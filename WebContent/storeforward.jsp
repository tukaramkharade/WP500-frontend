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

<script>
	var currentPage = 1; // Initial page
	var itemsPerPage = 100; // Items per page
	var total_pages = 0;

	function getStoreForwardData() {
		$.ajax({
			url : 'storeForwardDataServlet',
			type : 'GET',
			dataType : 'json',
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

	function getStoreForward(currentPage) {
		$.ajax({
			url : 'storeForwardDataServlet',
			type : 'POST', // Use POST method
			data : {
				currentPage : currentPage
			}, // Pass current page number
			dataType : 'json',
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

	function clearTable() {
		$('#data-table tbody').empty();
	}
	function updatePageInfo() {
		$('#pageInfo').text('Page ' + currentPage);
	}
	$(document).ready(function() {
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
