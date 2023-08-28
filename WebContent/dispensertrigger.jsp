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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css" integrity="sha512-nMNlpuaDPrqlEls3IX/Q56H36qvBASwb3ipuo3MxeWbsQB1881ox0cRv7UPTgBlriqoynt35KjEwgGUeUXIPnw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>

var roleValue;

	function loadBrokerIPList() {
		$.ajax({
			url : "jsonBuilderData",
			type : "GET",
			dataType : "json",
			success : function(data) {
				if (data.broker_ip_result
						&& Array.isArray(data.broker_ip_result)) {

					var selectElement = $("#broker_name");
					// Clear any existing options
					//	selectElement.empty();

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
	
	function loadTagListTriggerTag() {
		$
				.ajax({
					url : "alarmConfigTagListServlet",
					type : "GET",
					dataType : "json",
					success : function(data) {
						if (data.tag_list_result
								&& Array.isArray(data.tag_list_result)) {
							var datalist = $("#trigger_tag");
							// Clear any existing options
							//   datalist.empty();

							// Loop through the data and add options to the datalist
							data.tag_list_result.forEach(function(tag) {
								var option = $("<option>", {
									value : tag,
									text : tag,
								});
								datalist.append(option);
							});
						}
					},
					error : function(xhr, status, error) {
						console.log("Error showing tag list: " + error);
					},
				});
	}

	function loadTagListStartPressure() {
		$
				.ajax({
					url : "alarmConfigTagListServlet",
					type : "GET",
					dataType : "json",
					success : function(data) {
						if (data.tag_list_result
								&& Array.isArray(data.tag_list_result)) {
							var datalist = $("#start_pressure");
							// Clear any existing options
							//   datalist.empty();

							// Loop through the data and add options to the datalist
							data.tag_list_result.forEach(function(tag) {
								var option = $("<option>", {
									value : tag,
									text : tag,
								});
								datalist.append(option);
							});
						}
					},
					error : function(xhr, status, error) {
						console.log("Error showing tag list: " + error);
					},
				});
	}

	function loadTagListEndPressure() {
		$
				.ajax({
					url : "alarmConfigTagListServlet",
					type : "GET",
					dataType : "json",
					success : function(data) {
						if (data.tag_list_result
								&& Array.isArray(data.tag_list_result)) {
							var datalist = $("#end_pressure");
							// Clear any existing options
							//   datalist.empty();

							// Loop through the data and add options to the datalist
							data.tag_list_result.forEach(function(tag) {
								var option = $("<option>", {
									value : tag,
									text : tag,
								});
								datalist.append(option);
							});
						}
					},
					error : function(xhr, status, error) {
						console.log("Error showing tag list: " + error);
					},
				});
	}

	function loadTagListTemperature() {
		$
				.ajax({
					url : "alarmConfigTagListServlet",
					type : "GET",
					dataType : "json",
					success : function(data) {
						if (data.tag_list_result
								&& Array.isArray(data.tag_list_result)) {
							var datalist = $("#temperature");
							// Clear any existing options
							//   datalist.empty();

							// Loop through the data and add options to the datalist
							data.tag_list_result.forEach(function(tag) {
								var option = $("<option>", {
									value : tag,
									text : tag,
								});
								datalist.append(option);
							});
						}
					},
					error : function(xhr, status, error) {
						console.log("Error showing tag list: " + error);
					},
				});
	}

	function loadTagListTotal() {
		$
				.ajax({
					url : "alarmConfigTagListServlet",
					type : "GET",
					dataType : "json",
					success : function(data) {
						if (data.tag_list_result
								&& Array.isArray(data.tag_list_result)) {
							var datalist = $("#total");
							// Clear any existing options
							//   datalist.empty();

							// Loop through the data and add options to the datalist
							data.tag_list_result.forEach(function(tag) {
								var option = $("<option>", {
									value : tag,
									text : tag,
								});
								datalist.append(option);
							});
						}
					},
					error : function(xhr, status, error) {
						console.log("Error showing tag list: " + error);
					},
				});
	}

	function loadTagListQuantity() {
		$
				.ajax({
					url : "alarmConfigTagListServlet",
					type : "GET",
					dataType : "json",
					success : function(data) {
						if (data.tag_list_result
								&& Array.isArray(data.tag_list_result)) {
							var datalist = $("#quantity");
							// Clear any existing options
							//   datalist.empty();

							// Loop through the data and add options to the datalist
							data.tag_list_result.forEach(function(tag) {
								var option = $("<option>", {
									value : tag,
									text : tag,
								});
								datalist.append(option);
							});
						}
					},
					error : function(xhr, status, error) {
						console.log("Error showing tag list: " + error);
					},
				});
	}

	function loadTagListUnitPrice() {
		$
				.ajax({
					url : "alarmConfigTagListServlet",
					type : "GET",
					dataType : "json",
					success : function(data) {
						if (data.tag_list_result
								&& Array.isArray(data.tag_list_result)) {
							var datalist = $("#unit_price");
							// Clear any existing options
							//   datalist.empty();

							// Loop through the data and add options to the datalist
							data.tag_list_result.forEach(function(tag) {
								var option = $("<option>", {
									value : tag,
									text : tag,
								});
								datalist.append(option);
							});
						}
					},
					error : function(xhr, status, error) {
						console.log("Error showing tag list: " + error);
					},
				});
	}

	function loadDispenserTriggerList() {
		$
				.ajax({
					url : 'dispenserTriggerServlet',
					type : 'GET',
					dataType : 'json',
					success : function(data) {
						// Clear existing table rows
						
						var dispenserTriggerTable = $('#dispenserTriggerListTable tbody');
						dispenserTriggerTable.empty();
						
						var json1 = JSON.stringify(data);

						var json = JSON.parse(json1);

						if (json.status == 'fail') {
							var confirmation = confirm(json.msg);
							if (confirmation) {
								window.location.href = 'login.jsp';
							}
						}

						// Iterate through the user data and add rows to the table
					if(roleValue == 'Admin' || roleValue == 'ADMIN'){
						$.each(data,function(index, dispenserTrigger) {
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
							row.append($('<td>').text(dispenserTrigger.unit_id));

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
												setUnitId(dispenserTrigger.unit_id);
											});

							var deleteButton = $(
									'<button style="background-color: red; border: none; border-radius: 5px; margin-left: 5px; color: white; margin-top: 3px;">')
									.text('Delete')
									.click(
											function() {
												deleteDispenserTrigger(
														dispenserTrigger.serial_number,
														dispenserTrigger.side);
											});

							actions.append(editButton);
							actions.append(deleteButton);

							row.append(actions);

							dispenserTriggerTable.append(row);

						});
					}else if(roleValue == 'VIEWER' || roleValue == 'Viewer'){
						$.each(data,function(index, dispenserTrigger) {
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
							row.append($('<td>').text(dispenserTrigger.unit_id));

							dispenserTriggerTable.append(row);

						});
					}
						
					},
					error : function(xhr, status, error) {
						console.log('Error loading dispenser trigger data: '
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
	
	function setUnitId(dispenserTriggerId) {

		$('#unit_id').val(dispenserTriggerId);
	}

	function editDispenserTrigger() {

		var confirmation = confirm('Are you sure you want to edit this dispenser trigger settings?');

		var station_name = $('#station_name').val();
		var serial_number = $('#serial_number').val();
		var side = $('#side').find(":selected").val();
		var broker_name = $('#broker_name').find(":selected").val();
		var trigger_tag = $('#trigger_tag').find(":selected").val();
		var trigger_value = $('#trigger_value').find(":selected").val();
		var start_pressure = $('#start_pressure').find(":selected").val();
		var end_pressure = $('#end_pressure').find(":selected").val();
		var temperature = $('#temperature').find(":selected").val();
		var total = $('#total').find(":selected").val();
		var quantity = $('#quantity').find(":selected").val();
		var unit_price = $('#unit_price').find(":selected").val();
		var status = $('#status').find(":selected").val();
		var unit_id = $('#unit_id').val();

		$.ajax({
			url : 'dispenserTriggerServlet',
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
				status : status,
				unit_id : unit_id,
				action: 'update'
			},
			success : function(data) {
				// Display the registration status message
				alert(data.message);
				loadDispenserTriggerList();

				// Clear form fields

				$('#station_name').val('');
				$('#serial_number').val('');
				$('#side').val('Select side');
				$('#broker_name').val('Select broker IP address');
				$('#trigger_tag').val('Select trigger tag');
				$('#trigger_value').val('Select trigger value');
				$('#start_pressure').val('Select start pressure');
				$('#end_pressure').val('Select end pressure');
				$('#temperature').val('Select temperature');
				$('#total').val('Select total');
				$('#quantity').val('Select quantity');
				$('#unit_price').val('Select unit price');
				$('#status').val('Select status');
				$('#unit_id').val('');

				$("#serial_number").prop("disabled", false);

				$("#side").prop("disabled", false);
			},
			error : function(xhr, status, error) {
				console.log('Error updating dispenser trigger settings: '
						+ error);
			}
		});

		$('#registerBtn').val('Add');
	}

	function addDispenserTrigger() {

		var station_name = $('#station_name').val();
		var serial_number = $('#serial_number').val();
		var side = $('#side').find(":selected").val();
		var broker_name = $('#broker_name').find(":selected").val();
		var trigger_tag = $('#trigger_tag').find(":selected").val();
		var trigger_value = $('#trigger_value').find(":selected").val();
		var start_pressure = $('#start_pressure').find(":selected").val();
		var end_pressure = $('#end_pressure').find(":selected").val();
		var temperature = $('#temperature').find(":selected").val();
		var total = $('#total').find(":selected").val();
		var quantity = $('#quantity').find(":selected").val();
		var unit_price = $('#unit_price').find(":selected").val();
		var status = $('#status').find(":selected").val();
		var unit_id = $('#unit_id').val();

		$.ajax({
			url : 'dispenserTriggerServlet',
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
				status : status,
				unit_id : unit_id,
				action: 'add'
			},
			success : function(data) {
				// Display the registration status message
				alert(data.message);
				loadDispenserTriggerList();

				// Clear form fields

				$('#station_name').val('');
				$('#serial_number').val('');
				$('#side').val('Select side');
				$('#broker_name').val('Select broker IP address');
				$('#trigger_tag').val('Select trigger tag');
				$('#trigger_value').val('Select trigger value');
				$('#start_pressure').val('Select start pressure');
				$('#end_pressure').val('Select end pressure');
				$('#temperature').val('Select temperature');
				$('#total').val('Select total');
				$('#quantity').val('Select quantity');
				$('#unit_price').val('Select unit price');
				$('#status').val('Select status');
				$('#unit_id').val('');

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

		var confirmation = confirm('Are you sure you want to delete this dispenser trigger settings?');
		if (confirmation) {
			$.ajax({
				url : 'dispenserTriggerServlet',
				type : 'POST',
				data : {
					serial_number : dispenserTriggerId1,
					side : dispenserTriggerId2,
					action: 'delete'
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

	function validateSide(side) {
		var sideError = document.getElementById("sideError");

		if (side == 'Select side') {

			sideError.textContent = "Please select side";
			return false;
		} else {
			sideError.textContent = "";
			return true;
		}
	}

	function validateStatus(status) {
		var statusError = document.getElementById("statusError");

		if (status == 'Select status') {

			statusError.textContent = "Please select status";
			return false;
		} else {
			statusError.textContent = "";
			return true;
		}
	}

	function validateTriggerValue(triggerValue) {
		var triggerValueError = document.getElementById("triggerValueError");

		if (triggerValue == 'Select trigger value') {

			triggerValueError.textContent = "Please select trigger value";
			return false;
		} else {
			triggerValueError.textContent = "";
			return true;
		}
	}

	function validateBrokerIPAddress(broker_name) {
		var brokerIPAddressError = document
				.getElementById("brokerIPAddressError");

		if (broker_name == 'Select broker IP address') {

			brokerIPAddressError.textContent = "Please select broker ip address";
			return false;
		} else {
			brokerIPAddressError.textContent = "";
			return true;
		}
	}

	function validateStartPressure(start_pressure) {
		var startPressureError = document.getElementById("startPressureError");

		if (start_pressure == 'Select start pressure') {

			startPressureError.textContent = "Please select start pressure";
			return false;
		} else {
			startPressureError.textContent = "";
			return true;
		}
	}

	function validateEndPressure(end_pressure) {
		var endPressureError = document.getElementById("endPressureError");

		if (end_pressure == 'Select end pressure') {

			endPressureError.textContent = "Please select end pressure";
			return false;
		} else {
			endPressureError.textContent = "";
			return true;
		}
	}

	function validateTemperature(temperature) {
		var temperatureError = document.getElementById("temperatureError");

		if (temperature == 'Select temperature') {

			temperatureError.textContent = "Please select temperature";
			return false;
		} else {
			temperatureError.textContent = "";
			return true;
		}
	}

	function validateTotal(total) {
		var totalError = document.getElementById("totalError");

		if (total == 'Select total') {

			totalError.textContent = "Please select total";
			return false;
		} else {
			totalError.textContent = "";
			return true;
		}
	}

	function validateQuantity(quantity) {
		var quantityError = document.getElementById("quantityError");

		if (quantity == 'Select quantity') {

			quantityError.textContent = "Please select quantity";
			return false;
		} else {
			quantityError.textContent = "";
			return true;
		}
	}
	
	function validateTriggerTag(trigger_tag) {
		var triggerTagError = document.getElementById("triggerTagError");

		if (trigger_tag == 'Select trigger tag') {

			triggerTagError.textContent = "Please select trigger tag";
			return false;
		} else {
			triggerTagError.textContent = "";
			return true;
		}
	}

	function validateUnitPrice(unit_price) {
		var unitPriceError = document.getElementById("unitPriceError");

		if (unit_price == 'Select unit price') {

			unitPriceError.textContent = "Please select unit price";
			return false;
		} else {
			unitPriceError.textContent = "";
			return true;
		}
	}

	function changeButtonColor(isDisabled) {
        var $add_button = $('#registerBtn');       
        var $clear_button = $('#clearBtn');
        
        
         if (isDisabled) {
            $add_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $add_button.css('background-color', '#2b3991'); // Reset to original color
        }
        
        if (isDisabled) {
            $clear_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $clear_button.css('background-color', '#2b3991'); // Reset to original color
        } 
        
    }
	
	$(document).ready(function() {
		
		<%// Access the session variable
		HttpSession role = request.getSession();
		String roleValue = (String) session.getAttribute("role");%>
	
		roleValue = '<%=roleValue%>';
	

						loadBrokerIPList();
						loadDispenserTriggerList();
						
						if (roleValue == 'VIEWER' || roleValue == 'Viewer') {
							$("#actions").hide(); 
							var confirmation = confirm('You do not have enough privileges for role VIEWER');
							$('#registerBtn').prop('disabled', true);
							$('#clearBtn').prop('disabled', true);
							
							changeButtonColor(true);
						}
						
						loadTagListTriggerTag();
						loadTagListStartPressure();
						loadTagListEndPressure();
						loadTagListTemperature();
						loadTagListTotal();
						loadTagListQuantity();
						loadTagListUnitPrice();

						$('#dispensortriggerform').submit(function(event) {
											event.preventDefault();
											var buttonText = $('#registerBtn').val();
											var side = $('#side').find(":selected").val();
											var status = $('#status').find(":selected").val();
											var trigger_value = $('#trigger_value').find(":selected").val();
											var broker_name = $('#broker_name').find(":selected").val();
											var start_pressure = $('#start_pressure').find(":selected").val();
											var end_pressure = $('#end_pressure').find(":selected").val();
											var temperature = $('#temperature').find(":selected").val();
											var total = $('#total').find(":selected").val();
											var quantity = $('#quantity').find(":selected").val();
											var unit_price = $('#unit_price').find(":selected").val();
											var trigger_tag = $('#trigger_tag').find(":selected").val();

											if (!validateSide(side)) {
												sideError.textContent = "Please select side";
												return;
											}

											if (!validateStatus(status)) {
												statusError.textContent = "Please select status";
												return;
											}

											if (!validateTriggerValue(trigger_value)) {
												triggerValueError.textContent = "Please select trigger value";
												return;
											}

											if (!validateBrokerIPAddress(broker_name)) {
												brokerIPAddressError.textContent = "Please select broker ip address ";
												return;
											}

											if (!validateStartPressure(start_pressure)) {
												startPressureError.textContent = "Please select start pressure ";
												return;
											}

											if (!validateEndPressure(end_pressure)) {
												endPressureError.textContent = "Please select end pressure ";
												return;
											}

											if (!validateTemperature(temperature)) {
												temperatureError.textContent = "Please select temperature ";
												return;
											}

											if (!validateTotal(total)) {
												totalError.textContent = "Please select total ";
												return;
											}
											if (!validateQuantity(quantity)) {
												quantityError.textContent = "Please select quantity ";
												return;
											}
											if (!validateUnitPrice(unit_price)) {
												unitPriceError.textContent = "Please select unit price ";
												return;
											}
											
											if (!validateTriggerTag(trigger_tag)) {
												triggerTagError.textContent = "Please select trigger tag ";
												return;
											}

											if (buttonText == 'Add') {
												addDispenserTrigger();
											} else {
												editDispenserTrigger();
											}
										});

						$('#clearBtn').click(function() {
							$('#station_name').val('');
							$('#serial_number').val('');
							$('#side').val('Select side');
							$('#broker_name').val('Select broker IP address');
							$('#trigger_tag').val('');
							$('#trigger_value').val('Select trigger value');
							$('#start_pressure').val('Select start pressure');
							$('#end_pressure').val('Select end pressure');
							$('#temperature').val('Select temperature');
							$('#total').val('Select total');
							$('#quantity').val('Select quantity');
							$('#unit_price').val('Select unit price');
							$('#status').val('Select status');
							$('#unit_id').val('');

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
			<input type="hidden" id="action" name="action" value="">
				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: -20px;">
					<div class="col-75-1" style="width: 20%;">
						<input type="text" id="station_name" name="station_name"
							placeholder="Station Name" required style="height: 17px" />
					</div>
					
					<div class="col-75-2" style="width: 20%;">
						<input type="text" id="serial_number" name="serial_number"
							placeholder="Serial Number" required style="height: 17px" /> <span
							style="color: red; font-size: 12px;" id="serialError"></span>
					</div>

					 <div class="col-75-3" style="width: 20%;">
						<select class="textBox" id="side" name="side" style="height: 35px"
							required>
							<option value="Select side">Select side</option>
							<option value="a">A</option>
							<option value="b">B</option>
							<option value="c">C</option>
							<option value="d">D</option>
						</select> <span id="sideError" style="color: red"></span>
					</div> 
					
					<div class="col-75-4" style="width: 20%;">
							
						<select class="textBox" id=trigger_tag name="trigger_tag"
							style="height: 35px;">
							<option value="Select trigger tag">Select trigger tag</option>
						</select> <span id="triggerTagError" style="color: red"></span>
						
					</div>

					<div class="col-75-5" style="width: 20%;">
						<select class="textBox" id="trigger_value" name="trigger_value"
							style="height: 35px" required>
							<option value="Select trigger value">Select Trigger
								Value</option>
							<option value="0">0</option>
							<option value="1">1</option>

						</select> <span id="triggerValueError" style="color: red"></span>
					</div>
				</div>

				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: 10px;">

					<div class="col-75-1" style="width: 20%;">
						<select class="textBox" id="start_pressure" name="start_pressure"
							style="height: 35px;">
							<option value="Select start pressure">Select start
								pressure</option>
						</select> <span id="startPressureError" style="color: red"></span>
					</div>


					<div class="col-75-2" style="width: 20%;">
						<select class="textBox" id="end_pressure" name="end_pressure"
							style="height: 35px;">
							<option value="Select end pressure">Select end pressure</option>
						</select> <span id="endPressureError" style="color: red"></span>
					</div>


					<div class="col-75-3" style="width: 20%;">
						<select class="textBox" id="temperature" name="temperature"
							style="height: 35px;">
							<option value="Select temperature">Select temperature</option>
						</select> <span id="temperatureError" style="color: red"></span>
					</div>


					<div class="col-75-4" style="width: 20%;">
						<select class="textBox" id="total" name="total"
							style="height: 35px;">
							<option value="Select total">Select total</option>
						</select> <span id="totalError" style="color: red"></span>
					</div>

					<div class="col-75-5" style="width: 20%;">
						<select class="textBox" id="quantity" name="quantity"
							style="height: 35px;">
							<option value="Select quantity">Select quantity</option>
						</select> <span id="quantityError" style="color: red"></span>
					</div>

				</div>

				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: 10px;">

					<div class="col-75-6" style="width: 20%;">
						<select class="textBox" id="unit_price" name="unit_price"
							style="height: 35px;">
							<option value="Select unit price">Select unit price</option>
						</select> <span id="unitPriceError" style="color: red"></span>
					</div>

					<div class="col-75-3" style="width: 20%;">
						<select class="textBox" id="status" name="status"
							style="height: 35px" required>
							<option value="Select status">Select status</option>
							<option value="enable">Enable</option>
							<option value="disable">Disable</option>
						</select> <span id="statusError" style="color: red"></span>
					</div>
					
					<div class="col-75-4" style="width: 20%;">
						<select class="textBox" id="broker_name" name="broker_name"
							style="height: 35px;">
							<option value="Select broker IP address">Select broker
								IP address</option>
						</select> <span id="brokerIPAddressError" style="color: red;"></span>
					</div>
					
					<div class="col-75-14" style="width: 20%;">
						<input type="text" id="unit_id" name="unit_id"
							placeholder="Unit ID" required />
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
						<th>Unit ID</th>
						<th id="actions">Actions</th>
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