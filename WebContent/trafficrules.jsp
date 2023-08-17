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

<style type="text/css">
.switch {
	position: relative;
	display: inline-block;
	width: 50px;
	height: 14px;
}

.switch input {
	opacity: 0;
	width: 0;
	height: 0;
}

.slider {
	position: absolute;
	cursor: pointer;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-color: #ccc;
	-webkit-transition: .4s;
	transition: .4s;
}

.slider:before {
	position: absolute;
	content: "";
	height: 27px;
	width: 26px;
	left: 3px;
	bottom: 2px;
	background-color: white;
	-webkit-transition: .4s;
	transition: .4s;
}

input:checked+.slider {
	background-color: #2196F3;
}

input:focus+.slider {
	box-shadow: 0 0 1px #2196F3;
}

input:checked+.slider:before {
	-webkit-transform: translateX(26px);
	-ms-transform: translateX(26px);
	transform: translateX(26px);
}

/* Rounded sliders */
.slider.round {
	border-radius: 54px;
}

.slider.round:before {
	border-radius: 50%;
}
</style>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	function loadTrafficRulesList() {
		$
				.ajax({
					url : "trafficRulesData",
					type : "GET",
					dataType : "json",
					success : function(data) {
						// Clear existing table rows

						var firewallTable = $("#trafficRulesListTable tbody");
						firewallTable.empty();

						var json1 = JSON.stringify(data);

						var json = JSON.parse(json1);

						if (json.status == 'fail') {
							var confirmation = confirm(json.msg);
							if (confirmation) {
								window.location.href = 'login.jsp';
							}
						}

						// Iterate through the user data and add rows to the table
						$
								.each(
										data,
										function(index, trafficrules) {
											var row = $("<tr>");
											row.append($("<td>").text(
													trafficrules.name
															+ ""));
											row.append($("<td>").text(
													trafficrules.protocol + ""));
											row
													.append($("<td>")
															.text(
																	trafficrules.destination_port
																			+ ""));
											row.append($("<td>").text(
													trafficrules.iface + ""));
											row.append($("<td>").text(
													trafficrules.mac_address + ""));
											row.append($("<td>").text(
													trafficrules.ip_address
															+ ""));
											row.append($("<td>").text(
													trafficrules.action
															+ ""));
											row.append($("<td>").text(
													trafficrules.type
															+ ""));

											var actions = $("<td>");
											var deleteButton = $(
													'<button style="background-color: #35449a; border: none; border-radius: 5px; margin-left: 5px; color: white">')
													.text("Delete")
													.click(
															function() {
																deleteFirewall(trafficrules.lineNumber);
															});

											//	actions.append(editButton);
											actions.append(deleteButton);

											row.append(actions);

											firewallTable.append(row);
										});
					},
					error : function(xhr, status, error) {
						console.log("Error loading firewall data: " + error);
					},
				});
	}

	function addFirewall() {
		var portNumber = $("#portNumber").val();
		var protocol = $("#protocol").val();
		var ip_addr = $("#ip_addr").val();

		$.ajax({
			url : "firewallData",
			type : "POST",
			data : {
				portNumber : portNumber,
				protocol : protocol,
				ip_addr : ip_addr,
			},
			success : function(data) {
				// Display the registration status message
				alert(data.message);
				loadFirewallList();

				// Clear form fields
				$("#portNumber").val("");
				$("#protocol").val("");
				$("#ip_addr").val("");
			},
			error : function(xhr, status, error) {
				console.log("Error adding firewall: " + error);
			},
		});

		$("#addFirewall").val("Add");
	}

	function deleteFirewall(firewallId) {
		// Perform necessary actions to delete the user
		// For example, make an AJAX call to a delete servlet

		alert(firewallId);
		var confirmation = confirm("Are you sure you want to delete this firewall setting?");
		if (confirmation) {
			$.ajax({
				url : "firewallDeleteServlet",
				type : "POST",
				data : {
					lineNumber : firewallId,
				},
				success : function(data) {
					// Display the registration status message
					alert(data.message);

					// Refresh the user list
					loadFirewallList();
				},
				error : function(xhr, status, error) {
					// Handle the error response, if needed
					console.log("Error deleting user: " + error);
				},
			});
		}
	}

	

	//Function to execute on page load
	$(document).ready(function() {
		// Load user list
		loadFirewallList();

		// Handle form submission
		$("#trafficRulesForm").submit(function(event) {
			event.preventDefault();
			var buttonText = $("#registerBtn").val();

			if (buttonText == "Add") {
				addFirewall();
			}
		});

		$('#clearBtn').click(function() {
			$('#name').val('');
			$('#interface').val('');
			$('#portNumber').val('');
			$('#macAddress').val('');
			$('#protocol').val('');
			$('#ip_addr').val('');
			$('#type').val('');
			$('#action').val('');

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
		<h3>GENERAL SETTINGS</h3>
		<hr>

		<div class="container">
			<form id="generalSettingsForm">

				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: -25px;">

					<div class="col-75-2" style="width: 20%;">
					<label>Input</label>
						<select class="textBox" id="input" name="input"
							style="height: 35px;">
							<option value="Accept">Accept</option>
							<option value="Reject">Reject</option>
						</select> <span id="inputError" style="color: red;"></span>
					</div>
					<div class="col-75-2" style="width: 20%;">
					<label>Output</label>
						<select class="textBox" id="output" name="output"
							style="height: 35px;">
							<option value="Accept">Accept</option>
							<option value="Reject">Reject</option>
						</select> <span id="outputError" style="color: red;"></span>
					</div>
					<div class="col-75-2" style="width: 20%;">
					<label>Forward</label>
						<select class="textBox" id="forward" name="forward"
							style="height: 35px;">
							<option value="Accept">Accept</option>
							<option value="Reject">Reject</option>
						</select> <span id="forwardError" style="color: red;"></span>
					</div>
					<div class="col-75-2" style="width: 20%;">
					<label>Drop invalid packets</label>
						<select class="textBox" id="invalid_packet" name="invalid_packet"
							style="height: 35px;">
							<option value="on">on</option>
							<option value="off">off</option>
						</select> <span id="forwardError" style="color: red;"></span>
					</div>
				</div>

				
				<div class="row"
					style="display: flex; justify-content: right; margin-top: -1%;">
					<input type="button" value="Apply" id="applyBtn" /> 
				</div>

			</form>
		</div>

		<h3>TRAFFIC RULES</h3>
		<hr>
		<div class="container">

			<form id="trafficRulesForm">

				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: 10px;">

					<div class="col-75-5" style="width: 20%;">
						<input type="text" id="name" name="name" placeholder="Name" />
					</div>

					<div class="col-75-4" style="width: 20%;">
						<input type="text" id="interface" name="interface"
							placeholder="Interface" />
					</div>

					<div class="col-75-1" style="width: 20%;">
						<input type="text" id="portNumber" name="portNumber"
							placeholder="Destination Port" />
					</div>

					<div class="col-75-1" style="width: 20%;">
						<input type="text" id="macAddress" name="macAddress"
							placeholder="Source MAC address" />
					</div>

					<div class="col-75-2" style="width: 20%;">
						<select class="textBox" id="protocol" name="protocol"
							style="height: 35px;">							
							<option value="tcp">tcp</option>
							<option value="udp">udp</option>

						</select>
					</div>
				</div>

				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: 10px;">
					<div class="col-75-3" style="width: 20%;">
						<input type="text" id="ip_addr" name="ip_addr"
							placeholder="Source IP address" />
					</div>
					
					<div class="col-75-2" style="width: 20%;">
						<select class="textBox" id="type" name="type"
							style="height: 35px;">							
							<option value="ip">ip</option>
							<option value="mac">mac</option>

						</select>
					</div>
					
					<div class="col-75-2" style="width: 20%;">
						<select class="textBox" id="action" name="action"
							style="height: 35px;">							
							<option value="ACCEPT">ACCEPT</option>
							<option value="REJECT">REJECT</option>

						</select>
					</div>
					
				</div>

				<div class="row" style="display: flex; justify-content: right; margin-top: 2%;">
					<input type="button" value="Apply" id="applyBtn" /> 
					<input style="margin-left: 5px;" type="button" value="Clear" id="clearBtn" /> 
					<input style="margin-left: 5px;" type="submit" value="Add"
						id="registerBtn" />
				</div>
			</form>
		</div>


		<h3>TRAFFIC RULES LIST</h3>
		<hr>
		<div class="container">
			<table id="trafficRulesListTable">
				<thead>
					<tr>
						<th>Name</th>
						<th>Interface</th>
						<th>Protocol</th>
						<th>Source IP address</th>
						<th>MAC address</th>
						<th>Destination port</th>
						<th>Action</th>
						<th>Type</th>
						<th>Actions</th>
					</tr>
				</thead>
				<tbody>
					<!-- User list table rows will be populated dynamically using JavaScript -->
				</tbody>
			</table>
		</div>
		</section>
	</div>

</body>
</html>