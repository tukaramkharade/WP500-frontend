<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>WP500 Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="favicon.png" />

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>

var roleValue;	

	function reboot() {

		var confirmation = confirm('Are you sure you want to reboot?');

		if (confirmation) {
			$.ajax({
				url : 'reboot',
				type : 'GET',
				dataType : 'json',
				success : function(data) {
					
					var json1 = JSON.stringify(data);

					var json = JSON.parse(json1);

					if (json.status == 'fail') {
						var confirmation = confirm(json.msg);
						if (confirmation) {
							window.location.href = 'login.jsp';
						}
					}
					alert(data.message);

				},
				error : function(xhr, status, error) {
					// Handle the error response, if needed
					console.log('Error: ' + error);
				}
			});
		}
	}
	
	function changeButtonColor(isDisabled) {
        var $reboot_button = $('#reboot');
        
        if (isDisabled) {
            $reboot_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $reboot_button.css('background-color', '#2b3991'); // Reset to original color
        }
	}

	$(document).ready(function() {

		<%
    	// Access the session variable
    	HttpSession role = request.getSession();
    	String roleValue = (String) session.getAttribute("role");
    	%>
    	
    	roleValue = '<%= roleValue %>'; // This will insert the session value into the JavaScript code
    	
    	if(roleValue == 'VIEWER' || roleValue == 'Viewer'){
  		  
  		  var confirmation = confirm('You do not have enough privileges for role VIEWER');
  		  
  		$('#reboot').prop('disabled', true);
  		  
  		  changeButtonColor(true);
  	  }
    	
		$('#reboot').click(function() {
			reboot();

		});

	});
</script>
</head>
<body>
	<div class="sidebar">
		<%@ include file="common.jsp"%>
	</div>
	<div class="header">
		<%@ include file="header.jsp"%>
	</div>

	<div class="content">
		<section style="margin-left: 1em">
		<h3>Reboot</h3>
		<hr>

		<div class="container">

			<input type="button" id="reboot" value="Reboot" />
		</div>
		</section>
	</div>

	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>