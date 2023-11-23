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


.modal-delete-crt-files {
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

.modal-content-delete-crt-files {
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


#confirm-button-delete-crt-files {
  background-color: #4caf50;
  color: white;
}

#cancel-button-delete-crt-files {
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
    width: 80%;
  }

 .bordered-table {
  border-collapse: collapse; /* Optional: To collapse table borders */
  margin: 0 auto; /* Center the table horizontally */
}

.bordered-table td {
  border: 1px solid #ccc; /* Light gray border */
}

/* .delete_crt {
            text-align: center;
        }
        
        .delete_crt h3 {
            text-align: left;
        }

        .delete_crt > div {
            display: inline-block;
            text-align: left;
        } */
        
         .upload-crt-container {
        display: flex;
        align-items: flex-start;
        justify-content: space-between;
    }

    .delete-crt-container {
        margin-right: 233px; /* Adjust margin as needed */
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
								row.append($('<td>').text(mqtt.publish_topic + ""));								
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
							
						}else if(roleValue == 'VIEWER' || roleValue == 'Viewer'){
							$.each(data,function(index, mqtt) {
								var row = $('<tr>');
								row.append($('<td>').text(mqtt.broker_ip_address+ ""));
								row.append($('<td>').text(mqtt.port_number + ""));							
								row.append($('<td>').text(mqtt.publish_topic + ""));								
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
					
					// Close the modal
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
	    $('#registerBtn').val('Update');
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
        var $crt_file_upload_button = $('#crt_file_upload');
        
        
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

	// Function to execute on page load
	$(document).ready(function() {
						
			<%// Access the session variable
			HttpSession role = request.getSession();
			String roleValue = (String) session.getAttribute("role");%>
    	
    	roleValue = '<%=roleValue%>';

						
						
						
						if (roleValue == 'VIEWER' || roleValue == 'Viewer') {

							$('#registerBtn').prop('disabled', true);
							$('#clearBtn').prop('disabled', true);
							$('#crtFileInput').prop('disabled', true); 
							
							changeButtonColor(true);
						}
						
						if (roleValue === "null") {
					        var modal = document.getElementById('custom-modal-session-timeout');
					        modal.style.display = 'block';

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
					    						
					    						$('#delete_crt_file').on('click', function () {
					    				            var selectedFile = $('#file_name_delete').val();
					    				            deleteCrtFiles(selectedFile);
					    				          
					    						});
					    						
					    						$("#crtUploadForm").submit(function (e) {
					    				            e.preventDefault(); // Prevent the default form submission

					    				            crtFileUpload();
					    				        });
					    						
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
					<table class="bordered-table" style="margin-top: -1px;">

					<tr>
					<td>Broker IP address</td>
					<td><input type="text" id="broker_ip_address" maxlength="31" name="broker_ip_address" required />
							<p id="broker_ip_error" style="color: red;"></p>
					</td>
					
					<td>Port</td>
					<td><input type="text" id="port_number" name="port_number" maxlength="6" required /> <span style="color: red; font-size: 12px;"
								id="portNoError"></span>
							<p id="port_number_error" style="color: red;"></p></td>
					
					<td>Username</td>
					<td><input type="text" id="username" name="username" maxlength="31"/>
							<p id="username_error" style="color: red;"></p></td>
					<td>Password</td>
					<td><input type="password" id="password" name="password" maxlength="31"/>
							<p id="password_error" style="color: red;"></p></td>
					</tr>
					<tr>
					<td>Published topic</td>
					<td><input type="text" id="pub_topic" name="pub_topic" maxlength="30" required />
							<p id="pub_topic_error" style="color: red;"></p></td>
							
							
					<td>Status</td>
					<td><select class="textBox" id="enable" name="enable" style="height: 33px;">
								<option value="Select status">Select status</option>
								<option value="True">True</option>
								<option value="False">False</option>
							</select>
							<span id="statusError" style="color: red;"></span></td>
					
					<td>Type</td>
					<td><select class="textBox" id="file_type" name="file_type" style="height: 33px;">
								<option value="Select type">Select type</option>
								<option>SSL</option>
								<option>TCP</option>
							</select> <span id="fileTypeError" style="color: red;"></span></td>
					<td>CRT file</td>
					<td><select class="textBox" id="file_name" name="file_name" style="height: 33px;">
								<option value="Select crt file">Select crt file</option>

							</select> <span id="crtFileError" style="color: red;"></span></td>
					</tr>
					<tr>
					<td>Subscribed topic</td>
					<td><input type="text" id="sub_topic" name="sub_topic" maxlength="31" required />
							<p id="sub_topic_error" style="color: red;"></p></td>
					<td>Prefix</td>
					<td><input type="text" id="prefix" name="prefix" maxlength="31" required />
							<p id="prefix_error" style="color: red;"></p>
					</td>
					<td></td>
					<td></td>
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
				  <p>Your session is timeout. Please login again</p>
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