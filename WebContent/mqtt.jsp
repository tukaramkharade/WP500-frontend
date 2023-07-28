<%-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>MQTT</title>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
	function loadMqttList() {
		$.ajax({
			url : "mqttData",
			type : "GET",
			dataType : "json",
			success : function(data) {
				// Clear existing table rows

				var mqttTable = $("#mqttListTable tbody");
				mqttTable.empty();

				// Iterate through the user data and add rows to the table
				$.each(data, function(index, mqtt) {
					var row = $("<tr>");
					row.append($("<td>").text(mqtt.publish_topic + ""));
					row.append($("<td>").text(mqtt.password + ""));
					row.append($("<td>").text(mqtt.broker_ip_address + ""));
					row.append($("<td>").text(mqtt.prefix + ""));
					row.append($("<td>").text(mqtt.file_type + ""));
					row.append($("<td>").text(mqtt.enable + ""));
					row.append($("<td>").text(mqtt.port_number + ""));
					row.append($("<td>").text(mqtt.subscribe_topic + ""));
					row.append($("<td>").text(mqtt.username + ""));

					var actions = $('<td>');
					var editButton = $('<button>').text('Edit').click(
							function() {
								settUser(user.firstName);

							});
					var deleteButton = $('<button>').text('Delete').click(
							function() {
								deleteUser(user.firstName);
							});

					actions.append(editButton);
					actions.append(deleteButton);

					row.append(actions);

					mqttTable.append(row);
				});
			},
			error : function(xhr, status, error) {
				console.log("Error loading mqtt data: " + error);
			},
		});
	}
	function addMqttData() {
		var broker_ip_address = $("#broker_ip_address").val();
		var port_number = $("#port_number").val();
		var username = $("#username").val();

		var password = $("#password").val();
		var subscribe_topic = $("#subscribe_topic").val();
		var publish_topic = $("#publish_topic").val();

		var prefix = $("#prefix").val();
		var file_type = $("#file_type").val();
		var enable = $("#enable").val();

		$.ajax({
			url : "mqttAddData",
			type : "POST",
			data : {

				broker_ip_address : broker_ip_address,
				port_number : port_number,
				username : username,
				password : password,
				subscribe_topic : subscribe_topic,
				publish_topic : publish_topic,
				prefix : prefix,
				file_type : file_type,
				enable : enable,

			},
			success : function(data) {
				// Display the ntp status message
				alert(data.message);

				// Clear form fields
				$("#broker_ip_address").val("");
				$("#port_number").val("");
				$("#username").val("");

				$("#password").val("");
				$("#subscribe_topic").val("");
				$("#publish_topic").val("");

				$("#prefix").val("");
				$("#file_type").val("");
				$("#enable").val("");
			},
			error : function(xhr, status, error) {
				console.log("Error adding ntp: " + error);
			},
		});
		$("#addMqttData").val("Add");
	}

	//Function to execute on page load
	$(document).ready(function() {
		// Load user list
		loadMqttList();

		// Handle form submission
		/* $('#userForm').submit(function(event) {
			event.preventDefault();
			var buttonText = $('#registerBtn').val();

			if (buttonText == 'Add') {
				addUser();
			} else {
				editUser();
			}
		}); */

	});
</script>

