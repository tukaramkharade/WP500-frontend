<%
    response.setHeader("X-Frame-Options", "DENY");
    response.setHeader("X-Content-Type-Options", "nosniff");
    HttpSession session1 = request.getSession();
    String secureFlag = "Secure";
    String httpOnlyFlag = "HttpOnly";
    String sameSiteFlag = "SameSite=None"; // Add this line for SameSite attribute
    String cookieValue = session1.getId();
    String headerKey = "Set-Cookie";
    String headerValue = String.format("%s=%s; %s; %s; %s", session1.getId(), cookieValue, secureFlag, httpOnlyFlag, sameSiteFlag);
    response.setHeader(headerKey, headerValue);
%>

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
.toggle-container {
	display: inline-block;
	position: relative;
	width: 59px;
	height: 30px;
	background-color: #ccc;
	border-radius: 15px; /* Half of the height for circular edges */
	cursor: pointer;
}

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
   margin-left: 120px;
    background: rgba(255, 255, 255, 0.2); /* Transparent white background */
    border-radius: 5px;
}

</style>

<script>
	var isActive;
	var qr_status;
	var secretKey;
	var roleValue;
	var tokenValue;
	var csrfTokenValue;
	
	function ntpSyncStatus(){
		   var csrfToken = document.getElementById('csrfToken').value;	   
		$.ajax({
			url : 'overviewGetData',
			type : 'GET',
			dataType : 'json',
			data: {
				csrfToken: csrfToken
	        },
			beforeSend : function(xhr) {
				xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
			},
			success : function(data) {				
			if (data.status == 'fail') {			
				 var modal = document.getElementById('custom-modal-session-timeout');
				 modal.style.display = 'block';		  
				 var sessionMsg = document.getElementById('session-msg');
				 sessionMsg.textContent = data.message; // Assuming data.message contains the server message	  
				 var confirmButton = document.getElementById('confirm-button-session-timeout');
				 confirmButton.onclick = function () {			  
				        modal.style.display = 'none';
				        window.location.href = 'login.jsp';
				 };			  
			}		
			else {
				var ntpSyncStatus = data.NTP_SYNC_STATUS;
				var ntpSyncElement = $("#ntp_sync");
				ntpSyncElement.text("NTP sync status : " + ntpSyncStatus);
				if (ntpSyncStatus === 'yes') {
				  ntpSyncElement.html("NTP sync status : <span style='color: green;'>yes</span>");
				} else if (ntpSyncStatus === 'no') {
				  ntpSyncElement.html("NTP sync status : <span style='color: red;'>no</span>");
				}
	            }				
			},
			error : function(xhr, status, error) {				
			}
		});
	}

	function updateTOTP(element) {
	    var toggleContainer = document.querySelector('.toggle-container');
	    var enableText = document.getElementById("enableText");
	    var disableText = document.getElementById("disableText");
	    var modal = document.getElementById('custom-modal-edit');
	    modal.style.display = 'block';
	    var confirmButton = document.getElementById('confirm-button-edit');
	    confirmButton.onclick = function () {
	        if (toggleContainer.classList.contains('active')) {
	            generateQRCode();
	        }
	        sendDataToServlet(toggleContainer.classList.contains('active') ? "enable" : "disable");
	        modal.style.display = 'none';	        
	        if (toggleContainer.classList.contains('active')) {
	        	generateQRCode();
	        }
	    };
	    if (toggleContainer.classList.contains('active')) {
	        toggleContainer.classList.remove('active');
	        enableText.style.display = "none";
	        disableText.style.display = "inline";
	        var container = document.getElementById("imageContainer");
	        while (container.firstChild) {
	            container.removeChild(container.firstChild);
	        }
	        $('#generateQR').val('Generate QR code');
	    } else {
	        toggleContainer.classList.add('active');
	        enableText.style.display = "inline";
	        disableText.style.display = "none";
	    }
	    var cancelButton = document.getElementById('cancel-button-edit');
	    cancelButton.onclick = function () {
	        if (toggleContainer.classList.contains('active')) {
	            toggleContainer.classList.remove('active');
	            enableText.style.display = "none";
	            disableText.style.display = "inline";
	        } else {
	            toggleContainer.classList.add('active');
	            enableText.style.display = "inline";
	            disableText.style.display = "none";
	        }
	        modal.style.display = 'none';
	    };
	}

	function sendDataToServlet(totp_authenticator) {
		 var csrfToken = document.getElementById('csrfToken').value;	 
	    $.ajax({
	        type: "POST",
	        url: "twoFactorAuthServlet",
	        data: {
	            totp_authenticator: totp_authenticator,
	            csrfToken: csrfToken
	        },
	        success: function(response) { 	
	        },
	        error: function(xhr, textStatus, errorThrown) {
	            console.error("Error sending data: " + errorThrown);
	        }
	    });
	}

	function getTOTPDetails() {
 		var csrfToken = document.getElementById('csrfToken').value;
		$.ajax({
			type : "GET",
			url : "twoFactorAuthServlet", // Replace with the actual URL to retrieve TOTP details
			dataType : "json",			
			data: {
	            action: 'getTOTPDetails',
	            	csrfToken: csrfToken
	        },
			success : function(data) {
				var enableText = document.getElementById("enableText");
				var disableText = document.getElementById("disableText");		
				if (data.totp_authenticator === "enable") {
					$('.toggle-container').addClass('active');			
					enableText.style.display = "inline";
					disableText.style.display = "none";							
				} else {
					$('.toggle-container').removeClass('active');					
					enableText.style.display = "none";
					disableText.style.display = "inline";
				}
			},
			error : function(xhr, textStatus, errorThrown) {
			}
		});
	}

	function generateQRCode() {	
    	var container = document.getElementById("imageContainer");
    	while (container.firstChild) {
        	container.removeChild(container.firstChild);
    	}
    	 var csrfToken = document.getElementById('csrfToken').value;
		$.ajax({
			type : "GET",
			url : "qrcodeServlet", // URL of your servlet    
			 data: {
		            action: "generate",
		            csrfToken: csrfToken
		        },
			success : function(data) {
				if (data.qr_image && data.user_secret_key) {
					secretKey = data.user_secret_key;
					displayQRImage(data.qr_image);
				} else {
				}
			},
			error : function() {
				console.error("Ajax request failed");
			}
		});
	}	
	
	function getQRCode() {
		 var csrfToken = document.getElementById('csrfToken').value;
		$.ajax({
			type : "GET",
			url : "qrcodeServlet", // URL of your servlet 
			 data: {
		            action: "get",
		            csrfToken: csrfToken
		        },
			success : function(data) {				
				qr_status = data.qr_status;		
				if (data.qr_image  && data.user_secret_key) {
					secretKey = data.user_secret_key;
	                displayQRImage(data.qr_image);
	                 if (qr_status) {
	                	$('#generateQR').val('Regenerate QR Code');
	                } else {
	                	$('#generateQR').val('Generate QR code');
	                } 
	            } else {
	            }			
			},
			error : function() {
			}
		});
	}
	
	function sendOTP() {
        var otpValue = document.getElementById("otp").value; 
        $.ajax({
			url : "qrcodeServlet",
			type : "POST",
			data : {
				otp: otpValue,
				secretKey: secretKey,
				action: 'test-totp'
			},
            success: function (response) {
                var message = document.getElementById("message"); 
                if(response.status === 'success'){
                	message.style.color = "green";
                    message.innerHTML = "Your OTP is correct; you can now log in with TOTP.";
                }else{
                    message.style.color = "red";
                    message.innerHTML = "Incorrect OTP. Please try again or check device time.";
                    $('#otp').val('');         	
                }      
            },
            error: function () {
                console.error("TOTP authentication failed");
            }
        });
    }

	function displayQRImage(base64Image) {
		var imgElement = document.createElement("img");
		imgElement.src = "data:image/png;base64," + base64Image; // Assuming the image is in PNG format
		var container = document.getElementById("imageContainer"); // Replace "imageContainer" with the ID of your container element
		container.appendChild(imgElement);
	}

	$(document).ready(function() {		
		<%// Access the session variable
			HttpSession role = request.getSession();
			String roleValue = (String) session.getAttribute("role");%>
	roleValue = '<%=roleValue%>';
		
	<%// Access the session variable
	HttpSession csrfToken = request.getSession();
	String csrfTokenValue = (String) session.getAttribute("csrfToken");%>
	csrfTokenValue = '<%=csrfTokenValue%>';		
	
	if (roleValue === "null") {
        var modal = document.getElementById('custom-modal-session-timeout');
        modal.style.display = 'block';
        var sessionMsg = document.getElementById('session-msg');
	    sessionMsg.textContent = 'You are not allowed to redirect like this !!'; 	    
        var confirmButton = document.getElementById('confirm-button-session-timeout');
        confirmButton.onclick = function() {
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
<input type="hidden" name="csrfToken" id="csrfToken" value="<%= csrfTokenValue %>" />
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
<div class="step">
    <p>Step 1</p>
    <img src="icons/toggle.png" alt="Switch Icon">
    <p>Enable 2FA</p>
</div>
<div class="step">
    <p>Step 2</p>
    <img src="icons/scan_qr.jpg" alt="QR Code" width="150" height="150">
    <p>Scan QR Code</p>
</div>
<div class="step">
    <p>Step 3</p>
    <img src="icons/test_totp.jpg" alt="Test TOTP Icon">
    <p>Test TOTP</p>
</div>
<div class="step">
    <p>Step 4</p>
    <img src="icons/logout.png" alt="Logout Icon">
    <p>Logout</p>
</div>
<div class="step">
    <p>Step 5</p>
    <img src="icons/login.png" alt="Login Icon">
    <p>Log in Again</p>
</div>
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
					<p id="session-msg"></p>
					<button id="confirm-button-session-timeout">OK</button>
				</div>
			</div>
		</section>
	</div>
</body>
</html>