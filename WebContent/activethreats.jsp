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
.modal-session-timeout,
.modal-ack{
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
.modal-content-ack
 {
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

#confirm-button-ack,
#confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
  margin: 5px;
  padding: 10px 20px;
  border: none;
  cursor: pointer;
}

#cancel-button-ack {
  background-color: #f44336;
  color: white;
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

function getActiveThreats() {
	// Display loader when the request is initiated
    showLoader();
	
	$.ajax({
		url : 'activeThreatServlet',
		type : 'GET',
		dataType : 'json',
		beforeSend: function(xhr) {
	        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
	    },
		success : function(data) {
			// Hide loader when the response has arrived
            hideLoader();
			
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
			
			var activeThreatsTable = $('#data-table tbody');
			activeThreatsTable.empty();
			
			 
			 if(roleValue == 'ADMIN' || roleValue == 'Admin'){
				 
				 data.result.forEach(function(activeThreats) {
					 var row = $('<tr>');
						row.append($('<td>').text(activeThreats.timestamp + ""));
						
						if(activeThreats.priority == '1'){							
							row.append($('<td>').append($('<div>').addClass('red-box').text('high')));
						}else if(activeThreats.priority == '2'){
							row.append($('<td>').append($('<div>').addClass('orange-box').text('medium')));
						}else if(activeThreats.priority == '3'){
							row.append($('<td>').append($('<div>').addClass('yellow-box').text('low')));
						}
						
						row.append($('<td>').text(activeThreats.threat_id + ""));
						row.append($('<td>').text(activeThreats.alert_message + ""));						
						row.append($('<td>').text(activeThreats.src_ip + ""));
						row.append($('<td>').text(activeThreats.src_port + ""));
						row.append($('<td>').text(activeThreats.dest_ip + ""));
						row.append($('<td>').text(activeThreats.dest_port + ""));
						row.append($('<td>').text(activeThreats.protocol_type + ""));
						
						var actions = $('<td>')
						var ackButton = $(
										'<button data-toggle="tooltip" class="editBtn" data-placement="top" title="Acknowledge" style="color: #35449a;">')
										.html('<i class="fas fa-check"></i>')
										.click(
												function() {
													ackThreats(activeThreats.threat_id);
												});
						
						actions.append(ackButton);
					
						row.append(actions);
											
						activeThreatsTable.append(row);
				 });
				 
				
			 }else if(roleValue == 'OPERATOR' || roleValue == 'Operator'){
				 data.result.forEach(function(activeThreats) {
					 var row = $('<tr>');
						row.append($('<td>').text(activeThreats.timestamp + ""));
						
						if(activeThreats.priority == '1'){							
							row.append($('<td>').append($('<div>').addClass('red-box').text('high')));
						}else if(activeThreats.priority == '2'){
							row.append($('<td>').append($('<div>').addClass('orange-box').text('medium')));
						}else if(activeThreats.priority == '3'){
							row.append($('<td>').append($('<div>').addClass('yellow-box').text('low')));
						}
						
						row.append($('<td>').text(activeThreats.threat_id + ""));
						row.append($('<td>').text(activeThreats.alert_message + ""));						
						row.append($('<td>').text(activeThreats.src_ip + ""));
						row.append($('<td>').text(activeThreats.src_port + ""));
						row.append($('<td>').text(activeThreats.dest_ip + ""));
						row.append($('<td>').text(activeThreats.dest_port + ""));
						row.append($('<td>').text(activeThreats.protocol_type + ""));
											
						activeThreatsTable.append(row);
				 });
				 
			 }		
				
		},
		error : function(xhr, status, error) {
			// Hide loader when the response has arrived
            hideLoader();
			
			console.log('Error loading active threats data: ' + error);
		}
	});
}

function getSearchThreats() {
    // Get the values of startdatetime and enddatetime elements
    var startdatetime = $('#startdatetime').val();
    var enddatetime = $('#enddatetime').val();
    
    $.ajax({
        url: 'activeThreatServlet',
        type: 'POST',
        data: {
            startdatetime: startdatetime,
            enddatetime: enddatetime,
            action : 'get_threats'
        },
        beforeSend: function(xhr) {
	        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
	    },
        success: function (data) {
			var activeThreatsTable = $('#data-table tbody');
			activeThreatsTable.empty();
			
			 var json1 = JSON.stringify(data);

			var json = JSON.parse(json1);

			if (json.status == 'fail') {
				var confirmation = confirm(json.msg);
				if (confirmation) {
					window.location.href = 'login.jsp';
				}
			} 

				$.each(data, function(index, activeThreats) {
					
					
						var row = $('<tr>');
						row.append($('<td>').text(activeThreats.timestamp + ""));
						
						if(activeThreats.priority == '1'){							
							row.append($('<td>').append($('<div>').addClass('red-box').text('high')));
						}else if(activeThreats.priority == '2'){
							row.append($('<td>').append($('<div>').addClass('orange-box').text('medium')));
						}else if(activeThreats.priority == '3'){
							row.append($('<td>').append($('<div>').addClass('yellow-box').text('low')));
						}
						
						row.append($('<td>').text(activeThreats.threat_id + ""));
						row.append($('<td>').text(activeThreats.alert_message + ""));						
						row.append($('<td>').text(activeThreats.src_ip + ""));
						row.append($('<td>').text(activeThreats.src_port + ""));
						row.append($('<td>').text(activeThreats.dest_ip + ""));
						row.append($('<td>').text(activeThreats.dest_port + ""));
						row.append($('<td>').text(activeThreats.protocol_type + ""));
						row.append($('<td>').text(activeThreats.ack_at + ""));
						row.append($('<td>').text(activeThreats.ack_by + ""));
						
						var actions = $('<td>')
						var ackButton = $(
										'<button style="background-color: #35449a; border: none; border-radius: 5px; margin-left: 5px; color: white">')
										.text('Acknowledge')
										.click(
												function() {
													ackThreats(activeThreats.threat_id);
												});
						
						actions.append(ackButton);
					
						row.append(actions);
											
						activeThreatsTable.append(row);
					
				});

		
        },
        error: function (xhr, status, error) {
            console.log('Error acknowledging threats: ' + error);
        }
    });
}


function ackThreats(threat_id){
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-ack');
	  modal.style.display = 'block';
	  
	// Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-ack');
	  confirmButton.onclick = function () {
		  $.ajax({
				url : 'activeThreatServlet',
				type : 'POST',
				data : {
					threat_id : threat_id,
					 action : 'get_ack_threats'
					
				},
				success : function(data) {
					
					// Close the modal
			        modal.style.display = 'none';
					
				},
				error : function(xhr, status, error) {
					console.log('Error acknowledging threats: ' + error);
				}
			});
		  location.reload();
		  
	  };
	  
	  var cancelButton = document.getElementById('cancel-button-ack');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	    location.reload();
	  };
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

//Function to show the loader
function showLoader() {
    // Show the loader overlay
    $('#loader-overlay').show();
}

// Function to hide the loader
function hideLoader() {
    // Hide the loader overlay
    $('#loader-overlay').hide();
}

$(document).ready(function() {
	
	<%// Access the session variable
	HttpSession role = request.getSession();
	String roleValue = (String) session.getAttribute("role");%>

roleValue = '<%=roleValue%>';


	
	if (roleValue == 'OPERATOR' || roleValue == 'Operator') {
		$("#acknowledge").hide();
		
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
    }else{
    	<%// Access the session variable
    	HttpSession token = request.getSession();
    	String tokenValue = (String) session.getAttribute("token");%>

    	tokenValue = '<%=tokenValue%>';
    		
    		getActiveThreats();
    		
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
		<h3>ACTIVE THREATS</h3>
		<hr />
		
			<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>

		<div class="row"
			style="display: flex; flex-content: space-between; margin-top: 5px;">
			
			
			<div style="width: 20%;">
				<label for="choose_date">Choose a date:</label>
			</div>
			
			<div style="width: 25%; margin-left: -11%;margin-top: 5px;">
				<input type="datetime-local" id="startdatetime" name="startdatetime" >
			</div>
			
			<div style="width: 10%; margin-left: -10%;">
				<label for="to">  to  </label>
			</div>
			
			<div style="width: 25%; margin-left: -8%;margin-top: 5px;">
				<input type="datetime-local" id="enddatetime" name="enddatetime" >
			</div>
			
			<div>
				<input style="margin-left: 1%; margin-top: 5%;" type="button"
					id="loadThreats" value="Load threats">
			</div>
			
			</div>
			
			<div id="custom-modal-ack" class="modal-ack">
				<div class="modal-content-ack">
				  <p>Are you sure you want to acknowledge this threat?</p>
				  <button id="confirm-button-ack">Yes</button>
				  <button id="cancel-button-ack">No</button>
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
							<th id="acknowledge">Acknowledge</th>
							
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