<!DOCTYPE html>
<html>
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png" />

<link rel="stylesheet" href="css_files/ionicons.min.css">
<link rel="stylesheet" href="css_files/normalize.min.css">
<link rel="stylesheet" href="css_files/fonts.txt" type="text/css">	
<link rel="stylesheet" href="nav-bar.css" />
<link rel="stylesheet" href="css_files/all.min.css">
<link rel="stylesheet" href="css_files/fontawesome.min.css">
<script src="jquery-3.6.0.min.js"></script>

<style>/* Styles for the circular toggle switch */
/* Style for the container */
.toggle-container {
	display: inline-block;
	position: relative;
	width: 59px;
	height: 30px;
	background-color: #ccc;
	border-radius: 15px; /* Half of the height for circular edges */
	cursor: pointer;
}

/* Style for the switch (circle) */
.toggle-switch {
	position: absolute;
	top: 2px;
	left: 2px;
	width: 26px; /* Width of the circle */
	height: 26px; /* Height of the circle */
	background-color: #fff;
	border-radius: 50%; /* Makes it circular */
	transition: 0.3s; /* Smooth transition */
}

/* Style for the checked state */
.toggle-container.active .toggle-switch {
	left: 32px; /* Move the circle to the right */
}

.modal-edit,
.modal-session-timeout {
	display: none;
	position: fixed;
	z-index: 1;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.5);
	justify-content: center;
	align-items: center;
	min-height: 100vh;
	margin: 0;
}

.modal-content-edit,
.modal-content-session-timeout {
	background-color: #d5d3d3;
	padding: 20px;
	border-radius: 5px;
	text-align: center;
	position: relative;
	width: 300px;
	transform: translate(0, -50%); /* Center vertically */
	top: 50%; /* Center vertically */
	left: 50%; /* Center horizontally */
	transform: translate(-50%, -50%);
	/* Center horizontally and vertically */
}

button {
	margin: 5px;
	padding: 10px 20px;
	border: none;
	cursor: pointer;
}

#confirm-button-edit,
#confirm-button-session-timeout {
	background-color: #4caf50;
	color: white;
}

#cancel-button-edit {
	background-color: #f44336;
	color: white;
}

.toggle-text {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-left: 10px; /* Adjust the spacing between text and switch */
	width: 100px; /* Adjust the width as needed */
}

#enableText, #disableText {
	font-size: 14px; /* Adjust the font size as needed */
	color: #333; /* Text color */
	margin: 0; /* Reset margin */
	display: none; /* Initially hide the text */
}

/* Style for the enable text when active */
.toggle-container.active+.toggle-text #enableText {
	display: inline;
}

.toggle-container.active+.toggle-text #disableText {
	display: inline;
}

#generateQR {
	margin-top: 15px;
}

#imageContainer {
	margin-top: 2%;
}

.note {
	color: red;
	margin-top: 5%;
}

.test-totp {
	margin-top: 15px;
}

#otp, #sendOTP {
	display: none;
}

#auth_app {
	height: 50px;
	width: 50px;
}

h3 {
	margin-top: 68px;
}

.steps_container{
display: flex;      
            height: 19vh;
}

.step {
  flex: 0 0 0; /* Adjust the width as needed */
  text-align: center;
  margin: 10px;
  padding: 10px;
}

.step img {
  margin-bottom: 10px;
  width: 100px; /* Set your preferred width */
  height: 100px; /* Set your preferred height */
}

#totp_steps{
margin-left: -39px;
}

#loader-overlay {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(255, 255, 255, 0.7); /* Transparent white background */
    z-index: 1000; /* Ensure the loader is on top of other elements */
    justify-content: center;
    align-items: center;
}

#loader {
    text-align: center;
    padding: 20px;
    background: #fff; /* Loader background color */
    border-radius: 5px;
}

</style>

