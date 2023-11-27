<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
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
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style type="text/css">
.red-box {
	display: inline-block;
	width: 40px;
	height: 20px;
	background-color: red;
	color: white;
	text-align: center;
	line-height: 20px;
}

.orange-box {
	display: inline-block;
	width: 40px;
	height: 20px;
	background-color: orange;
	color: white;
	text-align: center;
	line-height: 20px;
}

.yellow-box {
	display: inline-block;
	width: 40px;
	height: 20px;
	background-color: yellow;
	color: white;
	text-align: center;
	line-height: 20px;
}
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
  
#confirm-button-session-timeout {
  background-color: #4caf50;
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

h3{
margin-top: 68px;
}

</style>

<script>
var roleValue;
var tokenValue;

	function loadThreatLogs() {

		$.ajax({
			url : 'threatLogsServlet',
			type : 'GET',
			dataType : 'json',
			beforeSend: function(xhr) {
		        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
		    },
			success : function(data) {
				var json1 = JSON.stringify(data);
				var json = JSON.parse(json1);
				handleStatus(json.status);
				 
				var threatLogsTable = $('#data-table tbody');
				threatLogsTable.empty();

				var json1 = JSON.stringify(data);

				var json = JSON.parse(json1);

				$
						.each(data,
								function(index, threatLogs) {

									var row = $('<tr>');
									row.append($('<td>').text(
											threatLogs.timestamp + ""));

									if (threatLogs.priority == '1') {
										row.append($('<td>').append(
												$('<div>').addClass('red-box')
														.text('high')));
									} else if (threatLogs.priority == '2') {
										row.append($('<td>').append(
												$('<div>').addClass(
														'orange-box').text(
														'medium')));
									} else if (threatLogs.priority == '3') {
										row.append($('<td>').append(
												$('<div>').addClass(
														'yellow-box').text(
														'low')));
									}

									row.append($('<td>').text(
											threatLogs.threat_id + ""));
									row.append($('<td>').text(
											threatLogs.alert_message + ""));
									row.append($('<td>').text(
											threatLogs.src_ip + ""));
									row.append($('<td>').text(
											threatLogs.src_port + ""));
									row.append($('<td>').text(
											threatLogs.dest_ip + ""));
									row.append($('<td>').text(
											threatLogs.dest_port + ""));
									row.append($('<td>').text(
											threatLogs.protocol_type + ""));
									row.append($('<td>').text(
											threatLogs.ack_at + ""));
									row.append($('<td>').text(
											threatLogs.ack_by + ""));

									threatLogsTable.append(row);

								});

			},
			error : function(xhr, status, error) {
				console.log('Error loading active threats data: ' + error);
			}
		});
	}

	function getSearchThreats() {
		// Get the values of startdatetime and enddatetime elements
		var startdatetime = $('#startdatetime').val();
		var enddatetime = $('#enddatetime').val();

		$.ajax({
			url : 'threatLogsServlet',
			type : 'POST',
			data : {
				startdatetime : startdatetime,
				enddatetime : enddatetime
			},
			beforeSend: function(xhr) {
		        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
		    },
			success : function(data) {
				var threatLogsTable = $('#data-table tbody');
				threatLogsTable.empty();

				var json1 = JSON.stringify(data);

				var json = JSON.parse(json1);

				if (json.status == 'fail') {
					var confirmation = confirm(json.msg);
					if (confirmation) {
						window.location.href = 'login.jsp';
					}
				}

				$
						.each(data,
								function(index, threatLogs) {

									var row = $('<tr>');
									row.append($('<td>').text(
											threatLogs.timestamp + ""));

									if (threatLogs.priority == '1') {
										row.append($('<td>').append(
												$('<div>').addClass('red-box')
														.text('high')));
									} else if (threatLogs.priority == '2') {
										row.append($('<td>').append(
												$('<div>').addClass(
														'orange-box').text(
														'medium')));
									} else if (threatLogs.priority == '3') {
										row.append($('<td>').append(
												$('<div>').addClass(
														'yellow-box').text(
														'low')));
									}

									row.append($('<td>').text(
											threatLogs.threat_id + ""));
									row.append($('<td>').text(
											threatLogs.alert_message + ""));
									row.append($('<td>').text(
											threatLogs.src_ip + ""));
									row.append($('<td>').text(
											threatLogs.src_port + ""));
									row.append($('<td>').text(
											threatLogs.dest_ip + ""));
									row.append($('<td>').text(
											threatLogs.dest_port + ""));
									row.append($('<td>').text(
											threatLogs.protocol_type + ""));
									row.append($('<td>').text(
											threatLogs.ack_at + ""));
									row.append($('<td>').text(
											threatLogs.ack_by + ""));

									threatLogsTable.append(row);

								});

			},
			error : function(xhr, status, error) {
				console.log('Error acknowledging threats: ' + error);
			}
		});
	}
	function checkDateField() {
		var startdatetime = $('#startdatetime').val();
		var enddatetime = $('#enddatetime').val();
		var errorMessage = '';

		// Check if startdatetime is empty
		if (startdatetime.trim() === '') {
			errorMessage += 'Start Date/Time is required.\n';
		}

		// Check if enddatetime is empty
		if (enddatetime.trim() === '') {
			errorMessage += 'End Date/Time is required.\n';
		}

		// Check if both startdatetime and enddatetime are not empty
		if (errorMessage === '' && startdatetime !== '' && enddatetime !== '') {
			getSearchThreats(); // Call the function when both fields have content
		} else {
			// Display the error message using an alert
			//alert(errorMessage);
			
			// Display the custom popup message
 			$("#popupMessage").text(errorMessage);
  			$("#customPopup").show();
			
			
		}
	}
	function getCurrentTimeInIndia() {
	    const date = new Date();
	    var ISTOffset = 330; // IST is 5:30; i.e., 60*5+30 = 330 in minutes
	    var offset = ISTOffset * 60 * 1000;
	    var ISTTime = new Date(date.getTime() + offset);

	    // Subtract 24 hours (24 hours * 60 minutes * 60 seconds * 1000 milliseconds) from ISTTime
	    var ISTTime24HoursAgo = new Date(ISTTime.getTime() - (24 * 60 * 60 * 1000));
	 
	    // Format both current ISTTime and ISTTime24HoursAgo as strings in "yyyy-MM-ddTHH:mm" format
	    var formattedCurrentTime = ISTTime.toISOString().slice(0, 16);
	    var formattedTime24HoursAgo = ISTTime24HoursAgo.toISOString().slice(0, 16);

	    // Set the current IST time as the value of the "enddatetime" input field
	    document.getElementById('enddatetime').value = formattedCurrentTime;

	    // Set the IST time 24 hours ago as the value of the "startdatetime" input field
	    document.getElementById('startdatetime').value = formattedTime24HoursAgo;

	    // Debugging: Log both calculated times to the console
	    console.log('Current IST time:', formattedCurrentTime);
	    console.log('IST time 24 hours ago:', formattedTime24HoursAgo);
	}
	function handleStatus(status) {
	    if (status === 'fail') {
	        var modal = document.getElementById('custom-modal-session-timeout');
	        modal.style.display = 'block';

	        // Handle the confirm button click
	        var confirmButton = document.getElementById('confirm-button-session-timeout');
	        confirmButton.onclick = function () {
	            // Close the modal
	            modal.style.display = 'none';
	            window.location.href = 'login.jsp';
	        };
	    }
	}

	function changeButtonColor(isDisabled) {
	    var $loadThreatsbutton = $('#loadThreats');       
	   
	    
	     if (isDisabled) {
	        $loadThreatsbutton.css('background-color', 'gray'); // Change to your desired color
	    } else {
	        $loadThreatsbutton.css('background-color', '#2b3991'); // Reset to original color
	    }
	}
	
	
	$(document).ready(function() {
		
		<%// Access the session variable
		HttpSession role = request.getSession();
		String roleValue = (String) session.getAttribute("role");%>
	
	roleValue = '<%=roleValue%>';
	
		
		
		if (roleValue == 'OPERATOR' || roleValue == 'Operator') {
			
			$('#loadThreats').prop('disabled', true);
			
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
			
			loadThreatLogs();
			getCurrentTimeInIndia();
			$(document).on("click", "#loadThreats", function() {
				checkDateField();
			});
			setInterval(getCurrentTimeInIndia, 60000);
			
			$("#closePopup").click(function () {
			    $("#customPopup").hide();
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
		<h3>THREAT LOGS</h3>
		<hr />

		<div class="row"
			style="display: flex; flex-content: space-between; margin-top: 5px;">


			<div style="width: 20%;">
				<label for="log_file">Choose a date:</label>
			</div>

			<div style="width: 25%; margin-left: -11%; margin-top: 5px;">
				<input type="datetime-local" id="startdatetime" name="startdatetime">
			</div>

			<div style="width: 10%; margin-left: -10%;">
				<label for="log_file"> to </label>
			</div>

			<div style="width: 25%; margin-left: -8%; margin-top: 5px;">
				<input type="datetime-local" id="enddatetime" name="enddatetime">
			</div>

			<div>
				<input style="margin-left: 1%; margin-top: 5%;" type="button"
					id="loadThreats" value="Load threats">
			</div>

		</div>
		
		<div id="custom-modal-session-timeout" class="modal-session-timeout">
				<div class="modal-content-session-timeout">
				  <p>Your session is timeout. Please login again</p>
				  <button id="confirm-button-session-timeout">OK</button>
				</div>
		</div>
		
		 <div id="customPopup" class="popup">
  				<span class="popup-content" id="popupMessage"></span>
  				<button id="closePopup">OK</button>
			  </div>

		<div class="container">

			<table id="data-table">
				<thead>
					<tr>
						<th>Timestamp</th>
						<th>Priority</th>
						<th>Threat ID</th>
						<th>Alert message</th>
						<th>Src IP</th>
						<th>Src port</th>
						<th>Dest IP</th>
						<th>Dest port</th>
						<th>Protocol type</th>
						<th>Ack at</th>
						<th>Ack by</th>

					</tr>
				</thead>
				<tbody>
					<!-- Table rows will be dynamically generated here -->
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