<!DOCTYPE html>
<html>
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <style>
    

.note {
    color: red;
    margin-top: 5%; 
   
}
    </style>
    
    <script>
    var secretKey;
   
        // Function to make an Ajax request
        /* function getImageAndSecretKey() {
            $.ajax({
                type: "GET",
                url: "imageServlet", // URL of your servlet               
                success: function (data) {
                    // Handle the response data (data.qr_image and data.secret_key)
                    if (data.qr_image && data.secret_key) {
                    	secretKey = data.secret_key;
                        // You can use data.qr_image and data.secret_key here
                        displayQRImage(data.qr_image);
                        
                        var secretKeyDisplay = document.getElementById("secretKeyDisplay");
                        secretKeyDisplay.innerHTML = "Secret Key: " +data.secret_key;
                        
                        // Update your HTML elements with the data if needed
                    } else {
                        // Handle the case where the response does not contain the expected data
                        console.error("Invalid response data");
                    }
                },
                error: function () {
                    // Handle errors here
                    console.error("Ajax request failed");
                }
            });
        } */
        
        
        /* function displayQRImage(base64Image) {
            // Create an img element
            var imgElement = document.createElement("img");

            // Set the src attribute with the base64 image data
            imgElement.src = "data:image/png;base64," + base64Image; // Assuming the image is in PNG format

            // Append the image to a container element in your HTML (e.g., a <div>)
            var container = document.getElementById("imageContainer"); // Replace "imageContainer" with the ID of your container element
            container.appendChild(imgElement);
        } */
        
        function sendOTP() {
            // Get the OTP value from the input field
            var otpValue = document.getElementById("otp").value;
            console.log("OTP -->"+otpValue);
            $.ajax({
    			url : "imageServlet",
    			type : "POST",
    			data : {
    				otp: otpValue,
    				secretKey: secretKey    				
    			},
                success: function (response) {
                    // Handle the response from the server, if needed
                    console.log("OTP -->"+response.otp_result);
                   
                    if(response.otp_result === 'true'){
                    	window.location.href = 'overview.jsp';
                    }else{
                    	
                    	// Display an error message on the same page
                        document.getElementById("error-message").innerHTML = "Incorrect OTP. Please try again.";
                        $('#otp').val('');
                    	//window.location.href = 'totp.jsp';
                    }
                    
                },
                error: function () {
                    // Handle errors here
                    console.error("totp authentication failed");
                }
            });
        }
        
    </script>
    
   
</head>
<body>

	<div class="content1">
		<section style="margin-left: 1em">
			<h3>TOTP AUTHENTICATION</h3>
				<hr>
			
			<div class="container">
				
				<div class="row" style="display: flex;   justify-content: center; align-items: center; margin-top: -20px;">
					<!-- input type="button" onclick="getImageAndSecretKey()" id="showQRCode" value="Get Image and Secret Key">
    				<div id="imageContainer" style="margin-left: 1%">
    				
    				</div>
    				
    				<div id="secretKeyContainer">
    					<span id="secretKeyDisplay"></span>
					</div>
    				 -->
    				
    				<input type="text" id="otp" placeholder="Enter OTP" style="width: 15%; margin-left: 1%;">
    				
    
    				<input type="button" onclick="sendOTP()" id="sendOTP" value="Send OTP" style="margin-left: 1%">
					<div id="error-message" style="color: red; margin-left: 2%;"></div>
				</div>
    			
			
			<!-- <div class="note">
				<p>Note: Please install <b>Authenticator App</b> on your mobile phone for scanning QR code.</p>
			</div> -->
			</div>
			
			
			
	</section>
	</div>
    
</body>
</html>
