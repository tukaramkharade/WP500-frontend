<%
    response.setHeader("X-Frame-Options", "DENY");
    response.setHeader("X-Content-Type-Options", "nosniff");
    HttpSession session1 = request.getSession();
    String secureFlag = "Secure";
    String httpOnlyFlag = "HttpOnly";
    String sameSiteFlag = "SameSite=None"; // Add this line for SameSite attribute
    String cookieValue = session1.getId();
    String headerKey = "Set-Cookie";
    String headerValue = String.format("%s=%s; %s; %s; %s", session1.getId(), cookieValue, secureFlag, httpOnlyFlag, sameSiteFlag);
    response.setHeader(headerKey, headerValue);
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png" />
<link rel="stylesheet" href="css_files/ionicons.min.css">
<link rel="stylesheet" href="css_files/normalize.min.css">
<link rel="stylesheet" href="css_files/fonts.txt" type="text/css">	
<link rel="stylesheet" href="nav-bar.css" />
<link rel="stylesheet" href="css_files/all.min.css">
<link rel="stylesheet" href="css_files/fontawesome.min.css">
<script src="jquery-3.6.0.min.js"></script>
<style>

.modal-delete,
.modal-edit,
.modal-session-timeout {
  display: none;
  position: fixed;
  z-index: 1;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  margin: 0;
}

.modal-content-delete,
.modal-content-edit,
.modal-content-session-timeout {
  background-color: #d5d3d3;
  padding: 20px;
  border-radius: 5px;
  text-align: center;
  position: relative;
  width: 300px;
  transform: translate(0, -50%); /* Center vertically */
  top: 50%; /* Center vertically */
  left: 50%; /* Center horizontally */
  transform: translate(-50%, -50%); /* Center horizontally and vertically */
}

button {
  margin: 5px;
  padding: 10px 20px;
  border: none;
  cursor: pointer;
}

#confirm-button-delete,
#confirm-button-edit,
#confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
}

#cancel-button-delete,
#cancel-button-edit {
  background-color: #f44336;
  color: white;
}

  .popup {
  display: none;
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background-color: #d5d3d3;
  border: 1px solid #ccc;
  padding: 20px;
  box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5);
  z-index: 1000;
  text-align: center; /* Center-align the content */
  width: 20%;
}

#closePopup {
  display: block; /* Display as to center horizontally */
  margin-top: 30px; /* Adjust the top margin as needed */
  background-color: #4caf50;
  color: #fff;
  border: none;
  padding: 10px 20px;
  cursor: pointer;
  margin-left: 40%;
}

h3{
margin-top: 68px;
}

.container {
    margin: 0 auto;
   max-width: 750px;
  }

 .bordered-table {
  border-collapse: collapse; /* Optional: To collapse table borders */
  margin: 0 auto; /* Center the table horizontally */
}

.bordered-table td {
  border: 1px solid #ccc; /* Light gray border */
}

#loader-overlay {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(255, 255, 255, 0.7); /* Transparent white background */
    z-index: 1000; /* Ensure the loader is on top of other elements */
    justify-content: center;
    align-items: center;
}

#loader {
    text-align: center;
   margin-left: 120px;
    background: rgba(255, 255, 255, 0.2); /* Transparent white background */
    border-radius: 5px;
}

.footer{
margin-top: 20px;
}

</style>