<style type="text/css">
#broker_label{
margin-left: 50px;
}
</style>
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
			<h3>MQTT</h3><hr>

			<div class="container">
				<form id="mqttForm">
				  <div class="row">
					<div class="col-25">
					  <label for="broker_ip_address">Broker IP Address</label>
					</div>
					<div class="col-75">
					  <input type="text" id="broker_ip_address" name="broker_ip_address" 
					  	placeholder="Broker IP Address" required/>
					  
					</div>
				  </div>
				  
				  <div class="row">
					<div class="col-25">
					  <label for="port_number">Port Number</label>
					</div>
					<div class="col-75">
						<input type="text" id="port_number" name="port_number" placeholder="Port Number" required>
					</div>
				  </div>
				  
				  <div class="row">
					<div class="col-25">
					  <label for="username">User Name</label>
					</div>
					<div class="col-75">
						<input type="text" id="username" name="username" placeholder="Username" required>
					</div>
				  </div>
				  
				  <div class="row">
					<div class="col-25">
					  <label for="password">Password</label>
					</div>
					<div class="col-75">
						<input type="password" id="password" name="password" placeholder="Password" required>
					</div>
				  </div>
				  
				  

				  <!-- <div class="row">
					<input style="margin-top: 2%;"
					  type="submit"
					  value="Add"
					  id="registerBtn"
					/>
				  </div>
 -->				</form>
			  </div>

			<!-- <h3>User List</h3><hr>
			<div class="container">
			<table id="userListTable">
				<thead>
					<tr>
						<th>User Name</th>
						<th>Actions</th>
					</tr>
				</thead>
				<tbody>
					User list table rows will be populated dynamically using JavaScript
				</tbody>
			</table>
			</div> -->
			</section>
		</div>

	
	<div class="footer">
			<%@ include file="footer.jsp"%>
		  </div>
</body>
</html> --%>


<!-- --------------------------------- -->





<%-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<title>User Settings</title>
<link rel="stylesheet" type="text/css" href="nav-bar.css">
<%@ include file="header.jsp"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	// Function to load user data and populate the user list table
	function loadUserList() {
		$.ajax({
			url : 'data',
			type : 'GET',
			dataType : 'json',
			success : function(data) {
				// Clear existing table rows
				var userTable = $('#userListTable tbody');
				userTable.empty();

				// Iterate through the user data and add rows to the table
				$.each(data, function(index, user) {
					var row = $('<tr>');
					row.append($('<td>').text(user.firstName));

					var actions = $('<td>');
					var editButton = $('<button>').text('Edit').click(
							function() {
								settUser(user.firstName);

							});
					var deleteButton = $('<button>').text('Delete').click(
							function() {
								deleteUser(user.firstName);
							});

					actions.append(editButton);
					actions.append(deleteButton);

					row.append(actions);

					userTable.append(row);

				});
			},
			error : function(xhr, status, error) {
				console.log('Error loading user data: ' + error);
			}
		});
	}

	function settUser(userId) {
		// Make an AJAX GET request to retrieve user details for editing

		$('#firstName').val(userId);
		$('#registerBtn').val('Edit');

	}

	// Function to handle deleting a user
	function deleteUser(userId) {
		// Perform necessary actions to delete the user
		// For example, make an AJAX call to a delete servlet

		alert(userId)
		var confirmation = confirm('Are you sure you want to delete this user?');
		if (confirmation) {
			$.ajax({
				url : 'UserDeleteServlet',
				type : 'POST',
				data : {
					firstName : userId
				},
				success : function(data) {
					// Display the registration status message
					alert(data.message);

					// Refresh the user list
					loadUserList();
				},
				error : function(xhr, status, error) {
					// Handle the error response, if needed
					console.log('Error deleting user: ' + error);
				}
			});
		}
	}

	function editUser() {

		var confirmation = confirm('Are you sure you want to edit this user?');

		var firstName = $('#firstName').val();
		var password = $('#password').val();

		$.ajax({
			url : 'UserEditServlet',
			type : 'POST',
			data : {
				firstName : firstName,
				password : password
			},
			success : function(data) {
				// Display the registration status message
				alert(data.message);
				loadUserList();

				// Clear form fields
				$('#firstName').val('');
				$('#password').val('');
			},
			error : function(xhr, status, error) {
				console.log('Error adding user: ' + error);
			}
		});

		$('#registerBtn').val('Add');
	}

	// Function to handle form submission and add a new user
	function addUser() {
		var firstName = $('#firstName').val();
		var password = $('#password').val();

		$.ajax({
			url : 'data',
			type : 'POST',
			data : {
				firstName : firstName,
				password : password
			},
			success : function(data) {
				// Display the registration status message
				alert(data.message);
				loadUserList();

				// Clear form fields
				$('#firstName').val('');
				$('#password').val('');
			},
			error : function(xhr, status, error) {
				console.log('Error adding user: ' + error);
			}
		});

		$('#registerBtn').val('Add');
	}

	// Function to execute on page load
	$(document).ready(function() {
		// Load user list
		loadUserList();

		// Handle form submission
		$('#userForm').submit(function(event) {
			event.preventDefault();
			var buttonText = $('#registerBtn').val();

			if (buttonText == 'Add') {
				addUser();
			} else {
				editUser();
			}
		});

	});
