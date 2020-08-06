<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="kissco.store.jp.model.*"%>
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />

<%
	ProductVO product = (ProductVO) request.getAttribute("product");
	String[] images = product.getPhotopath().split(",");
	int userID = 0;
	if(request.getAttribute("user_no") !=null){
		userID = (int) request.getAttribute("user_no");
	}
%>

<script>
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");

	$(document).ready(function() {

		var userUser_no = ${user_no};
		var productUser_no = ${product.user_no};
		console.log(userUser_no);
		console.log(productUser_no);
		
		$("#productUpdate").html('');
		if(userUser_no==productUser_no){
			var html = '<span> <a class="cart-btn btn-default" href="/product/update?product_no='+${product.product_no}+'">'+
				'<i class="fa fa-pencil-square" aria-hidden="true"></i> 商品修正</a></span>'+
				'<span> <a class="cart-btn btn-default" href="javascript:void(0)" onclick="deleteProduct('+${product.product_no}+')">'+
				'<i class="fa fa-trash-o" aria-hidden="true"></i> 商品削除</a></span>';
				
			
			$("#productUpdate").append(html); 
		}else{
			
			var html = '<a class="cart-btn btn-default" href="javascript:void(0)"'
						+' onclick="sendAddWishList('+'${product.product_no}'+')">'
						+' <i class="fa fa-heart-o"></i> 買いたい物に追加 </a>';
			$("#productUpdate").append(html); 
		}
		
		commentList();
	});

	function updateComment() {

		var comment_no = $("#comment-no").attr("comment_no");
		var content = $("#update-input").val();

		$.ajax({
			url : "/comment/update",
			type : "POST",
			dataType : 'json',
			data : {
				comment_no : comment_no,
				content : content
			},
			beforeSend : function(xhr) {
				xhr.setRequestHeader(header, token);
			},
			success : function(data, status, xhr) { // alertify or another welcome page 이동
				if (data) {
					alertify.notify('コメントが修正されました', 'success');
					commentList();
				} else {
					alertify.notify('コメントが修正されません', 'error');
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alertify.notify('コメントの登録に問題があります', 'error', 3, function() {
					console.log(jqXHR.responseText);
				});
			}
		});

	}

	function commentList() {

		var product_no = <%=product.getProduct_no()%>;

		$.ajax({
			url : "/comment/list",
			type : "POST",
			dataType : 'json',
			data : {
				product_no : product_no
			},
			beforeSend : function(xhr) {
				xhr.setRequestHeader(header, token);
			},
			success : function(data, status, xhr) { // alertify or another welcome page 이동
				makeComment(data);
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alertify.notify('コメントのリストに問題があります', 'error', 3, function() {
					console.log(jqXHR.responseText);
				});
			}
		});
	}

	function makeComment(data) {

		$("#comments").html('<hr class="ruleLine">');
		if (data != null) {
			for (var i = 0; i < data.length; i++) {

				var comment_no = data[i].comment_no;
				var user_no = data[i].user_no;
				var content =  data[i].content;
				var board = "'" + data[i].content + "'";
				var date = data[i].date;
				var nickname = data[i].nickname;
				var commentNickname = "'" + data[i].nickname + "'";

				if ( <%=userID%> == user_no) {
					var listHtml = '<div><div><p><b>'
							+ nickname
							+ '</b></p></div><div><p>'
							+ content
							+ '</p>'
							+ '<a href="javascript:void(0)" onclick="deleteComment('
							+ comment_no
							+ ')" style="background:#f99fff;border-radius:15px;border:1px solid #f99fff;padding: 3px 7px;'
							+'><i aria-hidden="true"></i></i>Delete</a>   '
							+ '<a href="javascript:void(0)" onclick="updateCommentInput('
							+ board
							+ ','
							+ comment_no
							+ ')" style="background:#f99fff;border-radius:15px;border:1px solid #f99fff;padding: 3px 7px;"></i></i>Update</a>'
							+ '</div><br><p>'
							+ date
							+ '</p><div id="comment_no'+comment_no+'"></div><hr class="ruleLine">';
					$("#comments").append(listHtml);
				} else {
					var listHtml = '<div><div onclick="uploadRecomment('
							+ nickname
							+ ')"><p><b>'
							+ nickname
							+ '</b></p></div><div><p>'
							+ content
							+ '</p><div><a href="javascript:void(0)" onclick="replyComment('
							+ commentNickname
							+ ','
							+ comment_no
							+ ')" style="background:#f99fff;border-radius:15px;border:1px solid #f99fff;padding: 3px 7px;'
							+'><i aria-hidden="true"></i>reply</a></div></div><br><p>'
							+ date
							+ '</p></div><div id="comment_no'+comment_no+'"></div><hr class="ruleLine">';
					$("#comments").append(listHtml);
				}
			}
		}
	}

	function deleteComment(comment_no) {

		$.ajax({
			url : "/comment/delete",
			type : "POST",
			dataType : 'json',
			data : {
				comment_no : comment_no
			},
			beforeSend : function(xhr) {
				xhr.setRequestHeader(header, token);
			},
			success : function(data, status, xhr) { // alertify or another welcome page 이동

				if (data) {
					alertify.success('コメントが削除されました');
					commentList();
				} else {
					alertify.error('コメントが削除されません');
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alertify.notify('コメントの削除に問題があります', 'error', 3, function() {
					console.log(jqXHR.responseText);
				});
			}
		});

	}

	function replyComment(commentNickname, comment_no) {

		var tag = '@' + commentNickname;
		var html = '<div></div>'
				+ '<textarea id="reply-input" style="width: 98%; height: 50px;" name="content"></textarea><button '
				+ 'onclick="replyCommentUpload()" '
				+ 'style="background:#f99fff; border-radius:15px; border:1px solid #f99fff; padding: 3px 7px;"'
				+ '>Insert</button><button onclick="cancelComment('
				+ comment_no + ')" style="background:#f99fff; border-radius:15px; border:1px solid #f99fff; padding: 3px 7px;"'
				+'>Cancle</button>';

		//div에 값이 없으면 클릭 안하도록.
		$("#comment_no" + comment_no + "").append(html);

		$('#reply-input').focus();
		$('#reply-input').val(tag);

	}

	function updateCommentInput(board, comment_no) {

		console.log(board);

		var html = '<div comment_no="'+comment_no+'"  id="comment-no"></div>'
				+ '<textarea id="update-input" style="width: 98%; height: 50px;" name="content"></textarea><button '
				+ 'onclick="updateComment()" style="background:#f99fff; border-radius:15px; border:1px solid #f99fff;'
				+' padding: 3px 7px; color:#ffffff;     font-family: hanazome;"'
				+'>Confirm</button><button onclick="cancelComment('
				+ comment_no + ')" style="background:#f99fff; border-radius:15px; border:1px solid #f99fff; padding: 3px 7px;"'
				+'>Cancle</button>';

		$("#comment_no" + comment_no + "").append(html);

		$('#update-input').focus();
		$('#update-input').val(board);

	}

	function cancelComment(comment_no) {
		$("#comment_no" + comment_no + "").html("");
	}

	function uploadRecomment(nickname) {
		var comment = "comment" + comment_no;
		console.log(comment);
	}

	function replyCommentUpload() {

		var product_no = <%=product.getProduct_no()%>;
		var content = $("#reply-input").val();

		$.ajax({
			url : "/comment/upload",
			type : "POST",
			dataType : 'json',
			data : {
				product_no : product_no,
				content : content
			},
			beforeSend : function(xhr) {
				xhr.setRequestHeader(header, token);
			},
			success : function(data, status, xhr) { // alertify or another welcome page 이동
				if (data) {
					$("#comment-input").val('');
					alertify.success('コメントが登録されました');
					commentList();

				} else {
					alertify.notify('コメントが登録されません', 'error');
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alertify.notify('ログインしてください。', 'error', 3, function() {
					console.log(jqXHR.responseText);
				});
			}
		});

	}

	   function uploadComment() {

	      var product_no = <%=product.getProduct_no()%>;
	      var content = $("#comment-input").val();
	      console.log("content: "+content); 
	      if(content.trim().length!=0){ 
	         
	         $.ajax({
	            url : "/comment/upload",
	            type : "POST",
	            dataType : 'json',
	            data : {
	               product_no : product_no,
	               content : content
	            },
	            beforeSend : function(xhr) {
	               xhr.setRequestHeader(header, token);
	            },
	            success : function(data, status, xhr) { // alertify or another welcome page 이동
	               if (data) {
	                  $("#comment-input").val('');
	                  alertify.success('コメントが登録されました');
	                  commentList();
	                  sendAlarm();
	               } else {
	                  alertify.notify('コメントが登録されません', 'error');
	               }
	            },
	            error : function(jqXHR, textStatus, errorThrown) {
	               alertify.notify('ログインしてください。', 'error', 3, function() {
	                  console.log(jqXHR.responseText);
	               }); 
	            }
	         });
	         
	      }else{
	         alertify.notify('コメントを入力してください', 'error');
	         $("#comment-input").focus();
	      }
   }
	
	function sendAlarm(){
		console.log('sendAlarm()');
		$.ajax({
			url : "/user/alarm/add",
			type : "POST",
			dataType : 'json',
			data : {
				product_no : <%=product.getProduct_no()%>,
				user_no : <%=product.getUser_no()%>
			},
			beforeSend : function(xhr) {
				xhr.setRequestHeader(header, token);
			},
			success : function(data, status, xhr) { // alertify or another welcome page 이동
				if (data) {
					console.log('알림 추가 성공');
				} else {
					alertify.notify('コメントが登録されません', 'error');
					console.log('알침 추가 실패')
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alertify.notify('コメントの登録に問題があります', 'error', 3, function() {
					console.log(jqXHR.responseText);
				});
			}
		});
	}
	
	function sendAddWishList(product_no){
		$.ajax({
			url : "/product/wishList/add",
			type : "GET",
			dataType : 'json',
			data : {
				product_no : product_no
			},
			beforeSend : function(xhr) {
				//xhr.setRequestHeader("ApiKey", "asdfasxdfasdfasdf");
				xhr.setRequestHeader("AJAX", true);
			},
			success : function(data, status, xhr) { // alertify or another welcome page 이동
				var check = data;
				if(check){
					alertify.notify('wishlistに追加できました。', 'あちこち');
				}else{
					alertify.notify('wishlistにあります。', 'あちこち');
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alertify.notify('ログインしてください。', 'あちこち');
			}
		});
	}
	
   function deleteProduct(product_no){

      console.log(product_no);
      if (confirm("削除しますか。") == true){
         $.ajax({ 
            url : "/product/delete",
            type : "POST",
            dataType : 'json',
            data : {
               product_no: product_no
            },
            beforeSend : function(xhr) {
               xhr.setRequestHeader(header, token);
            },
            success : function(data, status, xhr) { // alertify or another welcome page 이동
               if (data) {
                  alert('コメントが削除されました', 'success');
                  window.location.href = "/shop?page=0&word=&category_no=0";
               } else {
                  alertify.notify('コメントが削除されません', 'error');
               }
            },
            error : function(jqXHR, textStatus, errorThrown) {
               alertify.notify('コメントの削除に問題があります', 'error', 3, function() {
                  console.log(jqXHR.responseText);
               });
            }
         });
       }
   }
</script>

<!-- Breadcrumbs Area Start -->
<!-- Single Product Area Start -->
<div class="single-product-area section-padding">
	<div class="container">
		<div class="row">
			<div class="col-md-6 col-sm-7">
				<div class="slider-area">
					<div class="bend niceties preview-1">
						<div id="ensign-nivoslider" class="slides">
							<%
								for (int i = 0; i < images.length; i++) {
							%>
							<img src="<%=images[i]%>" alt="" title="#slider-direction-1"
								style="width: 570px; height: 550px; overflow: hidden" />
							<%
								}
							%>
						</div>
					</div>
				</div>
			</div>
			<div class="col-md-6 col-sm-5">
				<div class="single-product-details">
					<h2>${product.title}</h2>
					<div class="single-product-price">
						<h2>${product.price}円</h2>
					</div>
					<p>販売者 ：${user.nickname}</p>
					<div class="product-attributes clearfix" id="productUpdate">
						<span> 
							<a class="cart-btn btn-default" href="javascript:void(0)" onclick="sendAddWishList(${product.product_no})"> 
								<i class="fa fa-heart-o"></i> 買いたい物に追加
							</a>
						</span>
					</div>
					<div class="add-to-wishlist"></div>
					<div class="single-product-categories">
						<label>カテゴリ:</label> <span>${category}</span>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-9-1">
				<div class="p-details-tab-content resize">
					<div class="p-details-tab">
						<ul class="p-details-nav-tab" role="tablist">
							<li role="presentation" class="active"><a href="#more-info"
								aria-controls="more-info" role="tab" data-toggle="tab">詳細説明</a></li>
							<li role="presentation"><a href="#reviews"
								aria-controls="reviews" role="tab" data-toggle="tab">コメント</a></li>
						</ul>
					</div>
					<div class="clearfix"></div>
					<div class="tab-content review">
						<div role="tabpanel" class="tab-pane active" id="more-info">
							<p>${product.content}</p>
							<div class="row">
								<div class="map_wrap">
									<div id="map"
										style="width: 100%; height: 100%; position: relative; overflow: hidden;"></div>
								</div>
							</div>
						</div>
						<div role="tabpanel" class="tab-pane" id="reviews">
							<div id="product-comments-block-tab">
								<div id="form-commentInfo">
									<div id="comment-count">
										コメント <span id="count">0</span>
									</div>
									<textarea class="textarea-1" id="comment-input"
										style="width: 98%; height: 100px;" name="content"></textarea>
									<button onclick="uploadComment()" class="commentBtn">コメントを書く</button>
								</div>
								<div id=comments>
									<hr class="ruleLine">
									<div>
										<div>
											<p>
												<b>천호영</b>
											</p>
										</div>
										<div>
											<p>혹시 직거래 가능 하신가요...??</p>
											<i class="fas fa-reply" id="floatright">reply</i>
										</div>
										<br>
										<p>2020-07-04</p>
									</div>
									<hr class="ruleLine">
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

	</div>
</div>

<script>
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	mapOption = {
		center : new kakao.maps.LatLng( <%=product.getLat()%> , <%=product.getLng()%> ), // 지도의 중심좌표
		level : 3
	// 지도의 확대 레벨
	};

	//마커를 담을 배열입니다
	var markers = [];
	// 지도를 생성합니다    
	var map = new kakao.maps.Map(mapContainer, mapOption);

	// 장소 검색 객체를 생성합니다
	var ps = new kakao.maps.services.Places();

	// 검색 결과 목록이나 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성합니다
	var infowindow = new kakao.maps.InfoWindow({
		zIndex : 1
	});

	//주소-좌표 변환 객체를 생성합니다
	var geocoder = new kakao.maps.services.Geocoder();

	//지도를 클릭한 위치에 표출할 마커입니다
	var markerr = new kakao.maps.Marker({
		// 지도 중심좌표에 마커를 생성합니다 
		position : map.getCenter()
	});
	// 지도에 마커를 표시합니다
	markerr.setMap(map);

	function searchAddrFromCoords(coords, callback) {
		// 좌표로 행정동 주소 정보를 요청합니다
		geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback);
	}

	function searchDetailAddrFromCoords(coords, callback) {
		// 좌표로 법정동 상세 주소 정보를 요청합니다
		geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
	}
</script>
