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
  
  .popup {
  display: none;
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background-color: #fff;
  border: 1px solid #ccc;
  padding: 20px;
  box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5);
  z-index: 1000;
}

/* Style for the close button */
#closePopup {
  display: block;
  margin-top: 10px;
  background-color: #007bff;
  color: #fff;
  border: none;
  padding: 10px 20px;
  cursor: pointer;
}
  
</style>

<script>
	// Function to load user data and populate the user list table

	var roleValue;	
	var tokenValue;
	
	function loadCrtFilesList() {
		$.ajax({
			url : "mqttCrtFileListServlet",
			type : "GET",
			dataType : "json",
			success : function(data) {
				if (data.crt_files_result
						&& Array.isArray(data.crt_files_result)) {

					var selectElement = $("#file_name");
					// Clear any existing options
					//selectElement.empty();

					// Loop through the data and add options to the select element
					data.crt_files_result.forEach(function(filename) {
						var option = $("<option>", {
							value : filename,
							text : filename,
						});
						selectElement.append(option);
					});

				}
			},
			error : function(xhr, status, error) {
				console.log("Error showing crt files list : " + error);
			},
		});
	}

	function loadMqttList() {
		
		$.ajax({
					url : 'mqttServlet',
					type : 'GET',
					dataType : 'json',
					beforeSend: function(xhr) {
				        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
				    },
					success : function(data) {
						// Clear existing table rows
						var mqttTable = $('#mqttListTable tbody');
						mqttTable.empty();
						
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

						// Iterate through the user data and add rows to the table
						
						
						if(roleValue == 'Admin' || roleValue == 'ADMIN'){
							$.each(data,function(index, mqtt) {
								var row = $('<tr>');
								row.append($('<td>').text(mqtt.broker_ip_address+ ""));
								row.append($('<td>').text(mqtt.port_number + ""));
								row.append($('<td>').text(mqtt.username + ""));
								row.append($('<td>').text(mqtt.publish_topic + ""));
								row.append($('<td>').text(mqtt.subscribe_topic + ""));
								row.append($('<td>').text(mqtt.prefix + ""));
								row.append($('<td>').text(mqtt.file_type + ""));
								row.append($('<td>').text(mqtt.file_name + ""));
								row.append($('<td>').text(mqtt.enable + ""));
								
								var actions = $('<td>')
								
								var editButton = $(
										'<button data-toggle="tooltip" class="editBtn" data-placement="top" title="Edit" style="color: #35449a;">')
										.html('<i class="fas fa-edit"></i>')
										.click(
												function() {
													setMqtt(mqtt.prefix);
													setBrokerIPAddress(mqtt.broker_ip_address);
													setPortNumber(mqtt.port_number);
													setUsername(mqtt.username);
													setPassword(mqtt.password);
													setPublishedTopic(mqtt.publish_topic);
													setSubscribedTopic(mqtt.subscribe_topic);
													setFileType(mqtt.file_type);
													setFileName(mqtt.file_name);
													setEnable(mqtt.enable);

												});
								var deleteButton = $(
										'<button data-toggle="tooltip" class="delBtn" data-placement="top" title="Delete"style="color: red">')
										.html('<i class="fas fa-trash-alt"></i>')
										.click(
												function() {
												
												deleteMqtt(mqtt.prefix);
													
												});
								var getStatusButton = $(
										'<button data-toggle="tooltip" class="statusBtn" data-placement="top" title="Get Status"style="color: #35449a;">')
										.html('<i class="fas fa-info-circle"></i>')
										.click(
												function() {
													getMqttStatus(mqtt.broker_ip_address);
												});

								actions.append(editButton);
								actions.append(deleteButton);
								actions.append(getStatusButton);

								row.append(actions);
									
								mqttTable.append(row);

							});
							
						}else if(roleValue == 'VIEWER' || roleValue == 'Viewer'){
							$.each(data,function(index, mqtt) {
								var row = $('<tr>');
								row.append($('<td>').text(mqtt.broker_ip_address+ ""));
								row.append($('<td>').text(mqtt.port_number + ""));
								row.append($('<td>').text(mqtt.username + ""));
								row.append($('<td>').text(mqtt.publish_topic + ""));
								row.append($('<td>').text(mqtt.subscribe_topic + ""));
								row.append($('<td>').text(mqtt.prefix + ""));
								row.append($('<td>').text(mqtt.file_type + ""));
								row.append($('<td>').text(mqtt.file_name + ""));
								row.append($('<td>').text(mqtt.enable + ""));
								
								var actions = $('<td>')
								
								
								var getStatusButton = $(
										'<button data-toggle="tooltip" class="statusBtn" data-placement="top" title="Get Status" style="color: #35449a;">')
										.html('<i class="fas fa-info-circle"></i>')
										.click(
												function() {
													getMqttStatus(mqtt.broker_ip_address);
												});

															actions.append(getStatusButton);

								row.append(actions);
									
								mqttTable.append(row);

							});
						}
						// Initialize tooltips using Bootstrap
			            $('[data-toggle="tooltip"]').tooltip();
					},
					error : function(xhr, status, error) {
						console.log('Error loading mqtt data: ' + error);
					}
				});
	}


	function setMqtt(mqttId) {
		// Make an AJAX GET request to retrieve user details for editing

		$('#prefix').val(mqttId);
		$("#prefix").prop("disabled", true);
		$('#registerBtn').val('Edit');
	}

	function setBrokerIPAddress(mqttId) {

		$('#broker_ip_address').val(mqttId);
	}

	function setPortNumber(mqttId) {

		$('#port_number').val(mqttId);
	}

	function setUsername(mqttId) {

		$('#username').val(mqttId);
	}

	function setPassword(mqttId) {

		$('#password').val(mqttId);
	}

	function setPublishedTopic(mqttId) {

		$('#pub_topic').val(mqttId);
	}

	function setSubscribedTopic(mqttId) {

		$('#sub_topic').val(mqttId);
	}

	function setFileType(mqttId) {

		$('#file_type').val(mqttId);
		
		if(mqttId == 'TCP'){
			$("#file_name").prop("disabled", true);
		}
		
	}

	function setFileName(mqttId) {

		$('#file_name').val(mqttId);
	}

	function setEnable(mqttId) {

		$('#enable').val(mqttId);
	}

	function getMqttStatus(mqttId) {
		$.ajax({
			url : 'mqttCrtFileListServlet',
			type : 'POST',
			data : {
				broker_ip_address : mqttId

			},
			dataType : 'json', // Expecting JSON response from the server
			success : function(data) {
				// Display the MQTT status message
				
				if(data.connection_status == 'true'){
					alert(mqttId + ' : connected');
					
				}
				else{
					alert(mqttId + ' : disconnected');
				} 
				
			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error retrieving MQTT status: ' + error);
			}
		});
	}

	 
	function deleteMqtt(prefix) {
		// Display the custom modal dialog
		  var modal = document.getElementById('custom-modal-delete');
		  modal.style.display = 'block';

		  // Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-delete');
		  confirmButton.onclick = function () {
			  $.ajax({
					url : 'mqttServlet',
					type : 'POST',
					data : {
						prefix : prefix,
						action: 'delete'
					},
					success : function(data) {
						
						modal.style.display = 'none';
						loadMqttList();
					},
					error : function(xhr, status, error) {
						// Handle the error response, if needed
						console.log('Error deleting mqtt settings: ' + error);
					}
				});
			  
		  };
		  
		  var cancelButton = document.getElementById('cancel-button-delete');
		  cancelButton.onclick = function () {
		    // Close the modal
		    modal.style.display = 'none';
		  };
		  
	}
 
 function editMqtt(){
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-edit');
	  modal.style.display = 'block';
	  
	// Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-edit');
	  confirmButton.onclick = function () {
		  
		  var broker_ip_address = $('#broker_ip_address').val();
			var port_number = $('#port_number').val();
			var username = $('#username').val();
			var password = $('#password').val();
			var pub_topic = $('#pub_topic').val();
			var sub_topic = $('#sub_topic').val();
			var prefix = $('#prefix').val();
			var file_type = $('#file_type').find(":selected").val();
			var file_name = $('#file_name').find(":selected").val();
			var enable = $('#enable').find(":selected").val();
			
			$.ajax({
				url : 'mqttServlet',
				type : 'POST',
				data : {
					broker_ip_address : broker_ip_address,
					port_number : port_number,
					username : username,
					password : password,
					pub_topic : pub_topic,
					sub_topic : sub_topic,
					prefix : prefix,
					file_type : file_type,
					enable : enable,
					file_name : file_name,
					action: 'update'

				},
				success : function(data) {
					
					modal.style.display = 'none';
					loadMqttList();

					// Clear form fields
					$('#broker_ip_address').val('');
					$('#port_number').val('');
					$('#username').val('');
					$('#password').val('');
					$('#pub_topic').val('');
					$('#sub_topic').val('');
					$('#prefix').val('');
					$('#file_type').val('Select type');
					$('#file_name').val('Select crt file');
					$('#enable').val('Select status');

					$("#prefix").prop("disabled", false);
					$('#file_name').prop('disabled', false);
				},
				error : function(xhr, status, error) {
					console.log('Error updating mqtt: ' + error);
				}
			});
			$('#registerBtn').val('Add');
			
	  };
	  
	  var cancelButton = document.getElementById('cancel-button-edit');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	    $('#registerBtn').val('Edit');
	  };	
	 
 }
 
	// Function to handle form submission and add a new mqtt
	function addMqtt() {
		
		var broker_ip_address = $('#broker_ip_address').val();
		var port_number = $('#port_number').val();
		var username = $('#username').val();
		var password = $('#password').val();
		var pub_topic = $('#pub_topic').val();
		var sub_topic = $('#sub_topic').val();
		var prefix = $('#prefix').val();
		var enable = $('#enable').find(":selected").val();
		var file_type = $('#file_type').find(":selected").val();
		var file_name;
		
		if(file_type == 'TCP'){
			file_name = '';
		
		}else if(file_type == 'SSL'){
			file_name = $('#file_name').find(":selected").val();
			
		}

		$.ajax({
			url : 'mqttServlet',
			type : 'POST',
			data : {
				broker_ip_address : broker_ip_address,
				port_number : port_number,
				username : username,
				password : password,
				pub_topic : pub_topic,
				sub_topic : sub_topic,
				prefix : prefix,
				file_type : file_type,
				enable : enable,
				file_name : file_name,
				action: 'add'
				
			},
			success : function(data) {
				// Display the registration status message
				
			//	alert(data.message);
				
				// Display the custom popup message
     			$("#popupMessage").text(data.message);
      			$("#customPopup").show();

      
				loadMqttList();

				// Clear form fields

				$('#broker_ip_address').val('');
				$('#port_number').val('');
				$('#username').val('');
				$('#password').val('');
				$('#pub_topic').val('');
				$('#sub_topic').val('');
				$('#prefix').val('');
				$('#file_type').val('Select type');
				$('#file_name').val('Select crt file');
				$('#enable').val('Select status');
				
				$('#file_name').prop('disabled', false);

			},
			error : function(xhr, status, error) {
				console.log('Error adding mqtt settings: ' + error);
			}
		});
		$("#closePopup").click(function () {
		    $("#customPopup").hide();
		  });

		$('#registerBtn').val('Add');
	}
	
	function validateFiletype(type) {
		var fileTypeError = document.getElementById("fileTypeError");

		if (type == 'Select file type'){
			
			fileTypeError.textContent = "Please select type";
			return false;
		} else {
			fileTypeError.textContent = "";
			return true;
		}
	}
	
	function validateCrtFile(crtFile) {
		var crtFileError = document.getElementById("crtFileError");

		if (crtFile == 'Select crt file'){
			
			crtFileError.textContent = "Please select crt file";
			return false;
		} else {
			crtFileError.textContent = "";
			return true;
		}
	}
	
	function validateStatus(status) {
		var statusError = document.getElementById("statusError");

		if (status == 'Select status'){
			
			statusError.textContent = "Please select status";
			return false;
		} else {
			statusError.textContent = "";
			return true;
		}
	}

	
	function validateNumbers(number) {
		const
		numberPattern = /\b\d{1,5}\b/g;
		if (!numberPattern.test(number)) {
			portNoError.textContent = "Enter port number upto 5 digits";

			return false;
		} else {
			portNoError.textContent = "";
			return true;
		}
	}
	
	//change color of disabled buttons
	
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

	// Function to execute on page load
	$(document).ready(function() {
						
			<%// Access the session variable
			HttpSession role = request.getSession();
			String roleValue = (String) session.getAttribute("role");%>
    	
    	roleValue = '<%=roleValue%>';

					
						
						<%// Access the session variable
	HttpSession token = request.getSession();
	String tokenValue = (String) session.getAttribute("token");%>

	tokenValue = '<%=tokenValue%>';

						loadMqttList();
						
						
						if (roleValue == 'VIEWER' || roleValue == 'Viewer') {

							$('#registerBtn').prop('disabled', true);
							$('#clearBtn').prop('disabled', true);
							
							changeButtonColor(true);
						}

						loadCrtFilesList();

						$("#file_type").change(function(event) {
									
									if ($(this).val() == 'SSL'
											|| $(this).val() == 'ssl') {
										$("#file_name").prop("disabled", false);
									} else if ($(this).val() == 'TCP'
											|| $(this).val() == 'tcp') {
										$("#file_name").prop("disabled", true);
										$('#file_name').val('');
									}
								});

						// Handle form submission
						$('#mqttForm').submit(function(event) {
											event.preventDefault();
											var buttonText = $('#registerBtn')
													.val();
											var broker_ip_address = $(
											'#broker_ip_address').val();
										var type = $('#file_type').find(
											":selected").val();
										var port_number = $('#port_number')
											.val();
										var file_name = $('#file_name')
											.find(":selected").val();
										var broker_ip_address = $('#broker_ip_address').val();
										var port_number = $('#port_number').val();
										var username = $('#username').val();
										var password = $('#password').val();
										var pub_topic = $('#pub_topic').val();
										var sub_topic = $('#sub_topic').val();
										var prefix = $('#prefix').val();

										if ((prefix.length > 30)) {
											prefix_error.textContent = "You can write upto 30 maximum characters."
										}
										else {
											prefix_error.textContent = ""
										}

										if ((sub_topic.length > 30)) {
											sub_topic_error.textContent = "You can write upto 30 maximum characters."
										} else {
											sub_topic_error.textContent = ""
										}

										if ((pub_topic.length > 30)) {
											pub_topic_error.textContent = "You can write upto 30 maximum characters."
										}
										else {
											pub_topic_error.textContent = ""
										}

										if ((password.length > 30)) {
											password_error.textContent = "You can write upto 30 maximum characters."
										} else {
											password_error.textContent = ""
										}
										if ((username.length > 30)) {
											username_error.textContent = "You can write upto 30 maximum characters."
										} else {
											username_error.textContent = ""
										}

										if ((port_number.length > 5)) {
											port_number_error.textContent = "You can write upto 5 maximum characters."
										}
										else {
											port_number_error.textContent = ""
										}

										if ((broker_ip_address.length > 30)) {
											broker_ip_error.textContent = "You can write upto 30 maximum characters."
										} else {
											broker_ip_error.textContent = ""
										}

											if (!validateNumbers(port_number)) {
												portNoError.textContent = "Enter port number upto 5 digits";
												return;
											}

											if (!validateFiletype(type)) {
												fileTypeError.textContent = "Please select type";
												return;
											}
											
											if (!validateStatus(enable)) {
												statusError.textContent = "Please select status";
												return;
											}

											 var isDisabled = $("#file_name").prop("disabled");
											 if (!isDisabled) {
												 if (!validateCrtFile(file_name)) {
														crtFileError.textContent = "Please select crt file";
														return;
													}
											 }
											

											if (buttonText == 'Add') {
												addMqtt();
											} else {
												editMqtt();
											}
										});

						$('#clearBtn').click(function() {
							$('#broker_ip_address').val('');
							$('#port_number').val('');
							$('#username').val('');
							$('#password').val('');
							$('#pub_topic').val('');
							$('#sub_topic').val('');
							$('#prefix').val('');
							$("#prefix").prop("disabled", false);
							$('#file_type').val('Select type');
							$('#file_name').val('Select crt file');
							$('#enable').val('Select status');
							$('#registerBtn').val('Add');
						});

					});
