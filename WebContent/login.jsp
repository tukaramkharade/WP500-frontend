<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WPConnex Web Configuration</title>
    <link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">
    <link href="https://fonts.googleapis.com/css?family=Lato:400,300,700" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
    <link rel="stylesheet" href="nav-bar.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        
         function checkLogin() {
        	    var username = $('#username').val();
        	    var password = $('#password').val();

        	    $.ajax({
        	        url: 'WP500Login',
        	        type: 'POST',
        	        data: {
        	            username: username,
        	            password: password
        	        },
        	        success: function(data) {
        	            var json1 = JSON.stringify(data);
        	            var json = JSON.parse(json1);

        	            if (json.status === 'success') {
        	                // Login successful
        	                $('#loginMessage').text('Login Successful').css('color', 'green');
        	                var token = data.token;

                            // Set the token in the header for future AJAX requests
                            $.ajaxSetup({
                                beforeSend: function(xhr) {
                                    xhr.setRequestHeader('Authorization', 'Bearer ' + token);
                                }
                            });
                            
                            
        	                window.location.href = 'overview.jsp';
        	                
        	                // Redirect or perform other actions as needed
        	            } else {
        	                // Login failed
        	                $('#loginMessage').text(json.msg).css('color', 'red');
        	                window.location.href = 'login.jsp';
        	            }
        	        },
        	        error: function(xhr, status, error) {
        	            console.log('Error showing login data: ' + error);
        	        }
        	    });
        	}


        $(document).ready(function () {
        	// Attach the checkLogin function to the form submission
            $('#loginForm').submit(function(event) {
                event.preventDefault(); // Prevent the default form submission
                checkLogin();
            });
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
            padding: 5px 0;
            margin-bottom: 10px;
        }
        
        .container input[type="submit"] {
            padding: 5px 140px;
            font-size: medium;
        }
    </style>
</head>
<body style="background-color: #2e3891d4;">
    <form action="WP500Login" method="post" class="container" id="loginForm">
        <div>
            <img src="images/WP_connex_logo_full.png" alt="Tasm2mLogo">
        </div>
        
        <p style="font-size: medium;"><b>WPConnex Web Configuration</b></p>
        <label for="username" style="float: left;">Username:</label>
        <input required type="text" id="username" name="username" ><br>
        
        <label for="password" style="float: left;">Password:</label>
        <input required type="password" id="password" name="password" ><br><br>
      
        <input font-size: medium" type="submit" value="Login" id="login">
        
        <div id="loginMessage" style="color: red;"></div>

    </form>
</body>
</html>
