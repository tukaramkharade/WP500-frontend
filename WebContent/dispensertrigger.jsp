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
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	function loadBrokerIPList() {
		$.ajax({
			url : "dispenserTriggerDataServlet",
			type : "GET",
			dataType : "json",
			success : function(data) {
				if (data.broker_ip_result
						&& Array.isArray(data.broker_ip_result)) {

					var selectElement = $("#broker_name");
					// Clear any existing options
					selectElement.empty();

					// Loop through the data and add options to the select element
					data.broker_ip_result.forEach(function(filename) {
						var option = $("<option>", {
							value : filename,
							text : filename,
						});
						selectElement.append(option);
					});

				}
			},
			error : function(xhr, status, error) {
				console.log("Error showing broker ip list : " + error);
			},
		});
	}
	
	
	function loadDispenserTriggerList() {
		$
				.ajax({
					url : 'dispenserTriggerEditServlet',
					type : 'GET',
					dataType : 'json',
					success : function(data) {
						// Clear existing table rows
						var dispenserTriggerTable = $('#dispenserTriggerListTable tbody');
						dispenserTriggerTable.empty();

						// Iterate through the user data and add rows to the table
						$
								.each(
										data,
										function(index, dispenserTrigger) {
											var row = $('<tr>');
											row.append($('<td>').text(dispenserTrigger.station_name));
											row.append($('<td>').text(dispenserTrigger.serial_number));
											row.append($('<td>').text(dispenserTrigger.side));
											row.append($('<td>').text(dispenserTrigger.trigger_tag));
											row.append($('<td>').text(dispenserTrigger.trigger_value));
											row.append($('<td>').text(dispenserTrigger.start_pressesure));
											row.append($('<td>').text(dispenserTrigger.end_pressure)); 
											row.append($('<td>').text(dispenserTrigger.tempreture));
											row.append($('<td>').text(dispenserTrigger.total));
											row.append($('<td>').text(dispenserTrigger.unit_price));
											row.append($('<td>').text(dispenserTrigger.quantity));
											row.append($('<td>').text(dispenserTrigger.broker_ip_address));
											row.append($('<td>').text(dispenserTrigger.status));

											var actions = $('<td>');
											var editButton = $(
													'<button style="background-color: #35449a; border: none; border-radius: 5px; margin-left: 5px; color: white">')
													.text('Edit')
													.click(
															function() {
																setSerialNumber(dispenserTrigger.serial_number);
																setStationName(dispenserTrigger.station_name);
																setSide(dispenserTrigger.side);
																setBrokerName(dispenserTrigger.broker_ip_address);
																setTriggerTag(dispenserTrigger.trigger_tag);
																setTriggerValue(dispenserTrigger.trigger_value);
																setStartPressure(dispenserTrigger.start_pressesure);
																setEndPressure(dispenserTrigger.end_pressure);
																setTemperature(dispenserTrigger.tempreture);
																setTotal(dispenserTrigger.total);
																setQuantity(dispenserTrigger.quantity);
																setUnitPrice(dispenserTrigger.unit_price);
																setStatus(dispenserTrigger.status);
															});

											var deleteButton = $(
													'<button style="background-color: red; border: none; border-radius: 5px; margin-left: 5px; color: white; margin-top: 3px;">')
													.text('Delete')
													.click(
															function() {
																deleteDispenserTrigger(dispenserTrigger.serial_number, dispenserTrigger.side);
															});

											actions.append(editButton);
											actions.append(deleteButton);

											row.append(actions);

											dispenserTriggerTable.append(row);

										});
					},
					error : function(xhr, status, error) {
						console.log('Error loading jsonBuilderTable data: '
								+ error);
					}
				});
	}

	function setSerialNumber(dispenserTriggerId) {
		// Make an AJAX GET request to retrieve user details for editing

		$('#serial_number').val(dispenserTriggerId);
		$("#serial_number").prop("disabled", true);

		$('#registerBtn').val('Edit');

	}
	
	function setStationName(dispenserTriggerId) {

		$('#station_name').val(dispenserTriggerId);
	}
	
	function setSide(dispenserTriggerId) {

		$('#side').val(dispenserTriggerId);
		$("#side").prop("disabled", true);
	}
	
	function setBrokerName(dispenserTriggerId) {

		$('#broker_name').val(dispenserTriggerId);
	}
	
	function setTriggerTag(dispenserTriggerId) {

		$('#trigger_tag').val(dispenserTriggerId);
	}
	
	function setTriggerValue(dispenserTriggerId) {

		$('#trigger_value').val(dispenserTriggerId);
	}
	
	function setStartPressure(dispenserTriggerId) {

		$('#start_pressure').val(dispenserTriggerId);
	}
	
	function setEndPressure(dispenserTriggerId) {

		$('#end_pressure').val(dispenserTriggerId);
	}
	
	function setTemperature(dispenserTriggerId) {

		$('#temperature').val(dispenserTriggerId);
	}
	
	function setTotal(dispenserTriggerId) {

		$('#total').val(dispenserTriggerId);
	}
	
	function setQuantity(dispenserTriggerId) {

		$('#quantity').val(dispenserTriggerId);
	}
	
	function setUnitPrice(dispenserTriggerId) {

		$('#unit_price').val(dispenserTriggerId);
	}
	
	function setStatus(dispenserTriggerId) {

		$('#status').val(dispenserTriggerId);
	}
	
	
	function editDispenserTrigger() {

		var confirmation = confirm('Are you sure you want to edit this dispenser trigger settings?');

		var station_name = $('#station_name').val();
		var serial_number = $('#serial_number').val();
		//var side = $('#side').val();
		var side = $('#side').find(":selected").val();
		var broker_name = $('#broker_name').find(":selected").val();
		var trigger_tag = $('#trigger_tag').val();
		var trigger_value = $('#trigger_value').val();
		var start_pressure = $('#start_pressure').val();
		var end_pressure = $('#end_pressure').val();
		var temperature = $('#temperature').val();
		var total = $('#total').val();
		var quantity = $('#quantity').val();
		var unit_price = $('#unit_price').val();
		var status = $('#status').find(":selected").val();

		$.ajax({
			url : 'dispenserTriggerEditServlet',
			type : 'POST',
			data : {
				station_name : station_name,
				serial_number : serial_number,
				side : side,
				broker_name : broker_name,
				trigger_tag : trigger_tag,
				trigger_value : trigger_value,
				start_pressure : start_pressure,
				end_pressure : end_pressure,
				temperature : temperature,
				total : total,
				quantity : quantity,
				unit_price : unit_price,
				status : status
			},
			success : function(data) {
				// Display the registration status message
				alert(data.message);
				loadDispenserTriggerList();

				// Clear form fields

				$('#station_name').val('');
				$('#serial_number').val('');
				$('#side').val('');
				$('#broker_name').val('');
				$('#trigger_tag').val('');
				$('#trigger_value').val('');
				$('#start_pressure').val('');
				$('#end_pressure').val('');
				$('#temperature').val('');
				$('#total').val('');
				$('#quantity').val('');
				$('#unit_price').val('');
				$('#status').val('');
				
				$("#serial_number").prop("disabled", false);
				
				$("#side").prop("disabled", false);
			},
			error : function(xhr, status, error) {
				console.log('Error updating dispenser trigger settings: ' + error);
			}
		});

		$('#registerBtn').val('Add');
	}

	
	function addDispenserTrigger() {

		var station_name = $('#station_name').val();
		var serial_number = $('#serial_number').val();
		//var side = $('#side').val();
		var side = $('#side').find(":selected").val();
		var broker_name = $('#broker_name').find(":selected").val();
		var trigger_tag = $('#trigger_tag').val();
		var trigger_value = $('#trigger_value').val();
		var start_pressure = $('#start_pressure').val();
		var end_pressure = $('#end_pressure').val();
		var temperature = $('#temperature').val();
		var total = $('#total').val();
		var quantity = $('#quantity').val();
		var unit_price = $('#unit_price').val();
		var status = $('#status').find(":selected").val();
			
			
		$.ajax({
			url : 'dispenserTriggerDataServlet',
			type : 'POST',
			data : {
				station_name : station_name,
				serial_number : serial_number,
				side : side,
				broker_name : broker_name,
				trigger_tag : trigger_tag,
				trigger_value : trigger_value,
				start_pressure : start_pressure,
				end_pressure : end_pressure,
				temperature : temperature,
				total : total,
				quantity : quantity,
				unit_price : unit_price,
				status : status
			},
			success : function(data) {
				// Display the registration status message
				alert(data.message);
				loadDispenserTriggerList();
				
				// Clear form fields

				$('#station_name').val('');
				$('#serial_number').val('');
				$('#side').val('');
				$('#broker_name').val('');
				$('#trigger_tag').val('');
				$('#trigger_value').val('');
				$('#start_pressure').val('');
				$('#end_pressure').val('');
				$('#temperature').val('');
				$('#total').val('');
				$('#quantity').val('');
				$('#unit_price').val('');
				$('#status').val('');
				
				
			},
			error : function(xhr, status, error) {
				console.log('Error adding dispenser trigger: ' + error);
			}
		});

		$('#registerBtn').val('Add');
	}

	function deleteDispenserTrigger(dispenserTriggerId1, dispenserTriggerId2) {
		// Perform necessary actions to delete the user
		// For example, make an AJAX call to a delete servlet

		alert(dispenserTriggerId)
		var confirmation = confirm('Are you sure you want to delete this dispenser trigger settings?');
		if (confirmation) {
			$.ajax({
				url : 'dispenserTriggerDeleteServlet',
				type : 'POST',
				data : {
					serial_number : dispenserTriggerId1,
					side : dispenserTriggerId2
				},
				success : function(data) {
					// Display the registration status message
					alert(data.message);

					// Refresh the user list
					loadDispenserTriggerList();
				},
				error : function(xhr, status, error) {
					// Handle the error response, if needed
					console.log('Error deleting dispenser trigger settings: '
							+ error);
				}
			});
		}
	}

	$(document).ready(function() {
		// Load user list
		loadBrokerIPList();
		loadDispenserTriggerList();
		
		$('#dispensortriggerform').submit(function(event) {
			event.preventDefault();
			var buttonText = $('#registerBtn').val();

			if (buttonText == 'Add') {
				addDispenserTrigger();
			} else {
				editDispenserTrigger();
			}
		});
		
		$('#clearBtn').click(function(){
			$('#station_name').val('');
			$('#serial_number').val('');
			$('#side').val('');
			$('#broker_name').val('');
			$('#trigger_tag').val('');
			$('#trigger_value').val('');
			$('#start_pressure').val('');
			$('#end_pressure').val('');
			$('#temperature').val('');
			$('#total').val('');
			$('#quantity').val('');
			$('#unit_price').val('');
			$('#status').val('');
  	 
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
		<h3>DISPENSER TRIGGER</h3>
		<hr />
		<div class="container">
			<form id="dispensortriggerform">
				<div class="row">
					<div class="col-75-1" style="width: 20%; margin-top: -20px">
						<input type="text" id="station_name" name="station_name"
							placeholder="Station Name" required style="height: 17px" />
					</div>
				</div>

				<div class="row">
					<div class="col-75-2"
						style="width: 20%; margin-top: -34px; margin-left: 20%">
						<input type="text" id="serial_number" name="serial_number"
							placeholder="Serial Number" required style="height: 17px" />
					</div>
				</div>

				<div class="row">
					<!-- <div class="col-75-3"
						style="width: 20%; margin-left: 40%; margin-top: -34px">
						<input type="text" id="side" name="side" placeholder="Side"
							required style="height: 17px" />
					</div> -->
					
					<div class="col-75-3"
						style="width: 20%; margin-left: 40%; margin-top: -3%">
						<select class="textBox" id="side" name="side"
							style="height: 35px">
							<option value="Select Side">Select Side</option>
							<option value="a">A</option>
							<option value="b">B</option>
							<option value="c">C</option>
							<option value="d">D</option>
						</select>
					</div>
					
				</div>

				<div class="row">
					<div class="col-75-4"
						style="width: 20%; margin-left: 60%; margin-top: -34px">
						<input type="text" id="trigger_tag" name="trigger_tag"
							placeholder="Trigger Tag" required style="height: 17px" />
					</div>
				</div>

				<div class="row">
					<div class="col-75-5"
						style="width: 20%; margin-left: 80%; margin-top: -34px">
						<input type="text" id="trigger_value" name="trigger_value"
							placeholder="Trigger Value" required style="height: 17px" />
					</div>
				</div>



				<div class="row">
					<div class="col-75-1" style="width: 20%; margin-top: 1%">
						<input type="text" id="start_pressure" name="start_pressure"
							placeholder="Start Pressure" required style="height: 17px" />
					</div>
				</div>

				<div class="row">
					<div class="col-75-2"
						style="width: 20%; margin-top: -3.1%; margin-left: 20%">
						<input type="text" id="end_pressure" name="end_pressure"
							placeholder="End Pressure" required style="height: 17px" />
					</div>
				</div>

				<div class="row">
					<div class="col-75-3"
						style="width: 20%; margin-left: 40%; margin-top: -3.1%">
						<input type="text" id="temperature" name="temperature" placeholder="Temperatur"
							required style="height: 17px" />
					</div>
				</div>

				<div class="row">
					<div class="col-75-4"
						style="width: 20%; margin-left: 60%; margin-top: -3.1%">
						<input type="text" id="total" name="total" placeholder="Total"
							required style="height: 17px" />
					</div>
				</div>

				<div class="row">
					<div class="col-75-5"
						style="width: 20%; margin-left: 80%; margin-top: -3.1%">
						<input type="text" id="quantity" name="quantity"
							placeholder="Quantity" required style="height: 17px" />
					</div>
				</div>

				<div class="row">
					<div class="col-75-5" style="width: 20%; margin-top: 1%">
						<input type="text" id="unit_price" name="unit_price" placeholder="Unit Price"
							required style="height: 17px" />
					</div>
				</div>

				<div class="row">
					<div class="col-75-3"
						style="width: 20%; margin-left: 20%; margin-top: -3%">
						<select class="textBox" id="status" name="status"
							style="height: 35px">
							<option value="Select Status">Select Status</option>
							<option value="enable">Enable</option>
							<option value="disable">Disable</option>
						</select>
					</div>
				</div>

				<div class="row">
					<div class="col-75-4"
						style="width: 20%; margin-left: 40%; margin-top: -35px">
						<select class="textBox" id="broker_name" name="broker_name"
							style="height: 35px;">
							<option value=""></option>
						</select>
					</div>
				</div>

				<div class="row">
					<input style="margin-top: 2%; margin-left: 85%;" type="button"
						value="Clear" id="clearBtn" />
				</div>

				<div class="row">
					<input style="margin-top: -2.2%; margin-left: 95%;" type="submit"
						value="Add" id="registerBtn" />
				</div>

			</form>
		</div>
		
		<h3>DISPENSER TRIGGER LIST</h3>
		<hr />
		
		<div class="container">
			<table id="dispenserTriggerListTable">
				<thead>
					<tr>
						<th>Station Name</th>
						<th>Serial Number</th>
						<th>Side</th>
						<th>Trigger Tag</th>
						<th>Trigger Value</th>
						<th>Start Pressure</th>
					 	<th>End Pressure</th> 
						<th>Temperature</th>
						<th>Total</th> 
						<th>Unit Price</th>
						<th>Quantity</th>
						<th>Broker IP Address</th>
						<th>Status</th>						
						<th>Actions</th>
					</tr>
				</thead>
				<tbody>
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