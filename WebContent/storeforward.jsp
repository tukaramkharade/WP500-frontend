<!DOCTYPE html>
<html>
<head>
<title>WP500 Web Configuration</title>
<style>
.pagination {
	display: flex;
	justify-content: flex-start;
	align-items: center;
}

#prevPage, #nextPage {
	margin-right: 10px; /* Add some spacing between the links */
}
</style>
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
	var currentPage = 1; // Initial page
	var itemsPerPage = 100; // Items per page

	function getStoreForwardData() {
		$.ajax({
			url : 'storeForwardDataServlet',
			type : 'GET',
			dataType : 'json',
			success : function(data) {
				var storeForwardDataTable = $('#data-table tbody');
				storeForwardDataTable.empty();

				var startIndex = (currentPage - 1) * itemsPerPage;
				var endIndex = startIndex + itemsPerPage;

				if (data.length > 0) {
					$.each(data, function(index, storeForwardData) {
						if (index >= startIndex && index < endIndex) {
							var row = $('<tr>');
							row.append($('<td>').text(
									storeForwardData.dateTime + ""));
							row.append($('<td>').text(
									storeForwardData.dataString + ""));
							row.append($('<td>').text(
									storeForwardData.brokerIp + ""));
							row.append($('<td>').text(
									storeForwardData.publishTopic + ""));
							storeForwardDataTable.append(row);
						}
					});

					// Show pagination controls if needed
					$('#pagination').show();
				} else {
					// Hide pagination controls if there is no data
					$('#pagination').hide();
				}
			},
			error : function(xhr, status, error) {
				console.log('Error loading store forward data: ' + error);
			}
		});
	}

	$(document).ready(function() {
		getStoreForwardData();
		$('#prevPage').on('click', function() {
			if (currentPage > 1) {
				currentPage--;
				getStoreForwardData();
				updatePageInfo();
			}
		});

		$('#nextPage').on('click', function() {
			currentPage++;
			getStoreForwardData();
			updatePageInfo();
		});
		function updatePageInfo() {
			$('#pageInfo').text('Page ' + currentPage);
		}
		
});
	

</script>
</head>


<body>
	<div class="sidebar"><%@ include file="common.jsp"%></div>
	<div class="header"><%@ include file="header.jsp"%></div>
	<div class="content">
		<section style="margin-left: 1em">
			<h3>STORE FORWORD DATA</h3>
			<button onClick="window.location.reload();"
				style="cursor: pointer; background-color: #35449a; border-radius: 5px; border: none; color: white; font-size: small">Refresh
				Page</button>

			<div class="pagination" id="pagination">
				<!-- Ensure the ID is "pagination" -->
				<a href="#" id="prevPage">Previous</a> <span id="pageInfo">Page
					1</span> <a href="#" id="nextPage">Next</a>
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
	<script>
		function myFunction() {
			var input, filter, table, tr, td, i, txtValue;
			input = document.getElementById("searchInput");
			filter = input.value.toUpperCase();
			table = document.getElementById("data-table");
			tr = table.getElementsByTagName("tr");
			for (i = 0; i < tr.length; i++) {
				td = tr[i].getElementsByTagName("td")[0];
				if (td) {
					txtValue = td.textContent || td.innerText;
					if (txtValue.toUpperCase().indexOf(filter) > -1) {
						tr[i].style.display = "";
					} else {
						tr[i].style.display = "none";
					}
				}
			}
		}
	</script>
	<div class="footer"><%@ include file="footer.jsp"%></div>
</body>
</html>
