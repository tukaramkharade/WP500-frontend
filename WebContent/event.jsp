<!DOCTYPE html>
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
</style>
<script>
var currentPage = 1;
var total_pages=0;
var tokenValue;

function loadEventData() {
	var tableBody = $("#log_table_body");
     $.ajax({
        url: "loadEventData", // Replace this with the appropriate server-side URL to handle the AJAX GET
        type: "GET", // Change the request method to GET
        beforeSend: function(xhr) {
	        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
	    },
        success: function(data) {
        	 var json1 = JSON.stringify(data);
			 var json = JSON.parse(json1);
			 handleStatus(json.status);
        	
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

	function updatePageInfo() {
		$('#pageInfo').text('Page ' + currentPage);
	}
	function clearTable() {
        $('#log_table_body').empty();
    }
	$(document).ready(function() {
		
		<%// Access the session variable
		HttpSession token = request.getSession();
		String tokenValue = (String) session.getAttribute("token");%>

		tokenValue = '<%=tokenValue%>';
		
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
		
		<div id="custom-modal-session-timeout" class="modal-session-timeout">
				<div class="modal-content-session-timeout">
				  <p>Your session is timeout. Please login again</p>
				  <button id="confirm-button-session-timeout">OK</button>
				</div>
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