<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>WP500 Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="favicon.png" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>

function getActiveThreats() {
	
	$.ajax({
		url : 'activeThreatServlet',
		type : 'GET',
		dataType : 'json',
		success : function(data) {
			var activeThreatsTable = $('#data-table tbody');
			activeThreatsTable.empty();
			
			 var json1 = JSON.stringify(data);

			var json = JSON.parse(json1);

			if (json.status == 'fail') {
				var confirmation = confirm(json.msg);
				if (confirmation) {
					window.location.href = 'login.jsp';
				}
			} 

			
				$.each(data, function(index, activeThreats) {
					
						var row = $('<tr>');
						row.append($('<td>').text(
								activeThreats.src_ip + ""));
						row.append($('<td>').text(
								activeThreats.src_port + ""));
						row.append($('<td>').text(
								activeThreats.protocol_type + ""));
						row.append($('<td>').text(
								activeThreats.ack_at + ""));
						row.append($('<td>').text(
								activeThreats.ack_by + ""));
						row.append($('<td>').text(
								activeThreats.alert_message + ""));
						row.append($('<td>').text(
								activeThreats.dest_ip + ""));
						row.append($('<td>').text(
								activeThreats.threat_id + ""));
						row.append($('<td>').text(
								activeThreats.priority + ""));
						row.append($('<td>').text(
								activeThreats.dest_port + ""));
						row.append($('<td>').text(
								activeThreats.timestamp + ""));
						
						activeThreatsTable.append(row);
					
				});

		},
		error : function(xhr, status, error) {
			console.log('Error loading active threats data: ' + error);
		}
	});
}

$(document).ready(function() {
	getActiveThreats();

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
		<h3>THREATS AND ATTACKS</h3>
		<hr />
		
		<div class="container">

				<table id="data-table">
				<thead>
						<tr>
							<th>Src IP</th>
							<th>Src port</th>
							<th>Protocol type</th>
							<th>Ack at</th>
							<th>Ack by</th>
							<th>Alert message</th>
							<th>Dest IP</th>
							<th>Threat ID</th>
							<th>Priority</th>
							<th>Dest port</th>
							<th>Timestamp</th>
						</tr>
					</thead>
					<tbody>
						<!-- Table rows will be dynamically generated here -->
					</tbody>
				</table>
				</div>
		</section>
		</div>

	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>