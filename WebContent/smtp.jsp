<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>WP500 Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="favicon.png" />
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

<script>
var roleValue; 

function getSMTPSettings() {

	$.ajax({
		url : "SMTPServlet",
		type : "GET",
		dataType : "json",
		success : function(data) {

			$('#from_email_id').val(data.from_email_id);
			$('#password').val(data.password);
			$('#host').val(data.host);
			$('#smtp_type').val(data.smtp_type);
			if(data.smtp_type =='ssl' || data.smtp_type =='SSL'){
				$('#tls_port, #tls_auth, #tls_enable').prop('disabled', true);
	            $('#ssl_socket_factory_port, #ssl_port, #ssl_smtp_type').prop('disabled', false);
			} else if (data.smtp_type =='tls' || data.smtp_type =='TLS'){
				$('#ssl_socket_factory_port, #ssl_port, #ssl_smtp_type').prop('disabled', true);
	            $('#tls_port, #tls_auth, #tls_enable').prop('disabled', false);
			}
			$('#ssl_socket_factory_port').val(data.ssl_socket_factory_port);
			$('#ssl_port').val(data.ssl_port);
			$('#ssl_smtp_type').val(data.ssl_smtp_type);
			$('#tls_port').val(data.tls_port);
			$('#tls_auth').val(data.tls_auth);
			$('#tls_enable').val(data.tls_enable);

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
			action: 'add'

		},
		success : function(data) {
			// Display the registration status message
			alert(data.message);
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
			
			location.reload();

		},
		error : function(xhr, status, error) {
			console.log('Error adding SMTP setting: ' + error);
		}
	});

	$('#addBtn').val('Add');
}

function editSMTPSettings() {
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
			action: 'update'

		},
		success : function(data) {
			// Display the registration status message
			alert(data.message);
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
			
			location.reload();

		},
		error : function(xhr, status, error) {
			console.log('Error editing SMTP setting: ' + error);
		}
	});

	$('#addBtn').val('Add');
}

function deleteSMTPSettings() {
		
		var confirmation = confirm('Are you sure you want to delete this SMTP settings?');
		if (confirmation) {
			$.ajax({
				url : 'SMTPServlet',
				type : 'DELETE',
				dataType : 'json',
				success : function(data) {
					// Display the registration status message
					alert(data.message);

					// Refresh the user list
					getSMTPSettings();
				},
				error : function(xhr, status, error) {
					// Handle the error response, if needed
					console.log('Error deleting SMTP settings: '+ error);
				}
			});
		}
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

$(document).ready(function() {
	<%// Access the session variable
	HttpSession role = request.getSession();
	String roleValue = (String) session.getAttribute("role");%>

roleValue = '<%=roleValue%>';
	
	getSMTPSettings();
	
	if (roleValue == 'VIEWER' || roleValue == 'Viewer') {

		var confirmation = confirm('You do not have enough privileges for role VIEWER');
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
			$("#ssl_smtp_type").val('True');
			
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
		$('#ssl_smtp_type').val('Select SSL SMTP type');
		$('#tls_port').val('');
		$('#tls_auth').val('Select TLS auth');
		$('#tls_enable').val('Select TLS enable');
	});
	
	$("#delBtn").click(function () {
		deleteSMTPSettings();
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
					
					<div class="col-75-1" style="width: 20%;">
						<input type="text" id="from_email_id" name="from_email_id"
							placeholder="From email ID" required style="height: 17px" />
					</div>
					
					<div class="col-75-2" style="width: 20%;">
						<input type="password" id="password" name="password"
							placeholder="Password" required style="height: 17px" />
					</div>
					<div class="col-75-3" style="width: 20%;">
						<input type="text" id="host" name="host"
							placeholder="Host" required style="height: 17px" />
					</div>
					
					<div class="col-75-4" style="width: 20%;">
						<select class="smtp_type" id="smtp_type" name="smtp_type"
							style="height: 35px">
							<option value="Select SMTP type">Select SMTP type</option>
							<option value="SSL">SSL</option>
							<option value="TLS">TLS</option>
						</select>
					</div>
							
					<div class="col-75-5" style="width: 20%;">
						<input type="text" id="ssl_socket_factory_port" name="ssl_socket_factory_port"
							placeholder="SSL socket factory port" style="height: 17px" />
					</div>				
				</div>
				
				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: 10px;">
					
					<div class="col-75-6" style="width: 20%;">
						<input type="text" id="ssl_port" name="ssl_port"
							placeholder="SSL port" style="height: 17px" />
					</div>
					
					<div class="col-75-7" style="width: 20%;">
						<select class="ssl_smtp_type" id="ssl_smtp_type" name="ssl_smtp_type"
							style="height: 35px">
							<option value="True" selected>True</option>
							<option value="False">False</option>
						</select>
					</div>
					
					<div class="col-75-8" style="width: 20%;">
						<input type="text" id="tls_port" name="tls_port"
							placeholder="TLS port" style="height: 17px" />
					</div>
					
					<div class="col-75-9" style="width: 20%;">
						<select class="tls_auth" id="tls_auth" name="tls_auth"
							style="height: 35px">
							<option value="True">True</option>
							<option value="False" selected>False</option>
						</select>
					</div>
					
					<div class="col-75-10" style="width: 20%;">
						<select class="tls_enable" id="tls_enable" name="tls_enable"
							style="height: 35px">
							<option value="True">True</option>
							<option value="False" selected>False</option>
						</select>
					</div>					
				</div>
				
				<div class="row" style="display: flex; justify-content: right;">
					<input style="margin-top: 10px; margin-left: 5px" type="button"
						value="Clear" id="clearBtn"/> 
						<input style="margin-top: 10px; margin-left: 5px" type="submit"
						value="Add" id="addBtn" /> 
						<input style="margin-top: 10px; margin-left: 5px" type="button"
						value="Delete" id="delBtn" onClick="window.location.reload();" />
				</div>
			</form>
		</div>
		</section>
		</div>
		
		<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>