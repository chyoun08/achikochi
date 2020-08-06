<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />

<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=6075271047e78cae55ec2f93d011c0a1&libraries=services"></script>

<script>
	$(document).ready(function() {
		$("#updateInfo").click(function(e) {
			updateRequset();
		});
	});

	function updateRequset() {
		var user_no = $("#user_no").val();
		var user_pw = $("#user_pw").val();
		var mail = $("#mail").val();
		var nickname = $("#nickname").val();
		var introduce = $("#introduce").val();
		var lat = $("#t1").val();
		var lng = $("#t2").val();

		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");

		$.ajax({
			url : "/user/update",
			type : "POST",
			dataType : 'json',
			data : {
				user_no : user_no,
				user_pw : user_pw,
				mail : mail,
				nickname : nickname,
				introduce : introduce,
				lat : lat,
				lng : lng
			},
			beforeSend : function(xhr) {
				xhr.setRequestHeader(header, token);
			},
			success : function(data, status, xhr) { // alertify or another welcome page 이동
				alertify.alert('KisscoStore', '회원정보 수정이 완료되었습니다!!', function() {
					window.location.href = "/user/userInfo";
				})
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alertify.notify('유저정보창 입장에 문제가 생겼습니다.', 'error', 3, function() {
					console.log(jqXHR.responseText);
				});
			}
		});
	}
</script>

<!-- Breadcrumbs Area Start -->
<div class="breadcrumbs-area">
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<div class="breadcrumbs">
					<h2>マイページ</h2>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- Breadcrumbs Area Start -->

<!-- My Account Area Start -->
<div class="my-account-area section-padding">
	<div class="container">
		<div class="row">
			<div class="addresses-lists">
				<div class="col-xs-12 col-sm-6 col-lg-12">
					<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
						<div class="panel panel-default">
							<div class="panel-heading">
								<h4 class="panel-title">
									<a href="/user/mySellList"> <i class="fa fa-heart"></i> <span>販売している物に移動</span>
									</a>
								</h4>
							</div>
						</div>
						<div class="panel panel-default">
							<div class="panel-heading">
								<h4 class="panel-title">
									<a href="/product/wishList"> <i class="fa fa-heart"></i> <span>買いたい物に移動</span>
									</a>
								</h4>
							</div>
						</div>
						<div class="panel panel-default">
							<div class="panel-heading" role="tab" id="headingOne">
								<h4 class="panel-title">
									<a role="button" data-toggle="collapse"
										data-parent="#accordion" href="#collapseOne"
										aria-expanded="true" aria-controls="collapseOne"> <i
										class="fa fa-building"></i> <span>個人情報管理</span>
									</a>
								</h4>
							</div>
							<div class="panel-collapse collapse in" role="tabpanel"
								aria-labelledby="headingOne">
								<div class="panel-body">
									<div class="coupon-info">
										<h1 class="heading-title">個人情報管理</h1>

										<%--
										<p class="coupon-text">個人情報を更新、及び追加したい方は下の欄に記入してください。</p>
										<p class="required">*必須項目</p> --%>

										<input type="hidden" id="user_no" value="${user.user_no}">

										<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;アイディー</p>
										<p class="form-row">
											<input type="text" id="user_id" name="user_id"
												value="${user.user_id}" readonly>
										</p>

										<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;パスワード</p>
										<p class="form-row">
											<input type="text" id="user_pw" name="user_pw"
												value="${user.user_pw}" placeholder="パスワード *" />
										</p>

										<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ニックネーム</p>
										<p class="form-row">
											<input type="text" id="nickname" name="nickname"
												value="${user.nickname}" placeholder="名前 *">
										</p>

										<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;メールアドレス</p>
										<p class="form-row">
											<input type="text" id="mail" name="mail"
												value="${user.mail}" readonly>
										</p>



										<p>*あなたの位置</p>
										<p class="form-row order-notes">
										<div class="map_wrap">

											<div id="map"
												style="width: 100%; height: 100%; position: relative; overflow: hidden;"></div>

											<div id="menu_wrap" class="bg_white">
												<div class="option">
													<div>
														<form onsubmit="searchPlaces(); return false;">
															キーワード : <input type="text" value="" id="keyword"
																size="15">
															<button type="submit">検索</button>
														</form>
													</div>
												</div>
												<hr>
												<ul id="placesList"></ul>
												<div id="pagination"></div>
											</div>

											<div>
												<input type="hidden" id="t1" name="lat" value="${user.lat}"> 
												<input type="hidden" id="t2" name="lng" value="${user.lng}">
											</div>


										</div>
										
										<a title="Save" class="btn button button-small"
											id="updateInfo"> <span> 保存 <i
												class="fa fa-chevron-right"></i>
										</span>
										</a>
									</div>
								</div>
							</div>
						</div>
					</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="create-account-button pull-left">
					<a href="index.html" class="btn button button-small" title="Home">
						<span> <i class="fa fa-chevron-left"></i> ホーム
					</span>
					</a>
				</div>
			</div>
		</div>
	</div>
