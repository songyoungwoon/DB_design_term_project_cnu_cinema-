<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>

<%
  // oracle database connection
  Connection conn=null;
  String url ="jdbc:oracle:thin:@localhost:1521:orcl";
  String user ="hr";
  String password ="song1357";

  Class.forName("oracle.jdbc.driver.OracleDriver");
  conn = DriverManager.getConnection(url, user, password);
%>
