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
    마이페이지
  </p>

  <%
    // my_page를 위한 jsp
    request.setCharacterEncoding("utf-8");

    String id = (String)session.getAttribute("id");

    ResultSet rs = null;
    Statement stmt = null;

    // 구간별 조회를 위한 조회 시작 및 종료 날짜 변수 초기화
    String 예매내역시작날짜 = request.getParameter("예매내역시작날짜");
    String 예매내역종료날짜 = request.getParameter("예매내역종료날짜");
    String 관람내역시작날짜 = request.getParameter("관람내역시작날짜");
    String 관람내역종료날짜 = request.getParameter("관람내역종료날짜");
    String 취소내역시작날짜 = request.getParameter("취소내역시작날짜");
    String 취소내역종료날짜 = request.getParameter("취소내역종료날짜");

    // 보유 포인트 조회
    String sql = "select * from 회원 where 회원번호='"+id+"'";
    stmt = conn.createStatement();
    rs = stmt.executeQuery(sql);
    while(rs.next()){
      // 보유 포인트 display
      out.println("보유 포인트 : " + rs.getString("포인트"));
    }
  %>
  <!-- 예매내역 불러오기 시작 -->
  <table id="t1">
    <p>예매내역
    <!-- 조회 시작날짜 및 종료날짜 전송 -->
    <form method="post" action="my_page.jsp">
      시작날짜 : <input type="date" name="예매내역시작날짜" required>
      종료날짜 : <input type="date" name="예매내역종료날짜" required>
      <input type="submit" value="검색">
    </form>
    </p>
    <tr>
      <th> 예매번호 </th>
      <th> 영화이름 </th>
      <th> 성인예매매수 </th>
      <th> 청소년예매매수 </th>
      <th> 지점 </th>
      <th> 상영관 </th>
      <th> 상영시간 </th>
      <th> 예매날짜 </th>
      <th> 현금결제금액 </th>
      <th> 포인트결제금액 </th>
      <th> 예매취소하기 </th>
    </tr>
     <%
     // 예매내역 불러오기
     sql = "select * from 예매내역 where 회원번호 = '"+id+"'";
     // 조회 날짜에 따른 쿼리문 추가
     if(예매내역시작날짜 != null && 예매내역종료날짜 != null){
       sql += " and 예매날짜 between to_date('"+예매내역시작날짜+"', 'yyyy-mm-dd') and to_date('"+예매내역종료날짜+"', 'yyyy-mm-dd') + 1";
     }
     // 예매내역 내림차순 정렬
     sql += " order by 예매날짜 desc";
     stmt = conn.createStatement();
     rs = stmt.executeQuery(sql);
     // 예매내역 하나씩 불러오기
     while(rs.next()){
       String 예매번호 = rs.getString("예매번호");
       String 성인예매매수 = rs.getString("성인예매매수");
       String 현금결제금액 = rs.getString("현금결제금액");
       String 포인트결제금액 = rs.getString("포인트결제금액");
       String 예매날짜 = rs.getString("예매날짜");
       String 청소년예매매수 = rs.getString("청소년예매매수");
       String 상영번호 = rs.getString("상영번호");
       String 영화이름 = null;
       String 지점 = null;
       String 상영관이름 = null;
       String 상영날짜 = null;

       // 예매내역에 대한 상영정보를 얻기 위한 sql문
       String sql2 = "select 영화이름, 지점, 상영관이름, 상영날짜 from 상영정보 where 상영번호 = '"+상영번호+"'";
       Statement stmt2 = conn.createStatement();
       ResultSet rs2 = stmt2.executeQuery(sql2);
       // 상영정보 저장
       while(rs2.next()){
         영화이름 = rs2.getString("영화이름");
         지점 = rs2.getString("지점");
         상영관이름 = rs2.getString("상영관이름");
         상영날짜 = rs2.getString("상영날짜");
       }
     %>
       <!-- 예매 정보 표시 -->
       <tr>
         <td><%=예매번호%></td>
         <td><%=영화이름%></td>
         <td><%=성인예매매수%></td>
         <td><%=청소년예매매수%></td>
         <td><%=지점%></td>
         <td><%=상영관이름%></td>
         <td><%=상영날짜%></td>
         <td><%=예매날짜%></td>
         <td><%=현금결제금액%></td>
         <td><%=포인트결제금액%></td>
         <td>
           <!-- 예매취소 버튼 클릭시 cancel.jsp 실행 -->
           <form method="post" action="cancel.jsp">
            <input type="hidden" name="예매번호" value="<%=예매번호%>">
            <input type="submit" value="예매 취소">
           </form>
           </td>
       </tr>
     <%
      }
     %>
  </table>
  <!-- 예매내역 불러오기 끝 -->


  <!-- 관람내역 불러오기 시작 -->
  <table id="t2">
    <p>관람내역
    <!-- 조회 시작날짜 및 종료날짜 전송 -->
    <form method="post" action="my_page.jsp">
      시작날짜 : <input type="date" name="관람내역시작날짜" required>
      종료날짜 : <input type="date" name="관람내역종료날짜" required>
      <input type="submit" value="검색">
    </form>
    </p>
    <tr>
      <th> 영화이름 </th>
      <th> 성인예매매수 </th>
      <th> 청소년예매매수 </th>
      <th> 지점 </th>
      <th> 상영관이름 </th>
      <th> 관람날짜 </th>
    </tr>
     <%
     // 관람내역 불러오기
     sql = "select * from 관람내역 where 회원번호 = '"+id+"'";
     // 구간별 조회를 위한 조회 날짜에 따른 쿼리문 추가
     if(관람내역시작날짜 != null && 관람내역종료날짜 != null){
       sql += " and 관람날짜 between to_date('"+관람내역시작날짜+"', 'yyyy-mm-dd') and to_date('"+관람내역종료날짜+"', 'yyyy-mm-dd') + 1";
     }
     // 관람날짜 내림차순 정렬
     sql += " order by 관람날짜 desc";
     stmt = conn.createStatement();
     rs = stmt.executeQuery(sql);
     // 관람내역 하나씩 불러오기
     while(rs.next()){
       String 관람번호 = rs.getString("관람번호");
       String 관람날짜 = rs.getString("관람날짜");
       String 성인예매매수 = rs.getString("성인예매매수");
       String 청소년예매매수 = rs.getString("청소년예매매수");
       String 영화이름 = rs.getString("영화이름");
       String 지점 = rs.getString("지점");
       String 상영관이름 = rs.getString("상영관이름");
     %>
       <!-- 관람내역 표시 -->
       <tr>
         <td><%=영화이름%></td>
         <td><%=성인예매매수%></td>
         <td><%=청소년예매매수%></td>
         <td><%=지점%></td>
         <td><%=상영관이름%></td>
         <td><%=관람날짜%></td>
       </tr>
     <%
      }
     %>
  </table>
  <!-- 관람내역 불러오기 끝 -->


  <!-- 취소내역 불러오기 시작 -->
  <table id="t3">
    <p>취소내역
    <!-- 조회 시작날짜 및 종료날짜 전송 -->
    <form method="post" action="my_page.jsp">
      시작날짜 : <input type="date" name="취소내역시작날짜" required>
      종료날짜 : <input type="date" name="취소내역종료날짜" required>
      <input type="submit" value="검색">
    </form>
    </p>
    <tr>
      <th> 영화이름 </th>
      <th> 취소매수 </th>
      <th> 현금환불금액 </th>
      <th> 포인트환불금액 </th>
      <th> 지점 </th>
      <th> 취소날짜 </th>
    </tr>
     <%
     // 취소내역 불러오기
     sql = "select * from 취소내역 where 회원번호 = '"+id+"'";
     // 구간별 조회를 위한 조회 날짜에 따른 쿼리문 추가
     if(취소내역시작날짜 != null && 취소내역종료날짜 != null){
       sql += " and 취소날짜 between to_date('"+취소내역시작날짜+"', 'yyyy-mm-dd') and to_date('"+취소내역종료날짜+"', 'yyyy-mm-dd') + 1";
     }
     // 취소날짜 내림차순 정렬
     sql += " order by 취소날짜 desc";
     stmt = conn.createStatement();
     rs = stmt.executeQuery(sql);
     // 취소내역 하나씩 불러오기
     while(rs.next()){
       String 취소번호 = rs.getString("취소번호");
       String 취소매수 = rs.getString("취소매수");
       String 현금환불금액 = rs.getString("현금환불금액");
       String 포인트환불금액 = rs.getString("포인트환불금액");
       String 취소날짜 = rs.getString("취소날짜");
       String 영화이름 = rs.getString("영화이름");
       String 지점 = rs.getString("지점");
     %>
       <!-- 취소내역 표시 -->
       <tr>
         <td><%=영화이름%></td>
         <td><%=취소매수%></td>
         <td><%=현금환불금액%></td>
         <td><%=포인트환불금액%></td>
         <td><%=지점%></td>
         <td><%=취소날짜%></td>
       </tr>
     <%
      }

      // conn 종료
      if(rs != null) rs.close();
      if(stmt != null) stmt.close();
      if(conn != null) conn.close();
     %>
  </table>
  <!-- 취소내역 불러오기 끝 -->
</body>
</html>
