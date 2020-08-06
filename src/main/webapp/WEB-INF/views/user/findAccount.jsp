<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

<!-- Breadcrumbs Area Start -->
<div class="breadcrumbs-area">
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<div class="breadcrumbs">
					<h2>パスワード探し</h2>
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
				<form action="/user/findAccount" class="find-account-form" method="post">
					<h2 class="heading-title">パスワードを忘れた場合</h2>
					<p class="form-row">
						<input type="email" name="mail" id="mail" placeholder="メールアドレス" required>
					</p>
					
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
					
					<div class="submit">
						<button name="submitcreate" id="submitcreate" type="submit"
							class="btn-default">
							<span> <i class="fa fa-user left"></i> パスワードを探す
							</span>
						</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>
<!-- Loging Area End -->