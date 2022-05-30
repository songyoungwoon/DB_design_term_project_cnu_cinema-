<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>

<html>
<head lang="ko">
  <meta charset="utf-8">
  <title>Database SQL</title>
</head>
<body>
  <p>ticketing</p>
    <p>영화제목</p>

    <!-- 지점 선택 -->
    <select name="지점">
    <%
    ResultSet rs = null;
    Statement stmt = null;
    // 지점 불러오기
    String sql = "select employee_id, concat(first_name, concat(' ', last_name)) as name, email, salary, department_id from employees";
    stmt = conn.createStatement();
    rs = stmt.executeQuery(sql);
    while(rs.next()){
      // 하나씩 지점 불러오기
    %>
    <option value="">지점명</option>
    <%
          }
    %>
    </select>

    <!-- 상영관 선택 -->
    <select name="상영관">
      <%
      ResultSet rs = null;
      Statement stmt = null;
      // 지점에 대한 상영관 불러오기
      String sql = "select employee_id, concat(first_name, concat(' ', last_name)) as name, email, salary, department_id from employees";
      stmt = conn.createStatement();
      rs = stmt.executeQuery(sql);
      while(rs.next()){
        // 하나씩 상영관 불러오기
      %>
      <option value="">상영관</option>
      <%
            }
      %>
    </select>

    <%
    // 해당 지점 상영관 영화 정보 불러오기
    %>
    
</body>
</html>
