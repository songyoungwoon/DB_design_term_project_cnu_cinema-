<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<html>
<head lang="ko">
  <meta charset="utf-8">
  <title>Database SQL</title>
  <link rel="stylesheet" href="main.css">
</head>
<body>
  <%@ include file="../dbconn.jsp" %>
  <!-- 메인 페이지 : 상영중인 영화정보, 상영예정인 영화정보 표시 -->
  <p>cnu cinema</p>
  <!-- 마이페이지 이동, 로그아웃 버튼 생성 -->
  <p>
      <button type='button' onclick="location.href='../my_page.jsp';">마이페이지</button>
      <button type='button' onclick="location.href='../login/login.html';">로그아웃</button>
  </p>
  <!-- 상영작품 불러오기 시작 -->
  <table id="t1">
    <tr>
      <th> 영화이름 </th>
      <th> 개봉일 </th>
      <th> 감독 </th>
      <th> 출연자 </th>
      <th> 장르 </th>
      <th> 총상영시간 </th>
      <th> 관람등급 </th>
      <th> 현재 예매자수 </th>
      <th> 누적 관람객수 </th>
      <th> 상영정보 </th>
    </tr>
   <p>
     상영작품
     <!-- post 방식으로 테이블 값을 전달, 해당 영화에 대한 상영정보 페이지로 이동 -->
     <form method="post" action="main.jsp">
       <!-- 정렬 option 선택 -->
       <select name="sort1">
         <option value="개봉일">개봉일순</option>
         <option value="예매수">예매순</option>
       </select>
       <input type="submit" value="정렬">
     </form>
     <%
     request.setCharacterEncoding("utf-8");

     // 상영작품 및 예정작의 정렬을 위한 변수
     String 상영작품정렬 = request.getParameter("sort1");
     String 상영예정작품정렬 = request.getParameter("sort2");

     ResultSet rs = null;
     ResultSet rs2 = null;
     Statement stmt = null;

     // 현재 시간을 관리하기 위한 변수
     Date nowTime = new Date();
     SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");

     // 상영작품을 불러오기 위한 sql문 : 예매자수, 누적관객수 포함
     String sql = "select m.영화이름, to_char(m.개봉일, 'yyyy-mm-dd') as 개봉일, m.감독, m.장르, m.총상영시간, m.관람등급, nvl((select sum(예매좌석수) from 상영정보 where 영화이름 = m.영화이름 group by 영화이름, 개봉일, 감독), 0) as 예매수, nvl((select sum(성인예매매수)+sum(청소년예매매수) from 관람내역 where 영화이름 = m.영화이름 group by 영화이름, 개봉일, 감독), 0) as 누적관객수 from 영화 m ";
     sql += "where 개봉일 + 10 > TO_DATE('"+sf.format(nowTime)+"', 'yyyy-mm-dd') and 개봉일 <= TO_DATE('"+sf.format(nowTime)+"', 'yyyy-mm-dd') ";

     // 상영작품 정렬을 위한 sql문
     if(상영작품정렬 != null){
       // 정렬 기준이 예매수일 경우,
       if(상영작품정렬.equals("예매수")){
         sql += " order by "+상영작품정렬+" desc"; // 예매수 내림차순 정렬
       }
       // 정렬 기준이 개봉일일 경우,
       else{
         sql += " order by "+상영작품정렬+""; // 개봉일 오름차순 정렬
       }
     }
     stmt = conn.createStatement();
     rs = stmt.executeQuery(sql);

     // 상영작품 하나씩 받아오기
     while(rs.next()){
       String 영화이름 = rs.getString("영화이름");
       String 개봉일 = rs.getString("개봉일");
       String 감독 = rs.getString("감독");
       String 장르 = rs.getString("장르");
       String 총상영시간 = rs.getString("총상영시간");
       String 관람등급 = rs.getString("관람등급");
       String 예매수 = rs.getString("예매수");
       String 누적관객수 = rs.getString("누적관객수");
       String 출연자 = ""; // 출연자 정보를 저장할 변수

       // 영화출연자 불러오기 위한 sql문
       sql = "select 출연자이름 from 영화출연자 where 영화이름='"+영화이름+"' and 개봉일='"+개봉일+"' and 감독='"+감독+"'";
       stmt = conn.createStatement();
       rs2 = stmt.executeQuery(sql);
       // 출연자 불러오기 : 출연자를 한명씩 불러와 string에 더해줌
       while(rs2.next()){
         // 출연자 하나씩 연결
         출연자 += rs2.getString("출연자이름")+". ";
       }
     %>
       <tr>
         <td><%=영화이름%></td>
         <td><%=개봉일%></td>
         <td><%=감독%></td>
         <td><%=출연자%></td>
         <td><%=장르%></td>
         <td><%=총상영시간%></td>
         <td><%=관람등급%></td>
         <td><%=예매수%></td>
         <td><%=누적관객수%></td>
         <td>
           <!-- 상영정보 버튼을 누르면, 영화에 대한 상영정보 조회 페이지로 이동 -->
           <form method="post" action="../ticketing.jsp">
            <input type="hidden" name="영화이름" value="<%=영화이름%>">
            <input type="hidden" name="개봉일" value="<%=개봉일%>">
            <input type="hidden" name="감독" value="<%=감독%>">
            <input type="submit" value="상영정보">
           </form>
           </td>
       </tr>
     <%
      }
     %>
   </p>
  </table>
  <!-- 상영작품 불러오기 끝 -->

  <!-- 상영예정작 불러오기 시작 -->
  <table id="t2">
    <tr>
      <th> 영화이름 </th>
      <th> 개봉일 </th>
      <th> 감독 </th>
      <th> 출연자 </th>
      <th> 장르 </th>
      <th> 총상영시간 </th>
      <th> 관람등급 </th>
      <th> 현재 예매자수 </th>
      <th> 상영정보 </th>
    </tr>
   <p>
     상영예정작
     <!-- post 방식으로 테이블 값을 전달, 해당 영화에 대한 상영정보 페이지로 이동 -->
     <form method="post" action="main.jsp">
       <!-- 정렬 option 선택 -->
       <select name="sort2">
         <option value="개봉일">개봉일순</option>
         <option value="예매수">예매순</option>
       </select>
       <input type="submit" value="정렬">
     </form>
     <%

     // 상영 예정작을 불러오기 위한 sql문 : 예매자수 포함
     sql = "select m.영화이름, to_char(m.개봉일, 'yyyy-mm-dd') as 개봉일, m.감독, m.장르, m.총상영시간, m.관람등급, nvl((select sum(예매좌석수) from 상영정보 where 영화이름 = m.영화이름 group by 영화이름, 개봉일, 감독), 0) as 예매수, nvl((select sum(성인예매매수)+sum(청소년예매매수) from 관람내역 where 영화이름 = m.영화이름 group by 영화이름, 개봉일, 감독), 0) as 누적관객수 from 영화 m where 개봉일 > TO_DATE('"+sf.format(nowTime)+"', 'yyyy-mm-dd')";
     if(상영예정작품정렬 != null){
       // 정렬 기준이 예매수일 경우
       if(상영예정작품정렬.equals("예매수")){
         sql += " order by "+상영예정작품정렬+" desc"; // 예매수 내림차순 정렬
       }
       // 정렬 기준이 개봉일일 경우
       else{
         sql += " order by "+상영예정작품정렬+""; // 개봉일 오름차순 정렬
       }
     }
     stmt = conn.createStatement();
     rs = stmt.executeQuery(sql);

     // 상영예정작 하나씩
     while(rs.next()){
       String 영화이름 = rs.getString("영화이름");
       String 개봉일 = rs.getString("개봉일");
       String 감독 = rs.getString("감독");
       String 장르 = rs.getString("장르");
       String 총상영시간 = rs.getString("총상영시간");
       String 관람등급 = rs.getString("관람등급");
       String 예매수 = rs.getString("예매수");
       String 출연자 = ""; // 출연자를 저장할 변수

       // 영화출연자 불러오기
       sql = "select 출연자이름 from 영화출연자 where 영화이름='"+영화이름+"' and 개봉일='"+개봉일+"' and 감독='"+감독+"'";
       stmt = conn.createStatement();
       rs2 = stmt.executeQuery(sql);
       while(rs2.next()){
         // 출연자 하나씩 연결
         출연자 += rs2.getString("출연자이름")+". ";
       }
     %>
       <tr>
         <td><%=영화이름%></td>
         <td><%=개봉일%></td>
         <td><%=감독%></td>
         <td><%=출연자%></td>
         <td><%=장르%></td>
         <td><%=총상영시간%></td>
         <td><%=관람등급%></td>
         <td><%=예매수%></td>
         <td>
           <!-- 상영정보 버튼을 누르면, 영화에 대한 상영정보 조회 페이지로 이동 -->
           <form method="post" action="../ticketing.jsp">
            <input type="hidden" name="영화이름" value="<%=영화이름%>">
            <input type="hidden" name="개봉일" value="<%=개봉일%>">
            <input type="hidden" name="감독" value="<%=감독%>">
            <input type="submit" value="상영정보">
           </form>
           </td>
       </tr>
     <%
      }
     %>
   </p>
  </table>
  <!-- 상영예정작 불러오기 끝 -->
  <%
  if(rs != null) rs.close();
  if(rs2 != null) rs2.close();
  if(stmt != null) stmt.close();
  if(conn != null) conn.close();
  %>

</body>
</html>
