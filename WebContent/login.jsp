<!DOCTYPE html>
<head>
    
   <title>WP500 Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="favicon.png" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>

 function checkLogin() {
	
	var username = $('#username').val();
	var password = $('#password').val();
	
	$
			.ajax({
				
				url : 'WP500Login',
				type : 'POST',
				data : {
					username : username,
					password : password
				},
				success : function(data) {
					
				//alert(data.msg);
				
				var json1 = JSON.stringify(data);

						var json = JSON.parse(json1);

						if (json.status == 'fail') {
							var confirmation = confirm(json.msg);
							if (confirmation) {
								//window.location.href = 'login.jsp';
							}
						}
				
				
				
				
				
			},
				error : function(xhr, status, error) {
					console.log('Error showing login data: ' + error);
				}
			});
} 

$(document).ready(function() {
	//checkLogin();
	
});

</script>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #2e3891d4;
            margin: 0;
        }
        
        .container {
            width: 24em;
            border-radius: 30px;
            background-color: #ffffff8f;
            padding-bottom: 30px;
            text-align: center;
        }
        
        .container img {
            width: 78%;
        }
        
        .container label {
            display: block;
            text-align: left;
        }
        
        .container input[type="text"],
        .container input[type="password"] {
            width: 100%;
            padding: 5px;
            margin-bottom: 10px;
        }
        
        .container input[type="submit"] {
            padding: 5px 140px;
            font-size: medium;
        }
    </style>       
       
</head>
<body style="background-color: #2e3891d4;">
    
      <%-- Display error message if there is an error parameter in the URL --%>
    <%-- <% if (request.getParameter("error") != null) { %>
        <p style="color: red; margin-top: -25%; margin-left: 50%;">Invalid username or password.</p>
    <% } %>   --%>
    
    <form action="WP500Login" method="post" class="container" style="width: 24em; border-radius: 30px; background-color: #ffffff8f;padding-bottom: 30px;">
        <div>
            <img src="images/tasm2m.png" alt="Tasm2mLogo" style="width: 78%; float: center;"/>
        </div>
        
        <p>WP500 Web Configuration</p>
            <label for="username" style="float: left;">Username:</label>
        <input type="text" id="username" name="username" required><br>
        
        <label for="password" style="float: left;">Password:</label>
        <input type="password" id="password" name="password" required><br><br>
      
        <input style="padding: 5px 140px;font-size:medium" type="submit" value="Login" id="login">
    </form>
   
</body>
</html>