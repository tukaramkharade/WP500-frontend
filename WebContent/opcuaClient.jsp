<!DOCTYPE html>
<html>
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>

h3{
margin-top: 70px;
}

.container {
    margin: 0 auto;
    width: 80%;
  }

 .bordered-table {
  border-collapse: collapse; /* Optional: To collapse table borders */
  margin: 0 auto; /* Center the table horizontally */
}

.bordered-table td {
  border: 1px solid #ccc; /* Light gray border */
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

</style>

<script>

var roleValue;
var tokenValue;

function loadOPCUAClientList(){
	
	$.ajax({

		url : 'OPCUAClientServlet',
		type : 'GET',
		dataType : 'json',
		beforeSend: function(xhr) {
	        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
	    },
	    
	    success : function(data) {
			// Clear existing table rows
			var opcuaTable = $('#opcuaListTable tbody');
			opcuaTable.empty();

			var json1 = JSON.stringify(data);

			var json = JSON.parse(json1);

			if (json.status == 'fail') {
				
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
			
			

			if(roleValue == 'ADMIN' || roleValue == 'Admin'){
				// Iterate through the user data and add rows to the table
				$.each(data,function(index, opcuaClient) {
					
								var row = $('<tr>');
									
								
									row.append($('<td>').text(opcuaClient.endUrl));
									row.append($('<td>').text(opcuaClient.Username));
									row.append($('<td>').text(opcuaClient.Password));
									row.append($('<td>').text(opcuaClient.Security));	
									row.append($('<td>').text(opcuaClient.ActionType));
									row.append($('<td>').text(opcuaClient.prefix));
									
									 var actions = $('<td>');
							
											var editButton = $(
				                            '<button data-toggle="tooltip" data-placement="top" title="Edit" style="color: #35449a;">'
				                            )
				                            .html('<i class="fas fa-edit"></i>')
				                            .click(function() {
				                                setEndUrl(opcuaClient.endUrl);
				                                setUserName(opcuaClient.Username);
				                                setPassword(opcuaClient.Password);
				                                setActionType(opcuaClient.ActionType);
				                                setSecurity(opcuaClient.Security);
				                                setPrefix(opcuaClient.prefix);
				                            });

				                        var deleteButton = $(
				                            '<button data-toggle="tooltip" data-placement="top" title="Delete" style="color: red;">')
				                            .html('<i class="fas fa-trash-alt"></i>')
				                            .click(function() {
				                                deleteOpcuaClient(opcuaClient.prefix);
				                            });

				                       

									actions.append(editButton);
									actions.append(deleteButton);									

									row.append(actions); 

									opcuaTable.append(row);
				
								});
			}else if(roleValue == 'VIEWER' || roleValue == 'Viewer'){
				
				// Iterate through the user data and add rows to the table
				$.each(data,function(index, opcuaClient) {
					
									var row = $('<tr>');
									
									row.append($('<td>').text(opcuaClient.endUrl));
									row.append($('<td>').text(opcuaClient.Username));
									row.append($('<td>').text(opcuaClient.Password));
									row.append($('<td>').text(opcuaClient.Security));	
									row.append($('<td>').text(opcuaClient.ActionType));
									row.append($('<td>').text(opcuaClient.prefix));

									opcuaTable.append(row);
					
								});
			}
			
		
			
		},
		error : function(xhr, status, error) {
			console.log('Error loading opcua client data: ' + error);
		}
		
	});
	
}

function setEndUrl(opcuaClientId){
	$('#endURL').val(opcuaClientId);
}

function setUserName(opcuaClientId){
	$('#username').val(opcuaClientId);
}

function setPassword(opcuaClientId){
	$('#password').val(opcuaClientId);
}

function setActionType(opcuaClientId){
	$('#actionType').val(opcuaClientId);
}

function setSecurity(opcuaClientId){
	$('#security').val(opcuaClientId);
}

function setPrefix(opcuaClientId){
	$('#prefix').val(opcuaClientId);
	$("#prefix").prop("disabled", true);
	$('#registerBtn').val('Update');
}

function editOPCUA(){
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-edit');
	  modal.style.display = 'block';
	  
	// Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-edit');
	  confirmButton.onclick = function () {
		  
		  var endURL = $('#endURL').val();
			var username = $('#username').val();
			var password = $('#password').val();
			var security = $('#security').find(":selected").val();
			var actionType = $('#actionType').find(":selected").val();
			var prefix = $('#prefix').val();
			
			
			$.ajax({
				
				url : 'OPCUAClientServlet',
				type : 'POST',
				data : {
					
					endURL : endURL,
					username : username,
					password : password,
					security : security,
					actionType : actionType,
					prefix : prefix,		
					action: 'update'		
				},
				success : function(data) {
					
					// Close the modal
				    modal.style.display = 'none';

		  
					loadOPCUAClientList();

					// Clear form fields

					$('#endURL').val('');
					$('#username').val('');
					$('#password').val('');
					$('#security').val('');
					$('#prefix').val('');
					$('#actionType').val('Enable');
					
				},
				error : function(xhr, status, error) {
					console.log('Error adding opcua settings: ' + error);
				}
			});
			
			$('#registerBtn').val('Add');
		  
	  };
	  
	  var cancelButton = document.getElementById('cancel-button-edit');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	    $('#registerBtn').val('Update');
	  };	
	
}


function addOPCUA(){
	
	var endURL = $('#endURL').val();
	var username = $('#username').val();
	var password = $('#password').val();
	var security = $('#security').find(":selected").val();
	var actionType = $('#actionType').find(":selected").val();
	var prefix = $('#prefix').val();
	
	$.ajax({
		
		url : 'OPCUAClientServlet',
		type : 'POST',
		data : {
			
			endURL : endURL,
			username : username,
			password : password,
			security : security,
			actionType : actionType,
			prefix : prefix,		
			action: 'add'		
		},
		success : function(data) {
			
			// Display the custom popup message
 			$("#popupMessage").text(data.message);
  			$("#customPopup").show();

  
			loadOPCUAClientList();

			// Clear form fields

			$('#endURL').val('');
			$('#username').val('');
			$('#password').val('');
			$('#security').val('');
			$('#prefix').val('');
			$('#actionType').val('Enable');
			
		},
		error : function(xhr, status, error) {
			console.log('Error adding opcua settings: ' + error);
		}
	});
	
	$("#closePopup").click(function () {
	    $("#customPopup").hide();
	  });
	
	$('#registerBtn').val('Add');
}


function deleteOpcuaClient(prefix){
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-delete');
	  modal.style.display = 'block';

	  // Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-delete');
	  confirmButton.onclick = function () {
		  $.ajax({
				url : 'OPCUAClientServlet',
				type : 'POST',
				data : {
					prefix : prefix,
					action: 'delete'
				},
				success : function(data) {
					
					modal.style.display = 'none';
					loadOPCUAClientList();
				},
				error : function(xhr, status, error) {
					// Handle the error response, if needed
					console.log('Error deleting opcua client settings: ' + error);
				}
			});
		  
	  };
	  
	  var cancelButton = document.getElementById('cancel-button-delete');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	  };
}

