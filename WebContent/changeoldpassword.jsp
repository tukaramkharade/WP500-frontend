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
<link rel="stylesheet" href="nav-bar.css" />
<script src="jquery-3.6.0.min.js"></script>

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
        
.changePassword input[type="text"]
 {
    width: 85%;
    padding: 5px 0;
    
    margin-left: -3%;
}
       
 .changePassword input[type="password"]
 {
    width: 85%;
    padding: 5px 0;
   
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

#old_password_label{
margin-top: 15px;
}

h3{
margin-top: 68px;
}

.old_password_toggle {
        position: absolute;
        right: 41.8vw; /* Adjust the positioning as needed */
        top: 29.2%; /* Adjusted top to center the eye symbol */
        cursor: pointer;
    }
    
    .new_password_toggle {
        position: absolute;
        right: 41.8vw; /* Adjust the positioning as needed */
        top: 36.7%; /* Adjusted top to center the eye symbol */
        cursor: pointer;
    }
    
    .confirm_password_toggle {
        position: absolute;
        right: 41.8vw; /* Adjust the positioning as needed */
        top: 44%; /* Adjusted top to center the eye symbol */
        cursor: pointer;
    }

</style>
<script>

var user;

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
					
						// Close the modal
							modal.style.display = 'none';
						
						if(data.status === "success"){
							 window.location.href = 'login.jsp';
						}else if(data.status === "fail"){
							$("#popupMessage").text(data.message);
			      			$("#customPopup").show();
						}
						
						
				},
				error : function(xhr, status, error) {
					console.log('Error updating password: ' + error);
					modal.style.display = 'none';
				}
			});
			
			$("#closePopup").click(function () {
			    $("#customPopup").hide();
			  });
		};

		var cancelButton = document.getElementById('cancel-button-edit');
		cancelButton.onclick = function() {
			// Close the modal
			modal.style.display = 'none';
		};
	} else {
		
		$("#popupMessage").text('New password and confirm password do not match.');
			$("#customPopup").show();
		
	}
}

function toggleOldPassword() {
    var passwordInput = $('#old_password');
    var passwordToggle = $('#old_password_toggle');

    if (passwordInput.attr('type') === 'password') {
        passwordInput.attr('type', 'text');
        passwordToggle.html('<i class="fa fa-eye-slash"></i>');
    } else {
        passwordInput.attr('type', 'password');
        passwordToggle.html('<i class="fa fa-eye"></i>');
    }
}

function toggleNewPassword() {
    var passwordInput = $('#new_password');
    var passwordToggle = $('#new_password_toggle');

    if (passwordInput.attr('type') === 'password') {
        passwordInput.attr('type', 'text');
        passwordToggle.html('<i class="fa fa-eye-slash"></i>');
    } else {
        passwordInput.attr('type', 'password');
        passwordToggle.html('<i class="fa fa-eye"></i>');
    }
}

function toggleConfirmPassword() {
    var passwordInput = $('#confirm_password');
    var passwordToggle = $('#confirm_password_toggle');

    if (passwordInput.attr('type') === 'password') {
        passwordInput.attr('type', 'text');
        passwordToggle.html('<i class="fa fa-eye-slash"></i>');
    } else {
        passwordInput.attr('type', 'password');
        passwordToggle.html('<i class="fa fa-eye"></i>');
    }
}

function getPasswordInfo(){
	$.ajax({
		 
		 url : 'ChangePasswordServlet',
			type : 'GET',
			dataType : 'json',
			success : function(data) {
				
	            $("#characters_count").text("1. Minimum "+data.characters_count+" character count");
	            $("#ascii_ch_count").text("2. Minumum "+data.ascii_ch_count+" alphabet count");
	            $("#number_count").text("3. Minimum "+data.number_count+" number count");
	            $("#mixed_ch_count").text("4. Minimum "+data.mixed_ch_count+" mixed character count");
	            $("#special_ch_count").text("5. Minimum "+data.special_ch_count+" special character count");
	            $("#allowed_special_ch").text("6. "+data.allowed_special_ch+" allowed special characters");
	            
			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error: ' + error);
			}
		    
	 });
}


