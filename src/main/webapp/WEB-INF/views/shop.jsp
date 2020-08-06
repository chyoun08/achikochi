<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
	var totalSize = 0;
	var SearchWORD = "";
	var currentPage = <%=request.getParameter("page")%>;
	var totalCnt = 0;
	var currentCategory_no = <%=request.getParameter("category_no")%>; 
	var minPrice = 0;
	var maxPrice = 10000; 
	var currentSort = 'p.date DESC';

	$(document).ready(function() {
 
		sendCreateCategoryMenu();

		$("#searchWordText").keydown(function() {
			if (event.keyCode === 13) {
				$("#search_btn").click();
			}
		});

		$("#search_btn").click(function(e) {

			SearchWORD = $("#searchWordText").val();
			currentSort = $("#selectBySort option:selected").val();

			if (currentCategory_no == 0) {
				sendCreateProductListALL();
			} else {
				sendCreateProductListByCategory(currentCategory_no);
			}
		});

		$("#searchPrice").click(function(e) {

			minPrice = $("#slider-range").slider("values", 0);
			maxPrice = $("#slider-range").slider("values", 1);

			if (currentCategory_no == 0) {
				sendCreateProductListALL();
			} else {
				sendCreateProductListByCategory(currentCategory_no);
			}
		});

		if (currentCategory_no == 0) {
			sendCreateProductListALL();
		} else {
			sendCreateProductListByCategory(currentCategory_no);
		}
	});

	function changeSelectBySort() {
		currentSort = $("#selectBySort option:selected").val();

		if (currentCategory_no == 0) {
			sendCreateProductListALL();
		} else {
			sendCreateProductListByCategory(currentCategory_no);
		}
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
		$("#_category").html("");
		$("#_category").append(
				'<h2 class="sidebar-title text-center">カテゴリ</h2>');
		var categoryDIV = '<ul class="sidebar-menu">';
		for (var i = 0; i < category.length; i++) {
			var category_no = category[i].category_no;
			var category_title = category[i].category_title;
			categoryDIV = categoryDIV
					+ '<li>'
					+ '<a href="javascript:void(0)" onclick="sendCreateProductListByCategory('
					+ category_no + ')">'
					+ '<i class="fa fa-angle-double-right"></i>'
					+ category_title + '</a>' + '</li>';
		}
		categoryDIV = categoryDIV + '</ul>';
		$("#_category").append(categoryDIV);
	}

	function sendCreateProductListALL() {
		
		currentPage = 0;
		//sendAmountALL();

		$.ajax({
			url : "/product/listALL",
			type : "GET",
			dataType : 'json',
			data : {
				word : SearchWORD,
				min : minPrice,
				max : maxPrice,
				p_sort : currentSort,
				page : currentPage
			},
			beforeSend : function(xhr) {
				//xhr.setRequestHeader("ApiKey", "asdfasxdfasdfasdf");
				xhr.setRequestHeader("AJAX", true);
			},
			success : function(data, status, xhr) { // alertify or another welcome page 이동
				createProductListALL(data);
				sendtotalCnt();
			},
			error : function(jqXHR, textStatus, errorThrown) {
				console.log("ListByCategory 에러");
			}
		});
	}
	
	function sendCreateProductListALLAndPage() {

		//sendAmountALL();

		$.ajax({
			url : "/product/listALL",
			type : "GET",
			dataType : 'json',
			data : {
				word : SearchWORD,
				min : minPrice,
				max : maxPrice,
				p_sort : currentSort,
				page : currentPage
			},
			beforeSend : function(xhr) {
				//xhr.setRequestHeader("ApiKey", "asdfasxdfasdfasdf");
				xhr.setRequestHeader("AJAX", true);
			},
			success : function(data, status, xhr) { // alertify or another welcome page 이동
				createProductListALL(data);
				sendtotalCnt();
			},
			error : function(jqXHR, textStatus, errorThrown) {
				console.log("ListByCategory 에러");
			}
		});
	}

	function createProductListALL(productList) {
		$("#_product_area").html("");
		for (var i = 0; i < productList.length; i++) {
			var product_no = productList[i].product_no;
			var title = productList[i].title;
			var price = productList[i].price;
			var sumnail = productList[i].sumnail;
			var productHtml = '<div class="col-md-4 col-sm-6">'
					+ '<div class="single-banner">'
					+ '<div class="product-wrapper">'
					+ '<a href="/product/detail?product_no='
					+ product_no
					+ '" class="single-banner-image-wrapper">'
					+ '<img alt="" src="'+sumnail+'" style="width: 260.48px;height:270.13px;">'
					+ '<div class="price">'
					+ price
					+ '<span>円</span>'
					+ '</div>'
					+ '</a>'
					+ '<div class="product-description">'
					+ '<div class="functional-buttons">'
					+ '<a href="javascript:void(0)" onclick="sendAddWishList('+product_no+')" title="買いたい物に追加"> '
					+ '<i class="fa fa-heart-o"></i>'
					+ '</a>'
					+ '</div>'
					+ '</div>'
					+ '</div>'
					+ '<div class="banner-bottom text-center">'
					+ '<div class="banner-bottom-title">'
					+ '<a href="/product/detail?product_no='
					+ product_no
					+ '" style="overflow: hidden;height: 20px;" >'
					+ title
					+ '</a>'
					+ '</div>'
					+ '</div>'
					+ '</div>'
					+ '</div>';
			$("#_product_area").append(productHtml);
		}
	}

	function sendCreateProductListByCategory(_category_no) {

		currentCategory_no = _category_no;
		currentPage = 0;
		//sendAmountByCategory();

		$.ajax({
			url : "/product/listByCategory",
			type : "GET",
			dataType : 'json',
			data : {
				category_no : currentCategory_no,
				word : SearchWORD,
				min : minPrice,
				max : maxPrice,
				p_sort : currentSort,
				page : currentPage
			},
			beforeSend : function(xhr) {
				//xhr.setRequestHeader("ApiKey", "asdfasxdfasdfasdf");
				xhr.setRequestHeader("AJAX", true);
			},
			success : function(data, status, xhr) { // alertify or another welcome page 이동
				createProductListByCategory(data);
				sendtotalCntByCategory();
			},
			error : function(jqXHR, textStatus, errorThrown) {
				console.log("ListByCategory 에러");
			}
		});
	}
	
	function sendCreateProductListByCategoryAndPage(_category_no) {

		currentCategory_no = _category_no;
		//sendAmountByCategory();

		$.ajax({
			url : "/product/listByCategory",
			type : "GET",
			dataType : 'json',
			data : {
				category_no : currentCategory_no,
				word : SearchWORD,
				min : minPrice,
				max : maxPrice,
				p_sort : currentSort,
				page : currentPage
			},
			beforeSend : function(xhr) {
				//xhr.setRequestHeader("ApiKey", "asdfasxdfasdfasdf");
				xhr.setRequestHeader("AJAX", true);
			},
			success : function(data, status, xhr) { // alertify or another welcome page 이동
				createProductListByCategory(data);
				sendtotalCntByCategory();
			},
			error : function(jqXHR, textStatus, errorThrown) {
				console.log("ListByCategory 에러");
			}
		});
	}

	function createProductListByCategory(productListByCategory) {
		$("#_product_area").html("");
		for (var i = 0; i < productListByCategory.length; i++) {
			var product_no = productListByCategory[i].product_no;
			var title = productListByCategory[i].title;
			var price = productListByCategory[i].price;
			var sumnail = productListByCategory[i].sumnail;

			var productHtml = '<div class="col-md-4 col-sm-6">'
					+ '<div class="single-banner">'
					+ '<div class="product-wrapper">'
					+ '<a href="/product/detail?product_no='
					+ product_no
					+ '" class="single-banner-image-wrapper">'
					+ '<img alt="" src="'+sumnail+'" style="width:260.48px; height:270.13px;">'
					+ '<div class="price">'
					+ price
					+ '<span>円</span>'
					+ '</div>'
					+ '</a>'
					+ '<div class="product-description">'
					+ '<div class="functional-buttons">'
					+ '<a href="javascript:void(0)" onclick="sendAddWishList('+product_no+')" title="買いたい物に追加"> '
					+ '<i class="fa fa-heart-o"></i>'
					+ '</a>'
					+ '</div>'
					+ '</div>'
					+ '</div>'
					+ '<div class="banner-bottom text-center">'
					+ '<div class="banner-bottom-title">'
					+ '<a href="/product/detail?product_no='
					+ product_no
					+ '" style="overflow: hidden;height: 20px;" >'
					+ title
					+ '</a>' + '</div>' + '</div>' + '</div>' + '</div>';
			$("#_product_area").append(productHtml);
		}
	}

	function sendtotalCnt() {
		$.ajax({
			url : "/product/totalCnt",
			type : "GET",
			dataType : 'json',
			data : {
				word : SearchWORD
			},
			beforeSend : function(xhr) {
				//xhr.setRequestHeader("ApiKey", "asdfasxdfasdfasdf");
				xhr.setRequestHeader("AJAX", true);
			},
			success : function(data, status, xhr) { // alertify or another welcome page 이동
				totalCnt = data;
				createPagination();
			},
			error : function(jqXHR, textStatus, errorThrown) {
				console.log("ListByCategory 에러");
			}
		});
	}

	function sendtotalCntByCategory() {
		$.ajax({
			url : "/product/totalCntByCategory",
			type : "GET",
			dataType : 'json',
			data : {
				category_no : currentCategory_no,
				word : SearchWORD
			},
			beforeSend : function(xhr) {
				//xhr.setRequestHeader("ApiKey", "asdfasxdfasdfasdf");
				xhr.setRequestHeader("AJAX", true);
			},
			success : function(data, status, xhr) { // alertify or another welcome page 이동
				totalCnt = data;
				createPagination();
			},
			error : function(jqXHR, textStatus, errorThrown) {
				console.log("ListByCategory 에러");
			}
		});
	}

	function sendAmountALL() {

		$.ajax({
			url : "/product/priceALL",
			type : "GET",
			dataType : 'json',
			beforeSend : function(xhr) {
				//xhr.setRequestHeader("ApiKey", "asdfasxdfasdfasdf");
				xhr.setRequestHeader("AJAX", true);
			},
			success : function(data, status, xhr) { // alertify or another welcome page 이동
				minPrice = data[0];
				maxPrice = data[1];
			},
			error : function(jqXHR, textStatus, errorThrown) {
				console.log("ListByCategory 에러");
			}
		});
	}

	function sendAmountByCategory() {

		$.ajax({
			url : "/product/priceByCategory",
			type : "GET",
			dataType : 'json',
			data : {
				category_no : currentCategory_no
			},
			beforeSend : function(xhr) {
				//xhr.setRequestHeader("ApiKey", "asdfasxdfasdfasdf");
				xhr.setRequestHeader("AJAX", true);
			},
			success : function(data, status, xhr) { // alertify or another welcome page 이동
				minPrice = data[0];
				maxPrice = data[1];
			},
			error : function(jqXHR, textStatus, errorThrown) {
				console.log("ListByCategory 에러");
			}
		});
	}

	function createPagination() {
		var totalPage = parseInt(totalCnt / 9);
		if (totalCnt % 9 != 0)
			totalPage++;
		var sort_page = currentPage;

		$("#paginationDIV").html("");
		var pagingHtml = "";
		if (currentPage >= 3) {
			pagingHtml += '<a href="javascript:void(0)" onclick=';
			if (currentCategory_no == 0)
				pagingHtml = pagingHtml + '"sendCurrentPage(0)">';
			if (currentCategory_no != 0)
				pagingHtml = pagingHtml + '"sendCurrentPageByCategory(0)">';
			pagingHtml += '1</a>'
			if (currentPage > 3)
				pagingHtml += '<a>...</a>';
		}

		for (var i = sort_page - 2; i < sort_page + 3; i++) {
			var _page = i;
			var _ppage = i + 1;
			if (_ppage > 0 && totalPage >= _ppage) {
				pagingHtml = pagingHtml + '<a href="javascript:void(0)" onclick=';
				if (currentCategory_no == 0)
					pagingHtml = pagingHtml + '"sendCurrentPage(' + _page
							+ ')"';
				if (currentCategory_no != 0)
					pagingHtml = pagingHtml + '"sendCurrentPageByCategory('
							+ _page + ')"';
				if (currentPage == i) {
					pagingHtml = pagingHtml + 'style="font-size: 25px; color: mediumblue;">';
				} else {
					pagingHtml = pagingHtml + '>';
				}
				pagingHtml = pagingHtml + _ppage + ' </a>';
			}
		}
		if (currentPage <= totalPage - 4) {
			if (currentPage < totalPage - 4) {
				pagingHtml += '<a>...</a>';
			}
			pagingHtml += '<a href="javascript:void(0)" onclick=';
			var _totalPage = totalPage - 1;
			if (currentCategory_no == 0)
				pagingHtml = pagingHtml + '"sendCurrentPage(' + _totalPage
						+ ')">';
			if (currentCategory_no != 0)
				pagingHtml = pagingHtml + '"sendCurrentPageByCategory('
						+ _totalPage + ')">';
			pagingHtml += totalPage + '</a>';
		}
		console.log(currentPage);
		$("#paginationDIV").append(pagingHtml);
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
				console.log("ListByCategory 에러");
			}
		});
	}

	function sendCurrentPage(clickPage) {
		currentPage = clickPage;
		sendCreateProductListALLAndPage();
	}

	function sendCurrentPageByCategory(clickPage) {
		currentPage = clickPage;
		sendCreateProductListByCategoryAndPage(currentCategory_no);
	}
