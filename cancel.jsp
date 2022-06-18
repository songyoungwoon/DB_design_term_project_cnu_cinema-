<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="dbconn.jsp" %>
<%
  request.setCharacterEncoding("utf-8");

  String id = (String)session.getAttribute("id");

  String 예매번호 = request.getParameter("예매번호");

  ResultSet rs = null;
  Statement stmt = null;

  String sql = "select * from 예매내역 where 회원번호 = '"+id+"' and 예매번호 = '"+예매번호+"'";
  stmt = conn.createStatement();
  rs = stmt.executeQuery(sql);
  String 현금결제금액 = "";
  String 포인트결제금액 = "";
  while(rs.next()){
    // 취소내역에 들어갈 예매내역 불러오기
    String 성인예매매수 = rs.getString("성인예매매수");
    String 청소년예매매수 = rs.getString("청소년예매매수");
    현금결제금액 = rs.getString("현금결제금액");
    포인트결제금액 = rs.getString("포인트결제금액");
    String 상영번호 = rs.getString("상영번호");

    // 취소내역에 들어갈 지점 및 영화정보 불러오기
    String 지점 = "";
    String 상영관이름 = "";
    String 영화이름 = "";
    String 개봉일 = "";
    String 감독 = "";
    sql = "select 지점, 상영관이름, 영화이름, 개봉일, 감독 from 상영정보 where 상영번호 = '"+상영번호+"'";
    stmt = conn.createStatement();
    rs = stmt.executeQuery(sql);
    while(rs.next()){
      지점 = rs.getString("지점");
      상영관이름 = rs.getString("상영관이름");
      영화이름 = rs.getString("영화이름");
      개봉일 = rs.getString("개봉일");
      감독 = rs.getString("감독");
    }

    // 취소내역 추가
    int 취소매수 = Integer.parseInt(성인예매매수) + Integer.parseInt(청소년예매매수);
    Date nowTime = new Date();
    SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
    sql = "insert into 취소내역(취소매수, 현금환불금액, 포인트환불금액, 취소날짜, 회원번호, 영화이름, 개봉일, 감독, 지점, 상영관이름) ";
    sql += "values('"+취소매수+"', '"+현금결제금액+"', '"+포인트결제금액+"', TO_DATE('"+sf.format(nowTime)+"', 'yyyy-mm-dd'), '"+id+"', '"+영화이름+"', TO_DATE('"+개봉일+"', 'yyyy-mm-dd hh24:mi:ss'), '"+감독+"', '"+지점+"', '"+상영관이름+"') ";
    stmt = conn.createStatement();
    stmt.executeUpdate(sql);

    // 포인트 환불
    // 회원 포인트 정보 불러오기
    sql = "select 포인트 from 회원 where 회원번호 = '"+id+"'";
    stmt = conn.createStatement();
    rs = stmt.executeQuery(sql);
    String 잔여포인트 = "";
    while(rs.next()){
      잔여포인트 = rs.getString("포인트");
    }
    잔여포인트 = Integer.toString(Integer.parseInt(잔여포인트) + Integer.parseInt(포인트결제금액));
    // 포인트 update
    sql = "update 회원 set 포인트 = '"+잔여포인트+"' where 회원번호 = '"+id+"'";
    stmt = conn.createStatement();
    stmt.executeUpdate(sql);

    // 예매내역 삭제
    sql = "delete from 예매내역 where 예매번호 = '"+예매번호+"'";
    stmt = conn.createStatement();
    stmt.executeUpdate(sql);

    // 예매좌석수 불러오기
    sql = "select 예매좌석수 from 상영정보 where 상영번호 = '"+상영번호+"'";
    stmt = conn.createStatement();
    rs = stmt.executeQuery(sql);
    while(rs.next()){
      String 예매좌석수 = rs.getString("예매좌석수");
      예매좌석수 = Integer.toString((Integer.parseInt(예매좌석수)-취소매수));
      // 상영관 예매좌석수 업데이트
      sql = "update 상영정보 set 예매좌석수 = '"+예매좌석수+"' where 상영번호 = '"+상영번호+"'";
      stmt = conn.createStatement();
      stmt.executeUpdate(sql);
    }
  }
  if(rs != null) rs.close();
  if(stmt != null) stmt.close();
  if(conn != null) conn.close();
%>
<script>
  alert("현금 결제 : "+<%out.println(현금결제금액);%>+"\n포인트 결제 : "+<%out.println(포인트결제금액);%>+"\n환불되었습니다.");
  location.href="my_page.jsp";
</script>
