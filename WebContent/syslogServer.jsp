<%  
    // Add X-Frame-Options header to prevent clickjacking
    response.setHeader("X-Frame-Options", "DENY");
%>

<!DOCTYPE html>
<html>
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32"
	href="images/WP_Connex_logo_favicon.png" />
	
<link rel="stylesheet" href="css_files/ionicons.min.css">
<link rel="stylesheet" href="css_files/normalize.min.css">
<link rel="stylesheet" href="css_files/fonts.txt" type="text/css">
<link rel="stylesheet" href="nav-bar.css" />
<link rel="stylesheet" href="css_files/all.min.css">
<link rel="stylesheet" href="css_files/fontawesome.min.css">
<script src="jquery-3.6.0.min.js"></script>

<style>

.bordered-table {
	border-collapse: collapse; /* Optional: To collapse table borders */
	margin: 0 auto; /* Center the table horizontally */
	width: 100%; /* Full width for responsiveness */
}

.bordered-table td {
	border: 1px solid #ccc; /* Light gray border */
}

.container {
	margin: 0 auto;
	max-width: 20%;
}

.modal-session-timeout,
.modal-edit,
.modal-edit-status{
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
.modal-content-edit,
.modal-content-edit-status{
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

#confirm-button-session-timeout,
#confirm-button-edit,
#confirm-button-edit-status {
	background-color: #4caf50;
	color: white;
}


#cancel-button-edit,
#cancel-button-edit-status
 {
  background-color: #f44336;
  color: white;
}


h3{
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

</style>

<script>

var roleValue;	
var tokenValue;

function getSysLog(){
	
	// Display loader when the request is initiated
    showLoader();
	
	$.ajax({
		url : "syslogConf",
		type : "GET",
		dataType : "json",
		beforeSend: function(xhr) {
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

			$('#hostname').val(data.rsyslog_ip);
			$('#port_number').val(data.rsyslog_port);
			
		},
		error : function(xhr, status, error) {
			// Hide loader when the response has arrived
            hideLoader();
			
			// Handle the error response, if needed
			console.log("Error loading rsyslog configuration: " + error);
		},
	});

}


function updateSysLog(){
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-edit');
	  modal.style.display = 'block';
	  
	// Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-edit');
	  confirmButton.onclick = function () {
		  
		  var hostname = $('#hostname').val();
			var port_number = $('#port_number').val();
			
			
			$.ajax({
				url : 'syslogConf',
				type : 'POST',
				data : {
					hostname : hostname,
					port_number : port_number
					

				},
				success : function(data) {
					if (data.status == 'fail') {
						
						 var modal1 = document.getElementById('custom-modal-session-timeout');
						  modal1.style.display = 'block';
						  
						// Update the session-msg content with the message from the server
						    var sessionMsg = document.getElementById('session-msg');
						    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

						  
						  // Handle the confirm button click
						  var confirmButton1 = document.getElementById('confirm-button-session-timeout');
						  confirmButton1.onclick = function () {
							  
							// Close the modal
						        modal1.style.display = 'none';
						        window.location.href = 'login.jsp';
						  };
							  
					} 
					// Close the modal
			        modal.style.display = 'none';
			        getSysLog();

					// Clear form fields

					$('#hostname').val('');
					$('#port_number').val('');
					

				},
				error : function(xhr, status, error) {
					console.log('Error editing syslog configuration setting: ' + error);
				}
			});
				
	  };
	  
	  var cancelButton = document.getElementById('cancel-button-edit');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	   
	  };
	
}

function getSysLogStatus(){
	$.ajax({
		url : "syslogStatus",
		type : "GET",
		dataType : "json",
		beforeSend: function(xhr) {
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

			$('#status').val(data.rsyslog_status);
			
			
		},
		error : function(xhr, status, error) {
			// Handle the error response, if needed
			console.log("Error loading rsyslog configuration: " + error);
		},
	});

	
}

function updateSysLogStatus(){
	
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-edit-status');
	  modal.style.display = 'block';
	  
	// Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-edit-status');
	  confirmButton.onclick = function () {
		  
		  var status = $('#status').find(":selected").val();
		  
			$.ajax({
				url : 'syslogStatus',
				type : 'POST',
				data : {
					status : status
					
				},
				success : function(data) {
					if (data.status == 'fail') {
						
						 var modal1 = document.getElementById('custom-modal-session-timeout');
						  modal1.style.display = 'block';
						  
						// Update the session-msg content with the message from the server
						    var sessionMsg = document.getElementById('session-msg');
						    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

						  
						  // Handle the confirm button click
						  var confirmButton1 = document.getElementById('confirm-button-session-timeout');
						  confirmButton1.onclick = function () {
							  
							// Close the modal
						        modal1.style.display = 'none';
						        window.location.href = 'login.jsp';
						  };
							  
					} 
					// Close the modal
			        modal.style.display = 'none';
			        getSysLogStatus();

					// Clear form fields

					$('#status').val('Select status');
					
				},
				error : function(xhr, status, error) {
					console.log('Error editing syslog configuration setting: ' + error);
				}
			});
				
	  };
	  
	  var cancelButton = document.getElementById('cancel-button-edit-status');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	   
	  };
	
}