</script>
<style>
table {
	border-collapse: collapse;
	width: 98%;
}

th, td {
	padding: 8px;
	text-align: left;
	border-bottom: 1px solid #ddd;
}

th {
	background-color: #e2e6f9;
	color: #283587;
}

h2 {
	color: #283587;
}

input[type="text"] input[type="password"] {
	width: 400px;
	min-height: 80px;
	padding: 5px;
	border: 1px solid #ccc;
	border-radius: 4px;
}

input[type="submit"] {
	padding: 5px 10px;
	background-color: #6c45ed;
	color: white;
	border: none;
	width: 85px;
	height: 38px;
	border-radius: 4px;
	cursor: pointer;
}

.text {
	height: 30px;
}

.pwd {
	height: 30px;
}
</style>
</head>
<body>
	<div class="container">
<div class="sidebar"><%@ include file="common.jsp"%></div>
		


		<div class="content">

			<h2>Add User</h2>
			<form id="userForm">
				<input type="text" id="firstName" name="firstName" class="text"
					placeholder="Username" required> <input type="password"
					id="password" name="password" placeholder="Password" class="pwd"
					required> <input type="submit" value="Add" id="registerBtn" />
			</form>

			<h2>User List</h2>
			<table id="userListTable">
				<thead>
					<tr>
						<th>User Name</th>
						<th>Actions</th>
					</tr>
				</thead>
				<tbody>
					<!-- User list table rows will be populated dynamically using JavaScript -->
				</tbody>
			</table>
		</div>
	</div>
	<%@ include file="footer.jsp"%>
</body>
</html> --%>


<!-- ----------------------------------------------------------------------------------------------------- -->

