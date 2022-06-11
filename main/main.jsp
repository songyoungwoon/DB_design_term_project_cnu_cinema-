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
  <p>cnu cinema</p>
  <!-- 마이페이지, 로그아웃 버튼 -->
  <p>
      <button type='button' onclick="location.href='../my_page.jsp';">마이페이지</button>
      <button type='button' onclick="location.href='../login/login.html';">로그아웃</button>
  </p>
  <!-- 상영작품 불러오기 시작 -->
  <table id="t1">
   <p>
     상영작품
     <form method="post" action="main.jsp">
       <select name="sort1">
         <option value="개봉일">개봉일순</option>
         <option value="예매수">예매순</option>
       </select>
       <input type="submit" value="정렬">
     </form>
     <%
     request.setCharacterEncoding("utf-8");

     String 상영작품정렬 = request.getParameter("sort1");
     String 상영예정작품정렬 = request.getParameter("sort2");

     // 상영작품 불러오기
     ResultSet rs = null;
     Statement stmt = null;

     Date nowTime = new Date();
     SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");


     String sql = "select m.영화이름, to_char(m.개봉일, 'yyyy-mm-dd') as 개봉일, m.감독, m.장르, m.총상영시간, m.관람등급, nvl((select sum(예매좌석수) from 상영정보 where 영화이름 = m.영화이름 group by 영화이름, 개봉일, 감독), 0) as 예매수, nvl((select sum(성인예매매수)+sum(청소년예매매수) from 관람내역 where 영화이름 = m.영화이름 group by 영화이름, 개봉일, 감독), 0) as 누적관객수 from 영화 m where 개봉일 + 10 > TO_DATE('"+sf.format(nowTime)+"', 'yyyy-mm-dd') and 개봉일 < TO_DATE('"+sf.format(nowTime)+"', 'yyyy-mm-dd') ";
     if(상영작품정렬 != null){
       sql += " order by '"+상영작품정렬+"'";
     }
     stmt = conn.createStatement();
     rs = stmt.executeQuery(sql);

     while(rs.next()){
       String 영화이름 = rs.getString("영화이름");
       String 개봉일 = rs.getString("개봉일");
       String 감독 = rs.getString("감독");
       String 장르 = rs.getString("장르");
       String 총상영시간 = rs.getString("총상영시간");
       String 관람등급 = rs.getString("관람등급");
       String 예매수 = rs.getString("예매수");
       String 누적관객수 = rs.getString("누적관객수");
     %>
       <tr>
         <td><%=영화이름%></td>
         <td><%=개봉일%></td>
         <td><%=감독%></td>
         <td><%=장르%></td>
         <td><%=총상영시간%></td>
         <td><%=관람등급%></td>
         <td><%=예매수%></td>
         <td><%=누적관객수%></td>
         <td>
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
   <p>
     상영예정작
     <form method="post" action="main.jsp">
       <select name="sort2">
         <option value="개봉일">개봉일순</option>
         <option value="예매수">예매순</option>
       </select>
       <input type="submit" value="정렬">
     </form>
     <%
     // 상영예정작 불러오기

     sql = "select m.영화이름, to_char(m.개봉일, 'yyyy-mm-dd') as 개봉일, m.감독, m.장르, m.총상영시간, m.관람등급, nvl((select sum(예매좌석수) from 상영정보 where 영화이름 = m.영화이름 group by 영화이름, 개봉일, 감독), 0) as 예매수, nvl((select sum(성인예매매수)+sum(청소년예매매수) from 관람내역 where 영화이름 = m.영화이름 group by 영화이름, 개봉일, 감독), 0) as 누적관객수 from 영화 m where 개봉일 > TO_DATE('"+sf.format(nowTime)+"', 'yyyy-mm-dd')";
     if(상영예정작품정렬 != null){
       sql += " order by '"+상영예정작품정렬+"'";
     }
     stmt = conn.createStatement();
     rs = stmt.executeQuery(sql);

     while(rs.next()){
       String 영화이름 = rs.getString("영화이름");
       String 개봉일 = rs.getString("개봉일");
       String 감독 = rs.getString("감독");
       String 장르 = rs.getString("장르");
       String 총상영시간 = rs.getString("총상영시간");
       String 관람등급 = rs.getString("관람등급");
       String 예매수 = rs.getString("예매수");
       String 누적관객수 = rs.getString("누적관객수");
     %>
       <tr>
         <td><%=영화이름%></td>
         <td><%=개봉일%></td>
         <td><%=감독%></td>
         <td><%=장르%></td>
         <td><%=총상영시간%></td>
         <td><%=관람등급%></td>
         <td><%=예매수%></td>
         <td><%=누적관객수%></td>
         <td>
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

</body>
</html>
