<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>

<html>
<head lang="ko">
  <meta charset="utf-8">
  <title>Database SQL</title>
  <link rel="stylesheet" href="main/main.css">
</head>
<body>
  <%@ include file="dbconn.jsp" %>
  <!-- 홈 버튼 -->
  <p>
    <button type='button' onclick="location.href='main/main.jsp';"><-</button>
    상영정보
  </p>
    <%
    // 영화의 상영 정보를 조회하기 위한 jsp
    request.setCharacterEncoding("utf-8");

    String 영화이름 = request.getParameter("영화이름");
    String 개봉일 = request.getParameter("개봉일");
    String 감독 = request.getParameter("감독");
    String 장르 = request.getParameter("장르");
    String 총상영시간 = request.getParameter("총상영시간");
    String 관람등급 = request.getParameter("관람등급");
    String 지점 = request.getParameter("지점");
    String 날짜 = request.getParameter("날짜");
    %>

    <!-- 지점 및 날짜 선택 시작 : 지점 및 조회 날짜 선택 -->
    <p> 영화 : <%=영화이름%></p>
    <form method="post" action="ticketing.jsp">
     <input type="hidden" name="영화이름" value="<%=영화이름%>">
     <input type="hidden" name="개봉일" value="<%=개봉일%>">
     <input type="hidden" name="감독" value="<%=감독%>">
     <p> 지점 선택 : <select name="지점">
      <option value="선택" selected disabled>선택</option>
    <%
    ResultSet rs = null;
    Statement stmt = null;
    // 지점을 불러오기 위한 sql문
    String sql = "select distinct 지점 from 상영관";
    stmt = conn.createStatement();
    rs = stmt.executeQuery(sql);
    while(rs.next()){
      // 지점 하나씩 불러오기
      String select_지점 = rs.getString("지점");
    %>
      <!-- option에 각 지점 표시 -->
      <option value=<%=select_지점%>><%=select_지점%></option>
    <%
    }
    %>
     </select>
     <!-- 조회 날짜 선택 : 현재 날짜로부터 7일 이내의 날짜만 조회 가능 -->
     날짜 : <input type="date" id="select_Date" name="날짜" required>
     <input type="submit" value="검색"></p>
    </form>
    <!-- 지점 및 날짜 선택 끝 -->


    <!-- 상영관 불러오기 시작 -->
    <table>
      <tr>
        <th> 상영관 </th>
        <th> 상영시간 </th>
        <th> 예매자수 </th>
        <th> 총좌석수 </th>
        <th> 예매하기 </th>
      </tr>
    <%
    // 선택한 지점과 날짜의 영화 상영정보 불러오기
    if (지점 != null && 지점 != "선택" && 날짜 != null){
      out.println(지점);
      out.println(날짜);
      // 상영정보를 불러오기 위한 sql문
      sql = "select distinct 상영번호, 상영관이름, 상영날짜, 예매좌석수 from 상영정보 where 지점='"+지점+"' and 영화이름='"+영화이름+"' and  감독='"+감독+"' and to_date(to_char(상영날짜, 'yyyy-mm-dd'), 'yyyy-mm-dd') = to_date('"+날짜+"', 'yyyy-mm-dd') order by 상영관이름, 상영날짜";
      stmt = conn.createStatement();
      rs = stmt.executeQuery(sql);
      while(rs.next()){
        // 상영정보 하나씩 불러오기
        String 상영번호 = rs.getString("상영번호");
        String 상영관이름 = rs.getString("상영관이름");
        String 상영날짜 = rs.getString("상영날짜");
        String 예매좌석수 = rs.getString("예매좌석수");
        String 총좌석수 = "";
        // 총 좌석수를 불러오기 위한 sql문
        sql = "select 총좌석수 from 상영관 where 지점='"+지점+"' and 상영관이름='"+상영관이름+"'";
        stmt = conn.createStatement();
        ResultSet rs2 = stmt.executeQuery(sql);
        while(rs2.next()){
         총좌석수 = rs2.getString("총좌석수");
      }
      %>
      <!-- 상영정보 표시 -->
      <tr>
        <td><%=상영관이름%></td>
        <td><%=상영날짜%></td>
        <td><%=예매좌석수%></td>
        <td><%=총좌석수%></td>
        <%
        // 예매 가능 여부 확인
        int 예매가능좌석수 = Integer.parseInt(총좌석수) - Integer.parseInt(예매좌석수);
        // 예매가 가능할 때, 예매 버튼 활성화
        if (예매가능좌석수 > 0){
        %>
        <td>
          <form method="post" action="payment.jsp">
           <input type="hidden" name="상영번호" value="<%=상영번호%>">
           <input type="submit" value="예매">
          </form>
        </td>
        <%
        }
        // 예매가 불가능 할 때, 매진 표시
        else{
        %>
        <p>매진</p>
        <%
        }
        %>
      </tr>
      <%
      }
    }

    // conn 종료
    if(rs != null) rs.close();
    if(stmt != null) stmt.close();
    if(conn != null) conn.close();
    %>
    </table>
    <!-- 상영관 불러오기 끝 -->

    <!--현재 날짜로부터 7일 이내 영화만 예매 가능 -->
    <script>
      var now_utc = Date.now();
      var timeoff = new Date().getTimezoneOffset()*60000*16;
      var today = new Date(now_utc-timeoff).toISOString().split("T")[0];
      document.getElementById("select_Date").setAttribute("max", today);
    </script>
</body>
</html>
