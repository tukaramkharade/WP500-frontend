<%  
    // Add X-Frame-Options header to prevent clickjacking
    response.setHeader("X-Frame-Options", "DENY");
response.setHeader("X-Content-Type-Options", "nosniff");

%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>WP500 Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png" />

<link rel="stylesheet" href="css_files/ionicons.min.css">
<link rel="stylesheet" href="css_files/normalize.min.css">
<link rel="stylesheet" href="css_files/fonts.txt" type="text/css">	
<link rel="stylesheet" href="nav-bar.css" />
<link rel="stylesheet" href="css_files/all.min.css">
<link rel="stylesheet" href="css_files/fontawesome.min.css">	
<script src="jquery-3.6.0.min.js"></script>
<style>
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
	width: 25%;
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

.modal-session-timeout,
.modal-delete,
.modal-edit{
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
.modal-content-delete,
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
	transform: translate(-50%, -50%);
	/* Center horizontally and vertically */
}

#confirm-button-session-timeout,
#confirm-button-delete,
#confirm-button-edit {
	background-color: #4caf50;
	color: white;
}

/* Style for buttons */
button {
	margin: 5px;
	padding: 10px 20px;
	border: none;
	cursor: pointer;
}

#cancel-button-delete,
#cancel-button-edit {
	background-color: #f44336;
	color: white;
}

h3{
margin-top: 68px;
}

 .container {
    border-collapse: collapse;
    }

table{
margin-top: -30px;

}
  .container th, .container td {
    border: 1px solid #ccc; /* Light gray border */
    
    text-align: left;
    
  }

 .container th{
 background-color: #e2e6f9;

 }
 
 .password-toggle {
        
    margin-right: -5px;
   
    cursor: pointer;
    margin-left: 10px;
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
var csrfTokenValue;

function togglePassword() {
    var passwordInput = $('#password');
    var passwordToggle = $('#password-toggle');

    if (passwordInput.attr('type') === 'password') {
        passwordInput.attr('type', 'text');
        passwordToggle.html('<i class="fa fa-eye-slash"></i>'); // Change to eye-slash icon
    } else {
        passwordInput.attr('type', 'password');
        passwordToggle.html('<i class="fa fa-eye"></i>'); // Change to eye icon
    }
}

function getSMTPSettings() {
	// Display loader when the request is initiated
    showLoader();
	
    var csrfToken = document.getElementById('csrfToken').value;
    
	$.ajax({
		url : "SMTPServlet",
		type : "GET",
		dataType : "json",
		data: {
			csrfToken: csrfToken
        },
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

			$('#from_email_id').val(data.from_email_id);
			$('#password').val(data.password);
			$('#host').val(data.host);
			$('#smtp_type').val(data.smtp_type);
			$('#ssl_smtp_type').val(data.ssl_smtp_type);
			if(data.smtp_type =='ssl' || data.smtp_type =='SSL'){
				$('#tls_port, #tls_auth, #tls_enable').prop('disabled', true);
	            $('#ssl_socket_factory_port, #ssl_port, #ssl_smtp_type').prop('disabled', false);
			} else if (data.smtp_type =='tls' || data.smtp_type =='TLS'){
				$('#ssl_socket_factory_port, #ssl_port, #ssl_smtp_type').prop('disabled', true);
	            $('#tls_port, #tls_auth, #tls_enable').prop('disabled', false);
			}
			$('#ssl_socket_factory_port').val(data.ssl_socket_factory_port);
			$('#ssl_port').val(data.ssl_port);
			
			$('#tls_port').val(data.tls_port);
			$('#tls_auth').val(data.tls_auth);
			$('#tls_enable').val(data.tls_enable);
			$('#to_email_id').val(data.to_email_id);
			$('#email_cc').val(data.email_cc);
		    $('#email_bcc').val(data.email_bcc);
		   		    
			if ($('#from_email_id').val(data.from_email_id) != null) {
				$('#addBtn').val('Update');
			} else {
				$('#addBtn').val('Add');
			}

		},
		error : function(xhr, status, error) {
			// Hide loader when the response has arrived
            hideLoader();
			
		},
	});

}

