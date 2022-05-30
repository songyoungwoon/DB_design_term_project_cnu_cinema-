<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>

<html>
<head lang="ko">
  <meta charset="utf-8">
  <title>Database SQL</title>
</head>
<body>
  <p>cnu cinema</p>
   <p>
     상영작품
     <select name="sort">
       <option value="">개봉일순</option>
       <option value="학생">예매순</option>
     </select>
     <%
     // 상영작품 불러오기
     %>
   </p>
   <p>
     상영예정작
     <select name="sort">
       <option value="">개봉일순</option>
       <option value="">예매순</option>
     </select>
     <%
     // 상영예정작 불러오기
     %>
   </p>
</body>
</html>
