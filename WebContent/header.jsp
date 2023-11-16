<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">

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
	transform: translate(-50%, -50%);
	/* Center horizontally and vertically */
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

#notification-bell-count {
	color: red;
}


.badge {
	position: absolute;
	top: -7px; /* Adjust this value to position the badge as needed */
	right: 2px; /* Adjust this value to position the badge as needed */
	background-color: white;
	color: white;
	border-radius: 50%;
	padding: 5px 3px;
	font-size: 12px;
	font-weight: bold;
}

.modal-load-config {
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

.modal-content-load-config {
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

#confirm-button-load-config {
  background-color: #4caf50;
  color: white;
}

#cancel-button-load-config {
  background-color: #f44336;
  color: white;
}

.notification-container {
    position: relative;
    display: inline-block;
     
}

#loadConfig {
    height: 35px;
    margin-bottom: 10px;
    margin-right: 10px; /* Adjust the margin as needed */
    margin-top: -8px;
    margin-left: -10px;
    background-color: #f7f7f7;
}

.user-info {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-left: -10px; /* Adjust the margin as needed */
    margin-top: -10px;
}

#countdown {
    font-size: 13px;
    color: black;
    margin-right: 10px; /* Adjust the margin as needed */
    margin-left: 10px;
    margin-top: -10px;
}

#logoutBtn {
    margin-right: -4px;
    margin-left: 2px;
    margin-top: -15px;
}

.logout-container {
    display: flex;
    align-items: center;
}

#redirectButton{
margin-top: -5px;
background-color: #f7f7f7;
}

.center-container {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-grow: 1; /* Allow the container to grow and take available space */
        }

        .project_name {
            text-align: center;
        }
        
        #helpDropdown {
            position: relative;
            display: inline-block;
            margin-right: 20px; /* Adjust as needed */
        }

        .help-content {
            display: none;
            position: absolute;
            background-color: #f7f7f7;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            z-index: 1;
            padding: 10px;
            border-radius: 5px;
        }

        #helpDropdown:hover .help-content {
            display: block;
        }

</style>
<script>
var roleValu1e;

	function loadConfig() {
		
		// Display the custom modal dialog
		  var modal = document.getElementById('custom-modal-load-config');
		  modal.style.display = 'block';
		  
		// Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-load-config');
		  confirmButton.onclick = function () {
			  
			  $.ajax({
					url : 'loadConfigurationServlet',
					type : 'GET',
					dataType : 'json',
					success : function(data) {
						//alert(data.status);

						
						modal.style.display = 'none';
					},
					error : function(xhr, status, error) {
						// Handle the error response, if needed
						console.log('Error: ' + error);
					}
				});
		  };
		  
		  var cancelButton = document.getElementById('cancel-button-load-config');
		  cancelButton.onclick = function () {
		    // Close the modal
		    modal.style.display = 'none';
		  
		  };	
		
	}
	
	 function getProjectName(){
		 $.ajax({
			 
			 url : 'projectNameServlet',
				type : 'GET',
				dataType : 'json',
				success : function(data) {
					
				},
				error : function(xhr, status, error) {
					// Handle the error response, if needed
					console.log('Error: ' + error);
				}
			    
		 });
		
	} 
	
	function getProcessData1() {
		$.ajax({
			url : "processGetData",
			type : "POST", // Change the request type to POST
			data : { process_type: "process_count" },
			success : function(data) {
				var blackListCount = data.black_list_process_count;
				$('#notification-bell-count').text(blackListCount); // Update the notification bell count inside the span

			},
			error : function(xhr, status, error) {
				console.error("Error occurred: " + error);
				// Handle the error here (show error message to the user, etc.)
			}
		});
	}
	
	function changeButtonColor1(isDisabled) {
        var $load_conifg_button = $('#loadConfig'); 
       
        
         if (isDisabled) {
            $load_conifg_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $load_conifg_button.css('background-color', '#2b3991'); // Reset to original color
        }
         
    }
	
	
	function startCountdown() {
	    var countdownElement = document.getElementById('countdown');
	    var currentTime = new Date();
	    var logoutTime = new Date(currentTime.getTime() + 3599000); // Set logoutTime to 1 hour from the current time

	    function updateCountdownDisplay() {
	        var currentTime = new Date();
	        var timeDiff = logoutTime - currentTime;

	        if (timeDiff <= 0) {
	            // Redirect to "login.jsp" when the timer reaches 00:00
	            window.location.href = 'login.jsp';
	        } else {
	            var minutes = Math.floor(timeDiff / 60000); // Calculate minutes directly from timeDiff
	            var seconds = Math.floor((timeDiff % 60000) / 1000);

	            var countdownText = 'Logout in ' +
	                (minutes < 10 ? '0' : '') + minutes + ':' +
	                (seconds < 10 ? '0' : '') + seconds;
	            countdownElement.textContent = countdownText;
	        }
	    }

	    // Call updateCountdownDisplay immediately to avoid the "00:00" display
	    updateCountdownDisplay();

	    // Update the countdown every second
	    setInterval(updateCountdownDisplay, 1000);
	}



	$(document).ready(function() {
		
		<%// Access the session variable
		
		String roleValue1 = (String) session.getAttribute("role");%>
	
	roleValue1 = '<%=roleValue1%>';
	
	if (roleValue1 == 'VIEWER' || roleValue1 == 'Viewer') {

		
		$('#loadConfig').prop('disabled', true);
	
		
		changeButtonColor1(true);
	}
	
				startCountdown();
				getProcessData1();
				getProjectName();

				$('#loadConfig').click(function() {
					loadConfig();
				});

				$("#logoutBtn").click(
						function() {

							var modal = document
									.getElementById('custom-modal-logout');
							modal.style.display = 'block';

							// Handle the confirm button click
							var confirmButton = document
									.getElementById('confirm-button-logout');
							confirmButton.onclick = function() {

								$.ajax({
									type : "POST",
									url : "logout",
									success : function(response) {
										// Close the modal
										modal.style.display = 'none';
										// Handle the response, e.g., redirect to login page
										window.location.href = "login.jsp";
									},
									error : function(xhr, status, error) {
										console.log("Error: " + error);
									}
								});

							};

							// Handle the cancel button click
							var cancelButton = document
									.getElementById('cancel-button-logout');
							cancelButton.onclick = function() {
								// Close the modal
								modal.style.display = 'none';
							};
						});

			});
	document.addEventListener("DOMContentLoaded", function() {
		// Get the button element by its id
		var redirectButton = document.getElementById("redirectButton");
		// Add click event listener to the button
		redirectButton.addEventListener("click", function() {
			// Redirect the user to process.jsp page
			window.location.href = "process.jsp";
		});
	});
	setInterval(getProcessData1, 300000);
