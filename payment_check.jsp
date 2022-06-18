<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="dbconn.jsp" %>
<%
  // 결제 조건 확인을 위한 jsp
  request.setCharacterEncoding("utf-8");

  // id 세션 획득
  String id = (String)session.getAttribute("id");
  // 결제정보 form으로 획득
  String 상영번호 = request.getParameter("상영번호");
  String 상영관타입 = request.getParameter("상영관타입");
  String 현금 = request.getParameter("현금");
  String 포인트 = request.getParameter("포인트");
  String 성인예매매수 = request.getParameter("성인예매매수");
  String 청소년예매매수 = request.getParameter("청소년예매매수");

  ResultSet rs = null;
  Statement stmt = null;

  // 회원의 포인트 잔액 확인
  String sql = "select 포인트 from 회원 where 회원번호= '"+id+"'";
  stmt = conn.createStatement();
  rs = stmt.executeQuery(sql);
  String 잔여포인트 = "";
  while(rs.next()){
    잔여포인트 = rs.getString("포인트");
    // 포인트가 부족할 때, 결제 불가
    if (Integer.parseInt(포인트) > Integer.parseInt(잔여포인트)){
      %>
      <script>
        // 포인트 부족 알림
        alert("포인트가 부족합니다.");
        history.back();
      </script>
      <%
    }
  }

  // 포인트가 있을 때, 남은 결제 금액 계산
  if (Integer.parseInt(포인트) <= Integer.parseInt(잔여포인트)){
    // 결제금액 계산
    int 결제금액 = 0;
    // 프리미엄관일 경우 가격
    if (상영관타입.equals("프리미엄관")){
      결제금액 += 15000*Integer.parseInt(성인예매매수);
      결제금액 += 13000*Integer.parseInt(청소년예매매수);
    }
    // 일반관일 경우 가격
    else{
      결제금액 += 10000*Integer.parseInt(성인예매매수);
      결제금액 += 8000*Integer.parseInt(청소년예매매수);
    }
    // 결제금액에서 포인트만큼 차감
    결제금액 -= Integer.parseInt(포인트);
    if(결제금액 < 0) 결제금액 = 0;

    // 결제시점 예매 가능 여부 확인 (좌석수)
    int 총예매매수 = Integer.parseInt(성인예매매수) + Integer.parseInt(청소년예매매수);
    int 예매가능매수 = 0;
    String 예매좌석수 = "";
    String 총좌석수 = "";
    sql = "select s.예매좌석수, (select 총좌석수 from 상영관 where 지점 = s.지점 and 상영관이름 = s.상영관이름) as 총좌석수 from 상영정보 s where s.상영번호 = '"+상영번호+"'";
    stmt = stmt = conn.createStatement();
    rs = stmt.executeQuery(sql);
    while(rs.next()){
      예매좌석수 = rs.getString("예매좌석수");
      총좌석수 = rs.getString("총좌석수");
      // 예매 가능 매수 계산
      예매가능매수 = Integer.parseInt(총좌석수) - Integer.parseInt(예매좌석수);
      // 예매가능매수를 초과했을 때, 최대 10장
      if(예매가능매수 < 총예매매수 || 10 < 총예매매수){
        %>
        <script>
          // 좌석수가 부족할 때 알림
          alert("예매가능매수를 초과하였습니다.");
          history.back();
        </script>
        <%
      }
    }

    // 결제 금액과 예매가능한 좌석수가 충분할 때,
    if (Integer.parseInt(현금) >= 결제금액 && 예매가능매수 >= 총예매매수){
        // 예매좌석수 계산
        예매좌석수 = Integer.toString(Integer.parseInt(예매좌석수) + 총예매매수);
        // 현재 시간을 다루기 위한 변수
        Date nowTime = new Date();
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");

        // 예매내역 insert 및 예매 완료
        sql = "INSERT INTO 예매내역 values (0, '"+성인예매매수+"', '"+청소년예매매수+"', '"+결제금액+"', '"+포인트+"', TO_DATE('"+sf.format(nowTime)+"', 'yyyy-mm-dd'), '"+id+"', '"+상영번호+"')";
        stmt = conn.createStatement();
        stmt.executeUpdate(sql);

        // 상영정보에 대한 예매좌석수 update
        sql = "update 상영정보 set 예매좌석수 = '"+예매좌석수+"' where 상영번호 = '"+상영번호+"'";
        stmt = conn.createStatement();
        stmt.executeUpdate(sql);

        // 회원의 사용 포인트 차감
        잔여포인트 = Integer.toString(Integer.parseInt(잔여포인트) - Integer.parseInt(포인트));
        sql = "update 회원 set 포인트 = '"+잔여포인트+"' where 회원번호 = '"+id+"'";
        stmt = conn.createStatement();
        stmt.executeUpdate(sql);

        // 예매 내역 알림에 들어갈 내용 조회
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
            // 예매 내역 알림
            alert("<%=예매번호%>번\n <%=예매날짜%>\n 성인 : <%=성인예매매수%>명\n 청소년 : <%=청소년예매매수%>명");
            location.href="main/main.jsp";
          </script>
          <%
        }
    }
    else{
      %>
      <script>
        // 결제 금액이 부족할 때 알림
        alert("결제금액이 부족합니다.");
        history.back();
      </script>
      <%
    }
  }
  // conn 종료
  if(rs != null) rs.close();
  if(stmt != null) stmt.close();
  if(conn != null) conn.close();
%>
