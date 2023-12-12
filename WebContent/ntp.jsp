<!DOCTYPE html>
<html>
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32"
	href="images/WP_Connex_logo_favicon.png" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

<style type="text/css">
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

#close-popup:hover {
  background-color: #1f2b6d;
}

.modal-session-timeout,
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

.modal-content-session-timeout,
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

.btn_discard_0 {
	padding: 5px 10px;
	background-color: #ef0803;
	color: white;
	border: none;
	width: 85px;
	height: 30px;
	border-radius: 4px;
	cursor: pointer;
}

.btn_change_0 {
	margin-top: 10px;
	margin-bottom: 10px;
	padding: 5px 10px;
	background-color: #6c45ed;
	color: white;
	border: none;
	width: 185px;
	height: 30px;
	border-radius: 4px;
	cursor: pointer;
}

input[type="text"] input[type="password"] {
	width: 400px;
	min-height: 80px;
	padding: 5px;
	border: 1px solid #ccc;
	border-radius: 4px;
}

table {
	border-collapse: collapse;
	width: 100%;
}

th, td {
	padding: 8px;
	text-align: left;
	border-bottom: 1px solid #ddd;
}

tr th {
	background-color: #e2e6f9;
	color: #283587;
}

h2 {
	color: #283587;
}

.text {
	height: 30px;
}

.toggle {
	position: relative;
	display: block;
	width: 55px;
	height: 25px;
	padding: 3px;
	border-radius: 50px;
	cursor: pointer;
}

.toggle-input {
	position: absolute;
	top: 0;
	left: 0;
	opacity: 0;
}

.toggle-label {
	position: relative;
	display: block;
	height: inherit;
	font-size: 12px;
	background: red;
	border-radius: 25px; /* Adjust the value to control the roundness */
	box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.12), inset 0 0 3px
		rgba(0, 0, 0, 0.15);
}

.toggle-label:before, .toggle-label:after {
	position: absolute;
	top: 50%;
	color: black;
	margin-top: -.5em;
	line-height: 1;
}

.toggle-label:before {
	content: attr(data-off); /* Display the "OFF" label */
	right: 5px;
	color: #fff;
	text-shadow: 0 1px rgba(255, 255, 255, 0.5);
}

.toggle-label:after {
	content: attr(data-on); /* Display the "ON" label */
	left: 7px;
	color: #fff;
	text-shadow: 0 1px rgba(0, 0, 0, 0.2);
	opacity: 0;
}

.toggle-input:checked ~.toggle-label {
	background: green;
}

.toggle-input:checked ~.toggle-label:before {
	opacity: 0;
}

.toggle-input:checked ~.toggle-label:after {
	opacity: 1;
}

.toggle-handle {
	position: absolute;
	top: 4px;
	left: 2px;
	width: 25px;
	height: 25px;
	background: linear-gradient(to bottom, #FFFFFF 40%, #f0f0f0);
	border-radius: 50%;
}

.toggle-handle:before {
	position: absolute;
	top: 50%;
	left: 50%;
	margin: -6px 0 0 -6px;
	width: 10px;
	height: 10px;
}

.toggle-input:checked ~.toggle-handle {
	left: 33px;
	box-shadow: -1px 1px 5px rgba(0, 0, 0, 0.2);
}

/* Transition*/
.toggle-label, .toggle-handle {
	transition: All 0.3s ease;
	-webkit-transition: All 0.3s ease;
	-moz-transition: All 0.3s ease;
	-o-transition: All 0.3s ease;
}

.dhcp_btn {
	background-color: #6c45ed;
	border-radius: 4px;
	color: white;
	border: none;
	width: 100px;
	height: 25px;
	cursor: pointer;
}

.center {
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100vh;
	flex-direction: column;
}

.switch {
	position: relative;
	display: inline-block;
	width: 60px;
	height: 34px;
}

.switch input {
	opacity: 0;
	width: 0;
	height: 0;
}

.slider {
	position: absolute;
	cursor: pointer;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-color: #ccc;
	-webkit-transition: .4s;
	transition: .4s;
}

.slider:before {
	position: absolute;
	content: "";
	height: 25px;
	width: 27px;
	left: -2px;
	bottom: 0px;
	background-color: white;
	-webkit-transition: .4s;
	transition: .4s;
}

input:checked+.slider {
	background-color: #2196F3;
}

input:focus+.slider {
	box-shadow: 0 0 1px #2196F3;
}

input:checked+.slider:before {
	-webkit-transform: translateX(26px);
	-ms-transform: translateX(26px);
	transform: translateX(26px);
}

/* Rounded sliders */
.slider.round {
	border-radius: 100px;
	height: 25px;
	width: 50px;
}

.slider.round:before {
	border-radius: 50%;
}
/* p {
    font-weight: bold;
    font-size: 16px; 
 } */

#confirm-button-session-timeout,
#confirm-button-edit {
  background-color: #4caf50;
  color: white;
}

