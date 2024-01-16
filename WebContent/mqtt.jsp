<%  
    // Add X-Frame-Options header to prevent clickjacking
    response.setHeader("X-Frame-Options", "DENY");
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

<style>
.modal-delete,
.modal-delete-crt-files,
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

.modal-content-delete,
.modal-content-delete-crt-files,
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
  transform: translate(-50%, -50%); /* Center horizontally and vertically */
}

/* Style for buttons */
button {
  margin: 5px;
  padding: 10px 20px;
  border: none;
  cursor: pointer;
}

#confirm-button-delete,
#confirm-button-delete-crt-files,
#confirm-button-edit,
#confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
}

#cancel-button-delete,
#cancel-button-delete-crt-files,
#cancel-button-edit {
  background-color: #f44336;
  color: white;
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

.note {
    color: red;
    margin-top: 5%; 
}

h3{
margin-top: 70px;
}

.container {
    margin: 0 auto;
    max-width: 1200px;
    border-collapse: collapse;
    background-color: #f2f2f2;
     border-radius: 5px;
     overflow-x: auto; /* Enable horizontal scrolling */
     
     
  }

 .bordered-table {
  border-collapse: collapse; /* Optional: To collapse table borders */
  margin: 0 auto; /* Center the table horizontally */
 width: auto; /* Set width to auto for responsive behavior */
  table-layout: auto; /* Set table layout to auto */
}

.bordered-table td {
  border: 1px solid #ccc; /* Light gray border */
}
        
         .upload-crt-container {
        display: flex;
        align-items: flex-start;
        justify-content: space-between;
        overflow-x: auto; /* Enable horizontal scrolling */
    }

    .delete-crt-container {
        margin-right: 233px; /* Adjust margin as needed */
    }
    
    .password-container {
  display: flex; /* Use flexbox to align items horizontally */
  align-items: center; /* Center items vertically */
}