$(document).ready(function () {
	<%// Access the session variable
	
	String user = (String) session.getAttribute("username");%>

	user = '<%=user%>';
	
	// Set the value of the 'username' input field to the 'user' variable
    $('#username').val(user);
	
 // Add a "keyup" event listener to the new_password input field
    $('#new_password').on('keyup', function() {
        var new_password = $(this).val();
        var old_password = $('#old_password').val();
        var messageSpan = $('#newPasswordMessage');
        
        if (new_password === old_password) {
            // Display a message in the message span
            messageSpan.text('The new password is same as the old password. Please try with a new password.');
            $(this).css('border', '2px solid red'); // You can use different styling
        } else {
            // Clear the message and reset the styling
            messageSpan.text('');
            $(this).css('border', ''); // Remove the red border
        }
    });
	
    getPasswordInfo();
 
    	$('#changePasswordForm').submit(function(event) {
    		event.preventDefault(); // Prevent the default form submission
    		
    		if((old_password.length > 30)){
                field_Old_Pass_Error.textContent = "You can write upto 30 maximum characters."
                	return;
            }else{
                field_Old_Pass_Error.textContent =""
            }  
    		
    		if((new_password.length > 30)){
                field_New_Pass_Error.textContent = "You can write upto 30 maximum characters."
                	return;
            }else{
                field_New_Pass_Error.textContent =""
            }  
    		
    		if((confirm_password.length > 30)){
                field_Confirm_Pass_Error.textContent = "You can write upto 30 maximum characters."
                	return;
            }else{
                field_Confirm_Pass_Error.textContent =""
            }  
    		updateOldPassword();
    	});
    
	$("#closePopup").click(function () {
	    $("#customPopup").hide();
	  });
	
	$('#old_password_toggle').click(function () {
        toggleOldPassword();
    });
	
	$('#new_password_toggle').click(function () {
        toggleNewPassword();
    });
	
	$('#confirm_password_toggle').click(function () {
        toggleConfirmPassword();
    });
	});

</script>

<body>
	
	<div class="content1">
		<section style="margin-left: 1em">
			<h3>RESET PASSWORD</h3>
			<hr>

			<div class="container">
			
				<form id="changePasswordForm" class="changePassword">

				<label for="username" style="float: left;">Username</label>
				<input required type="text" id="username" name="username" style="padding-left: 5px;"><br>

				<label for="old_password" style="float: left;" id="old_password_label">Old password</label>
				<input required type="password" id="old_password" name="old_password" style="padding-left: 5px;">
				<span class="old_password_toggle" id="old_password_toggle"><i class="fa fa-eye"></i></span> 
				
				<p id="field_Old_Pass_Error" style="color: red;"></p>
				
				<label for="new_password" style="float: left;">New password</label> 
				<input required type="password" id="new_password" name="new_password" style="padding-left: 5px;">
				 <span class="new_password_toggle" id="new_password_toggle"><i class="fa fa-eye"></i></span> 
				<p id="field_New_Pass_Error" style="color: red;"></p> 
				
				<!-- Add a span to display the message -->
				<span id="newPasswordMessage" style="color: red;"></span>
					
				<label for="confirm_password" style="float: left;">Confirm password</label> 
				<input required type="password" id="confirm_password" name="confirm_password" style="padding-left: 5px;"> 
				 <span class="confirm_password_toggle" id="confirm_password_toggle"><i class="fa fa-eye"></i></span> 
				<p id="field_Confirm_Pass_Error" style="color: red;"></p>
					
				<input type="submit" value="Submit" id="change_password">

			</form>
			
			
			</div>
			
			<span style="color: red;"><b>Password policies to be followed while entering new password</b></span><br>
			<span id="characters_count"></span><br>
			<span id="ascii_ch_count"></span><br>
			<span id="number_count"></span><br>
			<span id="mixed_ch_count"></span><br>
			<span id="special_ch_count"></span><br>
			<span id="allowed_special_ch"></span>
			
			  <div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to reset password?</p>
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