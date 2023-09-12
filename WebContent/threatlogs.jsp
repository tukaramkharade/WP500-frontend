<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png" />
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

<style type="text/css">
.red-box {
    display: inline-block;
    width: 40px;
    height: 20px;
    background-color: red;
    color: white;
    text-align: center;
    line-height: 20px;
    
}

.orange-box {
    display: inline-block;
    width: 40px;
    height: 20px;
    background-color: orange;
    color: white;
    text-align: center;
    line-height: 20px;
    
}

.yellow-box {
    display: inline-block;
    width: 40px;
    height: 20px;
    background-color: yellow;
    color: white;
    text-align: center;
    line-height: 20px;
   
}

</style>

<script>

function loadThreatLogs() {
	
	$.ajax({
		url : 'threatLogsServlet',
		type : 'GET',
		dataType : 'json',
		success : function(data) {
			var threatLogsTable = $('#data-table tbody');
			threatLogsTable.empty();
			
			 var json1 = JSON.stringify(data);

			var json = JSON.parse(json1);

			if (json.status == 'fail') {
				var confirmation = confirm(json.msg);
				if (confirmation) {
					window.location.href = 'login.jsp';
				}
			} 

				$.each(data, function(index, threatLogs) {
					
						var row = $('<tr>');
						row.append($('<td>').text(threatLogs.timestamp + ""));
					
						if(threatLogs.priority == '1'){							
							row.append($('<td>').append($('<div>').addClass('red-box').text('high')));
						}else if(threatLogs.priority == '2'){
							row.append($('<td>').append($('<div>').addClass('orange-box').text('medium')));
						}else if(threatLogs.priority == '3'){
							row.append($('<td>').append($('<div>').addClass('yellow-box').text('low')));
						}
						
						row.append($('<td>').text(threatLogs.threat_id + ""));
						row.append($('<td>').text(threatLogs.alert_message + ""));						
						row.append($('<td>').text(threatLogs.src_ip + ""));
						row.append($('<td>').text(threatLogs.src_port + ""));
						row.append($('<td>').text(threatLogs.dest_ip + ""));
						row.append($('<td>').text(threatLogs.dest_port + ""));
						row.append($('<td>').text(threatLogs.protocol_type + ""));
						row.append($('<td>').text(threatLogs.ack_at + ""));
						row.append($('<td>').text(threatLogs.ack_by + ""));
												
						threatLogsTable.append(row);
					
				});

		},
		error : function(xhr, status, error) {
			console.log('Error loading active threats data: ' + error);
		}
	});
}

$(document).ready(function() {
	loadThreatLogs();

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
		<h3>THREAT LOGS</h3>
		<hr />
		
		<div class="container">
		
		<table id="data-table">
				<thead>
						<tr>
							<th>Timestamp</th>
							<th>Priority</th>
							<th>Threat ID</th>
							<th>Alert message</th>
							<th>Src IP</th>
							<th>Src port</th>
							<th>Dest IP</th>
							<th>Dest port</th>
							<th>Protocol type</th>
							<th>Ack at</th>
							<th>Ack by</th>
							
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