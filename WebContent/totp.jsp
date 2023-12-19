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

h3{
margin-top: 68px;
}

 .container.center {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
        }


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
        
        function validateEmailFormat(email) {
            // Regular expression for basic email validation
            var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }
        
        function sendEmailOTP(){
        	
        	 var to_email_id = $('#to_email_id').val();
        	 
        	 if (validateEmailFormat(to_email_id)) {
                 $.ajax({
                     url: 'TOTPOTPServlet',
                     type: 'POST',
                     data: {
                         to_email_id: to_email_id
                     },
                     success: function (data) {
                         
                     },
                     error: function (xhr, status, error) {
                         console.log('Error getting OTP: ' + error);
                     }
                 });
             } else {
                 
            	 $("#popupMessage").text('Invalid email format. Please enter a valid email address.');
       			$("#customPopup").show();
       			
             }
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
			<h3>TOTP AUTHENTICATION</h3>
				<hr>
			
			<div class="container">
				
				<div class="row" style="display: flex;   justify-content: center; align-items: center; margin-top: -20px;">
					
    				 <input type="hidden" id="action" name="action" value="">
    				
    				<input type="password" id="otp" placeholder="Enter OTP" style="width: 15%; margin-left: 1%;">
    				<input type="button" id="sendOTP" onclick="sendOTP();" value="Validate OTP" style="margin-left: 1%">
					<div id="error-message" style="color: red; margin-left: 2%;"></div>
				</div>
    			
			</div>
			
			<h3>EMAIL OTP</h3>
			<hr>
			
			 <div class="container center">

                <!-- <label for="username" style="float: left;">Username</label>
                <input required type="text" id="username" name="username" style="padding-left: 5px; width: 15%;"><br> -->

                <label for="to_email_id" style="float: left; margin-top: 10px;">To email id</label>
                <input required type="text" id="to_email_id" name="to_email_id" style="padding-left: 5px; width: 15%; margin-top: 10px;"><br>

                <input type="button" value="Get OTP" id="get_otp" style="margin-top: 10px;">

            </div>
            
            <div id="customPopup" class="popup">
  				<span class="popup-content" id="popupMessage"></span>
  				<button id="closePopup">OK</button>
			  </div>
			
	</section>
	</div>
    
</body>
</html>
