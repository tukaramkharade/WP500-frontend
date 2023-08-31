<!DOCTYPE html>
<html>
<head>
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

<script>
	function loadStratonLiveDataList() {
		$.ajax({
			url : 'stratonLiveDataServlet',
			type : 'GET',
			dataType : 'json',
			success : function(data) {
				// Clear existing table rows

				var stratonLiveTable = $('#data-table tbody');
				stratonLiveTable.empty();
				
				var json1 = JSON.stringify(data);

				var json = JSON.parse(json1);

				if (json.status == 'fail') {
					var confirmation = confirm(json.msg);
					if (confirmation) {
						window.location.href = 'login.jsp';
					}
				}

				// Iterate through the user data and add rows to the table
				$.each(data, function(index, stratonLiveData) {

					var row = $('<tr>');
					row.append($('<td>').text(stratonLiveData.tag_name + ""));
					row.append($('<td>').text(stratonLiveData.value + ""));
					row.append($('<td>').text(stratonLiveData.extError + ""));
					row.append($('<td>').text(stratonLiveData.access + ""));
					row.append($('<td>').text(stratonLiveData.error + ""));

					stratonLiveTable.append(row);

				});
			},
			error : function(xhr, status, error) {
				console.log('Error loading straton live data: ' + error);
			}
		});
	}

	$(document).ready(function() {
		loadStratonLiveDataList();

	});
</script>
</head>


<body>
	<div class="sidebar"><%@ include file="common.jsp"%></div>
	<div class="header"><%@ include file="header.jsp"%></div>
	<div class="content">
		<section style="margin-left: 1em">
			<h3>STRATON LIVE DATA</h3>
			<button onClick="window.location.reload();"
				style="cursor: pointer; background-color: #35449a; border-radius: 5px; border: none; color: white; font-size: small">Refresh
				Page</button>

			<div id="search">
				<!-- <label for="searchInput">Find <i class="fa fa-search"></i>Tags</label> -->
				<input id="searchInput" type="text" placeholder="Search" onkeyup="myFunction()"
					style="margin-top: 5px;">
			</div>


			<hr />

			<div class="container">

				<table id="data-table">
					<thead>
						<tr>
							<th>Tag Name</th>
							<th>Value</th>
							<th>ExtError</th>
							<th>Access</th>
							<th>Error</th>
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