function validateIPaddr(ipaddr) {
    var regex = /^([a-zA-Z0-9@_.-]{1,100}\.){0,3}[a-zA-Z0-9@_.-]{1,100}$/;

    if (!regex.test(ipaddr)) {
        return 'Invalid IP Address. Please enter a valid IP address.';
    }

    return null; // Validation passed
}

function addSMTPSettings() {

	var from_email_id = $('#from_email_id').val();
	var password = $('#password').val();
	var host = $('#host').val();
	var smtp_type = $('#smtp_type').find(":selected").val();
	var ssl_socket_factory_port = $('#ssl_socket_factory_port').val();
	var ssl_port = $('#ssl_port').val();
	var ssl_smtp_type = $('#ssl_smtp_type').find(":selected").val();
	var tls_port = $('#tls_port').val();
	var tls_auth = $('#tls_auth').find(":selected").val();
	var tls_enable = $('#tls_enable').find(":selected").val();
	var to_email_id = $('#to_email_id').val();
	var email_cc = $('#email_cc').val();
	var email_bcc = $('#email_bcc').val();
	 var csrfToken = document.getElementById('csrfToken').value;
	 
	if (from_email_id && !validateEmails(from_email_id)) {
        return; // Exit the function if email_cc is not blank and is invalid
    }
	// Check validation for email_cc if it is not blank
    if (email_cc && !validateEmails(email_cc)) {
        return; // Exit the function if email_cc is not blank and is invalid
    }

    // Check validation for email_bcc if it is not blank
    if (email_bcc && !validateEmails(email_bcc)) {
        return; // Exit the function if email_bcc is not blank and is invalid
    }

    // Check validation for to_email_id
    if (!validateEmails(to_email_id)) {
        return; // Exit the function if to_email_id is invalid
    }
	
	if (!validatePortLength(ssl_socket_factory_port) || !validatePortLength(ssl_port) || !validatePortLength(tls_port)) {
        return;
    }
	
	$('#field_ipaddr_Error').text('');
	
	  var ipAddrError = validateIPaddr(host);
	    if (ipAddrError) {
	        $('#field_ipaddr_Error').text(ipAddrError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }
    
    
	$.ajax({
		url : 'SMTPServlet',
		type : 'POST',
		data : {
			from_email_id : from_email_id,
			password : password,
			host : host,
			smtp_type : smtp_type,
			ssl_socket_factory_port : ssl_socket_factory_port,
			ssl_port : ssl_port,
			ssl_smtp_type : ssl_smtp_type,
			tls_port : tls_port,
			tls_auth : tls_auth,
			tls_enable : tls_enable,
			to_email_id : to_email_id,
			email_cc : email_cc,
			email_bcc : email_bcc, 
			csrfToken: csrfToken,
			action: 'add'

		},
		success : function(data) {
	
			// Clear form fields

			$('#from_email_id').val('');
			$('#password').val('');
			$('#host').val('');
			$('#smtp_type').val('Select SMTP type');
			$('#ssl_socket_factory_port').val('');
			$('#ssl_port').val('');
			$('#ssl_smtp_type').val('Select SSL SMTP type');
			$('#tls_port').val('');
			$('#tls_auth').val('Select TLS auth');
			$('#tls_enable').val('Select TLS enable');
			$('#to_email_id').val('');
			$('#email_cc').val('');
			$('#email_bcc').val('');
			location.reload();

		},
		error : function(xhr, status, error) {
			
		}
	});

	$('#addBtn').val('Add');
}

function editSMTPSettings() {
	
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-edit');
	  modal.style.display = 'block';
	  
	// Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-edit');
	  confirmButton.onclick = function () {
		  var from_email_id = $('#from_email_id').val();
			var password = $('#password').val();
			var host = $('#host').val();
			var smtp_type = $('#smtp_type').find(":selected").val();
			var ssl_socket_factory_port = $('#ssl_socket_factory_port').val();
			var ssl_port = $('#ssl_port').val();
			var ssl_smtp_type = $('#ssl_smtp_type').find(":selected").val();
			var tls_port = $('#tls_port').val();
			var tls_auth = $('#tls_auth').find(":selected").val();
			var tls_enable = $('#tls_enable').find(":selected").val();
			var to_email_id = $('#to_email_id').val();
			var email_cc = $('#email_cc').val();
			var email_bcc = $('#email_bcc').val();
			 var csrfToken = document.getElementById('csrfToken').value;
			
			if (from_email_id && !validateEmails(from_email_id)) {
		        return; // Exit the function if email_cc is not blank and is invalid
		    }
			// Check validation for email_cc if it is not blank
		    if (email_cc && !validateEmails(email_cc)) {
		        return; // Exit the function if email_cc is not blank and is invalid
		    }

		    // Check validation for email_bcc if it is not blank
		    if (email_bcc && !validateEmails(email_bcc)) {
		        return; // Exit the function if email_bcc is not blank and is invalid
		    }

		    // Check validation for to_email_id
		    if (!validateEmails(to_email_id)) {
		        return; // Exit the function if to_email_id is invalid
		    }
			
			if (!validatePortLength(ssl_socket_factory_port) || !validatePortLength(ssl_port) || !validatePortLength(tls_port)) {
		        return;
		    }
			
			$('#field_ipaddr_Error').text('');
			
			  var ipAddrError = validateIPaddr(host);
			    if (ipAddrError) {
			        $('#field_ipaddr_Error').text(ipAddrError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
			        return;
			    }
			    
			$.ajax({
				url : 'SMTPServlet',
				type : 'POST',
				data : {
					from_email_id : from_email_id,
					password : password,
					host : host,
					smtp_type : smtp_type,
					ssl_socket_factory_port : ssl_socket_factory_port,
					ssl_port : ssl_port,
					ssl_smtp_type : ssl_smtp_type,
					tls_port : tls_port,
					tls_auth : tls_auth,
					tls_enable : tls_enable,
					to_email_id : to_email_id,
					email_cc : email_cc,
					email_bcc : email_bcc,
					csrfToken: csrfToken,
					action: 'update'

				},
				success : function(data) {
					
					// Close the modal
			        modal.style.display = 'none';
					
			        getSMTPSettings();		        
			        

					// Clear form fields

					$('#from_email_id').val('');
					$('#password').val('');
					$('#host').val('');
					$('#smtp_type').val('Select SMTP type');
					$('#ssl_socket_factory_port').val('');
					$('#ssl_port').val('');
					$('#ssl_smtp_type').val('Select SSL SMTP type');
					$('#tls_port').val('');
					$('#tls_auth').val('Select TLS auth');
					$('#tls_enable').val('Select TLS enable');
					$('#to_email_id').val('');
					$('#email_cc').val('');
					$('#email_bcc').val('');
					location.reload();

				},
				error : function(xhr, status, error) {
					
				}
				
			});
			
	  };
	  
	  var cancelButton = document.getElementById('cancel-button-edit');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	    $('#addBtn').val('Update');
	  };	
	
}
function validatePortLength(port) {
    // Check if port is a number
    if (isNaN(port)) {
       
       // Display the custom popup message
	     			$("#popupMessage").text('Port must be a number.');
	      			$("#customPopup").show();
	      			
	      			
        return false;
    }
    if (port.length > 5) {

       
       // Display the custom popup message
	     			$("#popupMessage").text('Port must not exceed 5 digits in length.');
	      			$("#customPopup").show();
	      			
        return false;
    }
    return true;
}

function validateEmails(emails) {
	
    var emailArray = emails.split(',').map(function (email) {
        return email; // Remove leading/trailing spaces
    });
    
    var emailArray1 = emails.split(',').map(function (email) {
        return email.trim(); // Remove leading/trailing spaces
    });
   
    if (emails.includes(' ')) {
     
     // Display the custom popup message
	     			$("#popupMessage").text('Space is not allowed between email addresses: ' + emails);
	      			$("#customPopup").show();
	      			
	      			
        return false; // Space is not allowed between email addresses
    }

    
    for (var i = 0; i < emailArray1.length; i++) {
        if (!isValidEmail(emailArray1[i])) {
        	if (emails.includes(',') && !emailArray.length > 1) {
                              
               // Display the custom popup message
	     			$("#popupMessage").text('Comma is required between email addresses:1' + emailArray1[i]);
	      			$("#customPopup").show();
	      			
                return false; // Comma is required between multiple emails
            }
        	else if(!emails.includes(',') && emails.includes('@')){
        		            
            // Display the custom popup message
	     			$("#popupMessage").text('Comma is required between email addresses:2' + emailArray1[i]);
	      			$("#customPopup").show();
	      			
	      			
                return false; // Comma is required between multiple emails
        	}    	
        	
        	// Display the custom popup message
	     			$("#popupMessage").text('Invalid email address: ' + emailArray1[i]);
	      			$("#customPopup").show();
	      			
            return false; // Stop and show an showCustomPopup for the first invalid email
        	
            
        }
    }
    
    return true; // All emails are valid
}
function isValidEmail(email) {
    var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    var isValid = emailRegex.test(email);

    // Log whether the email is considered valid or not
    if (isValid) {
       
    } else {
       
    }

    return isValid;
}

function deleteSMTPSettings() {
	 var csrfToken = document.getElementById('csrfToken').value;
	 
		// Display the custom modal dialog
		  var modal = document.getElementById('custom-modal-delete');
		  modal.style.display = 'block';

		  // Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-delete');
		  confirmButton.onclick = function () {
			  $.ajax({
					url : 'SMTPServlet',
					type : 'DELETE',
					dataType : 'json',
					data: {
						csrfToken: csrfToken
			        },
					success : function(data) {
						// Close the modal
				        modal.style.display = 'none';

						// Refresh the user list
						getSMTPSettings();
						location.reload();
					},
					error : function(xhr, status, error) {
						modal.style.display = 'none';
					}
				});
			  $('#addBtn').val('Add');
		  };
		// Handle the cancel button click
		  var cancelButton = document.getElementById('cancel-button-delete');
		  cancelButton.onclick = function () {
		    // Close the modal
		    modal.style.display = 'none';
		    $('#addBtn').val('Update');
		  };
	}

function testEmail() {
	$.ajax({
			url : 'smtpTESTEMAIL',
			type : 'GET',
			dataType : 'json',
			success : function(data) {
			
				// Display the custom popup message
     			$("#popupMessage").text(data.message);
      			$("#customPopup").show();

				// Refresh the user list
				getSMTPSettings();
			},
			error : function(xhr, status, error) {
				
			}
		});
	$("#closePopup").click(function () {
	    $("#customPopup").hide();
	  });
	
}


function changeButtonColor(isDisabled) {
    var $add_button = $('#addBtn');
    var $delete_button = $('#delBtn');
    var $clear_button = $('#clearBtn');    
    
    if (isDisabled) {
        $add_button.css('background-color', 'gray'); // Change to your desired color
    } else {
        $add_button.css('background-color', '#2b3991'); // Reset to original color
    }
    
    if (isDisabled) {
        $delete_button.css('background-color', 'gray'); // Change to your desired color
    } else {
        $delete_button.css('background-color', '#2b3991'); // Reset to original color
    }
    
    if (isDisabled) {
        $clear_button.css('background-color', 'gray'); // Change to your desired color
    } else {
        $clear_button.css('background-color', '#2b3991'); // Reset to original color
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

<%// Access the session variable
HttpSession csrfToken = request.getSession();
String csrfTokenValue = (String) session.getAttribute("csrfToken");%>

csrfTokenValue = '<%=csrfTokenValue%>';

						if (roleValue == 'OPERATOR' || roleValue == 'Operator') {

							$('#addBtn').prop('disabled', true);
							$('#clearBtn').prop('disabled', true);
							$('#delBtn').prop('disabled', true);

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

					    							getSMTPSettings();
					    							$("#smtp_type")
													.change(
															function(event) {

																if ($(this).val() == 'ssl'
																		|| $(this).val() == 'SSL') {

																	$("#tls_port").prop("disabled",
																			true);

																	$("#tls_auth").prop("disabled",
																			true);
																	$("#tls_enable").prop(
																			"disabled", true);

																	$("#tls_port").val('');
																	$("#tls_auth").val('False');
																	$("#tls_enable").val('False');
																	$('#ssl_smtp_type').val('True');

																	var isDisabled1 = $(
																			'#ssl_socket_factory_port')
																			.prop('disabled');

																	if (isDisabled1) {
																		$(
																				"#ssl_socket_factory_port")
																				.prop("disabled",
																						false);
																	}

																	var isDisabled2 = $('#ssl_port')
																			.prop('disabled');

																	if (isDisabled2) {
																		$("#ssl_port").prop(
																				"disabled", false);
																	}

																	var isDisabled3 = $(
																			'#ssl_smtp_type').prop(
																			'disabled');

																	if (isDisabled3) {
																		$("#ssl_smtp_type").prop(
																				"disabled", false);
																	}

																} else if ($(this).val() == 'tls'
																		|| $(this).val() == 'TLS') {
																	$("#ssl_socket_factory_port")
																			.prop("disabled", true);
																	$("#ssl_port").prop("disabled",
																			true);
																	$("#ssl_smtp_type").prop(
																			"disabled", true);

																	$("#ssl_socket_factory_port")
																			.val('');
																	$("#ssl_port").val('');
																	$('#ssl_smtp_type')
																			.val('False');
																	$("#tls_auth").val('True');
																	$("#tls_enable").val('True');

																	var isDisabled1 = $('#tls_port')
																			.prop('disabled');

																	if (isDisabled1) {
																		$("#tls_port").prop(
																				"disabled", false);
																	}

																	var isDisabled2 = $('#tls_auth')
																			.prop('disabled');

																	if (isDisabled2) {
																		$("#tls_auth").prop(
																				"disabled", false);
																	}

																	var isDisabled3 = $(
																			'#tls_enable').prop(
																			'disabled');

																	if (isDisabled3) {
																		$("#tls_enable").prop(
																				"disabled", false);
																	}

																}
															});

											$('#smtpForm').submit(function(event) {
												event.preventDefault();
												var buttonText = $('#addBtn').val();

												if (buttonText == 'Add') {
													addSMTPSettings();
												} else {
													editSMTPSettings();
												}

											});

											$('#clearBtn').click(function() {
												$('#from_email_id').val('');
												$('#password').val('');
												$('#host').val('');
												$('#smtp_type').val('Select SMTP type');
												$('#ssl_socket_factory_port').val('');
												$('#ssl_port').val('');
												$('#ssl_smtp_type').val('True');
												$('#tls_port').val('');
												$('#tls_auth').val('True');
												$('#tls_enable').val('True');
												$('#to_email_id').val('');
												$('#email_cc').val('');
												$('#email_bcc').val('');
												$('#field_ipaddr_Error').text('');
											});

											$("#delBtn").click(function() {
												deleteSMTPSettings();
											});
											$("#testEmailBtn").click(function() {
												testEmail();
											});
											$("#closePopup").click(function() {
												$("#customPopup").hide();
											});		
											
											 $('#password-toggle').click(function () {
									                togglePassword();
									            });
					    							
					    }

					});
</script>

</head>
<body>
	<div class="sidebar"><%@ include file="common.jsp"%></div>
	<div class="header"><%@ include file="header.jsp"%></div>

	<div class="content">
		<section style="margin-left: 1em">
		<h3>SMTP SETTINGS</h3>
	<hr />

		<div class="container">
		<form id="smtpForm">

				<input type="hidden" id="action" name="action" value="">
					<input type="hidden" name="csrfToken" id="csrfToken" value="<%= csrfTokenValue %>" />
					<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>
				
				<table>
				
				<tr>
					<th  colspan="2">Email Configuration</th>
				</tr>
				
				<tr>
				
				<td>From Email ID</td>
				<td><input type="text" id="from_email_id" name="from_email_id" style="height: 10px; width: 30%;" required /></td>
				
				</tr>
				
				<tr>
				<td>Password</td>
				<td><input type="password" id="password" name="password" style="height: 10px; width: 20%;" required />
				<span class="password-toggle" id="password-toggle"><i class="fa fa-eye"></i></span></td>
				</tr>
				
				<tr>
				<td>Host</td>
				<td><input type="text" id="host" name="host" style="height: 10px; width: 10%;" required />
				<span id="field_ipaddr_Error" class="error-message" style="display: block; margin-top: 5px;"></span>
				</td>
				</tr>
				
				<tr>
				<td>SMTP Type</td>
				<td><select class="smtp_type" id="smtp_type" name="smtp_type" style="height: 31px; width: 15%;" required>
							<option value="Select SMTP type">Select SMTP type</option>
							<option value="SSL">SSL</option>
							<option value="TLS">TLS</option>
						</select></td>
				</tr>
				
				<tr>
					<th  colspan="2">SSL Configuration</th>
				</tr>
				
				<tr>
				
				<td>SSL Socket Factory Port</td>
				<td><input type="text" id="ssl_socket_factory_port" name="ssl_socket_factory_port" style="height: 10px; width: 20%;" required /></td>
				
				</tr>
				
				<tr>
				<td>SSL Port</td>
				<td><input type="text" id="ssl_port" name="ssl_port" style="height: 10px; width: 20%;" required /></td>
				</tr>
				
				<tr>
				<td>SSL SMTP Type</td>
				<td><select class="ssl_smtp_type" id="ssl_smtp_type" name="ssl_smtp_type" style="height: 31px; width: 20%;" required>
								<option value="True" selected>True</option>
								<option value="False">False</option>
						</select></td>
				</tr>
				
				<tr>
					<th  colspan="2">TLS Configuration</th>
				</tr>
				
				<tr>
				
				<td>TLS Port</td>
				<td><input type="text" id="tls_port" name="tls_port" style="height: 10px; width: 8%;" required /></td>
				
				</tr>
				
				<tr>
				<td>TLS Auth</td>
				<td><select class="tls_auth" id="tls_auth" name="tls_auth" style="height: 31px; width: 15%;" required>
								<option value="True">True</option>
								<option value="False" selected>False</option>
						</select></td>
				</tr>
				
				<tr>
				<td>TLS Enable</td>
				<td><select class="tls_enable" id="tls_enable" name="tls_enable" style="height: 31px; width: 15%;" required>
								<option value="True">True</option>
								<option value="False" selected>False</option>
						</select></td>
				</tr>
				
				
				
				<tr>
					<th  colspan="2">Email Recipients</th>
				</tr>
				
				<tr>
				
				<td>To Email ID</td>
				<td><input type="text" id="to_email_id" name="to_email_id" required style="height: 10px; width: 60%;" /></td>
				
				</tr>
				
				<tr>
				<td>CC</td>
				<td><input type="text" id="email_cc" name="email_cc" style="height: 10px; width: 60%;" /></td>
				</tr>
				
				<tr>
				<td>BCC</td>
				<td><input type="text" id="email_bcc" name="email_bcc" style="height: 10px; width: 60%;" /></td>
				</tr>
				
				
				
				</table>
				
				<div class="row" style="display: flex; justify-content: right; margin-bottom: 2%;">
					<input style="margin-top: 10px; margin-left: 5px" type="button" value="Clear" id="clearBtn" /> 
					<input style="margin-top: 10px; margin-left: 5px" type="submit" value="Add" id="addBtn" /> 
					<input style="margin-top: 10px; margin-left: 5px" type="button" value="Delete" id="delBtn" />
					<input style="margin-top: 10px; margin-left: 5px" type="button" value="Test Email" id="testEmailBtn" />
				</div>
				
				</form>
		</div>
		
		
		</section>
	</div>

	<div id="custom-modal-delete" class="modal-delete">
		<div class="modal-content-delete">
			<p>Are you sure you want to delete this SMTP setting?</p>
			<button id="confirm-button-delete">Yes</button>
			<button id="cancel-button-delete">No</button>
		</div>
	</div>

	<div id="custom-modal-edit" class="modal-edit">
		<div class="modal-content-edit">
			<p>Are you sure you want to modify this SMTP setting?</p>
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

	<div id="customPopup" class="popup">
		<span class="popup-content" id="popupMessage"></span>
		<button id="closePopup">OK</button>
	</div>

	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>
