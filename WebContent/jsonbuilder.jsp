<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>JSON Builder</title>
<link
rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css"
/>
<link
href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
rel="stylesheet"
type="text/css"
/>
<link
rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css"
/>
<link rel="stylesheet" href="nav-bar.css" />
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
		$('#jsonBuilderForm').submit(function(event) {
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
			<h3>JSON Builder Settings</h3><hr>

			<div class="container">
				<form id="jsonBuilderForm">
				  <div class="row">
					<div class="col-25">
					  <label for="jsonStringName">JSON String Name</label>
					</div>
					<div class="col-75">
					  <input type="text" id="jsonStringName" name="jsonStringName" placeholder="JSON String Name" required/>
					  
					</div>
				  </div>
				  <div class="row">
					<div class="col-25">
					  <label for="jsonInterval">JSON Interval</label>
					</div>
					<div class="col-75">
						<input type="text" id="jsonInterval" name="jsonInterval" placeholder="JSON Interval"
						required>
					</div>
				  </div>
				  
				  <div class="row">
						<div class="col-25">
							<label for="fileType">Broker Type</label>
						</div>
						<div class="col-75">

							<select class="textBox" id="broker_type" name="broker_type">
								<option id="mqtt">mqtt</option>
								<option id="iothub">iothub</option>
								

							</select>
						</div>
						</div>
						
						<div class="row">
						<div class="col-25">
							<label for="broker_name">Broker Name</label>
						</div>
						<div class="col-75">

							<select class="textBox" id="broker_name" name="broker_name">
								<option id=""></option>
								<option id=""></option>

							</select>
						</div>
						</div>
						
						<div class="row">
					<div class="col-25">
					  <label for="publishTopic">Publish Topic</label>
					</div>
					<div class="col-75">
						<input type="text" id="publishTopic" name="publishTopic" placeholder="Publish Topic"
						required>
					</div>
				  </div>
				  
				  <div class="row">
					<div class="col-25">
					  <label for="pubStatus">Publishing Status</label>
					</div>
					<div class="col-75">
						<input type="text" id="pubStatus" name="pubStatus" placeholder="Publishing Status"
						required>
					</div>
				  </div>
				  
				  <div class="row">
						<div class="col-25">
							<label for="storeAndForward">Store and Forward</label>
						</div>
						<div class="col-75">

							<select class="textBox" id="storeAndForward" name="storeAndForward">
								<option id="enable">Enable</option>
								<option id="disable">Disable</option>
								

							</select>
						</div>
						</div>
						
						<div class="row">
						<div class="col-25">
							<label for="json_string">Enter JSON String</label>
						</div>
						<div class="col-75">

							 <textarea id="json_string_text" name="json_string_text" rows="10" cols="50" placeholder="JSON String"></textarea>
					
						</div>
						</div>
						
						 <div class="row">
					<input style="margin-top: 2%;"
					  type="submit"
					  value="Validate"
					  id="validateBtn"
					/>
				  </div>
				  
				  <div class="row">
						 <div class="col-25">
<!-- 							<label for="json_string">Enter JSON String</label>
 -->						</div> 
						<div class="col-75">

							 <textarea id="json_string_validate" name="json_string_validate" rows="10" cols="50" placeholder="Validate String"></textarea>
					
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

			<h3>JSON Builder Settings</h3><hr>
			<div class="container">
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
			</section>
		</div>
		<div class="footer">
			<%@ include file="footer.jsp"%>
		  </div>
	
</body>
</html>