<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
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

.modal-edit,
.modal-factoryreset,
.modal-session-timeout {
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

.modal-content-edit,
.modal-content-factoryreset,
.modal-content-session-timeout {
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

#confirm-button-edit,
#confirm-button-factoryreset,
#confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
}

#cancel-button-edit,
#cancel-button-factoryreset {
  background-color: #f44336;
  color: white;
}

h3{
margin-top: 68px;
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

</style>
<script>

var roleValue;	
var tokenValue;

	function reboot() {

		// Display the custom modal dialog
		  var modal = document.getElementById('custom-modal-edit');
		  modal.style.display = 'block';
		  
		// Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-edit');
		  confirmButton.onclick = function () {
			  
			  $.ajax({
					url : 'reboot',
					type : 'GET',
					dataType : 'json',
					beforeSend: function(xhr) {
				        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
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

					},
					error : function(xhr, status, error) {
						// Handle the error response, if needed
						console.log('Error: ' + error);
					}
				});
			  
		  };
		  var cancelButton = document.getElementById('cancel-button-edit');
		  cancelButton.onclick = function () {
		    // Close the modal
		    modal.style.display = 'none';
		   
		  };	
	}
	
	
	function factoryReset() {

		// Display the custom modal dialog
		  var modal = document.getElementById('custom-modal-factoryreset');
		  modal.style.display = 'block';
		  
		// Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-factoryreset');
		  confirmButton.onclick = function () {
			  
			  $.ajax({
					url : 'factoryResetServlet',
					type : 'GET',
					dataType : 'json',
					beforeSend: function(xhr) {
				        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
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
						
						$("#popupMessage").text(data.message);
		      			$("#customPopup").show();
		      			

					},
					error : function(xhr, status, error) {
						// Handle the error response, if needed
						console.log('Error: ' + error);
					}
				});
			  
		  };
		  
		  $("#closePopup").click(function () {
			    $("#customPopup").hide();
			  });
		  
		  var cancelButton = document.getElementById('cancel-button-factoryreset');
		  cancelButton.onclick = function () {
		    // Close the modal
		    modal.style.display = 'none';
		   
		  };	
	}

	
	function changeButtonColor(isDisabled) {
        var $reboot_button = $('#reboot');
        var $factory_reset_button = $('#factory_reset');
        
        if (isDisabled) {
            $reboot_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $reboot_button.css('background-color', '#2b3991'); // Reset to original color
        }
        
        if (isDisabled) {
            $factory_reset_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $factory_reset_button.css('background-color', '#2b3991'); // Reset to original color
        }
	}

	$(document).ready(function() {

		<%
    	// Access the session variable
    	HttpSession role = request.getSession();
    	String roleValue = (String) session.getAttribute("role");
    	%>
    	
    	roleValue = '<%= roleValue %>';
    	
    	
    	if(roleValue == 'OPERATOR' || roleValue == 'Operator'){
  		  
  		$('#reboot').prop('disabled', true);
  		$('#factory_reset').prop('disabled', true);
  		  
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
	    }else{
	    	<%// Access the session variable
	    	HttpSession token = request.getSession();
	    	String tokenValue = (String) session.getAttribute("token");%>

	    	tokenValue = '<%=tokenValue%>';
	    	
	    	$('#reboot').click(function() {
				reboot();

			});
	    	
	    	$('#factory_reset').click(function() {
	    		factoryReset();

			});
	    }
    	
		

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
		<h3>REBOOT</h3>
		<hr>

		<div class="container">

			<input type="button" id="reboot" value="Reboot" />
		</div>
		
		
		<h3>FACTORY RESET</h3>
		<hr>
		<div class="container">
		<input type="button" id="factory_reset" value="Factory Reset" />
		</div>
		
		 <div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to reboot?</p>
				  <button id="confirm-button-edit">Yes</button>
				  <button id="cancel-button-edit">No</button>
				</div>
			  </div>
			  
			   <div id="custom-modal-factoryreset" class="modal-factoryreset">
				<div class="modal-content-factoryreset">
				  <p>Are you sure you want to do factory reset?</p>
				  <button id="confirm-button-factoryreset">Yes</button>
				  <button id="cancel-button-factoryreset">No</button>
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
			  
		</section>
	</div>

	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>