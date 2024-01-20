<%  
    // Add X-Frame-Options header to prevent clickjacking
    response.setHeader("X-Frame-Options", "DENY");
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32"
	href="images/WP_Connex_logo_favicon.png" />
<link rel="stylesheet" href="css_files/ionicons.min.css">
<link rel="stylesheet" href="css_files/normalize.min.css">
<link rel="stylesheet" href="css_files/fonts.txt" type="text/css">	
<link rel="stylesheet" href="nav-bar.css" />
<script src="jquery-3.6.0.min.js"></script>
<style>
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

	function searchSystemLogData() {
		var searchQuery = document.getElementById("search_query").value.trim();
		var csrfToken = document.getElementById('csrfToken').value;

		var startdatetime = $('#startdatetime').val();
		var enddatetime = $('#enddatetime').val();
		if (searchQuery === "") {
			
			// Display the custom popup message
	     			$("#popupMessage").text("Please enter a search query.");
	      			$("#customPopup").show();
			return;
		}
		var tableBody = $("#log_table_body");
		tableBody.empty(); // Clear the table body before adding search results
		$.ajax({
			url : "loadSystemLogSearch", // Replace this with the appropriate server-side URL to handle the search
			type : "POST",
			data : {
				search_query : searchQuery,
				startdatetime : startdatetime,
				enddatetime : enddatetime,
				csrfToken: csrfToken
			},
			beforeSend: function(xhr) {
		        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
		    },
			success : function(data) {
				if (data.system_log_result
						&& Array.isArray(data.system_log_result)) {
					tableBody.empty();

					data.system_log_result.forEach(function(log) {
						var logParts = log.split(" "); // Split the log entry by spaces

						if (logParts.length >= 6) {
							var month = logParts[0];
							var date = logParts[1];
							var time = logParts[2];
							var projectName = logParts[3];
							var message = logParts.slice(4).join(" "); // Join the remaining parts as the message

							var dateTime = month + " " + date + " " + time; // Concatenate month, date, and time

							var row = $("<tr>").append(
									$("<td>").text(dateTime), // Use the concatenated dateTime
									$("<td>").text(projectName),
									$("<td>").text(message));
							tableBody.append(row);
						} else {
							var row = $("<tr>").append(
									$("<td>").attr("colspan", 3).text(log) // Update colspan to 3
							);
							tableBody.append(row);
						}
					});

					var count = data.system_log_result.length;
					
					var totalPages = Math.ceil(count / 100);
					
					$("#log_table").show();
				}
			},
			error : function(xhr, status, error) {
				
			},
		});
		$("#closePopup").click(function () {
		    $("#customPopup").hide();
		  });

	}

	function getSysLogDate() {

		var startdatetime = $('#startdatetime').val();
		var enddatetime = $('#enddatetime').val();
		var tableBody = $("#log_table_body");
		var csrfToken = document.getElementById('csrfToken').value;

		tableBody.empty();
		$.ajax({
			url : 'loadSystemLog',
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
				if (data.system_log_result
						&& Array.isArray(data.system_log_result)) {
					tableBody.empty();

					data.system_log_result.forEach(function(log) {
						var logParts = log.split(" "); // Split the log entry by spaces

						if (logParts.length >= 6) {
							var month = logParts[0];
							var date = logParts[1];
							var time = logParts[2];
							var projectName = logParts[3];
							var message = logParts.slice(4).join(" "); // Join the remaining parts as the message

							var row = $("<tr>").append($("<td>").text(month),
									$("<td>").text(date), $("<td>").text(time),
									$("<td>").text(projectName),
									$("<td>").text(message));
							tableBody.append(row);
						} else {
							var row = $("<tr>").append(
									$("<td>").attr("colspan", 5).text(log));
							tableBody.append(row);
						}
					});

					var count = data.system_log_result.length;
					
					var totalPages = Math.ceil(count / 100);
					
					$("#log_table").show();
				}
			},
			error : function(xhr, status, error) {
				
			}
		});

	}

	function loadSystemLog() {
		// Display loader when the request is initiated
	    showLoader();
	    var csrfToken = document.getElementById('csrfToken').value;

	    var tableBody = $("#log_table_body");

		$.ajax({
			url : "loadSystemLog", // Replace this with the appropriate server-side URL to handle the AJAX GET
			type : "GET", // Change the request method to GET
			dataType : 'json',
			data: {
				csrfToken: csrfToken
	        },
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
				
				if (data.system_log_result
						&& Array.isArray(data.system_log_result)) {
					tableBody.empty();

					data.system_log_result.forEach(function(log) {
						var logParts = log.split(" "); // Split the log entry by spaces

						if (logParts.length >= 6) {
							var month = logParts[0];
							var date = logParts[1];
							var time = logParts[2];
							var projectName = logParts[3];
							var message = logParts.slice(4).join(" "); // Join the remaining parts as the message

							var dateTime = month + " " + date + " " + time; // Concatenate month, date, and time

							var row = $("<tr>").append(
									$("<td>").text(dateTime), // Use the concatenated dateTime
									$("<td>").text(projectName),
									$("<td>").text(message));
							tableBody.append(row);
						} else {
							var row = $("<tr>").append(
									$("<td>").attr("colspan", 3).text(log) // Update colspan to 3
							);
							tableBody.append(row);
						}
					});

					var count = data.system_log_result.length;
					
					var totalPages = Math.ceil(count / 100);
					
					$("#log_table").show();
				}
			},
			error : function(xhr, status, error) {
				// Hide loader when the response has arrived
	            hideLoader();
				
			},
		});
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
	}	
	
	function changeButtonColor(isDisabled) {
        var $load_button = $('#loadLogSysFileButton');       
        
         if (isDisabled) {
            $load_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $load_button.css('background-color', '#2b3991'); // Reset to original color
        }
        
    }
	
	// Function to show the loader
	 function showLoader() {
	     // Show the loader overlay
	     $('#loader-overlay').show();
	 }

	 // Function to hide the loader
	 function hideLoader() {
	     // Hide the loader overlay
	     $('#loader-overlay').hide();
	 }
	
	//Function to execute on page load
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

		$('#loadLogSysFileButton').prop('disabled', true);
		
		changeButtonColor(true);
	}
	
	if (roleValue === "null") {
        var modal = document.getElementById('custom-modal-session-timeout');
        modal.style.display = 'block';
        
        var sessionMsg = document.getElementById('session-msg');
	    sessionMsg.textContent = 'You are not allowed to redirect like this !!'; 
	    
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
		
		loadSystemLog();
		getCurrentTimeInIndia();
	
		$(document).on("click", "#loadLogSysFileButton", function() {
			var searchQuery = $("#search_query").val().trim();
			if (searchQuery !== "") {
				
				searchSystemLogData();

			} else {
				var tableBody = $("#log_table_body");
				tableBody.empty();
				getSysLogDate();
			}
		});
		setInterval(getCurrentTimeInIndia, 60000);
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
		<h3>SYSTEM LOGS</h3>
		<hr />
			<input type="hidden" name="csrfToken" id="csrfToken" value="<%= csrfTokenValue %>" />
			<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>
		<!-- <div class="row"
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

			<div
				style="width: 20%; margin-left: 1%; margin-right: 1%; float: left;">
				<input type="text" id="search_query" placeholder=" Search">
			</div>

			<div>
				<input style="margin-left: 1%; margin-top: 5%;" type="button"
					id="loadLogSysFileButton" value="Load system log file">
			</div>

		</div> -->
		
		
		<table class="bordered-table" style="margin-top: -1px;">
		<tr>
		<td style="width: 6%;">Choose a date</td>
		<td style="width: 10%;"><input type="datetime-local" id="startdatetime" name="startdatetime"></td>
		<td  style="width: 1%;">to</td>
		<td  style="width: 10%;"><input type="datetime-local" id="enddatetime" name="enddatetime"></td>
		<td><input type="text" id="search_query" placeholder=" Search"></td>
		<td><input style="margin-left: 1%;" type="button"
					id="loadLogSysFileButton" value="Load system log file"></td>
		</tr>
		</table>
		
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
		

		<!-- Table to display the log data -->
		<div class="container" style="margin-top: 1%;">

			<table id="log_table">
				<thead>
					<tr>
						<th style="width: 2%">DateTime</th>
						<th style="width: 2%">Package Name</th>
						<th style="width: 15%">Message</th>


					</tr>
				</thead>
				<tbody id="log_table_body"></tbody>
			</table>

		</div>

		</section>
	</div>

	</div>
	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>