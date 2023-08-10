<%-- 
<!DOCTYPE html>
<html>
<title>WP500 Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="favicon.png" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	// Function to load user data and populate the user list table

	function loadCrtFilesList() {
		$.ajax({
			url : "mqttAddData",
			type : "GET",
			dataType : "json",
			success : function(data) {
				if (data.crt_files_result
						&& Array.isArray(data.crt_files_result)) {

					var selectElement = $("#crt_file");
					// Clear any existing options
					selectElement.empty();

					// Loop through the data and add options to the select element
					data.crt_files_result.forEach(function(filename) {
						var option = $("<option>", {
							value : filename,
							text : filename,
						});
						selectElement.append(option);
					});

					/* var file_type = $('#file_type').find(":selected").val();
					
					alert("File type is: "+file_type);
					if(file_type == 'SSL' || file_type == 'ssl'){
					      $("#crt_file").prop("disabled", false);
					   } else if(file_type == 'TCP' || file_type == 'tcp'){
					      $("#crt_file").prop("disabled", true);  
					   } */
				}
			},
			error : function(xhr, status, error) {
				console.log("Error showing crt files list : " + error);
			},
		});
	}

	function loadMqttList() {
		$
				.ajax({
					url : 'mqttData',
					type : 'GET',
					dataType : 'json',
					success : function(data) {
						// Clear existing table rows
						var mqttTable = $('#mqttListTable tbody');
						mqttTable.empty();

						// Iterate through the user data and add rows to the table
						$
								.each(
										data,
										function(index, mqtt) {
											var row = $('<tr>');
											row.append($('<td>').text(mqtt.broker_ip_address+ ""));
											row.append($('<td>').text(
													mqtt.port_number + ""));
											row.append($('<td>').text(
													mqtt.username + ""));
											row.append($('<td>').text(
													mqtt.publish_topic + ""));
											row.append($('<td>').text(
													mqtt.subscribe_topic + ""));
											row.append($('<td>').text(
													mqtt.prefix + ""));
											row.append($('<td>').text(
													mqtt.file_type + ""));
											row.append($('<td>').text(
													mqtt.enable + ""));

											var actions = $('<td>');
											var editButton = $(
													'<button style="background-color: #35449a; border: none; border-radius: 5px; margin-left: 5px; color: white">')
													.text('Edit')
													.click(function() {
														setMqtt(mqtt.prefix);
														setBrokerIPAddress(mqtt.broker_ip_address);
														setPortNumber(mqtt.port_number);
														setUsername(mqtt.username);
														 setPassword(mqtt.password); 
														setPublishedTopic(mqtt.publish_topic);
														setSubscribedTopic(mqtt.subscribe_topic);
														setFileType(mqtt.file_type);
														setEnable(mqtt.enable);
														

													});
											var deleteButton = $(
													'<button style="background-color: red; border: none; border-radius: 5px; margin-left: 5px; color: white">')
													.text('Delete')
													.click(
															function() {
																deleteMqtt(mqtt.prefix);
															});
											var getStatusButton = $(
													'<button style="background-color: #35449a; border: none; border-radius: 10px; margin-left: 5px; color: white">')
													.text('Get Status').click(
															function() {
																getMqttStatus(mqtt.broker_ip_address);
															});

											actions.append(editButton);
											actions.append(deleteButton);
											actions.append(getStatusButton);

											row.append(actions);

											mqttTable.append(row);

										});
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
	}

	function setEnable(mqttId) {

		
		$('#enable').val(mqttId);
		alert('enable : '+mqttId)
		
		if(mqttId == true){
			
			document.getElementById("enable").checked = true;
		}
		
	}
	
	function getMqttStatus(mqttId) {
	    // Perform necessary actions to get the MQTT status
	    // For example, make an AJAX call to a servlet

	    alert(mqttId);
	    console.log('broker_ip_address: ' + mqttId);

	    $.ajax({
	        url: 'getMqttStatus',
	        type: 'POST',
	        data: {
	            broker_ip_address: mqttId
	          
	        },
	        dataType: 'json', // Expecting JSON response from the server
	        success: function (data) {
	            // Display the MQTT status message
	            alert(data.message);

	            // Refresh the user list or perform other actions if needed
	        },
	        error: function (xhr, status, error) {
	            // Handle the error response, if needed
	            console.log('Error retrieving MQTT status: ' + error);
	        }
	    });
	}
	

	// Function to handle deleting a user
	function deleteMqtt(mqttId) {
		// Perform necessary actions to delete the user
		// For example, make an AJAX call to a delete servlet

		alert(mqttId)
		var confirmation = confirm('Are you sure you want to delete this mqtt?');
		if (confirmation) {
			$.ajax({
				url : 'mqttDeleteServlet',
				type : 'POST',
				data : {
					prefix : mqttId
				},
				success : function(data) {
					// Display the registration status message
					alert(data.message);

					// Refresh the user list
					loadMqttList();
				},
				error : function(xhr, status, error) {
					// Handle the error response, if needed
					console.log('Error deleting mqtt settings: ' + error);
				}
			});
		}
	}

	function editMqtt() {

		var confirmation = confirm('Are you sure you want to edit this mqtt settings?');

		var broker_ip_address = $('#broker_ip_address').val();
		var port_number = $('#port_number').val();
		var username = $('#username').val();
		var password = $('#password').val();
		var pub_topic = $('#pub_topic').val();
		var sub_topic = $('#sub_topic').val();
		var prefix = $('#prefix').val();
		var file_type = $('#file_type').find(":selected").val();

		if ($('#enable').is(':checked')) {
			var enable = "true";
		} else {
			var enable = "false";
		}

		$.ajax({
			url : 'mqttEditServlet',
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
				enable : enable
			},
			success : function(data) {
				// Display the registration status message
			//	alert(data.message);
				loadMqttList();

				// Clear form fields
				$('#broker_ip_address').val('');
				$('#port_number').val('');
				$('#username').val('');
				$('#password').val('');
				$('#pub_topic').val('');
				$('#sub_topic').val('');
				$('#prefix').val('');
				$('#file_type').val('');
				$('#enable').val('');
				
				$("#prefix").prop("disabled", false);
			},
			error : function(xhr, status, error) {
				console.log('Error adding mqtt: ' + error);
			}
		});

		$('#registerBtn').val('Add');
	}

	// Function to handle form submission and add a new user
	function addMqtt() {

		var broker_ip_address = $('#broker_ip_address').val();
		var port_number = $('#port_number').val();
		var username = $('#username').val();
		var password = $('#password').val();
		var pub_topic = $('#pub_topic').val();
		var sub_topic = $('#sub_topic').val();
		var prefix = $('#prefix').val();

		var file_type = $('#file_type').find(":selected").val();

		if ($('#enable').is(':checked')) {
			var enable = "true";
		} else {
			var enable = "false";
		}

		$.ajax({
			url : 'mqttAddData',
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
				enable : enable
			},
			success : function(data) {
				// Display the registration status message
				alert(data.message);
				loadMqttList();

				// Clear form fields

				$('#broker_ip_address').val('');
				$('#port_number').val('');
				$('#username').val('');
				$('#password').val('');
				$('#pub_topic').val('');
				$('#sub_topic').val('');
				$('#prefix').val('');
				$('#file_type').val('');
				$('#enable').val('');
			},
			error : function(xhr, status, error) {
				console.log('Error adding mqtt settings: ' + error);
			}
		});

		$('#registerBtn').val('Add');
	}

	// Function to execute on page load
	$(document).ready(function() {
		// Load user list

		loadMqttList();
		loadCrtFilesList();

		$("#file_type").change(function(event) {
			//     alert("You have Selected  :: "+$(this).val());

			if ($(this).val() == 'SSL' || $(this).val() == 'ssl') {
				$("#crt_file").prop("disabled", false);
			} else if ($(this).val() == 'TCP' || $(this).val() == 'tcp') {
				$("#crt_file").prop("disabled", true);
			}
		});

		// Handle form submission
		$('#mqttForm').submit(function(event) {
			event.preventDefault();
			var buttonText = $('#registerBtn').val();

			if (buttonText == 'Add') {
				addMqtt();
			} else {
				editMqtt();
			}
		});
		
		$('#clearBtn').click(function(){
			$('#broker_ip_address').val('');
			$('#port_number').val('');
			$('#username').val('');
			$('#password').val('');
			$('#pub_topic').val('');
			$('#sub_topic').val('');
			$('#prefix').val('');
			$('#file_type').val('');
			$('#enable').val('');
  	 
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
			<h3>MQTT Server Settings</h3>
			<hr>

			<div class="container">
				<form id="mqttForm">
					<div class="row">
						<!-- <div class="col-25">
							<label for="broker_ip_address">Broker IP Address</label>
						</div> -->
						<div class="col-75-1" style="width: 20%; margin-top: -20px;">
							<input type="text" id="broker_ip_address"
								name="broker_ip_address" placeholder="Broker IP Address"
								required />

						</div>

					</div>
					<div class="row">
						<!-- <div class="col-25">
							<label for="port_number">Port Number</label>
						</div> -->
						<div class="col-75-2"
							style="width: 20%; margin-top: -35px; margin-left: 20%;">
							<input type="text" id="port_number" name="port_number"
								placeholder="Port Number" required />
						</div>
					</div>

					<div class="row">
						<!-- <div class="col-25">
							<label for="username">Username</label>
						</div> -->
						<div class="col-75-3"
							style="width: 20%; margin-top: -35px; margin-left: 40%;">
							<input type="text" id="username" name="username"
								placeholder="Username" required />

						</div>
					</div>
					<div class="row">
						<!-- <div class="col-25">
							<label for="password">Password</label>
						</div> -->
						<div class="col-75-4"
							style="width: 20%; margin-top: -35px; margin-left: 60%;">
							<input type="password" id="password" name="password"
								placeholder="Password" required />
						</div>
					</div>

					<div class="row">
						<!-- <div class="col-25">
							<label for="pub_topic">Published Topic</label>
						</div> -->
						<div class="col-75-5"
							style="width: 20%; margin-top: -35px; margin-left: 80%;">
							<input type="text" id="pub_topic" name="pub_topic"
								placeholder="Published Topic" required />

						</div>
					</div>
					<div class="row">
						<!-- <div class="col-25">
							<label for="sub_topic">Subscribed Topic</label>
						</div> -->
						<div class="col-75-6" style="width: 20%; margin-top: 10px;">
							<input type="text" id="sub_topic" name="sub_topic"
								placeholder="Subscribed Topic" required />
						</div>
					</div>

					<div class="row">
						<!-- <div class="col-25">
							<label for="prefix">Prefix</label>
						</div> -->
						<div class="col-75-7"
							style="width: 20%; margin-top: -34px; margin-left: 20%">
							<input type="text" id="prefix" name="prefix" placeholder="Prefix"
								required />

						</div>
					</div>


					<div class="row">
						<!-- <div class="col-25">
							<label for="fileType">File Type</label>
						</div> -->
						<div class="col-75-8"
							style="width: 20%; margin-left: 40%; margin-top: -34px;">

							<select class="textBox" id="file_type" name="file_type"
								style="height: 35px;">
								<option value="">Select file type</option>
								<option>SSL</option>
								<option>TCP</option>

							</select>
						</div>
					</div>

					<div class="row">
						<!-- div class="col-25">
								<label for="fileType"> File </label>
							</div> -->
						<div class="col-75-9"
							style="width: 20%; margin-left: 60%; margin-top: -35px;">

							<select class="textBox" id="crt_file" name="crt_file"
								style="height: 35px;">
								<option value="">Select crt file...</option>

							</select>

						</div>
					</div>
					<div class="row">

						<div class="col-25-1" style="margin-left: 70%; margin-top: -35px;">
							<label for="enable">Enable</label>
						</div>
						<div class="col-75-10"
							style="margin-left: 80%; margin-top: -22px;">
							<input type="checkbox" class="enable" id="enable" name="enable">

						</div>
					</div>


					<div class="row">
					<input style="margin-top: 2%; margin-left: 85%;" type="button"
						value="Clear" id="clearBtn" />
				</div>

				<div class="row">
					<input style="margin-top: -1%; margin-left: 95%;" type="submit"
						value="Add" id="registerBtn" />
				</div>

				</form>
			</div>

			<h3>MQTT SERVER LIST</h3>
			<hr>
			<div class="container">
				<table id="mqttListTable">
					<thead>
						<tr>
							<th>Broker IP Address</th>
							<th>Port Number</th>
							<th>Username</th>
							<!-- <th>Password</th> -->
							<th>Published Topic</th>
							<th>Subscribed Topic</th>
							<th>Prefix</th>
							<th>File Type</th>
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
</html> --%>


<!-- ----------------------------------------------------------- -->

<!DOCTYPE html>
<html>
<title>WP500 Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="favicon.png" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	// Function to load user data and populate the user list table

	function loadCrtFilesList() {
		$.ajax({
			url : "mqttAddData",
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

					/* var file_type = $('#file_type').find(":selected").val();
					
					alert("File type is: "+file_type);
					if(file_type == 'SSL' || file_type == 'ssl'){
						  $("#crt_file").prop("disabled", false);
					   } else if(file_type == 'TCP' || file_type == 'tcp'){
						  $("#crt_file").prop("disabled", true);  
					   } */
				}
			},
			error : function(xhr, status, error) {
				console.log("Error showing crt files list : " + error);
			},
		});
	}

	function loadMqttList() {
		$
				.ajax({
					url : 'mqttData',
					type : 'GET',
					dataType : 'json',
					success : function(data) {
						// Clear existing table rows
						var mqttTable = $('#mqttListTable tbody');
						mqttTable.empty();

						// Iterate through the user data and add rows to the table
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
											

											var actions = $('<td>');
											var editButton = $(
													'<button style="background-color: #35449a; border: none; border-radius: 5px; margin-left: 5px; color: white">')
													.text('Edit')
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
													'<button style="background-color: red; border: none; border-radius: 5px; margin-left: 5px; color: white">')
													.text('Delete')
													.click(
															function() {
																deleteMqtt(mqtt.prefix);
															});
											var getStatusButton = $(
													'<button style="background-color: #35449a; border: none; border-radius: 10px; margin-left: 5px; color: white">')
													.text('Get Status')
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
	}

	function setFileName(mqttId) {

		$('#file_name').val(mqttId);
	}

	function setEnable(mqttId) {

		$('#enable').val(mqttId);
		//alert('enable : ' + mqttId)
		

		/* if (mqttId === true) {

			document.getElementById("enable").checked = true;
		} */

	}

	function getMqttStatus(mqttId) {
		// Perform necessary actions to get the MQTT status
		// For example, make an AJAX call to a servlet

		//alert(mqttId);
		//console.log('broker_ip_address: ' + mqttId);

		$.ajax({
			url : 'getMqttStatus',
			type : 'POST',
			data : {
				broker_ip_address : mqttId

			},
			dataType : 'json', // Expecting JSON response from the server
			success : function(data) {
				// Display the MQTT status message
				
				//alert(data.connection_status);
				if(data.connection_status == 'true'){
					alert(mqttId + ' : connected');
					
				}
				else{
					alert(mqttId + ' : disconnected');
				} 
				

				// Refresh the user list or perform other actions if needed
			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error retrieving MQTT status: ' + error);
			}
		});
	}

	// Function to handle deleting a user
	function deleteMqtt(mqttId) {
		// Perform necessary actions to delete the user
		// For example, make an AJAX call to a delete servlet

		alert(mqttId)
		var confirmation = confirm('Are you sure you want to delete this mqtt?');
		if (confirmation) {
			$.ajax({
				url : 'mqttDeleteServlet',
				type : 'POST',
				data : {
					prefix : mqttId
				},
				success : function(data) {
					// Display the registration status message
					alert(data.message);

					// Refresh the user list
					loadMqttList();
				},
				error : function(xhr, status, error) {
					// Handle the error response, if needed
					console.log('Error deleting mqtt settings: ' + error);
				}
			});
		}
	}

	function editMqtt() {

		var confirmation = confirm('Are you sure you want to edit this mqtt settings?');

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
		
		/* if ($('#enable').is(':checked')) {
			var enable = "true";
		} else {
			var enable = "false";
		}
 */
		$.ajax({
			url : 'mqttEditServlet',
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
				file_name : file_name

			},
			success : function(data) {
				// Display the registration status message
				//	alert(data.message);
				loadMqttList();

				// Clear form fields
				$('#broker_ip_address').val('');
				$('#port_number').val('');
				$('#username').val('');
				$('#password').val('');
				$('#pub_topic').val('');
				$('#sub_topic').val('');
				$('#prefix').val('');
				$('#file_type').val('Select file type');
				$('#file_name').val('Select crt file');
				$('#enable').val('Enable');

				$("#prefix").prop("disabled", false);
			},
			error : function(xhr, status, error) {
				console.log('Error updating mqtt: ' + error);
			}
		});

		$('#registerBtn').val('Add');
	}

	// Function to handle form submission and add a new user
	function addMqtt() {

		var broker_ip_address = $('#broker_ip_address').val();
		var port_number = $('#port_number').val();
		var username = $('#username').val();
		var password = $('#password').val();
		var pub_topic = $('#pub_topic').val();
		var sub_topic = $('#sub_topic').val();
		var prefix = $('#prefix').val();
		var file_name = $('#file_name').find(":selected").val();
		var enable = $('#enable').find(":selected").val();
		var file_type = $('#file_type').find(":selected").val();

		/* if ($('#enable').is(':checked')) {
			var enable = "true";
		} else {
			var enable = "false";
		} */

		$.ajax({
			url : 'mqttAddData',
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
				file_name : file_name

			},
			success : function(data) {
				// Display the registration status message
				alert(data.message);
				loadMqttList();

				// Clear form fields

				$('#broker_ip_address').val('');
				$('#port_number').val('');
				$('#username').val('');
				$('#password').val('');
				$('#pub_topic').val('');
				$('#sub_topic').val('');
				$('#prefix').val('');
				$('#file_type').val('Select file type');
				$('#file_name').val('Select crt file');
				$('#enable').val('Enable');

			},
			error : function(xhr, status, error) {
				console.log('Error adding mqtt settings: ' + error);
			}
		});

		$('#registerBtn').val('Add');
	}

	/* function validatePassword(password) {
		var passwordError = document.getElementById("passwordError");

		if (password.length < 8
				|| !/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+/.test(password)) {
			passwordError.textContent = "Password must be at least 8 characters long and contain special characters.";
			return false;
		} else {
			passwordError.textContent = "";
			return true;
		}
	} */

	
	function validateFiletype(type) {
		var fileTypeError = document.getElementById("fileTypeError");

		if (type == 'Select file type'){
			
			fileTypeError.textContent = "Please select file type";
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

	// Function to execute on page load
	$(document)
			.ready(
					function() {
						// Load user list

						loadMqttList();
						loadCrtFilesList();

						$("#file_type").change(
								function(event) {
									//     alert("You have Selected  :: "+$(this).val());

									if ($(this).val() == 'SSL'
											|| $(this).val() == 'ssl') {
										$("#crt_file").prop("disabled", false);
									} else if ($(this).val() == 'TCP'
											|| $(this).val() == 'tcp') {
										$("#crt_file").prop("disabled", true);
									}
								});

						// Handle form submission
						$('#mqttForm')
								.submit(
										function(event) {
											event.preventDefault();
											var buttonText = $('#registerBtn')
													.val();
											var broker_ip_address = $(
													'#broker_ip_address').val();
											var type = $('#file_type').find(":selected").val();
											var port_number = $('#port_number').val();
											var file_name = $('#file_name').find(":selected").val();
											
											
											if (!validateNumbers(port_number)) {
												portNoError.textContent = "Enter port number upto 5 digits";
												return;
											}

											if (!validateFiletype(type)) {
												fileTypeError.textContent = "Please select file type";
												return;
											}
											
											if (!validateCrtFile(file_name)) {
												crtFileError.textContent = "Please select crt file";
												return;
											}
											
											
											/* var password = $('#password').val();
											if (!validatePassword(password)) {
												passwordError.textContent = "Password must be at least 8 characters long and contain special characters.";
												return;
											} */

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
							$('#file_type').val('Select file type');
							$('#file_name').val('Select crt file');
							$('#enable').val('Enable');

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
			<h3>MQTT Server Settings</h3>
			<hr>

			<div class="container">
				<form id="mqttForm">
					<div class="row" style="display:flex; flex-content:space-between; margin-top: -20px;">
						
						<div class="col-75-1"
							style="width: 20%; height: 20%">
							<input type="text" id="broker_ip_address"
								name="broker_ip_address" placeholder="Host Name"
								required />

						</div>

					<!-- </div>
					<div class="row"> -->
						
						<div class="col-75-2"
							style="width: 20%; ">
							<input type="text" id="port_number" name="port_number"
								placeholder="Port Number" required /> <span
								style="color: red; font-size: 12px;" id="portNoError"></span>

						</div>
					<!-- </div>

					<div class="row"> -->
						<!-- <div class="col-25">
							<label for="username">Username</label>
						</div> -->
						<div class="col-75-3"
							style="width: 20%; height: 20%">
							<input type="text" id="username" name="username"
								placeholder="Username" required />

						</div>
					<!-- </div>
					<div class="row"> -->
						
						<div class="col-75-4"
							style="width: 20%; height: 20%">
							<input type="password" id="password" name="password"
								placeholder="Password" required /> 
						</div>


					<!-- </div>

					<div class="row"> -->
						
						<div class="col-75-5"
							style="width: 20%; height: 20%">
							<input type="text" id="pub_topic" name="pub_topic"
								placeholder="Published Topic" required />

						</div>
					</div>
					
					
					<div class="row" style="display:flex; flex-content:space-between; margin-top: 10px;">
						
						<div class="col-75-6" style="width: 20%;">
							<input type="text" id="sub_topic" name="sub_topic"
								placeholder="Subscribed Topic" required />
						</div>
					<!-- </div>

					<div class="row"> -->
						
						<div class="col-75-7"
							style="width: 20%;">
							<input type="text" id="prefix" name="prefix" placeholder="Prefix"
								required />

						</div>
					<!-- </div>

					<div class="row"> -->
						<!-- <div class="col-25">
							<label for="fileType">File Type</label>
						</div> -->
						<div class="col-75-8"
							style="width: 20%;">

							<select class="textBox" id="file_type" name="file_type"
								style="height: 35px;">
								<option value="Select file type">Select file type</option>
								<option>SSL</option>
								<option>TCP</option>

							</select>
							<span id="fileTypeError" style="color:red;"></span>
						</div>
					<!-- </div>

					<div class="row"> -->
							
						<div class="col-75-9"
							style="width: 20%;">

							<select class="textBox" id="file_name" name="file_name"
								style="height: 35px;" required>
								<option value="Select crt file">Select crt file</option>

							</select>
							<span id="crtFileError" style="color:red;"></span>

						</div>
					<!-- </div>
					
					<div class="row"> -->
						
						<div class="col-75-10"
							style="width: 20%;">

							<select class="textBox" id="enable" name="enable"
								style="height: 35px; required">
								
								<option value="enable" selected>Enable</option>
								<option value="disable">Disable</option>

							</select>
						</div>
					</div>

					<!-- <div class="row">

						<div class="col-25-1"
							style="margin-left: 65%; margin-top: -35px;">
							<label for="enable">Enable</label>
						</div>
						<div class="col-75-10"
							style="margin-left: 70%; margin-top: -22px;">
							<input type="checkbox" class="enable" id="enable" name="enable" checked="enable">

						</div>
					</div> -->
					
					


					<div class="row" style="display: flex; justify-content: right; margin-top: 2%;">
						<input type="button"
							value="Clear" id="clearBtn" /> <input
							style="margin-left: 5px;" type="submit"
							value="Add" id="registerBtn" />
					</div>

					<!-- <div class="row">
					<input style="margin-top: -1%; margin-left: 95%;" type="submit"
						value="Add" id="registerBtn" />
				</div> -->

				</form>
			</div>

			<h3>MQTT SERVER LIST</h3>
			<hr>
			<div class="container">
				<table id="mqttListTable">
					<thead>
						<tr>
							<th>Broker IP Address</th>
							<th>Port Number</th>
							<th>Username</th>
							<!-- <th>Password</th> -->
							<th>Published Topic</th>
							<th>Subscribed Topic</th>
							<th>Prefix</th>
							<th>File Type</th>
							<th>File Name</th>
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