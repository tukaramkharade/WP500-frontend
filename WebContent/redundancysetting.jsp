<!DOCTYPE html>
<html>
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32"
	href="images/WP_Connex_logo_favicon.png" />
	
<link rel="stylesheet" href="css_files/ionicons.min.css">
<link rel="stylesheet" href="css_files/normalize.min.css">
<link rel="stylesheet" href="css_files/fonts.txt" type="text/css">	
 <link rel="stylesheet" href="css_files/all.min.css">
<link rel="stylesheet" href="css_files/fontawesome.min.css">

<script src="jquery-3.6.0.min.js"></script>
<style>
h3 {
	margin-top: 70px;
}

.toggle-redundancy {
  position: relative;
  display: block;
  width: 49px;
  height: 20px;
  padding: 3px;
  border-radius: 50px;
  cursor: pointer;
  font-size: small;
  
}

.toggle-input-redundancy {
  position: absolute;
  top: 0;
  left: 0;
  opacity: 0;
}

.toggle-label-redundancy {
  position: relative;
  display: block;
  height: inherit;
  font-size: small;
  background: gray;
  border-radius: inherit;
  box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.12), inset 0 0 3px rgba(0, 0, 0, 0.15);
}

.toggle-label-redundancy:before,
.toggle-label-redundancy:after {
  position: absolute;
  top: 158%;
  left: 3px;
  color: black;
  margin-top: -.5em;
  line-height: 1;
}

.toggle-label-redundancy:before {
  content: attr(data-off);
  
  right: 5px;
  color: black;
  text-shadow: 0 1px rgba(255, 255, 255, 0.5);
  font-size: small;
}

.toggle-label-redundancy:after {
  content: attr(data-on);
  left: 7px;
  color: black;
  text-shadow: 0 1px rgba(0, 0, 0, 0.2);
  opacity: 0;
  font-size: small;
}

.toggle-input-redundancy:checked~.toggle-label-redundancy {
  background: #007FFF;
}

.toggle-input-redundancy:checked~.toggle-label-redundancy:before {
  opacity: 0;
}

.toggle-input-redundancy:checked~.toggle-label-redundancy:after {
  opacity: 1;
}

.toggle-handle-redundancy {
	position: absolute;
    top: 4px;
    left: 3px;
    width: 19px;
    height: 18px;
    background: linear-gradient(to bottom, #FFFFFF 40%, #f0f0f0);
    border-radius: 50%;
}

.toggle-handle-redundancy:before {
  position: absolute;
  top: 50%;
  left: 50%;
  margin: -6px 0 0 -6px;
  width: 10px;
  height: 10px;
}

.toggle-input-redundancy:checked~.toggle-handle-redundancy {
  left: 33px;
  box-shadow: -1px 1px 5px rgba(0, 0, 0, 0.2);
}

/* Transition*/
.toggle-label-redundancy,
.toggle-handle-redundancy {
  transition: All 0.3s ease;
  -webkit-transition: All 0.3s ease;
  -moz-transition: All 0.3s ease;
  -o-transition: All 0.3s ease;
}

.container {
	margin: 0 auto;
	max-width: 40%;
}

.modal-session-timeout,
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

.modal-content-session-timeout,
.modal-content-edit  {
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

#confirm-button-edit,
#confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
}

#cancel-button-edit{
  background-color: #f44336;
  color: white;
}

.bordered-table {
	border-collapse: collapse; /* Optional: To collapse table borders */
	margin: 0 auto; /* Center the table horizontally */
	width: 100%; /* Full width for responsiveness */
}

.bordered-table td {
	border: 1px solid #ccc; /* Light gray border */
	
}

