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
  <p>payment</p>
    <%
    request.setCharacterEncoding("utf-8");
    String 상영번호 = request.getParameter("상영번호");
    out.println(상영번호);
    %>
    <form method="post" action="insert01.jsp">
      <p>현금 : <input type="text" name="현금" required></p>
      <p>포인트 : <input type="text" name="포인트" required></p>
      <p>예매 매수 : <input type="text" name="예매매수" required></p>
      <p><input type="submit" value="결제"> <input type="reset" value="초기화"></p>
    </form>
</body>
</html>
