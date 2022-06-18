<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="dbconn.jsp" %>

<head>
  <!-- 페이지 자동 새로고침 -->
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title> Auto refresh current page with regular intervals using JS</title>
  <script>
    setTimeout(function(){
        location.reload();
    },30000); // 30000밀리초 = 30초
  </script>
</head>

<%
  // 예매내역 및 관람내역을 manage하기 위한 jsp
  request.setCharacterEncoding("utf-8");

//  String id = request.getParameter("id");
//  String pass = request.getParameter("pass");

  ResultSet rs = null;
  Statement stmt = null;

  // 상영 시작한 영화에 대한 예매내역 정보를 관람내역으로 이동
  // 모든 예매내역 불러오기
  String sql = "select * from 예매내역";
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
    String 회원번호 = rs.getString("회원번호");
    out.println(예매번호);

    // 관람내역에 들어갈 지점 및 영화정보 불러오기
    String 지점 = "";
    String 상영관이름 = "";
    String 상영날짜 = "";
    String 상영날짜2 = "";
    String 영화이름 = "";
    String 개봉일 = "";
    String 감독 = "";
    // 관람내역에 들어갈 지점 및 영화정보 불러오기 위한 sql문
    sql = "select 지점, 상영관이름, 상영날짜, to_char(상영날짜, 'yyyymmddhh24miss') as 상영날짜2, 영화이름, 개봉일, 감독 from 상영정보 where 상영번호 = '"+상영번호+"'";
    stmt = conn.createStatement();
    ResultSet rs2 = stmt.executeQuery(sql);
    while(rs2.next()){
      지점 = rs2.getString("지점");
      상영관이름 = rs2.getString("상영관이름");
      상영날짜 = rs2.getString("상영날짜");
      상영날짜2 = rs2.getString("상영날짜2");
      영화이름 = rs2.getString("영화이름");
      개봉일 = rs2.getString("개봉일");
      감독 = rs2.getString("감독");
      out.println(지점);

      // 현재시간 상영날짜 비교
      // 현재 시간을 다루기 위한 변수
      Date nowTime = new Date();
      SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmmss");
      String 현재시간 = sf.format(nowTime);
      out.println(상영날짜2);
      out.println(현재시간);
      // 연도, 월일, 시간 차이를 계산
      int 연도차이 = Integer.parseInt(상영날짜2.substring(0, 4)) - Integer.parseInt(현재시간.substring(0, 4));
      int 월일차이 = Integer.parseInt(상영날짜2.substring(4, 8)) - Integer.parseInt(현재시간.substring(4, 8));
      int 시간차이 = Integer.parseInt(상영날짜2.substring(8, 14)) - Integer.parseInt(현재시간.substring(8, 14));
      // 상영시간이 지났을 때,
      if(연도차이<0 || (연도차이==0 && 월일차이<0) || (연도차이==0 && 월일차이==0 && 시간차이<0)){
        // 예매내역의 정보 -> 관람내역으로 이동
        sql = "insert into 관람내역 values(0, "+성인예매매수+", "+청소년예매매수+", to_date('"+상영날짜+"', 'yyyy-mm-dd hh24:mi:ss'), "+회원번호+", '"+영화이름+"', to_date('"+개봉일+"', 'yyyy-mm-dd hh24:mi:ss'), '"+감독+"', '"+지점+"', '"+상영관이름+"' )";
        stmt = conn.createStatement();
        stmt.executeUpdate(sql);
        // 관람관객 포인트 5% 적립
        int 적립포인트 = (int)Integer.parseInt(현금결제금액)*5/100;
        sql = "update 회원 set 포인트 = 포인트 + '"+적립포인트+"' where 회원번호 = '"+회원번호+"'";
        stmt = conn.createStatement();
        stmt.executeUpdate(sql);
        // 해당 영화의 예매내역 삭제
        sql = "delete from 예매내역 where 예매번호 = '"+예매번호+"'";
        stmt = conn.createStatement();
        stmt.executeUpdate(sql);
        // 상영정보의 예매자수 관리
        sql = "select * from 예매내역 where 상영번호 = '"+상영번호+"'";
        stmt = conn.createStatement();
        rs2 = stmt.executeQuery(sql);
        // 상영정보에 대한 예매내역이 없을 경우 상영정보 삭제
        if(!rs2.next()){
          sql = "delete from 상영정보 where 상영번호 ='"+상영번호+"'";
          stmt = conn.createStatement();
          stmt.executeUpdate(sql);
        }
      }
    }
  }
  // conn 종료
  if(rs != null) rs.close();
  if(stmt != null) stmt.close();
  if(conn != null) conn.close();
%>
