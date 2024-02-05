 <%@ page import="java.util.UUID" %>
<%@ page import="java.security.MessageDigest" %>
<%
    response.setHeader("X-Frame-Options", "DENY");
    response.setHeader("X-Content-Type-Options", "nosniff");
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
        	            	window.location.replace('resetpasswordfirsttime.jsp');     	            	
        	            }else if (json.status === 'success' && json.first_login === 'false' && json.totp_authenticator === 'enable') {
        	                $('#loginMessage').text('Login Successful').css('color', 'green');        	                
        	                window.location.replace('twofactorAuthOTP.jsp');       	                
        	            }       	           	            
        	            else if(json.status === 'success' && json.first_login === 'false' && json.totp_authenticator === 'disable'){
        	                $('#loginMessage').text('Login Successful').css('color', 'green');
        	                var token = data.token;     	          
                            $.ajaxSetup({
                                beforeSend: function(xhr) {
                                    xhr.setRequestHeader('Authorization', 'Bearer ' + token);
                                }
                            });                            
                             window.location.replace('overview.jsp');   	             	
        	            }       	            
        	            else if(json.status === 'error'){
        	                $('#loginMessage').text(json.msg).css('color', 'red');    	               
        	            }
        	            else if(json.status === 'blocked'){
        	                $('#loginMessage').text(json.msg).css('color', 'red');    	               
        	            }
        	        },
        	        error: function(xhr, status, error) {       	            
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
        	    const userInput = $('#userInputNumber').val();      	  
        	    if (userInput.trim() === $('#captchaLabel').text().trim()) {     	        
        	        $('#loginMessage').text('Captcha is correct. You may proceed.').css('color', 'green');
        	        checkLogin();
        	    } else {
        	        $('#loginMessage').text('Captcha is incorrect. Please try again.').css('color', 'red');
        	        $('#userInputNumber').val('');     	        
        	    }
        	}

         function readBannerText(){
        		$.ajax({
        			url : "bannerTextServlet",
        			type : "GET",
        			dataType : "json",
        			success : function(data) {
        	            var textToShow = data.banner_text_data.join('\n');
        	            $('#banner_text').text(textToShow);
        			},
        			error : function(xhr, status, error) {     				
        			},
        		});
        	}
         
         document.addEventListener('DOMContentLoaded', function () {
             const captchaLabel = document.getElementById('captchaLabel');
             const captchaText = generateRandomAlphanumeric();            
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
             var passwordField = $('#password');
		      passwordField.on('paste', function(e) {
		        e.preventDefault();
		      });		      
        	$('#loginForm').submit(function(event) {
                event.preventDefault();                
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
        width: calc(100% - 20px); 
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
        right: 15px; 
        top: 36%; 
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
    width: 200px; 
    margin: 0 auto;
    text-align: center;
    position: relative; 
    display: inline-block; 
}

#refreshCaptcha {
    font-size: 10px; 
    padding: 5px 10px; 
    cursor: pointer;
    height: 30px;
}
  
</style>   
</head>
<body style="background-color: #2e3891d4;">

<%!
        private String generateCSRFToken() {
            String token = UUID.randomUUID().toString();
            return token;
        }
    %>  
    <form action="WP500Login" method="post" class="container" id="loginForm" autocomplete="off">
    <% 
            String csrfToken = generateCSRFToken();
            session.setAttribute("csrfToken", csrfToken);               
            if (session.getAttribute("blockedUser") != null) {
                long blockTime = (long) session.getAttribute("blockedUser");
                long currentTime = System.currentTimeMillis();
                if (currentTime < blockTime) {
                    out.println("<script>$('#loginMessage').text('User is blocked. Please try again later.').css('color', 'red');</script>");       	        
                    return;
                } else {
                    session.removeAttribute("blockedUser");
                    session.setAttribute("loginAttempts", 0);
                }
            }
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
		</label>
        <input required type="text" id="userInputNumber" placeholder="Enter the captcha" style="padding-left: 5px; margin-top: 10px;  font-family: Sans-serif;"><br>     
		<input style="font-size: medium;" type="submit" value="Login" id="login">
        <div id="loginMessage" style="color: red;"></div>    
        <div id="banner_text" style="font-size: 10.5px; margin-top: 20px; text-align: left;"></div>  
      <%
      int loginAttempts = 0;
      if (session.getAttribute("loginAttempts") != null) {
          loginAttempts = (int) session.getAttribute("loginAttempts");
      } else {
          session.setAttribute("loginAttempts", loginAttempts);
      }
      if (request.getAttribute("loginError") != null) {
          session.setAttribute("loginAttempts", loginAttempts + 1);
      }
%> 
        </form>  
</body>
</html>