.password-toggle {
  cursor: pointer;
  margin-left: 5px; /* Adjust the margin for spacing */
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
	
	function loadCrtFilesListToDelete() {
		$.ajax({
			url : "mqttCrtFileListServlet",
			type : "GET",
			dataType : "json",
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
				
				if (data.crt_files_result
						&& Array.isArray(data.crt_files_result)) {

					var selectElement = $("#file_name_delete");
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
		
		// Display loader when the request is initiated
	    showLoader();
		
		$.ajax({
					url : 'mqttServlet',
					type : 'GET',
					dataType : 'json',
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
						
						// Clear existing table rows
						var mqttTable = $('#mqttListTable tbody');
						mqttTable.empty();
						
						if(roleValue == 'Admin' || roleValue == 'ADMIN'){
 								data.result.forEach(function(mqtt) {
								
								var broker_ip_address = mqtt.broker_ip_address; 
								var port_number = mqtt.port_number; 
								var publish_topic = mqtt.publish_topic; 
								var prefix = mqtt.prefix; 
								var file_type = mqtt.file_type; 
								var file_name = mqtt.file_name; 
								var enable = mqtt.enable; 
								var publishing_format = mqtt.publishing_format;
								
								var row = $("<tr>").append($("<td>").text(broker_ip_address),
										$("<td>").text(port_number),
										$("<td>").text(publish_topic),
										$("<td>").text(prefix),
										$("<td>").text(file_type),
										$("<td>").text(file_name),
										$("<td>").text(enable),
										$("<td>").text(publishing_format)
										);
								
								var actions = $('<td>');
								
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
													setPublishingFormat(mqtt.publishing_format);

												});
								var deleteButton = $(
										'<button data-toggle="tooltip" class="delBtn" data-placement="top" title="Delete" style="color: red">')
										.html('<i class="fas fa-trash-alt"></i>')
										.click(
												function() {
												
												deleteMqtt(mqtt.prefix);
													
												});
								var getStatusButton = $(
										'<button data-toggle="tooltip" class="statusBtn" data-placement="top" title="Get Status" style="color: #35449a;">')
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
							
						}else if(roleValue == 'OPERATOR' || roleValue == 'Operator'){
							data.result.forEach(function(mqtt) {
								var broker_ip_address = mqtt.broker_ip_address; 
								var port_number = mqtt.port_number; 
								var publish_topic = mqtt.publish_topic; 
								var prefix = mqtt.prefix; 
								var file_type = mqtt.file_type; 
								var file_name = mqtt.file_name; 
								var enable = mqtt.enable; 
								var publishing_format = mqtt.publishing_format;
								
								var row = $("<tr>").append($("<td>").text(broker_ip_address),
										$("<td>").text(port_number),
										$("<td>").text(publish_topic),
										$("<td>").text(prefix),
										$("<td>").text(file_type),
										$("<td>").text(file_name),
										$("<td>").text(enable),
										$("<td>").text(publishing_format));
								
								var actions = $('<td>');
								
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
					},
					error : function(xhr, status, error) {
						// Hide loader when the response has arrived
			            hideLoader();
						console.log('Error loading mqtt data: ' + error);
					}
				});
	}


	function setMqtt(mqttId) {
		// Make an AJAX GET request to retrieve user details for editing

		$('#prefix').val(mqttId);
		$("#prefix").prop("disabled", true);
		$('#registerBtn').val('Update');
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
		}else if(mqttId == 'SSL'){
			$("#file_name").prop("disabled", false);
		}
		
	}

	function setFileName(mqttId) {

		$('#file_name').val(mqttId);
	}
	
	
	function setPublishingFormat(mqttId) {

		$('#publishing_format').val(mqttId);
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
				
					// Display the custom popup message
	     			$("#popupMessage").text(mqttId + ' : connected');
	      			$("#customPopup").show();
	      			
				}
				else{
				
					// Display the custom popup message
	     			$("#popupMessage").text(mqttId + ' : disconnected');
	      			$("#customPopup").show();
				} 
				
			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error retrieving MQTT status: ' + error);
			}
		});
		
		$("#closePopup").click(function () {
		    $("#customPopup").hide();
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
						
						modal.style.display = 'none';
						loadMqttList();
						location.reload();
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
			var enable = $('#enable').find(":selected").val();
			var publishing_format = $('#publishing_format').find(":selected").val();
			
			
			 var file_name;
				
				if(file_type == 'TCP'){
					file_name = '';
				
				}else if(file_type == 'SSL'){
					file_name = $('#file_name').find(":selected").val();
					
				}
				
				if ($('#file_type').val().toUpperCase() === 'TCP') {
				    $("#file_name").prop("disabled", true);
				} else {
				    $("#file_name").prop("disabled", false);
				}

				 // Add change event listener
				$("#file_type").change(function(event) {
				    if ($(this).val().toUpperCase() === 'TCP') {
				        $("#file_name").prop("disabled", true);
				        $('#file_name').val(''); // Clear the value when disabled, if needed
				    } else {
				        $("#file_name").prop("disabled", false);
				    }
				}); 
				
				
				$('#enable').on('change', function () {
			        var enableValue = $(this).val();

			        // Check if the enable field changed from Disable to Enable
			        if (enableValue === 'Enable') {
			            var existingEnabledEntries = $('#mqttListTable tbody').find('td:contains("Enable")');
			            if (existingEnabledEntries.length > 0) {
			                // Display a message or perform other actions
			                $("#popupMessage").text('Only one entry can be enabled at a time. Please disable the existing entry first.');
			                $("#customPopup").show();
			                
			                $('#broker_ip_address').val('');
							$('#port_number').val('');
							$('#username').val('');
							$('#password').val('');
							$('#pub_topic').val('');
							$('#sub_topic').val('');
							$('#prefix').val('');
							$('#file_type').val('TCP');
							$('#file_name').val('Select crt file');
							$('#publishing_format').val('Single');
							
							$('#enable').val('Disable');
							$("#prefix").prop("disabled", false);					
							$('#file_name').prop('disabled', true);
								
								$('#registerBtn').val('Add');
								
			                return; // Prevent form submission
			            }
			        }
			    });
				
			
			
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
					publishing_format : publishing_format,
					action: 'update'

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
					
					loadMqttList();

					// Clear form fields
					var passwordInput = $('#password');
				    var passwordToggle = $('#password-toggle');

				    // Reset password input first
				    passwordInput.attr('type', 'password');
				    passwordToggle.html('<i class="fa fa-eye"></i>'); // Change to eye icon
				    
					$('#broker_ip_address').val('');
					$('#port_number').val('');
					$('#username').val('');
					$('#password').val('');
					$('#pub_topic').val('');
					$('#sub_topic').val('');
					$('#prefix').val('');
					$('#publishing_format').val('Single');
					$('#file_type').val('TCP');
					$('#file_name').val('Select crt file');
					$('#enable').val('Disable');

					$("#prefix").prop("disabled", false);
					
						$('#file_name').prop('disabled', true);
					
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
	    $('#registerBtn').val('Update');
	  };	
	  
	 
 }
 
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
		var publishing_format = $('#publishing_format').find(":selected").val();
		var file_type = $('#file_type').find(":selected").val();
		var file_name;
		
		if(file_type == 'TCP'){
			file_name = '';
		
		}else if(file_type == 'SSL'){
			file_name = $('#file_name').find(":selected").val();
			
		}
		
		if (enable === 'Enable') {
	        var existingEnabledEntries = $('#mqttListTable tbody').find('td:contains("Enable")');
	        if (existingEnabledEntries.length > 0) {
	            //alert();
	            
	            $("#popupMessage").text('Only one entry can be enabled at a time. Please disable the existing entry first.');
      			$("#customPopup").show();

      			
	            return; // Prevent form submission
	        }
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
				publishing_format : publishing_format,
				action: 'add'
				
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
				
				// Display the custom popup message
     			$("#popupMessage").text(data.message);
      			$("#customPopup").show();

      
				loadMqttList();

				// Clear form fields
				var passwordInput = $('#password');
				    var passwordToggle = $('#password-toggle');

				    // Reset password input first
				    passwordInput.attr('type', 'password');
				    passwordToggle.html('<i class="fa fa-eye"></i>'); // Change to eye icon

				$('#broker_ip_address').val('');
				$('#port_number').val('');
				$('#username').val('');
				$('#password').val('');
				$('#pub_topic').val('');
				$('#sub_topic').val('');
				$('#prefix').val('');
				$('#publishing_format').val('Single');				
				$('#file_type').val('TCP');
				$('#file_name').val('Select crt file');
				$('#enable').val('Disable');
				
				
				if ($("#file_type").val().toUpperCase() === 'TCP') {
			        $("#file_name").prop("disabled", true);
			    } else {
			        $("#file_name").prop("disabled", false);
			    }

			    // Event handler for file_type change
			    $("#file_type").change(function(event) {
			        // Check the selected value and enable/disable file_name accordingly
			        if ($(this).val().toUpperCase() === 'TCP') {
			            $("#file_name").prop("disabled", true);
			            $('#file_name').val(''); // Clear the value when disabled, if needed
			        } else {
			            $("#file_name").prop("disabled", false);
			        }
			    });
				//$('#file_name').prop('disabled', false);

			},
			error : function(xhr, status, error) {
				console.log('Error adding mqtt settings: ' + error);
			}
		});
		

		$('#registerBtn').val('Add');
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
        var $crt_file_upload_button = $('#crt_file_upload');
        var $crt_file_delete_button = $('#delete_crt_file');
        
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
        
        if (isDisabled) {
            $crt_file_upload_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $crt_file_upload_button.css('background-color', '#2b3991'); // Reset to original color
        } 
        
        if (isDisabled) {
            $crt_file_delete_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $crt_file_delete_button.css('background-color', '#2b3991'); // Reset to original color
        } 
        
    }
	
	 function redirectToMQTT() {
	        window.location.href = 'mqtt.jsp';
	    }
	 
	 function deleteCrtFiles(crt_file_name){
		 
		// Display the custom modal dialog
		  var modal = document.getElementById('custom-modal-delete-crt-files');
		  modal.style.display = 'block';

		  // Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-delete-crt-files');
		  confirmButton.onclick = function () {
		 
		 $.ajax({
             url: 'mqttServlet', // Replace with the actual server endpoint
             type: 'POST',
             data: { 
            	 crt_file_name: crt_file_name,
            	 action : 'crt_file_delete'
           },
             success: function (response) {
            	 modal.style.display = 'none';
                 loadCrtFilesListToDelete();
                 location.reload();
             },
             error: function (xhr, status, error) {
                 console.error('Error deleting CRT File:', error);
                 // Handle error scenarios
             }
         });
		  };
		  
		  var cancelButton = document.getElementById('cancel-button-delete-crt-files');
		  cancelButton.onclick = function () {
		    // Close the modal
		    modal.style.display = 'none';
		  };
	 }
	 
	 function crtFileUpload(){
		 var inputFile = $("#crtFileInput");
         var fileName = inputFile.val();

         // Check if a file is selected
         if (fileName) {
             // Check if the file has a ".crt" extension
             if (/\.(crt)$/i.test(fileName)) {
                 // File has a valid extension, proceed with the form submission
                 var formData = new FormData($("#crtUploadForm")[0]);

                 $.ajax({
                     type: "POST",
                     url: "CRTFileUploadServlet",
                     data: formData,
                     processData: false,
                     contentType: false,
                     success: function (response) {
                        
                         redirectToMQTT();
                     },
                     error: function (error) {
                         // Handle the error response
                         console.error("Error uploading file:", error);
                     }
                 });
             } else {
                 // File does not have a valid extension
             	$("#popupMessage").text('Invalid file extension. Please select a file with .crt extension.');
	      			$("#customPopup").show();
             }
         } else {
         	$("#popupMessage").text('Please select a file.');
   			$("#customPopup").show();
         }
         
         $("#closePopup").click(function () {
			    $("#customPopup").hide();
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
	 
	// Function to execute on page load
	$(document).ready(function() {
						
			<%// Access the session variable
			HttpSession role = request.getSession();
			String roleValue = (String) session.getAttribute("role");%>
    	
    	roleValue = '<%=roleValue%>';

						if (roleValue == 'OPERATOR' || roleValue == 'Operator') {

							$('#registerBtn').prop('disabled', true);
							$('#clearBtn').prop('disabled', true);
							$('#crtFileInput').prop('disabled', true); 
							$('#delete_crt_file').prop('disabled', true);
							
							changeButtonColor(true);
						}
						
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

					    						loadMqttList();
					    						
					    						loadCrtFilesList();
					    						
					    						loadCrtFilesListToDelete();
					    						
					    						
					    						$("#closePopup").click(function () {
					    						    $("#customPopup").hide();
					    						  });
					    						
					    						
					    						$('#delete_crt_file').on('click', function () {
					    				            var selectedFile = $('#file_name_delete').val();
					    				            deleteCrtFiles(selectedFile);
					    				          
					    						});
					    						
					    						$("#crtUploadForm").submit(function (e) {
					    				            e.preventDefault(); // Prevent the default form submission

					    				            crtFileUpload();
					    				        });
					    						
					    						if ($("#file_type").val().toUpperCase() === 'TCP') {
					    					        $("#file_name").prop("disabled", true);
					    					    } else {
					    					        $("#file_name").prop("disabled", false);
					    					    }

					    					    // Event handler for file_type change
					    					    $("#file_type").change(function(event) {
					    					        // Check the selected value and enable/disable file_name accordingly
					    					        if ($(this).val().toUpperCase() === 'TCP') {
					    					            $("#file_name").prop("disabled", true);
					    					            $('#file_name').val(''); // Clear the value when disabled, if needed
					    					        } else {
					    					            $("#file_name").prop("disabled", false);
					    					        }
					    					    });

					    						// Handle form submission
					    						$('#mqttForm').submit(function(event) {
					    											event.preventDefault();
					    											var buttonText = $('#registerBtn').val();
					    											
					    											var broker_ip_address = $('#broker_ip_address').val();
					    										var type = $('#file_type').find(":selected").val();
					    										var port_number = $('#port_number').val();
					    										var file_name = $('#file_name').find(":selected").val();
					    										var broker_ip_address = $('#broker_ip_address').val();
					    										var port_number = $('#port_number').val();
					    										var username = $('#username').val();
					    										var password = $('#password').val();
					    										var pub_topic = $('#pub_topic').val();
					    										var sub_topic = $('#sub_topic').val();
					    										var prefix = $('#prefix').val();

					    											if (!validateNumbers(port_number)) {
					    												portNoError.textContent = "Enter port number upto 5 digits";
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
					    							var passwordInput = $('#password');
					    						    var passwordToggle = $('#password-toggle');

					    						    // Reset password input first
					    						    passwordInput.attr('type', 'password');
					    						    passwordToggle.html('<i class="fa fa-eye"></i>'); // Change to eye icon
					    						    
					    							$('#broker_ip_address').val('');
					    							$('#port_number').val('');
					    							$('#username').val('');
					    							$('#password').val('');
					    							$('#pub_topic').val('');
					    							$('#sub_topic').val('');
					    							$('#prefix').val('');
					    							$('#publishing_format').val('Single');
					    							$("#prefix").prop("disabled", false);
					    							$('#file_type').val('TCP');
					    							$('#file_name').val('Select crt file');
					    							$('#enable').val('Disable');
					    							$('#registerBtn').val('Add');
					    						});
					    						
					    						$('#password-toggle').click(function () {
					    			                togglePassword();
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
			<h3>ADD MQTT SERVER</h3>
			<hr>

			<div class="container">
				<form id="mqttForm">

					<input type="hidden" id="action" name="action" value="">
					
	<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>
					
					
					<table class="bordered-table" style="margin-top: -1px;">

					<tr>
					<td>Broker IP address</td>
					<td><input type="text" id="broker_ip_address" maxlength="31" name="broker_ip_address" required />
							
					</td>
					
					<td>Port</td>
					<td><input type="text" id="port_number" name="port_number" maxlength="6" required /> <span style="color: red; font-size: 12px;"
								id="portNoError"></span>
							</td>
					
					<td>Username</td>
					<td><input type="text" id="username" name="username" maxlength="31"/>
							</td>
					<td>Password</td>
					
					
					<td><div class="password-container">
    <input type="password" id="password" name="password" maxlength="31"/>
    <span class="password-toggle" id="password-toggle"><i class="fa fa-eye"></i></span>
  </div>
							</td>
					</tr>
					<tr>
					<td>Published topic</td>
					<td><input type="text" id="pub_topic" name="pub_topic" maxlength="30" required />
							
					<td>Status</td>
					<td><select class="textBox" id="enable" name="enable" style="height: 33px;">
								
								<option value="Enable">Enable</option>
								<option value="Disable" selected>Disable</option>
							</select>
							
					
					<td>Type</td>
					<td><select class="textBox" id="file_type" name="file_type" style="height: 33px;">
								
								<option value="SSL">SSL</option>
								<option value="TCP" selected>TCP</option>
							</select>
							</td>
					<td>CRT file</td>
					<td><select class="textBox" id="file_name" name="file_name" style="height: 33px;">
								<option value="Select crt file">Select crt file</option>

							</select> <span id="crtFileError" style="color: red;"></span></td>
					</tr>
					<tr>
					<td>Subscribed topic</td>
					<td><input type="text" id="sub_topic" name="sub_topic" maxlength="31" required />
							</td>
					<td>Prefix</td>
					<td><input type="text" id="prefix" name="prefix" maxlength="31" required />
							
					</td>
					<td>Publishing format</td>
					<td>
					<select class="textBox" id="publishing_format" name="publishing_format" style="height: 33px;">
								
								<option value="Single" selected>Single</option>
								<option value="Array">Array</option>
							</select>
					</td>
					<td></td>
					<td></td>
					</tr>
								
					</table>
					
					<div class="row" style="display: flex; justify-content: center; margin-bottom: 2%; margin-top: 1%;">			
						<input style="height: 26px;" type="button" value="Clear" id="clearBtn" /> 
						<input style="margin-left: 5px; height: 26px;" type="submit" value="Add" id="registerBtn" />

					</div>
				</form>
				
			<div class="upload-crt-container">
    <div>
        <h3 style="margin-top: 5px;">UPLOAD CRT FILE</h3>
        <form action="CRTFileUploadServlet" method="post" enctype="multipart/form-data" id="crtUploadForm">
            <input type="file" name="file" id="crtFileInput">
            <input type="submit" value="Upload" id="crt_file_upload">
        </form>
    </div>

    <div class="delete-crt-container">
        <h3 style="margin-top: 5px;">DELETE CRT FILE</h3>
        <div>
            <select class="textBox" id="file_name_delete" name="file_name_delete" style="height: 33px; width: 200px; margin-top: 10px;"></select>
            <input style="height: 26px; margin-left: 5px;" type="button" value="Delete CRT file" id="delete_crt_file" />
        </div>
    </div>
</div>
    		
    		<div class="note">
					<p>Note: Please upload CRT file first and you will find that file in crt file dropdown.</p>
				</div>
    		
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
				  <p>Are you sure you want to modify this mqtt setting?</p>
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
			  
			  <div id="custom-modal-delete-crt-files" class="modal-delete-crt-files">
				<div class="modal-content-delete-crt-files">
				  <p>Are you sure you want to delete this crt file?</p>
				  <button id="confirm-button-delete-crt-files">Yes</button>
				  <button id="cancel-button-delete-crt-files">No</button>
				</div>
			  </div>

			<h3 style="margin-top: 15px;">MQTT SERVER LIST</h3>
			<hr>
			<div class="table-container">
				<table id="mqttListTable">
					<thead>
						<tr>
							<th>Broker IP address</th>
							<th>Port</th>						
							<th>Published topic</th>						
							<th>Prefix</th>
							<th>Type</th>
							<th>File name</th>
							<th>Enable</th>
							<th>Publishing format</th>
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