function changeButtonColor(isDisabled) {
    var $applyBtn = $('#applyButton');   
    var $addBtn = $('#saveBtn');   
    
    if (isDisabled) {
        $applyBtn.css('background-color', 'gray'); // Change to your desired color
    } else {
        $applyBtn.css('background-color', '#2b3991'); // Reset to original color
    }   
    
    if (isDisabled) {
        $addBtn.css('background-color', 'gray'); // Change to your desired color
    } else {
        $addBtn.css('background-color', '#2b3991'); // Reset to original color
    }  
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

$(document).ready(function() {
	<%// Access the session variable
	HttpSession role = request.getSession();
	String roleValue = (String) session.getAttribute("role");%>

roleValue = '<%=roleValue%>';

if (roleValue == 'OPERATOR' || roleValue == 'Operator') {

	$('#applyButton').prop('disabled', true);
	$('#saveBtn').prop('disabled', true);
	
	changeButtonColor(true);
}

if (roleValue === "null") {
    var modal = document.getElementById('custom-modal-session-timeout');
    modal.style.display = 'block';

    var sessionMsg = document.getElementById('session-msg');
    sessionMsg.textContent = 'You are not allowed to redirect like this !!'; 
    
    
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

getSysLog();

$('#saveBtn').click(function() {
	updateSysLog();
});

getSysLogStatus();

$('#applyButton').click(function() {
	updateSysLogStatus();
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
			<h3>SYSLOG CONFIGURATION</h3>
			<hr>

			<div class="container">
			<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>

				<form id="settingsForm">
					<table class="bordered-table" style="margin-top: -1px;">
					
					<tr>
							<td>Status</td>
							<td><select class="textBox" id="status" name="status" style="height: 33px; max-width: 220px;">
							
							<option value="Enable" selected>Enable</option>
							<option value="Disable">Disable</option>
						</select>
						
						</td>
						<td><input type="button" id="applyButton" value="Apply"/></td>
						</tr>
					
					
						<tr>
							<td>Hostname</td>
							<td><input type="text" id="hostname" maxlength="31" name="hostname" required style="max-width: 200px;" /></td>
							</tr>
							
						<tr>
							<td>Port</td>
							<td><input type="text" id="port_number" name="port_number" maxlength="6" required style="max-width: 200px;"/></td>
						</tr>
						
						<tr>
						<td colspan="2" style="text-align: center;"><input style="height: 26px;" type="button" value="Save"
							id="saveBtn" /></td>
						</tr>
						
						
					</table>

				</form>
			</div>
			
			<div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to modify this rsyslog configuration?</p>
				  <button id="confirm-button-edit">Yes</button>
				  <button id="cancel-button-edit">No</button>
				</div>
			  </div>
			  
			  <div id="custom-modal-edit-status" class="modal-edit-status">
				<div class="modal-content-edit-status">
				  <p>Are you sure you want to modify this rsyslog status?</p>
				  <button id="confirm-button-edit-status">Yes</button>
				  <button id="cancel-button-edit-status">No</button>
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