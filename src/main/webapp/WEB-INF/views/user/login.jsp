<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

<!-- Breadcrumbs Area Start -->
<div class="breadcrumbs-area">
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<div class="breadcrumbs">
					<h2>ログイン</h2>
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
			
				<c:if test="${not empty errorMsg}">
					<div style = "color:#ff0000;"> <h3> ${errorMsg} </h3> </div>
				</c:if>
				<c:if test="${not empty logoutMsg}">
					<div style = "color:#0000ff;"> <h3> ${logoutMsg} </h3> </div>
				</c:if>
			
				<form class="create-account-form" action="<c:url value="/login"/>" method="post">
					<h2 class="heading-title">ログイン</h2>
					<p class="form-row">
						<input type="text" id="user_id" name="username" placeholder="アイディー" required>
					</p>
					<p class="form-row">
						<input type="password" id="user_pw" name="password" placeholder="パスワード" required>
					</p>
					<p class="lost-password form-group">
						<a href="/user/findAccount" rel="nofollow">パスワードを忘れた場合は？</a>
					</p>
					<p class="lost-password form-group">
						<a href="/user/regist" rel="nofollow">会員登録</a>
					</p>
					
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
					
					<div class="submit">
						<button name="submitcreate" id="submitcreate" type="submit"
							class="btn-default">
							<span> <i class="fa fa-user left"></i> ログイン
							</span>
						</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>
<!-- Loging Area End -->