</div>
</div>
<!-- My Account Area End -->

<script>

var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
mapOption = {
    center: new kakao.maps.LatLng($("#t1").val(), $("#t2").val()), // 지도의 중심좌표
    level: 3 // 지도의 확대 레벨
};  

//마커를 담을 배열입니다
var markers = [];

// 지도를 생성합니다    
var map = new kakao.maps.Map(mapContainer, mapOption); 


// 장소 검색 객체를 생성합니다
var ps = new kakao.maps.services.Places();  

// 검색 결과 목록이나 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성합니다
var infowindow = new kakao.maps.InfoWindow({zIndex:1});

// 키워드로 장소를 검색합니다
searchPlaces();

// 키워드 검색을 요청하는 함수입니다
function searchPlaces() {

    var keyword = document.getElementById('keyword').value;

    if (!keyword.replace(/^\s+|\s+$/g, '')) {
        // alert('키워드를 입력해주세요!');
        return false;
    }

    // 장소검색 객체를 통해 키워드로 장소검색을 요청합니다
    ps.keywordSearch( keyword, placesSearchCB); 
}

// 장소검색이 완료됐을 때 호출되는 콜백함수 입니다
function placesSearchCB(data, status, pagination) {
    if (status === kakao.maps.services.Status.OK) {

        // 정상적으로 검색이 완료됐으면
        // 검색 목록과 마커를 표출합니다
        displayPlaces(data);

        // 페이지 번호를 표출합니다
        displayPagination(pagination);

    } else if (status === kakao.maps.services.Status.ZERO_RESULT) {

        alert('검색 결과가 존재하지 않습니다.');
        return;

    } else if (status === kakao.maps.services.Status.ERROR) {

        alert('검색 결과 중 오류가 발생했습니다.');
        return;

    }
}

//주소-좌표 변환 객체를 생성합니다
var geocoder = new kakao.maps.services.Geocoder();


//지도를 클릭한 위치에 표출할 마커입니다
var markerr = new kakao.maps.Marker({ 
    // 지도 중심좌표에 마커를 생성합니다 
    position: map.getCenter() 
}); 
// 지도에 마커를 표시합니다
markerr.setMap(map);

// 지도에 클릭 이벤트를 등록합니다
// 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다


kakao.maps.event.addListener(map, 'click', function(mouseEvent) {        
    
    // 클릭한 위도, 경도 정보를 가져옵니다 
    var latlng = mouseEvent.latLng; 
    
    // 마커 위치를 클릭한 위치로 옮깁니다
    markerr.setPosition(latlng);

	document.getElementById('t1').value = latlng.getLat();
	document.getElementById('t2').value = latlng.getLng();
    
});

function swap(markerPosition){

	markerr.setPosition(markerPosition);
	
}

//지도를 클릭했을 때 클릭 위치 좌표에 대한 주소정보를 표시하도록 이벤트를 등록합니다
kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
    searchDetailAddrFromCoords(mouseEvent.latLng, function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
            var detailAddr = !!result[0].road_address ? '<div>도로명주소 : ' + result[0].road_address.address_name + '</div>' : '';
            detailAddr += '<div>지번 주소 : ' + result[0].address.address_name + '</div>';
            
            var content = '<div class="bAddr">' +
                            '<span class="title">법정동 주소정보</span>' + 
                            detailAddr + 
                        '</div>';

            // 마커를 클릭한 위치에 표시합니다 
            markerr.setPosition(mouseEvent.latLng);
            markerr.setMap(map);

            // 인포윈도우에 클릭한 위치에 대한 법정동 상세 주소정보를 표시합니다
            infowindow.setContent(content);
            infowindow.open(map, markerr);
        }   
    });
});

function searchAddrFromCoords(coords, callback) {
    // 좌표로 행정동 주소 정보를 요청합니다
    geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback);         
}

function searchDetailAddrFromCoords(coords, callback) {
    // 좌표로 법정동 상세 주소 정보를 요청합니다
    geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
}