<!DOCTYPE html>
<html>
<title>IIOT Connex</title>
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
	function loadMqttList() {
		$.ajax({
			url : 'mqttData',
			type : 'GET',
			dataType : 'json',
			success : function(data) {
				// Clear existing table rows
				var mqttTable = $('#mqttListTable tbody');
				mqttTable.empty();

				// Iterate through the user data and add rows to the table
				$.each(data, function(index, mqtt) {
					var row = $('<tr>');
					row.append($('<td>').text(mqtt.broker_ip_address + ""));
					row.append($('<td>').text(mqtt.port_number + ""));
					row.append($('<td>').text(mqtt.username + ""));
					row.append($('<td>').text(mqtt.password + ""));
					row.append($('<td>').text(mqtt.publish_topic + ""));
					row.append($('<td>').text(mqtt.subscribe_topic + ""));
					row.append($('<td>').text(mqtt.prefix + ""));
					row.append($('<td>').text(mqtt.file_type + ""));
					row.append($('<td>').text(mqtt.enable + ""));

					mqttTable.append(row);

				});
			},
			error : function(xhr, status, error) {
				console.log('Error loading mqtt data: ' + error);
			}
		});
	}

	function setMqtt(userId) {
		// Make an AJAX GET request to retrieve user details for editing

		$('#firstName').val(userId);
		$('#registerBtn').val('Edit');

	}

	// Function to handle deleting a user
	function deleteMqttSettings(userId) {
		// Perform necessary actions to delete the user
		// For example, make an AJAX call to a delete servlet

		alert(userId)
		var confirmation = confirm('Are you sure you want to delete this user?');
		if (confirmation) {
			$.ajax({
				url : 'UserDeleteServlet',
				type : 'POST',
				data : {
					firstName : userId
				},
				success : function(data) {
					// Display the registration status message
					alert(data.message);

					// Refresh the user list
					loadUserList();
				},
				error : function(xhr, status, error) {
					// Handle the error response, if needed
					console.log('Error deleting user: ' + error);
				}
			});
		}
	}

	function editMqtt() {

		var confirmation = confirm('Are you sure you want to edit this mqtt settings?');

		var firstName = $('#firstName').val();
		var password = $('#password').val();

		$.ajax({
			url : 'UserEditServlet',
			type : 'POST',
			data : {
				firstName : firstName,
				password : password
			},
			success : function(data) {
				// Display the registration status message
				alert(data.message);
				loadUserList();

				// Clear form fields
				$('#firstName').val('');
				$('#password').val('');
			},
			error : function(xhr, status, error) {
				console.log('Error adding user: ' + error);
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
	
		if($('#enable').is(':checked')){
			var enable = "true";
		}else{
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
						<div class="col-25">
							<label for="broker_ip_address">Broker IP Address</label>
						</div>
						<div class="col-75">
							<input type="text" id="broker_ip_address"
								name="broker_ip_address" placeholder="Broker IP Address"
								required />

						</div>

					</div>
					<div class="row">
						<div class="col-25">
							<label for="port_number">Port Number</label>
						</div>
						<div class="col-75">
							<input type="text" id="port_number" name="port_number"
								placeholder="Port Number" required>
						</div>
					</div>

					<div class="row">
						<div class="col-25">
							<label for="username">Username</label>
						</div>
						<div class="col-75">
							<input type="text" id="username" name="username"
								placeholder="Username" required />

						</div>
					</div>
					<div class="row">
						<div class="col-25">
							<label for="password">Password</label>
						</div>
						<div class="col-75">
							<input type="password" id="password" name="password"
								placeholder="Password" required>
						</div>
					</div>

					<div class="row">
						<div class="col-25">
							<label for="pub_topic">Published Topic</label>
						</div>
						<div class="col-75">
							<input type="text" id="pub_topic" name="pub_topic"
								placeholder="Published Topic" required />

						</div>
					</div>
					<div class="row">
						<div class="col-25">
							<label for="sub_topic">Subscribed Topic</label>
						</div>
						<div class="col-75">
							<input type="text" id="sub_topic" name="sub_topic"
								placeholder="Subscribed Topic" required>
						</div>
					</div>

					<div class="row">
						<div class="col-25">
							<label for="prefix">Prefix</label>
						</div>
						<div class="col-75">
							<input type="text" id="prefix" name="prefix" placeholder="Prefix"
								required />

						</div>
					</div>


					<div class="row">
						<div class="col-25">
							<label for="fileType">File Type</label>
						</div>
						<div class="col-75">

							<select class="textBox" id="file_type" name="file_type">
								<option id="ssl">SSL</option>
								<option id="tcp">TCP</option>

							</select>
						</div>
						</div>

						<div class="row">

							<div class="col-25">
								<label for="enable">Enable</label>
							</div>
							<div class="col-75">
								<input type="checkbox" class="enable" id="enable" name="enable">

							</div>
						</div>
					

					<div class="row">
						<input style="margin-top: 2%;" type="submit" value="Add"
							id="registerBtn" /> <input style="margin-top: 2%;"
							type="submit" value="Update" id="updateBtn" /> <input
							style="margin-top: 2%; background-color: red" type="submit"
							value="Delete" id="deleteBtn" />
					</div>

				</form>
			</div>

			<h3>MQTT Server List</h3>
			<hr>
			<div class="container">
				<table id="mqttListTable">
					<thead>
						<tr>
							<th>Broker IP Address</th>
							<th>Port Number</th>
							<th>Username</th>
							<th>Password</th>
							<th>Published Topic</th>
							<th>Subscribed Topic</th>
							<th>Prefix</th>
							<th>File Type</th>
							<th>Enable</th>

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