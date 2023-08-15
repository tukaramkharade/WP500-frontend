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
	left: 6.3px;
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
	function loadFirewallList() {
		$
				.ajax({
					url : "firewallData",
					type : "GET",
					dataType : "json",
					success : function(data) {
						// Clear existing table rows

						var firewallTable = $("#firewallListTable tbody");
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
										function(index, firewall) {
											var row = $("<tr>");
											row.append($("<td>").text(
													firewall.lineNumber + ""));
											row.append($("<td>").text(
													firewall.target + ""));
											row.append($("<td>").text(
													firewall.protocol + ""));
											row.append($("<td>").text(
													firewall.opt + ""));
											row.append($("<td>").text(
													firewall.source + ""));
											row.append($("<td>").text(
													firewall.destination + ""));

											var actions = $("<td>");
											var deleteButton = $(
													'<button style="background-color: #35449a; border: none; border-radius: 5px; margin-left: 5px; color: white">')
													.text("Delete")
													.click(
															function() {
																deleteFirewall(firewall.lineNumber);
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

	function toggle() {
		var toggleButton = document.getElementById("ntp_client");
		var ipField = document.getElementById("ntp_interval");
		var serverField = document.getElementById("ntp_server");

		if (toggleButton.checked) {
			ipField.disabled = false;
			serverField.disabled = false;
			toggleButton.value = "1"; //ntp_client_enable
		} else {
			ipField.disabled = true;
			serverField.disabled = true;
			toggleButton.value = "0"; //ntp_client_disable
		}
	}

	//Function to execute on page load
	$(document).ready(function() {
		// Load user list
		loadFirewallList();

		// Handle form submission
		$("#firewallForm").submit(function(event) {
			event.preventDefault();
			var buttonText = $("#registerBtn").val();

			if (buttonText == "Add") {
				addFirewall();
			}
		});

		$('#clearBtn').click(function() {
			$('#portNumber').val('');
			$('#protocol').val('');
			$('#ip_addr').val('');

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
		<h3>FIREWALL</h3>
		<hr>

		<div class="container">
			<form id="firewallForm" method="post">

				<div class="row">
					<div
						style="width: 40%; margin-top: -20px; display: flex; justify-content: left;">

						<label for="enable">Enable</label> <label class="switch">
							<input type="checkbox" checked> <span
							class="slider round"></span>
						</label>

					</div>

				</div>

				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: 10px;">

					<div class="col-75-5" style="width: 20%;">
						<input type="text" id="name" name="name" placeholder="Name" />
					</div>

					<div class="col-75-4" style="width: 20%;">
						<input type="text" id="destination_address"
							name="destination_address" placeholder="Destination address" />
					</div>

					<div class="col-75-1" style="width: 20%;">
						<input type="text" id="portNumber" name="portNumber"
							placeholder="Source Port" />
					</div>

					<div class="col-75-1" style="width: 20%;">
						<input type="text" id="macAddress" name="macAddress"
							placeholder="Source MAC address" />
					</div>

					<div class="col-75-2" style="width: 20%;">
						<select class="textBox" id="protocol" name="protocol"
								style="height: 35px;">
								<option value="Select protocol">Select protocol</option>
								<option>TCP</option>
								<option>UDP</option>

							</select>
					</div>
				</div>

				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: 10px;">
					<div class="col-75-3" style="width: 20%;">
						<input type="text" id="ip_addr" name="ip_addr"
							placeholder="Source IP address" />
					</div>
				</div>

				<div class="row"
					style="display: flex; justify-content: right; margin-top: 2%;">
					<input type="button" value="Clear" id="clearBtn" /> <input
						style="margin-left: 5px;" type="submit" value="Add"
						id="registerBtn" />
				</div>
			</form>
		</div>

		<h3>FIREWALL SETTINGS LIST</h3>
		<hr>
		<div class="container">
			<table id="firewallListTable">
				<thead>
					<tr>
						<th>Chain Number</th>
						<th>Target</th>
						<th>Protocol</th>
						<th>Opt</th>
						<th>Source</th>
						<th>Destination</th>
						<th>Action</th>
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