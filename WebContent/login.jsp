<%@ page import="java.util.UUID" %>
<%@ page import="java.security.MessageDigest" %>

<%
   
    // Add X-Frame-Options header to prevent clickjacking
    response.setHeader("X-Frame-Options", "DENY");


%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
   
    <title>WPConnex Web Configuration</title>
    <link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png">
        <link rel="stylesheet" href="css_files/ionicons.min.css">
<link rel="stylesheet" href="css_files/normalize.min.css">
<link rel="stylesheet" href="css_files/fonts.txt" type="text/css">    
    <link rel="stylesheet" href="nav-bar.css">
   <link rel="stylesheet" href="css_files/all.min.css">
<link rel="stylesheet" href="css_files/fontawesome.min.css">    
    <script src="jquery-3.6.0.min.js"></script>
    <script>
   
         function checkLogin() {
        	    var username = $('#username').val();
        	    var password = $('#password').val();
        	    var csrfToken = document.getElementById('csrfToken').value;

			
        	    
        	    $.ajax({
        	        url: 'WP500Login',
        	        type: 'POST',
        	        data: {
        	            username: username,
        	            password: password,
        	            csrfToken: csrfToken
        	        },
        	        success: function(data) {
        	            var json1 = JSON.stringify(data);
        	            var json = JSON.parse(json1);

        	            if(json.status === 'success' && json.first_login === 'true'){
        	            	
        	            	window.location.href = 'changeoldpassword.jsp';
        	            	
        	            }else if (json.status === 'success' && json.first_login === 'false' && json.totp_authenticator === 'enable') {
        	                // Login successful
        	                $('#loginMessage').text('Login Successful').css('color', 'green');
        	                var token = data.token;

                            // Set the token in the header for future AJAX requests
                            $.ajaxSetup({
                                beforeSend: function(xhr) {
                                    xhr.setRequestHeader('Authorization', 'Bearer ' + token);
                                }
                            });
                            
        	                window.location.href = 'totp.jsp';
        	                
        	            } 
        	            
        	            
        	            else if(json.status === 'success' && json.first_login === 'false' && json.totp_authenticator === 'disable'){
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
        	            	
        	            }
        	            
        	            else {
        	                // Login failed
        	                $('#loginMessage').text(json.msg).css('color', 'red');
        	               
        	            }
        	        },
        	        error: function(xhr, status, error) {
        	            console.log('Error showing login data: ' + error);
        	        }
        	    });
        	}
        
         
         function togglePassword() {
        	    var passwordInput = $('#password');
        	    var passwordToggle = $('#password-toggle');

        	    if (passwordInput.attr('type') === 'password') {
        	        passwordInput.attr('type', 'text');
        	        passwordToggle.html('<i class="fa fa-eye-slash"></i>');
        	    } else {
        	        passwordInput.attr('type', 'password');
        	        passwordToggle.html('<i class="fa fa-eye"></i>');
        	    }
        	}

         function checkUserInput() {
        	    // Get the user's input
        	    const userInput = $('#userInputNumber').val();
        	  
        	    console.log(userInput+" "+$('#captchaLabel').text());
        	    // Check if the user's input matches the stored random number
        	    if (userInput.trim() === $('#captchaLabel').text().trim()) {
        	        // Call your checkLogin function or do whatever you want
        	        $('#loginMessage').text('Captcha is correct. You may proceed.').css('color', 'green');
        	        checkLogin();
        	    } else {
        	        $('#loginMessage').text('Captcha is incorrect. Please try again.').css('color', 'red');
        	        $('#userInputNumber').val('');
        	        // Generate a new random number/image
        	        
        	    }
        	}

         function readBannerText(){
        		$.ajax({
        			url : "bannerTextServlet",
        			type : "GET",
        			dataType : "json",
        			success : function(data) {
        				// Assuming data.banner_text_data is an array, join it to create a string
        	            var textToShow = data.banner_text_data.join('\n');

        	            // Set the text in the textarea
        	            $('#banner_text').text(textToShow);
        			},
        			error : function(xhr, status, error) {
        				console.log("Error showing banner text data : " + error);
        			},
        		});
        	}
         
         document.addEventListener('DOMContentLoaded', function () {
             const captchaLabel = document.getElementById('captchaLabel');

             // Generate random alphanumeric text for CAPTCHA
             const captchaText = generateRandomAlphanumeric();
            
             // Set the generated text to the label
             captchaLabel.textContent = captchaText;
         });

         function generateRandomAlphanumeric() {
        	 var length = 6;
             const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
             let result = '';
             for (var i = 0; i < length; i++) {
                 result += characters.charAt(Math.floor(Math.random() * characters.length));
             }
             return result;
         }
         
        $(document).ready(function () {
        	
        	
            
        	readBannerText();
        	
        	
        	// Attach the checkLogin function to the form submission
        	$('#loginForm').submit(function(event) {
                event.preventDefault(); // Prevent the default form submission               
                checkUserInput();
                
            });
        	
        	$('#password-toggle').click(function () {
                togglePassword();
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
    width: 25em;
    border-radius: 30px;
    background-color: #ffffff8f;
    padding-bottom: 30px;
   text-align: center;
}

    .container img {
        width: 70%;
        margin-top: -36px;
    }

    .container label {
        display: block;
        text-align: left;
    }

    .container input[type="text"],
    .container input[type="password"] {
        width: calc(100% - 20px); /* Adjusted width to account for padding */
        padding: 5px 0;
        margin-bottom: 10px;
        margin-top: -8px;
    }

    .container input[type="submit"] {
        padding: 5px 140px;
        font-size: medium;
    }

    #imageContainer img {
        width: 38%;
    }

    input[type="text"],
    input[type="password"],
    input[type="submit"] {
        margin-left: -5px;
    }

    .password-toggle {
        position: absolute;
        right: 15px; /* Adjust the positioning as needed */
        top: 36%; /* Adjusted top to center the eye symbol */
        cursor: pointer;
    }
    
  #captchaLabel {
  user-select: none;
    font-size: 24px;
    color: black;
    border: none;
    padding: 10px;
   font-family: Sans-serif;
    border-radius: 5px;
    width: 200px; /* Adjusted width to accommodate the text content */
    margin: 0 auto;
    text-align: center;
    position: relative; /* Add relative positioning to the label */
    display: inline-block; /* Display as inline-block to allow adjacent elements */
}

#refreshCaptcha {
    font-size: 10px; /* Adjusted font size for the button */
    padding: 5px 10px; /* Adjusted padding for the button */
    cursor: pointer;
    height: 30px;
}
  