</script>
</head>

<body>

	<div class="sidebar">
		<%@ include file="common.jsp"%>
	</div>
	<div class="header">
		<%@ include file="header.jsp"%>
	</div>
	<div class="content">
		<section style="margin-left: 1em">
			<h3>MQTT SERVER SETTINGS</h3>
			<hr>

			<div class="container">
				<form id="mqttForm">

					<input type="hidden" id="action" name="action" value="">

					<div class="row" style="display: flex; flex-content: space-between; margin-top: -20px;">

						<div class="col-75-1" style="width: 15%; height: 20%">
							<input type="text" id="broker_ip_address" maxlength="31" name="broker_ip_address"
								placeholder="Hostname" required />
							<p id="broker_ip_error" style="color: red;"></p>

						</div>

						<div class="col-75-2" style="width: 10%;">
							<input type="text" id="port_number" name="port_number" maxlength="6"
								placeholder="Port number" required /> <span style="color: red; font-size: 12px;"
								id="portNoError"></span>
							<p id="port_number_error" style="color: red;"></p>

						</div>

						<div class="col-75-3" style="width: 15%; height: 20%">
							<input type="text" id="username" name="username" placeholder="Username" maxlength="31"
								required />
							<p id="username_error" style="color: red;"></p>

						</div>

						<div class="col-75-4" style="width: 15%; height: 20%">
							<input type="password" id="password" name="password" placeholder="Password" maxlength="31"
								required />
							<p id="password_error" style="color: red;"></p>

						</div>

						<div class="col-75-5" style="width: 15%; height: 20%">
							<input type="text" id="pub_topic" name="pub_topic" placeholder="Published topic"
								maxlength="30" required />
							<p id="pub_topic_error" style="color: red;"></p>
						</div>
						<div class="col-75-10" style="width: 10%;">
							<select class="textBox" id="enable" name="enable" style="height: 35px;">
								<option value="Select status">Select status</option>
								<option value="True">True</option>
								<option value="False">False</option>

							</select>
							<span id="statusError" style="color: red;"></span>
						</div>
						<div class="col-75-8" style="width: 10%;">

							<select class="textBox" id="file_type" name="file_type" style="height: 35px;">
								<option value="Select type">Select type</option>
								<option>SSL</option>
								<option>TCP</option>

							</select> <span id="fileTypeError" style="color: red;"></span>
						</div>

						<div class="col-75-9" style="width: 10%;">

							<select class="textBox" id="file_name" name="file_name" style="height: 35px;">
								<option value="Select crt file">Select crt file</option>

							</select> <span id="crtFileError" style="color: red;"></span>

						</div>
					</div>


					<div class="row" style="display: flex; flex-content: space-between; margin-top: 10px;">

						<div class="col-75-6" style="width: 15%;">
							<input type="text" id="sub_topic" name="sub_topic" placeholder="Subscribed topic"
								maxlength="31" required />
							<p id="sub_topic_error" style="color: red;"></p>

						</div>

						<div class="col-75-7" style="width: 10%;">
							<input type="text" id="prefix" name="prefix" maxlength="31" placeholder="Prefix" required />
							<p id="prefix_error" style="color: red;"></p>

						</div>

					</div>

					<div class="row" style="display: flex; justify-content: right;margin-top: -2%; ">
						<input type="button" value="Clear" id="clearBtn" /> <input style="margin-left: 5px;"
							type="submit" value="Add" id="registerBtn" />
					</div>

				</form>
			</div>
			
			<div id="custom-modal-delete" class="modal-delete">
				<div class="modal-content-delete">
				  <p>Are you sure you want to delete this mqtt setting?</p>
				  <button id="confirm-button-delete">Yes</button>
				  <button id="cancel-button-delete">No</button>
				</div>
			  </div>
			  
			  <div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to edit this mqtt setting?</p>
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
  				<button id="closePopup">Close</button>
				</div>

			<h3>MQTT SERVER LIST</h3>
			<hr>
			<div class="container">
				<table id="mqttListTable">
					<thead>
						<tr>
							<th>Broker IP address</th>
							<th>Port Number</th>
							<th>Username</th>
							<th>Published topic</th>
							<th>Subscribed topic</th>
							<th>Prefix</th>
							<th>Type</th>
							<th>File name</th>
							<th>Enable</th>
							<th>Actions</th>

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