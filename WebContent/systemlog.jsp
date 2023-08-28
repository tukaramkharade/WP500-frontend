<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>WP500 Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="favicon.png" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>


	function searchSystemLogData() {
		var searchQuery = document.getElementById("search_query").value.trim();
		
		var startdatetime = $('#startdatetime').val();
		var enddatetime = $('#enddatetime').val();
		if (searchQuery === "") {
			alert("Please enter a search query.");
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
				enddatetime : enddatetime
			},
			success : function(data) {
				if (data.system_log_result && Array.isArray(data.system_log_result)) {
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
	        	                $("<td>").text(message)
	        	            );
	        	            tableBody.append(row);
	        	        } else {
	        	            var row = $("<tr>").append(
	        	                $("<td>").attr("colspan", 3).text(log) // Update colspan to 3
	        	            );
	        	            tableBody.append(row);
	        	        }
	        	    });
	        	


	                var count = data.system_log_result.length;
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

	}
	
	function getSysLogDate() {
		 
		var startdatetime = $('#startdatetime').val();
		var enddatetime = $('#enddatetime').val();
		var tableBody = $("#log_table_body");
		tableBody.empty();
		$.ajax({
			url : 'loadSystemLog', 
			type : 'POST',
			data : {
				startdatetime : startdatetime,
				enddatetime : enddatetime

			},
			success : function(data) {
				if (data.system_log_result && Array.isArray(data.system_log_result)) {
	                tableBody.empty();

	                data.system_log_result.forEach(function(log) {
	                    var logParts = log.split(" "); // Split the log entry by spaces

	                    if (logParts.length >= 6) {
	                        var month = logParts[0];
	                        var date = logParts[1];
	                        var time = logParts[2];
	                        var projectName = logParts[3];
	                        var message = logParts.slice(4).join(" "); // Join the remaining parts as the message

	                        var row = $("<tr>").append(
	                            $("<td>").text(month),
	                            $("<td>").text(date),
	                            $("<td>").text(time),
	                            $("<td>").text(projectName),
	                            $("<td>").text(message)
	                        );
	                        tableBody.append(row);
	                    } else {
	                        var row = $("<tr>").append(
	                            $("<td>").attr("colspan", 5).text(log)
	                        );
	                        tableBody.append(row);
	                    }
	                });

	                var count = data.system_log_result.length;
	                console.log("count : " + count);

	                var totalPages = Math.ceil(count / 100);
	                console.log("Per page records : " + totalPages);

	                $("#log_table").show();
				}
			},
			error : function(xhr, status, error) {
				console.log('Error setting manual time: ' + error);
			}
		});

	}
	
	function loadSystemLog() {
	    var tableBody = $("#log_table_body");

	    $.ajax({
	        url: "loadSystemLog", // Replace this with the appropriate server-side URL to handle the AJAX GET
	        type: "GET", // Change the request method to GET
	        success: function(data) {
	        	if (data.system_log_result && Array.isArray(data.system_log_result)) {
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
	        	                $("<td>").text(message)
	        	            );
	        	            tableBody.append(row);
	        	        } else {
	        	            var row = $("<tr>").append(
	        	                $("<td>").attr("colspan", 3).text(log) // Update colspan to 3
	        	            );
	        	            tableBody.append(row);
	        	        }
	        	    });
	        	


	                var count = data.system_log_result.length;
	                console.log("count : " + count);

	                var totalPages = Math.ceil(count / 100);
	                console.log("Per page records : " + totalPages);

	                $("#log_table").show();
	            }
	        },
	        error: function(xhr, status, error) {
	            console.log("Error logs: " + error);
	        },
	    });
	}
	//Function to execute on page load
	$(document).ready(function() {
		// Load log file list
		
		
		loadSystemLog();
		
			$(document).on("click", "#loadLogSysFileButton", function() {
					var searchQuery = $("#search_query").val().trim();
					if (searchQuery !== "") {
						//var tableBody = $("#log_table_body");
					//	tableBody.empty();
							console.log("searchQuery: " + searchQuery.length);
							searchSystemLogData();
							
							
					} else {
						var tableBody = $("#log_table_body");
						tableBody.empty();
							getSysLogDate();
					}
				});
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
		<div class="row"
			style="display: flex; flex-content: space-between; margin-top: 5px;">
			<div style="width: 20%;">
				<label for="log_file">Choose a date:</label>
			</div>
			
			<div style="width: 25%; margin-left: -11%;margin-top: 5px;">
				<input type="datetime-local" id="startdatetime" name="startdatetime" >
			</div>
			
			<div style="width: 10%; margin-left: -10%;">
				<label for="log_file">  to  </label>
			</div>
			
			<div style="width: 25%; margin-left: -8%;margin-top: 5px;">
				<input type="datetime-local" id="enddatetime" name="enddatetime" >
			</div>
			
			<div
				style="width: 20%; margin-left: 1%; margin-right: 1%; float: left;">
				<input type="text" id="search_query" placeholder=" Search">
			</div>
			
			<div>
				<input style="margin-left: 1%; margin-top: 5%;" type="button"
					id="loadLogSysFileButton" value="Load System Log File">
			</div>

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