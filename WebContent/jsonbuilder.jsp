<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>

var roleValue;	

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
					success : function(data) {
						// Clear existing table rows
						var jsonBuilderTable = $('#jsonBuilderListTable tbody');
						jsonBuilderTable.empty();

						var json1 = JSON.stringify(data);

						var json = JSON.parse(json1);

						if (json.status == 'fail') {
							var confirmation = confirm(json.msg);
							if (confirmation) {
								window.location.href = 'login.jsp';
							}
						}

						// Iterate through the user data and add rows to the table
					
						if(roleValue == 'Admin' || roleValue == 'ADMIN'){
							
								$.each(data,function(index, jsonBuilder) {
									
										var row = $('<tr>');
										row.append($('<td>').text(jsonBuilder.json_string_name));
										row.append($('<td>').text(jsonBuilder.json_interval));
										row.append($('<td>').text(jsonBuilder.broker_type));
										row.append($('<td>').text(jsonBuilder.broker_ip_address));
										row.append($('<td>').text(jsonBuilder.publish_topic_name));
										row.append($('<td>').text(jsonBuilder.publishing_status));
										row.append($('<td>').text(jsonBuilder.store_n_forward));
										row.append($('<td style="width: 400px; word-break: break-all; white-space: normal; overflow: hidden; text-overflow: ellipsis;">').text(
												jsonBuilder.json_string));

										 var actions = $('<td>');
										var editButton = $(
												'<button style="background-color: #35449a; border: none; border-radius: 5px; margin-left: 5px; color: white">')
												.text('Edit')
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
												'<button style="background-color: red; border: none; border-radius: 5px; margin-left: 5px; color: white; margin-top: 3px;">')
												.text('Delete')
												.click(
														function() {
															deleteJsonBuilder(jsonBuilder.json_string_name);
														}); 

										 actions.append(editButton);
										actions.append(deleteButton);

										row.append(actions); 

										jsonBuilderTable.append(row);
								});
						}else if(roleValue == 'VIEWER' || roleValue == 'Viewer'){
							
							$.each(data,function(index, jsonBuilder) {
								
								var row = $('<tr>');
								row.append($('<td>').text(jsonBuilder.json_string_name));
								row.append($('<td>').text(jsonBuilder.json_interval));
								row.append($('<td>').text(jsonBuilder.broker_type));
								row.append($('<td>').text(jsonBuilder.broker_ip_address));
								row.append($('<td>').text(jsonBuilder.publish_topic_name));
								row.append($('<td>').text(jsonBuilder.publishing_status));
								row.append($('<td>').text(jsonBuilder.store_n_forward));
								row.append($('<td style="width: 400px; word-break: break-all; white-space: normal; overflow: hidden; text-overflow: ellipsis;">').text(
										jsonBuilder.json_string));

								
								jsonBuilderTable.append(row);
						});
						}	
						
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

		$('#registerBtn').val('Edit');

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

	// Function to handle deleting a user
	function deleteJsonBuilder(jsonBuilderId) {
		// Perform necessary actions to delete the user
		// For example, make an AJAX call to a delete servlet

		alert(jsonBuilderId)
		var confirmation = confirm('Are you sure you want to delete this json builder settings?');
		if (confirmation) {
			$.ajax({
				url : 'jsonBuilderServlet',
				type : 'POST',
				data : {
					json_string_name : jsonBuilderId,
					action: 'delete'
				},
				success : function(data) {
					// Display the registration status message
					alert(data.message);

					// Refresh the user list
					loadJsonBuilderList();
				},
				error : function(xhr, status, error) {
					// Handle the error response, if needed
					console.log('Error deleting json builder settings: '
							+ error);
				}
			});
		}
	}

	function editJsonBuilder() {

		var confirmation = confirm('Are you sure you want to edit this json builder settings?');

		var json_string_name = $('#json_string_name').val();
		var json_interval = $('#json_interval').find(":selected").val();
		var broker_type = $('#broker_type').find(":selected").val();
		var broker_name = $('#broker_name').find(":selected").val();
		var publish_topic = $('#publish_topic').val();
		var publishing_status = $('#publishing_status').find(":selected").val();
		var storeAndForward = $('#storeAndForward').find(":selected").val();
		var json_string_text = $('#json_string_text').val();

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
						// Display the registration status message
						alert(data.message);
						loadJsonBuilderList();

						// Clear form fields

						$('#json_string_name').val('');
						$('#json_interval').val('Select JSON Interval');
						$('#broker_type').val('Select Broker Type');
						$('#broker_name').val('Select Broker IP Address');
						$('#publish_topic').val('');
						$('#publishing_status').val('Enable');
						$('#storeAndForward').val('Enter Store and Forward');
						$('#json_string_text')
								.val(
										'{"unit_id":"UNIT1","asset_id":"ASSET1","TAG1":"var1","TAG2":"var2"}');

						$("#json_string_name").prop("disabled", false);
					},
					error : function(xhr, status, error) {
						console.log('Error updating json builder settings: '
								+ error);
					}
				});

		$('#registerBtn').val('Add');
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
		var json_string_text = $('#json_string_text').val();

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
						action: 'add'
					},
					success : function(data) {
						// Display the registration status message
						alert(data.message);
						loadJsonBuilderList();

						// Clear form fields

						$('#json_string_name').val('');
						$('#json_interval').val('Select JSON Interval');
						$('#broker_type').val('Select Broker Type');
						$('#broker_name').val('Select Broker IP Address');
						$('#publish_topic').val('');
						$('#publishing_status').val('Enable');
						$('#storeAndForward').val('Select Store and Forward');
						$('#json_string_text')
								.val(
										'{"unit_id":"UNIT1","asset_id":"ASSET1","TAG1":"var1","TAG2":"var2"}');
						$('#json_string_validate').val('');
					},
					error : function(xhr, status, error) {
						console.log('Error adding json builder: ' + error);
					}
				});

		$('#registerBtn').val('Add');
	}

	function validateJSON() {
		
		const json_string = document.querySelector('textarea').value;
		  console.log(json_string);
		  var res = isJsonString(json_string);
		  
		  if(res == true){
			  $('#json_string_validate').val(json_string)
		  }else{
			  alert('Enter valid JSON!!')
			  $('#json_string_text').val('');
		  }
	}

	function isJsonString(str) {
		try {
			JSON.parse(str);
		} catch (e) {
			return false;
		}
		return true;
	}

	function validateSoreAndForward(storeAndForward) {
		var storeAndForwardError = document
				.getElementById("storeAndForwardError");

		if (storeAndForward == 'Select Store and Forward') {

			storeAndForwardError.textContent = "Please select store and forward";
			return false;
		} else {
			storeAndForwardError.textContent = "";
			return true;
		}
	}

	function validateJSONInterval(jsonInterval) {
		var jsonIntervalError = document.getElementById("jsonIntervalError");

		if (jsonInterval == 'Select JSON Interval') {

			jsonIntervalError.textContent = "Please select json interval";
			return false;
		} else {
			jsonIntervalError.textContent = "";
			return true;
		}
	}

	function validateBrokerType(broker_type) {
		var brokerTypeError = document.getElementById("brokerTypeError");

		if (broker_type == 'Select Broker Type') {

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

		if (broker_name == 'Select Broker IP Address') {

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

						// Load user list
						loadBrokerIPList();
						loadJsonBuilderList();

						if (roleValue == 'VIEWER' || roleValue == 'Viewer') {

							var confirmation = confirm('You do not have enough privileges for role VIEWER');
							
							 $("#actions").hide();
							$('#registerBtn').prop('disabled', true);
							$('#clearBtn').prop('disabled', true);

							changeButtonColor(true);
						}

						$('#validateBtn').click(function() {
							validateJSON();

						});

						//console.log(is_json({name: 'Robert'}));
						// Handle form submission
						$('#jsonBuilderForm')
								.submit(
										function(event) {
											event.preventDefault();
											var buttonText = $('#registerBtn')
													.val();

											var storeAndForward = $(
													'#storeAndForward').find(
													":selected").val();
											var json_interval = $(
													'#json_interval').find(
													":selected").val();
											var broker_type = $('#broker_type')
													.find(":selected").val();
											var broker_name = $('#broker_name')
													.find(":selected").val();

											if (!validateSoreAndForward(storeAndForward)) {
												storeAndForwardError.textContent = "Please select store and forward";
												return;
											}

											if (!validateJSONInterval(json_interval)) {
												jsonIntervalError.textContent = "Please select json interval";
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

											if (buttonText == 'Add') {
												addJsonBuilder();
											} else {
												editJsonBuilder();
											}
										});

						$('#clearBtn')
								.click(
										function() {
											$('#json_string_name').val('');
											$('#json_interval').val(
													'Select JSON Interval');
											$('#broker_type').val(
													'Select Broker Type');
											$('#broker_name').val(
													'Select Broker IP Address');
											$('#publish_topic').val('');
											$('#publishing_status').val(
													'Enable');
											$('#storeAndForward').val(
													'Select Store and Forward');
											$('#json_string_text')
													.val(
															'{"unit_id":"UNIT1","asset_id":"ASSET1","TAG1":"var1","TAG2":"var2"}');
											$('#json_string_validate').val('');

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
		<h3>JSON BUILDER SETTINGS</h3>
		<hr>

		<div class="container">
			<form id="jsonBuilderForm">
			 <input type="hidden" id="action" name="action" value="">
				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: -20px;">
					<div class="col-75-1" style="width: 20%;">
						<input type="text" id="json_string_name" name="json_string_name"
							placeholder="JSON String Name" required style="height: 17px;" />

					</div>

					<div class="col-75-2" style="width: 20%;">
						<select class="json-interval-select" id="json_interval"
							name="json_interval" style="height: 35px;" required>
							<option value="Select JSON Interval">Select JSON
								Interval</option>
							<option value="30 sec">30 sec</option>
							<option value="1 min">1 min</option>
							<option value="5 min">5 min</option>
							<option value="10 min">10 min</option>
							<option value="15 min">15 min</option>
							<option value="20 min">20 min</option>
							<option value="25 min">25 min</option>
							<option value="30 min">30 min</option>
							<option value="1 hour">1 hour</option>

						</select> <span id="jsonIntervalError" style="color: red;"></span>
					</div>

					<div class="col-75-3" style="width: 20%;">
						<select class="textBox" id="broker_type" name="broker_type"
							style="height: 35px;" required>
							<option value="Select Broker Type">Select Broker Type</option>
							<option value="mqtt">mqtt</option>
							<option value="iothub">iothub</option>
						</select> <span id="brokerTypeError" style="color: red;"></span>
					</div>

					<div class="col-75-4" style="width: 20%;">
						<select class="textBox" id="broker_name" name="broker_name"
							style="height: 35px;" required>
							<option value="Select Broker IP Address">Select Broker
								IP Address</option>
						</select> <span id="brokerIPAddressError" style="color: red;"></span>
					</div>

					<div class="col-75-5" style="width: 20%;">
						<input type="text" id="publish_topic" name="publish_topic"
							placeholder="Publish Topic" required style="height: 17px;">
					</div>
				</div>

				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: 10px;">

					<div class="col-75-6" style="width: 20%;">
						<select class="textBox" id="publishing_status"
							name="publishing_status" style="height: 35px;" required>
							<option value="Enable" selected>Enable</option>
							<option value="Disable">Disable</option>
						</select>
					</div>

					<div class="col-75-7" style="width: 20%;">
						<select class="textBox" id="storeAndForward"
							name="storeAndForward" style="height: 35px;" required>
							<option value="Select Store and Forward">Select Store
								and Forward</option>
							<option value="enable">Enable</option>
							<option value="disable">Disable</option>
						</select> <span id="storeAndForwardError" style="color: red;"></span>
					</div>

				</div>

				<div class="row">

					<div class="col-75-8" style="margin-top: 10px; width: 100%">

						<textarea id="json_string_text" name="json_string_text" rows="10"
							cols="100" required>{"unit_id":"UNIT1","asset_id":"ASSET1","TAG1":"var1","TAG2":"var2"}</textarea>

					</div>
				</div>


				<div class="row">
					<input style="margin-top: 1%;" type="button" value="Validate"
						id="validateBtn" />
				</div>

				<div class="row">

					<div class="col-75-9" style="margin-top: 10px; width: 100%">

						<textarea id="json_string_validate" name="json_string_validate"
							rows="10" cols="100" placeholder="Validate String" disabled></textarea>

					</div>
				</div>

				<div class="row"
					style="display: flex; justify-content: right; margin-top: 2%;">
					<input type="button" value="Clear" id="clearBtn" /> <input
						style="margin-left: 5px;" type="submit" value="Add"
						id="registerBtn" />
				</div>

			</form>
		</div>

		<h3>JSON BUILDER SETTINGS LIST</h3>
		<hr>
		<div class="container">
			<table id="jsonBuilderListTable">
				<thead>
					<tr>
						<th>JSON String Name</th>
						<th>JSON Interval</th>
						<th>Broker Type</th>
						<th>Broker IP Address</th>
						<th>Publish Topic Name</th>
						<th>Publishing Status</th>
						<th>Store And Forward</th>
						<th>JSON String</th>
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