<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
<link rel="stylesheet" href="nav-bar.css" />

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
.modal-logout {
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

.modal-content-logout {
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

button {
  margin: 5px;
  padding: 10px 20px;
  border: none;
  cursor: pointer;
}

#confirm-button-logout {
  background-color: #4caf50;
  color: white;
}

#cancel-button-logout {
  background-color: #f44336;
  color: white;
}

</style>
<script>
var roleValue;

	function loadConfig() {
		$.ajax({
			url : 'loadConfigurationServlet',
			type : 'GET',
			dataType : 'json',
			success : function(data) {
				alert(data.status);

			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error: ' + error);
			}
		});
	}
	
	

	$(document).ready(function() {

		
	
	
		$('#loadConfig').click(function() {
			loadConfig();
		});
		
		$("#logoutBtn").click(function() {
			
            
            var modal = document.getElementById('custom-modal-logout');
  		  modal.style.display = 'block';

  		  // Handle the confirm button click
  		  var confirmButton = document.getElementById('confirm-button-logout');
  		  confirmButton.onclick = function () {

              $.ajax({
                  type: "POST",
                  url: "logout",
                  success: function(response) {
                	  // Close the modal
      		        modal.style.display = 'none';
                      // Handle the response, e.g., redirect to login page
                      window.location.href = "login.jsp";
                  },
                  error: function(xhr, status, error) {
                      console.log("Error: " + error);
                  }
              });
  			  
  		  };
  		  
  		// Handle the cancel button click
		  var cancelButton = document.getElementById('cancel-button-logout');
		  cancelButton.onclick = function () {
		    // Close the modal
		    modal.style.display = 'none';
		  };
        });

	});
</script>
<!-- <div class="header"> -->
<header>

	<div class="row"
		style="display: flex; justify-content: right; margin-top: 1%">
		<input style="margin-right: 10px;" type="button" id="loadConfig"
			value="Update Configuration" />
		<div>
			${username} <i class="fa fa-sign-out"
				style="font-size: 20px; margin-left: 5px" id="logoutBtn"></i>
		</div>
	</div>
	
	 <div id="custom-modal-logout" class="modal-logout">
				<div class="modal-content-logout">
				  <p>Are you sure you want to logout?</p>
				  <button id="confirm-button-logout">Yes</button>
				  <button id="cancel-button-logout">No</button>
				</div>
			  </div>
</header>

</head>

</html>