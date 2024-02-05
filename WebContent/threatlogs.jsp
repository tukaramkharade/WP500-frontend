<%
    response.setHeader("X-Frame-Options", "DENY");
    response.setHeader("X-Content-Type-Options", "nosniff");
    HttpSession session1 = request.getSession();
    String secureFlag = "Secure";
    String httpOnlyFlag = "HttpOnly";
    String sameSiteFlag = "SameSite=None"; // Add this line for SameSite attribute
    String cookieValue = session1.getId();
    String headerKey = "Set-Cookie";
    String headerValue = String.format("%s=%s; %s; %s; %s", session1.getId(), cookieValue, secureFlag, httpOnlyFlag, sameSiteFlag);
    response.setHeader(headerKey, headerValue);
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png" />
<link rel="stylesheet" href="css_files/ionicons.min.css">
<link rel="stylesheet" href="css_files/normalize.min.css">
<link rel="stylesheet" href="css_files/fonts.txt" type="text/css">	
<link rel="stylesheet" href="nav-bar.css" />
<link rel="stylesheet" href="css_files/all.min.css">
<link rel="stylesheet" href="css_files/fontawesome.min.css">	
<script src="jquery-3.6.0.min.js"></script>

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
   margin-left: 120px;
    background: rgba(255, 255, 255, 0.2); /* Transparent white background */
    border-radius: 5px;
}

</style>

