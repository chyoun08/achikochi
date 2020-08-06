<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />
<script type="text/javascript"
   src="//dapi.kakao.com/v2/maps/sdk.js?appkey=6075271047e78cae55ec2f93d011c0a1&libraries=services"></script>

<script>
   $(document).ready(function() { 

      $("#update").click(function() {

         productUpdate();

      });

   });

   function productUpdate() {

      //var form = $('#upload-file-form')[0];
      var formdata = new FormData();
      var inputFile = $("input[name='uploadfile']");
      var files = inputFile[0].files;
     formdata.append("product_no",${product.product_no});
      formdata.append("category", $("#category").val());
      formdata.append("lat", $("#t1").val());
      formdata.append("lng", $("#t2").val());
      formdata.append("title", $("#title").val());
      formdata.append("price", $("#price").val());
      formdata.append("content", $("#board").val());
      for (var i = 0; i < files.length; i++) {
         formdata.append("files", files[i]);
      }

      console.log($("#lat").val());
      console.log($("#lng").val());
      console.log($("#price").val());
      console.log($("#board").val());

      var token = $("meta[name='_csrf']").attr("content");
      var header = $("meta[name='_csrf_header']").attr("content");

      $.ajax({
         type : 'post',
         url : '/product/update',
         dataType : 'json',
         data : formdata,
         contentType : false, // forcing jQuery not to add a Content-Type header for you, otherwise, the boundary string will be missing from it
         processData : false, // otherwise, jQuery will try to convert your FormData into a string, which will fail.
         beforeSend : function(xhr) {
            //xhr.setRequestHeader("ApiKey", "asdfasxdfasdfasdf");
            xhr.setRequestHeader(header, token);
         },
         success : function(data, status, xhr) {

            if (data) {
               alert('商品が修正されました。');
               window.location.href = "/shop?page=0&word=&category_no=0";
            } else {
               alertify.notify('写真の数は最大4個までできます。', 'error');
            }
         },
         error : function(jqXHR, textStatus, errorThrown) {
            if (jqXHR.responseText == "timeout") {
               window.location.href = "/login"
            } else {
               alertify.notify('오류', 'error', //'error','warning','message'
               3, //-1
               function() {
                  console.log(jqXHR.responseText);
               });
            }

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
               <h2>商品修正</h2>
            </div>
         </div>
      </div>
   </div>
</div>
<!-- Breadcrumbs Area Start -->

<!-- Product upload Start -->
<div class="product-upload" id="content">
   <div>
      <div class="table-responsive">
         <table class="table">
            <tr>
               <th class="success-1">商品名</th>
               <td colspan="5"><input type="text" name="title" id="title" value="${product.title}"></td>
            </tr>
            <tr>
               <th>カテゴリ</th>
               <td colspan="5">
                  <select class="span6 m-wrap" name="category" id="category" >
                  
                     <c:set var = "_currentCategory" value="${product.category}" />
                     <c:forEach var="categoryVO" items="${categoryList}"> 
                     <c:set var = "_category" value="${categoryVO.category_no}" />
                     <c:if test= "${_currentCategory eq _category}">
                        <option value="${categoryVO.category_no}" selected>${categoryVO.category_title}</option>
                     </c:if>
                        <option value="${categoryVO.category_no}">${categoryVO.category_title }</option>
                     </c:forEach>
                     
                  </select> 
               </td>
            </tr>
            <tr>
               <th>値段</th>
               <td>
                  <input type="text" name="price" id="price" min="1000" value ="${product.price}"> 円
               </td>
            </tr>
            <tr>
               <th>詳細説明</th>
               <td colspan="5"><textarea id="board"
                     style="width: 98%; height: 200px;" name="" >${product.content}</textarea></td>
            </tr>
            <tr>
               <th>商品イメージ</th>
               <td colspan="5" id="imageinput"><input type="file"
                  name="uploadfile" id="uploadfile" multiple>
               <p style="color: red">写真は最大4個までできます</p></td>

            </tr>
            <tr>
               <th>販売位置</th>
               <td colspan="5">

                  <div class="map_wrap">

                     <div id="map"
                        style="width: 100%; height: 100%; position: relative; overflow: hidden;"></div>

                     <div id="menu_wrap" class="bg_white">
                        <div class="option">
                           <div>
                              <form onsubmit="searchPlaces(); return false;">
                                 キーワード : <input type="text" value="" id="keyword" size="15">
                                 <button type="submit">検索</button>
                              </form>
                           </div>
                        </div>
                        <hr>
                        <ul id="placesList"></ul>
                        <div id="pagination"></div>
                     </div>

                     <div>
                  <input type="hidden" id="t1" name="lat" value="${product.lat}"> 
                  <input type="hidden" id="t2" name="lng" value="${product.lng}">
               </div>

 
                  </div>

               </td>
            </tr>
         </table>
      </div>

      <div class="text-center">
         <input type="button" id="update" value="登録" class="btn btn-success">
         <input type="reset" value="キャンセル" class="btn btn-warning">
      </div>
   </div>
</div>
<!-- Product upload End -->

<script>

var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
mapOption = {
    center: new kakao.maps.LatLng(document.getElementById('t1').value, document.getElementById('t2').value), // 지도의 중심좌표
    level: 3 // 지도의 확대 레벨
};  

//마커를 담을 배열입니다
var markers = [];

window.addEventListener("load", init);

function init() {
   window.navigator.geolocation.getCurrentPosition(current_position);
}

function current_position(position) {

    var lat = document.getElementById('t1').value, // 위도 -> 이거 저장된 위치로 바꾸면 됨
     lon = document.getElementById('t2').value; // 경도  -> 이거 저장된 위치로 바꾸면 됨
 
    var locPosition = new kakao.maps.LatLng(lat, lon);

    map.setCenter(locPosition);

    swap(locPosition);
    
}

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

               document.getElementById('t1').value = marker.getPosition().getLat();
               document.getElementById('t2').value = marker.getPosition().getLng();
            
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