<script>
	var isActive;
	var qr_status;
	var secretKey;
	var roleValue;
	var tokenValue;
	
	function ntpSyncStatus(){
		
		$.ajax({

			url : 'overviewGetData',
			type : 'GET',
			dataType : 'json',
			beforeSend : function(xhr) {
				xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
			},
			success : function(data) {
				
			if (data.status == 'fail') {
				
				 var modal = document.getElementById('custom-modal-session-timeout');
				  modal.style.display = 'block';
				  
				// Update the session-msg content with the message from the server
				    var sessionMsg = document.getElementById('session-msg');
				    sessionMsg.textContent = data.message; // Assuming data.message contains the server message
				  
				  // Handle the confirm button click
				  var confirmButton = document.getElementById('confirm-button-session-timeout');
				  confirmButton.onclick = function () {
					  
					// Close the modal
				        modal.style.display = 'none';
				        window.location.href = 'login.jsp';
				  };
					  
			} 
			
			else {
				// Assuming data.NTP_SYNC_STATUS is a string with values 'yes' or 'no'
				var ntpSyncStatus = data.NTP_SYNC_STATUS;

				// Select the element with id "ntp_sync"
				var ntpSyncElement = $("#ntp_sync");

				// Set the text content
				ntpSyncElement.text("NTP sync status : " + ntpSyncStatus);

				// Update the color based on the value of data.NTP_SYNC_STATUS
				if (ntpSyncStatus === 'yes') {
				  // Wrap 'yes' in a span with green color
				  ntpSyncElement.html("NTP sync status : <span style='color: green;'>yes</span>");
				} else if (ntpSyncStatus === 'no') {
				  // Wrap 'no' in a span with red color
				  ntpSyncElement.html("NTP sync status : <span style='color: red;'>no</span>");
				}

	            }
				
			},

			error : function(xhr, status, error) {
				console.log('Error loading opcua client data: ' + error);
			}

		});
	}

	function updateTOTP(element) {
	    // Get references to necessary elements
	    var toggleContainer = document.querySelector('.toggle-container');
	    var enableText = document.getElementById("enableText");
	    var disableText = document.getElementById("disableText");
	    var modal = document.getElementById('custom-modal-edit');

	    // Display the custom modal dialog
	    modal.style.display = 'block';

	    // Handle the confirm button click
	    var confirmButton = document.getElementById('confirm-button-edit');
	    confirmButton.onclick = function () {
	        // Check if the toggle switch is enabled and call generateQRCode if true
	        if (toggleContainer.classList.contains('active')) {
	        	//location.reload();
	            generateQRCode();
	        }

	        // Send data to the server based on the toggle switch state
	        sendDataToServlet(toggleContainer.classList.contains('active') ? "enable" : "disable");

	        // Close the modal
	        modal.style.display = 'none';
	        
	     // If the toggle switch is enabled, refresh the page
	        if (toggleContainer.classList.contains('active')) {
	        	generateQRCode();
	        }
	    };

	    // Toggle the switch state and update text accordingly
	    if (toggleContainer.classList.contains('active')) {
	        // Toggle switch is enabled, so we want to disable it
	        toggleContainer.classList.remove('active');
	        enableText.style.display = "none";
	        disableText.style.display = "inline";

	        // Clear the image container and update the button text
	        var container = document.getElementById("imageContainer");
	        while (container.firstChild) {
	            container.removeChild(container.firstChild);
	        }
	        $('#generateQR').val('Generate QR code');
	    } else {
	        // Toggle switch is disabled, so we want to enable it
	        toggleContainer.classList.add('active');
	        enableText.style.display = "inline";
	        disableText.style.display = "none";
	    }

	    // Handle the cancel button click
	    var cancelButton = document.getElementById('cancel-button-edit');
	    cancelButton.onclick = function () {
	        // Revert the toggle switch state when Cancel is clicked
	        if (toggleContainer.classList.contains('active')) {
	            toggleContainer.classList.remove('active');
	            enableText.style.display = "none";
	            disableText.style.display = "inline";
	        } else {
	            toggleContainer.classList.add('active');
	            enableText.style.display = "inline";
	            disableText.style.display = "none";
	        }

	        // Close the modal
	        modal.style.display = 'none';
	    };
	}


	function sendDataToServlet(totp_authenticator) {
	    $.ajax({
	        type: "POST",
	        url: "TOTPServlet",
	        data: {
	            totp_authenticator: totp_authenticator
	        },
	        success: function(response) {
	        	

	        },
	        error: function(xhr, textStatus, errorThrown) {
	            // Handle any errors that occur during the AJAX request
	            console.error("Error sending data: " + errorThrown);
	        }
	    });
	}


	function getTOTPDetails() {
		// Display loader when the request is initiated
	    showLoader();

		$.ajax({
			type : "GET",
			url : "TOTPServlet", // Replace with the actual URL to retrieve TOTP details
			dataType : "json",
			beforeSend : function(xhr) {
				xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
			},
			data: {
	            action: 'getTOTPDetails'
	        },
			success : function(data) {
				// Hide loader when the response has arrived
	            hideLoader();
				
				var enableText = document.getElementById("enableText");
				var disableText = document.getElementById("disableText");

				if (data.totp_authenticator === "enable") {
					// If TOTP authenticator is enabled, show "Enable" and hide "Disable"
					$('.toggle-container').addClass('active');
					enableText.style.display = "inline";
					disableText.style.display = "none";
					
					
				} else {
					// If TOTP authenticator is disabled, show "Disable" and hide "Enable"
					$('.toggle-container').removeClass('active');
					enableText.style.display = "none";
					disableText.style.display = "inline";
				}
			},
			error : function(xhr, textStatus, errorThrown) {
				// Hide loader when the response has arrived
	            hideLoader();
				
				console.error("Error fetching TOTP details: " + errorThrown);
			}
		});
	}

	function generateQRCode() {
		
    	var container = document.getElementById("imageContainer");
    	while (container.firstChild) {
        	container.removeChild(container.firstChild);
    	}


		$.ajax({

			type : "GET",
			url : "imageServlet", // URL of your servlet    
			 data: {
		            action: "generate"
		        },
			success : function(data) {
				// Handle the response data (data.qr_image and data.secret_key)
				if (data.qr_image && data.user_secret_key) {
					secretKey = data.user_secret_key;
					// You can use data.qr_image and data.secret_key here
					displayQRImage(data.qr_image);

					// Update your HTML elements with the data if needed
				} else {
					// Handle the case where the response does not contain the expected data
					console.error("Invalid response data");
				}
			},
			error : function() {
				// Handle errors here
				console.error("Ajax request failed");
			}
		});
	}
	
	
	function getQRCode() {
 
		$.ajax({

			type : "GET",
			url : "imageServlet", // URL of your servlet 
			 data: {
		            action: "get"
		        },
			success : function(data) {
				// Handle the response data (data.qr_image and data.secret_key)
				
				qr_status = data.qr_status;
				
				if (data.qr_image  && data.user_secret_key) {
					secretKey = data.user_secret_key;
	                displayQRImage(data.qr_image);

	                // Check qr_status and disable the button if true
	                 if (qr_status) {
	                	$('#generateQR').val('Regenerate QR Code');
	                } else {
	                	$('#generateQR').val('Generate QR code');
	                } 
	            } else {
	                // Handle the case where the response does not contain the expected data
	                console.error("Invalid response data");
	            }
					
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
				action: 'test-totp'
			},
            success: function (response) {
                // Handle the response from the server, if needed
              
                var message = document.getElementById("message");
               
                if(response.otp_result === 'true'){
                	message.style.color = "green";
                    message.innerHTML = "Your OTP is correct; you can now log in with TOTP.";
                }else{
                	// OTP is incorrect, display in red
                    message.style.color = "red";
                    message.innerHTML = "Incorrect OTP. Please try again or check device time.";
                    $('#otp').val('');
                	
                }
                
            },
            error: function () {
                // Handle errors here
                console.error("TOTP authentication failed");
            }
        });
    }

	function displayQRImage(base64Image) {
		// Create an img element
		var imgElement = document.createElement("img");

		// Set the src attribute with the base64 image data
		imgElement.src = "data:image/png;base64," + base64Image; // Assuming the image is in PNG format

		// Append the image to a container element in your HTML (e.g., a <div>)
		var container = document.getElementById("imageContainer"); // Replace "imageContainer" with the ID of your container element
		container.appendChild(imgElement);
	}
	
	// Function to show the loader
	 function showLoader() {
	     // Show the loader overlay
	     $('#loader-overlay').show();
	 }

	 // Function to hide the loader
	 function hideLoader() {
	     // Hide the loader overlay
	     $('#loader-overlay').hide();
	 }

	$(document).ready(function() {
		
		<%// Access the session variable
			HttpSession role = request.getSession();
			String roleValue = (String) session.getAttribute("role");%>

	roleValue = '<%=roleValue%>';
	
	if (roleValue === "null") {
        var modal = document.getElementById('custom-modal-session-timeout');
        modal.style.display = 'block';

        // Handle the confirm button click
        var confirmButton = document.getElementById('confirm-button-session-timeout');
        confirmButton.onclick = function() {
            // Close the modal
            modal.style.display = 'none';
            window.location.href = 'login.jsp';
        };
    }else{
    	<%// Access the session variable
			HttpSession token = request.getSession();
			String tokenValue = (String) session.getAttribute("token");%>

	tokenValue = '<%=tokenValue%>';
	
	ntpSyncStatus();

							$('.toggle-container').click(function() {
								updateTOTP(this);
							});

							getTOTPDetails();

							$('#generateQR').click(function() {
								generateQRCode();
							});

							getQRCode();

							$('#test-totp').click(function() {
								// Show the OTP textbox and Send OTP button
								$('#test-totp').css('display', 'none');
								$('#otp').css('display', 'inline');
								$('#sendOTP').css('display', 'inline');
							});

							$('#sendOTP').click(function() {
								sendOTP();
							});
						}
					});