</script>

<!-- Breadcrumbs Area Start -->
<div class="breadcrumbs-area">
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<div class="breadcrumbs">
					<h2>商品検索</h2>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- Breadcrumbs Area Start -->
<!-- Shop Area Start -->
<div class="shopping-area section-padding">
	<div class="container">
		<div class="row">
			<div class="col-md-3 col-sm-3 col-xs-12">
				<div class="shop-widget">
					<div class="shop-widget-top">
						<aside class="widget widget-categories" id="_category">
							<h2 class="sidebar-title text-center">カテゴリ</h2>
							<ul class="sidebar-menu">
								<li><a href="#"> <i class="fa fa-angle-double-right"></i>
										ファッション衣類 ・ 雑貨
								</a></li>
							</ul>
						</aside>
						<aside class="widget shop-filter">
							<h2 class="sidebar-title text-center">値段調整</h2>
							<div class="info-widget">
								<div class="price-filter">
									<div id="slider-range"></div>
									<div class="price-slider-amount">
										<input type="text" id="amount" name="price"
											placeholder="値段を入力して下さい" />
										<div class="widget-buttom">
											<input type="submit" value="決定" id="searchPrice" /> <input
												type="reset" value="クリア" />
										</div>
									</div>
								</div>
							</div>
						</aside>
					</div>
				</div>
			</div>
			<div class="col-md-9 col-sm-9 col-xs-12">
				<div class="shop-tab-area">
					<div class="shop-tab-list">
						<div class="shop-tab-pill pull-right">
							<ul>
								<li class="product-size-deatils">
									<div class="green_window" style="">
										<input type="text" id="searchWordText" width="200px">
										<button class="btn_submit" type="button" id="search_btn"
											title="検索">
											<span class="blind"> <i class="fa fa-search"
												aria-hidden="true"></i>
											</span> <span class="ico_search_submit"></span>
										</button>
									</div>
								</li>
								<li class="product-size-deatils">
									<div class="show-label">
										<label><i class="fa fa-sort-amount-asc"></i>整列 : </label> <select
											id="selectBySort" onchange="changeSelectBySort()">
											<option value="p.date DESC" selected="selected">最新順</option>
											<option value="p.price ASC">値段昇順</option>
											<option value="p.price DESC">値段降順</option>
										</select>
									</div>
								</li>
								<div class="paginationDIV" id="paginationDIV">
									<a href="#">&laquo;</a> <a href="#">1</a> 
									<a class="active" href="#">2</a> 
									<a href="#">3</a> <a href="#">4</a> <a href="#">5</a>
									<a href="#">6</a> <a href="#">&raquo;</a>
								</div>
							</ul>
						</div>
					</div>
					<div class="tab-content">
						<div class="row tab-pane fade in active" id="home">
							<div class="shop-single-product-area" id="_product_area">
								<div class="col-md-4 col-sm-6">
									<div class="single-banner">
										<div class="product-wrapper">
											<a href="#" class="single-banner-image-wrapper"> <img
												alt="" src="<c:url value="/resources/img/featured/1.jpg"/>">
												<div class="price">
													<span>$</span>160
												</div>
											</a>
											<div class="product-description">
												<div class="functional-buttons">
													<a href="wishlist.html" title="買いたい物に追加"> <i
														class="fa fa-heart-o"></i>
													</a>
												</div>
											</div>
										</div>
										<div class="banner-bottom text-center">
											<div class="banner-bottom-title">
												<a href="#">East of eden</a>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div id="menu1" class="tab-pane fade">
							<div class="row">
								<div class="single-shop-product">
									<div class="col-xs-12 col-sm-5 col-md-4">
										<div class="left-item">
											<a href="single-product.html" title="East of eden"> <img
												src="<c:url value="/resources/img/featured/1.jpg"/>" alt="">
											</a>
										</div>
									</div>
									<div class="col-xs-12 col-sm-7 col-md-8">
										<div class="deal-product-content">
											<h4>
												<a href="single-product.html" title="East of eden">East
													of eden</a>
											</h4>
											<div class="product-price">
												<span class="new-price">$ 140.00</span>
											</div>
											<p>Faded short sleeves t-shirt with high neckline. Soft
												and stretchy material for a comfortable fit. Accessorize
												with a straw hat and you're ready for summer!</p>
											<div class="availability">
												<span><a href="wishlist.html">買いたい物に追加</a></span>
											</div>
										</div>
									</div>
								</div>
								<div class="single-shop-product">
									<div class="col-xs-12 col-sm-5 col-md-4">
										<div class="left-item">
											<a href="single-product.html" title="People of the book">
												<img src="<c:url value="/resources/img/featured/2.jpg"/>"
												alt="">
											</a>
										</div>
									</div>
									<div class="col-xs-12 col-sm-7 col-md-8">
										<div class="deal-product-content">
											<h4>
												<a href="single-product.html" title="People of the book">People
													of the book</a>
											</h4>
											<div class="product-price">
												<span class="new-price">$ 140.00</span>
											</div>
											<p>Faded short sleeves t-shirt with high neckline. Soft
												and stretchy material for a comfortable fit. Accessorize
												with a straw hat and you're ready for summer!</p>
											<div class="availability">
												<span><a href="wishlist.html">買いたい物に追加</a></span>
											</div>
										</div>
									</div>
								</div>
								<div class="single-shop-product">
									<div class="col-xs-12 col-sm-5 col-md-4">
										<div class="left-item">
											<a href="single-product.html" title="The secret letter">
												<img src="<c:url value="/resources/img/featured/3.jpg"/>"
												alt="">
											</a>
										</div>
									</div>
									<div class="col-xs-12 col-sm-7 col-md-8">
										<div class="deal-product-content">
											<h4>
												<a href="single-product.html" title="The secret letter">The
													secret letter</a>
											</h4>
											<div class="product-price">
												<span class="new-price">$ 140.00</span>
											</div>
											<p>Faded short sleeves t-shirt with high neckline. Soft
												and stretchy material for a comfortable fit. Accessorize
												with a straw hat and you're ready for summer!</p>
											<div class="availability">
												<span><a href="wishlist.html">買いたい物に追加</a></span>
											</div>
										</div>
									</div>
								</div>
								<div class="single-shop-product">
									<div class="col-xs-12 col-sm-5 col-md-4">
										<div class="left-item">
											<a href="single-product.html" title="Lone some dove"> <img
												src="<c:url value="/resources/img/featured/4.jpg"/>" alt="">
											</a>
										</div>
									</div>
									<div class="col-xs-12 col-sm-7 col-md-8">
										<div class="deal-product-content">
											<h4>
												<a href="single-product.html" title="Lone some dove">Lone
													some dove</a>
											</h4>
											<div class="product-price">
												<span class="new-price">$ 140.00</span>
											</div>
											<p>Faded short sleeves t-shirt with high neckline. Soft
												and stretchy material for a comfortable fit. Accessorize
												with a straw hat and you're ready for summer!</p>
											<div class="availability">
												<span><a href="wishlist.html">買いたい物に追加</a></span>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- Shop Area End -->