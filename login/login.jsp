<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>
<%
  request.setCharacterEncoding("utf-8");

  String id = request.getParameter("id");
  String pass = request.getParameter("pass");

  ResultSet rs = null;
  Statement stmt = null;

  String sql = "select 비밀번호 from 회원 where 회원번호= '"+id+"'";
  stmt = conn.createStatement();
  rs = stmt.executeQuery(sql);
  while(rs.next()){
  String match_pass = rs.getString("비밀번호");

  if (pass.equals(match_pass)){
    //세션 유지 및 성공 페이지
    session.setAttribute("id", id);
    session.setAttribute("pass", pass);
    response.sendRedirect("../main/main.jsp");
    }
  }
%>
<script>
  alert("회원번호 또는 비밀번호가 잘못되었습니다.");
  history.back();
</script>
