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
   
        function getSecretKey(){
        	$.ajax({

    			type : "GET",
    			url : "TOTPOTPServlet", // URL of your servlet 
    			dataType : 'json',
    			success : function(data) {
    				
    					secretKey = data.totp_key;
    					
    			},
    			error : function() {
    				// Handle errors here
    				console.error("Ajax request failed");
    			}
    		});
        }
        
        function sendOTP() {
            // Get the OTP value from the input field
            var otpValue = document.getElementById("otp").value;
            console.log("OTP -->"+otpValue);
          
            $.ajax({
    			url : "imageServlet",
    			type : "POST",
    			data : {
    				otp: otpValue,
    				secretKey: secretKey,
    				action: 'totp-authentication'
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
                    	
                    }
                    
                },
                error: function () {
                    // Handle errors here
                    console.error("totp authentication failed");
                }
            });
        }
        
        $(document).ready(function() {
        	getSecretKey();
        	
        });
        
    </script>
    
    
   
</head>
<body>

	<div class="content1">
		<section style="margin-left: 1em">
			<h3>TOTP AUTHENTICATION</h3>
				<hr>
			
			<div class="container">
				
				<div class="row" style="display: flex;   justify-content: center; align-items: center; margin-top: -20px;">
					
    				 <input type="hidden" id="action" name="action" value="">
    				
    				<input type="text" id="otp" placeholder="Enter OTP" style="width: 15%; margin-left: 1%;">
    				<input type="button" id="sendOTP" onclick="sendOTP();" value="Send OTP" style="margin-left: 1%">
					<div id="error-message" style="color: red; margin-left: 2%;"></div>
				</div>
    			
			
			</div>
			
			
			
	</section>
	</div>
    
</body>
</html>
