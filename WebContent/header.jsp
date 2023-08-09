<%-- <!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
<!-- <div class="header"> -->
<header>
	<div class="row" style="float: right; margin-top: 1%">
		<div>
			${username} <i class="fa fa-sign-out"
				style="font-size: 20px; margin-left: 5px" id="logout"
				onclick="logout()"></i>
		</div>
	</div>
</header>
<!-- </div> -->
</head>
<!-- <body>
    
  </body> -->

<script>
	/* function logout(){
	  
	  alert("Are you sure you want to logout?")
	  
	  $.ajax({
	        url: 'logout',
	        type: 'get',
	        data:{action:'logout'},
	        success: function(data){
	        alert(data);
	               //location.reload();
	            //window.location.href = data;
	        }
	    });
	} */
	$(document).ready(function() {
		$("#logout").click(function() {
			alert('Are you sure want to logout?')
			$.ajax({
				url : "logout"
			});
		});
	});
</script>
</html> --%>


<!-- ---------------------------------------------------------------------------------- -->



<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
<link rel="stylesheet" href="nav-bar.css" />

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	function loadConfig() {
		$.ajax({
			url : 'loadConfigurationServlet',
			type : 'GET',
			dataType : 'json',
			success : function(data) {
				alert(data.status);

			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error: ' + error);
			}
		});
	}

	$(document).ready(function() {

		$('#loadConfig').click(function() {
			loadConfig();

		});

	});
</script>
<!-- <div class="header"> -->
<header>

	<div class="row"
		style="display: flex; justify-content: right; margin-top: 1%">
		<input style="margin-right: 10px;" type="button" id="loadConfig"
			value="Update Configuration" />
		<div>
			${username} <i class="fa fa-sign-out"
				style="font-size: 20px; margin-left: 5px" onclick="logout()"></i>
		</div>
	</div>
</header>
<!-- </div> -->
</head>
<!-- <body>
    
  </body> -->
</html>