.validation-container {
            position: relative;
            width: 70%; /* Adjust the width as needed */
        }

        .validation-message {
            color: red;
            margin-top: 5px;
            position: absolute;
            bottom: -6px;
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

var roleValue;
var tokenValue;

function validateIPAddress(inputId, spanId) {
    var ipAddress = document.getElementById(inputId).value;
    var ipRegex = /^(\d{1,3}\.){0,3}\d{1,3}$/;
    var validationMessageSpan = document.getElementById(spanId);

    if (ipRegex.test(ipAddress)) {
        validationMessageSpan.innerHTML = "";
        return true; // IP address is valid
    } else {
        validationMessageSpan.innerHTML = "Invalid IP Address. Please enter a valid IP address.";
        return false; // IP address is invalid
    }
}

function getRedundancySettings(){
	// Display loader when the request is initiated
    showLoader();
	
	$.ajax({
		url : 'redundancyServlet',
		type : 'GET',
		dataType : 'json',
		beforeSend: function(xhr) {
	        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
	    },
	    
	    success : function(data) {
	    	// Hide loader when the response has arrived
            hideLoader();
	    	
			if(data.status == 'fail'){
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
			
			var enableLabel = data.Redundancy_enable === 1 ? 'Enable' : 'Disable';
			var roleLabel = data.Redundancy_Role === 1 ? 'Primary' : 'Secondary';

			$('#toggle_redundancy_enable').prop('checked', data.Redundancy_enable == 1);
			$('#toggle_redundancy_role').prop('checked', data.Redundancy_Role == 1);
			
			$('#partner_ip').val(data.partner_ip);	
			$('#common_ip_0').val(data.common_ip0);			
			$('#common_subnet_0').val(data.common_subnet0);		
			$('#common_ip_1').val(data.common_ip1);		
			$('#common_subnet_1').val(data.common_subnet1);	
			$('#common_ip_2').val(data.common_ip2);		
			$('#common_subnet_2').val(data.common_subnet2);	
			
	    },
	    error : function(xhr, status, error) {
	    	// Hide loader when the response has arrived
            hideLoader();
	    	
			// Handle the error response, if needed
			console.log('Error: ' + error);
		}
	});
		
}

function updateRedundancySettings(){
	
	// Display the custom modal dialog
	var modal = document.getElementById('custom-modal-edit');
	modal.style.display = 'block';

	// Handle the confirm button click
	var confirmButton = document.getElementById('confirm-button-edit');
	confirmButton.onclick = function() {
	
	var toggle_redundancy_enable = $("#toggle_redundancy_enable").prop("checked") ? "1": "0";
	var toggle_redundancy_role = $("#toggle_redundancy_role").prop("checked") ? "1": "0";
	
	var partner_ip = $('#partner_ip').val();
	var common_ip_0 = $('#common_ip_0').val();	
	var common_subnet_0 = $('#common_subnet_0').val();	
	var common_ip_1 = $('#common_ip_1').val();	
	var common_subnet_1 = $('#common_subnet_1').val();	
	var common_ip_2 = $('#common_ip_2').val();	
	var common_subnet_2 = $('#common_subnet_2').val();
	
	$.ajax({
		
		url : 'redundancyServlet', 
		type : 'POST',
		data : {
			toggle_redundancy_enable : toggle_redundancy_enable,		
			toggle_redundancy_role : toggle_redundancy_role,			
			partner_ip : partner_ip,			
			common_ip_0 : common_ip_0,			
			common_subnet_0 : common_subnet_0,			
			common_ip_1 : common_ip_1,			
			common_subnet_1 : common_subnet_1,			
			common_ip_2 : common_ip_2,
			common_subnet_2 : common_subnet_2
			
			
		},
		success : function(data) {
			// Close the modal
	        modal.style.display = 'none';
				
				getRedundancySettings();
				
				$('#partner_ip').val('');
				$('#common_ip_0').val('');
				$('#common_subnet_0').val('');
				$('#common_ip_1').val('');
				$('#common_subnet_1').val('');
				$('#common_ip_2').val('');
				$('#common_subnet_2').val('');
				
		},
		error : function(xhr, status, error) {
			console.log('Error updating lan : ' + error);
		}
	});
	};
	
	var cancelButton = document.getElementById('cancel-button-edit');
	cancelButton.onclick = function() {
		// Close the modal
		modal.style.display = 'none';

	};
}

//Function to show the loader
function showLoader() {
    // Show the loader overlay
    $('#loader-overlay').show();
}

// Function to hide the loader
function hideLoader() {
    // Hide the loader overlay
    $('#loader-overlay').hide();
}

function changeButtonColor(isDisabled) {
    var $applyBtn = $('#applyBtn');   
    
    if (isDisabled) {
        $applyBtn.css('background-color', 'gray'); // Change to your desired color
    } else {
        $applyBtn.css('background-color', '#2b3991'); // Reset to original color
    }   
    
    
}


$(document).ready(function() {
	
	<%// Access the session variable
	HttpSession role = request.getSession();
	String roleValue = (String) session.getAttribute("role");%>

roleValue = '<%=roleValue%>';

	
	if (roleValue == 'OPERATOR' || roleValue == 'Operator') {
		$('#applyBtn').prop('disabled', true);
		
		
		changeButtonColor(true);
	}
	
	if (roleValue === "null") {
		
		
	}else{
		<%// Access the session variable
		HttpSession token = request.getSession();
		String tokenValue = (String) session.getAttribute("token");%>

		tokenValue = '<%=tokenValue%>';
		
		getRedundancySettings();
		
		$('#applyBtn').click(function() {
			
			if (validateIPAddress('partner_ip', 'validationMessage1') &&
			        validateIPAddress('common_ip_0', 'validationMessage2') &&
			        validateIPAddress('common_subnet_0', 'validationMessage3') &&
			        validateIPAddress('common_ip_1', 'validationMessage4') &&
			        validateIPAddress('common_subnet_1', 'validationMessage5') &&
			        validateIPAddress('common_ip_2', 'validationMessage6') &&
			        validateIPAddress('common_subnet_2', 'validationMessage7')) {
				
				updateRedundancySettings();
			    }
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
			<h3>REDUNDANCY SETTINGS</h3>
			<hr>
			<div class="container">
			<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>
			<form id="redundancySettingsForm">
			<table class="bordered-table" style="margin-top: -1px;">
			
			
			<tr>
							<td style="height: 50px;">Redundancy enable</td>
							<td><label class="toggle-redundancy"> <input
									id="toggle_redundancy_enable" name="toggle_redundancy_enable"
									class="toggle-input-redundancy" type="checkbox"> <span
									class="toggle-label-redundancy" data-off="Disable" data-on="Enable"></span> <span
									class="toggle-handle-redundancy"></span>
							</label></td>
							</tr>
							
							<tr>
							<td style="height: 50px;">Redundancy role</td>
							<td><label class="toggle-redundancy"> <input
									id="toggle_redundancy_role" name="toggle_redundancy_role"
									class="toggle-input-redundancy" type="checkbox"> <span
									class="toggle-label-redundancy" data-off="Secondary" data-on="Primary"></span> <span
									class="toggle-handle-redundancy"></span>
							</label></td>
							
							</tr>
							
							<tr>
							
							<td>Partner IP</td>
							<td>
							 <div class="validation-container">
							<input id="partner_ip" class="config" type='text' name="partner_ip" style="width: 42%;" required>
							 <span id="validationMessage1" class="validation-message" style="margin-left: 10px;"></span>
							</div>
							</td>
							</tr>
							
							<tr>
							<td>Common IP 0</td>
							<td>
							 <div class="validation-container">
							<input id="common_ip_0" class="config" type='text' name="common_ip_0" style="width: 42%;" required>
							 <span id="validationMessage2" class="validation-message" style="margin-left: 10px;"></span>
							</div>
							</td>
							</tr>
							
							<tr>
							<td>Common Subnet 0</td>
							<td>
							 <div class="validation-container">
							<input id="common_subnet_0" class="config" type='text' name="common_subnet_0" style="width: 42%;" required>
							 <span id="validationMessage3" class="validation-message" style="margin-left: 10px;"></span>
							</div>
							</td>
							</tr>
							
							<tr>
							<td>Common IP 1</td>
							<td>
							 <div class="validation-container">
							<input id="common_ip_1" class="config" type='text' name="common_ip_1" style="width: 42%;" required>
							 <span id="validationMessage4" class="validation-message" style="margin-left: 10px;"></span>
							</div>
							</td>
							</tr>
							
							<tr>
							<td>Common Subnet 1</td>
							<td>
							 <div class="validation-container">
							<input id="common_subnet_1" class="config" type='text' name="common_subnet_1" style="width: 42%;" required>
							 <span id="validationMessage5" class="validation-message" style="margin-left: 10px;"></span>
							</div>
							</td>
							</tr>
							
							<tr>
							<td>Common IP 2</td>
							<td>
							 <div class="validation-container">
							<input id="common_ip_2" class="config" type='text' name="common_ip_2" style="width: 42%;" required>
							 <span id="validationMessage6" class="validation-message" style="margin-left: 10px;"></span>
							</div>
							</td>
							</tr>
							
							<tr>
							<td>Common Subnet 2</td>
							<td>
							 <div class="validation-container">
							<input id="common_subnet_2" class="config" type='text' name="common_subnet_2" style="width: 42%;" required>
							 <span id="validationMessage7" class="validation-message" style="margin-left: 10px;"></span>
							</div>
							</td>
							</tr>
							
							
							
			</table>
			
			<div class="row"
						style="display: flex; justify-content: center; margin-bottom: 2%; margin-top: 1%;">
						<input style="height: 26px;" type="button" value="Apply"
							id="applyBtn" />

					</div>
			
			</form>
			</div>
			
			<div id="custom-modal-session-timeout" class="modal-session-timeout">
				<div class="modal-content-session-timeout">
				 <p id="session-msg"></p>
				  <button id="confirm-button-session-timeout">OK</button>
				</div>
			</div>
			
			<div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to modfiy this lan setting?</p>
				  <button id="confirm-button-edit">Yes</button>
				  <button id="cancel-button-edit">No</button>
				</div>
			</div>
			
			</section>
			</div>

</body>
</html>