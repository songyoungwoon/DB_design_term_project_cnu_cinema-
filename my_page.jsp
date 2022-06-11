<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>

<html>
<head lang="ko">
  <meta charset="utf-8">
  <title>Database SQL</title>
  <link rel="stylesheet" href="main/main.css">
</head>
<!-- 마이페이지 접속시, 기간이 지난 예매내역 관람내역으로 이동 -->
<%
  
%>

<body>
  <%@ include file="dbconn.jsp" %>
  <!-- 홈 버튼 -->
  <p>
    <button type='button' onclick="location.href='main/main.jsp';"><-</button>
    마이페이지
  </p>

  <!-- 예매내역 불러오기 시작 -->
  <table id="t1">
   <p>
     예매내역
     <%
     // 예매내역 불러오기
     ResultSet rs = null;
     Statement stmt = null;

     String id = (String)session.getAttribute("id");

     String sql = "select * from 예매내역 where 회원번호 = '"+id+"'";
     stmt = conn.createStatement();
     rs = stmt.executeQuery(sql);

     while(rs.next()){
       String 예매번호 = rs.getString("예매번호");
       String 성인예매매수 = rs.getString("성인예매매수");
       String 현금결제금액 = rs.getString("현금결제금액");
       String 포인트결제금액 = rs.getString("포인트결제금액");
       String 예매날짜 = rs.getString("예매날짜");
       String 청소년예매매수 = rs.getString("청소년예매매수");
       String 상영번호 = rs.getString("상영번호");
       String 영화이름 = null;

       String sql2 = "select 영화이름 from 상영정보 where 상영번호 = '"+상영번호+"'";
       Statement stmt2 = conn.createStatement();
       ResultSet rs2 = stmt2.executeQuery(sql2);
       while(rs2.next()){
         영화이름 = rs2.getString("영화이름");
       }

     %>
       <tr>
         <td><%=예매번호%></td>
         <td><%=영화이름%></td>
         <td><%=성인예매매수%></td>
         <td><%=청소년예매매수%></td>
         <td><%=예매날짜%></td>
         <td><%=현금결제금액%></td>
         <td><%=포인트결제금액%></td>
         <td>
           <form method="post" action="cancel.jsp">
            <input type="hidden" name="예매번호" value="<%=예매번호%>">
            <input type="submit" value="예매 취소">
           </form>
           </td>
       </tr>
     <%
      }
     %>
   </p>
  </table>
  <!-- 예매내역 불러오기 끝 -->

  <!-- 관람내역 불러오기 시작 -->
  <table id="t2">
   <p>
     관람내역
     <%
     // 관람내역 불러오기
     sql = "select * from 관람내역 where 회원번호 = '"+id+"'";
     stmt = conn.createStatement();
     rs = stmt.executeQuery(sql);

     while(rs.next()){
       String 관람번호 = rs.getString("관람번호");
       String 관람날짜 = rs.getString("관람날짜");
       String 성인예매매수 = rs.getString("성인예매매수");
       String 청소년예매매수 = rs.getString("청소년예매매수");
       String 영화이름 = rs.getString("영화이름");
       String 지점 = rs.getString("지점");
       String 상영관이름 = rs.getString("상영관이름");

     %>
       <tr>
         <td><%=영화이름%></td>
         <td><%=성인예매매수%></td>
         <td><%=청소년예매매수%></td>
         <td><%=지점%></td>
         <td><%=상영관이름%></td>
         <td><%=관람날짜%></td>
       </tr>
     <%
      }
     %>
   </p>
  </table>
  <!-- 관람내역 불러오기 끝 -->

  <!-- 취소내역 불러오기 시작 -->
  <table id="t3">
   <p>
     취소내역
     <%
     // 취소내역 불러오기
     sql = "select * from 취소내역 where 회원번호 = '"+id+"'";
     stmt = conn.createStatement();
     rs = stmt.executeQuery(sql);

     while(rs.next()){
       String 취소번호 = rs.getString("취소번호");
       String 취소매수 = rs.getString("취소매수");
       String 현금환불금액 = rs.getString("현금환불금액");
       String 포인트환불금액 = rs.getString("포인트환불금액");
       String 취소날짜 = rs.getString("취소날짜");
       String 영화이름 = rs.getString("영화이름");
       String 지점 = rs.getString("지점");
     %>
       <tr>
         <td><%=영화이름%></td>
         <td><%=취소매수%></td>
         <td><%=현금환불금액%></td>
         <td><%=포인트환불금액%></td>
         <td><%=지점%></td>
         <td><%=취소날짜%></td>
       </tr>
     <%
      }
     %>
   </p>
  </table>
  <!-- 취소내역 불러오기 끝 -->

</body>
</html>
