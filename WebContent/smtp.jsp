<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>WP500 Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
 
 #confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
}

.modal-delete {
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

.modal-content-delete {
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
  transform: translate(-50%, -50%); /* Center horizontally and vertically */
}

/* Style for buttons */
button {
  margin: 5px;
  padding: 10px 20px;
  border: none;
  cursor: pointer;
}

#confirm-button-delete {
  background-color: #4caf50;
  color: white;
}

#cancel-button-delete {
  background-color: #f44336;
  color: white;
}

#confirm-button-edit {
  background-color: #4caf50;
  color: white;
}

#cancel-button-edit {
  background-color: #f44336;
  color: white;
}

#password_label{
margin-left: -355%;
}

#password{
margin-left: -145%;
width: 80%;
}

#host_label{
margin-left: -545%;
}

#host{
margin-left: -135%;
width: 80%;
}

#smtp_type_label{
margin-left: -255%;
}

#smtp_type{
margin-left: -135%;
width: 80%;
}

</style>

<script>
var roleValue; 
var tokenValue;

function getSMTPSettings() {

	$.ajax({
		url : "SMTPServlet",
		type : "GET",
		dataType : "json",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
	    },
		success : function(data) {
			var json1 = JSON.stringify(data);
			 var json = JSON.parse(json1);
			 handleStatus(json.status);

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
		    console.log("Email BCC Value:", data.email_bcc);
		    
			if ($('#from_email_id').val(data.from_email_id) != null) {
				$('#addBtn').val('Edit');
			} else {
				$('#addBtn').val('Add');
			}

		},
		error : function(xhr, status, error) {
			// Handle the error response, if needed
			console.log("Error loading SMTP Settings: " + error);
		},
	});

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
			console.log('Error adding SMTP setting: ' + error);
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
					console.log('Error editing SMTP setting: ' + error);
				}
				
			});
			
			
	  };
	  
	  var cancelButton = document.getElementById('cancel-button-edit');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	    $('#addBtn').val('Edit');
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
    console.log("emailArray:", emailArray + " "+emailArray.length);
    console.log("emailArray1:", emailArray1 + " "+emailArray1.length);
    if (emails.includes(' ')) {
     
     // Display the custom popup message
	     			$("#popupMessage").text('Space is not allowed between email addresses: ' + emails);
	      			$("#customPopup").show();
	      			
	      			
        return false; // Space is not allowed between email addresses
    }

    
    for (var i = 0; i < emailArray1.length; i++) {
        if (!isValidEmail(emailArray1[i])) {
        	if (emails.includes(',') && !emailArray.length > 1) {
                console.log("comma " + emailArray.length + " " + emails.length);    
               
               // Display the custom popup message
	     			$("#popupMessage").text('Comma is required between email addresses:1' + emailArray1[i]);
	      			$("#customPopup").show();
	      			
                return false; // Comma is required between multiple emails
            }
        	else if(!emails.includes(',') && emails.includes('@')){
        		console.log("comma " + emailArray.length + " " + emails.length);
            
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
        console.log("Email is valid: " + email);
    } else {
        console.log("Email is NOT valid: " + email);
    }

    return isValid;
}
function deleteSMTPSettings() {
		
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
					success : function(data) {
						// Close the modal
				        modal.style.display = 'none';

						// Refresh the user list
						getSMTPSettings();
					},
					error : function(xhr, status, error) {
						// Handle the error response, if needed
						console.log('Error deleting SMTP settings: '+ error);
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
		    $('#addBtn').val('Edit');
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
				// Handle the error response, if needed
				console.log('Error testing email: '+ error);
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
function handleStatus(status) {
    if (status === 'fail') {
        var modal = document.getElementById('custom-modal-session-timeout');
        modal.style.display = 'block';

        // Handle the confirm button click
        var confirmButton = document.getElementById('confirm-button-session-timeout');
        confirmButton.onclick = function () {
            // Close the modal
            modal.style.display = 'none';
            window.location.href = 'login.jsp';
        };
    }
}

$(document).ready(function() {
	<%// Access the session variable
	HttpSession role = request.getSession();
	String roleValue = (String) session.getAttribute("role");%>

roleValue = '<%=roleValue%>';

<%// Access the session variable
HttpSession token = request.getSession();
String tokenValue = (String) session.getAttribute("token");%>

tokenValue = '<%=tokenValue%>';

	
	getSMTPSettings();
	
	if (roleValue == 'VIEWER' || roleValue == 'Viewer') {

		$('#addBtn').prop('disabled', true);
		$('#clearBtn').prop('disabled', true);
		$('#delBtn').prop('disabled', true);
		
		changeButtonColor(true);
	}
	
	
	$("#smtp_type").change(function(event) {

		if ($(this).val() == 'ssl' || $(this).val() == 'SSL') {
			 
			$("#tls_port").prop("disabled", true);
			
			 $("#tls_auth").prop("disabled", true);
			$("#tls_enable").prop("disabled", true);
			
			$("#tls_port").val('');
			$("#tls_auth").val('False');
			$("#tls_enable").val('False');
			$('#ssl_smtp_type').val('True');
			
			var isDisabled1 = $('#ssl_socket_factory_port').prop('disabled');
			 
			 if(isDisabled1){
				 $("#ssl_socket_factory_port").prop("disabled", false);
			 }
			 
			var isDisabled2 = $('#ssl_port').prop('disabled');
			 
			 if(isDisabled2){
				 $("#ssl_port").prop("disabled", false);
			 }
			 
			var isDisabled3 = $('#ssl_smtp_type').prop('disabled');
			 
			 if(isDisabled3){
				 $("#ssl_smtp_type").prop("disabled", false);
			 } 
			 
		} 
		 else if ($(this).val() == 'tls' || $(this).val() == 'TLS') {
			$("#ssl_socket_factory_port").prop("disabled", true);
			$("#ssl_port").prop("disabled", true);
			$("#ssl_smtp_type").prop("disabled", true);
			
			
			$("#ssl_socket_factory_port").val('');
			$("#ssl_port").val('');
			$('#ssl_smtp_type').val('False');
			$("#tls_auth").val('True');
			$("#tls_enable").val('True');
			
			var isDisabled1 = $('#tls_port').prop('disabled');
			 
			 if(isDisabled1){
				 $("#tls_port").prop("disabled", false);
			 }
			 
			var isDisabled2 = $('#tls_auth').prop('disabled');
			 
			 if(isDisabled2){
				 $("#tls_auth").prop("disabled", false);
			 }
			 
			var isDisabled3 = $('#tls_enable').prop('disabled');
			 
			 if(isDisabled3){
				 $("#tls_enable").prop("disabled", false);
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
	});
	
	$("#delBtn").click(function () {
		deleteSMTPSettings();
	  });
	$("#testEmailBtn").click(function () {
		testEmail();
	  });
	$("#closePopup").click(function () {
	    $("#customPopup").hide();
	  });
	
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
			
			<div class="row"
					style="display: flex; flex-content: space-between; margin-top: -20px;">
					
					<div class="col-75-1" style="width: 22%; display:flex;">
						<div >
							<label for="from_email_id" id="from_email_id_label">From Email ID:</label>
						</div>
							
						<div >
                  			  <input type="text" id="from_email_id" name="from_email_id"  required style="height: 17px" />
                		</div>
					</div>
					
					<div class="col-75-2" style="display:flex">
							<div>
                				<label for="password" id="password_label">Password:</label>
                			</div>
                			<div > 	
                				<input type="password" id="password" name="password"  required style="height: 17px" />
            				</div>
            		</div>
					<div class="col-75-3" style="display:flex">
						<div>
							<label for="host" id="host_label">Host:</label>
						</div>	
							<div>
								<input type="text" id="host" name="host"
									 required style="height: 17px" />
							</div>
					</div>
					
					<div class="col-75-4" style="display:flex">
						<div>
							<label for="smtp_type" id="smtp_type_label">SMTP Type:</label>
						</div>
						<div>
							<select class="smtp_type" id="smtp_type" name="smtp_type"
								style="height: 35px" required>
								<option value="Select SMTP type">Select SMTP type</option>
								<option value="SSL">SSL</option>
								<option value="TLS">TLS</option>
							</select>
						</div>
					</div>
					
							
				</div>
				<div class="row" style="display: flex; flex-content: space-between; margin-top: 15px;">
						<div class="col-75-5" style="width: 27%;display:flex">
							<div>
								<label for="ssl_socket_factory_port">SSL Socket Factory Port:</label>
							</div>
							<div>	
								<input type="text" id="ssl_socket_factory_port" name="ssl_socket_factory_port"
									 style="height: 17px" required />
							</div>
						</div>
						
						<div class="col-75-6" style="width: 20%;display:flex">
							<div>
								<label for="ssl_port">SSL Port:</label>
							</div>
							<div>
								<input type="text" id="ssl_port" name="ssl_port"
									 style="height: 17px" required/>
							</div>
					</div>
					<div class="col-75-7" style="width: 20%;display:flex">
						<div>
							<label for="ssl_smtp_type">SSL Smtp Type</label>
						</div>
						<div>
							<select class="ssl_smtp_type" id="ssl_smtp_type" name="ssl_smtp_type"
								style="height: 35px" required>
								<option value="True" selected>True</option>
								<option value="False">False</option>
							</select>
						</div>	
					</div>
				</div>
					
				
				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: 10px;">
					
					<div class="col-75-8" style="width: 27%;display:flex">
						<div>
								<label for="tls_port">TLS Port:</label>
						</div>
						<div>	
							<input type="text" id="tls_port" name="tls_port"
								 style="height: 17px" required/>
						</div>
					</div>	
					
					<div class="col-75-9" style="width: 20%;display:flex">
						<div>
							<label for="tls_auth">TLS Auth</label>
						</div>
						<div>
							<select class="tls_auth" id="tls_auth" name="tls_auth"
								style="height: 35px" required>
								<option value="True">True</option>
								<option value="False" selected>False</option>
							</select>
						</div>
					</div>
					
					<div class="col-75-10" style="width: 20%;display:flex">
						<div>
							<label for="tls_enable">TLS Enable</label>
						</div>
						<div>
							<select class="tls_enable" id="tls_enable" name="tls_enable"
							style="height: 35px" required>
							<option value="True">True</option>
							<option value="False" selected>False</option>
							</select>
						</div>
					</div>					
				</div>
				
				<div id="custom-modal-session-timeout" class="modal-session-timeout">
					<div class="modal-content-session-timeout">
					  <p>Your session is timeout. Please login again</p>
					  <button id="confirm-button-session-timeout">OK</button>
					</div>
			   </div>
			   
			   
				
				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: 10px;">
					<div class="col-75-1" style="width: 38%;display:flex">
						<div>
							<label for="to_email_id">TO Email ID</label>
						</div>
						<div>
     					   <input type="text" id="to_email_id" name="to_email_id"
      					       required style="height: 17px; width: 325px;" />
   						 </div>
					</div>
					
					<div class="col-75-1" style="width: 33.5%;display:flex">
						<div>
							<label for="email_cc">CC</label>
						</div>
						<div>
							<input type="text" id="email_cc" name="email_cc"
								  style="height: 17px; width: 325px;" />
						</div>
					</div>
					
					<div class="col-75-1" style="width: 25%;display:flex">
						<div>
							<label for="email_cc">BCC</label>
						</div>
						<div>
							<input type="text" id="email_bcc" name="email_bcc"
							  style="height: 17px;width: 280px;" />
						</div>		
					</div>
				</div>	
				
				<div class="row" style="display: flex; justify-content: right;">
					<input style="margin-top: 10px; margin-left: 5px" type="button"
						value="Clear" id="clearBtn"/> 
						<input style="margin-top: 10px; margin-left: 5px" type="submit"
						value="Add" id="addBtn" /> 
						<input style="margin-top: 10px; margin-left: 5px" type="button"
						value="Delete" id="delBtn" onClick="window.location.reload();" />
						<input style="margin-top: 10px; margin-left: 5px" type="button" value="Test Email" id="testEmailBtn" />
				</div>
			</form>
		</div>
		</section>
		</div>
		
		<div id="custom-modal-delete" class="modal-delete">
				<div class="modal-content-delete">
				  <p>Are you sure you want to delete this user?</p>
				  <button id="confirm-button-delete">Yes</button>
				  <button id="cancel-button-delete">No</button>
				</div>
			  </div>
			  
			  <div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to edit this user?</p>
				  <button id="confirm-button-edit">Yes</button>
				  <button id="cancel-button-edit">No</button>
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