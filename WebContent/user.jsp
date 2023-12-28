<!DOCTYPE html>
<html>
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png" />
<link rel="stylesheet" href="css_files/ionicons.min.css">
<link rel="stylesheet" href="css_files/normalize.min.css">
<link rel="stylesheet" href="css_files/fonts.txt" type="text/css">
<link rel="stylesheet" href="nav-bar.css" />
<link rel="stylesheet" href="css_files/all.min.css">
<link rel="stylesheet" href="css_files/fontawesome.min.css">

<script src="jquery-3.6.0.min.js"></script>


<style>
.modal-delete,
.modal-edit,
.modal-updatePasswordPolicy,
.modal-session-timeout,
.modal-edit-password  {
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

.modal-content-delete,
.modal-content-edit,
.modal-content-updatePasswordPolicy,
.modal-content-session-timeout,
.modal-content-edit-password
 {
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
#confirm-button-updatePasswordPolicy,
#confirm-button-edit-password,
#confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
}

#cancel-button-delete,
#cancel-button-edit,
#cancel-button-updatePasswordPolicy,
#cancel-button-edit-password
 {
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

#userListTable tr.userTableRow{
height: 10px;
}

h3{
margin-top: 18px;
}

 .bordered-table {
  border-collapse: collapse; /* Optional: To collapse table borders */
  margin: 0 auto; /* Center the table horizontally */
  width: 100%; /* Make the table take up 100% of the container's width */
}

.bordered-table td {
  border: 1px solid #ccc; /* Light gray border */
  
}

.block-list{
 border-collapse: collapse;
}

.block-list td{
 border: 1px solid #ccc;
 
}

   .container {
    margin: 0 auto;
   max-width: 750px;
    border-collapse: collapse;
    background-color: #f2f2f2;
     border-radius: 5px;
  
  }
  
  .policy-container{
  margin: 0 auto;
    width: 50%;
    border-collapse: collapse;
    background-color: #f2f2f2;
     border-radius: 5px;
  
  }
  
  
  .password-toggle {
   margin-right: -5px;
    margin-top: -10px;    
    cursor: pointer;
    margin-left: 10px;
    }
    
    .error-message {
            color: red;
            display: none; /* Hide the error message by default */
        }
  
.tab {
        display: none;
        }
        
        .tab-button {
          
            padding: 10px 20px;
            border: none;
            cursor: pointer;
        }
        
        .tab-button.active {
            background-color: #2b3991;
            color: white;
        }
        
        .tab-content {
           
            border: 1px solid #ccc;
        }
        
        .tab-container{
       
        margin-left: -18px;
        }
        
        #loader-overlay {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(255, 255, 255, 0.7); /* Transparent white background */
    z-index: 1000; /* Ensure the loader is on top of other elements */
    justify-content: center;
    align-items: center;
}

#loader {
    text-align: center;
    padding: 20px;
    background: #fff; /* Loader background color */
    border-radius: 5px;
}

</style>
<script>

var roleValue;
var tokenValue;

