<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>JSON Builder</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
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
					selectElement.empty();

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
				console.log("Error showing broker ip : " + error);
			},
		});
	}

	// Function to load user data and populate the user list table
	function loadJsonBuilderList() {
		$
				.ajax({
					url : 'jsonBuilderEditServlet',
					type : 'GET',
					dataType : 'json',
					success : function(data) {
						// Clear existing table rows
						var jsonBuilderTable = $('#jsonBuilderListTable tbody');
						jsonBuilderTable.empty();

						// Iterate through the user data and add rows to the table
						$
								.each(
										data,
										function(index, jsonBuilder) {
											var row = $('<tr>');
											row
													.append($('<td>')
															.text(
																	jsonBuilder.json_string_name));
											row.append($('<td>').text(
													jsonBuilder.json_interval));
											row.append($('<td>').text(
													jsonBuilder.broker_type));
											row
													.append($('<td>')
															.text(
																	jsonBuilder.broker_ip_address));
											row
													.append($('<td>')
															.text(
																	jsonBuilder.publish_topic_name));
											row
													.append($('<td>')
															.text(
																	jsonBuilder.publishing_status));
											/* row.append($('<td>').text(jsonBuilder.store_n_forward)); */
											row.append($('<td>').text(
													jsonBuilder.json_string));

											var actions = $('<td>');
											var editButton = $(
													'<button style="background-color: #35449a; border: none; border-radius: 5px; margin-left: 5px; color: white">')
													.text('Edit')
													.click(
															function() {
																setJsonBuilder(jsonBuilder.json_string_name);

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
					},
					error : function(xhr, status, error) {
						console.log('Error loading jsonBuilderTable data: '
								+ error);
					}
				});
	}

	function setJsonBuilder(jsonBuilderId) {
		// Make an AJAX GET request to retrieve user details for editing

		$('#jsonStringName').val(jsonBuilderId);

		$('#registerBtn').val('Edit');

	}

	// Function to handle deleting a user
	function deleteJsonBuilder(jsonBuilderId) {
		// Perform necessary actions to delete the user
		// For example, make an AJAX call to a delete servlet

		alert(jsonBuilderId)
		var confirmation = confirm('Are you sure you want to delete this json builder settings?');
		if (confirmation) {
			$.ajax({
				url : 'jsonBuilderDeleteServlet',
				type : 'POST',
				data : {
					jsonStringName : jsonBuilderId
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
		var jsonInterval = $('#jsonInterval').find(":selected").val();
		var broker_type = $('#broker_type').find(":selected").val();
		var broker_name = $('#broker_name').find(":selected").val();
		var publishTopic = $('#publishTopic').val();
		var publishing_status = $('#publishing_status').find(":selected").val();
		var storeAndForward = $('#storeAndForward').find(":selected").val();
		var json_string_text = $('#json_string_text').val();

		$.ajax({
			url : 'jsonBuilderEditServlet',
			type : 'POST',
			data : {
				json_string_name : json_string_name,
				jsonInterval : jsonInterval,
				broker_type : broker_type,
				broker_name : broker_name,
				publishTopic : publishTopic,
				publishing_status : publishing_status,
				storeAndForward : storeAndForward,
				json_string_text : json_string_text
			},
			success : function(data) {
				// Display the registration status message
				alert(data.message);
				loadJsonBuilderList();

				// Clear form fields

				$('#jsonStringName').val('');
				$('#jsonInterval').val('');
				$('#broker_type').val('');
				$('#broker_name').val('');
				$('#publishTopic').val('');
				$('#publishing_status').val('');
				$('#storeAndForward').val('');
				$('#json_string_text').val('');
			},
			error : function(xhr, status, error) {
				console.log('Error adding json builder settings: ' + error);
			}
		});

		$('#registerBtn').val('Add');
	}

	// Function to handle form submission and add a new user
	function addJsonBuilder() {

		var json_string_name = $('#json_string_name').val();
		var jsonInterval = $('#jsonInterval').find(":selected").val();
		var broker_type = $('#broker_type').find(":selected").val();
		var broker_name = $('#broker_name').find(":selected").val();
		var publishTopic = $('#publishTopic').val();
		var publishing_status = $('#publishing_status').find(":selected").val();
		var storeAndForward = $('#storeAndForward').find(":selected").val();
		var json_string_text = $('#json_string_text').val();

		$.ajax({
			url : 'jsonBuilderData',
			type : 'POST',
			data : {
				jsonStringName : jsonStringName,
				jsonInterval : jsonInterval,
				broker_type : broker_type,
				broker_name : broker_name,
				publishTopic : publishTopic,
				publishing_status : publishing_status,
				storeAndForward : storeAndForward,
				json_string_text : json_string_text
			},
			success : function(data) {
				// Display the registration status message
				alert(data.message);
				loadJsonBuilderList();

				// Clear form fields

				$('#jsonStringName').val('');
				$('#jsonInterval').val('');
				$('#broker_type').val('');
				$('#broker_name').val('');
				$('#publishTopic').val('');
				$('#publishing_status').val('');
				$('#storeAndForward').val('');
				$('#json_string_text').val('');
			},
			error : function(xhr, status, error) {
				console.log('Error adding json builder: ' + error);
			}
		});

		$('#registerBtn').val('Add');
	}

	// Function to execute on page load
	$(document).ready(function() {
		// Load user list
		loadBrokerIPList();
		loadJsonBuilderList();
		// Handle form submission
		$('#jsonBuilderForm').submit(function(event) {
			event.preventDefault();
			var buttonText = $('#registerBtn').val();

			if (buttonText == 'Add') {
				addJsonBuilder();
			} else {
				editJsonBuilder();
			}
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
		<h3>JSON Builder Settings</h3>
		<hr>

		<div class="container">
			<form id="jsonBuilderForm">
				<div class="row">
					<!-- <div class="col-25">
						<label for="jsonStringName">JSON String Name</label>
					</div> -->
					<div class="col-75-1" style="width: 170px; margin-top: -20px; font-size: 15px">
						<input type="text" id="jsonStringName" name="jsonStringName"
							placeholder="JSON String Name" required style="height: 17px;" />

					</div>
				</div>
				<div class="row">
					<!-- <div class="col-25">
						<label for="jsonInterval">JSON Interval</label>
					</div> -->
					<!-- <div class="col-75">
						<input type="text" id="jsonInterval" name="jsonInterval" placeholder="JSON Interval"
						required>
					</div> -->

					<div class="col-75-2" style="width: 165px; margin-top: -35px; margin-left: 180px;">
						<select class="json-interval-select" id="jsonInterval" name="jsonInterval" style="height: 35px;font-size: 15px">
							<option value="">Select JSON Interval</option>
							<option value="30sec">30 sec</option>
							<option value="1min">1 min</option>
							<option value="5min">5 min</option>
							<option value="10min">10 min</option>
							<option value="15min">15 min</option>
							<option value="20min">20 min</option>
							<option value="25min">25 min</option>
							<option value="30min">30 min</option>
							<option value="1hour">1 hour</option>

						</select>
					</div>
				</div>

				<div class="row">
					<!-- <div class="col-25">
													<label for="fileType">Broker Type</label>

					</div> -->
					<div class="col-75-3" style="width: 155px; margin-left: 356px; margin-top: -35px">

						<select class="textBox" id="broker_type" name="broker_type" style="height: 35px; font-size: 15px">
						<option value="">Select Broker Type</option>
							<option value="mqtt">mqtt</option>
							<option value="iothub">iothub</option>


						</select>
					</div>
				</div>

				<div class="row">
					<!-- <div class="col-25">
						<label for="broker_name">Broker Name</label>
					</div> -->
					<div class="col-75-4" style="width: 160px; margin-left: 520px; margin-top: -35px">

						<select class="textBox" id="broker_name" name="broker_name" style="height: 35px; font-size: 15px">
							<option value="Select Broker IP">Select Broker IP</option>

						</select>
					</div>
				</div>

				<div class="row">
					<!-- <div class="col-25">
						<label for="publishTopic">Publish Topic</label>
					</div> -->
					<div class="col-75-5" style="width: 160px; margin-left: 690px; margin-top: -35px">
						<input type="text" id="publishTopic" name="publishTopic"
							placeholder="Publish Topic" required style="height: 17px;">
					</div>
				</div>

				<div class="row">
					<!-- <div class="col-25">
						 <label for="pubStatus">Publishing Status</label>
					</div> -->
					<div class="col-75-6" style="width: 178px; margin-left: 860px; margin-top: -35px;">
						<select class="textBox" id="publishing_status"
							name="publishing_status" style="font-size: 15px; height: 35px;">
							<option value="enable">Enter Publishing Status</option>
							<option value="enable">Enable</option>
							<option value="disable">Disable</option>
						</select>
					</div>
				</div>

				<div class="row">
					<!-- <div class="col-25">
						<label for="storeAndForward">Store and Forward</label>
					</div> -->
					<div class="col-75-7" style="width: 191px; margin-top: 10px;">
						<select class="textBox" id="storeAndForward"
							name="storeAndForward" style="font-size: 15px; height: 35px;">
							<option value="Enter Store and Forward">Enter Store and Forward</option>
							<option value="enable">Enable</option>
							<option value="disable">Disable</option>
						</select>
					</div>
				</div>

				<div class="row">
					<!-- <div class="col-25">
													<label for="json_string">Enter JSON String</label>

					</div> -->
					<div class="col-75-8" style="margin-top: 10px; width: 100%">

						<textarea id="json_string_text" name="json_string_text" rows="10"
							cols="100" placeholder="Enter JSON String"></textarea>

					</div>
				</div>

				<div class="row">
					<input style="margin-top: 2%;" type="submit" value="Validate"
						id="validateBtn" />
				</div>

				<div class="row">
					<!-- <div class="col-25">
													<label for="json_string">Enter JSON String</label>

					</div> -->
					<div class="col-75-9" style="margin-top: 10px; width: 100%">

						<textarea id="json_string_validate" name="json_string_validate"
							rows="10" cols="100" placeholder="Validate String"></textarea>

					</div>
				</div>

				<div class="row">
					<input style="margin-top: 2%;" type="submit" value="Add"
						id="registerBtn" />

					<!-- <input style="margin-top: 2%;"
							type="submit" value="Update" id="updateBtn" /> 
							<input
							style="margin-top: 2%; background-color: red" type="submit"
							value="Delete" id="deleteBtn" /> -->
				</div>
			</form>
		</div>

		<h3>JSON Builder Settings</h3>
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
						<!-- <th>Store And Forward</th> -->
						<th>JSON String</th>
						<th>Actions</th>
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