<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />





<!-- Breadcrumbs Area Start -->
<div class="breadcrumbs-area">
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<div class="breadcrumbs">
					<h2>買いたい物</h2>
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
			<c:set var="name" value="${wishList}" />
			<c:choose>
				<c:when test="${empty name}">
					<div class="single-shop-product">
						<div class="col-xs-12 col-sm-12 col-md-12">
							<div class="deal-product-content">
								<br> <br> <br> <br>
								<p>
								<center>
									<b><font size=6>リストが空いています。 <br>品物を追加してください。
									</font></b>
								</center>
								</p>
								<br> <br> <br> <br> <br>
							</div>
						</div>
					</div>

				</c:when>

				<c:otherwise>
					<c:forEach var="wishlistVO" items="${wishList}">
						<div class="single-shop-product">
							<div class="col-xs-12 col-sm-5 col-md-4">
								<div class="left-item">
									<a href="/product/detail?product_no=${wishlistVO.product_no}"
										title="${wishlistVO.title}"> <img
										src="${wishlistVO.sumnail}" alt="">
									</a>
								</div>
							</div>
							<div class="col-xs-12 col-sm-7 col-md-8">
								<div class="deal-product-content">
									<h4>
										<a href="/product/detail?product_no=${wishlistVO.product_no}"
											title="${wishlistVO.title}">${wishlistVO.title}</a>
									</h4>
									<div class="product-price">
										<span class="new-price">$ ${wishlistVO.price}</span>
									</div>
									<p>${wishlistVO.content}</p>


									<div class="availability">

										<form class="availability"
											action="<c:url value="/product/wishList/delete" />"
											method="get">
											<input type="hidden" name="product_no" id="product_no"
												value="${wishlistVO.product_no}" />
											<button type="submit" class="btn btn-success">削除</button>
										</form>

									</div>

								</div>
							</div>
						</div>
					</c:forEach>

					<div class="shopingcart-bottom-area">
						<div class="shopingcart-bottom-area pull-right">
							<form action="<c:url value="/product/wishList/deleteAll" />"
								method="get">
								<button type="submit" class="btn btn-warning">買いたい物クリーア</button>
							</form>
						</div>
					</div>
				</c:otherwise>
			</c:choose>



		</div>


	</div>
</div>

<!-- Shop Area End -->