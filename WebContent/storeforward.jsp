<!DOCTYPE html>
<html>
<head>
<title>WPConnex Web Configuration</title>
<style>

.pagination {
	display: flex;
	justify-content: flex-start;
	align-items: center;
}

#prevPage, #nextPage {
	margin-right: 10px; /* Add some spacing between the links */
	margin-left: 5px;
}
</style>
<link rel="icon" type="image/png" sizes="32x32"
	href="images/WP_Connex_logo_favicon.png" />
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
	var currentPage = 1; // Initial page
	var itemsPerPage = 100; // Items per page
	var total_pages = 0;
	var tokenValue;

	function getStoreForwardData() {
		$.ajax({
			url : 'storeForwardDataServlet',
			type : 'GET',
			dataType : 'json',
			beforeSend: function(xhr) {
		        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
		    },
			success : function(data) {
				 var json1 = JSON.stringify(data);
				 var json = JSON.parse(json1);
				 handleStatus(json.status);
				 
				 total_pages = data.total_page; // Access the total_pages value
				//         console.log("totalPageNo: " + total_pages);

				var count = data.event_log_result.length;
				//          console.log("count: " + count);
				if (data.event_log_result
						&& Array.isArray(data.event_log_result)) {
					//   tableBody.empty();
					var storeForwardDataTable = $('#data-table tbody');
					storeForwardDataTable.empty();

					data.event_log_result.forEach(function(log) {
						var dateTime = log.date_time; // Accessing the date_time property
						var dataString = log.data_string; // Accessing the event_name property
						var brokerIp = log.broker_ip; // Accessing the event_type property
						var publishTopic = log.publish_topic; // Accessing the msg property

						var row = $("<tr>").append($("<td>").text(dateTime),
								$("<td>").text(dataString),
								$("<td>").text(brokerIp),
								$("<td>").text(publishTopic));
						storeForwardDataTable.append(row);
					});

				}
			},
			error : function(xhr, status, error) {
				console.log('Error loading store forward data: ' + error);
			}
		});
	}

	function getStoreForward(currentPage) {
		$.ajax({
			url : 'storeForwardDataServlet',
			type : 'POST', // Use POST method
			data : {
				currentPage : currentPage
			}, // Pass current page number
			dataType : 'json',
			beforeSend: function(xhr) {
		        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
		    },
			success : function(data) {
				total_pages = data.total_page; // Access the total_pages value
				//         console.log("totalPageNo: " + total_pages);

				var count = data.event_log_result.length;
				//          console.log("count: " + count);
				if (data.event_log_result
						&& Array.isArray(data.event_log_result)) {
					//   tableBody.empty();
					var storeForwardDataTable = $('#data-table tbody');
					storeForwardDataTable.empty();

					data.event_log_result.forEach(function(log) {
						var dateTime = log.date_time; // Accessing the date_time property
						var dataString = log.data_string; // Accessing the event_name property
						var brokerIp = log.broker_ip; // Accessing the event_type property
						var publishTopic = log.publish_topic; // Accessing the msg property

						var row = $("<tr>").append($("<td>").text(dateTime),
								$("<td>").text(dataString),
								$("<td>").text(brokerIp),
								$("<td>").text(publishTopic));
						storeForwardDataTable.append(row);
					});

				}
			},
			error : function(xhr, status, error) {
				console.log('Error loading store forward data: ' + error);
			}
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

	function clearTable() {
		$('#data-table tbody').empty();
	}
	function updatePageInfo() {
		$('#pageInfo').text('Page ' + currentPage);
	}
	$(document).ready(function() {
		
		<%// Access the session variable
		HttpSession token = request.getSession();
		String tokenValue = (String) session.getAttribute("token");%>

		tokenValue = '<%=tokenValue%>';
		
		getStoreForwardData();

		$('#prevPage').on('click', function() {
			if (currentPage > 1) {
				currentPage--;
				clearTable();
				getStoreForward(currentPage);
				updatePageInfo();
			}
		});

		$('#nextPage').on('click', function() {

			console.log("totalPageNo: " + total_pages);
			if (currentPage < total_pages) {
				currentPage++;
				clearTable();
				getStoreForward(currentPage);
				updatePageInfo();
			}
		});

	});
</script>
</head>


<body>
	<div class="sidebar"><%@ include file="common.jsp"%></div>
	<div class="header"><%@ include file="header.jsp"%></div>
	<div class="content">
		<section style="margin-left: 1em">
			<h3>STORE FORWARD DATA</h3>
			<button onClick="window.location.reload();"
				style="cursor: pointer; background-color: #35449a; border-radius: 5px; border: none; color: white; font-size: small">Refresh
				Page</button>

			<div class="pagination" id="pagination">
				<!-- Ensure the ID is "pagination" -->
				<a href="#" id="prevPage">Previous</a> <span id="pageInfo">Page1</span>
				<a href="#" id="nextPage">Next</a>
			</div>
					  
			<hr />
			
			<div id="custom-modal-session-timeout" class="modal-session-timeout">
				<div class="modal-content-session-timeout">
					  <p>Your session is timeout. Please login again</p>
					  <button id="confirm-button-session-timeout">OK</button>
				</div>
    		</div>

			<div class="container">

				<table id="data-table">
					<thead>
						<tr>
							<th>Date Time</th>
							<th>Data String</th>
							<th>Broker Ip</th>
							<th>Publish Topic Ip</th>


						</tr>
					</thead>
					<tbody>
						<!-- Table rows will be dynamically generated here -->
					</tbody>
				</table>
			</div>

		</section>
	</div>
	
	<div class="footer"><%@ include file="footer.jsp"%></div>
	
</body>
</html>
