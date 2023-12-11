<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32"
	href="images/WP_Connex_logo_favicon.png" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
.tab {
	display: none;
}

.tab.active {
	display: block;
}

.tab-basic {
	display: none;
}

.tab-basic.active {
	display: block;
}

.tab-button-lan {
	background-color: #f2f2f2;
	padding: 10px 20px;
	border: none;
	cursor: pointer;
	margin-left: 10px;
}

.tab-button-lan.active {
	background-color: #2b3991;
	color: white;
}

.tab-button {
	background-color: #f2f2f2;
	padding: 10px 20px;
	border: none;
	cursor: pointer;
	margin-left: 10px;
}

.tab-button.active {
	background-color: #2b3991;
	color: white;
}

.form-container {
	margin: 0 auto;
	width: 80%;
	border-collapse: collapse;
	background-color: #f2f2f2;
	border-radius: 5px;
	padding: 20px;
}

.form-container td {
	border: 1px solid #ccc; /* Light gray border */
}

.modal-edit-basic-conf, 
.modal-session-timeout, 
.modal-delete_lan0,
.modal-edit_lan0,
.modal-delete_lan1,
.modal-edit_lan1,
.modal-delete_lan2,
.modal-edit_lan2 {
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

.modal-content-edit-basic-conf, 
.modal-content-session-timeout,
.modal-content-delete_lan0, 
.modal-content-edit_lan0,
.modal-content-delete_lan1, 
.modal-content-edit_lan1,
.modal-content-delete_lan2, 
.modal-content-edit_lan2  {
	background-color: #d5d3d3;
	padding: 20px;
	border-radius: 5px;
	text-align: center;
	position: relative;
	width: 300px;
	transform: translate(0, -50%); /* Center vertically */
	top: 50%; /* Center vertically */
	left: 50%; /* Center horizontally */
	transform: translate(-50%, -50%);
	/* Center horizontally and vertically */
}

button {
	margin: 5px;
	padding: 10px 20px;
	border: none;
	cursor: pointer;
}

#confirm-button-edit-basic-conf,
#confirm-button-session-timeout,
#confirm-button-delete_lan0,
#confirm-button-edit_lan0,
#confirm-button-delete_lan1,
#confirm-button-edit_lan1,
#confirm-button-delete_lan2,
#confirm-button-edit_lan2 {
	background-color: #4caf50;
	color: white;
}

#cancel-button-edit-basic-conf, 
#cancel-button-delete_lan0,
#cancel-button-edit_lan0,
#cancel-button-delete_lan1,
#cancel-button-edit_lan1,
#cancel-button-delete_lan2,
#cancel-button-edit_lan2 {
	background-color: #f44336;
	color: white;
}
</style>

<script>

var roleValue; 
var tokenValue;
var globalId;
var globalAction;
var globalData = [];

function getBasicConfiguration(){
	
	$.ajax({
		url : "BasicConfigurationServlet",
		type : "GET",
		dataType : "json",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
	    },
	    success : function(data) {
	    	
	    	if (data.status == "fail") {
				
				 var modal = document.getElementById('custom-modal-session-timeout');
				  modal.style.display = 'block';
				  
				// Update the session-msg content with the message from the server
				    var sessionMsg = document.getElementById('session-msg');
				    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

				  
				  // Handle the confirm button click
				  var confirmButton = document.getElementById('confirm-button-session-timeout');
				  confirmButton.onclick = function () {
					  
					// Close the modal
				        modal.style.display = 'none';
				        window.location.href = 'login.jsp';
				  };
					  
			} 
			
				var basicConfigTable = $("#basic-config-table tbody");
				basicConfigTable.empty();
			
				
 								data.result_basic.forEach(function(basicConfig) {
	 
 									 var row = $("<tr>");
 									row.attr("data-basic-config-id", basicConfig.basicConfigId);
 									row.append($("<td>").text(basicConfig.id));
									row.append($("<td>").append($("<input>").attr("type", "text").val(basicConfig.direction).prop("disabled", true)));
									row.append($("<td>").append($("<input>").attr("type", "text").val(basicConfig.lan_type).prop("disabled", true)));
									row.append($("<td>").append($("<input>").attr("type", "text").val(basicConfig.protocol).prop("disabled", true)));
									row.append($("<td>").append($("<input>").attr("type", "text").val(basicConfig.to_port).prop("disabled", true)));
									row.append($("<td>").append($("<input>").attr("type", "text").val(basicConfig.comment).prop("disabled", true)));
									
									// Assuming you have a table row (row) and a variable basicConfig with a property: action
									var actionOptions = ["ACCEPT", "REJECT"];
									var select = $("<select>");

									// Loop through the options and create <option> elements
									for (var i = 0; i < actionOptions.length; i++) {
									    var option = $("<option>").text(actionOptions[i]);
									    select.append(option);
									}

									// Set the selected option based on the value of basicConfig.action
									select.val(basicConfig.action);

									// Create the <td> element and append the <select> element
									var td = $("<td>").append(select);
									
									 select.on("change", function() {
									    globalAction = $(this).val();
									    globalId = basicConfig.id; // Get the associated id from basicConfig
									  //  alert("Selected value: " + globalAction + " for id: " + globalId);
									}); 
									row.append(td);

									basicConfigTable.append(row); 
									
 								});
		    
					    },
		error : function(xhr, status, error) {
			console.log("Error loading basic configuration data: "+ error);
		},
	 		});
	
}