</script>

<body>

	<div class="sidebar">
		<%@ include file="common.jsp"%>
	</div>
	<div class="header">
		<%@ include file="header.jsp"%>
	</div>

	<div class="content">
		<section style="margin-left: 1em">
			<h3>2 FACTOR AUTHENTICATION</h3>
			<hr>

			<div class="container">
			
				<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>

	<p id="ntp_sync" style="font-weight: bold; font-size: 16px; margin-top: -15px;"></p>

				<div class="toggle-container">
					<div id="toggle-switch" class="toggle-switch"></div>
				</div>
				<div class="toggle-text">
					<span id="disableText">Disable</span> <span id="enableText">Enable</span>
				</div>

				<input type="hidden" id="action" name="action" value="">

				<div class="generateQRcode">
					<input type="button" id="generateQR" value="Generate QR code">
					<div id="imageContainer"></div>
				</div>

				<div class="test-totp">
					<input type="button" id="test-totp" value="Test TOTP"> <input
						type="password" id="otp" placeholder="Enter OTP"
						style="width: 15%;"> <input type="button" id="sendOTP"
						value="Validate OTP" style="margin-left: 1%">
					<div id="message"></div>

				</div>

				<div class="note">

					<p>
						Please install <b>Authenticator App</b> <img id="auth_app"
							src="images/auth.png" alt="Authenticator App image"> on
						your mobile phone for scanning QR code and save this QR code for
						further use.
					</p>

					<p>
						To ensure proper functionality of TOTP, <b>time</b> must be
						correctly synchronized with the device.
					</p>

				</div>

			</div>
			
			
			<div class="steps_container">
			<!-- Step 1: Enable Two-Factor Authentication -->
