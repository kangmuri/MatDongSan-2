<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
#main{
	background-color: white;
}
</style>
<!-- 일정 상세조회 시작 -->
<div class="card" style="display: none;" id="schDetail">
	<div class="card-body">
		<h5 class="card-title">일정조회</h5>

		<form class="row g-3">
			<div class="col-md-12">
				<div class="form-floating">
					<input type="text" class="form-control schTitle" id="floatingName">
				</div>
			</div>
			<div class="col-md-6">
				<div class="form-floating">
					<input type="text" class="form-control schStart" id="floatingEmail"
						readonly="readonly">
				</div>
			</div>
			<div class="col-md-6">
				<div class="form-floating">
					<input type="text" class="form-control schEnd"
						id="floatingPassword" readonly="readonly">
				</div>
			</div>
			<div class="col-12">
				<div class="form-floating">
					<textarea class="form-control schContent" id="floatingTextarea"
						style="height: 100px;" readonly="readonly"></textarea>
				</div>
			</div>
			<div class="text-center">
				<button type="reset" class="btn btn-secondary" onclick="fMClose()">닫기</button>
			</div>
		</form>

	</div>
</div>
<!-- 일정 상세조회 끝 -->

    <!-- 캘린더 -->
    <div id="Wrapper">
        <div id='calendar'></div>
    </div>
    <script>
        const calendarEl = document.querySelector('#calendar');
        const mySchStart = document.querySelector("#schStart");
        const mySchEnd = document.querySelector("#schEnd");
        const mySchTitle = document.querySelector("#schTitle");
        const mySchAllday = document.querySelector("#allDay");
        const mySchBColor = document.querySelector("#schBColor");
        const mySchFColor = document.querySelector("#schFColor");
        
        const schDetail = document.querySelector("#schDetail");
        const mySchStart1 = document.querySelector(".schStart");
        const mySchEnd1 = document.querySelector(".schEnd");
        const mySchTitle1 = document.querySelector(".schTitle");
        const mySchContent1 = document.querySelector(".schContent");

        // Date 형식 변환 함수
        function yjToCal(pDate,pSep){

            let year = pDate.getFullYear();
            let month = pDate.getMonth()+1;
            if(month < 10){
                month = "0" + month;
            }
            let date = pDate.getDate();
            if(date < 10){
                date = "0" + date;
            }

            return `\${year}\${pSep}\${month}\${pSep}\${date}`;

        }
        //Date 형식 변환 함수
        
        
        //로그인한 사용자의 일정데이터 가져오기
        $(function(){
        	
        	var request = $.ajax({
        		url : cPath + "/lessee/schedule/" + '${principal.userNo }',//유저넘버를 가지고 스케줄 조회하는곳으로 가깅 
        		method:"GET",
        		dataType:"json",
        		success : function(resp) {
        			console.log("첫번째 확인",resp.scheduleVOList[0]);
        			console.log("두번째 확인",resp.scheduleVOList.length);
        			console.log("세번째 확인",resp.scheduleVOList[0].schdulBgnde);
        			console.log("종료일",resp.scheduleVOList[0].schdulEndde);
        			for(var i=0; i<resp.scheduleVOList.length; i++){
	        			var event = {
	        					start:resp.scheduleVOList[i].schdulBgnde,//일정시작날짜	
	        					end:resp.scheduleVOList[i].schdulEndde,	//일정종료날짜
	        					title:resp.scheduleVOList[i].schdulSj,//일정제목
	        					content:resp.scheduleVOList[i].schdulCn//일정내용
	        			};
	        			 
	        			 calendar.addEvent(event);// 일정 추가 
        			}
        		}
        	});
        })
        //캘린더 헤더 옵션
        const headerToolbar = {
            left: 'prevYear,prev,next,nextYear today',
            center: 'title',
            right: 'dayGridMonth,dayGridWeek,timeGridDay'
        }

        // 캘린더 생성 옵션(참공)
        const calendarOption = {
            height: '700px', // calendar 높이 설정
            expandRows: true, // 화면에 맞게 높이 재설정
            slotMinTime: '09:00', // Day 캘린더 시작 시간
            slotMaxTime: '18:00', // Day 캘린더 종료 시간
            // 맨 위 헤더 지정
            headerToolbar: headerToolbar,
            initialView: 'dayGridMonth',  // default: dayGridMonth 'dayGridWeek', 'timeGridDay', 'listWeek'
            locale: 'kr',        // 언어 설정
            selectable: true,    // 영역 선택
            selectMirror: true,  // 오직 TimeGrid view에만 적용됨, default false
            navLinks: true,      // 날짜,WeekNumber 클릭 여부, default false
            weekNumbers: true,   // WeekNumber 출력여부, default false
            editable: true,      // event(일정) 
            dayMaxEventRows: true,  // Row 높이보다 많으면 +숫자 more 링크 보임!
            nowIndicator: true,
            eventTimeFormat: { // 이 부분을 추가하여 시간을 숨긴다.
                hour: '2-digit',
                minute: '2-digit',
                meridiem: false,
                omitZeroMinute: true,
                hour12: false // 24시간 형식 사용
            },
            displayEventTime: false,
            eventSources: [
                './commonEvents.json',  // Ajax 요청 URL임에 유의!
                './KYREvents.json',
                './SYREvents.json'
            ]
        }
        
        // 캘린더 생성
        const calendar = new FullCalendar.Calendar(calendarEl, calendarOption);
        // 캘린더 그리깅
        calendar.render();

        // 캘린더 이벤트 등록
        calendar.on("eventClick", info => {//일정클릭했을때
            console.log("eClick:", info);
            console.log('Event: ', info.event.extendedProps);
            console.log('Coordinates: ', info.jsEvent);
            console.log('View: ', info.view);
            console.log('date: ', info.event._instance.range.end);
            
            schDetail.style.display = "block";

			//상세조회 값 설정
			mySchTitle1.value = info.event.title;
			mySchContent1.value = info.event.extendedProps.content;
			mySchStart1.value = yjToCal(info.event.start,"-");
			mySchEnd1.value = yjToCal(info.event._instance.range.end,"-");
			
// 			alert(info.event.title);
// 			alert(info.event.extendedProps.content);
			
        });
        
        // 모달 닫기
        function fMClose() {
            schDetail.style.display = "none";
        }
        	
    </script>


