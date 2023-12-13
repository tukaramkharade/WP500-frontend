<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
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
.modal-session-timeout,
.modal-delete,
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
.modal-content-delete,
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

#confirm-button-delete,
#confirm-button-edit,
#confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
}

#cancel-button-delete,
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

h3{
margin-top: 68px;
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


</style>
<script>

var roleValue;	
var json_string_text;
var tokenValue;

	function loadBrokerIPList() {
		$.ajax({
			url : "jsonBuilderData",
			type : "GET",
			dataType : "json",
			success : function(data) {
				if (data.broker_ip_result
						&& Array.isArray(data.broker_ip_result)) {

					var selectElement = $("#broker_name");
					// Clear any existing options
					//	selectElement.empty();
					// Loop through the data and add options to the select element
					data.broker_ip_result.forEach(function(filename) {
						var option = $("<option>", {
							value : filename,
							text : filename,
						});
						selectElement.append(option);
					});

				}
			},
			error : function(xhr, status, error) {
				console.log("Error showing broker ip list : " + error);
			},
		});
	}

	// Function to load user data and populate the user list table
	function loadJsonBuilderList() {
		$
				.ajax({
					url : 'jsonBuilderServlet',
					type : 'GET',
					dataType : 'json',
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
						
						// Clear existing table rows
						var jsonBuilderTable = $('#jsonBuilderListTable tbody');
						jsonBuilderTable.empty();

						// Iterate through the user data and add rows to the table
					
						if(roleValue == 'Admin' || roleValue == 'ADMIN'){
							
						data.result.forEach(function(jsonBuilder) {
 						var json_string_name = jsonBuilder.json_string_name; 
						var json_interval = jsonBuilder.json_interval; 
						var broker_type = jsonBuilder.broker_type; 
						var broker_ip_address = jsonBuilder.broker_ip_address; 
						var publish_topic_name = jsonBuilder.publish_topic_name; 
						var publishing_status = jsonBuilder.publishing_status; 
						var store_n_forward = jsonBuilder.store_n_forward; 
						
						var row = $("<tr>").append($("<td>").text(json_string_name),
								$("<td>").text(json_interval),
								$("<td>").text(broker_type),
								$("<td>").text(broker_ip_address),
								$("<td>").text(publish_topic_name),
								$("<td>").text(publishing_status),
								$("<td>").text(store_n_forward));
						
						var actions = $('<td>');
						var editButton = $(
								'<button data-toggle="tooltip" class="editBtn" data-placement="top" title="Edit"style="color: #35449a;">')
								.html('<i class="fas fa-edit"></i>')
								.click(
										function() {
											setJsonBuilder(jsonBuilder.json_string_name);
											setJSONInterval(jsonBuilder.json_interval);
											setBrokerType(jsonBuilder.broker_type);
											setBrokerIPAddress(jsonBuilder.broker_ip_address);
											setPublishTopic(jsonBuilder.publish_topic_name);
											setPublishingStatus(jsonBuilder.publishing_status);
											setStoreAndForward(jsonBuilder.store_n_forward);
											setJSONString(jsonBuilder.json_string);
										});

						var deleteButton = $(
								'<button data-toggle="tooltip" class="delBtn" data-placement="top" title="Delete"style="color: red;">')
								.html('<i class="fas fa-trash-alt"></i>')
								.click(
										function() {
											deleteJsonBuilder(jsonBuilder.json_string_name);
										}); 

						 actions.append(editButton);
						actions.append(deleteButton);

						row.append(actions); 

						jsonBuilderTable.append(row);
 						
 					});
 
 
						}else if(roleValue == 'OPERATOR' || roleValue == 'Operator'){
							
						data.result.forEach(function(jsonBuilder) {
							var json_string_name = jsonBuilder.json_string_name; 
							var json_interval = jsonBuilder.json_interval; 
							var broker_type = jsonBuilder.broker_type; 
							var broker_ip_address = jsonBuilder.broker_ip_address; 
							var publish_topic_name = jsonBuilder.publish_topic_name; 
							var publishing_status = jsonBuilder.publishing_status; 
							var store_n_forward = jsonBuilder.store_n_forward; 
							
							var row = $("<tr>").append($("<td>").text(json_string_name),
									$("<td>").text(json_interval),
									$("<td>").text(broker_type),
									$("<td>").text(broker_ip_address),
									$("<td>").text(publish_topic_name),
									$("<td>").text(publishing_status),
									$("<td>").text(store_n_forward));
							
							jsonBuilderTable.append(row);
							
						});
						}	
						// Initialize tooltips using Bootstrap
			            $('[data-toggle="tooltip"]').tooltip();
					},
					error : function(xhr, status, error) {
						console.log('Error loading jsonBuilderTable data: '
								+ error);
					}
				});
	}

	function setJsonBuilder(jsonBuilderId) {
		// Make an AJAX GET request to retrieve user details for editing

		$('#json_string_name').val(jsonBuilderId);
		$("#json_string_name").prop("disabled", true);

		$('#registerBtn').val('Update');

	}

	function setJSONInterval(jsonBuilderId) {

		$('#json_interval').val(jsonBuilderId);
	}

	function setBrokerType(jsonBuilderId) {

		$('#broker_type').val(jsonBuilderId);
	}

	function setBrokerIPAddress(jsonBuilderId) {

		$('#broker_name').val(jsonBuilderId);
	}

	function setPublishTopic(jsonBuilderId) {

		$('#publish_topic').val(jsonBuilderId);
	}

	function setPublishingStatus(jsonBuilderId) {

		$('#publishing_status').val(jsonBuilderId);
	}

	function setStoreAndForward(jsonBuilderId) {

		$('#storeAndForward').val(jsonBuilderId);
	}

	function setJSONString(jsonBuilderId) {

		$('#json_string_text').val(jsonBuilderId);
	}
 
 function deleteJsonBuilder(jsonBuilderId) {
	 // Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-delete');
	  modal.style.display = 'block';

	  // Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-delete');
	  confirmButton.onclick = function () {
		  $.ajax({
				url : 'jsonBuilderServlet',
				type : 'POST',
				data : {
					json_string_name : jsonBuilderId,
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
					 // Close the modal
			        modal.style.display = 'none';

					// Refresh the user list
					loadJsonBuilderList();
				},
				error : function(xhr, status, error) {
					// Handle the error response, if needed
					console.log('Error deleting json builder settings: '
							+ error);
				}
			});  
	  };
	  
	// Handle the cancel button click
	  var cancelButton = document.getElementById('cancel-button-delete');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	  };
 }
	
	
	function editJsonBuilder() {
		// Display the custom modal dialog
		  var modal = document.getElementById('custom-modal-edit');
		  modal.style.display = 'block';
		  
		// Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-edit');
		  confirmButton.onclick = function () {
			  
			  var json_string_name = $('#json_string_name').val();
				var json_interval = $('#json_interval').find(":selected").val();
				var broker_type = $('#broker_type').find(":selected").val();
				var broker_name = $('#broker_name').find(":selected").val();
				var publish_topic = $('#publish_topic').val();
				var publishing_status = $('#publishing_status').find(":selected").val();
				var storeAndForward = $('#storeAndForward').find(":selected").val();
				 json_string_text = $('#json_string_validate').val();
				 
				 $
					.ajax({
						url : 'jsonBuilderServlet',
						type : 'POST',
						data : {
							json_string_name : json_string_name,
							json_interval : json_interval,
							broker_type : broker_type,
							broker_name : broker_name,
							publish_topic : publish_topic,
							publishing_status : publishing_status,
							storeAndForward : storeAndForward,
							json_string_text : json_string_text,
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
							
							loadJsonBuilderList();

							// Clear form fields

							$('#json_string_name').val('');
							$('#json_interval').val('Select interval');
							$('#broker_type').val('Select broker type');
							$('#broker_name').val('Select broker IP address');
							$('#publish_topic').val('');
							$('#publishing_status').val('Enable');
							$('#storeAndForward').val('Enter store and forward');
							$('#json_string_text')
									.val('{"unit_id":"UNIT1","asset_id":"ASSET1","TAG1":"var1","TAG2":"var2"}');
							$('#json_string_validate').val('');
							

							$("#json_string_name").prop("disabled", false);
						},
						error : function(xhr, status, error) {
							console.log('Error updating json builder settings: '
									+ error);
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
	

	// Function to handle form submission and add a new user
	function addJsonBuilder() {

		var json_string_name = $('#json_string_name').val();
		var json_interval = $('#json_interval').find(":selected").val();
		var broker_type = $('#broker_type').find(":selected").val();
		var broker_name = $('#broker_name').find(":selected").val();
		var publish_topic = $('#publish_topic').val();
		var publishing_status = $('#publishing_status').find(":selected").val();
		var storeAndForward = $('#storeAndForward').find(":selected").val();
		 json_string_text = $('#json_string_validate').val();

		$.ajax({
					url : 'jsonBuilderServlet',
					type : 'POST',
					data : {
						json_string_name : json_string_name,
						json_interval : json_interval,
						broker_type : broker_type,
						broker_name : broker_name,
						publish_topic : publish_topic,
						publishing_status : publishing_status,
						storeAndForward : storeAndForward,
						json_string_text : json_string_text,
						action: 'add'
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
						
						
						// Display the custom popup message
     			$("#popupMessage").text(data.message);
      			$("#customPopup").show();

      			
						loadJsonBuilderList();

						// Clear form fields

						$('#json_string_name').val('');
						$('#json_interval').val('Select interval');
						$('#broker_type').val('Select broker type');
						$('#broker_name').val('Select broker IP address');
						$('#publish_topic').val('');
						$('#publishing_status').val('Enable');
						$('#storeAndForward').val('Select store and forward');
						$('#json_string_text')
								.val(
										'{"unit_id":"UNIT1","asset_id":"ASSET1","TAG1":"var1","TAG2":"var2"}');
						$('#json_string_validate').val('');
					},
					error : function(xhr, status, error) {
						console.log('Error adding json builder: ' + error);
					}
				});
		
		$("#closePopup").click(function () {
		    $("#customPopup").hide();
		  });

		$('#registerBtn').val('Add');
	}

	function validateJSON() {
		
		const json_string = document.querySelector('textarea').value;
		  if(json_string ===''){
			
			// Display the custom popup message
   			$("#popupMessage").text("Please fill the JsonSring");
    			$("#customPopup").show();
    			
    			$("#closePopup").click(function () {
    			    $("#customPopup").hide();
    			  });

		  }
		  var res_val = isValidJsonString(json_string);
		  var res_dup = isJsonStringDuplicate(json_string);
		  var res_emp = isJsonStringEmpty(json_string);
		 
		  if(res_val == true &&  res_dup == false && res_emp == false){
			  json_string_text = json_string; // Assign the value here
			 
	            try {
	                const formattedJson = JSON.stringify(JSON.parse(json_string), null, 2);
	                $('#json_string_validate').val(formattedJson);
	            } catch (error) {
	                // Handle JSON parsing error
	                $("#popupMessage").text("JSON parsing error: " + error);
	                $("#customPopup").show();
	            }
			  
		  }else{
			
			  
			  // Display the custom popup message
     			$("#popupMessage").text('Check if the JSON is valid and ensure that duplicate keys are not present !!');
      			$("#customPopup").show();
      			
      			$("#closePopup").click(function () {
      			    $("#customPopup").hide();
      			  });

		  }
	}
	
	function isJsonStringEmpty(jsonString) {
	    console.log("Input JSON string:", jsonString);
	    
	    // Parse the JSON string into an object
	    const jsonObject = JSON.parse(jsonString);
	    
	    // Check if the parsed object is empty
	    if (Object.keys(jsonObject).length === 0) {
	       
	        return true; // JSON is empty
	    } else {
	        
	        return false; // JSON is not empty
	    }
	}

	function isValidJsonString(jsonString) {
	    try {
	        JSON.parse(jsonString);
	        return true; // JSON is valid
	    } catch (e) {
	        return false; // JSON is not valid
	    }
	} 

	
	function isJsonStringDuplicate(jsonString) {
		
		    let keys = new Set();
		    let inString = false;

		    for (var i = 0; i < jsonString.length; i++) {
		        const char = jsonString.charAt(i);

		        if (char === '"') {
		            // Toggle the inString flag when encountering double quotes
		            inString = !inString;
		        } else if (!inString && char === ':') {
		            // When not in a string and encountering a colon, check for duplicate key
		            const keyStart = jsonString.lastIndexOf('"', i - 2); // Find the start of the key
		            const key = jsonString.substring(keyStart + 1, i).trim();

		            if (keys.has(key)) {
		                return true; // Duplicate key found
		            }
		            keys.add(key);
		        }
		    }

		    return false; // No duplicate keys found
		}

	function validateSoreAndForward(storeAndForward) {
		var storeAndForwardError = document
				.getElementById("storeAndForwardError");

		if (storeAndForward == 'Select store and forward') {

			storeAndForwardError.textContent = "Please select store and forward";
			return false;
		} else {
			storeAndForwardError.textContent = "";
			return true;
		}
	}
	
	function validatePublishingStatus(publishingStatus) {
		var publishingStatusError = document.getElementById("publishingStatusError");

		if (publishingStatus == 'Select publishing status') {

			publishingStatusError.textContent = "Please select publishing status";
			return false;
		} else {
			publishingStatusError.textContent = "";
			return true;
		}
	}

	function validateJSONInterval(jsonInterval) {
		var jsonIntervalError = document.getElementById("jsonIntervalError");

		if (jsonInterval == 'Select interval') {

			jsonIntervalError.textContent = "Please select interval";
			return false;
		} else {
			jsonIntervalError.textContent = "";
			return true;
		}
	}

	function validateBrokerType(broker_type) {
		var brokerTypeError = document.getElementById("brokerTypeError");

		if (broker_type == 'Select broker type') {

			brokerTypeError.textContent = "Please select broker type";
			return false;
		} else {
			brokerTypeError.textContent = "";
			return true;
		}
	}

	function validateBrokerIPAddress(broker_name) {
		var brokerIPAddressError = document
				.getElementById("brokerIPAddressError");

		if (broker_name == 'Select broker IP address') {

			brokerIPAddressError.textContent = "Please select broker ip address";
			return false;
		} else {
			brokerIPAddressError.textContent = "";
			return true;
		}
	}

	function changeButtonColor(isDisabled) {
        var $add_button = $('#registerBtn');       
        var $clear_button = $('#clearBtn');
        var $validate_button = $('#validateBtn');
        
        
        
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
            $validate_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $validate_button.css('background-color', '#2b3991'); // Reset to original color
        } 
        
    }
	
	// Function to execute on page load
	$(document).ready(function() {
			
						<%// Access the session variable
			HttpSession role = request.getSession();
			String roleValue = (String) session.getAttribute("role");%>
			    	
			    	roleValue = '<%=roleValue%>';
			    	
						if (roleValue == 'OPERATOR' || roleValue == 'Operator') {

							$("#actions").hide();
							$('#registerBtn').prop('disabled', true);
							$('#clearBtn').prop('disabled', true);
							$('#validateBtn').prop('disabled', true);
							
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

								// Load user list
								loadBrokerIPList();
								loadJsonBuilderList();
								
								$('#validateBtn').click(function() {
									validateJSON();

								});

								//console.log(is_json({name: 'Robert'}));
								// Handle form submission
								$('#jsonBuilderForm').submit(function(event) {
													event.preventDefault();
													var buttonText = $('#registerBtn').val();

													var publishingStatus = $('#publishing_status').find(":selected").val();
													var storeAndForward = $('#storeAndForward').find(":selected").val();
													var json_interval = $('#json_interval').find(":selected").val();
													var broker_type = $('#broker_type').find(":selected").val();
													var broker_name = $('#broker_name').find(":selected").val();
													var json_string_name = $("#json_string_name").val();
													var publish_topic = $("#publish_topic").val();

													if (!validatePublishingStatus(publishingStatus)) {
														publishingStatusError.textContent = "Please select publishing status";
														return;
													}

													if (!validateSoreAndForward(storeAndForward)) {
														storeAndForwardError.textContent = "Please select store and forward";
														return;
													}

													if (!validateJSONInterval(json_interval)) {
														jsonIntervalError.textContent = "Please select interval";
														return;
													}

													if (!validateBrokerType(broker_type)) {
														brokerTypeError.textContent = "Please select broker type";
														return;
													}

													if (!validateBrokerIPAddress(broker_name)) {
														brokerIPAddressError.textContent = "Please select broker ip address ";
														return;
													}

													if (publish_topic.length > 30) {
														publish_topic_error.textContent = "You can write upto 30 maximum characters.";
													} else {
														publish_topic_error.textContent = "";
													}

													if (json_string_name.length > 30) {
														json_string_name_error.textContent = "You can write upto 30 maximum characters.";
													} else {
														json_string_name_error.textContent = "";
													}

													if (json_string_text) {
														if (buttonText == 'Add') {
															addJsonBuilder();
														} else {
															editJsonBuilder();
														}
													} else {
													
										     			$("#popupMessage").text('First validate json!');
										      			$("#customPopup").show();
										      			
										      			$("#closePopup").click(function () {
										      			    $("#customPopup").hide();
										      			  });
													}

												});

								$('#clearBtn').click(function() {
													$('#json_string_name').val('');
													$("#json_string_name").prop("disabled", false);
													$('#json_interval').val('Select interval');
													$('#broker_type').val('Select broker type');
													$('#broker_name').val('Select broker IP address');
													$('#publish_topic').val('');
													$('#publishing_status').val('Enable');
													$('#storeAndForward').val('Select store and forward');
													$('#json_string_text').val('{"unit_id":"UNIT1","asset_id":"ASSET1","TAG1":"var1","TAG2":"var2"}');
													$('#json_string_validate').val('');
													$('#registerBtn').val('Add');
												});
																
					    }		
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
		<h3>ADD JSON STRING</h3>
		<hr>

		<div class="container">
			<form id="jsonBuilderForm">
				<input type="hidden" id="action" name="action" value="">
				
				<table class="bordered-table" style="margin-top: -1px;">
				
				<tr>
				<td>JSON string name</td>
				<td><input type="text" id="json_string_name" name="json_string_name" required style="height: 17px;" maxlength="31" />
						<p id="json_string_name_error" style="color: red;"></p></td>
				<td>Interval</td>
				<td><select class="json-interval-select" id="json_interval"
							name="json_interval" style="height: 35px;" required>
							<option value="Select interval">Select interval</option>
							<option value="30 sec">30 sec</option>
							<option value="1 min">1 min</option>
							<option value="5 min">5 min</option>
							<option value="10 min">10 min</option>
							<option value="15 min">15 min</option>
							<option value="20 min">20 min</option>
							<option value="25 min">25 min</option>
							<option value="30 min">30 min</option>
							<option value="1 hour">1 hour</option>

						</select> <span id="jsonIntervalError" style="color: red;"></span></td>
				
				<td>Broker type</td>
				<td><select class="textBox" id="broker_type" name="broker_type"
							style="height: 35px;" required>
							<option value="Select broker type">Select broker type</option>
							<option value="mqtt">mqtt</option>
							<option value="iothub">iothub</option>
						</select> <span id="brokerTypeError" style="color: red;"></span></td>
				<td>Broker IP address</td>
				<td><select class="textBox" id="broker_name" name="broker_name"
							style="height: 35px;" required>
							<option value="Select Broker IP address">Select broker
								IP address</option>
						</select> <span id="brokerIPAddressError" style="color: red;"></span></td>
				</tr>
				
					<tr>
					<td>Publish topic</td>
					<td><input type="text" id="publish_topic" name="publish_topic" style="height: 17px;" maxlength="31">
						<p id="publish_topic_error" style="color: red;"></p></td>
					<td>Publishing status</td>
					<td><select class="textBox" id="publishing_status"
							name="publishing_status" style="height: 35px;" required>
							<option value="Select publishing status">Select publishing status</option>
							<option value="Enable" selected>Enable</option>
							<option value="Disable">Disable</option>
						</select> <span id="publishingStatusError" style="color: red;"></span></td>
					
				<td>Store and forward</td>
				<td><select class="textBox" id="storeAndForward"
							name="storeAndForward" style="height: 35px;" required>
							<option value="Select store and forward">Select store and forward</option>
							<option value="Enable">Enable</option>
							<option value="Disable">Disable</option>
						</select> <span id="storeAndForwardError" style="color: red;"></span></td>
						<td></td>
						<td></td>
				</tr>
							
				<tr>
				<td>JSON String</td>
				<td colspan="7">
					<textarea id="json_string_text" name="json_string_text" rows="10"
							cols="100" required>{"unit_id":"UNIT1","asset_id":"ASSET1","TAG1":"var1","TAG2":"var2"}</textarea></td>
				</tr>
		
				<tr>
				
				<td colspan="8"  style="text-align: center;"><input style="margin-top: 1%;" type="button" value="Validate"
						id="validateBtn" /></td>			
				</tr>
				
				<tr>
				<td>JSON string validate</td>
				<td colspan="7"><textarea id="json_string_validate" name="json_string_validate"
							rows="10" cols="100" placeholder="Validate String" disabled></textarea>
				</td>
				</tr>
				
				</table>
				
				<div class="row" style="display: flex; justify-content: center; margin-top: 2%;">
					<input type="button" value="Clear" id="clearBtn" />
					 <input style="margin-left: 5px;" type="submit" value="Add" id="registerBtn" />
				</div>
			</form>
		</div>
		
		<div id="custom-modal-delete" class="modal-delete">
				<div class="modal-content-delete">
				  <p>Are you sure you want to delete this json string?</p>
				  <button id="confirm-button-delete">Yes</button>
				  <button id="cancel-button-delete">No</button>
				</div>
			  </div>
			  
			  <div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to modify this json string?</p>
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

		<h3 style="margin-top: 15px;">JSON STRING LIST</h3>
		<hr>
		<div class="table-container">
			<table id="jsonBuilderListTable">
				<thead>
					<tr>
						<th>JSON string name</th>
						<th>JSON interval</th>
						<th>Broker type</th>
						<th>Broker IP address</th>
						<th>Publish topic name</th>
						<th>Publishing status</th>
						<th>Store and forward</th>
						
						<th id="actions">Actions</th>
					</tr>
				</thead>
				<tbody>
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