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
  <p>ticketing</p>
    <%
    request.setCharacterEncoding("utf-8");

    String 영화이름 = request.getParameter("영화이름");
    String 개봉일 = request.getParameter("개봉일");
    String 감독 = request.getParameter("감독");
    String 장르 = request.getParameter("장르");
    String 총상영시간 = request.getParameter("총상영시간");
    String 관람등급 = request.getParameter("관람등급");
    String 지점 = request.getParameter("지점");
    %>

    <!-- 지점 선택 시작 -->
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
    // 지점 불러오기
    String sql = "select distinct 지점 from 상영관";
    stmt = conn.createStatement();
    rs = stmt.executeQuery(sql);
    while(rs.next()){
      // 지점 하나씩 불러오기
      String select_지점 = rs.getString("지점");
    %>
      <option value=<%=select_지점%>><%=select_지점%></option>
    <%
    }
    %>
     </select>
     <input type="submit" value="검색"></p>
    </form>
    <!-- 지점 선택 끝 -->

    <!-- 상영관 불러오기 시작 -->
    <table>
    <%
    // 해당 지점 영화 상영관 불러오기
    if (지점 != null && 지점 != "선택"){
      out.println(지점);
      sql = "select distinct 상영번호, 상영관이름, 상영날짜, 예매좌석수 from 상영정보 where 지점='"+지점+"' and 영화이름='"+영화이름+"' and  감독='"+감독+"'";
      stmt = conn.createStatement();
      rs = stmt.executeQuery(sql);
      while(rs.next()){
        // 상영정보 하나씩 불러오기
        String 상영번호 = rs.getString("상영번호");
        String 상영관이름 = rs.getString("상영관이름");
        String 상영날짜 = rs.getString("상영날짜");
        String 예매좌석수 = rs.getString("예매좌석수");
        String 총좌석수 = "";
        String sql2 = "select 총좌석수 from 상영관 where 지점='"+지점+"' and 상영관이름='"+상영관이름+"'";
        Statement stmt2 = conn.createStatement();
        ResultSet rs2 = stmt2.executeQuery(sql2);
        while(rs2.next()){
         총좌석수 = rs2.getString("총좌석수");
      }
      %>
      <tr>
        <td><%=상영관이름%></td>
        <td><%=상영날짜%></td>
        <td><%=예매좌석수%></td>
        <td><%=총좌석수%></td>
        <%
        int 예매가능좌석수 = Integer.parseInt(총좌석수) - Integer.parseInt(예매좌석수);
        if (예매가능좌석수 > 0){
        %>
        <td>
          <form method="post" action="payment.jsp">
           <input type="hidden" name="영화이름" value="<%=영화이름%>">
           <input type="hidden" name="개봉일" value="<%=개봉일%>">
           <input type="hidden" name="감독" value="<%=감독%>">
           <input type="hidden" name="상영번호" value="<%=상영번호%>">
           <input type="hidden" name="예매가능좌석수" value="<%=예매가능좌석수%>">
           <input type="submit" value="예매">
          </form>
        </td>
        <%
        }
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
    %>
    </table>
    <!-- 상영관 불러오기 끝 -->

    <script>
      var selected = "";
      function myFunction(str) {
        alert(str + " 을 선택하였습니다.");
        selected = str;
      }
    </script>

</body>
</html>
