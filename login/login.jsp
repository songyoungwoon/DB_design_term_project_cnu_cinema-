<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../dbconn.jsp" %>
<%
  // login
  request.setCharacterEncoding("utf-8");

  // id, password form data
  String id = request.getParameter("id");
  String pass = request.getParameter("pass");

  ResultSet rs = null;
  Statement stmt = null;

  // id에 해당하는 회원의 비밀번호를 조회
  String sql = "select 비밀번호 from 회원 where 회원번호= '"+id+"'";
  stmt = conn.createStatement();
  rs = stmt.executeQuery(sql);
  while(rs.next()){
    // match_pass : 조회한 비밀번호
    String match_pass = rs.getString("비밀번호");
    // form으로 받은 password와 조회한 비밀번호가 일치할 때,
    if (pass.equals(match_pass)){
      // 관리자 접속시 : 관리자 id는 1
      if(id.equals("1")){
        // 관리 페이지로 이동
        response.sendRedirect("../manager.jsp");
      }
      // 일반 회원 접속시
      else{
        // 세션 유지 및 성공 페이지
        session.setAttribute("id", id);
        session.setAttribute("pass", pass);
        response.sendRedirect("../main/main.jsp");
      }
    }
  }
  // conn 종료
  if(rs != null) rs.close();
  if(stmt != null) stmt.close();
  if(conn != null) conn.close();
%>
<script>
  // id, 비밀번호가 틀렸을 경우 알림
  alert("회원번호 또는 비밀번호가 잘못되었습니다.");
  history.back();
</script>
