<%
    response.setHeader("X-Frame-Options", "DENY");
    response.setHeader("X-Content-Type-Options", "nosniff");
%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="nav-bar.css" />
<script src="jquery-3.6.0.min.js"></script>
<link href="css_files/material.css" rel="stylesheet">
<link rel="stylesheet" href="css_files/all.min.css">
<link rel="stylesheet" href="css_files/fontawesome.min.css">
<style>
.modal-logout,
.modal-load-config,
.modal-session-timeout {
	display: none;
	position: fixed;
	z-index: 1000;
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

.modal-content-logout,
.modal-content-load-config,
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
	transform: translate(-50%, -50%);
	/* Center horizontally and vertically */
}

button {
	margin: 5px;
	padding: 10px 20px;
	border: none;
	cursor: pointer;
}

#confirm-button-logout,
#confirm-button-load-config,
#confirm-button-session-timeout {
	background-color: #4caf50;
	color: white;
}

#cancel-button-logout,
#cancel-button-load-config  {
	background-color: #f44336;
	color: white;
}

#notification-bell-count {
	color: red;
}

.badge {
	position: absolute;
	top: -8px; /* Adjust this value to position the badge as needed */
	right: 8px; /* Adjust this value to position the badge as needed */
	background-color: white;
	color: white;
	border-radius: 50%;
	padding: 5px 3px;
	font-size: 12px;
	font-weight: bold;
}

#cyberguard-bell-count {
	color: red;
}

.cyberguard-badge {
	position: absolute;
	top: -8px; /* Adjust this value to position the badge as needed */
	right: 15px; /* Adjust this value to position the badge as needed */
	background-color: white;
	color: white;
	border-radius: 50%;
	padding: 5px 3px;
	font-size: 12px;
	font-weight: bold;
}

.notification-container {
    position: relative;
    display: inline-block;     
}

