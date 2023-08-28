
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

var roleValue;

	// Function to load user data and populate the user list table
	function loadUserList() {
		$
				.ajax({
					//	url : 'data',
					url : 'userServlet',
					type : 'GET',
					dataType : 'json',
					success : function(data) {
						// Clear existing table rows
						var userTable = $('#userListTable tbody');
						userTable.empty();

						var json1 = JSON.stringify(data);

						var json = JSON.parse(json1);

						if (json.status == 'fail') {
							var confirmation = confirm(json.msg);
							if (confirmation) {
								window.location.href = 'login.jsp';
							}
						}

						
						if(roleValue == 'ADMIN' || roleValue == 'Admin'){
							// Iterate through the user data and add rows to the table
							$.each(data,function(index, user) {
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
						}else if(roleValue == 'VIEWER' || roleValue == 'Viewer'){
							
							// Iterate through the user data and add rows to the table
							$.each(data,function(index, user) {
												var row = $('<tr>');
												
												row.append($('<td>').text(user.username));
												row.append($('<td>').text(user.first_name));
												row.append($('<td>').text(user.last_name));
												row.append($('<td>').text(user.role));

												userTable.append(row);

											});
						}
							
						
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

	function setFirstName(userId) {

		$('#first_name').val(userId);
	}

	function setLastName(userId) {

		$('#last_name').val(userId);
	}

	function setRole(userId) {

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
				url : 'userServlet',
				type : 'POST',
				data : {
					username : userId,
					action: 'delete'
				},
				success : function(data) {
					// Display the registration status message
					
					if(userId == 'tasm2m_admin'){
						var json1 = JSON.stringify(data);

						var json = JSON.parse(json1);

						if (json.status == 'fail') {
							var confirmation = confirm(json.msg);
							if (confirmation) {
								window.location.href = 'user.jsp';
							}
						}
					}
					
					else{
						
						alert(data.message);
					}
				

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
			url : 'userServlet',
			type : 'POST',
			data : {
				username : username,
				first_name : first_name,
				last_name : last_name,
				role : role,
				action: 'update'
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
	    $('#role').val('Select role');

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
			url : 'userServlet',
			type : 'POST',
			data : {
				username : username,
				password : password,
				first_name : first_name,
				last_name : last_name,
				role : role,
				action: 'add'
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
			    $('#role').val('Select role');

			},
			error : function(xhr, status, error) {
				console.log('Error adding user: ' + error);
			}
		});

		$('#registerBtn').val('Add');
	}

	function validateRole(role) {
		var roleError = document.getElementById("roleError");

		if (role == 'Select role') {

			roleError.textContent = "Please select role";
			return false;
		} else {
			roleError.textContent = "";
			return true;
		}
	}
	
	function validatePassword(password) {
		var passwordError = document.getElementById("passwordError");

		if (password.length < 8 || !/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+/.test(password)) {
			passwordError.textContent = "Password must be at least 8 characters long and contain special characters.";
			return false;
		} else {
			passwordError.textContent = "";
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
		loadUserList();
		
		if (roleValue == 'VIEWER' || roleValue == 'Viewer') {

			var confirmation = confirm('You do not have enough privileges for role VIEWER');
			$("#actions").hide();
			$('#registerBtn').prop('disabled', true);
			$('#clearBtn').prop('disabled', true);
			
			changeButtonColor(true);
		}


		// Handle form submission
		$('#userForm').submit(function(event) {
			event.preventDefault();
			var buttonText = $('#registerBtn').val();
			var role = $('#role').find(":selected").val();
			var password = $('#password').val();

			if (!validateRole(role)) {
				roleError.textContent = "Please select role";
				return;
			}

			
			 var isDisabled = $("#password").prop("disabled");
			 
			 if (!isDisabled) {
				 if (!validatePassword(password)) {
						passwordError.textContent = "Password must be at least 8 characters long and contain special characters.";
						return;
					}	
			    } 
			
					
			if (buttonText == 'Add') {
				addUser();

			} else {

				editUser();
			}
		});

		$('#username').val('');
	    $('#password').val('');
	    $('#first_name').val('');
	    $('#last_name').val('');
	    $('#role').val('Select role');

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
				
				<input type="hidden" id="action" name="action" value="">
				
					<div class="row"
						style="display: flex; flex-content: space-between; margin-top: -20px;">
						<div class="col-75-1" style="width: 20%;">
							<input type="text" id="username" name="username"
								placeholder="Username" required />

						</div>
						
						<div class="col-75-2" style="width: 20%;">
							<input type="password" id="password" name="password"
								placeholder="Password" required>
								
								<p id="passwordError" style="color: red;"></p>
						</div>
						
						<div class="col-75-3" style="width: 20%;">
							<input type="text" id="first_name" name="first_name"
								placeholder="Firstname" />

						</div>
						
						<div class="col-75-4" style="width: 20%;">
							<input type="text" id="last_name" name="last_name"
								placeholder="Lastname" />
						</div>
					
						<div class="col-75-5" style="width: 20%;">
							<select class="role" id="role" name="role" style="height: 33px;">
								<option value="Select role">Select role</option>
								<option value="ADMIN">ADMIN</option>
								<option value="VIEWER">VIEWER</option>
							</select> <span style="color: red; font-size: 12px;" id="roleError"></span>
						</div>
					</div>

					<div class="row"
						style="display: flex; justify-content: right; margin-top: 2%;">
						<input type="button" value="Clear" id="clearBtn"/> <input
							style="margin-left: 5px;" type="submit" value="Add"
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
							<th id="actions">Actions</th>
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