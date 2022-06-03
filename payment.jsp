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
  <p>결제</p>
    <%
    request.setCharacterEncoding("utf-8");

    // 로그인 여부 확인
    String id = (String)session.getAttribute("id");
    if (id == null){
        response.sendRedirect("login/login.html");
    }
    String 상영번호 = request.getParameter("상영번호");
    String 지점 = null;
    String 상영관이름 = null;
    String 상영관타입 = null;

    ResultSet rs = null;
    Statement stmt = null;

    String sql = "select 지점, 상영관이름 from 상영정보 where 상영번호= '"+상영번호+"'";
    stmt = conn.createStatement();
    rs = stmt.executeQuery(sql);
    while(rs.next()){
      지점 = rs.getString("지점");
      상영관이름 = rs.getString("상영관이름");
      sql = "select 상영관타입 from 상영관 where 지점 = '"+지점+"' and 상영관이름 = '"+상영관이름+"'";
      stmt = conn.createStatement();
      rs = stmt.executeQuery(sql);
      while(rs.next()){
        상영관타입 = rs.getString("상영관타입");
      }
    }
    %>
    <p><%=지점%> <%=상영관이름%> <%=상영관타입%> :
    <%
    if (상영관타입.equals("프리미엄관")){
      %>
      성인 15,000원, 청소년 13,000원</p>
      <%
    }
    else{
      %>
      성인 10,000원, 청소년 8,000원</p>
      <%
    }
    %>
    <form method="post" action="payment_check.jsp">
      <p>예매 매수(성인) : <input type="text" name="성인예매매수" required></p>
      <p>예매 매수(청소년) : <input type="text" name="청소년예매매수" required></p>
      <p>현금 : <input type="text" name="현금" required></p>
      <p>포인트 : <input type="text" name="포인트" required></p>
      <input type="hidden" name="상영번호" value="<%=상영번호%>" required>
      <input type="hidden" name="상영관타입" value="<%=상영관타입%>"required>
      <p><input type="submit" value="결제"> <input type="reset" value="초기화"></p>
    </form>
</body>
</html>