.cyberguard-notification-container {
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

#redirectButtonCyberguard{
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

button {
  margin: 5px;
  padding: 10px 20px;
  border: none;
  cursor: pointer;
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
var roleValue1;
var csrfTokenValue1;

	function loadConfig() {		
		  var modal = document.getElementById('custom-modal-load-config');
		  modal.style.display = 'block';		  
		  var confirmButton = document.getElementById('confirm-button-load-config');
		  confirmButton.onclick = function () {		  
			  $.ajax({
					url : 'loadConfigurationServlet',
					type : 'GET',
					dataType : 'json',
					success : function(data) {						
						modal.style.display = 'none';						
						$("#popupMessage").text(data.status);
		      			$("#customPopup").show();	      				      			
					},
					error : function(xhr, status, error) {					
					}
				});
		  };	  
		  $("#closePopup").click(function () {
			    $("#customPopup").hide();
			  });		  
		  var cancelButton = document.getElementById('cancel-button-load-config');
		  cancelButton.onclick = function () {
		    modal.style.display = 'none';		  
		  };			
	}
	
	 function getProjectName(){
		 $.ajax({	 
			 url : 'projectNameServlet',
				type : 'GET',
				dataType : 'json',
				success : function(data) {
					var projectName = data.sys_appname;
		            $(".project_name p").text("Project Name - " + projectName);
				},
				error : function(xhr, status, error) {					
				}		    
		 });	
	} 
	
	function getProcessData1() {
		 var csrfToken = document.getElementById('csrfToken').value;
			$.ajax({
			url : "processGetData",
			type : "POST", // Change the request type to POST
			data : { 
				process_type: "process_count",
				csrfToken: csrfToken				
				},
			success : function(data) {
				var blackListCount = data.black_list_process_count;
				$('#notification-bell-count').text(blackListCount); // Update the notification bell count inside the span
			},
			error : function(xhr, status, error) {
				console.error("Error occurred: " + error);
			}
		});
	}
	
	function getActiveThreatsCount() {
		$.ajax({
			url : "countDetailsServlet",
			type : "GET", // Change the request type to POST
			dataType : "json",			
			success : function(data) {				
				var activeThreatsCount = data.active_threats_count;
				$('#cyberguard-bell-count').text(activeThreatsCount); // Update the notification bell count inside the span				
			},
			error : function(xhr, status, error) {
				console.error("Error occurred: " + error);
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
	        	  window.location.replace('login.jsp'); 	        
	        } else {
	            var minutes = Math.floor(timeDiff / 60000); // Calculate minutes directly from timeDiff
	            var seconds = Math.floor((timeDiff % 60000) / 1000);
	            var countdownText = 'Logout in ' +
	                (minutes < 10 ? '0' : '') + minutes + ':' +
	                (seconds < 10 ? '0' : '') + seconds;
	            countdownElement.textContent = countdownText;
	        }
	    }
	    updateCountdownDisplay();
	    setInterval(updateCountdownDisplay, 1000);
	} 

	$(document).ready(function() {	
		<%// Access the session variable	
		String roleValue1 = (String) session.getAttribute("role");%>
		roleValue1 = '<%=roleValue1%>';
	<%// Access the session variable
	
	String csrfTokenValue1 = (String) session.getAttribute("csrfToken");%>
	csrfTokenValue1 = '<%=csrfTokenValue1%>';
	
	if (roleValue1 == 'OPERATOR' || roleValue1 == 'Operator') {		
		$('#loadConfig').prop('disabled', true);		
		changeButtonColor1(true);
	}
			startCountdown();
				getProcessData1();
				getProjectName();
				getActiveThreatsCount();
				$('#loadConfig').click(function() {
					loadConfig();
				});					
				$("#logoutBtn").click(function() {
							var modal = document.getElementById('custom-modal-logout');
							modal.style.display = 'block';
							var confirmButton = document.getElementById('confirm-button-logout');
							confirmButton.onclick = function() {
								$.ajax({
									type : "GET",
									url : "logout",
									dataType : 'json',
									success : function(response) {
										modal.style.display = 'none';								
										  window.location.replace('login.jsp'); 
									},
									error : function(xhr, status, error) {									
									}
								});
							};
							var cancelButton = document.getElementById('cancel-button-logout');
							cancelButton.onclick = function() {
								modal.style.display = 'none';
							};
						});
			});
	document.addEventListener("DOMContentLoaded", function() {
		var redirectButton = document.getElementById("redirectButton");
		redirectButton.addEventListener("click", function() {
			window.location.href = "process.jsp";
		});
	});
	setInterval(getProcessData1, 300000);		
 document.addEventListener("DOMContentLoaded", function() {
	var redirectButton = document.getElementById("redirectButtonCyberguard");
	redirectButton.addEventListener("click", function() {
		window.location.href = "dashboard.jsp";
	});
}); 
 setInterval(getActiveThreatsCount, 300000);	
</script>
 <header>
	<div class="row" style="display: flex; justify-content: flex-end; align-items: center; margin-top: 0.5%">
	<input type="hidden" name="csrfToken" id="csrfToken" value="<%= csrfTokenValue1 %>" />
	 <div id="helpDropdown">
    <a href="https://support.tasind.com/" target="_blank" title="Help" style="text-decoration: none; color: inherit;">
        <button style="border: none;"><b>Help</b></button>
    </a>
</div>    
	<div class="center-container">
            <div class="project_name">
                <p></p>
            </div>
        </div>		
		<div class="cyberguard-notification-container">
    <button id="redirectButtonCyberguard" data-toggle="tooltip" class="editBtn"
        data-placement="top" title="Cyberguard" style="color: #35449a; height: 40px; padding: 0 10px;">
        <i class="material-icons" id="warning" style="font-size: 24px;">warning</i>
    </button>
    <span id="cyberguard-bell-count" class="cyberguard-badge" style="height: 15px;">0</span>
</div>	
		<div class="notification-container">
    <button id="redirectButton" data-toggle="tooltip" class="editBtn" data-placement="top" title="Process"
        style="color: #35449a; height: 40px; padding: 0 10px;">
        <i class="material-icons" id="notification-bell" style="font-size: 24px;">notifications</i>
    </button>
    <span id="notification-bell-count" class="badge" style="height: 15px;">0</span>
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
			  <div id="customPopup" class="popup">
  				<span class="popup-content" id="popupMessage"></span>
  				<button id="closePopup">OK</button>
			  </div>
</header>
</head>
</html>