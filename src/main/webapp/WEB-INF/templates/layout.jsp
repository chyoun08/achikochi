<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>

<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
	<meta http-equiv="x-ua-compatible" content="ie=edge">
	<title>あちこち</title>
	<meta name="description" content="">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- favicon -->
	<link rel="shortcut icon" type="image/x-icon" href="<c:url value="/resources/img/favicon.ico"/>">
	<!-- Place favicon.ico in the root directory -->
	<!-- Google Fonts -->
	<link href='https://fonts.googleapis.com/css?family=Poppins:400,700,600,500,300' rel='stylesheet' type='text/css'>
	
	<!-- all css here -->
	<!-- bootstrap v3.3.6 css -->
	<link rel="stylesheet" href="<c:url value="/resources/css/bootstrap.min.css"/>">
	<!-- animate css -->
	<link rel="stylesheet" href="<c:url value="/resources/css/animate.css"/>">
	<!-- jquery-ui.min css -->
	<link rel="stylesheet" href="<c:url value="/resources/css/jquery-ui.min.css"/>">
	<!-- meanmenu css -->
	<link rel="stylesheet" href="<c:url value="/resources/css/meanmenu.min.css"/>">
	<!-- Font-Awesome css -->
	<link rel="stylesheet" href="<c:url value="/resources/css/font-awesome.min.css"/>">
	<!-- pe-icon-7-stroke css -->
	<link rel="stylesheet" href="<c:url value="/resources/css/pe-icon-7-stroke.css"/>">
	<!-- Flaticon css -->
	<link rel="stylesheet" href="<c:url value="/resources/css/flaticon.css"/>">
	<!-- venobox css -->
	<link rel="stylesheet" href="<c:url value="/resources/venobox/venobox.css"/>" type="text/css" media="screen" />
	<!-- nivo slider css -->
	<link rel="stylesheet" href="<c:url value="/resources/lib/css/nivo-slider.css"/>" type="text/css" />
	<link rel="stylesheet" href="<c:url value="/resources/lib/css/preview.css"/>" type="text/css" media="screen" />
	<!-- owl.carousel css -->
	<link rel="stylesheet" href="<c:url value="/resources/css/owl.carousel.css"/>">
	<!-- style css -->
	<link rel="stylesheet" href="<c:url value="/resources/style.css?ver=1"/>">
	<!-- responsive css -->
	<link rel="stylesheet" href="<c:url value="/resources/css/responsive.css"/>">
	<!-- kakaomap css -->
	<link rel="stylesheet" href="<c:url value="/resources/css/map.css?ver=1"/>">
	<!-- modernizr css -->
	<script src="<c:url value="/resources/js/vendor/modernizr-2.8.3.min.js"/>"></script>
	
	<!-- Alertify -->
	<script src="//cdn.jsdelivr.net/npm/alertifyjs@1.12.0/build/alertify.min.js"></script>
	<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.12.0/build/css/alertify.min.css" />
	<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.12.0/build/css/themes/default.min.css" />
	
	<!-- JQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=6075271047e78cae55ec2f93d011c0a1&libraries=services"></script>
</head>

<body>
	<div>
		<tiles:insertAttribute name="menu" />
		<tiles:insertAttribute name="body" />
		<tiles:insertAttribute name="footer" />
	</div>
	
	<!-- all js here -->
	<!-- jquery latest version -->
	<script src="<c:url value="/resources/js/vendor/jquery-1.12.0.min.js"/>"></script>
	<!-- bootstrap js -->
	<script src="<c:url value="/resources/js/bootstrap.min.js"/>"></script>
	<!-- owl.carousel js -->
	<script src="<c:url value="/resources/js/owl.carousel.min.js"/>"></script>
	<!-- jquery-ui js -->
	<script src="<c:url value="/resources/js/jquery-ui.min.js"/>"></script>
	<!-- jquery Counterup js -->
	<script src="<c:url value="/resources/js/jquery.counterup.min.js"/>"></script>
	<script src="<c:url value="/resources/js/waypoints.min.js"/>"></script>
	<!-- jquery countdown js -->
	<script src="<c:url value="/resources/js/jquery.countdown.min.js"/>"></script>
	<!-- jquery countdown js -->
	<script type="text/javascript" src="<c:url value="/resources/venobox/venobox.min.js"/>"></script>
	<!-- jquery Meanmenu js -->
	<script src="<c:url value="/resources/js/jquery.meanmenu.js"/>"></script>
	<!-- wow js -->
	<script src="<c:url value="/resources/js/wow.min.js"/>"></script>
	<script>
		new WOW().init();
	</script>
	<!-- scrollUp JS -->
	<script src="<c:url value="/resources/js/jquery.scrollUp.min.js"/>"></script>
	<!-- plugins js -->
	<script src="<c:url value="/resources/js/plugins.js"/>"></script>
	<!-- Nivo slider js -->
	<script src="<c:url value="/resources/lib/js/jquery.nivo.slider.js"/>" type="text/javascript"></script>
	<script src="<c:url value="/resources/lib/home.js"/>" type="text/javascript"></script>
	<!-- main js -->
	<script src="<c:url value="/resources/js/main.js?ver=3"/>"></script>
</body>
</html>