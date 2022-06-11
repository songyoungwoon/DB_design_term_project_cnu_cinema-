<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>

<html>
<head lang="ko">
  <meta charset="utf-8">
  <title>Database SQL</title>
  <link rel="stylesheet" href="main.css">
</head>
<body>
  <%@ include file="../dbconn.jsp" %>
  <p>cnu cinema</p>
  <!-- 상단바 -->
  <p>
      <button type='button' onclick="location.href='../my_page.jsp';">마이페이지</button>
      <button type='button' onclick="location.href='../login/login.html';">로그아웃</button>
  </p>
  <!-- 상영작품 불러오기 시작 -->
  <table id="t1">
   <p>
     상영작품
     <select name="sort">
       <option value="">개봉일순</option>
       <option value="">예매순</option>
     </select>
     <%
     // 상영작품 불러오기
     ResultSet rs = null;
     Statement stmt = null;

     String sql = "select 영화이름, 개봉일, 감독, 장르, 총상영시간, 관람등급 from 영화";
     stmt = conn.createStatement();
     rs = stmt.executeQuery(sql);

     while(rs.next()){
       String 영화이름 = rs.getString("영화이름");
       String 개봉일 = rs.getString("개봉일");
       String 감독 = rs.getString("감독");
       String 장르 = rs.getString("장르");
       String 총상영시간 = rs.getString("총상영시간");
       String 관람등급 = rs.getString("관람등급");
     %>
       <tr>
         <td><%=영화이름%></td>
         <td><%=개봉일%></td>
         <td><%=감독%></td>
         <td><%=장르%></td>
         <td><%=총상영시간%></td>
         <td><%=관람등급%></td>
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
     <select name="sort">
       <option value="">개봉일순</option>
       <option value="">예매순</option>
     </select>
     <%
     // 상영예정작 불러오기

     sql = "select 영화이름, 개봉일, 감독, 장르, 총상영시간, 관람등급 from 영화";
     stmt = conn.createStatement();
     rs = stmt.executeQuery(sql);

     while(rs.next()){
       String 영화이름 = rs.getString("영화이름");
       String 개봉일 = rs.getString("개봉일");
       String 감독 = rs.getString("감독");
       String 장르 = rs.getString("장르");
       String 총상영시간 = rs.getString("총상영시간");
       String 관람등급 = rs.getString("관람등급");
     %>
       <tr onclick="location.href='../ticketing.jsp'">
         <td><%=영화이름%></td>
         <td><%=개봉일%></td>
         <td><%=감독%></td>
         <td><%=장르%></td>
         <td><%=총상영시간%></td>
         <td><%=관람등급%></td>
       </tr>
     <%
      }
     %>
   </p>
  </table>
  <!-- 상영예정작 불러오기 끝 -->

</body>
</html>