var globalData = [];

// This function sends the accumulated data when you call it
function sendAccumulatedData() {
    if (globalData && globalData.length > 0) {
        sendToServer(globalData);
        // Clear the globalData array after sending the data if needed
        globalData = [];
    }
}

function sendToServer(dataArray) {
	
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-edit-basic-conf');
	  modal.style.display = 'block';
	  
	// Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-edit-basic-conf');
	  confirmButton.onclick = function () {
		  
	  
    var requestData = {
        data: dataArray
    };

    $.ajax({
        url: "BasicConfigurationServlet", // Replace with your servlet URL
        type: "POST",
        data: JSON.stringify(requestData),
        contentType: "application/json",
        beforeSend: function(xhr) {
            xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
        },
        success: function(response) {
        	
        	if (response.status == 'fail') {
				
				 var modal1 = document.getElementById('custom-modal-session-timeout');
				  modal1.style.display = 'block';
				  
				// Update the session-msg content with the message from the server
				    var sessionMsg = document.getElementById('session-msg');
				    sessionMsg.textContent = response.message; // Assuming data.message contains the server message

				  
				  // Handle the confirm button click
				  var confirmButton1 = document.getElementById('confirm-button-session-timeout');
				  confirmButton1.onclick = function () {
					  
					// Close the modal
				        modal1.style.display = 'none';
				        window.location.href = 'login.jsp';
				  };
					  
			} 
        	
        	// Close the modal
		    modal.style.display = 'none';
           
            getBasicConfiguration();
        },
        error: function(xhr, status, error) {
            console.log("Error sending global data: " + error);
        }
    });
    
	  };
	  
	  var cancelButton = document.getElementById('cancel-button-edit-basic-conf');
	  cancelButton.onclick = function () {
	      // Close the modal
	      modal.style.display = 'none';

	      // Get the previously selected value for a specific basicConfigId
	      var previousValue = getValueFromTable(globalId);

	      // Set the value back in the table for the same basicConfigId
	      setValueInTable(globalId, previousValue);
	      
	   // Reload the page
	      window.location.reload();
	  }

}

function addSelectedAction(id, action) {
    var data = {
        id: globalId,
        action: globalAction
    };
    globalData.push(data);
}

function getValueFromTable(basicConfigId) {
    // Assuming each row has a data-basic-config-id attribute
    var cell = $("td[data-basic-config-id='" + basicConfigId + "']");
    return cell.text();
}


function setValueInTable(basicConfigId, value) {
    // Assuming each row has a data-basic-config-id attribute
    var cell = $("td[data-basic-config-id='" + basicConfigId + "']");
    cell.text(value);
}


function getGeneralSettingsLan0(){
	
	$.ajax({
		url : "generalSettingsServletLan0",
		type : "GET",
		dataType : "json",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
	    },
		success : function(data) {
			
			if (data.status == 'fail') {
				
				 var modal = document.getElementById('custom-modal-session-timeout');
				  modal.style.display = 'block';
				  
				// Update the session-msg content with the message from the server
				    var sessionMsg = document.getElementById('session-msg');
				    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

				  
				  // Handle the confirm button click
				  var confirmButton = document.getElementById('confirm-button-session-timeout');
				  confirmButton.onclick = function () {
					  
					// Close the modal
				        modal.style.display = 'none';
				        window.location.href = 'login.jsp';
				  };
					  
			} 

			alert(data.input);
			$('#input_lan0').val(data.input);
			$('#output_lan0').val(data.output);
			$('#forward_lan0').val(data.forword);
			$('#rule_drop_lan0').val(data.rule_drop);

		},
		error : function(xhr, status, error) {
			// Handle the error response, if needed
			console.log("Error loading general Settings: " + error);
		},
	});

}

