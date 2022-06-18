<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

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
    // 결제 정보를 입력하기 위한 jsp
    request.setCharacterEncoding("utf-8");

    // 로그인 여부 확인
    String id = (String)session.getAttribute("id");
    // 로그인 상태가 아닐시 로그인 페이지로 이동
    if (id == null){
        response.sendRedirect("login/login.html");
    }

    // form으로 전달받은 상영번호 data
    String 상영번호 = request.getParameter("상영번호");
    // 상영정보를 저장할 변수
    String 지점 = null;
    String 상영관이름 = null;
    String 상영관타입 = null;
    String 상영날짜 = null;

    ResultSet rs = null;
    Statement stmt = null;

    // 지점 및 상영관이름 조회 및 상영관타입 조회
    String sql = "select 지점, 상영관이름, to_char(상영날짜, 'yyyymmddhh24miss') as 상영날짜 from 상영정보 where 상영번호= '"+상영번호+"'";
    stmt = conn.createStatement();
    rs = stmt.executeQuery(sql);
    while(rs.next()){
      지점 = rs.getString("지점");
      상영관이름 = rs.getString("상영관이름");
      상영날짜 = rs.getString("상영날짜");

      // 예매 가능 시간 확인
      Date nowTime = new Date();
      SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmmss");
      String 현재시간 = sf.format(nowTime);
      // 연도, 월일, 시간 차이 계산
      int 연도차이 = Integer.parseInt(상영날짜.substring(0, 4)) - Integer.parseInt(현재시간.substring(0, 4));
      int 월일차이 = Integer.parseInt(상영날짜.substring(4, 8)) - Integer.parseInt(현재시간.substring(4, 8));
      int 시간차이 = Integer.parseInt(상영날짜.substring(8, 14)) - Integer.parseInt(현재시간.substring(8, 14));

      // 예매 가능 시간이 아닐 때,(상영 20분 전까지만 예매 가능)
      if(연도차이<0 || (연도차이==0 && 월일차이<0) || (연도차이==0 && 월일차이==0 && 시간차이<2000)){
          %>
          <script>
            // 예매 가능 시간 x 알림
            alert("예매가능시간이 아닙니다.");
            history.back();
          </script>
          <%
      }

      // 상영관 정보 조회 sql문
      sql = "select 상영관타입 from 상영관 where 지점 = '"+지점+"' and 상영관이름 = '"+상영관이름+"'";
      stmt = conn.createStatement();
      rs = stmt.executeQuery(sql);
      while(rs.next()){
        상영관타입 = rs.getString("상영관타입");
      }
    }
    %>
    <!-- 상영관 지점, 이름, 타입 표시 -->
    <p><%=지점%> <%=상영관이름%> <%=상영관타입%> :
    <%
    // 상영관에 따른 가격 표시 : 프리미엄관
    if (상영관타입.equals("프리미엄관")){
      %>
      성인 15,000원, 청소년 13,000원</p>
      <%
    }
    // 상영관에 다른 가격 표시 : 일반관
    else{
      %>
      성인 10,000원, 청소년 8,000원</p>
      <%
    }
    %>
    <!-- 결제정보 form으로 전송 -->
    <form method="post" action="payment_check.jsp">
      <p>예매 매수(성인) : <input type="text" name="성인예매매수" required></p>
      <p>예매 매수(청소년) : <input type="text" name="청소년예매매수" required></p>
      <p>현금 : <input type="text" name="현금" required></p>
      <p>포인트 : <input type="text" name="포인트" required>
        <%
        // 회원의 보유 포인트 조회
        sql = "select * from 회원 where 회원번호='"+id+"'";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(sql);
        while(rs.next()){
          // 잔여 포인트 표시
          out.println("잔여 포인트 : " + rs.getString("포인트"));
        }
        %>
      </p>
      <input type="hidden" name="상영번호" value="<%=상영번호%>" required>
      <input type="hidden" name="상영관타입" value="<%=상영관타입%>"required>
      <p><input type="submit" value="결제"> <input type="reset" value="초기화"></p>
    </form>
    <%
      // conn 종료
      if(rs != null) rs.close();
      if(stmt != null) stmt.close();
      if(conn != null) conn.close();
    %>
</body>
</html>
