<%  
    // Add X-Frame-Options header to prevent clickjacking
    response.setHeader("X-Frame-Options", "DENY");
%>

<!DOCTYPE html>
<html>
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png" />
<link rel="stylesheet" href="css_files/ionicons.min.css">
<link rel="stylesheet" href="css_files/normalize.min.css">
<link rel="stylesheet" href="css_files/fonts.txt" type="text/css">
<link rel="stylesheet" href="nav-bar.css" />
<script src="jquery-3.6.0.min.js"></script>
    
<style>

.container.center label {
           display: block;
   text-align: left;
   margin-left: -11%;
        }
        
          .popup {
  display: none;
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background-color: #d5d3d3;
  border: 1px solid #ccc;
  padding: 20px;
  box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5);
  z-index: 1000;
  text-align: center; /* Center-align the content */
  width: 20%;
}

/* Style for the close button */
#closePopup {
  display: block; /* Display as to center horizontally */
  margin-top: 30px; /* Adjust the top margin as needed */
  background-color: #4caf50;
  color: #fff;
  border: none;
  padding: 10px 20px;
  cursor: pointer;
  margin-left: 40%;
}

.note {
    color: red;
    text-align: left;
    
}

   .email-container {
        
        align-items: center;
        justify-content: center;
        height: 10vh; /* Optional: Set a height to center vertically within the viewport */
    }

    #sendOTP,
    #email_sendOTP {
        width: 90px;
        margin-top: -14px;
    }

    #error-message {
        color: red;
        margin-top: 10px; /* Adjust as needed */
    }

    </style>
    
    <script>
    var secretKey;
   
        function getSecretKey(){
        	$.ajax({

    			type : "GET",
    			url : "twofacorAuthOTPServlet", // URL of your servlet 
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
          
            $.ajax({
    			url : "qrcodeServlet",
    			type : "POST",
    			data : {
    				otp: otpValue,
    				secretKey: secretKey,
    				action: 'totp-authentication'
    			},
                success: function (response) {
                   
                   
                    if(response.status === 'success'){
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
        
        function validateEmailFormat(email) {
            // Regular expression for basic email validation
            var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }
        
        function sendEmailOTP(){
        	
        	 var to_email_id = $('#to_email_id').val();
        	 
        	 if (validateEmailFormat(to_email_id)) {
                 $.ajax({
                     url: 'twofacorAuthOTPServlet',
                     type: 'POST',
                     data: {
                         to_email_id: to_email_id
                     },
                     success: function (data) {
                    	 
                    	 $("#popupMessage").text(data.message);
               			$("#customPopup").show();
                         
                     },
                     error: function (xhr, status, error) {
                         
                     }
                 });
             } else {
                 
            	 $("#popupMessage").text('Invalid email format. Please enter a valid email address.');
       			$("#customPopup").show();
       			
             }
        }
        
        
        function validateEmailOTP(){
        	        	
        	var emailOtpValue = document.getElementById("email_otp").value;
                     
            $.ajax({
    			url : "qrcodeServlet",
    			type : "POST",
    			data : {
    				email_otp: emailOtpValue,
    				action: 'totp-authentication-email'
    			},
                success: function (response) {
                    
                    if(response.status === 'success'){
                    	window.location.href = 'overview.jsp';
                    }else{
                    	
                    	// Display an error message on the same page
                        document.getElementById("error-message-email").innerHTML = "Incorrect OTP. Please try again.";
                        $('#email_otp').val('');
                    	
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
        	
        	$("#closePopup").click(function () {
    		    $("#customPopup").hide();
    		  });
        	
        	 $('#get_otp').click(function() {
        		 sendEmailOTP();
				  
			  });
        	
        });
        
    </script>
   
</head>
<body>

	<div class="content1">
		<section style="margin-left: 1em">
			<h3 style="margin-top: 68px;">TWO FACTOR AUTHENTICATION</h3>
				<hr>
			<div class="container-wrapper">
			
		<div class="mobile-container" style="display: flex; flex-direction: column; align-items: left;">
    <h3>Authenticator App OTP</h3>
    <div class="row" style="display: flex; justify-content: left; align-items: left;">
        <input type="hidden" id="action" name="action" value="">
        <input type="password" id="otp" placeholder="Enter OTP" style="margin-left: 208px; width: 129px; margin-top: -36px; height: 17px;">
        <input type="button" id="sendOTP" onclick="sendOTP();" value="Validate OTP" style="margin-left: 15px; margin-top: -35px; height: 30px;">
        <div id="error-message" style="color: red; margin-left: 2%;"></div>
    </div>
</div>
			
			
			
			
			</div>
			
			<h3>EMAIL OTP</h3>
			<hr>
			
			 <div class="container1">

                <label for="to_email_id" style="display: inline-block; margin-top: 10px;">To email id</label>
<input required type="text" id="to_email_id" name="to_email_id" style="display: inline-block; padding-left: 5px; width: 15%; margin-top: 10px;">
<input type="button" value="Get OTP" id="get_otp" style="display: inline-block; margin-left: 10px;">
                

            </div>
            
            <div class="email-container">
				
				<div class="row" style="display: flex;   justify-content: left; align-items: left;">
					
    				 <input type="hidden" id="action" name="action" value="">
    				
    				<label for="enter_otp" style="display: inline-block; margin-top: 20px;">Enter OTP</label>
    				<input type="password" id="email_otp" style="width: 10%; margin-top: 20px; margin-left: 10px;">
    				<input type="button" id="email_sendOTP" value="Validate OTP" onclick="validateEmailOTP();" style="margin-left: 5.5%; height: 30px; margin-top: 20px;">
					<div id="error-message-email" style="color: red; margin-left: 2%;"></div>
				</div>
    			
			</div>
			
			<div class="note">
					<p>Note: Email OTP is valid upto 5 minutes</p>
				</div>
			
            <div id="customPopup" class="popup">
  				<span class="popup-content" id="popupMessage"></span>
  				<button id="closePopup">OK</button>
			  </div>
			
	</section>
	</div>
    
</body>
</html>