function getGeneralSettingsLan1(){
	
	$.ajax({
		url : "generalSettingsServletLan1",
		type : "GET",
		dataType : "json",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
	    },
		success : function(data) {
			
			if (data.status == 'fail') {
				
				 var modal = document.getElementById('custom-modal-session-timeout');
				  modal.style.display = 'block';
				  
				// Update the session-msg content with the message from the server
				    var sessionMsg = document.getElementById('session-msg');
				    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

				  
				  // Handle the confirm button click
				  var confirmButton = document.getElementById('confirm-button-session-timeout');
				  confirmButton.onclick = function () {
					  
					// Close the modal
				        modal.style.display = 'none';
				        window.location.href = 'login.jsp';
				  };
					  
			} 

			$('#input_lan1').val(data.input);
			$('#output_lan1').val(data.output);
			$('#forward_lan1').val(data.forword);
			$('#rule_drop_lan1').val(data.rule_drop);

		},
		error : function(xhr, status, error) {
			// Handle the error response, if needed
			console.log("Error loading general Settings: " + error);
		},
	});
}

function getGeneralSettingsLan2(){
	
	$.ajax({
		url : "generalSettingsServletLan2",
		type : "GET",
		dataType : "json",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
	    },
		success : function(data) {
			
			if (data.status == 'fail') {
				
				 var modal = document.getElementById('custom-modal-session-timeout');
				  modal.style.display = 'block';
				  
				// Update the session-msg content with the message from the server
				    var sessionMsg = document.getElementById('session-msg');
				    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

				  
				  // Handle the confirm button click
				  var confirmButton = document.getElementById('confirm-button-session-timeout');
				  confirmButton.onclick = function () {
					  
					// Close the modal
				        modal.style.display = 'none';
				        window.location.href = 'login.jsp';
				  };
					  
			} 

			$('#input_lan2').val(data.input);
			$('#output_lan2').val(data.output);
			$('#forward_lan2').val(data.forword);
			$('#rule_drop_lan2').val(data.rule_drop);

		},
		error : function(xhr, status, error) {
			// Handle the error response, if needed
			console.log("Error loading general Settings: " + error);
		},
	});
}

function updateGeneralSettingsLan0(){

	
}

function updateGeneralSettingsLan1(){
	
}