</script>


 <header>

	<div class="row" style="display: flex; justify-content: flex-end; align-items: center; margin-top: 0.5%">
	
	 <div id="helpDropdown">
            <button title="Help" style="border: none;"><b>Help</b></button>
            <div class="help-content">
                <p><a href="#">Option A</a></p>
                <p><a href="#">Option B</a></p>
                <p><a href="#">Option C</a></p>
            </div>
        </div>
        
	<div class="center-container">
            <div class="project_name">
                <p>Project Name - ${sys_appname}</p>
            </div>
        </div>
		
		<div class="notification-container">
    <button id="redirectButton" data-toggle="tooltip" class="editBtn"
        data-placement="top" title="Process"
        style="color: #35449a; height: 40px; padding: 0 10px;">
        <i class="material-icons" id="notification-bell" style="font-size: 24px;">notifications</i>
    </button>
    <span id="notification-bell-count" class="badge"
        style="height: 15px;">0</span>
</div>

<button style="height: 35px; margin-bottom: 10px;" id="loadConfig" title="Update Configuration">
    <i class="fa fa-upload" style="font-size: 20px; color: #35449a"></i>
</button>
	
		<div class="user-info">
    <div style="font-size: 15px;"> 
        ${username}
        <div style="font-size: 13px;">(Role - ${role})</div>
    </div>
    <div class="logout-container">
        <div id="countdown" style="font-size: 13px;"></div>
        <i class="fa fa-sign-out" style="font-size: 20px; cursor: pointer;" id="logoutBtn" title="Logout"></i>
    </div>
</div>
		
		
	</div>

	<div id="custom-modal-logout" class="modal-logout">
		<div class="modal-content-logout">
			<p>Are you sure you want to logout?</p>
			<button id="confirm-button-logout">Yes</button>
			<button id="cancel-button-logout">No</button>
		</div>
	</div>
	
	<div id="custom-modal-load-config" class="modal-load-config">
				<div class="modal-content-load-config">
				  <p>Are you sure you want to load configuration?</p>
				  <button id="confirm-button-load-config">Yes</button>
				  <button id="cancel-button-load-config">No</button>
				</div>
	 </div>
	
</header>
 
</head>

</html>