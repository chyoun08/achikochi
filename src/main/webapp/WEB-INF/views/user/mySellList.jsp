<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />

<script>

function deleteProduct(product_no){
	
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");

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
                window.location.href = "redirect:/user/mySellList";
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
<div class="breadcrumbs-area">
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<div class="breadcrumbs">
					<h2>販売している物</h2>
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

			<c:forEach var="productVO" items="${sellList}">
				<div class="single-shop-product">
					<div class="col-xs-12 col-sm-5 col-md-4">
						<div class="left-item">
							<a href="/product/detail?product_no=${productVO.product_no}"
								title="${productVO.title}"> <img
								src="${productVO.sumnail}" alt="">
							</a>
						</div>
					</div>
					<div class="col-xs-12 col-sm-7 col-md-8">
						<div class="deal-product-content">
							<h4>
								<a href="/product/detail?product_no=${productVO.product_no}"
									title="${productVO.title}">${productVO.title}</a>
							</h4>
							<div class="product-price">
								<span class="new-price">$ ${productVO.price}</span>
							</div>
							<p>${productVO.content}</p>

							<div class="availability">
								<a class="btn btn-success"
								href="javascript:void(0)" onclick="deleteProduct(${productVO.product_no})">
									削除
								</a>
							</div>

						</div>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>
</div>

<!-- Shop Area End -->