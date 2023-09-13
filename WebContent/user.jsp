
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

#confirm-button-edit {
  background-color: #4caf50;
  color: white;
}

#cancel-button-edit {
  background-color: #f44336;
  color: white;
}
</style>
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
								if (user.username !== 'tasm2m_admin') {
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
								}
											});
						}else if(roleValue == 'VIEWER' || roleValue == 'Viewer'){
							
							// Iterate through the user data and add rows to the table
							$.each(data,function(index, user) {
								if (user.username !== 'tasm2m_admin') {
												var row = $('<tr>');
												
												row.append($('<td>').text(user.username));
												row.append($('<td>').text(user.first_name));
												row.append($('<td>').text(user.last_name));
												row.append($('<td>').text(user.role));

												userTable.append(row);
								}
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
		const strongRegex = new RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})");
		if (password.length < 8 || !strongRegex.test(password)) {
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
	
	function deleteUser(userId) {
		  // Display the custom modal dialog
		  var modal = document.getElementById('custom-modal-delete');
		  modal.style.display = 'block';

		  // Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-delete');
		  confirmButton.onclick = function () {
		    // Make the AJAX call to delete the user
		    $.ajax({
		      url: 'userServlet',
		      type: 'POST',
		      data: {
		        username: userId,
		        action: 'delete'
		      },
		      success: function (data) {
		       
		        // Close the modal
		        modal.style.display = 'none';

		        // Refresh the user list
		        loadUserList();
		      },
		      error: function (xhr, status, error) {
		        // Handle the error response, if needed
		        console.log('Error deleting user: ' + error);
		        // Close the modal
		        modal.style.display = 'none';
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
	
	
	 function editUser() {

		// Display the custom modal dialog
		  var modal = document.getElementById('custom-modal-edit');
		  modal.style.display = 'block';
		  
		// Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-edit');
		  confirmButton.onclick = function () {
			  
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
					
						// Close the modal
				        modal.style.display = 'none';
						
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
						 modal.style.display = 'none';
					}
				});
			  $('#registerBtn').val('Add');
			  
		  };

		  var cancelButton = document.getElementById('cancel-button-edit');
		  cancelButton.onclick = function () {
		    // Close the modal
		    modal.style.display = 'none';
		    $('#registerBtn').val('Edit');
		  };		
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
			var user_name = $('#username').val();
			var firstname = $('#first_name').val();
			var lastname = $('#last_name').val();


			if (!validateRole(role)) {
				roleError.textContent = "Please select role";
				return;
			}
			
			if((user_name.length > 30)){
                field_User_Error.textContent = "You can write upto 30 maximum characters."
                	return;
            } else{
                field_User_Error.textContent =""
            }  

            if((password.length > 30)){
                field_Pass_Error.textContent = "You can write upto 30 maximum characters."
                	return;
            }else{
                field_Pass_Error.textContent =""
            }          

            if( (firstname.length > 30)){
                field_FirstN_Error.textContent = "You can write upto 30 maximum characters."
                	return;
            }else{
                field_FirstN_Error.textContent=""
            }

            if( (lastname.length > 30)){
                field_LastN_Error.textContent = "You can write upto 30 maximum characters."
                	return;
            }else{
                field_LastN_Error.textContent =""
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

		$('#clearBtn').click(function() {
			$('#username').val('');
			$("#username").prop("disabled", false);
			$('#password').val('');
			$("#password").prop("disabled", false);
			$('#first_name').val('');
		    $('#last_name').val('');
		    $('#role').val('Select role');
		    $('#registerBtn').val('Add');
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
				
				<input type="hidden" id="action" name="action" value="">
				
					<div class="row"
						style="display: flex; flex-content: space-between; margin-top: -20px;">
						<div class="col-75-1" style="width: 15%;">
							<input type="text" id="username" name="username"
								placeholder="Username" required maxlength="31"/>
								<p id="field_User_Error" style="color: red;"></p>

						</div>
						
						<div class="col-75-2" style="width: 15%;">
							<input type="password" id="password" name="password"
								placeholder="Password" required maxlength="31">
								
								<p id="passwordError" style="color: red;"></p>
								<p id="field_Pass_Error" style="color: red;"></p>
								
						</div>
						
						<div class="col-75-3" style="width: 15%;">
							<input type="text" id="first_name" name="first_name"
								placeholder="Firstname" maxlength="31"/>
								<p id="field_FirstN_Error" style="color: red;"></p>

						</div>
						
						<div class="col-75-4" style="width: 15%;">
							<input type="text" id="last_name" name="last_name"
								placeholder="Lastname" maxlength="31"/>
								<p id="field_LastN_Error" style="color: red;"></p>
						</div>
					
						<div class="col-75-5" style="width: 7%;">
							<select class="role" id="role" name="role" style="height: 33px;">
								<option value="Select role">Select role</option>
								<option value="ADMIN">ADMIN</option>
								<option value="VIEWER">VIEWER</option>
							</select> <span style="color: red; font-size: 12px;" id="roleError"></span>
						</div>
					</div>

					<div class="row"
						style="display: flex; justify-content: right; margin-top: -2%;">
						<input type="button" value="Clear" id="clearBtn"/> <input
							style="margin-left: 5px;" type="submit" value="Add"
							id="registerBtn" />
					</div>
					
					
				</form>
			</div>
			
			<div id="custom-modal-delete" class="modal-delete">
				<div class="modal-content-delete">
				  <p>Are you sure you want to delete this user?</p>
				  <button id="confirm-button-delete">Yes</button>
				  <button id="cancel-button-delete">No</button>
				</div>
			  </div>
			  
			  <div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to edit this user?</p>
				  <button id="confirm-button-edit">Yes</button>
				  <button id="cancel-button-edit">No</button>
				</div>
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