<div class="step">
    <p>Step 1</p>
    <img src="icons/toggle.png" alt="Switch Icon">
    <p>Enable 2FA</p>
</div>

<!-- Step 2: Scan QR Code -->
<div class="step">
    <p>Step 2</p>
    <img src="icons/scan_qr.jpg" alt="QR Code" width="150" height="150">
    <p>Scan QR Code</p>
</div>

<!-- Step 3: Test TOTP -->
<div class="step">
    <p>Step 3</p>
    <img src="icons/test_totp.jpg" alt="Test TOTP Icon">
    <p>Test TOTP</p>
</div>

<!-- Step 4: Logout -->
<div class="step">
    <p>Step 4</p>
    <img src="icons/logout.png" alt="Logout Icon">
    <p>Logout</p>
</div>

<!-- Step 5: Log in Again -->
<div class="step">
    <p>Step 5</p>
    <img src="icons/login.png" alt="Login Icon">
    <p>Log in Again</p>
</div>

<!-- Step 6: Access Application -->
<div class="step">
    <p>Step 6</p>
    <img src="icons/validatetotp.jpg" alt="Access Icon">
    <p>Validate OTP</p>
</div>
</div>

			<div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
					<p>Are you sure you want to modify the TOTP authentication?</p>
					<button id="confirm-button-edit">Yes</button>
					<button id="cancel-button-edit">No</button>
				</div>
			</div>

			<div id="custom-modal-session-timeout" class="modal-session-timeout">
				<div class="modal-content-session-timeout">
					<p>Your session is timeout. Please login again</p>
					<button id="confirm-button-session-timeout">OK</button>
				</div>
			</div>

		</section>
	</div>

</body>
</html>