<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
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

</style>
<script>

var roleValue;
var tokenValue;

	function searchLogData() {
		var searchQuery = document.getElementById("search_query").value.trim();
		var selectedLogFile = document.getElementById("log_file").value;
		if (selectedLogFile === "") {
			
			// Display the custom popup message
     			$("#popupMessage").text("Please select a log file first.");
      			$("#customPopup").show();
			return;
		}

		if (searchQuery === "") {
		
			$("#popupMessage").text("Please enter a search query.");
      			$("#customPopup").show();
      			
			return;
		}
		var tableBody = $("#log_table_body");
		console.log("Clearing table body"); // Debug statement
		tableBody.empty(); // Clear the table body before adding search results
		$.ajax({
			url : "search_logs", // Replace this with the appropriate server-side URL to handle the search
			type : "POST",
			data : {
				search_query : searchQuery,
				log_file : selectedLogFile,
			},
			beforeSend: function(xhr) {
		        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
		    },
			success : function(data) {
				if (data.log_search_result
						&& Array.isArray(data.log_search_result)) {
					var tableBody = $("#log_table_body");
					//	tableBody.empty();

					data.log_search_result.forEach(function(log) {
						var myArray = log.split(",");
						var split_log0 = myArray[0];
						var split_log1 = myArray[1];
						var split_log2 = myArray[2];
						var split_log4 = myArray[4];
						var split_log5 = myArray[5];

						var row = $("<tr>").append(
								$('<td style="width: 20%;">').text(split_log0),
								$("<td>").text(split_log1),
								$("<td>").text(split_log2),
								$("<td>").text(split_log4),
								$("<td>").text(split_log5));
						tableBody.append(row);
					});

					var count = data.log_search_result.length;
					console.log("count : " + count);

					var totalPages = Math.ceil(count / 100);
					console.log("Per page records : " + totalPages);

					$("#log_table").show();
				}
			},
			error : function(xhr, status, error) {
				console.log("Error logs: " + error);
			},
		});
		
		$("#closePopup").click(function () {
		    $("#customPopup").hide();
		  });

	}

	function loadLogFileList() {
		$
				.ajax({
					url : "logs",
					type : "GET",
					dataType : "json",
					success : function(data) {
						
						var json1 = JSON.stringify(data);

						var json = JSON.parse(json1);

						handleStatus(json.status);
							
						if (data.log_file_result
								&& Array.isArray(data.log_file_result)) {
							var selectElement = $("#log_file");
							// Clear any existing options
							selectElement.empty();
							
							// Loop through the data and add options to the select element
							data.log_file_result.forEach(function(filename) {
								var option = $("<option>", {
									value : filename,
									text : filename,
								});
								selectElement.append(option);
							});
						}
					},
					error : function(xhr, status, error) {
						console.log("Error logs: " + error);
					},
				});
	}

	function changeButtonColor(isDisabled) {
        var $load_button = $('#loadLogFileButton');
        
        if (isDisabled) {
            $load_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $load_button.css('background-color', '#2b3991'); // Reset to original color
        }
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
	
	
	
	//Function to execute on page load
	$(document).ready(function() {
		// Load log file list
		
		<%
	    	    	// Access the session variable
	    	    	HttpSession role = request.getSession();
	    	    	String roleValue = (String) session.getAttribute("role");
	    	    	%>
	    	    	
	    	    	roleValue = '<%= roleValue %>'; // This will insert the session value into the JavaScript code
	    	    	
	    	    	<%// Access the session variable
	    	    	HttpSession token = request.getSession();
	    	    	String tokenValue = (String) session.getAttribute("token");%>

	    	    	tokenValue = '<%=tokenValue%>';
	    	    	
	    	    	
	    	    	if(roleValue == 'VIEWER' || roleValue == 'Viewer'){
	  	    		  
	  	    		$('#loadLogFileButton').prop('disabled', true);
	  	    		  
	  	    		  changeButtonColor(true);
	  	    	  }
		loadLogFileList();
		/* $("#exportButton").click(function() {		   
		    var selectedLogFile = document.getElementById("log_file").value;

		    if (selectedLogFile !== "") {
		       
		        $.ajax({
		            type: "POST",
		            url: "DownloadLogServlet",
		            log_file: selectedLogFile,
		            success: function(response) {
		                // Handle the success response, if needed
		                if (response.log_file_result === "success") {
		                    // Handle successful download
		                    // You can access the log content with response.log_content
		                    console.log("Log content:", response.log_content);
		                } else {
		                    // Handle error cases
		                    console.error("Error: " + response.message);
		                }
		            },
		            error: function(xhr, status, error) {
		                // Handle errors, if any
		                console.error("Error: " + error);
		            }
		        });
		    } else {
		        // Handle the case when no log file is selected
		        $("#popupMessage").text("Please select a log file first.");
		        $("#customPopup").show();
		    }
		}); */
		$("#exportButton").click(function() {
	        var selectedLogFile = $("#log_file").val();

	        if (selectedLogFile !== "") {
	            // Redirect to the servlet URL to trigger the download
	            window.location.href = "DownloadLogServlet?log_file=" + selectedLogFile;
	        } else {
	            // Handle the case when no log file is selected
	            $("#popupMessage").text("Please select a log file first.");
	            $("#customPopup").show();
	        }
	    });		
		
		$(document).on("click", "#loadLogFileButton", function() {
			var searchQuery = $("#search_query").val().trim();
			if (searchQuery !== "") {
				console.log("searchQuery: " + searchQuery.length);
				searchLogData();
			} else {
				loadLogFile();
			}
		});

	});

	function loadLogFile() {
		// Get the selected log file value from the dropdown
		var selectedLogFile = document.getElementById("log_file").value;
		var tableBody = $("#log_table_body");
		console.log("Clearing table body"); // Debug statement
		tableBody.empty();
		if (selectedLogFile !== "") {
			// Make an AJAX POST request to fetch the log data
			$
					.ajax({
						url : "logs", // Replace this with the appropriate server-side URL to handle the AJAX POST
						type : "POST",
						data : {
							log_file : selectedLogFile,
						}, // Send the selected log file name as POST data
						//dataType : "json",
						success : function(data) {
							// Data is the JSON array returned from the server
							if (data.log_file_data
									&& Array.isArray(data.log_file_data)) {
								var tableBody = $("#log_table_body");
								tableBody.empty(); // Clear any existing data

								// Loop through the log data and add rows to the table
								data.log_file_data.forEach(function(log) {

									//let text = "How are you doing today?";
									var myArray = log.split(",");
									var split_log0 = myArray[0];
									var split_log1 = myArray[1];
									var split_log2 = myArray[2];
									var split_log4 = myArray[4];
									var split_log5 = myArray[5];

									var row = $("<tr>").append(
											$('<td style="width: 20%;">').text(
													split_log0),
											$("<td>").text(split_log1),
											$("<td>").text(split_log2),
											$("<td>").text(split_log4),
											$("<td>").text(split_log5)
									/*  $("<td>").text(sub_log2),
									 $("<td>").text(sub_log3) */
									);
									tableBody.append(row);
								});

								var count = data.log_file_data.length;
								console.log("count : " + count);

								var totalPages = Math.ceil(count / 100);
								console.log("Per page records : " + totalPages);

								// Show the table
								$("#log_table").show();
							}
						},
						error : function(xhr, status, error) {
							console.log("Error logs: " + error);
						},
					});
		} else {
			
			// Display the custom popup message
 			$("#popupMessage").text("Please select a log file first.");
  			$("#customPopup").show();
  			
  			$("#closePopup").click(function () {
  			    $("#customPopup").hide();
  			  });
		}
	}
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
		<h3>LOGS</h3>
		<hr />
		<div class="row"
			style="display: flex; flex-content: space-between; margin-top: 5px;">
			<div style="width: 20%;">
				<label for="log_file">Choose a log file:</label>
			</div>
			<div style="width: 25%; margin-left: -11%;">
				<select id="log_file">
					<option value="">Select Log File First</option>
				</select>
			</div>
			<div
				style="width: 20%; margin-left: 1%; margin-right: 1%; float: left;">
				<input type="text" id="search_query" placeholder=" Search">
			</div>
			<div>
				<input style="margin-left: 1%; margin-top: 5%;" type="button"
					id="loadLogFileButton" value="Load Log File">
			</div>
			<div>
    			<input style="margin-left: 10px; margin-top: 5%;flex-content: space-between;" type="button" id="exportButton" value="Export Log File">
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
		
	<!-- Table to display the log data -->
	<div class="container" style="margin-top: 1%;">
	
		<table id="log_table">
			<thead>
				<tr>
					<th style="width: 15%">Date and Time</th>
					<th style="width: 8%">Log Type</th>
					<th style="width: 15%">Line Number</th>
					<th>Class</th>
					<th style="width: 55%">Message</th>

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