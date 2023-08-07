
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
<title>WP500 Web Configuration</title>
<link
      rel="icon"  
      type="image/png"
      sizes="32x32"
      href="favicon.png"
    /> 
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
	function loadUserList() {
		$
				.ajax({
					url : 'data',
					type : 'GET',
					dataType : 'json',
					success : function(data) {
						// Clear existing table rows
						var userTable = $('#userListTable tbody');
						userTable.empty();

						// Iterate through the user data and add rows to the table
						$
								.each(
										data,
										function(index, user) {
											var row = $('<tr>');
											row.append($('<td>').text(user.username));
											row.append($('<td>').text(user.first_name));
											row.append($('<td>').text(user.last_name));
											row.append($('<td>').text(user.role));

											var actions = $('<td>');
											var editButton = $(
													'<button style="background-color: #35449a; border: none; border-radius: 5px; margin-left: 5px; color: white">')
													.text('Edit')
													.click(
															function() {
																settUser(user.username);
																setFirstName(user.first_name);
																setLastName(user.last_name);
																setRole(user.role);

															});
											var deleteButton = $(
													'<button style="background-color:red; border: none; border-radius: 5px; margin-left: 5px; color: white">')
													.text('Delete')
													.click(
															function() {
																deleteUser(user.username);
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

		$("#password").prop("disabled", true);
		$('#username').val(userId);
		$("#username").prop("disabled", true);
		$('#registerBtn').val('Edit');

	}
	
	function setFirstName(userId){
		
		$('#first_name').val(userId);
	}
	
	function setLastName(userId){
		
		$('#last_name').val(userId);
	}
	
	function setRole(userId){
	
	$('#role').val(userId);
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
					username : userId
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

		var username = $('#username').val();
		var first_name = $('#first_name').val();
		var last_name = $('#last_name').val();
		var role = $('#role').find(":selected").val();
		
		

		$.ajax({
			url : 'UserEditServlet',
			type : 'POST',
			data : {
				username : username,
				first_name : first_name,
				last_name : last_name,
				role : role
			},
			success : function(data) {
				// Display the registration status message
				alert(data.message);
				loadUserList();

				// Clear form fields
				$('#username').val('');
				$('#first_name').val('');
				$('#last_name').val('');
				$('#role').val('');
				
				$("#password").prop("disabled", false);
				
				$("#username").prop("disabled", false);
			},
			error : function(xhr, status, error) {
				console.log('Error updating user: ' + error);
			}
		});

		$('#registerBtn').val('Add');
	}

	// Function to handle form submission and add a new user
	function addUser() {
		
		var username = $('#username').val();
		var password = $('#password').val();
		var first_name = $('#first_name').val();
		var last_name = $('#last_name').val();
		var role = $('#role').find(":selected").val();

		$.ajax({
			url : 'data',
			type : 'POST',
			data : {
				username : username,
				password : password,
				first_name : first_name,
				last_name : last_name,
				role : role
			},
			success : function(data) {
				// Display the registration status message
				alert(data.message);
				loadUserList();

				// Clear form fields
				
				$('#username').val('');
				$('#password').val('');
				$('#first_name').val('');
				$('#last_name').val('');
				$('#role').val('');
				
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
			<h3>ADD USER</h3>
			<hr>

			<div class="container">
				<form id="userForm">
					<div class="row">
						<!-- <div class="col-25">
					  <label for="username">Username</label>
					</div> -->
						<div class="col-75-1" style="width: 20%; margin-top: -20px;">
							<input type="text" id="username" name="username"
								placeholder="Username" required />

						</div>
					</div>
					<div class="row">
						<!-- <div class="col-25">
					  <label for="password">Password</label>
					</div> -->
						<div class="col-75-2"
							style="width: 20%; margin-left: 20%; margin-top: -32px;">
							<input type="password" id="password" name="password"
								placeholder="Password" required>
						</div>
					</div>
					<div class="row">
						<!-- <div class="col-25">
					  <label for="username">Username</label>
					</div> -->
						<div class="col-75-3"
							style="width: 20%; margin-top: -32px; margin-left: 40%;">
							<input type="text" id="first_name" name="first_name"
								placeholder="Firstname" required />

						</div>
					</div>
					<div class="row">
						<!-- <div class="col-25">
					  <label for="username">Username</label>
					</div> -->
						<div class="col-75-4"
							style="width: 20%; margin-top: -32px; margin-left: 60%;">
							<input type="text" id="last_name" name="last_name"
								placeholder="Lastname" required />

						</div>
					</div>

					<div class="row">
						
						<div class="col-75-5" style="width: 20%; margin-left: 80%; margin-top: -32px">
						<select class="role" id="role"
							name="role" style="height: 33px;">
							<option value="Select role">Select Role</option>
							<option value="ADMIN">ADMIN</option>
							<option value="VIEWER">VIEWER</option>
						</select>
					</div>
					</div>

<div class="row">
					<input style="margin-top: 2%; margin-left: 80%;" type="button"
						value="Clear" id="clearBtn" />
				</div>
					<div class="row">
						<input style="margin-top: -2.5%; margin-left: 95%;" type="submit" value="Add"
							id="registerBtn" />
					</div>
				</form>
			</div>

			<h3>USER LIST</h3>
			<hr>
			<div class="container">
				<table id="userListTable">
					<thead>
						<tr>
							<th>User Name</th>
							<th>First Name</th>
							<th>Last Name</th>
							<th>Role</th>
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