</style>
   
</head>
<body style="background-color: #2e3891d4;">

<%!
        // Function to generate CSRF token
        private String generateCSRFToken() {
            String token = UUID.randomUUID().toString();
            // You can apply additional hashing or encoding if needed
            return token;
        }
    %>
    
    <form action="WP500Login" method="post" class="container" id="loginForm">
    
    <% 
            // Generate CSRF token and store it in the session
            String csrfToken = generateCSRFToken();
            session.setAttribute("csrfToken", csrfToken);
            
            
      //      response.setHeader("Set-Cookie", "CSRF_TOKEN=" + csrfToken + "; HttpOnly; Secure; SameSite=Strict");

        %>

        <input type="hidden" name="csrfToken" id="csrfToken" value="<%= csrfToken %>" />
        
        <div>
            <img src="images/WP_connex_logo_full.png" alt="Tasm2mLogo">
        </div>
        
        <p style="font-size: medium; margin-top: -30px;"><b>WPConnex Web Configuration</b></p>
        <label for="username" style="float: left; margin-top: -20px;">Username</label>
        <input required type="text" id="username" name="username" style="padding-left: 5px;"><br>
        
        <label for="password" style="float: left;  margin-top: -15px;">Password</label>
       
        <div style="position: relative;">
    <input required type="password" id="password" name="password" style="padding-left: 5px;">
     
    <span class="password-toggle" id="password-toggle"><i class="fa fa-eye"></i></span>
</div>
 
  <label id="captchaLabel">
    <!-- <span id="captchaText"></span> -->
</label>
<!-- <button id="refreshCaptcha"><i class="fas fa-sync-alt" style="font-size: 15px; color: #35449a;"></i></button>
 --> 
        <input required type="text" id="userInputNumber" placeholder="Enter the captcha" style="padding-left: 5px; margin-top: 10px;  font-family: Sans-serif;"><br>
       
        <input font-size: medium" type="submit" value="Login" id="login">
        
        <div id="loginMessage" style="color: red;"></div>
        
        <div id="banner_text" style="font-size: 10.5px; margin-top: 20px; text-align: left;"></div>
    </form>
    
</body>
</html>