button {
  margin: 5px;
  padding: 10px 20px;
  border: none;
  cursor: pointer;
}

#cancel-button-edit {
  background-color: #f44336;
  color: white;
}

h3{
margin-top: 68px;
}

.bordered-table {
  border-collapse: collapse; /* Optional: To collapse table borders */
  margin: 0 auto; /* Center the table horizontally */
}

.bordered-table td {
  border: 1px solid #ccc; /* Light gray border */
 
}

   .form-container {
    margin: 0 auto;
    width: 50%;
    border-collapse: collapse;
    background-color: #f2f2f2;
     border-radius: 5px;
  padding: 20px;
  }
  
</style>
<script>
var roleValue;
var tokenValue;

	// Function to fetch current time from the server and update the button text
	function getCurrentTime() {
		$.ajax({
			url : "ntpLiveTime", // Replace with your server endpoint to get the current time
			type : "GET",
			dataType : "json",
			success : function(data) {
				// Update the <p> tags with the fetched time data
				$("#ist_time").text("IST Time: " + data.IST_Time);
				$("#utc_time").text("UTC Time: " + data.UTC_Time);
			},
			error : function(xhr, status, error) {
				// Handle any errors that occur during the AJAX request
				console.error("Error fetching current time:", status, error);
			}
		});
	}
	
	
	function getNtpDetails() {

		
			$.ajax({
				url: 'ntp',
				type: 'GET',
				dataType: 'json',
				beforeSend: function(xhr) {
					xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
				},
				success: function(data) {
				
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
					document.getElementById('ntp-service-cell').textContent = data.ntp_service;	               

					
				},

				error : function(xhr, status, error) {
					console.log('Error: ' + error);
				}
			});

		}
	function getOverviewData() {

		$.ajax({

			url : 'overviewGetData',
			type : 'GET',
			dataType : 'json',
			beforeSend : function(xhr) {
				xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
			},
			success : function(data) {

				if (data.status == 'fail') {
					var modal = document
							.getElementById('custom-modal-session-timeout');
					modal.style.display = 'block';

					// Handle the confirm button click
					var confirmButton = document
							.getElementById('confirm-button-session-timeout');
					confirmButton.onclick = function() {

						// Close the modal
						modal.style.display = 'none';
						window.location.href = 'login.jsp';
					};
				} else {	                
	                document.getElementById('system-clock-cell').textContent = data.NTP_SYNC_STATUS;
	            }
				
			},

			error : function(xhr, status, error) {
				console.log('Error loading opcua client data: ' + error);
			}

		});

	}


		function updatentp() {
		
		var ntp_client = $("#ntp_client").prop("checked") ? "1" : "0";
		
		$.ajax({
			url : "ntp",
			type : "POST",
			data : {
				ntp_client : ntp_client
				
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
      			
				
			
				// Clear form fields
				$("#ntp_client").val("");
	
			},
			error : function(xhr, status, error) {
				console.log("Error adding ntp: " + error);
			},
		});

		$("#updatentp").val("Add");
	}
	
	function loadNtpSettings() {
		$.ajax({
			url : 'ntpDataUpadate',
			type : 'GET',
			dataType : 'json',
			beforeSend: function(xhr) {
		        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
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
				
				$('#ntp_server1').val(data.ntp_server1);
				$('#ntp_server2').val(data.ntp_server2);
				$('#ntp_server3').val(data.ntp_server3);
				$('#ntp_interval_1').val(data.ntp_interval);

			
			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error: ' + error);
			}
		});
	}

	function editNtpData() {
		
		// Display the custom modal dialog
		  var modal = document.getElementById('custom-modal-edit');
		  modal.style.display = 'block';
		  
		// Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-edit');
		  confirmButton.onclick = function () {
			  var ntp_server1 = $('#ntp_server1').val();
			    var ntp_server2 = $('#ntp_server2').val();
			    var ntp_server3 = $('#ntp_server3').val();
			    var ntp_interval = $('#ntp_interval_1').val();
			    var isValid=true;
			   
			    
			    $.ajax({
			        url: 'ntpDataUpadate',
			        type: 'POST',
			        data: {
			            ntp_server1: ntp_server1,
			            ntp_server2: ntp_server2,
			            ntp_server3: ntp_server3,
			            ntp_interval: ntp_interval
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
			        	
			        	modal.style.display = 'none';

			            // Clear fields here if needed
			            $('#ntp_server1').val('');
			            $('#ntp_server2').val('');
			            $('#ntp_server3').val('');
			            $('#ntp_interval_1').val('');
			        },
			        error: function (xhr, status, error) {
			            console.log('Error updating lan: ' + error);
			        }
			    });
			  
		  };
		  
		  var cancelButton = document.getElementById('cancel-button-edit');
		  cancelButton.onclick = function () {
		    // Close the modal
		    modal.style.display = 'none';
		   
		  };	
		
	}


	function toggleNtpClient() {
		var toggleButton = document.getElementById("ntp_client");
		var ipField = document.getElementById("ntp_interval");
		var serverField = document.getElementById("ntp_server");

		if (toggleButton.checked) {
			ipField.disabled = false;
			serverField.disabled = false;
			toggleButton.value = "1"; //ntp_client_enable
		} else {
			ipField.disabled = true;
			serverField.disabled = true;
			toggleButton.value = "0"; //ntp_client_disable
		}

		toggleDateTimeInput();
	}

	function setManualTime() {

		var datetime = $('#datetime').val();
		if (datetime === '') {
			
				// Display the custom popup message
     			$("#popupMessage").text('Please enter a valid date and time.');
      			$("#customPopup").show();
	        return; // Prevent the AJAX request
	    }

		$.ajax({
			url : 'dateTimeServlet',
			type : 'POST',
			data : {
				datetime : datetime

			},
			success : function(data) {
				
				// Display the custom popup message
     			$("#popupMessage").text(data.message);
      			$("#customPopup").show();

				// Clear form fields
				getCurrentTimeInIndia();
				//$('#datetime').val('');

			},
			error : function(xhr, status, error) {
				console.log('Error setting manual time: ' + error);
			}
		});

	}

	function toggleDateTimeInput() {
		var ntpClientCheckbox = document.getElementById("ntp_client");
		var datetimeInput = document.getElementById("datetime");
		var dateTimeButton = document.getElementById("setDateTime");

		datetimeInput.disabled = ntpClientCheckbox.checked;
		dateTimeButton.disabled = ntpClientCheckbox.checked;
		
	}
	
	function getCurrentTimeInIndia() {
	    const date = new Date();
	    var ISTOffset = 330; // IST is 5:30; i.e., 60*5+30 = 330 in minutes 
	    var offset = ISTOffset * 60 * 1000;
	    var ISTTime = new Date(date.getTime() + offset); 

	    // Format IST time as a string in "yyyy-MM-ddTHH:mm" format
	    var formattedTime = ISTTime.toISOString().slice(0, 16);

	    // Set the IST time as the value of the "datetime" input field
	    document.getElementById('datetime').value = formattedTime;

	  }

	function changeButtonColor(isDisabled) {
	    
	   var $updatentpbutton = $('#updatentp'); 
	    var $savebutton = $('#saveButton'); 
	    
	     if (isDisabled) {
		        $updatentpbutton.css('background-color', 'gray'); // Change to your desired color
		    } else {
		        $updatentpbutton.css('background-color', '#2b3991'); // Reset to original color
		    }
	      
	     if (isDisabled) {
		        $savebutton.css('background-color', 'gray'); // Change to your desired color
		    } else {
		        $savebutton.css('background-color', '#2b3991'); // Reset to original color
		    }
	}
	
	$(document).ready(function() {
		<%// Access the session variable
		HttpSession role = request.getSession();
		String roleValue = (String) session.getAttribute("role");%>
		    	
		    	roleValue = '<%=roleValue%>';
		    	
		    	
		if (roleValue == 'OPERATOR' || roleValue == 'Operator') {

			$('#updatentp').prop('disabled', true);
			$('#saveButton').prop('disabled', true);
			
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
	    } else{
	    	<%// Access the session variable
	    	HttpSession token = request.getSession();
	    	String tokenValue = (String) session.getAttribute("token");%>

	    	tokenValue = '<%=tokenValue%>';
	    	
	loadNtpSettings();
	getCurrentTimeInIndia();
	
	getNtpDetails();
	
	toggleDateTimeInput();
	$("#get_current_time").click(function() {
		getCurrentTime();
	});
	//getntp();

	$('#setDateTime').click(function() {
		setManualTime();
		toggleDateTimeInput();
	});

	// Handle form submission
	$("#updateNtp").submit(function(event) {
		event.preventDefault();
		var buttonText = $("#updatentp").val();

		if (buttonText == "Add") {
			updatentp();
		}
	});
	
	$("#closePopup").click(function () {
	    $("#customPopup").hide();
	  });
	    }
	
	});
	setInterval(getCurrentTimeInIndia, 60000);

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
			<h3>NTP SETTINGS</h3>
			<hr>
			<div class="form-container">
				<form id="updateNtp" method="post">

					
					<table class="bordered-table" style="margin-top: -1px;">
					<tr>
					<td>Enable NTP Client</td>
					<td><label class="switch"> <input type="checkbox"
									id="ntp_client" name="ntp_client"
									onchange="toggleDateTimeInput()" value="1" checked> <span
									class="slider round"></span>
								</label></td>
					<td><input type="submit" value="Add"
								id="updatentp" /></td>
					</tr>
					<tr>
					<td>NTP Server 1</td>
					<td><input type="text" id="ntp_server1" name="ntp_server1" maxlength="31"/></td>
					<td>NTP Server 2</td>
					<td><input type="text" id="ntp_server2" name="ntp_server2" maxlength="31"/></td>
					</tr>
					
					<tr>
					<td>NTP Server 3</td>
					<td><input type="text" id="ntp_server3" name="ntp_server3" maxlength="31"/></td>
					<td>NTP Interval</td>
					<td><select class="ntp-interval-select" id="ntp_interval_1"
									name="ntp_interval_1" style="height: 35px;" required>
										<option value="Select interval">Select interval</option>
										<option value="5 sec">5 sec</option>
										<option value="10 sec">10 sec</option>
										<option value="15 sec">15 sec</option>
										<option value="25 sec">20 sec</option>
										<option value="25 sec">25 sec</option>
										<option value="30 sec">30 sec</option>
										<option value="1 min">1 min</option>
										<option value="5 min">5 min</option>
										<option value="10 min">10 min</option>							

						</select> <span id="jsonIntervalError" style="color: red;"></span></td>
					</tr>
					
					<tr>
						<td>NTP Service</td>
						<td id="ntp-service-cell"></td>
						<td >Clock Synchronized</td>
						<td id="system-clock-cell"></td>
					</tr>
					
				</table>
				<div class="row" style="display: flex; justify-content: center; margin-bottom: 2%; margin-top: 1%;">
							<input type="button" id="saveButton" onclick="editNtpData()"
								value="Save"/>

						</div>
					
					
				</form>
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
	
	 <div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to edit this NTP?</p>
				  <button id="confirm-button-edit">Yes</button>
				  <button id="cancel-button-edit">No</button>
				</div>
			  </div>
			</div>
			
			
			
			<h3></h3>
			<hr>
			<div class="container">

				<input type="button" id="get_current_time" value="Get Current Time" />
				<p id="ist_time" style="font-weight: bold; font-size: 16px;"></p>
				<p id="utc_time" style="font-weight: bold; font-size: 16px;"></p>

				<label for="datetime">Select Date-Time</label> <input
					type="datetime-local" id="datetime" name="datetime" required
					onchange="toggleDateTimeInput()">
					<input type="button" id="setDateTime" 
								value="Submit"/>
				<!-- <button id="setDateTime">Submit</button> -->

			</div>
		</section>
	</div>
	
	
	
	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>