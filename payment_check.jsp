<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="dbconn.jsp" %>
<%
  request.setCharacterEncoding("utf-8");

  String id = (String)session.getAttribute("id");
  String 상영번호 = request.getParameter("상영번호");
  String 상영관타입 = request.getParameter("상영관타입");
  String 현금 = request.getParameter("현금");
  String 포인트 = request.getParameter("포인트");
  String 성인예매매수 = request.getParameter("성인예매매수");
  String 청소년예매매수 = request.getParameter("청소년예매매수");

  ResultSet rs = null;
  Statement stmt = null;

  // 포인트 잔액 확인
  String sql = "select 포인트 from 회원 where 회원번호= '"+id+"'";
  stmt = conn.createStatement();
  rs = stmt.executeQuery(sql);
  while(rs.next()){
    if (Integer.parseInt(포인트) > Integer.parseInt(rs.getString("포인트"))){
      %>
      <script>
        alert("포인트가 부족합니다.");
        history.back();
      </script>
      <%
    }
  }

  // 결제금액 계산
  int 결제금액 = 0;
  if (상영관타입.equals("프리미엄관")){
    결제금액 += 15000*Integer.parseInt(성인예매매수);
    결제금액 += 13000*Integer.parseInt(청소년예매매수);
  }
  else{
    결제금액 += 10000*Integer.parseInt(성인예매매수);
    결제금액 += 8000*Integer.parseInt(청소년예매매수);
  }
  결제금액 -= Integer.parseInt(포인트);

  // todo 예매 가능 매수 계산


  if (Integer.parseInt(현금) >= 결제금액){
      // 예매 완료
      Date nowTime = new Date();
      SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");

      sql = "INSERT INTO 예매내역 values (0, '"+성인예매매수+"', '"+결제금액+"', '"+포인트+"', TO_DATE('"+sf.format(nowTime)+"', 'yyyy-mm-dd'), '"+id+"', '"+상영번호+"', '"+청소년예매매수+"')";
      stmt = conn.createStatement();
      stmt.executeUpdate(sql);

      // 예매 내역 알림
      sql = "select * from 예매내역 where 회원번호 = '"+id+"' and 예매날짜 = TO_DATE('"+sf.format(nowTime)+"', 'yyyy-mm-dd')";
      stmt = conn.createStatement();
      rs = stmt.executeQuery(sql);
      while(rs.next()){
        String 예매번호 = rs.getString("예매번호");
        String 예매날짜 = rs.getString("예매날짜");
        성인예매매수 = rs.getString("성인예매매수");
        청소년예매매수 = rs.getString("청소년예매매수");
        %>
        <script>
          alert("<%=예매번호%>번\n <%=예매날짜%>\n 성인 : <%=성인예매매수%>명\n 청소년 : <%=청소년예매매수%>명");
          location.href="main/main.jsp";
        </script>
        <%
      }
  }
  else{
    %>
    <script>
      alert("결제금액이 부족합니다.");
      history.back();
    </script>
    <%
  }
%>