<script>
var roleValue;
var tokenValue;
var csrfTokenValue;

	function loadThreatLogs() {
	    showLoader();
	    var csrfToken = document.getElementById('csrfToken').value;		
		$.ajax({
			url : 'threatLogsServlet',
			type : 'GET',
			dataType : 'json',
			data: {
				csrfToken: csrfToken
	        },
			beforeSend: function(xhr) {
		        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
		    },
			success : function(data) {
	            hideLoader();				
				if (data.status == 'fail') {					
					 var modal = document.getElementById('custom-modal-session-timeout');
					  modal.style.display = 'block';
					    var sessionMsg = document.getElementById('session-msg');
					    sessionMsg.textContent = data.message; // Assuming data.message contains the server message
					  var confirmButton = document.getElementById('confirm-button-session-timeout');
					  confirmButton.onclick = function () {
					        modal.style.display = 'none';
					        window.location.href = 'login.jsp';
					  };					  
				} 				
				var threatLogsTable = $('#data-table tbody');
				threatLogsTable.empty();
				 data.result.forEach(function(threatLogs) {
					 var row = $('<tr>');
						row.append($('<td>').text(threatLogs.timestamp + ""));
						if (threatLogs.priority == '1') {
							row.append($('<td>').append($('<div>').addClass('red-box').text('high')));
						} else if (threatLogs.priority == '2') {
							row.append($('<td>').append($('<div>').addClass('orange-box').text('medium')));
						} else if (threatLogs.priority == '3') {
							row.append($('<td>').append($('<div>').addClass('yellow-box').text('low')));
						}
						row.append($('<td>').text(threatLogs.threat_id + ""));
						row.append($('<td>').text(threatLogs.alert_message + ""));
						row.append($('<td>').text(threatLogs.src_ip + ""));
						row.append($('<td>').text(threatLogs.src_port + ""));
						row.append($('<td>').text(threatLogs.dest_ip + ""));
						row.append($('<td>').text(threatLogs.dest_port + ""));
						row.append($('<td>').text(threatLogs.protocol_type + ""));
						row.append($('<td>').text(threatLogs.ack_at + ""));
						row.append($('<td>').text(threatLogs.ack_by + ""));
						threatLogsTable.append(row);					 
				 });				
			},
			error : function(xhr, status, error) {
	            hideLoader();				
			}
		});
	}

	function getSearchThreats() {
		var startdatetime = $('#startdatetime').val();
		var enddatetime = $('#enddatetime').val();
		var csrfToken = document.getElementById('csrfToken').value;		
		$.ajax({
			url : 'threatLogsServlet',
			type : 'POST',
			data : {
				startdatetime : startdatetime,
				enddatetime : enddatetime,
				csrfToken: csrfToken
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
				$.each(data,function(index, threatLogs) {
									var row = $('<tr>');
									row.append($('<td>').text(threatLogs.timestamp + ""));
									if (threatLogs.priority == '1') {
										row.append($('<td>').append($('<div>').addClass('red-box').text('high')));
									} else if (threatLogs.priority == '2') {
										row.append($('<td>').append($('<div>').addClass('orange-box').text('medium')));
									} else if (threatLogs.priority == '3') {
										row.append($('<td>').append($('<div>').addClass('yellow-box').text('low')));
									}
									row.append($('<td>').text(threatLogs.threat_id + ""));
									row.append($('<td>').text(threatLogs.alert_message + ""));
									row.append($('<td>').text(threatLogs.src_ip + ""));
									row.append($('<td>').text(threatLogs.src_port + ""));
									row.append($('<td>').text(threatLogs.dest_ip + ""));
									row.append($('<td>').text(threatLogs.dest_port + ""));
									row.append($('<td>').text(threatLogs.protocol_type + ""));
									row.append($('<td>').text(threatLogs.ack_at + ""));
									row.append($('<td>').text(threatLogs.ack_by + ""));
									threatLogsTable.append(row);
								});
			},
			error : function(xhr, status, error) {				
			}
		});
	}
	
	function checkDateField() {
		var startdatetime = $('#startdatetime').val();
		var enddatetime = $('#enddatetime').val();
		var errorMessage = '';
		if (startdatetime.trim() === '') {
			errorMessage += 'Start Date/Time is required.\n';
		}
		if (enddatetime.trim() === '') {
			errorMessage += 'End Date/Time is required.\n';
		}
		if (errorMessage === '' && startdatetime !== '' && enddatetime !== '') {
			getSearchThreats(); // Call the function when both fields have content
		} else {
			$("#popupMessage").text(errorMessage);
  			$("#customPopup").show();
		}
	}
	
	function getCurrentTimeInIndia() {
	    const date = new Date();
	    var ISTOffset = 330; // IST is 5:30; i.e., 60*5+30 = 330 in minutes
	    var offset = ISTOffset * 60 * 1000;
	    var ISTTime = new Date(date.getTime() + offset);
	    var ISTTime24HoursAgo = new Date(ISTTime.getTime() - (24 * 60 * 60 * 1000));
	    var formattedCurrentTime = ISTTime.toISOString().slice(0, 16);
	    var formattedTime24HoursAgo = ISTTime24HoursAgo.toISOString().slice(0, 16);
	    document.getElementById('enddatetime').value = formattedCurrentTime;
	    document.getElementById('startdatetime').value = formattedTime24HoursAgo;
	}
	
	function handleStatus(status) {
	    if (status === 'fail') {
	        var modal = document.getElementById('custom-modal-session-timeout');
	        modal.style.display = 'block';
	        var confirmButton = document.getElementById('confirm-button-session-timeout');
	        confirmButton.onclick = function () {
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
	
	 function showLoader() {
	     $('#loader-overlay').show();
	 }

	 function hideLoader() {
	     $('#loader-overlay').hide();
	 }
	
	$(document).ready(function() {		
		<%// Access the session variable
		HttpSession role = request.getSession();
		String roleValue = (String) session.getAttribute("role");%>	
	roleValue = '<%=roleValue%>';
	
	<%// Access the session variable
	HttpSession csrfToken = request.getSession();
	String csrfTokenValue = (String) session.getAttribute("csrfToken");%>
	csrfTokenValue = '<%=csrfTokenValue%>';
		
	if (roleValue == 'OPERATOR' || roleValue == 'Operator') {			
			$('#loadThreats').prop('disabled', true);			
			changeButtonColor(true);
		}		
		
		if (roleValue === "null") {
	        var modal = document.getElementById('custom-modal-session-timeout');
	        modal.style.display = 'block';
	        var sessionMsg = document.getElementById('session-msg');
		    sessionMsg.textContent = 'You are not allowed to redirect like this !!'; 
	        var confirmButton = document.getElementById('confirm-button-session-timeout');
	        confirmButton.onclick = function() {
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
		<input type="hidden" name="csrfToken" id="csrfToken" value="<%= csrfTokenValue %>" />	
			<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>
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
				<p id="session-msg"></p>
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