<script>
var roleValue;
var tokenValue;
var csrfTokenValue;

	function loadBrokerIPList() {
		$.ajax({
			url : "jsonBuilderData",
			type : "GET",
			dataType : "json",
			success : function(data) {
				if (data.broker_ip_result && Array.isArray(data.broker_ip_result)) {
					var selectElement = $("#broker_name");				
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
			},
		});
	}
	
	function loadTagListTriggerTag() {
		 var csrfToken = document.getElementById('csrfToken').value;	 
		$.ajax({
					url : "alarmConfigTagListServlet",
					type : "GET",
					dataType : "json",
					 data: {
							csrfToken: csrfToken
				        },
					success : function(data) {
						if (data.tag_list_result
								&& Array.isArray(data.tag_list_result)) {
							var datalist = $("#trigger_tag");						
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
					},
				});
	}

	function loadTagListStartPressure() {
		 var csrfToken = document.getElementById('csrfToken').value;	 
		$.ajax({
					url : "alarmConfigTagListServlet",
					type : "GET",
					dataType : "json",
					 data: {
							csrfToken: csrfToken
				        },
					success : function(data) {
						if (data.tag_list_result
								&& Array.isArray(data.tag_list_result)) {
							var datalist = $("#start_pressure");							
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
						
					},
				});
	}

	function loadTagListEndPressure() {
		 var csrfToken = document.getElementById('csrfToken').value;	 
		$.ajax({
					url : "alarmConfigTagListServlet",
					type : "GET",
					dataType : "json",
					 data: {
							csrfToken: csrfToken
				        },
					success : function(data) {
						if (data.tag_list_result
								&& Array.isArray(data.tag_list_result)) {
							var datalist = $("#end_pressure");
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
					},
				});
	}

	function loadTagListTemperature() {
		 var csrfToken = document.getElementById('csrfToken').value;	 
		$.ajax({
					url : "alarmConfigTagListServlet",
					type : "GET",
					dataType : "json",
					 data: {
							csrfToken: csrfToken
				        },
					success : function(data) {
						if (data.tag_list_result && Array.isArray(data.tag_list_result)) {
							var datalist = $("#temperature");
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
					},
				});
	}

	function loadTagListTotal() {
		 var csrfToken = document.getElementById('csrfToken').value;	 
		$.ajax({
					url : "alarmConfigTagListServlet",
					type : "GET",
					dataType : "json",
					 data: {
							csrfToken: csrfToken
				        },
					success : function(data) {
						if (data.tag_list_result
								&& Array.isArray(data.tag_list_result)) {
							var datalist = $("#total");
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
						
					},
				});
	}

	function loadTagListQuantity() {
		 var csrfToken = document.getElementById('csrfToken').value;	 
		$.ajax({
					url : "alarmConfigTagListServlet",
					type : "GET",
					dataType : "json",
					 data: {
							csrfToken: csrfToken
				        },
					success : function(data) {
						if (data.tag_list_result && Array.isArray(data.tag_list_result)) {
							var datalist = $("#quantity");
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
					},
				});
	}

	function loadTagListUnitPrice() {
		 var csrfToken = document.getElementById('csrfToken').value;		 
		$.ajax({
					url : "alarmConfigTagListServlet",
					type : "GET",
					dataType : "json",
					 data: {
							csrfToken: csrfToken
				        },
					success : function(data) {
						if (data.tag_list_result && Array.isArray(data.tag_list_result)) {
							var datalist = $("#unit_price");
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
					},
				});
	}

	function loadDispenserTriggerList() {
	    showLoader();
	    var csrfToken = document.getElementById('csrfToken').value;  
		$.ajax({
					url : 'eventTriggerdataServlet',
					type : 'GET',
					dataType : 'json',
					data: {
						csrfToken: csrfToken
			        },
					beforeSend: function(xhr) {
				        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
				    },
					success : function(data) {
						hideLoader();						
						if (data.status == 'fail') {							
							 var modal = document.getElementById('custom-modal-session-timeout');
							 modal.style.display = 'block';							  
							 var sessionMsg = document.getElementById('session-msg');
							 sessionMsg.textContent = data.message; // Assuming data.message contains the server message							  
							 var confirmButton = document.getElementById('confirm-button-session-timeout');
							 confirmButton.onclick = function () {								  
							        modal.style.display = 'none';
							        window.location.href = 'login.jsp';
							 };							  
						} 
						var dispenserTriggerTable = $('#dispenserTriggerListTable tbody');
						dispenserTriggerTable.empty();
						if(roleValue == 'Admin' || roleValue == 'ADMIN'){
 						data.result.forEach(function(dispenserTrigger) {						
							var station_name = dispenserTrigger.station_name; 
							var serial_number = dispenserTrigger.serial_number; 
							var unit_id = dispenserTrigger.unit_id;
							var side = dispenserTrigger.side; 
							var trigger_tag = dispenserTrigger.trigger_tag; 
							var trigger_value = dispenserTrigger.trigger_value; 
							var broker_ip_address = dispenserTrigger.broker_ip_address; 
							var status = dispenserTrigger.status; 						
							var row = $("<tr>").append($("<td>").text(station_name),
									$("<td>").text(serial_number),
									$("<td>").text(unit_id),
									$("<td>").text(side),
									$("<td>").text(trigger_tag),
									$("<td>").text(trigger_value),
									$("<td>").text(broker_ip_address),
									$("<td>").text(status));							
							var actions = $('<td>');
							var editButton = $(
									'<button data-toggle="tooltip" class="editBtn" data-placement="top" title="Edit"style="color: #35449a;">')
									.html('<i class="fas fa-edit"></i>')
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
									'<button data-toggle="tooltip" class="delBtn" data-placement="top" title="Delete"style="color: red;">')
									.html('<i class="fas fa-trash-alt"></i>')
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
					}else if(roleValue == 'OPERATOR' || roleValue == 'Operator'){					
						var station_name = dispenserTrigger.station_name; 
						var serial_number = dispenserTrigger.serial_number; 
						var side = dispenserTrigger.side; 
						var trigger_tag = dispenserTrigger.trigger_tag; 
						var trigger_value = dispenserTrigger.trigger_value; 
						var broker_ip_address = dispenserTrigger.broker_ip_address; 
						var status = dispenserTrigger.status; 
						var unit_id = dispenserTrigger.unit_id;						
						var row = $("<tr>").append($("<td>").text(station_name),
								$("<td>").text(serial_number),
								$("<td>").text(side),
								$("<td>").text(trigger_tag),
								$("<td>").text(trigger_value),
								$("<td>").text(broker_ip_address),
								$("<td>").text(status),
								$("<td>").text(unit_id));					
						dispenserTriggerTable.append(row);
					}									},
					error : function(xhr, status, error) {
			            hideLoader();					
					}
				});
	}

	function setSerialNumber(dispenserTriggerId) {	
		$('#serial_number').val(dispenserTriggerId);
		$("#serial_number").prop("disabled", true);
		$('#registerBtn').val('Update');
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
			var csrfToken = document.getElementById('csrfToken').value;
		    $('#field_name_Error').text('');
		    $('#field_serial_num_Error').text('');
		    $('#field_unitid_Error').text('');
		    var stationnameError = validateStationName(station_name);
		    if (stationnameError) {
		        $('#field_name_Error').text(stationnameError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
		        return;
		    }
		    var serialNumError = validateSerialNumber(serial_number);
		    if (serialNumError) {
		        $('#field_serial_num_Error').text(serialNumError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
		        return;
		    }
		    var unitidError = validateUnitId(unit_id);
		    if (unitidError) {
		        $('#field_unitid_Error').text(unitidError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
		        return;
		    }	    
	  var modal = document.getElementById('custom-modal-edit');
	  modal.style.display = 'block';  
	  var confirmButton = document.getElementById('confirm-button-edit');
	  confirmButton.onclick = function () {
			$.ajax({
				url : 'eventTriggerdataServlet',
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
					csrfToken: csrfToken,
					action: 'update'
				},
				success : function(data) {				
					if (data.status == 'fail') {					
						 var modal1 = document.getElementById('custom-modal-session-timeout');
						 modal1.style.display = 'block';					  
						 var sessionMsg = document.getElementById('session-msg');
						 sessionMsg.textContent = data.message; // Assuming data.message contains the server message					  
						 var confirmButton1 = document.getElementById('confirm-button-session-timeout');
						 confirmButton1.onclick = function () {						  
						        modal1.style.display = 'none';
						        window.location.href = 'login.jsp';
						  };						  
					} 			
			        modal.style.display = 'none';				
					loadDispenserTriggerList();				
				$('#station_name').val('');
				$('#serial_number').val('');
				$('#side').val('A');
				$('#broker_name').val('Select broker IP address');
				$('#trigger_tag').val('Select trigger tag');
				$('#trigger_value').val('0');
				$('#start_pressure').val('Select start pressure');
				$('#end_pressure').val('Select end pressure');
				$('#temperature').val('Select temperature');
				$('#total').val('Select total');
				$('#quantity').val('Select quantity');
				$('#unit_price').val('Select unit price');
				$('#status').val('Enable');
				$('#unit_id').val('');
					$("#serial_number").prop("disabled", false);
					$("#side").prop("disabled", false);
				},
				error : function(xhr, status, error) {				
				}
			});
			$('#registerBtn').val('Add');		
	  };
	  var cancelButton = document.getElementById('cancel-button-edit');
	  cancelButton.onclick = function () {
	    modal.style.display = 'none';
	    $('#registerBtn').val('Update');
	  };	
 	}
 		
 	function validateStationName(stationName) {
 	    var regex = /^[a-zA-Z][a-zA-Z0-9]*$/;
 	    if (!regex.test(stationName)) {
 	        return 'Invalid station name; symbols not allowed';
 	    }
     	return null; // Validation passed
 	}

 	function validateSerialNumber(serialNum) {
 	    var regex = /^[a-zA-Z][a-zA-Z0-9]*$/;
 	    if (!regex.test(serialNum)) {
 	        return 'Invalid serial number; symbols not allowed';
 	    }
 	    return null; // Validation passed
 	}
 	
 	function validateUnitId(unitId) {
 	    var regex = /^[a-zA-Z][a-zA-Z0-9]*$/;
 	    if (!regex.test(unitId)) {
 	        return 'Invalid unit id; symbols not allowed';
 	    }
 	    return null; // Validation passed
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
		var csrfToken = document.getElementById('csrfToken').value;	
	    $('#field_name_Error').text('');
	    $('#field_serial_num_Error').text('');
	    $('#field_unitid_Error').text('');
	    var stationnameError = validateStationName(station_name);
	    if (stationnameError) {
	        $('#field_name_Error').text(stationnameError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }
	    var serialNumError = validateSerialNumber(serial_number);
	    if (serialNumError) {
	        $('#field_serial_num_Error').text(serialNumError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }
	    var unitidError = validateUnitId(unit_id);
	    if (unitidError) {
	        $('#field_unitid_Error').text(unitidError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }   
		$.ajax({
			url : 'eventTriggerdataServlet',
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
				csrfToken: csrfToken,
				action: 'add'
			},
			success : function(data) {
				if (data.status == 'fail') {				
					 var modal1 = document.getElementById('custom-modal-session-timeout');
					 modal1.style.display = 'block';				  
					 var sessionMsg = document.getElementById('session-msg');
					 sessionMsg.textContent = data.message; // Assuming data.message contains the server message				  
					 var confirmButton1 = document.getElementById('confirm-button-session-timeout');
					 confirmButton1.onclick = function () {					  
					        modal1.style.display = 'none';
					        window.location.href = 'login.jsp';
					  };					  
				} 			
     			$("#popupMessage").text(data.message);
      			$("#customPopup").show();
				loadDispenserTriggerList();

				$('#station_name').val('');
				$('#serial_number').val('');
				$('#side').val('A');
				$('#broker_name').val('Select broker IP address');
				$('#trigger_tag').val('Select trigger tag');
				$('#trigger_value').val('0');
				$('#start_pressure').val('Select start pressure');
				$('#end_pressure').val('Select end pressure');
				$('#temperature').val('Select temperature');
				$('#total').val('Select total');
				$('#quantity').val('Select quantity');
				$('#unit_price').val('Select unit price');
				$('#status').val('Enable');
				$('#unit_id').val('');
			},
			error : function(xhr, status, error) {			
			}
		});
		$("#closePopup").click(function () {
		    $("#customPopup").hide();
		  });	
		$('#registerBtn').val('Add');
	}
	
	function deleteDispenserTrigger(dispenserTriggerId1, dispenserTriggerId2) {
		var csrfToken = document.getElementById('csrfToken').value;	
		  var modal = document.getElementById('custom-modal-delete');
		  modal.style.display = 'block';
		  var confirmButton = document.getElementById('confirm-button-delete');
		  confirmButton.onclick = function () {
			  $.ajax({
					url : 'eventTriggerdataServlet',
					type : 'POST',
					data : {
						serial_number : dispenserTriggerId1,
						side : dispenserTriggerId2,
						csrfToken: csrfToken,
						action: 'delete'
					},
					success : function(data) {
						if (data.status == 'fail') {					
							 var modal1 = document.getElementById('custom-modal-session-timeout');
							 modal1.style.display = 'block';						  
							 var sessionMsg = document.getElementById('session-msg');
							 sessionMsg.textContent = data.message; // Assuming data.message contains the server message						  
							 var confirmButton1 = document.getElementById('confirm-button-session-timeout');
							 confirmButton1.onclick = function () {							  
							        modal1.style.display = 'none';
							        window.location.href = 'login.jsp';
							  };							  
						} 					
				        modal.style.display = 'none';
						loadDispenserTriggerList();
						location.reload();
					},
					error : function(xhr, status, error) {						
					}
				});
		  };		  
		  var cancelButton = document.getElementById('cancel-button-delete');
		  cancelButton.onclick = function () {
		    modal.style.display = 'none';
		  };		  
	}

	function validateBrokerIPAddress(broker_name) {
		var brokerIPAddressError = document.getElementById("brokerIPAddressError");
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
	
	 function showLoader() {
	     $('#loader-overlay').show();
	 }

	 function hideLoader() {
	     $('#loader-overlay').hide();
	 }
	 
	$(document).ready(function() {		
		<%// Access the session variable
		HttpSession role = request.getSession();
		String roleValue = (String) session.getAttribute("role");%>
		roleValue = '<%=roleValue%>';
		
		<%// Access the session variable
		HttpSession csrfToken = request.getSession();
		String csrfTokenValue = (String) session.getAttribute("csrfToken");%>
		csrfTokenValue = '<%=csrfTokenValue%>';
		
						if (roleValue == 'OPERATOR' || roleValue == 'Operator') {
							$("#actions").hide(); 							
							$('#registerBtn').prop('disabled', true);
							$('#clearBtn').prop('disabled', true);						
							changeButtonColor(true);
						}
						
						if (roleValue === "null") {
					        var modal = document.getElementById('custom-modal-session-timeout');
					        modal.style.display = 'block';
						    var sessionMsg = document.getElementById('session-msg');
						    sessionMsg.textContent = 'You are not allowed to redirect like this !!'; 						    
					        var confirmButton = document.getElementById('confirm-button-session-timeout');
					        confirmButton.onclick = function() {
					            modal.style.display = 'none';
					            window.location.href = 'login.jsp';
					        };
					    }else{
					    	<%// Access the session variable
							HttpSession token = request.getSession();
							String tokenValue = (String) session.getAttribute("token");%>
							tokenValue = '<%=tokenValue%>';						

							loadBrokerIPList();
							loadDispenserTriggerList();						
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
												var trigger_tag = $('#trigger_tag').find(":selected").val();
												var trigger_value = $('#trigger_value').find(":selected").val();
												var start_pressure = $('#start_pressure').find(":selected").val();
												var end_pressure = $('#end_pressure').find(":selected").val();
												var temperature = $('#temperature').find(":selected").val();
												var total = $('#total').find(":selected").val();
												var quantity = $('#quantity').find(":selected").val();
												var unit_price = $('#unit_price').find(":selected").val();
												var status = $('#status').find(":selected").val();										
												var broker_name = $('#broker_name').find(":selected").val();							
												var station_name = $('#station_name').val();
												var serial_number = $('#serial_number').val();
												var unit_id = $('#unit_id').val();	
												
												if (!validateTriggerTag(trigger_tag)) {
													triggerTagError.textContent = "Please select trigger tag ";
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
												if (!validateBrokerIPAddress(broker_name)) {
													brokerIPAddressError.textContent = "Please select broker ip address ";
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
								$('#side').val('A');
								$('#broker_name').val('Select broker IP address');
								$('#trigger_tag').val('Select trigger tag');
								$('#trigger_value').val('0');
								$('#start_pressure').val('Select start pressure');
								$('#end_pressure').val('Select end pressure');
								$('#temperature').val('Select temperature');
								$('#total').val('Select total');
								$('#quantity').val('Select quantity');
								$('#unit_price').val('Select unit price');
								$('#status').val('Enable');
								$('#unit_id').val('');
								$('#registerBtn').val('Add');
								$('#field_name_Error').text('');
								$('#field_serial_num_Error').text('');
								$('#field_unitid_Error').text('');
							});
					    }					
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
		<h3>ADD DISPENSER TRIGGER</h3>
		<hr />
		<div class="container">
			<form id="dispensortriggerform">
			<input type="hidden" id="action" name="action" value="">
			<input type="hidden" name="csrfToken" id="csrfToken" value="<%= csrfTokenValue %>" />			
			<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>		
			<table class="bordered-table" style="margin-top: -1px;">			
			<tr>
			<td>Station name</td>
			<td style="height: 50px; width: 230px;">
			<input type="text" id="station_name" name="station_name" required style="height: 10px;" maxlength="31"/>
							<span id="field_name_Error" class="error-message" style="display: block; margin-top: 5px;"></span>
			</td>
			<td>Serial number</td>
			<td><input type="text" id="serial_number" name="serial_number" required style="height: 10px" maxlength="31"/> 
							<span id="field_serial_num_Error" class="error-message" style="display: block; margin-top: 5px;"></span>
			</td>			
			<td>Unit ID</td>
			<td><input type="text" id="unit_id" name="unit_id" required maxlength="31" style="height: 10px;"/>
							<span id="field_unitid_Error" class="error-message" style="display: block; margin-top: 5px;"></span>
			</td>
			</tr>
			<tr>
		
			<td>Side</td>
			<td><select class="textBox" id="side" name="side" style="height: 33px"
							required>
							<option value="A" selected>A</option>
							<option value="B">B</option>
							<option value="C">C</option>
							<option value="D">D</option>
						</select> <span id="sideError" style="color: red"></span></td>	
			<td>Trigger tag</td>
			<td><select class="textBox" id=trigger_tag name="trigger_tag" style="height: 33px;">
							<option value="Select trigger tag">Select trigger tag</option>
						</select> <span id="triggerTagError" style="color: red"></span></td>											
			<td>Trigger value</td>
			<td><select class="textBox" id="trigger_value" name="trigger_value" style="height: 33px" required>						
							<option value="0" selected>0</option>
							<option value="1">1</option>
						</select> <span id="triggerValueError" style="color: red"></span></td>						
						</tr>
						<tr>			
			<td>Start pressure</td>
			<td><select class="textBox" id="start_pressure" name="start_pressure" style="height: 33px;">
							<option value="Select start pressure">Select start pressure</option>
						</select> <span id="startPressureError" style="color: red"></span></td>
			<td>End pressure</td>
			<td><select class="textBox" id="end_pressure" name="end_pressure" style="height: 33px;">
							<option value="Select end pressure">Select end pressure</option>
						</select> <span id="endPressureError" style="color: red"></span></td>						
			<td>temperature</td>
			<td><select class="textBox" id="temperature" name="temperature" style="height: 33px;">
							<option value="Select temperature">Select temperature</option>
						</select> <span id="temperatureError" style="color: red"></span></td>					
						</tr>						
						<tr>
			<td>total</td>
			<td><select class="textBox" id="total" name="total" style="height: 33px;">
							<option value="Select total">Select total</option>
						</select> <span id="totalError" style="color: red"></span></td>									
			<td>Quantity</td>
			<td><select class="textBox" id="quantity" name="quantity" style="height: 33px;">
							<option value="Select quantity">Select quantity</option>
						</select> <span id="quantityError" style="color: red"></span></td>
			<td>Unit price</td>
			<td><select class="textBox" id="unit_price" name="unit_price" style="height: 33px;">
							<option value="Select unit price">Select unit price</option>
						</select> <span id="unitPriceError" style="color: red"></span></td>			
			</tr>
			<tr>
			<td>Status</td>
			<td><select class="textBox" id="status" name="status" style="height: 33px" required>
							<option value="Enable" selected>Enable</option>
							<option value="Disable">Disable</option>
						</select> <span id="statusError" style="color: red"></span></td>
			<td>Broker IP address</td>
			<td><select class="textBox" id="broker_name" name="broker_name" style="height: 33px;">
							<option value="Select broker IP address">Select broker IP address</option>
						</select> <span id="brokerIPAddressError" style="color: red;"></span></td>					
						<td></td>
						<td></td>					
			</tr>			
			</table>			
			<div class="row" style="display: flex; justify-content: center; margin-top: 1%;">
					<input type="button" value="Clear" id="clearBtn" /> 
					<input style="margin-left: 5px;" type="submit" value="Add" id="registerBtn" />
			</div>
			</form>
		</div>	
		<div id="custom-modal-delete" class="modal-delete">
				<div class="modal-content-delete">
				  <p>Are you sure you want to delete this dispenser trigger?</p>
				  <button id="confirm-button-delete">Yes</button>
				  <button id="cancel-button-delete">No</button>
				</div>
			  </div>			  
			  <div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to modify this dispenser trigger?</p>
				  <button id="confirm-button-edit">Yes</button>
				  <button id="cancel-button-edit">No</button>
				</div>
			  </div>		  
			  <div id="custom-modal-session-timeout" class="modal-session-timeout">
				<div class="modal-content-session-timeout">
				  <p id="session-msg"></p>
				  <button id="confirm-button-session-timeout">OK</button>
				</div>
			  </div>			  
			   <div id="customPopup" class="popup">
  				<span class="popup-content" id="popupMessage"></span>
  				<button id="closePopup">OK</button>
			  </div>
		<h3 style="margin-top: 15px;">DISPENSER TRIGGER LIST</h3>
		<hr />
		<div class="class="table-container"">
			<table id="dispenserTriggerListTable">
				<thead>
					<tr>
						<th>Station name</th>
						<th>Serial number</th>
						<th>Unit ID</th>
						<th>Side</th>
						<th>Trigger tag</th>
						<th>Trigger value</th>
						<th>Broker IP address</th>
						<th>Status</th>
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