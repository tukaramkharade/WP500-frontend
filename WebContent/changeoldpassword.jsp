

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

#confirm-button-edit {
  background-color: #4caf50;
  color: white;
}

#cancel-button-edit {
  background-color: #f44336;
  color: white;
}

.container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
}

.changePassword {
  width: 28em;
  border-radius: 30px;
  background-color: #ffffff8f;
  padding: 30px; /* Use padding instead of padding-bottom for spacing */
  text-align: center;
}
       
.changePassword label {
   display: block;
   text-align: left;
   margin-left: 5.5%;
}
        
.changePassword input[type="text"],
.changePassword input[type="password"] {
    width: 85%;
    padding: 5px 0;
    margin-bottom: 10px;
    margin-left: -3%;
}
        
.changePassword input[type="submit"] {
    padding: 5px 140px;
    font-size: medium;
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
  width: 25%;
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

</style>
<script>

var changePasswordValue;

function updateOldPassword() {
	
	
	// Get the values of new_password and confirm_password
	var new_password = $('#new_password').val();
	var confirm_password = $('#confirm_password').val();
	 var old_password = $('#old_password').val();

	
	 if (new_password === confirm_password) {
		// Display the custom modal dialog
		var modal = document.getElementById('custom-modal-edit');
		modal.style.display = 'block';

		// Handle the confirm button click
		var confirmButton = document.getElementById('confirm-button-edit');
		confirmButton.onclick = function() {
			var username = $('#username').val();
			var old_password = $('#old_password').val();
			var new_password = $('#new_password').val();

			$.ajax({
				url : 'ChangePasswordServlet',
				type : 'POST',
				data : {
					username : username,
					old_password : old_password,
					new_password : new_password
					
				},
				success : function(data) {
					
					 if (old_password === new_password) {
					      //  showCustomPopup(data.message);
				
							$("#popupMessage").text(data.message);
								$("#customPopup").show();
								
								 $('#confirm_password').val('');
								 $('#new_password').val('');
					 }else{
						 
							
						 window.location.href = 'login.jsp';
					 }
					
					// Close the modal
					modal.style.display = 'none';
					
				},
				error : function(xhr, status, error) {
					console.log('Error updating user: ' + error);
					modal.style.display = 'none';
				}
			});
		};

		var cancelButton = document.getElementById('cancel-button-edit');
		cancelButton.onclick = function() {
			// Close the modal
			modal.style.display = 'none';
		};
	} else {
		
		//showCustomPopup('New password and confirm password do not match.');
		
		$("#popupMessage").text('New password and confirm password do not match.');
			$("#customPopup").show();
		
	}
}

$(document).ready(function () {
	
	 <%// Access the session variable
	
	Boolean changePasswordValue = (Boolean) session.getAttribute("password_set");%>

	changePasswordValue = '<%=changePasswordValue%>'; 
	
	// Check if password_set is not set or is false, then redirect to another page
    if (!changePasswordValue || changePasswordValue === 'false') {
        window.location.href = 'changeoldpassword.jsp';
    }
	
	
	$('#changePasswordForm').submit(function(event) {
		event.preventDefault(); // Prevent the default form submission
		updateOldPassword();
	});
	
	$("#closePopup").click(function () {
	    $("#customPopup").hide();
	  });

});

</script>
</head>
<body>

	
	
	<div class="content1">
		<section style="margin-left: 1em">
			<h3>CHANGE PASSWORD</h3>
			<hr>

			<div class="container">
			
				<form id="changePasswordForm" class="changePassword">

				<p style="font-size: medium;">Please change your old password</p>
				

				<label for="username" style="float: left;">Username:</label>
				 <input required type="text" id="username" name="username"><br>

				<label for="old_password" style="float: left;">Old password:</label>
				
				<input required type="password" id="old_password" name="old_password" > 
					
					<label for="new_password" style="float: left;">New password:</label> 
					<input required type="password" id="new_password" name="new_password" > 
					<label for="confirm_password" style="float: left;">Confirm password:</label> 
					<input required type="password" id="confirm_password" name="confirm_password" > 
					<input type="submit" value="Submit" id="change_password">

			</form>
			
			</div>
			
			  <div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to edit password of this user?</p>
				  <button id="confirm-button-edit">Yes</button>
				  <button id="cancel-button-edit">No</button>
				</div>
			  </div>
			  
			  <div id="customPopup" class="popup">
  				<span class="popup-content" id="popupMessage"></span>
  				<button id="closePopup">OK</button>
			  </div>
			
		</section>
	</div>
	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>

</body>
</html>