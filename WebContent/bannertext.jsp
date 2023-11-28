<!DOCTYPE html>
<html>
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32"
	href="images/WP_Connex_logo_favicon.png" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
h3 {
	margin-top: 70px;
}
</style>

<script type="text/javascript">

function readBannerText(){
	$.ajax({
		url : "bannerTextServlet",
		type : "GET",
		dataType : "json",
		success : function(data) {
			// Assuming data.banner_text_data is an array, join it to create a string
            var textToShow = data.banner_text_data.join('\n');

            // Set the text in the textarea
            $('#banner_text').val(textToShow);
		},
		error : function(xhr, status, error) {
			console.log("Error showing banner text data : " + error);
		},
	});
}

function updateBannerText(){
	
}

$(document).ready(function() {
	readBannerText();
});

</script>
<body>
<div class="sidebar">
		<%@ include file="common.jsp"%>
	</div>
	<div class="header">
		<%@ include file="header.jsp"%>
	</div>
	
	<div class="content">
		<section style="margin-left: 1em">
			<h3>BANNER TEXT</h3>
			<hr>
			<div class="container">
			
			<form id="bannerForm">
			<textarea id="banner_text" name="banner_text" rows="10"
							cols="100" required style="margin-top: -30px; margin-left: -19px; height: 500px;"></textarea>
							
			<div class="row" style="display: flex; justify-content: center; margin-bottom: 2%; margin-top: 1%;">
					
					 <input style="height: 26px;" type="button" value="Update" id="update"/> 
					
				</div>
			</form>
			</div>
			</section>
			</div>

</body>
</html>