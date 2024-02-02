<%
    // Add X-Frame-Options header to prevent clickjacking
    response.setHeader("X-Frame-Options", "DENY");
    response.setHeader("X-Content-Type-Options", "nosniff");

    // Ensure that the session cookie has the 'Secure', 'HttpOnly', and 'SameSite' attributes
    HttpSession session1 = request.getSession();

    // Set the 'Secure', 'HttpOnly', and 'SameSite' attributes for the session cookie
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
<head>
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png" />
<link rel="stylesheet" href="css_files/ionicons.min.css">
<link rel="stylesheet" href="css_files/normalize.min.css">
<link rel="stylesheet" href="css_files/fonts.txt" type="text/css">
<link rel="stylesheet" type="text/css" href="nav-bar.css">
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />

</head>
<script src="jquery-3.6.0.min.js"></script>

<style>
h3 {
	margin-top: 68px;
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
  transform: translate(-50%, -50%); /* Center horizontally and vertically */
}


button {
  margin: 5px;
  padding: 10px 20px;
  border: none;
  cursor: pointer;
}

#confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
}
</style>
<script>
var roleValue;
var tokenValue;
var csrfTokenValue;

	function getOverviewData() {
		// Display loader when the request is initiated
	    showLoader();
		
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
				// Hide loader when the response has arrived
	            hideLoader();
				
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
	                // Assuming you have <td> elements with IDs for displaying the values
	                document.getElementById('hw-rev-td').textContent = data.HW_REV;
	                document.getElementById('tas-serial-no-td').textContent = data.TAS_SERIAL_NO;
	                document.getElementById('fw-rev-td').textContent = data.FW_REV;
	                document.getElementById('sp-rev-td').textContent = data.SEC_PATCH_LVL;
	                
	            }
				
			},

			error : function(xhr, status, error) {
				// Hide loader when the response has arrived
	            hideLoader();
				
			}

		});

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
		
		<%// Access the session variable
		HttpSession csrfToken = request.getSession();
		String csrfTokenValue = (String) session.getAttribute("csrfToken");%>

		csrfTokenValue = '<%=csrfTokenValue%>';
			
		if (roleValue === "null") {
	        var modal = document.getElementById('custom-modal-session-timeout');
	        modal.style.display = 'block';

	     // Update the session-msg content with the message from the server
		    var sessionMsg = document.getElementById('session-msg');
		    sessionMsg.textContent = 'You are not allowed to redirect like this !!'; 
		    
	        // Handle the confirm button click
	        var confirmButton = document.getElementById('confirm-button-session-timeout');
	        confirmButton.onclick = function() {
	            // Close the modal
	            modal.style.display = 'none';
	            window.location.href = 'login.jsp';
	        };
	    } else{
				<%// Access the session variable
			HttpSession token = request.getSession();
			String tokenValue = (String) session.getAttribute("token");%>

		tokenValue = '<%=tokenValue%>';
		getOverviewData();
		
		// Add an entry to the browser history
        window.history.pushState(null, null, window.location.href);

        // Listen for the user trying to navigate back
        window.addEventListener('popstate', function (event) {
            // If the user tries to go back, push another state to keep them on the current page
            window.history.pushState(null, null, window.location.href);
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
			<h3>OVERVIEW</h3>
			<hr>
			
			<input type="hidden" name="csrfToken" id="csrfToken" value="<%= csrfTokenValue %>" />
			
			<div style="display: flex; justify-content: left; width: 100%;">
				<img src="images/rut_image.jpg" width="500" height="400" />

				<div class="container"
					style="width: 60%; margin-left: 1%; height: 400;">
					
					<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>

					<table>
						<tr>
							<th colspan="2">General data</th>
						</tr>

						<tr>
							<td>Manufactured by</td>
							<td>TAS INDIA PRIVATE LIMITED</td>
						</tr>

						<tr>
							<td>Manufacturing address</td>
							<td>PUNE, INDIA</td>
						</tr>

						<tr>
							<td>Web address</td>
							<td>http://www.tasm2m.com</td>
						</tr>

						<tr>
							<td>Model number</td>
							<td>WP500</td>
						</tr>

						<tr>
							<td>Serial no.</td>
							<td id="tas-serial-no-td"></td>
						</tr>

						<tr>
							<td>Firmware revision</td>
							<td id="fw-rev-td"></td>
						</tr>
						<tr>
							<td>Security patch level</td>
							<td id="sp-rev-td"></td>
						</tr>

						<tr>
							<td>Hardware revision</td>
							<td id="hw-rev-td"></td>
						</tr>

						<tr>
							<td>Web app version</td>
							<td>1.1.0</td>
						</tr>
					</table>
				</div>
				
				<div id="custom-modal-session-timeout" class="modal-session-timeout">
				<div class="modal-content-session-timeout">
				 <p id="session-msg"></p>
				  <button id="confirm-button-session-timeout">OK</button>
				</div>
			  </div>
			</div>


		</section>
		<!-- <footer>
        <span>COPYRIGHT � TAS INDIA PVT LTD, 2023</span>
      </footer> -->

	</div>
	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>

</body>
</html>