function changeButtonColor(isDisabled) {
    var $add_button = $('#registerBtn');       
    var $clear_button = $('#clearBtn');
    
    
     if (isDisabled) {
        $add_button.css('background-color', 'gray'); // Change to your desired color
    } else {
        $add_button.css('background-color', '#2b3991'); // Reset to original color
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

	<%// Access the session variable
	HttpSession token = request.getSession();
	String tokenValue = (String) session.getAttribute("token");%>

	tokenValue = '<%=tokenValue%>';
	
	loadOPCUAClientList();
	
	if (roleValue == 'VIEWER' || roleValue == 'Viewer') {

		$("#actions").hide();
		$('#registerBtn').prop('disabled', true);
		$('#clearBtn').prop('disabled', true);
		
		changeButtonColor(true);
	}
	
	$('#opcuaClientForm').submit(function(event) {
		event.preventDefault();
		var buttonText = $('#registerBtn').val();
		
		if (buttonText == 'Add') {
			addOPCUA();
		}else {
			editOPCUA();		
		}
	});
	
	$('#clearBtn').click(function() {
		$('#endURL').val('');
		$('#username').val('');
		$('#password').val('');
		$('#security').val('');
		$('#actionType').val('');
		$('#prefix').val('');
		$("#prefix").prop("disabled", false);
		$('#registerBtn').val('Add');
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
		
		<h3>ADD OPCUA CLIENT SETTINGS</h3>
		<hr />
			
			<div class="container">
				<form id="opcuaClientForm">
				
				<input type="hidden" id="action" name="action" value="">
					<table class="bordered-table" style="margin-top: -1px;">
					
					<tr>
					<td>End URL</td>
					<td><input type="text" id="endURL" name="endURL" maxlength="31"/>
							<p id="endURL_error" style="color: red;"></p></td>
					<td>Username</td>
					<td><input type="text" id="username" name="username" maxlength="31"/>
							<p id="username_error" style="color: red;"></p></td>
					<td>Password</td>
					<td><input type="password" id="password" name="password" maxlength="31"/>
							<p id="password_error" style="color: red;"></p></td>
					</tr>
					
					<tr>
					<td>Security</td>
					<td>
					<!-- <input type="text" id="security" name="security" maxlength="31"/>
							<p id="security_error" style="color: red;"></p> -->
							
							<select class="textBox" id="security" name="security">
								<option value="Select security">Select security</option>
								<option value="None,None">None,None</option>
								<option value="Basic128rsa15,Sign and Encrypt">Basic128rsa15,Sign and Encrypt</option>
								<option value="Basic256,Sign and Encrypt">Basic256,Sign and Encrypt</option>
								<option value="Basic256sha256,Sign and Encrypt">Basic256sha256,Sign and Encrypt</option>
							</select>
							
							</td>
					<td>Action type</td>
					<td><select class="textBox" id="actionType" name="actionType" style="height: 33px;">
								<option value="Select action type">Select action type</option>
								<option value="Enable">Enable</option>
								<option value="Disable">Disable</option>
							</select>
							<span id="actionTypeError" style="color: red;"></span></td>
					<td>Prefix</td>
					<td><input type="text" id="prefix" name="prefix" maxlength="31"/>
							<p id="prefix_error" style="color: red;"></p></td>
					</tr>
					</table>
					
					<div class="row" style="display: flex; justify-content: center; margin-bottom: 2%; margin-top: 1%;">			
						<input style="height: 26px;" type="button" value="Clear" id="clearBtn" /> 
						<input style="margin-left: 5px; height: 26px;" type="submit" value="Add" id="registerBtn" />

					</div>
				
				</form>
			</div>
			
			<div id="custom-modal-delete" class="modal-delete">
				<div class="modal-content-delete">
				  <p>Are you sure you want to delete this opcua client setting?</p>
				  <button id="confirm-button-delete">Yes</button>
				  <button id="cancel-button-delete">No</button>
				</div>
			  </div>
			  
			  <div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to modify this opcua client setting?</p>
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
			  
			<div id="customPopup" class="popup">
  				<span class="popup-content" id="popupMessage"></span>
  				<button id="closePopup">OK</button>
			  </div>
			  
			  <div class="table-container">
			<h3 style="margin-top: 15px;">OPCUA CLIENT LIST</h3>
			
			<hr />
				<table id="opcuaListTable" style="width: 100%; margin-top: 5px;">
					<thead>
						<tr>
						<th>End URL</th>
							<th>User name</th>
							<th>Password</th>
							<th>Security</th>
							<th>Action type</th>
							<th>Prefix</th>
							<th id="actions">Actions</th>
						</tr>
					</thead>
					<tbody>
						<!-- User list table rows will be populated dynamically using JavaScript -->
					</tbody>
				</table>
			</div>
			
		</section>
		</div>
		
		<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>