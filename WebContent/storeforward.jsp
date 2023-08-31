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
<link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png" />
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
	var total_pages=0;
	
	function getStoreForwardData() {
		$.ajax({
			url : 'storeForwardDataServlet',
			type : 'GET',
			dataType : 'json',
			success : function(data) {
	            if (Array.isArray(data) && data.length > 0) {
	                total_pages = data[0].total_pages; // Access the total_pages value
	                console.log("totalPageNo: " + total_pages);
	            } else {
	                console.log("No valid data received.");
	            }
	            
	            var storeForwardDataTable = $('#data-table tbody');
	            storeForwardDataTable.empty();

	            var json1 = JSON.stringify(data);
	            var json = JSON.parse(json1);

	            if (json.status == 'fail') {
	                var confirmation = confirm(json.msg);
	                if (confirmation) {
	                    window.location.href = 'login.jsp';
	                }
	            }
	            clearTable();
	            if(data.dateTime != null){
	            	console.log("Data Fetching")
	            $.each(data, function(index, storeForwardData) {
	                var row = $('<tr>');
	                row.append($('<td>').text(storeForwardData.dateTime + ""));
	                row.append($('<td>').text(storeForwardData.dataString + ""));
	                row.append($('<td>').text(storeForwardData.brokerIp + ""));
	                row.append($('<td>').text(storeForwardData.publishTopic + ""));
	                storeForwardDataTable.append(row);
	            });
	            }

	            // Hide pagination controls since there's no pagination
	             
	        },
	        error: function(xhr, status, error) {
	            console.log('Error loading store forward data: ' + error);
	        }
	    });
	}

	function getStoreForward(currentPage) {
	    $.ajax({
	        url: 'storeForwardDataServlet',
	        type: 'POST', // Use POST method
	        data: { currentPage: currentPage }, // Pass current page number
	        dataType: 'json',
	        success: function (data) {
	            if (Array.isArray(data) && data.length > 0) {
	                total_pages = data[0].total_pages; // Access the total_pages value
	                console.log("totalPageNo: " + total_pages);
	            } else {
	                console.log("No valid data received.");
	            }
	            
	            var storeForwardDataTable = $('#data-table tbody');
	            storeForwardDataTable.empty();

	            var json1 = JSON.stringify(data);
	            var json = JSON.parse(json1);

	            if (json.status == 'fail') {
	                var confirmation = confirm(json.msg);
	                if (confirmation) {
	                    window.location.href = 'login.jsp';
	                }
	            }
	            clearTable();
	            $.each(data, function(index, storeForwardData) {
	                var row = $('<tr>');
	                row.append($('<td>').text(storeForwardData.dateTime + ""));
	                row.append($('<td>').text(storeForwardData.dataString + ""));
	                row.append($('<td>').text(storeForwardData.brokerIp + ""));
	                row.append($('<td>').text(storeForwardData.publishTopic + ""));
	                storeForwardDataTable.append(row);
	            });

	            // Hide pagination controls since there's no pagination
	             
	        },
	        error: function(xhr, status, error) {
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
			if(currentPage < total_pages){
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