// 검색 결과 목록과 마커를 표출하는 함수입니다
function displayPlaces(places) {

    var listEl = document.getElementById('placesList'), 
    menuEl = document.getElementById('menu_wrap'),
    fragment = document.createDocumentFragment(), 
    bounds = new kakao.maps.LatLngBounds(), 
    listStr = '';
    
    // 검색 결과 목록에 추가된 항목들을 제거합니다
    removeAllChildNods(listEl);

    // 지도에 표시되고 있는 마커를 제거합니다
    removeMarker();
  
    
    for ( var i=0; i<places.length; i++ ) {

        // 마커를 생성하고 지도에 표시합니다
        var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x),
            marker = addMarker(placePosition, i), 
            itemEl = getListItem(i, places[i]); // 검색 결과 항목 Element를 생성합니다

        // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
        // LatLngBounds 객체에 좌표를 추가합니다
        bounds.extend(placePosition);

        // 마커와 검색결과 항목에 mouseover 했을때
        // 해당 장소에 인포윈도우에 장소명을 표시합니다
        // mouseout 했을 때는 인포윈도우를 닫습니다
        (function(marker, title) {

            kakao.maps.event.addListener(marker, 'click', function() {
            	
            	var markerPosition  = marker.getPosition();

            	swap(markerPosition);
            	
            });
            
            kakao.maps.event.addListener(marker, 'mouseover', function() {
                displayInfowindow(marker, title);
                
            });

            kakao.maps.event.addListener(marker, 'mouseout', function() {
                infowindow.close();
            });

            itemEl.onmouseover =  function () {
                displayInfowindow(marker, title);
            };

            itemEl.onmouseout =  function () {
                infowindow.close();
            };
        })(marker, places[i].place_name);

        fragment.appendChild(itemEl);
    }

    // 검색결과 항목들을 검색결과 목록 Elemnet에 추가합니다
    listEl.appendChild(fragment);
    menuEl.scrollTop = 0;

    // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
    map.setBounds(bounds);
}

// 검색결과 항목을 Element로 반환하는 함수입니다
function getListItem(index, places) {

    var el = document.createElement('li'),
    itemStr = '<span class="markerbg marker_' + (index+1) + '"></span>' +
                '<div class="info">' +
                '   <h5>' + places.place_name + '</h5>';

    if (places.road_address_name) {
        itemStr += '    <span>' + places.road_address_name + '</span>' +
                    '   <span class="jibun gray">' +  places.address_name  + '</span>';
    } else {
        itemStr += '    <span>' +  places.address_name  + '</span>'; 
    }
                 
      itemStr += '  <span class="tel">' + places.phone  + '</span>' +
                '</div>';           

    el.innerHTML = itemStr;
    el.className = 'item';

    return el;
}

// 마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
function addMarker(position, idx, title) {
    var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
        imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
        imgOptions =  {
            spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
            spriteOrigin : new kakao.maps.Point(0, (idx*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
            offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
        },
        markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
            marker = new kakao.maps.Marker({
            position: position, // 마커의 위치
            image: markerImage 
        });

    marker.setMap(map); // 지도 위에 마커를 표출합니다
    markers.push(marker);  // 배열에 생성된 마커를 추가합니다

    return marker;
}

// 지도 위에 표시되고 있는 마커를 모두 제거합니다
function removeMarker() {
    for ( var i = 0; i < markers.length; i++ ) {
        markers[i].setMap(null);
    }   
    markers = [];
}

// 검색결과 목록 하단에 페이지번호를 표시는 함수입니다
function displayPagination(pagination) {
    var paginationEl = document.getElementById('pagination'),
        fragment = document.createDocumentFragment(),
        i; 

    // 기존에 추가된 페이지번호를 삭제합니다
    while (paginationEl.hasChildNodes()) {
        paginationEl.removeChild (paginationEl.lastChild);
    }

    for (i=1; i<=pagination.last; i++) {
        var el = document.createElement('a');
        el.href = "#";
        el.innerHTML = i;

        if (i===pagination.current) {
            el.className = 'on';
        } else {
            el.onclick = (function(i) {
                return function() {
                    pagination.gotoPage(i);
                }
            })(i);
        }

        fragment.appendChild(el);
    }
    paginationEl.appendChild(fragment);
}

// 검색결과 목록 또는 마커를 클릭했을 때 호출되는 함수입니다
// 인포윈도우에 장소명을 표시합니다
function displayInfowindow(marker, title) {
    var content = '<div style="padding:5px;z-index:1;">' + title + '</div>';

    infowindow.setContent(content);
    infowindow.open(map, marker);
}

 // 검색결과 목록의 자식 Element를 제거하는 함수입니다
function removeAllChildNods(el) {   
    while (el.hasChildNodes()) {
        el.removeChild (el.lastChild);
    }
}

</script>
