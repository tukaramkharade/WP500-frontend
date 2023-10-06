<!DOCTYPE html>
<html>
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32"
	href="images/WP_Connex_logo_favicon.png" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

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

.modal-edit {
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

.modal-content-edit {
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

#confirm-button-edit {
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

.test-totp{
margin-top: 15px;
}

#otp, #sendOTP {
    display: none;
}

</style>

<script>
	var isActive;
	var qr_status;
	var secretKey;

	function updateTOTP(element) {

		element.classList.toggle('active');
		var toggleContainer = document.querySelector('.toggle-container');
		isActive = toggleContainer.classList.contains('active');

		var enableText = document.getElementById("enableText");
		var disableText = document.getElementById("disableText");

		if (isActive) {
			// Toggle switch is enabled
			sendDataToServlet("enable");
			enableText.style.display = "inline";
			disableText.style.display = "none";
		} else {
			// Toggle switch is disabled
			sendDataToServlet("disable");
			enableText.style.display = "none";
			disableText.style.display = "inline";
		}
	}

	function sendDataToServlet(totp_authenticator) {

		// Display the custom modal dialog
		var modal = document.getElementById('custom-modal-edit');
		modal.style.display = 'block';

		// Handle the confirm button click
		var confirmButton = document.getElementById('confirm-button-edit');
		confirmButton.onclick = function() {

			$.ajax({
				type : "POST",
				url : "TOTPServlet",
				data : {
					totp_authenticator : totp_authenticator
				},
				success : function(response) {
					// Close the modal
					modal.style.display = 'none';

				},
				error : function(xhr, textStatus, errorThrown) {
					// Handle any errors that occur during the AJAX request
					console.error("Error sending data: " + errorThrown);
				}
			});
		};
		var cancelButton = document.getElementById('cancel-button-edit');
		cancelButton.onclick = function() {
			// Close the modal
			modal.style.display = 'none';

		};

	}

	function getTOTPDetails() {

		$.ajax({
			type : "GET",
			url : "TOTPServlet", // Replace with the actual URL to retrieve TOTP details
			dataType : "json",
			data: {
	            action: 'getTOTPDetails'
	        },
			success : function(data) {
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
	
	function changeButtonColor(isDisabled) {
        var $generateQR_button = $('#generateQR');       
        
        
        if (isDisabled) {
            $generateQR_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $generateQR_button.css('background-color', '#2b3991'); // Reset to original color
        } 
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
                console.log("OTP -->"+response.otp_result);
                
                var message = document.getElementById("message");
               
                if(response.otp_result === 'true'){
                	message.style.color = "green";
                    message.innerHTML = "OTP is correct.";
                }else{
                	// OTP is incorrect, display in red
                    message.style.color = "red";
                    message.innerHTML = "Incorrect OTP. Please try again.";
                    $('#otp').val('');
                	//window.location.href = 'totp.jsp';
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

	$(document).ready(function() {

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
					 <input type="button" id="test-totp" value="Test TOTP">
					 <input type="password" id="otp" placeholder="Enter OTP" style="width: 15%;">
    				<input type="button" id="sendOTP" value="Validate OTP" style="margin-left: 1%">
    				<div id="message" style="margin-left: 2%;"></div>
					
				</div>
				
				

				<div class="note">
					<p>Note: Please install <b>Authenticator App</b> on your mobile phone for scanning QR code and save this QR code for further use.</p>
					
				</div>
				

			</div>

			<div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
					<p>Are you sure you want to edit the TOTP authentication?</p>
					<button id="confirm-button-edit">Yes</button>
					<button id="cancel-button-edit">No</button>
				</div>
			</div>

		</section>
	</div>

</body>
</html>