function togglePassword() {
    var passwordInput = $('#password');
    var passwordToggle = $('#password-toggle');

    if (passwordInput.attr('type') === 'password') {
        passwordInput.attr('type', 'text');
        passwordToggle.html('<i class="fa fa-eye-slash"></i>'); // Change to eye-slash icon
    } else {
        passwordInput.attr('type', 'password');
        passwordToggle.html('<i class="fa fa-eye"></i>'); // Change to eye icon
    }
}


	// Function to load user data and populate the user list table
	function loadUserList() {
		// Display loader when the request is initiated
	    showLoader();
		
		$.ajax({
					
					url : 'userServlet',
					type : 'GET',
					dataType : 'json',
					beforeSend: function(xhr) {
				        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
				    },
					success : function(data) {
						// Hide loader when the response has arrived
			            hideLoader();
						
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
						var userTable = $('#userListTable tbody');
						userTable.empty();
						
						if(roleValue == 'ADMIN' || roleValue == 'Admin'){
							data.result.forEach(function(user) {
								if (user.username !== 'wp500') {
								var username = user.username; // Accessing the date_time property
								var first_name = user.first_name; // Accessing the event_name property
								var last_name = user.last_name; // Accessing the event_type property
								var role = user.role; // Accessing the msg property

								var row = $("<tr>").append($("<td>").text(username),
										$("<td>").text(first_name),
										$("<td>").text(last_name),
										$("<td>").text(role));
								
								var actions = $('<td>');
								
								var editButton = $(
	                            '<button data-toggle="tooltip" data-placement="top" title="Edit" style="color: #35449a;">'
	                            )
	                            .html('<i class="fas fa-edit"></i>')
	                            .click(function() {
	                                settUser(user.username);
	                                setFirstName(user.first_name);
	                                setLastName(user.last_name);
	                                setRole(user.role);
	                            });

	                        var deleteButton = $(
	                            '<button data-toggle="tooltip" data-placement="top" title="Delete" style="color: red;">')
	                            .html('<i class="fas fa-trash-alt"></i>')
	                            .click(function() {
	                                deleteUser(user.username);
	                            });

	                        var changePasswordButton = $(
	                            '<button data-toggle="tooltip" data-placement="top" title="Change password" style="color: #35449a;">')
	                            .html('<i class="fas fa-key"></i>')
	                            .click(function() {
	                                setUserForChangingPassword(user.username);
	                            });

						actions.append(editButton);
						actions.append(deleteButton);
						actions.append(changePasswordButton);

						row.append(actions);
								userTable.append(row);
								}
							});
 
 
						}else if(roleValue == 'OPERATOR' || roleValue == 'Operator'){
							data.result.forEach(function(user) {
								if (user.username !== 'wp500') {
									var username = user.username; 
									var first_name = user.first_name; 
									var last_name = user.last_name; 
									var role = user.role; 

									var row = $("<tr>").append($("<td>").text(username),
											$("<td>").text(first_name),
											$("<td>").text(last_name),
											$("<td>").text(role));
									
									userTable.append(row);
								}
							});
							
						}
						
					},
					error : function(xhr, status, error) {
						// Hide loader when the response has arrived
			            hideLoader();
						console.log('Error loading user data: ' + error);
					}
				});
	}
	
	function setUserForChangingPassword(userId){
		$('#username').val(userId);
		$("#username").prop("disabled", true);
		$("#first_name").prop("disabled", true);
		$("#last_name").prop("disabled", true);
		$("#role").prop("disabled", true);
		$('#registerBtn').val('Update Password');
	}

	function settUser(userId) {
		// Make an AJAX GET request to retrieve user details for editing

		$("#password").prop("disabled", true);
		$('#username').val(userId);
		$("#username").prop("disabled", true);
		$('#registerBtn').val('Update');

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
				
				// Display the custom popup message
     			$("#popupMessage").text(data.message);
      			$("#customPopup").show();
      			
				loadUserList();

				if(data.status === "success"){
					// Clear form fields
					
					 var passwordInput = $('#password');
				    var passwordToggle = $('#password-toggle');

				    // Reset password input first
				    passwordInput.attr('type', 'password');
				    passwordToggle.html('<i class="fa fa-eye"></i>'); // Change to eye icon
				    
					$('#username').val('');
				    $('#password').val('');
				    $('#first_name').val('');
				    $('#last_name').val('');
				    $('#role').val('ADMIN');
				}
				

			},
			error : function(xhr, status, error) {
				console.log('Error adding user: ' + error);
			}
		});
		
		$("#closePopup").click(function () {
		    $("#customPopup").hide();
		  });

		$('#registerBtn').val('Add');
	}



	function changeButtonColor(isDisabled) {
        var $add_button = $('#registerBtn');       
        var $clear_button = $('#clearBtn');
        var $reset_password_button = $('#resetPasswordPolicy');
        var $apply_button = $('#applyPassword');
           
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
            $reset_password_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $reset_password_button.css('background-color', '#2b3991'); // Reset to original color
        } 
        
        if (isDisabled) {
            $apply_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $apply_button.css('background-color', '#2b3991'); // Reset to original color
        } 
    }
	
	function openTab(tabId, button) {
        var tabs = document.getElementsByClassName("tab");
        for (var i = 0; i < tabs.length; i++) {
            tabs[i].style.display = "none";
        }

        var tab = document.getElementById(tabId);
        if (tab) {
            tab.style.display = "block";
        }

        var tabButtons = document.getElementsByClassName("tab-button");
        for (var i = 0; i < tabButtons.length; i++) {
            tabButtons[i].classList.remove("active");
        }

        if (button) {
            button.classList.add("active");
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
		        loadUserList();
		        location.reload();
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
						
						
						modal.style.display = 'none';
						
						loadUserList();

						// Clear form fields
						
						 var passwordInput = $('#password');
				    var passwordToggle = $('#password-toggle');

				    // Reset password input first
				    passwordInput.attr('type', 'password');
				    passwordToggle.html('<i class="fa fa-eye"></i>'); // Change to eye icon
				    
					$('#username').val('');
			    $('#password').val('');
			    $('#first_name').val('');
			    $('#last_name').val('');
			    $('#role').val('ADMIN');

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
		    $('#registerBtn').val('Update');
		  };		
	} 
	 
	 function editPassword() {
		 var modal = document.getElementById('custom-modal-edit-password');
		  modal.style.display = 'block';
		  
		// Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-edit-password');
		  confirmButton.onclick = function () {
			  
			  var username = $('#username').val();
			  var password = $('#password').val();
			  
			  $.ajax({
					url : 'userServlet',
					type : 'POST',
					data : {
						username : username,
						password : password,
						action: 'update_user_password'
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
						
						loadUserList();

						// Clear form fields
					$('#username').val('');
			    $('#password').val('');
			    
						$("#username").prop("disabled", false);
						$("#first_name").prop("disabled", false);
						$("#last_name").prop("disabled", false);
						$("#role").prop("disabled", false);
					},
					error : function(xhr, status, error) {
						console.log('Error updating password: ' + error);
						 modal.style.display = 'none';
					}
				});
			  $('#registerBtn').val('Add');
				
		  };
		  
		  var cancelButton = document.getElementById('cancel-button-edit-password');
		  cancelButton.onclick = function () {
		    // Close the modal
		    modal.style.display = 'none';
		    $('#registerBtn').val('Update Password');
		  };
		  
	 }
	 
	 function updatePasswordPolicy(){
		 
		 var modal = document.getElementById('custom-modal-updatePasswordPolicy');
		  modal.style.display = 'block';
		  
		// Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-updatePasswordPolicy');
		  confirmButton.onclick = function () {
			  
			  event.preventDefault();
			  
				var min_asccii_char_count = $('#min_asccii_char_count').val();
				var min_mix_char_count = $('#min_mix_char_count').val();
				var min_num_count = $('#min_num_count').val();
				var min_spl_char_count = $('#min_spl_char_count').val();
				var allowed_spl_char = $('#allowed_spl_char').val();
				var min_char_count = $('#min_char_count').val();
				
				
				 var password_blocked_list = [];
				 
				// Find all input fields with name "blocked_password" in the table
				  $('#block-list input[name="blocked_password"]').each(function(index, input) {
				    var value = $(input).val();

				    if (value) {
				      password_blocked_list.push(value);
				    }
				  });

			        
			        var blockedPasswordJson = JSON.stringify(password_blocked_list);
			        
			        $.ajax({
			        	url : 'PasswordPolicyServlet',
			    		type : 'POST',
			    		data : {
			    			min_asccii_char_count : min_asccii_char_count,
			    			min_mix_char_count : min_mix_char_count,
			    			min_num_count : min_num_count,
			    			min_spl_char_count : min_spl_char_count,
			    			allowed_spl_char: allowed_spl_char,
			    			min_char_count : min_char_count,
			    			password_blocked_list : blockedPasswordJson,
			    			password_policy_action : 'updatePassword'
			    						
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
			    			
			    			getPasswordPolicy();
			    			
			    		},
			    		error : function(xhr, status, error) {
			    			console.log('Error updating password policy: ' + error);
			    		}
			        	
			        });
		  };
		  
		  var cancelButton = document.getElementById('cancel-button-updatePasswordPolicy');
		  cancelButton.onclick = function () {
			  event.preventDefault();
		    // Close the modal
		    modal.style.display = 'none';
		    
		    window.location.reload();
		   
		  };
			
	 }
	 
	 function resetPasswordPolicy(){
		 $.ajax({
			  url : 'ResetPasswordPolicyServlet',
				type : 'GET',
				dataType : 'json',
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
					
					getPasswordPolicy();
					
					// Display the custom popup message
	     			$("#popupMessage").text(data.message);
	      			$("#customPopup").show();
					
				},
				error : function(xhr, status, error) {
					// Handle the error response, if needed
					console.log("Error resetting password policy: " + error);
				},
		  });
		 
		 $("#closePopup").click(function () {
			    $("#customPopup").hide();
			  });
	 }
	 
	  
	 
	
	  function addRow() {
		    var table = document.getElementById('block-list');
		    
		    // Create a new row
		    var newRow = table.insertRow(table.rows.length - 1);

		    // Create cells for the new row
		    var cell1 = newRow.insertCell(0);
		    var cell2 = newRow.insertCell(1);
		    var cell3 = newRow.insertCell(2);

		    // Create input element for the new row
		    var input = document.createElement('input');
		    input.type = 'text';
		    input.name = 'blocked_password';
		    input.style.height = '10px';
		    input.style.width = '900px';

		    // Create delete button for the new row
		    var deleteBtn = document.createElement('input');
		    deleteBtn.type = 'button';
		    deleteBtn.value = 'X';
		    deleteBtn.className = 'deleteBtn';
		    deleteBtn.style.height = '22px';
		    deleteBtn.title = 'Remove block list entry';
		    deleteBtn.onclick = function () {
		        removeRow(this);
		    };

		    // Append input and delete button to cells
		    cell1.appendChild(input);
		    cell2.appendChild(document.createTextNode('')); // Empty cell
		    cell3.appendChild(deleteBtn);

		    // Move the "+" button row to the end
		 //   table.appendChild(table.rows[table.rows.length - 1]);
		}

		  function removeRow(button) {
		    var row = button.parentNode.parentNode;
		    row.parentNode.removeChild(row);
		  }
		  
		  function populateBlockList(passwordBlockedList) {
			    var table = document.getElementById('block-list');

			    // Clear existing rows and header
			    while (table.rows.length > 0) {
			        table.deleteRow(0);
			    }

			    // Add header row
			    var headerRow = table.insertRow(0);
			    var headerCell1 = headerRow.insertCell(0);
			    var headerCell2 = headerRow.insertCell(1);
			    var headerCell3 = headerRow.insertCell(2);
			   
			    headerRow.style.backgroundColor = '#e2e6f9';
			    headerCell1.innerHTML = '<b style="color: #283587;">Block Passwords</b>';
			    headerCell2.innerHTML = ''; // Empty cell
			    headerCell3.innerHTML = '<b style="color: #283587;">Actions</b>';

			    // Populate with new rows
			    for (var i = 0; i < passwordBlockedList.length; i++) {
			        var newRow = table.insertRow(i + 1);
			        var cell1 = newRow.insertCell(0);
			        var cell2 = newRow.insertCell(1);
			        var cell3 = newRow.insertCell(2);

			        cell1.innerHTML = '<input type="text" name="blocked_password" style="width: 900px; height: 10px;" value="' + passwordBlockedList[i] + '" />';
			        cell2.innerHTML = ''; // Empty cell
			        cell3.innerHTML = '<input type="button" value="X" class="deleteBtn" style="height: 22px;" title="Remove block list entry" onclick="removeRow(this)" />';
			    }

			    // Add an additional row with the "+" button
			    var addButtonRow = table.insertRow(table.rows.length);
			    var addButtonCell = addButtonRow.insertCell(0);
			    addButtonCell.innerHTML = '<input type="button" value="+" style="height: 22px;" title="Add block list entry" onclick="addRow()" />';
			}


		  
		  function getPasswordPolicy() {
			  $.ajax({
				  url : 'PasswordPolicyServlet',
					type : 'GET',
					dataType : 'json',
					success : function(data) {
						
						$('#min_char_count').val(data.characters_count);
						$('#min_asccii_char_count').val(data.ascii_ch_count);
						$('#min_num_count').val(data.number_count);
						$('#min_mix_char_count').val(data.mixed_ch_count);
						$('#allowed_spl_char').val(data.allowed_special_ch);
						$('#min_spl_char_count').val(data.special_ch_count);
						 var passwordBlockedList = data.password_blocked_list;
				            populateBlockList(passwordBlockedList);
						
					},
					error : function(xhr, status, error) {
						// Handle the error response, if needed
						console.log("Error loading password policy: " + error);
					},
			  });
			 }
		  
		// Function to show the loader
			 function showLoader() {
			     // Show the loader overlay
			     $('#loader-overlay').show();
			 }

			 // Function to hide the loader
			 function hideLoader() {
			     // Hide the loader overlay
			     $('#loader-overlay').hide();
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
			$('#resetPasswordPolicy').prop('disabled', true);
			$('#applyPassword').prop('disabled', true);		
			
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
	    }
		else{
			<%// Access the session variable
			HttpSession token = request.getSession();
			String tokenValue = (String) session.getAttribute("token");%>

			 tokenValue = '<%=tokenValue%>'; 
			
				// Load user list
				loadUserList();
				
				// Handle form submission
				$('#userForm').submit(function(event) {
					event.preventDefault();
					var buttonText = $('#registerBtn').val();
					var role = $('#role').find(":selected").val();
					var password = $('#password').val();
					var user_name = $('#username').val();
					var firstname = $('#first_name').val();
					var lastname = $('#last_name').val();


					 var isDisabledRole = $("#role").prop("disabled");
					 
					
					
				 var isDisabled = $("#password").prop("disabled");
									
					if (buttonText == 'Add') {
						addUser();
					} else if(buttonText == 'Update'){
						editUser();
					}else if(buttonText == 'Update Password'){
						editPassword();
					}
				});

				$('#clearBtn').click(function() {
				    var passwordInput = $('#password');
				    var passwordToggle = $('#password-toggle');

				    // Reset password input first
				    passwordInput.attr('type', 'password');
				    passwordToggle.html('<i class="fa fa-eye"></i>'); // Change to eye icon

				    $('#username').val('');
				    $("#username").prop("disabled", false);
				    $('#password').val('');
				    $("#password").prop("disabled", false);
				    $('#first_name').val('');
				    $("#first_name").prop("disabled", false);
				    $('#last_name').val('');
				    $("#last_name").prop("disabled", false);
				    $('#role').val('ADMIN');
				    $("#role").prop("disabled", false);
				    $('#registerBtn').val('Add');
				});

				
				  
				  $('#applyPassword').click(function() {
					  updatePasswordPolicy();
				  });
				  
				 
				  getPasswordPolicy();
				  
				  
				  $('#resetPasswordPolicy').click(function() {
					  resetPasswordPolicy();
					  
				  });
				  
				  $('#password-toggle').click(function () {
		                togglePassword();
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
				
		<div class="tab-container">
		
		 <button class="tab-button active" onclick="openTab('add-user', this)" style="margin-left: 16px; margin-top: 10px;">Add User</button>
    <button class="tab-button" onclick="openTab('password-policy', this)">Password Policy</button>
		
		<div id="add-user" class="tab" style="display: block; margin-left: 15px;">
		
		 <h3>ADD USER</h3>
			<hr />
			
			<div class="container">
				<form id="userForm">
				
				<input type="hidden" id="action" name="action" value="">
				
					<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>
		
		
				<table class="bordered-table" style="margin-top: -1px;">
					<tr>
						<td>Username</td>
						<td>
						<input type="text" id="username" name="username" required maxlength="31" style="height: 10px; max-width: 200px;"/>
								<p id="field_User_Error" class="error-message"></p>
						</td>
					
						<td>Password</td>
						<td>
						<input type="password" id="password" name="password" required maxlength="31" style="height: 10px; max-width: 200px;">
						 <span class="password-toggle" id="password-toggle"><i class="fa fa-eye"></i></span>
								<span id="passwordError" style="color: red;"></span>
								
						</td>
					</tr>
					
					<tr>			
						<td>First name</td>
						<td>
						<input type="text" id="first_name" name="first_name" maxlength="31" style="height: 10px; max-width: 200px;"/>
								
						</td>
						
						
						<td>Last name</td>
						<td>
						<input type="text" id="last_name" name="last_name"  maxlength="31" style="height: 10px; max-width: 200px;"/>
								
						</td>
					</tr>
							
					<tr>	
						<td>Role</td>
						<td>
						<select class="role" id="role" name="role" style="height: 33px; max-width: 200px;">
								
								<option value="ADMIN" selected>ADMIN</option>
								<option value="OPERATOR">OPERATOR</option>
						</select> <span style="color: red; font-size: 12px;" id="roleError"></span>
						</td>
						<td></td>
						<td></td>
					</tr>
				</table>
					
				<div class="row" style="display: flex; justify-content: center; margin-bottom: 2%; margin-top: 1%;">
					
					<input style="height: 26px;" type="button" value="Clear" id="clearBtn"/> 
					<input style="margin-left: 5px; height: 26px;" type="submit" value="Add" id="registerBtn" />
				</div>
				
				</form>
			
			<div id="custom-modal-delete" class="modal-delete">
				<div class="modal-content-delete">
				  <p>Are you sure you want to delete this user?</p>
				  <button id="confirm-button-delete">Yes</button>
				  <button id="cancel-button-delete">No</button>
				</div>
			  </div>
			  
			  <div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to modify this user?</p>
				  <button id="confirm-button-edit">Yes</button>
				  <button id="cancel-button-edit">No</button>
				</div>
			  </div>
			  
			   <div id="custom-modal-edit-password" class="modal-edit-password">
				<div class="modal-content-edit-password">
				  <p>Are you sure you want to change the password?</p>
				  <button id="confirm-button-edit-password">Yes</button>
				  <button id="cancel-button-edit-password">No</button>
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

</div>
<div class="table-container">
			<h3 style="margin-top: 15px;">USER LIST</h3>
			
			<hr />
				<table id="userListTable" style="width: 100%; margin-top: 5px;">
					<thead>
						<tr>
							<th>User name</th>
							<th>First name</th>
							<th>Last name</th>
							<th>Role</th>
							<th id="actions">Actions</th>
						</tr>
					</thead>
					<tbody>
						
					</tbody>
				</table>
			</div>
			 
		</div>
		
		 <div id="password-policy" class="tab">
		 
		 <div class="policy-container" style="width: 97%;">
		 <h3>Password Policy</h3>
		 <hr>
		 
		 <form id="passwordPolicyForm"  onsubmit="return false;">
		 
		 <input type="hidden" id="password_policy_action" name="password_policy_action" value="">
		 
		 <table class="bordered-table">
		 		
				<tr>
				<th colspan="3">Password Complexity rules</th>
				</tr>
				
				<tr>
				<td>Minimum alphabet characters count</td>
				<td><input type="text" id="min_asccii_char_count" name="min_asccii_char_count" style="height: 10px;"/></td>
				<td>Number of alphabet characters a new password must at least contain.</td>
				</tr>
				
				<tr>
				<td>Minimum mixed characters count (uppercase/lowercase)</td>
				<td><input type="text" id="min_mix_char_count" name="min_mix_char_count" style="height: 10px;"/></td>
				<td>Number of mixed-case characters a new password must at least contain. (uppercase/lowercase)</td>
				</tr>
				
				<tr>
				<td>Minimum numbers count</td>
				<td><input type="text" id="min_num_count" name="min_num_count" style="height: 10px;"/></td>
				<td>Number count a new password must at least contain.</td>
				</tr>
				
				<tr>
				<td>Minimum special characters count</td>
				<td><input type="text" id="min_spl_char_count" name="min_spl_char_count" style="height: 10px;"/></td>
				<td>Number of special characters a new password must at least contain.</td>
				</tr>
				
				<tr>
				<td>Allowed special characters</td>
				<td><input type="text" id="allowed_spl_char" name="allowed_spl_char" style="height: 10px;"/></td>
				<td>ASCII special characters that are allowed for the special character count rule.</td>
				</tr>
				
				<tr>
				<td>Minimum characters count</td>
				<td><input type="text" id="min_char_count" name="min_char_count" style="height: 10px;"/></td>
				<td>Number of characters a new password must at least contain in general.</td>
				</tr>
				 </table>
				
	<table id="block-list" style="border-left: 1px solid #ddd; border-right: 1px solid #ddd;">

	<tr>
	<th colspan="3">Blocked passwords</th>
	</tr>
  <tr>
    <td colspan="2"><input type="text" name="blocked_password" style="width: 900px; height: 10px;" /></td>
    <td><input type="button" value="X" class="deleteBtn" style="height: 22px;" title="Remove block list entry" onclick="removeRow(this)" /></td>
  </tr>

  <tr>
    <td><input type="button" value="+" style="height: 22px;" title="Add block list entry" onclick="addRow()" /></td>
  </tr>
</table>

	<div class="row" style="display: flex; justify-content: center; margin-bottom: 2%; margin-top: 1%;">
					
					 <input style="height: 26px;" type="button" value="Reset" id="resetPasswordPolicy"/> 
					<input style="margin-left: 5px; height: 26px;" type="submit" value="Apply" id="applyPassword" />
				</div>

		 </form>
		 </div>
		 
		 <div id="custom-modal-updatePasswordPolicy" class="modal-updatePasswordPolicy">
				<div class="modal-content-updatePasswordPolicy">
				  <p>Are you sure you want to modify this password policy?</p>
				  <button id="confirm-button-updatePasswordPolicy">Yes</button>
				  <button id="cancel-button-updatePasswordPolicy">No</button>
				</div>
			  </div>
			  
		 </div>
		</div>
			 
		</section>
	</div> 
	
	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>

</body>
</html>
