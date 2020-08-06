<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=6075271047e78cae55ec2f93d011c0a1&libraries=services"></script>

<script>
$(document).ready(function() {
   console.log('ajax on');
   $("#submitcreate").click(function(e){
      registerRequset();
   });
});

function registerRequset(){
   var user_id = $("#user_id").val();
   var user_pw = $("#user_pw").val();
   var nickname = $("#nickname").val();
   var mail = $("#mail").val();
   var lat = $("#t1").val();
   var lng = $("#t2").val();   
   
   var token = $("meta[name='_csrf']").attr("content");
   var header = $("meta[name='_csrf_header']").attr("content");
   
   $.ajax({ 
      url : "/user/register",
      type : "POST",
      dataType : 'json',
      data : {
         user_id : user_id,
         user_pw : user_pw,
         nickname : nickname,
         mail : mail,
         lat : lat,
         lng : lng
      },
      beforeSend : function(xhr) {
         xhr.setRequestHeader(header, token);
      },
      success : function(data, status, xhr) { // alertify or another welcome page 이동
         alertify.alert('あちこち', '加入準備ができました。　メールを確認してください。', function() {
            window.location.href = "/";
         })
      },
      error : function(jqXHR, textStatus, errorThrown) {
         alertify.notify('加入の間に問題が発生しました。もう一度、試してください。', 'error', 3,
               function() {
                  console.log(jqXHR.responseText);
               });
      }
   });
}
</script>

<script>
	function init() {
		window.navigator.geolocation.getCurrentPosition(current_position);
	}

	function current_position(position) {
		var mapContainer = document.getElementById('map'), mapOption = {
			center : new kakao.maps.LatLng(position.coords.latitude,
					position.coords.longitude),
			level : 3
		};

		document.getElementById('t1').value = position.coords.latitude;
		document.getElementById('t2').value = position.coords.longitude;

		var map = new kakao.maps.Map(mapContainer, mapOption);

		// 주소-좌표 변환 객체를 생성합니다
		var geocoder = new kakao.maps.services.Geocoder();

		var marker = new kakao.maps.Marker(), // 클릭한 위치를 표시할 마커입니다
		infowindow = new kakao.maps.InfoWindow({
			zindex : 1
		}); // 클릭한 위치에 대한 주소를 표시할 인포윈도우입니다

		// 현재 지도 중심좌표로 주소를 검색해서 지도 좌측 상단에 표시합니다
		searchAddrFromCoords(map.getCenter(), displayCenterInfo);

		// 지도를 클릭했을 때 클릭 위치 좌표에 대한 주소정보를 표시하도록 이벤트를 등록합니다
		kakao.maps.event
				.addListener(
						map,
						'click',
						function(mouseEvent) {
							
							// 클릭한 위도, 경도 정보를 가져옵니다 
							var latlng = mouseEvent.latLng;

							var message = '클릭한 위치의 위도는 ' + latlng.getLat() + ' 이고, ';
							message += '경도는 ' + latlng.getLng() + ' 입니다';

							document.getElementById('t1').value = latlng.getLat();
							document.getElementById('t2').value = latlng.getLng();

							searchDetailAddrFromCoords(
									mouseEvent.latLng,
									function(result, status) {
										if (status === kakao.maps.services.Status.OK) {
											var detailAddr = !!result[0].road_address ? '<div>도로명주소 : '
													+ result[0].road_address.address_name
													+ '</div>'
													: '';
											detailAddr += '<div>지번 주소 : '
													+ result[0].address.address_name
													+ '</div>';

											var content = '<div class="bAddr">'
													+ '<span class="title">법정동 주소정보</span>'
													+ detailAddr + '</div>';

											// 마커를 클릭한 위치에 표시합니다 
											marker.setPosition(mouseEvent.latLng);
											marker.setMap(map);

											// 인포윈도우에 클릭한 위치에 대한 법정동 상세 주소정보를 표시합니다
											infowindow.setContent(content);
											infowindow.open(map, marker);
										}
									});
						});

		// 중심 좌표나 확대 수준이 변경됐을 때 지도 중심 좌표에 대한 주소 정보를 표시하도록 이벤트를 등록합니다
		kakao.maps.event.addListener(map, 'idle', function() {
			searchAddrFromCoords(map.getCenter(), displayCenterInfo);
		});

		function searchAddrFromCoords(coords, callback) {
			// 좌표로 행정동 주소 정보를 요청합니다
			geocoder.coord2RegionCode(coords.getLng(), coords.getLat(),
					callback);
		}

		function searchDetailAddrFromCoords(coords, callback) {
			// 좌표로 법정동 상세 주소 정보를 요청합니다
			geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
		}

		// 지도 좌측상단에 지도 중심좌표에 대한 주소정보를 표출하는 함수입니다
		function displayCenterInfo(result, status) {
			if (status === kakao.maps.services.Status.OK) {
				var infoDiv = document.getElementById('centerAddr');

				for (var i = 0; i < result.length; i++) {
					// 행정동의 region_type 값은 'H' 이므로
					if (result[i].region_type === 'H') {
						infoDiv.innerHTML = result[i].address_name;
						break;
					}
				}
			}
		}
	}

	window.addEventListener("load", init);
</script>

<!-- Breadcrumbs Area Start -->
<div class="breadcrumbs-area">
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<div class="breadcrumbs">
					<h2>会員登録</h2>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- Breadcrumbs Area Start -->

<!-- Loging Area Start -->
<div class="login-account section-padding">
	<div class="container">
		<div class="row">
			<div class="col-md-6-1 col-sm-6">
				<form class="create-account-form" method="post">
					<h2 class="heading-title">会員登録</h2>
					<p class="form-row">
						<input type="text" id="user_id" placeholder="アイディー" required>
					</p>
					<p class="form-row">
						<input type="password" id="user_pw" placeholder="パスワード" required>
					</p>
					<p class="form-row">
						<input type="text" id="nickname" placeholder="ニックネーム" required>
					</p>
					<p class="form-row">
						<input type="email" id="mail" placeholder="メールアドレス" required>
					</p>


					<!-- map -->

					<div class="map_wrap">
						<div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
						<div class="hAddr">
							<span id="centerAddr"></span><span class="title"></span> 
						</div>
						
						<div>
							<input type="hidden" id="t1" name="lat"> 
							<input type="hidden" id="t2" name="lng">
							<p id="result"></p>
						</div>
					</div>

					<!-- MAP End -->
					
					<input type="hidden" name="${_csrf.parameterName}"
						value="${_csrf.token}" />
						
					<p><b>あなたの位置を選んで下さい。もし選択しない場合、基本位置が入ります。</b></p>

				</form>
				
				<!-- 이 부분 나중에 form안으로 -->
				<div class="submit">
						<button name="submitcreate" id="submitcreate" type="submit"
							class="btn-default">
							<span> <i class="fa fa-user left"></i> 会員登録
							</span>
						</button>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- Loging Area End -->