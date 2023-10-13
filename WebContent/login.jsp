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
         function generateRandomAlphanumeric() {
        	 const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        	    const numChars = characters.length;
        	    let result = '';
        	    const length = 6; // You can change this to generate strings of different lengths
        	    const numNumbers = 2; // Change this to the number of numbers you want

        	    for ( i = 0; i < length; i++) {
        	        if (i == 2 || i == 4) {
        	            // Ensure the first 'numNumbers' characters are numbers
        	            result += '0123456789'.charAt(Math.floor(Math.random() * 10));
        	        } else {
        	            // For the remaining characters, choose from the full set of characters
        	            const randomIndex = Math.floor(Math.random() * numChars);
        	            result += characters.charAt(randomIndex);
        	        }
        	    }

        	    return result;
        	}
     
        	
        	function generateImageWithNumber() {
        	    const randomNumber = generateRandomAlphanumeric();

        	    // Get the canvas element
        	    const canvas = document.createElement('canvas');
        	    canvas.width = 220; // Adjust the canvas size as needed
        	    canvas.height = 120;

        	    // Get the drawing context
        	    const ctx = canvas.getContext('2d');

        	    // Customize the appearance of the text
        	    ctx.fillStyle = 'white'; // Text color
        	    ctx.fillRect(0, 0, canvas.width, canvas.height); // Background color
        	    ctx.font = '36px Arial'; // Font size and family
        	    ctx.fillStyle = 'black'; // Text color

        	    // Center the text on the canvas
        	    ctx.textAlign = 'center';
        	    ctx.textBaseline = 'middle';

        	    // Calculate the space between characters
        	    const characterSpacing = 10; // Adjust the space between characters as needed

        	    // Calculate the total width needed for the text
        	    const totalTextWidth = (24 + characterSpacing) * randomNumber.length - characterSpacing;

        	    // Calculate the starting position for the text
        	    const startX = (canvas.width - totalTextWidth) / 2;
        	    
        	 // Draw a horizontal line in the middle of the canvas
        	    ctx.beginPath();
        	    ctx.moveTo(0, canvas.height / 2);
        	    ctx.lineTo(canvas.width, canvas.height / 2);
        	    ctx.stroke();

        	    // Draw each character with space between them
        	    for (var i = 0; i < randomNumber.length; i++) {
        	        const character = randomNumber.charAt(i);
        	        ctx.fillText(character, startX + i * (24 + characterSpacing), canvas.height / 2);
        	    }

        	    // Create an image element
        	    const img = new Image();

        	    // Set the source of the image to the canvas data URL
        	    img.src = canvas.toDataURL('image/png');

        	    // Clear the previous image (if any)
        	    const imageContainer = document.getElementById('imageContainer');
        	    imageContainer.innerHTML = '';

        	    // Append the new image to the container
        	    imageContainer.appendChild(img);

        	    // Store the generated random number in a data attribute
        	    img.setAttribute('data-random-number', randomNumber);
        	}



      
         function checkUserInput() {
             // Get the user's input
             const userInput = $('#userInputNumber').val();

             // Get the stored random number from the image
             const storedRandomNumber = $('#imageContainer img').attr('data-random-number');

             // Check if the user's input matches the stored random number
             if (userInput === storedRandomNumber) {
                 // Call your checkLogin function or do whatever you want
                 $('#loginMessage').text('Captcha is correct. You may proceed.').css('color', 'green');
                 checkLogin();
             } else {
                 $('#loginMessage').text('Captcha is incorrect. Please try again.').css('color', 'red');
                 $('#userInputNumber').val('');
                 // Generate a new random number/image
                 generateImageWithNumber();
             }
         }
         

        $(document).ready(function () {
        	generateImageWithNumber();
        	// Attach the checkLogin function to the form submission
        	$('#loginForm').submit(function(event) {
                event.preventDefault(); // Prevent the default form submission               
                checkUserInput();
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
        
       #imageContainer img {
          
            width: 38%;
        }
    </style>
</head>
<body style="background-color: #2e3891d4;">
    <form action="WP500Login" method="post" class="container" id="loginForm">
        <div>
            <img src="images/WP_connex_logo_full.png" alt="Tasm2mLogo">
        </div>
        
        <p style="font-size: medium;"><b>WPConnex Web Configuration</b></p>
        <label for="username" style="float: left;">Username</label>
        <input required type="text" id="username" name="username" style="padding-left: 5px;"><br>
        
        <label for="password" style="float: left;">Password</label>
        <input required type="password" id="password" name="password" style="padding-left: 5px;"><br><br>
     	<div id="imageContainer">
        <!-- The generated image will be displayed here -->
   		 </div>
        <label for="captcha" style="float: left;">Captcha</label>
        <input required type="text" id="userInputNumber" placeholder="Enter the captcha" style="padding-left: 5px;"><br>
       
        <input font-size: medium" type="submit" value="Login" id="login">
        
        <div id="loginMessage" style="color: red;"></div>
        
    </form>
</body>
</html>
