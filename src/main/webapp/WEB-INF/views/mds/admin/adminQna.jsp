<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	<main id="main" class="main">

		<div class="pagetitle">
			<h1>1:1 문의관리</h1>
			<br>
			<nav>
				<ol class="breadcrumb">
					<li class="breadcrumb-item"><a href="index.html">Home</a></li>
					<li class="breadcrumb-item active">1:1 문의관리</li>
				</ol>
			</nav>
		</div>
		<!-- End Page Title -->
		<section class="section"  style="width: 1100px;">
			<div class="row">
				<div class="col-lg-12">

					<div class="card">
						<div class="card-body">
							<h5 class="card-title">문의게시글</h5>

							<!-- Table with stripped rows -->
							<div class="datatable-wrapper datatable-loading no-footer sortable searchable fixed-columns">
								<div class="datatable-top" style="display: flex; flex-direction: row-reverse;">
									<!-- 검색버튼 -->
									<div id="searchUI" style="display: flex;">
										<select name="searchType" class="form-select" 
										style="width: 94px; height: 33px; margin: 0px 10px 0px 0px; font-size: 14px;">
											<option value>전체</option>
											<option value="pstSj">제목</option>
											<option value="userId">아이디</option>
											<option value="userNm">이름</option>
										</select>
										<input type="text" class="form-control" name="searchWord" style="width: 200px; height: 33px;"/>
										<button type="button" class="btn btn-secondary" id="searchBtn" style="height: 33px; width: 43px; position: absolute; right: 30px;">
											<i class="bi bi-search"></i>
										</button>
									</div> 
									<!-- 검색버튼 END -->
								</div>
								<div class="datatable-container">
									<table class="table datatable datatable-table">
										<thead>
											<tr>
												<th data-sortable="true" style="width: 10.794258373205743%;">
													<button class="datatable-sorter">
															<b>게시글 번호</b>
													</button>
												</th>
												<th data-sortable="true" style="width: 10.186602870813397%;">
													<button class="datatable-sorter">아이디</button>
												</th>
												<th data-sortable="true" style="width: 10.186602870813397%;">
													<button class="datatable-sorter">이름</button>
												</th>
												<th data-sortable="true" style="width: 28.51674641148325%;">
													<button class="datatable-sorter">제목</button>
												</th>
												<th data-format="YYYY/DD/MM" data-sortable="true" data-type="date" style="width: 16.937799043062203%;">
													<button class="datatable-sorter">등록일자</button>
												</th>
												<th data-sortable="true" class="red" style="width: 18.564593301435405%;">
													<button class="datatable-sorter">답변상태</button>
												</th>
											</tr>
										</thead>
										<tbody id="qnaListForm">
										</tbody>
									</table>
								</div>
								<div class="datatable-bottom">
									<!-- Pagination -->
									<div id="Qpaging"></div>
									<!--/ End Pagination -->
								</div>
							</div>
							<!-- End Table with stripped rows -->

						</div>
					</div>

				</div>
			</div>
			<input type="hidden" id="userNo" value="${principal.userNo}">
		</section>
	</main>
	<!-- End #main -->
<!-- 	<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a> -->
	<form action="<c:url value='/qna'/>" id="searchForm">
		<input type="hidden" name="pstSj"/>
		<input type="hidden" name="searchWord" />
		<input type="hidden" name="currentPage" />
	</form>
<script>
const paging = document.querySelector("#Qpaging");
let userNo = document.querySelector("#userNo").value;
//====================== 페이징,검색 스크립트======================//
$(function(){
	
// 	페이징버튼을 클릭하면 클릭한 페이징 정보가 저장된후 searchForm을 submit하는 스크립트
	$(document).on("click", "[data-page]", function(){
		let page = $(this).data('page');
		searchForm.currentPage.value = page;
//			console.log("눌러서 저장된 페이지값==>",searchForm.currentPage.value);
		$searchForm.submit();
	});
	
//		searchForm이 submit이 되면 해당 이벤트를 중지시키고 페이징 정보를 비동기로 요청하는 스크립트
	const $searchForm = $("#searchForm").on('submit',function(e){
		e.preventDefault();
        var searchType = $("select[name='searchType']").val();
        var searchWord = $("input[name='searchWord']").val();
	    
        // let data = searchForm.currentPage.value;

	    let formData = new FormData();

        formData.append("currentPage",searchForm.currentPage.value);
        formData.append("searchType",searchType);
        formData.append("searchWord",searchWord);

        let params = new URLSearchParams(formData);
	    
		// let url = cPath+"/qna?currentPage="+data;
        
		let url = cPath+"/adminQna?"+params;
//      console.log("url==>",url);
		
	    fetch(url,{
	        method:'get',
	        headers:{
	            'Accept': 'application/json'
	        }
	    })
	    .then(resp=>resp.json())
	    .then(resp=>{
	        items.innerHTML = "";
	        resp.QnaList.forEach(list => {
				items.innerHTML += gen(list);
	        });
	    	paging.innerHTML = resp.pagingHTML;
	    })
	});
	
	// searchBtn 을 클릭하면, searchUI 가 가진 모든 입력값을 searchForm 으로 복사하고, searchForm을 전송
    $("#searchBtn").on("click", function(event){
        // 검색 유형과 검색어를 가져옵니다.
    	$searchForm.submit();
    });
    
    $("[name='pstSj']").val("${detailConditions.pstSj}");
});	
//==================== 페이징,검색 스크립트 END ====================//

let items = document.querySelector("#qnaListForm");
const gen = (vo) =>{
    let date = vo.pstWrtDe.substr(0,10);
//    	console.log("vo==>",vo);
   	let str = "";
   	
   	str += `<tr>
				<td>\${vo.rnum}</td>
				<td>\${vo.userId}</td>
				<td>\${vo.userNm}</td>
				<td><a href=\${cPath}/adminQnaDetail/\${vo.pstNo}>\${vo.pstSj}</a></td>
				<td>\${date}</td>`;
		if(vo.cmt >0){
			str += `<td>답변완료</td>`;	
		}else{
			str += `<td>답변미완료</td>`;	
		}
	str += `</tr>`;
    return str;
}
let url = cPath+`/adminQna`;

fetch(url,{
    method:'get',
    headers:{
        'Accept': 'application/json'
    }
})
.then(resp=>resp.json())
.then(resp=>{
    // 방법1
//  items.innerHTML = resp.qnaVOList.map(gen).join("\n");
    // 방법2
    resp.QnaList.forEach(list => {
//  여기에서 함수를 하나 생성해서 div태그로 값들을 생성해준다.
// 		console.log("넘어온 list값==>",list);
		items.innerHTML += gen(list);
    });
	paging.innerHTML = resp.pagingHTML;
})
</script>