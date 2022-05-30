<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconn.jsp" %>
<%
  request.setCharacterEncoding("utf-8");

  String email = request.getParameter("email");
  String pass = request.getParameter("pass");

  Statement stmt = null;

  String sql = "select 비밀번호 from 회원 where 이메일 = '"+email+"'";
  stmt = conn.createStatement();
  rs = stmt.executeQuery(sql);
  String match_pass = rs.getString("비밀번호");

  if (stmt != null) stmt.close();
  if (conn != null) conn.close();

  if (pass == match_pass){
    
  }
  else{

  }
%>
