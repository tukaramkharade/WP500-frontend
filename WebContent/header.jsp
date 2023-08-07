<!DOCTYPE html>
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
</html>