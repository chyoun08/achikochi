<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
	$(document).ready(function() {
		updateAlarm();
		sendCreateCategoryMenu();
	});
	
	function updateAlarm(){
		setInterval(sendAlarmList, 500);
	}
	
	function sendAlarmList(){
		console.log('updateAlarm');
		$.ajax({
			url : "/user/alarm/list",
			type : "GET",
			dataType : 'json',
			beforeSend : function(xhr) {
				//xhr.setRequestHeader("ApiKey", "asdfasxdfasdfasdf");
				xhr.setRequestHeader("AJAX", true);
			},
			success : function(data, status, xhr) { // alertify or another welcome page 이동
				createAlarmList(data);
			},
			error : function(jqXHR, textStatus, errorThrown) {
				console.log("AlarmList 에러");
			}
		});
	}
	
	function createAlarmList(alarmList){
		var alarmsCount=0;
		var user_no=0;
		for(var i=0;i<alarmList.length;i++){
			if(alarmList[i].alarm>0)
				alarmsCount++;
		}
		$("#alarm_cart").html("");
		var alarmProduct = '';
		alarmProduct += '<a href="#">'
					+'<i class="fa fa-bell-o" aria-hidden="true"></i>'
					+'<span>'+alarmsCount+'</span></a>';
		alarmProduct += '<div class="add-to-cart-product">';
		for(var i=0;i<alarmList.length;i++){
			var product_no = alarmList[i].product_no;
			var sumnail = alarmList[i].sumnail;
			user_no = alarmList[i].user_no;
			var nickname = alarmList[i].nickname;
			var title = alarmList[i].title;
			var price = alarmList[i].price;
			var alarm = alarmList[i].alarm;
			if(alarm>0){
				alarmProduct += '<div class="cart-product">'
							+ '<div class="cart-product-image">'
							+ '<a href="/product/detail?product_no='+product_no+'">'
							+ '<img src="'+sumnail+'" alt=""> '
							+ '</a>'
							+ '</div>'
							+ '<div class="cart-product-info">'
							+'<p><a href="/product/detail?product_no='+product_no+'">'+title+'</a></p>'
							+'<a href="/product/detail?product_no='+product_no+'">'+nickname+'</a>' 
							+'<span class="cart-price">'+price+'円</span></div>'
							+'<span style="background: #f99fff none repeat scroll 0 0; border-radius: 50%;'
						    +'color: #ffffff; font-size: 12px; height: 19px; line-height: 19px;'
						    +' bottom: 15px; right: 90px;'
						    +' position: absolute; text-align: center; width: 19px;">'+alarm+'</span>'
							+'<div class="cart-product-remove">'
							+'<a href="javascript:void(0)" onclick="sendDeleteAlarm('+product_no+')">'
							+'<i class="fa fa-times"></i></a></div></div>';
			}
		}
		alarmProduct += '<div class="cart-checkout">'
					+'<a href="javascript:void(0)" onclick="sendDeleteAlaramALL('+user_no+')">'
					+' Check out<i class="fa fa-chevron-right"></i></a>'
					+'</div>'+'</div>';
		
		$("#alarm_cart").append(alarmProduct);
	}
	
	function sendDeleteAlarm(product_no){
		$.ajax({
			url : "/user/alarm/delete",
			type : "GET",
			dataType : 'json',
			data: {
				product_no : product_no
			},
			beforeSend : function(xhr) {
				//xhr.setRequestHeader("ApiKey", "asdfasxdfasdfasdf");
				xhr.setRequestHeader("AJAX", true);
			},
			success : function(data, status, xhr) { // alertify or another welcome page 이동
				var check = data;
				if(check){
					sendAlarmList();
					alertify.notify('alarmlistが削除できました。', 'あちこち');
				} else{
					console.log('삭제실패');
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				console.log("AlarmList 에러");
			}
		});
	}
	
	function sendDeleteAlaramALL(user_no){
		$.ajax({
			url : "/user/alarm/deleteALL",
			type : "GET",
			dataType : 'json',
			data: {
				user_no : user_no
			},
			beforeSend : function(xhr) {
				//xhr.setRequestHeader("ApiKey", "asdfasxdfasdfasdf");
				xhr.setRequestHeader("AJAX", true);
			},
			success : function(data, status, xhr) { // alertify or another welcome page 이동
				createAlarmList(data);
			},
			error : function(jqXHR, textStatus, errorThrown) {
				console.log("AlarmList 에러");
			}
		});
	}
	
	function sendCreateCategoryMenu() {
		$.ajax({
			url : "/product/category",
			type : "GET",
			dataType : 'json',
			beforeSend : function(xhr) {
				//xhr.setRequestHeader("ApiKey", "asdfasxdfasdfasdf");
				xhr.setRequestHeader("AJAX", true);
			},
			success : function(data, status, xhr) { // alertify or another welcome page 이동
				createCategoryMenu(data);
			},
			error : function(jqXHR, textStatus, errorThrown) {
				console.log("ListByCategory 에러");
			}
		});
	}
	
	function createCategoryMenu(category) {
		$("#category_sub_menu").html("");
		var categoryDIV = '';
		for (var i = 0; i < category.length; i++) {
			var category_no = category[i].category_no;
			var category_title = category[i].category_title;
			categoryDIV = categoryDIV
					+ '<li><a href="/shop?page=0&word=&category_no='+category_no+'">'
					+ category_title
					+ '</a></li>';
		}
		categoryDIV = categoryDIV + '</ul>';
		$("#category_sub_menu").append(categoryDIV);
	}
</script>
<!-- New UI -->

<!--Header Area Start-->
<div class="header-area">
	<div class="container">
		<div class="row">
			<div class="col-md-2 col-sm-6 col-xs-6">
				<div class="header-logo">
					<a href="/"> 
						<img src="<c:url value="/resources/img/logo.png"/>" alt="">
					</a>
				</div>
			</div>

			<div class="col-md-9 col-sm-12 hidden-xs">
				<div class="mainmenu text-center">
					<nav>
						<ul id="nav">
							<li><a href="/">ホーム</a></li>
							<c:if test="${pageContext.request.userPrincipal.name != null}">
							<li><a href="/product/upload">商品登録</a></li>
							</c:if>
							<li><a href="/shop?page=0&word=&category_no=0">商品検索</a>
								<ul class="sub-menu" id="category_sub_menu">
									<li><a href="#">ファッション衣類 ・ 雑貨</a></li>
									<li><a href="#">化粧品</a></li>
									<li><a href="#">キッチン用品</a></li>
									<li><a href="#">生活用品</a></li>
									<li><a href="#">ホームインテリア</a></li>
									<li><a href="#">家電 ・ デジタル</a></li>
									<li><a href="#">スポーツ ・ レジャー</a></li>
									<li><a href="#">自動車用品</a></li>
									<li><a href="#">図書 ・ レコード ・ DVD</a></li>
									<li><a href="#">玩具 ・ 趣味</a></li>
									<li><a href="#">文具 ・ オフィス</a></li>
									<li><a href="#">ペット用品</a></li>
									<li><a href="#">その他</a></li>
								</ul>
							</li>
							<li><a href="/question">よくある質問</a></li>
							<li><a href="/about">あちこちについて</a></li>
							<c:if test="${pageContext.request.userPrincipal.name != null}">
							<li><a href="/user/userInfo">マイページ</a></li>
							</c:if>
						
						</ul>
					</nav>
				</div>
			</div>
			<div class="col-md-1 hidden-sm">
				<div class="header-right">
					<ul>
						<c:choose>
						<c:when test="${pageContext.request.userPrincipal.name == null}">
							<li><a href="/login"><i class="flaticon-people"></i></a></li>
						</c:when>
						
						<c:when test="${pageContext.request.userPrincipal.name != null}">
							<li class="nav-item">
							<a class="nav-link" href="javascript:document.getElementById('logout').submit()"><i class="fa fa-sign-out" aria-hidden="true"></i></a>
							</li>
							<li class="shoping-cart" id="alarm_cart">
								<a href="#"> 
									<i class="fa fa-bell-o" aria-hidden="true"></i> <span>2</span>
								</a>
								<div class="add-to-cart-product">
									<div class="cart-product">
										<div class="cart-product-image">
											<a href="/product/detail">
												<img src="<c:url value="/resources/img/shop/1.jpg"/>" alt=""> 
											</a>
										</div>
										<div class="cart-product-info">
											<p>
												<span>1</span> x <a href="single-product.html">East of eden</a>
											</p>
											<a href="single-product.html">S, Orange</a> 
											<span class="cart-price">$ 140.00</span>
										</div>
										<div class="cart-product-remove">
											<i class="fa fa-times"></i>
										</div>
									</div>
									<div class="cart-checkout">
										<a href="#"> Check out 
											<i class="fa fa-chevron-right"></i>
										</a>
									</div>
								</div>
							</li>
						</c:when>
						</c:choose>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
<form id="logout" action="<c:url value="/logout"/>" method="post">
		                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
		                     </form>
<!--Header Area End-->

<!-- Mobile Menu Start -->
<div class="mobile-menu-area">
	<div class="container">
		<div class="row">
			<div class="col-lg-12 col-md-12 col-sm-12">
				<div class="mobile-menu">
					<nav id="dropdown">
						<ul>
							<li><a href="/">ホーム</a></li>
							<li><a href="/product/upload">商品登録</a></li>
							<li><a href="/shop">商品検索</a>
								<ul class="sub-menu">
									<li><a href="#">ファッション衣類 ・ 雑貨</a></li>
									<li><a href="#">化粧品</a></li>
									<li><a href="#">キッチン用品</a></li>
									<li><a href="#">生活用品</a></li>
									<li><a href="#">ホームインテリア</a></li>
									<li><a href="#">家電 ・ デジタル</a></li>
									<li><a href="#">スポーツ ・ レジャー</a></li>
									<li><a href="#">自動車用品</a></li>
									<li><a href="#">図書 ・ レコード ・ DVD</a></li>
									<li><a href="#">玩具 ・ 趣味</a></li>
									<li><a href="#">文具 ・ オフィス</a></li>
									<li><a href="#">ペット用品</a></li>
									<li><a href="#">その他</a></li>
								</ul></li>
							<li><a href="/question">よくある質問</a></li>
							<li><a href="/about">あちこちについて</a></li>
						</ul>
					</nav>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- Mobile Menu End -->
