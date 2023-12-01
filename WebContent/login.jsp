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
   
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
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

        	    // Get the stored random number from the image (access the text content)
        	    const storedRandomNumber = $('#captchaLabel').text(); // Fix: .text() to get the text content
        	   
        	    // Check if the user's input matches the stored random number
        	    if (userInput === storedRandomNumber) {
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
             const refreshCaptcha = document.getElementById('refreshCaptcha');


             // Generate random alphanumeric text for CAPTCHA
             function generateRandomAlphanumeric() {
               var length = 6;
               const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
               let result = '';
               for (var i = 0; i < length; i++) {
                 result += characters.charAt(Math.floor(Math.random() * characters.length));
               }
               return result;
             }

             // Set the generated text to the label
              function setNewCaptcha() {
               const captchaTextValue = generateRandomAlphanumeric();
               captchaLabel.textContent = captchaTextValue;
             }

             // Set initial captcha
             setNewCaptcha();

             // Attach the setNewCaptcha function to the refresh button click event
             refreshCaptcha.addEventListener('click', function () {
               setNewCaptcha();
             }); 
           });
          
          
         
         
         
         
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
        width: 78%;
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
    font-size: 20px;
    color: black;
    background-color: white;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 5px;
    width: 200px; /* Adjusted width to accommodate the text content */
    margin: 0 auto;
    text-align: left;
    position: relative; /* Add relative positioning to the label */
    display: inline-block; /* Display as inline-block to allow adjacent elements */
}

#refreshCaptcha {
    font-size: 14px; /* Adjusted font size for the button */
    padding: 5px 10px; /* Adjusted padding for the button */
    cursor: pointer;
}
  

    
     

</style>
   
</head>
<body style="background-color: #2e3891d4;">
    <form action="WP500Login" method="post" class="container" id="loginForm">
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
    <span id="captchaText"></span>
</label>
<button id="refreshCaptcha"><i class="fas fa-sync-alt" style="font-size: 20px; color: #35449a;"></i></button>
 
        <input required type="text" id="userInputNumber" placeholder="Enter the captcha" style="padding-left: 5px; margin-top: 10px;"><br>
       
        <input font-size: medium" type="submit" value="Login" id="login">
        
        <div id="loginMessage" style="color: red;"></div>
        
        <div id="banner_text" style="font-size: 10.5px; margin-top: 20px;"></div>
    </form>
    
</body>
</html>