function updateGeneralSettingsLan2(){
	
}

	function openTab(tabId, button) {
		var tabs = document.getElementsByClassName("tab");
		for (var i = 0; i < tabs.length; i++) {
			tabs[i].style.display = "none";
		}

		var tab = document.getElementById(tabId);
		if (tab) {
			tab.style.display = "block";
		}

		var tabButtons = document.getElementsByClassName("tab-button-lan");
		for (var i = 0; i < tabButtons.length; i++) {
			tabButtons[i].classList.remove("active");
		}

		if (button) {
			button.classList.add("active");
		}
	}

	function openTabBasic(tabId, button) {
		var tabs = document.getElementsByClassName("tab-basic");
		for (var i = 0; i < tabs.length; i++) {
			tabs[i].style.display = "none";
		}

		var tab = document.getElementById(tabId);
		if (tab) {
			tab.style.display = "block";
		}

		var tabButtons = document.getElementsByClassName("tab-button");
		for (var i = 0; i < tabButtons.length; i++) {
			tabButtons[i].classList.remove("active");
		}

		if (button) {
			button.classList.add("active");
		}

		if (tabId === 'user-config-lan1') {
			const
			lan1Button = document
					.querySelector('.tab-button[data-tab-id="user-config-lan1"]');
			if (lan1Button) {
				lan1Button.classList.add('active');
			}
		}

		if (tabId === 'user-config-lan2') {
			const
			lan1Button = document
					.querySelector('.tab-button[data-tab-id="user-config-lan2"]');
			if (lan1Button) {
				lan1Button.classList.add('active');
			}
		}
	}

	// Added function to initialize the page with only the first tab displayed
	function initializePage() {
		var tabs = document.getElementsByClassName("tab");
		for (var i = 1; i < tabs.length; i++) {
			tabs[i].style.display = "none";
		}
	}

	// Call the initializePage function when the page loads
	window.onload = initializePage;
	
	
	$(document).ready(function() {
		<%// Access the session variable
		HttpSession role = request.getSession();
		String roleValue = (String) session.getAttribute("role");%>
		    	
		    	roleValue = '<%=roleValue%>';
		    	
		    	<%// Access the session variable
		    	HttpSession token = request.getSession();
		    	String tokenValue = (String) session.getAttribute("token");%>

		    	tokenValue = '<%=tokenValue%>';
		    
		    	getBasicConfiguration();
		    	
		    	getGeneralSettingsLan0();
		    	getGeneralSettingsLan1();
		    	getGeneralSettingsLan2();
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

			<div class="tab-container-lan">
				<button class="tab-button-lan active"
					onclick="openTab('lan0', this)" style="margin-left: 2px;">LAN0</button>
				<button class="tab-button-lan" onclick="openTab('lan1', this)">LAN1</button>
				<button class="tab-button-lan" onclick="openTab('lan2', this)">LAN2</button>

				<div id="lan0" class="tab" style="display: block; margin-left: 3px;">

					<h3>GENERAL SETTINGS</h3>
					<hr>


					<div class="form-container">
						<form id="generalSettingsForm_lan0" style="width: 100%;">
							<input type="hidden" id="operation_action_lan0"
								name="operation_action_lan0" value="">

							<table>
								<tr>

									<td>Input</td>
									<td><select class="textBox" id="input_lan0"
										name="input_lan0" style="height: 33px; width: 120px;">
											<option value="Accept">Accept</option>
											<option value="Reject">Reject</option>
									</select> <span id="inputError_lan0" style="color: red;"></span></td>

									<td>Output</td>
									<td><select class="textBox" id="output_lan0"
										name="output_lan0" style="height: 33px; width: 120px;">
											<option value="Accept">Accept</option>
											<option value="Reject">Reject</option>
									</select> <span id="outputError_lan0" style="color: red;"></span></td>
								</tr>

								<tr>
									<td>Forward</td>
									<td><select class="textBox" id="forward_lan0"
										name="forward_lan0" style="height: 33px; width: 120px;">
											<option value="Accept">Accept</option>
											<option value="Reject">Reject</option>
									</select> <span id="forwardError_lan0" style="color: red;"></span></td>

									<td>Drop invalid packets</td>
									<td><select class="textBox" id="rule_drop_lan0"
										name="rule_drop_lan0" style="height: 33px; width: 120px;">
											<option value="On">On</option>
											<option value="Off">Off</option>
									</select> <span id="forwardError_lan0" style="color: red;"></span></td>
								</tr>
							</table>

							<div class="row"
								style="display: flex; justify-content: center; margin-top: 1%;">

								<input type="submit" value="Update"
									id="registerBtnGenSettings_lan0" style="margin-left: 5px;" />

							</div>

						</form>
					</div>

					<h3>CONFIGURATION</h3>
					<hr />


					<div class="tab-container">
						<button class="tab-button active"
							onclick="openTabBasic('basic-config', this)"
							style="margin-left: 2px;">Basic Configuration</button>
						<button class="tab-button"
							onclick="openTabBasic('user-config', this)">User
							Configuration</button>

						<div id="basic-config" class="tab-basic"
							style="display: block; margin-left: 3px;">
							<div class="container" style="margin-left: -19px;">

								<table id="basic-config-table" style="width: 100%;">
									<colgroup>
										<col style="width: 5%;">
										<col style="width: 20%;">
										<col style="width: 5%;">
										<col style="width: 15%;">
										<col style="width: 10%;">
										<col style="width: 30%;">
										<col style="width: 15%;">
									</colgroup>

									<thead>
										<tr>
											<th>Seq</th>
											<th>Direction</th>
											<th>LAN Type</th>
											<th>Protocol</th>
											<th>To Port</th>
											<th>Comment</th>
											<th>Action</th>


										</tr>
									</thead>

									<tbody>

									</tbody>


								</table>



								<div class="row"
									style="display: flex; justify-content: right; margin-top: 2%;">
									<input type="button" value="Apply" id="applyBtnBasicConf" />

								</div>

							</div>

							<div id="custom-modal-edit-basic-conf"
								class="modal-edit-basic-conf">
								<div class="modal-content-edit-basic-conf">
									<p>Are you sure you want to modify the basic configuration?</p>
									<button id="confirm-button-edit-basic-conf">Yes</button>
									<button id="cancel-button-edit-basic-conf">No</button>
								</div>
							</div>

							<div id="custom-modal-session-timeout"
								class="modal-session-timeout">
								<div class="modal-content-session-timeout">
									<p id="session-msg"></p>
									<button id="confirm-button-session-timeout">OK</button>
								</div>
							</div>
						</div>

						<div id="user-config" class="tab-basic" style="margin-left: 5px;">
							<h3 style="margin-top: 15px;">ADD TRAFFIC RULES</h3>
							<hr />
							<div class="form-container">
								<form id="trafficRulesForm_lan0">
									<input type="hidden" id="operation_action_lan0"
										name="operation_action_lan0" value="">

									<table class="bordered-table" style="margin-top: -1px;">

										<tr>
											<td>Name</td>
											<td><input type="text" id="name_lan0" name="name_lan0"
												maxlength="31" style="height: 10px;" />
												<p id="nameError_lan0" style="color: red;"></p></td>
											<td>Interface</td>
											<td><select class="textBox" id="iface_lan0" name="iface_lan0"
												style="height: 33px;">
													<option value="Select interface">Select interface</option>
													<option value="lan0">lan0</option>
													<option value="lan1">lan1</option>
													<option value="lan2">lan2</option>
											</select></td>

											<td>Type</td>
											<td><select class="textBox" id="type_lan0" name="type_lan0"
												style="height: 33px;">
													<option value="Select type">Select type</option>
													<option value="IP">IP</option>
													<option value="MAC">MAC</option>
											</select></td>
											<td>Source MAC address</td>
											<td><input type="text" id="macAddress_lan0" name="macAddress_lan0"
												maxlength="31" style="height: 10px;" />
												<p id="macAddrError_lan0" style="color: red;"></p></td>
										</tr>

										<tr>
											<td>Protocol</td>
											<td><select class="textBox" id="protocol_lan0"
												name="protocol_lan0" style="height: 33px;">
													<option value="Select protocol">Select protocol</option>
													<option value="TCP" selected="selected">TCP</option>
													<option value="UDP">UDP</option>
											</select></td>
											
											<td>Source IP address</td>
											<td><input type="text" id="ip_addr_lan0" name="ip_addr_lan0"
												maxlength="31" />
												<p id="sourceIpError_lan0" style="color: red;"></p></td>

											<td>Port</td>
											<td><input type="text" id="portNumber_lan0" name="portNumber_lan0"
												maxlength="6" />
												<p id="destPortError_lan0" style="color: red;"></p></td>
											<td>Action</td>
											<td><select class="textBox" id="action_lan0" name="action_lan0"
												style="height: 33px;">
													<option value="ACCEPT">ACCEPT</option>
													<option value="REJECT">REJECT</option>
											</select></td>
										</tr>

									</table>

									<div class="row"
										style="display: flex; justify-content: center; margin-top: 1%;">
										<input type="button" value="Apply" id="applyBtnRules_lan0" /> <input
											style="margin-left: 5px;" type="button" value="Clear"
											id="clearBtn_lan0" /> <input style="margin-left: 5px;"
											type="submit" value="Add" id="registerBtn_lan0" />
									</div>
								</form>

							</div>

							<div id="custom-modal-delete_lan0" class="modal-delete_lan0">
								<div class="modal-content-delete_lan0">
									<p>Are you sure you want to delete this traffic rule?</p>
									<button id="confirm-button-delete_lan0">Yes</button>
									<button id="cancel-button-delete_lan0">No</button>
								</div>
							</div>



							<div id="custom-modal-edit_lan0" class="modal-edit_lan0">
								<div class="modal-content-edit_lan0">
									<p>Are you sure you want to modify this traffic rule?</p>
									<button id="confirm-button-edit_lan0">Yes</button>
									<button id="cancel-button-edit_lan0">No</button>
								</div>
							</div>

							<h3 style="margin-top: 15px;">TRAFFIC RULES LIST</h3>
							<hr>
							<div class="table-container">
								<table id="trafficRulesListTable_lan0"
									style="margin-left: -1px; width: 100%;">
									<thead>
										<tr>
											<th>Name</th>
											<th>Protocol</th>
											<th>Interface</th>
											<th>Source IP address</th>
											<th>MAC address</th>
											<th>Destination port</th>
											<th>Action</th>
											<th>Type</th>
											<th id="actions_lan0">Actions</th>
										</tr>
									</thead>
									<tbody>

									</tbody>
								</table>
							</div>


						</div>

					</div>


				</div>

				<div id="lan1" class="tab" style="display: block; margin-left: 3px;">

					<h3>GENERAL SETTINGS</h3>
					<hr>

					<div class="form-container">
						<form id="generalSettingsForm_lan1" style="width: 100%;">
							<input type="hidden" id="operation_action_lan1"
								name="operation_action_lan1" value="">

							<table>
								<tr>

									<td>Input</td>
									<td><select class="textBox" id="input_lan1"
										name="input_lan1" style="height: 33px; width: 120px;">
											<option value="Accept">Accept</option>
											<option value="Reject">Reject</option>
									</select> <span id="inputError_lan1" style="color: red;"></span></td>

									<td>Output</td>
									<td><select class="textBox" id="output_lan1"
										name="output_lan1" style="height: 33px; width: 120px;">
											<option value="Accept">Accept</option>
											<option value="Reject">Reject</option>
									</select> <span id="outputError_lan1" style="color: red;"></span></td>
								</tr>

								<tr>
									<td>Forward</td>
									<td><select class="textBox" id="forward_lan1"
										name="forward_lan1" style="height: 33px; width: 120px;">
											<option value="Accept">Accept</option>
											<option value="Reject">Reject</option>
									</select> <span id="forwardError_lan1" style="color: red;"></span></td>

									<td>Drop invalid packets</td>
									<td><select class="textBox" id="rule_drop_lan1"
										name="rule_drop_lan1" style="height: 33px; width: 120px;">
											<option value="On">On</option>
											<option value="Off">Off</option>
									</select> <span id="forwardError_lan1" style="color: red;"></span></td>
								</tr>
							</table>


							<div class="row"
								style="display: flex; justify-content: center; margin-top: 1%;">

								<input type="submit" value="Update"
									id="registerBtnGenSettings_lan1" style="margin-left: 5px;" />

							</div>

						</form>
					</div>

					<h3>CONFIGURATION</h3>
					<hr />

					<div class="tab-container">

						<button class="tab-button active"
							onclick="openTabBasic('user-config-lan1', this)">User
							Configuration</button>


						<div id="user-config-lan1" class="tab-basic"
							style="margin-left: 5px;">
							<h3 style="margin-top: 15px;">ADD TRAFFIC RULES</h3>
							<hr />
							<div class="form-container">
								<form id="trafficRulesForm_lan1">
									<input type="hidden" id="operation_action_lan1"
										name="operation_action_lan1" value="">

									<table class="bordered-table" style="margin-top: -1px;">

										<tr>
											<td>Name</td>
											<td><input type="text" id="name_lan1" name="name_lan1"
												maxlength="31" style="height: 10px;" />
												<p id="nameError_lan1" style="color: red;"></p></td>
											<td>Interface</td>
											<td><select class="textBox" id="iface_lan1" name="iface_lan1"
												style="height: 33px;">
													<option value="Select interface">Select interface</option>
													<option value="lan0">lan0</option>
													<option value="lan1">lan1</option>
													<option value="lan2">lan2</option>
											</select></td>

											<td>Type</td>
											<td><select class="textBox" id="type_lan1" name="type_lan1"
												style="height: 33px;">
													<option value="Select type">Select type</option>
													<option value="IP">IP</option>
													<option value="MAC">MAC</option>
											</select></td>
											<td>Source MAC address</td>
											<td><input type="text" id="macAddress_lan1" name="macAddress_lan1"
												maxlength="31" style="height: 10px;" />
												<p id="macAddrError_lan1" style="color: red;"></p></td>
										</tr>

										<tr>
											<td>Protocol</td>
											<td><select class="textBox" id="protocol_lan1"
												name="protocol_lan1" style="height: 33px;">
													<option value="Select protocol">Select protocol</option>
													<option value="TCP" selected="selected">TCP</option>
													<option value="UDP">UDP</option>
											</select></td>
											<td>Source IP address</td>
											<td><input type="text" id="ip_addr_lan1" name="ip_addr_lan1"
												maxlength="31" />
												<p id="sourceIpError_lan1" style="color: red;"></p></td>

											<td>Port</td>
											<td><input type="text" id="portNumber_lan1" name="portNumber_lan1"
												maxlength="6" />
												<p id="destPortError_lan1" style="color: red;"></p></td>
											<td>Action</td>
											<td><select class="textBox" id="action_lan1" name="action_lan1"
												style="height: 33px;">
													<option value="ACCEPT">ACCEPT</option>
													<option value="REJECT">REJECT</option>
											</select></td>
										</tr>

									</table>

									<div class="row"
										style="display: flex; justify-content: center; margin-top: 1%;">
										<input type="button" value="Apply" id="applyBtnRules_lan1" /> <input
											style="margin-left: 5px;" type="button" value="Clear"
											id="clearBtn_lan1" /> <input style="margin-left: 5px;"
											type="submit" value="Add" id="registerBtn_lan1" />
									</div>
								</form>

							</div>

							<div id="custom-modal-delete_lan1" class="modal-delete_lan1">
								<div class="modal-content-delete_lan1">
									<p>Are you sure you want to delete this traffic rule?</p>
									<button id="confirm-button-delete_lan1">Yes</button>
									<button id="cancel-button-delete_lan1">No</button>
								</div>
							</div>



							<div id="custom-modal-edit_lan1" class="modal-edit_lan1">
								<div class="modal-content-edit_lan1">
									<p>Are you sure you want to modify this traffic rule?</p>
									<button id="confirm-button-edit_lan1">Yes</button>
									<button id="cancel-button-edit_lan1">No</button>
								</div>
							</div>


							<h3 style="margin-top: 15px;">TRAFFIC RULES LIST</h3>
							<hr>
							<div class="table-container">
								<table id="trafficRulesListTable_lan1"
									style="margin-left: -1px; width: 100%;">
									<thead>
										<tr>
											<th>Name</th>
											<th>Protocol</th>
											<th>Interface</th>
											<th>Source IP address</th>
											<th>MAC address</th>
											<th>Destination port</th>
											<th>Action</th>
											<th>Type</th>
											<th id="actions_lan1">Actions</th>
										</tr>
									</thead>
									<tbody>

									</tbody>
								</table>
							</div>


						</div>
					</div>

				</div>

				<div id="lan2" class="tab" style="display: block; margin-left: 3px;">

					<h3>GENERAL SETTINGS</h3>
					<hr>

					<div class="form-container">
						<form id="generalSettingsForm_lan2" style="width: 100%;">
							<input type="hidden" id="operation_action_lan2"
								name="operation_action_lan2" value="">

							<table>
								<tr>

									<td>Input</td>
									<td><select class="textBox" id="input_lan2"
										name="input_lan2" style="height: 33px; width: 120px;">
											<option value="Accept">Accept</option>
											<option value="Reject">Reject</option>
									</select> <span id="inputError_lan2" style="color: red;"></span></td>

									<td>Output</td>
									<td><select class="textBox" id="output_lan2"
										name="output_lan2" style="height: 33px; width: 120px;">
											<option value="Accept">Accept</option>
											<option value="Reject">Reject</option>
									</select> <span id="outputError_lan2" style="color: red;"></span></td>
								</tr>

								<tr>
									<td>Forward</td>
									<td><select class="textBox" id="forward_lan2"
										name="forward_lan2" style="height: 33px; width: 120px;">
											<option value="Accept">Accept</option>
											<option value="Reject">Reject</option>
									</select> <span id="forwardError_lan2" style="color: red;"></span></td>

									<td>Drop invalid packets</td>
									<td><select class="textBox" id="rule_drop_lan2"
										name="rule_drop_lan2" style="height: 33px; width: 120px;">
											<option value="On">On</option>
											<option value="Off">Off</option>
									</select> <span id="forwardError_lan2" style="color: red;"></span></td>
								</tr>
							</table>


							<div class="row"
								style="display: flex; justify-content: center; margin-top: 1%;">

								<input type="submit" value="Update"
									id="registerBtnGenSettings_lan2" style="margin-left: 5px;" />

							</div>

						</form>
					</div>

					<h3>CONFIGURATION</h3>
					<hr />

					<div class="tab-container">

						<button class="tab-button active"
							onclick="openTabBasic('user-config-lan2', this)">User
							Configuration</button>


						<div id="user-config-lan2" class="tab-basic"
							style="margin-left: 5px;">
							<h3 style="margin-top: 15px;">ADD TRAFFIC RULES</h3>
							<hr />
							<div class="form-container">
								<form id="trafficRulesForm_lan2">
									<input type="hidden" id="operation_action_lan2"
										name="operation_action_lan2" value="">

									<table class="bordered-table" style="margin-top: -1px;">

										<tr>
											<td>Name</td>
											<td><input type="text" id="name_lan2" name="name_lan2"
												maxlength="31" style="height: 10px;" />
												<p id="nameError_lan2" style="color: red;"></p></td>
											<td>Interface</td>
											<td><select class="textBox" id="iface_lan2" name="iface_lan2"
												style="height: 33px;">
													<option value="Select interface">Select interface</option>
													<option value="lan0">lan0</option>
													<option value="lan1">lan1</option>
													<option value="lan2">lan2</option>
											</select></td>

											<td>Type</td>
											<td><select class="textBox" id="type_lan2" name="type_lan2"
												style="height: 33px;">
													<option value="Select type">Select type</option>
													<option value="IP">IP</option>
													<option value="MAC">MAC</option>
											</select></td>
											<td>Source MAC address</td>
											<td><input type="text" id="macAddress_lan2" name="macAddress_lan2"
												maxlength="31" style="height: 10px;" />
												<p id="macAddrError_lan2" style="color: red;"></p></td>
										</tr>

										<tr>
											<td>Protocol</td>
											<td><select class="textBox" id="protocol_lan2"
												name="protocol_lan2" style="height: 33px;">
													<option value="Select protocol">Select protocol</option>
													<option value="TCP" selected="selected">TCP</option>
													<option value="UDP">UDP</option>
											</select></td>
											<td>Source IP address</td>
											<td><input type="text" id="ip_addr_lan2" name="ip_addr_lan2"
												maxlength="31" />
												<p id="sourceIpError_lan2" style="color: red;"></p></td>

											<td>Port</td>
											<td><input type="text" id="portNumber_lan2" name="portNumber_lan2"
												maxlength="6" />
												<p id="destPortError_lan2" style="color: red;"></p></td>
											<td>Action</td>
											<td><select class="textBox" id="action_lan2" name="action_lan2"
												style="height: 33px;">
													<option value="ACCEPT">ACCEPT</option>
													<option value="REJECT">REJECT</option>
											</select></td>
										</tr>

									</table>

									<div class="row"
										style="display: flex; justify-content: center; margin-top: 1%;">
										<input type="button" value="Apply" id="applyBtnRules_lan2" /> <input
											style="margin-left: 5px;" type="button" value="Clear"
											id="clearBtn_lan2" /> <input style="margin-left: 5px;"
											type="submit" value="Add" id="registerBtn_lan2" />
									</div>
								</form>

							</div>

							<div id="custom-modal-delete_lan2" class="modal-delete_lan2">
								<div class="modal-content-delete_lan2">
									<p>Are you sure you want to delete this traffic rule?</p>
									<button id="confirm-button-delete_lan2">Yes</button>
									<button id="cancel-button-delete_lan2">No</button>
								</div>
							</div>


							<div id="custom-modal-edit_lan2" class="modal-edit_lan2">
								<div class="modal-content-edit_lan2">
									<p>Are you sure you want to modify this traffic rule?</p>
									<button id="confirm-button-edit_lan2">Yes</button>
									<button id="cancel-button-edit_lan2">No</button>
								</div>
							</div>

							<h3 style="margin-top: 15px;">TRAFFIC RULES LIST</h3>
							<hr>
							<div class="table-container">
								<table id="trafficRulesListTable_lan2"
									style="margin-left: -1px; width: 100%;">
									<thead>
										<tr>
											<th>Name</th>
											<th>Protocol</th>
											<th>Interface</th>
											<th>Source IP address</th>
											<th>MAC address</th>
											<th>Destination port</th>
											<th>Action</th>
											<th>Type</th>
											<th id="actions_lan2">Actions</th>
										</tr>
									</thead>
									<tbody>

									</tbody>
								</table>
							</div>


						</div>
					</div>

				</div>

			</div>
			
			<div id="custom-modal-session-timeout"
								class="modal-session-timeout">
								<div class="modal-content-session-timeout">
									<p id="session-msg"></p>
									<button id="confirm-button-session-timeout">OK</button>
								</div>
							</div>
							
							<div id="customPopup" class="popup">
								<span class="popup-content" id="popupMessage"></span>
								<button id="closePopup">OK</button>
							</div>
							
			

		</section>
	</div>


	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>