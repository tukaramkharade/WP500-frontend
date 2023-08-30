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
var currentPage = 1;
var total_pages=0;

function loadEventData() {
	var tableBody = $("#log_table_body");
     $.ajax({
        url: "loadEventData", // Replace this with the appropriate server-side URL to handle the AJAX GET
        type: "GET", // Change the request method to GET
        success: function(data) {
        	
                total_pages = data.total_page; // Access the total_pages value
                console.log("totalPageNo: " + total_pages);
           		
                var count = data.event_log_result.length;
                console.log("count: " + count);
            if (data.event_log_result && Array.isArray(data.event_log_result)) {
             //   tableBody.empty();
	
                data.event_log_result.forEach(function(log) {
                    var dateTime = log.date_time; // Accessing the date_time property
                    var EventName = log.event_name; // Accessing the event_name property
                    var EventType = log.event_type; // Accessing the event_type property
                    var message = log.msg; // Accessing the msg property

                    var row = $("<tr>").append(
                        $("<td>").text(dateTime),
                        $("<td>").text(EventName),
                        $("<td>").text(EventType),
                        $("<td>").text(message)
                    );
                    tableBody.append(row);
                });

               

              //  var totalPages = Math.ceil(count / 100);
               // console.log("Per page records: " + totalPages);

                $("#log_table").show();
            }
        },
        error: function(xhr, status, error) {
            console.log("Error logs: " + error);
        },
    });
}
function getEventData(currentPage) {
	var tableBody = $("#log_table_body");
    $.ajax({
        url: 'loadEventData',
        type: 'POST', // Use POST method
        data: { currentPage: currentPage }, // Pass current page number
        dataType: 'json',
        success: function (data) {
        	
                total_pages = data.total_page; // Access the total_pages value
                console.log("totalPageNo: " + total_pages);
            	
                var count = data.event_log_result.length;
                console.log("count: " + count);
                
            if (data.event_log_result && Array.isArray(data.event_log_result)) {
                
            	//tableBody.empty();
                data.event_log_result.forEach(function(log) {
                    var dateTime = log.date_time; // Accessing the date_time property
                    var EventName = log.event_name; // Accessing the event_name property
                    var EventType = log.event_type; // Accessing the event_type property
                    var message = log.msg; // Accessing the msg property

                    var row = $("<tr>").append(
                        $("<td>").text(dateTime),
                        $("<td>").text(EventName),
                        $("<td>").text(EventType),
                        $("<td>").text(message)
                    );
                    tableBody.append(row);
                });

                

               // var totalPages = Math.ceil(count / 100);
               // console.log("Per page records: " + totalPages);

                $("#log_table").show();
            }
        },
        error: function(xhr, status, error) {
            console.log("Error logs: " + error);
        },
    });
}

	function updatePageInfo() {
		$('#pageInfo').text('Page ' + currentPage);
	}
	function clearTable() {
        $('#log_table_body').empty();
    }
	$(document).ready(function() {
		clearTable();
		loadEventData();
		$('#prevPage').on('click', function() {
			if (currentPage > 1) {
				currentPage--;
				clearTable();
				getEventData(currentPage);
				updatePageInfo();
			}
		});

		$('#nextPage').on('click', function() {
			if(currentPage < total_pages){
			currentPage++;
			clearTable();
			getEventData(currentPage);
			updatePageInfo();
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
		<h3>EVENT LOGS</h3>
		<hr />
		<div class="row"
			style="display: flex; flex-content: space-between; margin-top: 5px;">
			

		</div>
			<div class="pagination" id="pagination">
				<!-- Ensure the ID is "pagination" -->
				<a href="#" id="prevPage">Previous</a> <span id="pageInfo">Page1</span> 
				<a href="#" id="nextPage">Next</a>
			</div>
	<!-- Table to display the log data -->
	<div class="container" style="margin-top: 1%;">
	
		<table id="log_table">
			<thead>
				<tr>
					<th style="width: 2%">DateTime</th>
					<th style="width: 2%">Event Name</th>
					<th style="width: 2%">Event type</th>
					<th style="width: 15%">Event Message</th>
				

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