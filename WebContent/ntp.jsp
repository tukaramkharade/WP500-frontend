
<!-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%> -->
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
<link rel="stylesheet"
	href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

<style type="text/css">
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
p {
    font-weight: bold;
    font-size: 16px; 
 }
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
var roleValue;
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

	function getntp() {
		$.ajax({
			url : 'ntp',
			type : 'GET',
			dataType : 'json',
			success : function(data) {

				var json1 = JSON.stringify(data);

				var json = JSON.parse(json1);

				if (json.status == 'fail') {
					var confirmation = confirm(json.msg);
					if (confirmation) {
						window.location.href = 'login.jsp';
					}
				}

				//$('#ntp_client').prop('checked', data.ntp_client);
				$('#ntp_client').prop('checked', data.ntp_client === '1');

				$('#ntp_interval').val(data.ntp_interval);
				$('#ntp_server').val(data.ntp_server);
				//toggleNtpClient();
				toggleDateTimeInput();

			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error: ' + error);
			}
		});
	}

	// Function to load user data and populate the user list table

	function updatentp() {
		//	var ntp_client = $("ntp_client").checked ? "off" : "on";
		var ntp_client = $("#ntp_client").prop("checked") ? "1" : "0";

		//var ntp_client = document.getElementById("ntp_client").checked ? "off" : "on";
		

		$.ajax({
			url : "ntp",
			type : "POST",
			data : {
				ntp_client : ntp_client
				
			},
			success : function(data) {
				// Display the ntp status message
				//	alert(data.message);
				getntp();
				// Clear form fields
				alert(data.message);
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
			success : function(data) {
				//alert(data.eth0_ipaddr + " " + data.eth0_subnet);

				var json1 = JSON.stringify(data);

				var json = JSON.parse(json1);

				if (json.status == 'fail') {
					var confirmation = confirm(json.msg);
					if (confirmation) {
						window.location.href = 'login.jsp';
					}
				}

				$('#ntp_server1').val(data.ntp_server1);
				$('#ntp_server2').val(data.ntp_server2);
				$('#ntp_server3').val(data.ntp_server3);
				$('#ntp_interval_1').val(data.ntp_interval);

			//	console.log('lan1_ipaddr:', data.ntp_server1);
	       //	console.log('lan1_subnet:', data.ntp_server2);

		//		console.log('lan2_ipaddr:', data.ntp_server3);
		//		console.log('lan2_subnet:', data.ntp_interval);

			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error: ' + error);
			}
		});
	}

	function editNtpData() {
		
	    var ntp_server1 = $('#ntp_server1').val();
	    var ntp_server2 = $('#ntp_server2').val();
	    var ntp_server3 = $('#ntp_server3').val();
	    var ntp_interval = $('#ntp_interval_1').val();
	    var isValid=true;
	    if (ntp_server1 === '' || ntp_server2 === '' || ntp_server3 === '' || ntp_interval === '') {
	        alert('Please fill in all fields before saving.');
	        return; // Prevent the AJAX request
	    }
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
	            alert(data.message);

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
	        alert('Please enter a valid date and time.');
	        return; // Prevent the AJAX request
	    }

		$.ajax({
			url : 'dateTimeServlet',
			type : 'POST',
			data : {
				datetime : datetime

			},
			success : function(data) {
				// Display the registration status message
				alert(data.message);

				// Clear form fields

				$('#datetime').val('');

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
	  //  console.log("Current Time:", date);
	    var ISTOffset = 330; // IST is 5:30; i.e., 60*5+30 = 330 in minutes 
	    var offset = ISTOffset * 60 * 1000;
	    var ISTTime = new Date(date.getTime() + offset);
	 //   console.log("IST Date:", ISTTime);

	    // Format IST time as a string in "yyyy-MM-ddTHH:mm" format
	    var formattedTime = ISTTime.toISOString().slice(0, 16);

	    // Set the IST time as the value of the "datetime" input field
	    document.getElementById('datetime').value = formattedTime;

	    // Debugging: Log the calculated IST time to the console
	  //  console.log('Calculated IST time:', formattedTime);
	  }



	$(document).ready(function() {
		<%// Access the session variable
		HttpSession role = request.getSession();
		String roleValue = (String) session.getAttribute("role");%>
		    	
		    	roleValue = '<%=roleValue%>';
		    	
		loadNtpSettings();
		getCurrentTimeInIndia();
		if (roleValue == 'VIEWER' || roleValue == 'Viewer') {

			var confirmation = confirm('You do not have enough privileges for role VIEWER');
			
			
			$('#setDateTime').prop('disabled', true);
			$('#updateNtp').prop('disabled', true);
			$('#saveButton').prop('disabled', true);
			
		}
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

	});
	setInterval(getCurrentTimeInIndia, 60000);
//	setInterval(getCurrentTime, 60000);
	
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
			<div class="container">
				<form id="updateNtp" method="post">

					<div class="row">
						<div
							style="width: 40%; margin-top: 6px; display: flex; justify-content: left;">
							<label for="enableToggle">Enable NTP Client</label>

							<div style="width: 20%;">
								<label class="switch"> <input type="checkbox"
									id="ntp_client" name="ntp_client"
									onchange="toggleDateTimeInput()" value="1" checked> <span
									class="slider round"></span>
								</label>

							</div>
							<div class="row">
								<input style="margin-left: 95%;" type="submit" value="Add"
								id="updatentp" />
							</div>
						</div>
					</div>
					<br />


					<div class="row"
					style="display: flex; flex-content: space-between;">
						<div style="width: 22%; margin-top: 0;display:flex;">
							<div>
							<label>NTP Server 1</label>
							</div>
							<div>
							<input type="text" id="ntp_server1" name="ntp_server1"
								placeholder="NTP Server" maxlength="31"/>
							</div>
						</div>
					
						<div style="width: 21%; margin-top: 0;display:flex;">
							<div>
							<label>NTP Server 2</label>
							</div>
							<div>
								<input type="text" id="ntp_server2" name="ntp_server2"
								placeholder="NTP Server" maxlength="31"/>
							</div>
						</div>	
					</div>					
					<div class="row"
					style="display: flex; flex-content: space-between;">
						<div style="width: 22%; margin-top: 2px;display:flex;">
							<div>
								<label>NTP Server 3</label>
							</div>
							<div>	
								<input type="text" id="ntp_server3" name="ntp_server3"
								placeholder="NTP Server" maxlength="31"/>
							</div>
						</div>
						
						<div style="width: 22%; margin-top: 2px;display:flex; margin-left: 4px;">
								<div>
									<label>NTP Interval</label>
								</div>
								<div>
									<input type="text" id="ntp_interval_1" name="ntp_interval_1"
										placeholder="NTP Interval" maxlength="31" />
								</div>
						</div>
					</div>

					<div class="row">
						<div
							style="width: 40%; margin-top: 6px; justify-content: left; display: flex;">
							<input type="button" id="saveButton" onclick="editNtpData()"
								value="Save"/>

						</div>
					</div>

					
				</form>
			</div>

			<h3></h3>
			<hr>
			<div class="container">

				<input type="button" id="get_current_time" value="Get Current Time" />
				<p id="ist_time"></p>
				<p id="utc_time"></p>

				<label for="datetime">Select Date-Time:</label> <input
					type="datetime-local" id="datetime" name="datetime" required
					onchange="toggleDateTimeInput()">
				<button id="setDateTime">Submit</button>

			</div>
		</section>
	</div>

	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>