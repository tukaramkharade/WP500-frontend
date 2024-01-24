<%  
    // Add X-Frame-Options header to prevent clickjacking
    response.setHeader("X-Frame-Options", "DENY");
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
	max-width: 750px;
	/* border-collapse: collapse;
	background-color: #f2f2f2;
	border-radius: 5px; */
	
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
.modal-edit_lan2,
.modal-edit-gen-lan0,
.modal-edit-gen-lan1,
.modal-edit-gen-lan2,
.modal-apply
 {
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
.modal-content-edit_lan2,
.modal-content-edit-gen-lan0,
.modal-content-edit-gen-lan1,
.modal-content-edit-gen-lan2,
.modal-content-apply
  {
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
            cursor: pointer;
            border-radius: 5px;
            border: none;
            font-size: small;
             padding: 10px 20px;
        }

#confirm-button-edit-basic-conf,
#confirm-button-session-timeout,
#confirm-button-delete_lan0,
#confirm-button-edit_lan0,
#confirm-button-delete_lan1,
#confirm-button-edit_lan1,
#confirm-button-delete_lan2,
#confirm-button-edit_lan2,
#confirm-button-edit-gen-lan0,
#confirm-button-edit-gen-lan1,
#confirm-button-edit-gen-lan2,
#confirm-button-apply
 {
	background-color: #4caf50;
	color: white;
}

#cancel-button-edit-basic-conf, 
#cancel-button-delete_lan0,
#cancel-button-edit_lan0,
#cancel-button-delete_lan1,
#cancel-button-edit_lan1,
#cancel-button-delete_lan2,
#cancel-button-edit_lan2,
#cancel-button-edit-gen-lan0,
#cancel-button-edit-gen-lan1,
#cancel-button-edit-gen-lan2,
#cancel-button-apply
 {
	background-color: #f44336;
	color: white;
}

.button-container {
            display: flex;
            justify-content: flex-end;
            margin: 10px; /* Add margin as needed */
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
    
     
</style>

<script>

var roleValue; 
var tokenValue;
var globalId;
var globalAction;
var globalData = [];
var csrfTokenValue;

function getBasicConfiguration(){
	
	// Display loader when the request is initiated
    showLoader();
	
	$.ajax({
		url : "BasicConfigurationServlet",
		type : "GET",
		dataType : "json",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
	    },
	    success : function(data) {
	    	// Hide loader when the response has arrived
            hideLoader();
	    	
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
									select.val(basicConfig.action.toUpperCase());

									
									// Set the selected option based on the value of basicConfig.action
									//select.val(basicConfig.action);

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
			
			// Hide loader when the response has arrived
            hideLoader();
			
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

			$('#input_lan0').val(data.input);
			$('#output_lan0').val(data.output);
			$('#forward_lan0').val(data.forword);
			$('#rule_drop_lan0').val(data.rule_drop); 

		},
		error : function(xhr, status, error) {
			
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
			
		},
	});
}

function updateGeneralSettingsLan0(){
	
	 var csrfToken = document.getElementById('csrfToken').value;
	 
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-edit-gen-lan0');
	  modal.style.display = 'block';
	  
	// Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-edit-gen-lan0');
	  confirmButton.onclick = function () {
		  
		  var input = $('#input_lan0').val();
			var output = $('#output_lan0').val();
			var forward = $('#forward_lan0').val();
			var rule_drop = $('#rule_drop_lan0').val();
			
			$.ajax({
				url : 'generalSettingsServletLan0',
				type : 'POST',
				data : {
					input : input,
					output : output,
					forward : forward,
					rule_drop : rule_drop,
					csrfToken: csrfToken,
					operation_action_lan0: 'update'

				},
				success : function(data) {
					if (data.status == 'fail') {
						
						 var modal1 = document.getElementById('custom-modal-session-timeout');
						  modal1.style.display = 'block';
						  
						// Update the session-msg content with the message from the server
						    var sessionMsg = document.getElementById('session-msg');
						    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

						  
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
			        getGeneralSettingsLan0();

					// Clear form fields

					$('#input_lan0').val('');
					$('#output_lan0').val('');
					$('#forward_lan0').val('');
					$('#rule_drop_lan0').val('');

				},
				error : function(xhr, status, error) {
					
				}
			});
				
	  };
	  
	  var cancelButton = document.getElementById('cancel-button-edit-gen-lan0');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	   
	  };
	
}

function updateGeneralSettingsLan1(){
	 var csrfToken = document.getElementById('csrfToken').value;
	 
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-edit-gen-lan1');
	  modal.style.display = 'block';
	  
	// Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-edit-gen-lan1');
	  confirmButton.onclick = function () {
		  
		  var input = $('#input_lan1').val();
			var output = $('#output_lan1').val();
			var forward = $('#forward_lan1').val();
			var rule_drop = $('#rule_drop_lan1').val();
			
			$.ajax({
				url : 'generalSettingsServletLan1',
				type : 'POST',
				data : {
					input : input,
					output : output,
					forward : forward,
					rule_drop : rule_drop,
					csrfToken: csrfToken,
					operation_action_lan1: 'update'

				},
				success : function(data) {
					if (data.status == 'fail') {
						
						 var modal1 = document.getElementById('custom-modal-session-timeout');
						  modal1.style.display = 'block';
						  
						// Update the session-msg content with the message from the server
						    var sessionMsg = document.getElementById('session-msg');
						    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

						  
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
			        getGeneralSettingsLan1();

					// Clear form fields

					$('#input_lan1').val('');
					$('#output_lan1').val('');
					$('#forward_lan1').val('');
					$('#rule_drop_lan1').val('');

				},
				error : function(xhr, status, error) {
					
				}
			});
				
	  };
	  
	  var cancelButton = document.getElementById('cancel-button-edit-gen-lan1');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	   
	  };
	
}

function updateGeneralSettingsLan2(){
	 var csrfToken = document.getElementById('csrfToken').value;
	 
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-edit-gen-lan2');
	  modal.style.display = 'block';
	  
	// Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-edit-gen-lan2');
	  confirmButton.onclick = function () {
		  
		  var input = $('#input_lan2').val();
			var output = $('#output_lan2').val();
			var forward = $('#forward_lan2').val();
			var rule_drop = $('#rule_drop_lan2').val();
			
			$.ajax({
				url : 'generalSettingsServletLan2',
				type : 'POST',
				data : {
					input : input,
					output : output,
					forward : forward,
					rule_drop : rule_drop,
					csrfToken: csrfToken,
					operation_action_lan2: 'update'

				},
				success : function(data) {
					if (data.status == 'fail') {
						
						 var modal1 = document.getElementById('custom-modal-session-timeout');
						  modal1.style.display = 'block';
						  
						// Update the session-msg content with the message from the server
						    var sessionMsg = document.getElementById('session-msg');
						    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

						  
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
			        getGeneralSettingsLan2();

					// Clear form fields

					$('#input_lan2').val('');
					$('#output_lan2').val('');
					$('#forward_lan2').val('');
					$('#rule_drop_lan2').val('');

				},
				error : function(xhr, status, error) {
					
				}
			});
				
	  };
	  
	  var cancelButton = document.getElementById('cancel-button-edit-gen-lan2');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	   
	  };
	
}

function loadTrafficRulesListLan0() {
	
	$.ajax({
		url : "trafficRulesServletLan0",
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
			
			var trafficRulesTable = $("#trafficRulesListTable_lan0 tbody");
			trafficRulesTable.empty();

			if(roleValue == 'Admin' || roleValue == 'ADMIN'){
				 
				data.result.forEach(function(trafficrules) {
					
					if(trafficrules.iface === 'lan0'){
						
						var name = trafficrules.name; 
						var protocol = trafficrules.protocol; 
						var fromIPAddress = trafficrules.fromIp; 
						var toIPAddress = trafficrules.toIp;
						var fromPortNum = trafficrules.fromPort; 
						var toPortNum = trafficrules.toPort; 
						var action = trafficrules.action; 
						
						var row = $("<tr>").append($("<td>").text(name),
								$("<td>").text(protocol),
								$("<td>").text(fromIPAddress),
								$("<td>").text(fromPortNum),
								$("<td>").text(toIPAddress),
								$("<td>").text(toPortNum),
								$("<td>").text(action));
						
						var actions = $("<td>");

						var editButton = $(
								'<button data-toggle="tooltip" class="editBtn" data-placement="top" title="Edit" style="color: #35449a;">')
								.html('<i class="fas fa-edit"></i>')
								.click(
										function() {
											setName_lan0(trafficrules.name);
											setProtocol_lan0(trafficrules.protocol);
											setFromPort_lan0(trafficrules.fromPort);
											setToPort_lan0(trafficrules.toPort);
											setFromIP_lan0(trafficrules.fromIp);
											setToIP_lan0(trafficrules.toIp);
											setAction_lan0(trafficrules.action);

										});

						var deleteButton = $(
								'<button data-toggle="tooltip" class="delBtn" data-placement="top" title="Delete" style="color: red">')
								.html('<i class="fas fa-trash-alt"></i>')
								.click(
										function() {
											
											deleteTrafficRulesLan0(trafficrules.name);
										});

						
						actions.append(editButton);
						actions.append(deleteButton);

						row.append(actions);

						trafficRulesTable.append(row);

					}
					
				
				});
			
			}else if(roleValue == 'OPERATOR' || roleValue == 'Operator'){
				data.result.forEach(function(trafficrules) {
					if(trafficrules.iface === 'lan0'){
					var name = trafficrules.name; 
					var protocol = trafficrules.protocol; 
					var fromIPAddress = trafficrules.fromIp; 
					var toIPAddress = trafficrules.toIp;
					var fromPortNum = trafficrules.fromPort; 
					var toPortNum = trafficrules.toPort; 
					var action = trafficrules.action; 
					
					var row = $("<tr>").append($("<td>").text(name),
							$("<td>").text(protocol),
							$("<td>").text(fromIPAddress),
							$("<td>").text(fromPortNum),
							$("<td>").text(toIPAddress),
							$("<td>").text(toPortNum),
							$("<td>").text(action));
					
					trafficRulesTable.append(row);
					}
				});
			}
		},
		error : function(xhr, status, error) {
			
		},
	});
	
}

function loadTrafficRulesListLan1() {
	
	$.ajax({
		url : "trafficRulesServletLan1",
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
			
			var trafficRulesTable = $("#trafficRulesListTable_lan1 tbody");
			trafficRulesTable.empty();

			if(roleValue == 'Admin' || roleValue == 'ADMIN'){
				 
				data.result.forEach(function(trafficrules) {
					
					if(trafficrules.iface === 'lan1'){
						
					var name = trafficrules.name; 
					var protocol = trafficrules.protocol; 
					var fromIPAddress = trafficrules.fromIp; 
					var toIPAddress = trafficrules.toIp;
					var fromPortNum = trafficrules.fromPort; 
					var toPortNum = trafficrules.toPort; 
					var action = trafficrules.action; 
				
				var row = $("<tr>").append($("<td>").text(name),
						$("<td>").text(protocol),
						$("<td>").text(fromIPAddress),
						$("<td>").text(fromPortNum),
						$("<td>").text(toIPAddress),
						$("<td>").text(toPortNum),
						$("<td>").text(action));
				
				var actions = $("<td>");

				var editButton = $(
						'<button data-toggle="tooltip" class="editBtn" data-placement="top" title="Edit" style="color: #35449a;">')
						.html('<i class="fas fa-edit"></i>')
						.click(
								function() {
									setName_lan1(trafficrules.name);
									setProtocol_lan1(trafficrules.protocol);
									setFromPort_lan1(trafficrules.fromPort);
									setToPort_lan1(trafficrules.toPort);
									setFromIP_lan1(trafficrules.fromIp);
									setToIP_lan1(trafficrules.toIp);
									setAction_lan1(trafficrules.action);

								});

				var deleteButton = $(
						'<button data-toggle="tooltip" class="delBtn" data-placement="top" title="Delete" style="color: red">')
						.html('<i class="fas fa-trash-alt"></i>')
						.click(
								function() {
									
									deleteTrafficRulesLan1(trafficrules.name);
								});

				
				actions.append(editButton);
				actions.append(deleteButton);

				row.append(actions);

				trafficRulesTable.append(row);
					}
				});
				
			
			}else if(roleValue == 'OPERATOR' || roleValue == 'Operator'){
				data.result.forEach(function(trafficrules) {
					
					if(trafficrules.iface === 'lan1'){
					var name = trafficrules.name; 
					var protocol = trafficrules.protocol; 
					var fromIPAddress = trafficrules.fromIp; 
					var toIPAddress = trafficrules.toIp;
					var fromPortNum = trafficrules.fromPort; 
					var toPortNum = trafficrules.toPort; 
					var action = trafficrules.action; 
					
					var row = $("<tr>").append($("<td>").text(name),
							$("<td>").text(protocol),
							$("<td>").text(fromIPAddress),
							$("<td>").text(fromPortNum),
							$("<td>").text(toIPAddress),
							$("<td>").text(toPortNum),
							$("<td>").text(action));
					
					trafficRulesTable.append(row);
					}
				});
			}
		},
		error : function(xhr, status, error) {
			
		},
	});
}

function loadTrafficRulesListLan2() {
	
	$.ajax({
		url : "trafficRulesServletLan2",
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
			
			var trafficRulesTable = $("#trafficRulesListTable_lan2 tbody");
			trafficRulesTable.empty();

			if(roleValue == 'Admin' || roleValue == 'ADMIN'){
				 
				data.result.forEach(function(trafficrules) {
					
					if(trafficrules.iface === 'lan2'){
					
					var name = trafficrules.name; 
					var protocol = trafficrules.protocol; 
					var fromIPAddress = trafficrules.fromIp; 
					var toIPAddress = trafficrules.toIp;
					var fromPortNum = trafficrules.fromPort; 
					var toPortNum = trafficrules.toPort; 
					var action = trafficrules.action; 
				
				var row = $("<tr>").append($("<td>").text(name),
						$("<td>").text(protocol),
						$("<td>").text(fromIPAddress),
						$("<td>").text(fromPortNum),
						$("<td>").text(toIPAddress),
						$("<td>").text(toPortNum),
						$("<td>").text(action));
				
				var actions = $("<td>");

				var editButton = $(
						'<button data-toggle="tooltip" class="editBtn" data-placement="top" title="Edit" style="color: #35449a;">')
						.html('<i class="fas fa-edit"></i>')
						.click(
								function() {
									setName_lan2(trafficrules.name);							
									setProtocol_lan2(trafficrules.protocol);
									setFromPort_lan2(trafficrules.fromPort);
									setToPort_lan2(trafficrules.toPort);
									setFromIP_lan2(trafficrules.fromIp);
									setToIP_lan2(trafficrules.toIp);
									setAction_lan2(trafficrules.action);

								});

				var deleteButton = $(
						'<button data-toggle="tooltip" class="delBtn" data-placement="top" title="Delete" style="color: red">')
						.html('<i class="fas fa-trash-alt"></i>')
						.click(
								function() {
									
									deleteTrafficRulesLan2(trafficrules.name);
								});

				actions.append(editButton);
				actions.append(deleteButton);

				row.append(actions);

				trafficRulesTable.append(row);
					}
				});
			
			}else if(roleValue == 'OPERATOR' || roleValue == 'Operator'){
				data.result.forEach(function(trafficrules) {
					
					if(trafficrules.iface === 'lan2'){
					var name = trafficrules.name; 
					var protocol = trafficrules.protocol; 
					var fromIPAddress = trafficrules.fromIp; 
					var toIPAddress = trafficrules.toIp;
					var fromPortNum = trafficrules.fromPort; 
					var toPortNum = trafficrules.toPort; 
					var action = trafficrules.action; 
					
					var row = $("<tr>").append($("<td>").text(name),
							$("<td>").text(protocol),
							$("<td>").text(fromIPAddress),
							$("<td>").text(fromPortNum),
							$("<td>").text(toIPAddress),
							$("<td>").text(toPortNum),
							$("<td>").text(action));
					
					trafficRulesTable.append(row);
					}
				});
			}
		},
		error : function(xhr, status, error) {
			
		},
	});
}


function setName_lan0(trafficRulesId) {

	$('#name_lan0').val(trafficRulesId);
	$("#name_lan0").prop("disabled", true);
	$('#registerBtn_lan0').val('Update');

}

function setProtocol_lan0(trafficRulesId) {

	$('#protocol_lan0').val(trafficRulesId);
}

function setFromPort_lan0(trafficRulesId) {

	$('#from_port_lan0').val(trafficRulesId);
}

function setToPort_lan0(trafficRulesId) {

	$('#to_port_lan0').val(trafficRulesId);
}

function setFromIP_lan0(trafficRulesId) {

	$('#from_ip_lan0').val(trafficRulesId);

}

function setToIP_lan0(trafficRulesId) {

	$('#to_ip_lan0').val(trafficRulesId);
}

function setAction_lan0(trafficRulesId) {

	$('#action_lan0').val(trafficRulesId);
}


function setName_lan1(trafficRulesId) {

	$('#name_lan1').val(trafficRulesId);
	$("#name_lan1").prop("disabled", true);
	$('#registerBtn_lan1').val('Update');

}

function setProtocol_lan1(trafficRulesId) {

	$('#protocol_lan1').val(trafficRulesId);
}

function setFromPort_lan1(trafficRulesId) {

	$('#from_port_lan1').val(trafficRulesId);
}

function setToPort_lan1(trafficRulesId) {

	$('#to_port_lan1').val(trafficRulesId);
}


function setFromIP_lan1(trafficRulesId) {

	$('#from_ip_lan1').val(trafficRulesId);

}

function setToIP_lan1(trafficRulesId) {

	$('#to_ip_lan1').val(trafficRulesId);

}

function setAction_lan1(trafficRulesId) {

	$('#action_lan1').val(trafficRulesId);
}


function setName_lan2(trafficRulesId) {

	$('#name_lan2').val(trafficRulesId);
	$("#name_lan2").prop("disabled", true);
	$('#registerBtn_lan2').val('Update');

}

function setProtocol_lan2(trafficRulesId) {

	$('#protocol_lan2').val(trafficRulesId);
}

function setFromPort_lan2(trafficRulesId) {

	$('#from_port_lan2').val(trafficRulesId);
}

function setToPort_lan2(trafficRulesId) {

	$('#to_port_lan2').val(trafficRulesId);
}


function setFromIP_lan2(trafficRulesId) {

	$('#from_ip_lan2').val(trafficRulesId);

}

function setToIP_lan2(trafficRulesId) {

	$('#to_ip_lan2').val(trafficRulesId);

}

function setAction_lan2(trafficRulesId) {

	$('#action_lan2').val(trafficRulesId);
}

function validateIPAddr(ipAddr) {
    var regex = /^(\d{1,3}\.){0,3}\d{1,3}$/;

    if (ipAddr !== '' && !regex.test(ipAddr)) {
        return 'Invalid IP Address. Please enter a valid IP address.';
    }

    return null; // Validation passed
}

function validateName(name) {
    var regex = /^[a-zA-Z][a-zA-Z0-9]*$/;

    if (!regex.test(name)) {
        return 'Invalid name; symbols not allowed';
    }

    return null; // Validation passed
}

function validatePortNumber(portNumber) {
    // Check if it contains only numbers
    if (!/^\d+$/.test(portNumber)) {
        return 'Port number should contain only numbers.';
    }

    // Check if it has a maximum length of 5 digits
    if (portNumber.length > 5) {
        return 'Port number should have a maximum of 5 digits.';
    }

    // Validation passed
    return null;
}


function addTrafficRulesLan0() {
	var name = $('#name_lan0').val();
	var protocol = $('#protocol_lan0').find(":selected").val();
	var from_ip_addr = $('#from_ip_lan0').val();
	var to_ip_addr = $('#to_ip_lan0').val();
	var from_port = $('#from_port_lan0').val();
	var to_port = $('#to_port_lan0').val();
	var action = $('#action_lan0').find(":selected").val();
	var csrfToken = document.getElementById('csrfToken').value;

	$('#field_name_Error_lan0').text('');
    $('#field_from_ip_Error_lan0').text('');
    $('#field_from_port_Error_lan0').text('');
    $('#field_to_ip_Error_lan0').text('');
    $('#field_to_port_Error_lan0').text('');

	var nameError = validateName(name);
    if (nameError) {
        $('#field_name_Error_lan0').text(nameError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
        return;
    }

    var fromIPAddrError = validateIPAddr(from_ip_addr);
    if (fromIPAddrError) {
        $('#field_from_ip_Error_lan0').text(fromIPAddrError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
        return;
    }

    var fromPortError = validatePortNumber(from_port);
    if (fromPortError) {
        $('#field_from_port_Error_lan0').text(fromPortError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
        return;
    }
    
    var toIPAddrError = validateIPAddr(to_ip_addr);
    if (toIPAddrError) {
        $('#field_to_ip_Error_lan0').text(toIPAddrError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
        return;
    }

    var toPortError = validatePortNumber(to_port);
    if (toPortError) {
        $('#field_to_port_Error_lan0').text(toPortError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
        return;
    }
    
	$.ajax({
		url : "trafficRulesServletLan0",
		type : "POST",
		data : {
			name : name,
			from_port : from_port,
			to_port : to_port,
			protocol : protocol,
			from_ip_addr : from_ip_addr,
			to_ip_addr : to_ip_addr,
			action : action,
			csrfToken: csrfToken,
			operation_action_lan0: 'add'
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
		
			// Display the custom popup message
 			$("#popupMessage").text(data.message);
  			$("#customPopup").show();

  			
			loadTrafficRulesListLan0();

			// Clear form fields
			$('#name_lan0').val('');
			$('#from_port_lan0').val('');
			$('#to_port_lan0').val('');
			$('#protocol_lan0').val('TCP');
			$('#from_ip_lan0').val('');
			$('#to_ip_lan0').val('');
			$('#action_lan0').val('ACCEPT');

		},
		error : function(xhr, status, error) {
			
		},
	});
	
	$("#closePopup").click(function () {
	    $("#customPopup").hide();
	  });

	$("#registerBtn_lan0").val("Add");
	
}
 
 function addTrafficRulesLan1() {
		
		var name = $('#name_lan1').val();
		var from_port = $('#from_port_lan1').val();
		var to_port = $('#to_port_lan1').val();
		var protocol = $('#protocol_lan1').find(":selected").val();
		var from_ip_addr = $('#from_ip_lan1').val();
		var to_ip_addr = $('#to_ip_lan1').val();
		var action = $('#action_lan1').find(":selected").val();
		var csrfToken = document.getElementById('csrfToken').value;
		
		$('#field_name_Error_lan1').text('');
	    $('#field_from_ip_Error_lan1').text('');
	    $('#field_from_port_Error_lan1').text('');
	    $('#field_to_ip_Error_lan1').text('');
	    $('#field_to_port_Error_lan1').text('');

		var nameError = validateName(name);
	    if (nameError) {
	        $('#field_name_Error_lan1').text(nameError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }

	    var fromIPAddrError = validateIPAddr(from_ip_addr);
	    if (fromIPAddrError) {
	        $('#field_from_ip_Error_lan1').text(fromIPAddrError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }

	    var fromPortError = validatePortNumber(from_port);
	    if (fromPortError) {
	        $('#field_from_port_Error_lan1').text(fromPortError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }
	    
	    var toIPAddrError = validateIPAddr(to_ip_addr);
	    if (toIPAddrError) {
	        $('#field_to_ip_Error_lan1').text(toIPAddrError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }

	    var toPortError = validatePortNumber(to_port);
	    if (toPortError) {
	        $('#field_to_port_Error_lan1').text(toPortError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }

		$.ajax({
			url : "trafficRulesServletLan1",
			type : "POST",
			data : {
				name : name,
				from_port : from_port,
				to_port : to_port,
				protocol : protocol,
				from_ip_addr : from_ip_addr,
				to_ip_addr : to_ip_addr,
				action : action,
				csrfToken: csrfToken,
				operation_action_lan1: 'add'
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
			
				// Display the custom popup message
	 			$("#popupMessage").text(data.message);
	  			$("#customPopup").show();

	  			
				loadTrafficRulesListLan2();

				// Clear form fields
				$('#name_lan1').val('');
				$('#from_port_lan1').val('');
				$('#to_port_lan1').val('');
				$('#protocol_lan1').val('TCP');
				$('#from_ip_lan1').val('');
				$('#to_ip_lan1').val('');
				$('#action_lan1').val('ACCEPT');

			},
			error : function(xhr, status, error) {
				
			},
		});
		
		$("#closePopup").click(function () {
		    $("#customPopup").hide();
		  });

		$("#registerBtn_lan1").val("Add");
	}

 function addTrafficRulesLan2() {
	
	var name = $('#name_lan2').val();
	var from_port = $('#from_port_lan2').val();
	var to_port = $('#to_port_lan2').val();
	var protocol = $('#protocol_lan2').find(":selected").val();
	var from_ip_addr = $('#from_ip_lan2').val();
	var to_ip_addr = $('#to_ip_lan2').val();
	var action = $('#action_lan2').find(":selected").val();
	var csrfToken = document.getElementById('csrfToken').value;
	
	$('#field_name_Error_lan2').text('');
    $('#field_from_ip_Error_lan2').text('');
    $('#field_from_port_Error_lan2').text('');
    $('#field_to_ip_Error_lan2').text('');
    $('#field_to_port_Error_lan2').text('');

	var nameError = validateName(name);
    if (nameError) {
        $('#field_name_Error_lan2').text(nameError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
        return;
    }

    var fromIPAddrError = validateIPAddr(from_ip_addr);
    if (fromIPAddrError) {
        $('#field_from_ip_Error_lan2').text(fromIPAddrError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
        return;
    }

    var fromPortError = validatePortNumber(from_port);
    if (fromPortError) {
        $('#field_from_port_Error_lan2').text(fromPortError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
        return;
    }
    
    var toIPAddrError = validateIPAddr(to_ip_addr);
    if (toIPAddrError) {
        $('#field_to_ip_Error_lan2').text(toIPAddrError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
        return;
    }

    var toPortError = validatePortNumber(to_port);
    if (toPortError) {
        $('#field_to_port_Error_lan2').text(toPortError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
        return;
    }

	$.ajax({
		url : "trafficRulesServletLan2",
		type : "POST",
		data : {
			name : name,
			from_port : from_port,
			to_port : to_port,
			protocol : protocol,
			from_ip_addr : from_ip_addr,
			to_ip_addr : to_ip_addr,
			action : action,
			csrfToken: csrfToken,
			operation_action_lan2: 'add'
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
		
			// Display the custom popup message
 			$("#popupMessage").text(data.message);
  			$("#customPopup").show();

  			
			loadTrafficRulesListLan2();

			// Clear form fields
			$('#name_lan2').val('');
			$('#from_port_lan2').val('');
			$('#to_port_lan2').val('');
			$('#protocol_lan2').val('TCP');
			$('#from_ip_lan2').val('');
			$('#to_ip_lan2').val('');
			$('#action_lan2').val('ACCEPT');

		},
		error : function(xhr, status, error) {
			
		},
	});
	
	$("#closePopup").click(function () {
	    $("#customPopup").hide();
	  });

	$("#registerBtn_lan2").val("Add");
}

function deleteTrafficRulesLan0(trafficRulesId) {
	var csrfToken = document.getElementById('csrfToken').value;
	
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-delete_lan0');
	  modal.style.display = 'block';

	  // Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-delete_lan0');
	  confirmButton.onclick = function () {
		  
		  $.ajax({
			  url: 'trafficRulesServletLan0',
		      type: 'POST',
		      data: {
		    	  name : trafficRulesId,
		    	  csrfToken: csrfToken,
					operation_action_lan0: 'delete'
		      },
		      success: function (data) {
 		        
		    	  if (data.status == 'fail') {
						
						 var modal1 = document.getElementById('custom-modal-session-timeout');
						  modal1.style.display = 'block';
						  
						// Update the session-msg content with the message from the server
						    var sessionMsg = document.getElementById('session-msg');
						    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

						  
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

			        // Refresh the user list
			        loadTrafficRulesListLan0();
			        
			        location.reload();
			      },
			      error: function (xhr, status, error) {
			        
			        // Close the modal
			        modal.style.display = 'none';
			      }
			    });
		  
	  };
	  
	  // Handle the cancel button click
	  var cancelButton = document.getElementById('cancel-button-delete_lan0');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	  };
}

function deleteTrafficRulesLan1(trafficRulesId) {
	var csrfToken = document.getElementById('csrfToken').value;
	
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-delete_lan1');
	  modal.style.display = 'block';

	  // Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-delete_lan1');
	  confirmButton.onclick = function () {
		  
		  $.ajax({
			  url: 'trafficRulesServletLan1',
		      type: 'POST',
		      data: {
		    	  name : trafficRulesId,
		    	  csrfToken: csrfToken,
					operation_action_lan1: 'delete'
		      },
		      success: function (data) {
 		        
		    	  if (data.status == 'fail') {
						
						 var modal1 = document.getElementById('custom-modal-session-timeout');
						  modal1.style.display = 'block';
						  
						// Update the session-msg content with the message from the server
						    var sessionMsg = document.getElementById('session-msg');
						    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

						  
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

			        // Refresh the user list
			        loadTrafficRulesListLan1();
			        location.reload();
			      },
			      error: function (xhr, status, error) {
			        
			        // Close the modal
			        modal.style.display = 'none';
			      }
			    });
		  
	  };
	  
	  // Handle the cancel button click
	  var cancelButton = document.getElementById('cancel-button-delete_lan1');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	  };
}

function deleteTrafficRulesLan2(trafficRulesId) {
	var csrfToken = document.getElementById('csrfToken').value;
	
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-delete_lan2');
	  modal.style.display = 'block';

	  // Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-delete_lan2');
	  confirmButton.onclick = function () {
		  
		  $.ajax({
			  url: 'trafficRulesServletLan2',
		      type: 'POST',
		      data: {
		    	  name : trafficRulesId,
		    	  csrfToken: csrfToken,
					operation_action_lan2: 'delete'
		      },
		      success: function (data) {
 		        
		    	  if (data.status == 'fail') {
						
						 var modal1 = document.getElementById('custom-modal-session-timeout');
						  modal1.style.display = 'block';
						  
						// Update the session-msg content with the message from the server
						    var sessionMsg = document.getElementById('session-msg');
						    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

						  
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

			        // Refresh the user list
			        loadTrafficRulesListLan2();
			        location.reload();
			      },
			      error: function (xhr, status, error) {
			        
			        // Close the modal
			        modal.style.display = 'none';
			      }
			    });
		  
	  };
	  
	  // Handle the cancel button click
	  var cancelButton = document.getElementById('cancel-button-delete_lan2');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	  };
}

function editTrafficRulesLan0() {
	
	 	var name = $('#name_lan0').val();
		var from_port = $('#from_port_lan0').val();
		var to_port = $('#to_port_lan0').val();
		var protocol = $('#protocol_lan0').find(":selected").val();
		var from_ip_addr = $('#from_ip_lan0').val();
		var to_ip_addr = $('#to_ip_lan0').val();
		var action = $('#action_lan0').find(":selected").val();
		var csrfToken = document.getElementById('csrfToken').value;
				
		$('#field_name_Error_lan0').text('');
	    $('#field_from_ip_Error_lan0').text('');
	    $('#field_from_port_Error_lan0').text('');
	    $('#field_to_ip_Error_lan0').text('');
	    $('#field_to_port_Error_lan0').text('');

		var nameError = validateName(name);
	    if (nameError) {
	        $('#field_name_Error_lan0').text(nameError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }

	    var fromIPAddrError = validateIPAddr(from_ip_addr);
	    if (fromIPAddrError) {
	        $('#field_from_ip_Error_lan0').text(fromIPAddrError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }

	    var fromPortError = validatePortNumber(from_port);
	    if (fromPortError) {
	        $('#field_from_port_Error_lan0').text(fromPortError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }
	    
	    var toIPAddrError = validateIPAddr(to_ip_addr);
	    if (toIPAddrError) {
	        $('#field_to_ip_Error_lan0').text(toIPAddrError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }

	    var toPortError = validatePortNumber(to_port);
	    if (toPortError) {
	        $('#field_to_port_Error_lan0').text(toPortError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }

	
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-edit_lan0');
	  modal.style.display = 'block';
	  
	// Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-edit_lan0');
	  confirmButton.onclick = function () {
		   
			$.ajax({
				url : 'trafficRulesServletLan0',
				type : 'POST',
				data : {
					name : name,
					from_port : from_port,
					to_port : to_port,
					protocol : protocol,
					from_ip_addr : from_ip_addr,
					to_ip_addr : to_ip_addr,
					action : action,
					csrfToken: csrfToken,
					operation_action_lan0: 'update'
				},
				success : function(data) {
					if (data.status == 'fail') {
						
						 var modal1 = document.getElementById('custom-modal-session-timeout');
						  modal1.style.display = 'block';
						  
						// Update the session-msg content with the message from the server
						    var sessionMsg = document.getElementById('session-msg');
						    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

						  
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
					
					loadTrafficRulesListLan0();

					// Clear form fields
					$('#name_lan0').val('');
					$('#from_port_lan0').val('');
					$('#to_port_lan0').val('');
					$('#protocol_lan0').val('TCP');
					$('#from_ip_lan0').val('');
					$('#to_ip_lan0').val('');
					$('#action_lan0').val('ACCEPT');

					$("#name_lan0").prop("disabled", false);
					
				},
				error : function(xhr, status, error) {
					
				}
			});
			$('#registerBtn_lan0').val('Add');
	  };
	  
	  var cancelButton = document.getElementById('cancel-button-edit_lan0');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	    $('#registerBtn_lan0').val('Update');
	  };

	
}

function editTrafficRulesLan1() {
	
		var name = $('#name_lan1').val();
		var from_port = $('#from_port_lan1').val();
		var to_port = $('#to_port_lan1').val();
		var protocol = $('#protocol_lan1').find(":selected").val();
		var from_ip_addr = $('#from_ip_lan1').val();
		var to_ip_addr = $('#to_ip_lan1').val();
		var action = $('#action_lan1').find(":selected").val();
		var csrfToken = document.getElementById('csrfToken').value;
					
		$('#field_name_Error_lan1').text('');
	    $('#field_from_ip_Error_lan1').text('');
	    $('#field_from_port_Error_lan1').text('');
	    $('#field_to_ip_Error_lan1').text('');
	    $('#field_to_port_Error_lan1').text('');

		var nameError = validateName(name);
	    if (nameError) {
	        $('#field_name_Error_lan1').text(nameError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }

	    var fromIPAddrError = validateIPAddr(from_ip_addr);
	    if (fromIPAddrError) {
	        $('#field_from_ip_Error_lan1').text(fromIPAddrError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }

	    var fromPortError = validatePortNumber(from_port);
	    if (fromPortError) {
	        $('#field_from_port_Error_lan1').text(fromPortError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }

	    var toIPAddrError = validateIPAddr(to_ip_addr);
	    if (toIPAddrError) {
	        $('#field_to_ip_Error_lan1').text(toIPAddrError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }

	    var toPortError = validatePortNumber(to_port);
	    if (toPortError) {
	        $('#field_to_port_Error_lan1').text(toPortError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }
	    
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-edit_lan1');
	  modal.style.display = 'block';
	  
	// Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-edit_lan1');
	  confirmButton.onclick = function () {
		  
		 
			$.ajax({
				url : 'trafficRulesServletLan1',
				type : 'POST',
				data : {
					name : name,
					from_port : from_port,
					to_port : to_port,
					protocol : protocol,
					from_ip_addr : from_ip_addr,
					to_ip_addr : to_ip_addr,
					action : action,
					csrfToken: csrfToken,
					operation_action_lan1: 'update'
				},
				success : function(data) {
					if (data.status == 'fail') {
						
						 var modal1 = document.getElementById('custom-modal-session-timeout');
						  modal1.style.display = 'block';
						  
						// Update the session-msg content with the message from the server
						    var sessionMsg = document.getElementById('session-msg');
						    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

						  
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
					
					loadTrafficRulesListLan1();

					// Clear form fields
					$('#name_lan1').val('');
					$('#from_port_lan1').val('');
					$('#to_port_lan1').val('');
					$('#protocol_lan1').val('TCP');
					$('#from_ip_lan1').val('');
					$('#to_ip_lan1').val('');
					$('#action_lan1').val('ACCEPT');

					$("#name_lan1").prop("disabled", false);
					
				},
				error : function(xhr, status, error) {
					
				}
			});
			$('#registerBtn_lan1').val('Add');
	  };
	  
	  var cancelButton = document.getElementById('cancel-button-edit_lan1');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	    $('#registerBtn_lan1').val('Update');
	  };

}

function editTrafficRulesLan2() {
	
	 	var name = $('#name_lan2').val();
		var from_port = $('#from_port_lan2').val();
		var to_port = $('#to_port_lan2').val();
		var protocol = $('#protocol_lan2').find(":selected").val();
		var from_ip_addr = $('#from_ip_lan2').val();
		var to_ip_addr = $('#to_ip_lan2').val();
		var action = $('#action_lan2').find(":selected").val();
		var csrfToken = document.getElementById('csrfToken').value;
	
		$('#field_name_Error_lan2').text('');
	    $('#field_from_ip_Error_lan2').text('');
	    $('#field_from_port_Error_lan2').text('');
	    $('#field_to_ip_Error_lan2').text('');
	    $('#field_to_port_Error_lan2').text('');

		var nameError = validateName(name);
	    if (nameError) {
	        $('#field_name_Error_lan2').text(nameError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }
	    
	    var fromIPAddrError = validateIPAddr(from_ip_addr);
	    if (fromIPAddrError) {
	        $('#field_from_ip_Error_lan2').text(fromIPAddrError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }
  
	    var fromPortError = validatePortNumber(from_port);
	    if (fromPortError) {
	        $('#field_from_port_Error_lan2').text(fromPortError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }
	    
	    var toIPAddrError = validateIPAddr(to_ip_addr);
	    if (toIPAddrError) {
	        $('#field_to_ip_Error_lan2').text(toIPAddrError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }
  
	    var toPortError = validatePortNumber(to_port);
	    if (toPortError) {
	        $('#field_to_port_Error_lan2').text(toPortError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }
	    
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-edit_lan2');
	  modal.style.display = 'block';
	  
	// Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-edit_lan2');
	  confirmButton.onclick = function () {
		  
		
			$.ajax({
				url : 'trafficRulesServletLan2',
				type : 'POST',
				data : {
					name : name,
					from_port : from_port,
					to_port : to_port,
					protocol : protocol,
					from_ip_addr : from_ip_addr,
					to_ip_addr : to_ip_addr,
					action : action,
					csrfToken: csrfToken,
					operation_action_lan2: 'update'
				},
				success : function(data) {
					if (data.status == 'fail') {
						
						 var modal1 = document.getElementById('custom-modal-session-timeout');
						  modal1.style.display = 'block';
						  
						// Update the session-msg content with the message from the server
						    var sessionMsg = document.getElementById('session-msg');
						    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

						  
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
					
					loadTrafficRulesListLan2();

					// Clear form fields
					$('#name_lan2').val('');
					$('#from_port_lan2').val('');
					$('#to_port_lan2').val('');
					$('#protocol_lan2').val('TCP');
					$('#from_ip_lan2').val('');
					$('#to_ip_lan2').val('');
					$('#action_lan2').val('ACCEPT');

					$("#name_lan2").prop("disabled", false);
					
				},
				error : function(xhr, status, error) {
					
				}
			});
			$('#registerBtn_lan2').val('Add');
	  };
	  
	  var cancelButton = document.getElementById('cancel-button-edit_lan2');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	    $('#registerBtn_lan2').val('Update');
	  };

}

function applyTrafficRules() {
	
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-apply');
	  modal.style.display = 'block';
	  
	// Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-apply');
	  confirmButton.onclick = function () {

	$.ajax({
		url : "trafficRulesApplyServletLan0",
		type : "GET",
		dataType : "json",
		success : function(data) {

			modal.style.display = 'none';
			
		// Display the custom popup message
 			$("#popupMessage").text(data.message);
  			$("#customPopup").show();
	

		},
		error : function(xhr, status, error) {
			
		},
	});
	
	  };
	  
	  var cancelButton = document.getElementById('cancel-button-apply');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	    
	  };	
	  
	$("#closePopup").click(function () {
	    $("#customPopup").hide();
	  });
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
	
	function changeButtonColor(isDisabled) {
		 var $registerBtnGenSettings_lan0 = $('#registerBtnGenSettings_lan0'); 
		 var $registerBtnGenSettings_lan1 = $('#registerBtnGenSettings_lan1'); 
		 var $registerBtnGenSettings_lan2 = $('#registerBtnGenSettings_lan2'); 
		 
		 var $updateBtnBasicConf = $('#updateBtnBasicConf'); 
		 
		 var $applyBtn = $('#applyBtn'); 
				 
		 var $clearBtn_lan0 = $('#clearBtn_lan0'); 
		 var $clearBtn_lan1 = $('#clearBtn_lan1'); 
		 var $clearBtn_lan2 = $('#clearBtn_lan2'); 
		 
		 var $registerBtn_lan0 = $('#registerBtn_lan0'); 
		 var $registerBtn_lan1 = $('#registerBtn_lan1'); 
		 var $registerBtn_lan2 = $('#registerBtn_lan2'); 
		 
		
		 if (isDisabled) {
	            $registerBtnGenSettings_lan0.css('background-color', 'gray'); // Change to your desired color
	        } else {
	            $registerBtnGenSettings_lan0.css('background-color', '#2b3991'); // Reset to original color
	        }
		 
		 if (isDisabled) {
	            $registerBtnGenSettings_lan1.css('background-color', 'gray'); // Change to your desired color
	        } else {
	            $registerBtnGenSettings_lan1.css('background-color', '#2b3991'); // Reset to original color
	        }
		 if (isDisabled) {
	            $registerBtnGenSettings_lan2.css('background-color', 'gray'); // Change to your desired color
	        } else {
	            $registerBtnGenSettings_lan2.css('background-color', '#2b3991'); // Reset to original color
	        }
		 
		 
		 if (isDisabled) {
	            $updateBtnBasicConf.css('background-color', 'gray'); // Change to your desired color
	        } else {
	            $updateBtnBasicConf.css('background-color', '#2b3991'); // Reset to original color
	        }
		 
		 
		 if (isDisabled) {
	            $applyBtn.css('background-color', 'gray'); // Change to your desired color
	        } else {
	            $applyBtn.css('background-color', '#2b3991'); // Reset to original color
	        }
		 
		 if (isDisabled) {
	            $clearBtn_lan0.css('background-color', 'gray'); // Change to your desired color
	        } else {
	            $clearBtn_lan0.css('background-color', '#2b3991'); // Reset to original color
	        }
		 if (isDisabled) {
	            $clearBtn_lan1.css('background-color', 'gray'); // Change to your desired color
	        } else {
	            $clearBtn_lan1.css('background-color', '#2b3991'); // Reset to original color
	        }
		 if (isDisabled) {
	            $clearBtn_lan2.css('background-color', 'gray'); // Change to your desired color
	        } else {
	            $clearBtn_lan2.css('background-color', '#2b3991'); // Reset to original color
	        }
		 
		 
		 if (isDisabled) {
	            $registerBtn_lan0.css('background-color', 'gray'); // Change to your desired color
	        } else {
	            $registerBtn_lan0.css('background-color', '#2b3991'); // Reset to original color
	        }
		 if (isDisabled) {
	            $registerBtn_lan1.css('background-color', 'gray'); // Change to your desired color
	        } else {
	            $registerBtn_lan1.css('background-color', '#2b3991'); // Reset to original color
	        }
		 if (isDisabled) {
	            $registerBtn_lan2.css('background-color', 'gray'); // Change to your desired color
	        } else {
	            $registerBtn_lan2.css('background-color', '#2b3991'); // Reset to original color
	        }
		
	}
		
	// Function to show the loader
	 function showLoader() {
	     // Show the loader overlay
	     $('#loader-overlay').show();
	 }

	 // Function to hide the loader
	 function hideLoader() {
	     // Hide the loader overlay
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

					$('#registerBtnGenSettings_lan0').prop('disabled', true);
					$('#registerBtnGenSettings_lan1').prop('disabled', true);
					$('#registerBtnGenSettings_lan2').prop('disabled', true);
					
					$('#updateBtnBasicConf').prop('disabled', true);
					
					$('#applyBtn').prop('disabled', true);
										
					$('#clearBtn_lan0').prop('disabled', true);
					$('#clearBtn_lan1').prop('disabled', true);
					$('#clearBtn_lan2').prop('disabled', true);
					
					$('#registerBtn_lan0').prop('disabled', true);
					$('#registerBtn_lan1').prop('disabled', true);
					$('#registerBtn_lan2').prop('disabled', true);
					
					changeButtonColor(true);
				}
				
				if (roleValue === "null") {
			        var modal = document.getElementById('custom-modal-session-timeout');
			        modal.style.display = 'block';

			        var sessionMsg = document.getElementById('session-msg');
				    sessionMsg.textContent = 'You are not allowed to redirect like this !!'; 
				    
			        // Handle the confirm button click
			        var confirmButton = document.getElementById('confirm-button-session-timeout');
			        confirmButton.onclick = function() {
			            // Close the modal
			            modal.style.display = 'none';
			            window.location.href = 'login.jsp';
			        };
			        
				}else{   
		    	
		    	<%// Access the session variable
		    	HttpSession token = request.getSession();
		    	String tokenValue = (String) session.getAttribute("token");%>

		    	tokenValue = '<%=tokenValue%>';
		    
		    	getBasicConfiguration();
		    	
		    	getGeneralSettingsLan0();
		    	getGeneralSettingsLan1();
		    	getGeneralSettingsLan2();
		    	
		    	loadTrafficRulesListLan0();
		    	loadTrafficRulesListLan1();
		    	loadTrafficRulesListLan2();
		    			    	
		    	$("#updateBtnBasicConf").click(function() {
		   		 var newData = []; // Create an array to store the current data

		   		    // Iterate through the table rows to collect data for each row
		   		    $("#basic-config-table tbody tr").each(function() {
		   		        var id = $(this).find("td:eq(0)").text(); // Get the ID
		   		        var action = $(this).find("td:eq(6) select").val(); // Get the action from the select element

		   		        newData.push({ id: id, action: action }); // Add the data to the newData array
		   		    });

		   		 // Now, you can merge the current data with the existing globalData
		   		    if (!globalData) {
		   		        globalData = [];
		   		    }
		   		    globalData = globalData.concat(newData);
		   	    
		   	    sendAccumulatedData();
		   	});
		    			    		    	
		    	$('#generalSettingsForm_lan0').submit(function(event) {
		    		event.preventDefault(); 		
		    		updateGeneralSettingsLan0();
		    		
		    	});
		    	
				$('#generalSettingsForm_lan1').submit(function(event) {
					updateGeneralSettingsLan1();
		    	});
		    	
				$('#generalSettingsForm_lan2').submit(function(event) {
					updateGeneralSettingsLan2();
				});
				
				
				$("#trafficRulesForm_lan0").submit(function(event) {
					
					event.preventDefault();
					var buttonText = $("#registerBtn_lan0").val();
					
					if (buttonText == "Add") {
						addTrafficRulesLan0();
					} else {
						editTrafficRulesLan0();
					}
				});
				
				$("#trafficRulesForm_lan1").submit(function(event) {
					
					event.preventDefault();
					var buttonText = $("#registerBtn_lan1").val();
					
					if (buttonText == "Add") {
						addTrafficRulesLan1();
					} else {
						editTrafficRulesLan1();
					}
				});
				
				$("#trafficRulesForm_lan2").submit(function(event) {
	
					event.preventDefault();
					var buttonText = $("#registerBtn_lan2").val();
					
					if (buttonText == "Add") {
						addTrafficRulesLan2();
					} else {
						editTrafficRulesLan2();
					}
				});
				
				
				$('#applyBtn').click(function() {
					applyTrafficRules();

				});
						
		        	$('#clearBtn_lan0').click(function() {
		    		$('#name_lan0').val('');
		    		$('#from_port_lan0').val('');
		    		$('#to_port_lan0').val('');
		    		$('#protocol_lan0').val('TCP');
		    		$('#from_ip_lan0').val('');
		    		$('#to_ip_lan0').val('');
		    		$('#action_lan0').val('ACCEPT');
		    		$('#registerBtn_lan0').val('Add');
		    		
		    	});
		    	
		    	$('#clearBtn_lan1').click(function() {
		    		$('#name_lan1').val('');
		    		$('#from_port_lan1').val('');
		    		$('#to_port_lan1').val('');
		    		$('#protocol_lan1').val('TCP');
		    		$('#from_ip_lan1').val('');
		    		$('#to_ip_lan1').val('');
		    		$('#action_lan1').val('ACCEPT');
		    		$('#registerBtn_lan1').val('Add');
		    		
		    	});
		    	
		    	$('#clearBtn_lan2').click(function() {
		    		$('#name_lan2').val('');
		    		$('#from_port_lan2').val('');
		    		$('#to_port_lan2').val('');
		    		$('#protocol_lan2').val('TCP');
		    		$('#from_ip_lan2').val('');
		    		$('#to_ip_lan2').val('');
		    		$('#action_lan2').val('ACCEPT');
		    		$('#registerBtn_lan2').val('Add');
		    	
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

			<div class="tab-container-lan">
			
			<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>

<input type="hidden" name="csrfToken" id="csrfToken" value="<%= csrfTokenValue %>" />
				<button class="tab-button-lan active"
					onclick="openTab('lan0', this)" style="margin-left: 2px;">LAN0</button>
				<button class="tab-button-lan" onclick="openTab('lan1', this)">LAN1</button>
				<button class="tab-button-lan" onclick="openTab('lan2', this)">LAN2</button>
				
				<div class="button-container">
        <button style="color:white; background-color: #2b3991; margin-top: -40px;" id="applyBtn">Apply</button>
    </div>

				<div id="lan0" class="tab" style="display: block; margin-left: 3px;">

					<h3>GENERAL SETTINGS</h3>
					<hr>


					<div class="form-container" style="width: 40%;">
						<form id="generalSettingsForm_lan0" style="width: 100%;">
							<input type="hidden" id="operation_action_lan0" name="operation_action_lan0" value="">
							

							<table>
								<tr>

									<td>Input</td>
									<td><select class="textBox" id="input_lan0"
										name="input_lan0" style="height: 33px; width: 120px;">
											<option value="ACCEPT">ACCEPT</option>
											<option value="REJECT">REJECT</option>
									</select> <span id="inputError_lan0" style="color: red;"></span></td>

									<td>Output</td>
									<td><select class="textBox" id="output_lan0"
										name="output_lan0" style="height: 33px; width: 120px;">
											<option value="ACCEPT">ACCEPT</option>
											<option value="REJECT">REJECT</option>
									</select> <span id="outputError_lan0" style="color: red;"></span></td>
								</tr>

								<tr>
									<td>Forward</td>
									<td><select class="textBox" id="forward_lan0"
										name="forward_lan0" style="height: 33px; width: 120px;">
											<option value="ACCEPT">ACCEPT</option>
											<option value="REJECT">REJECT</option>
									</select> <span id="forwardError_lan0" style="color: red;"></span></td>

									<td>Drop invalid packets</td>
									<td><select class="textBox" id="rule_drop_lan0"
										name="rule_drop_lan0" style="height: 33px; width: 120px;">
											<option value="ON">ON</option>
											<option value="OFF">OFF</option>
									</select> <span id="forwardError_lan0" style="color: red;"></span></td>
								</tr>
							</table>

							<div class="row"
								style="display: flex; justify-content: center; margin-top: 1%;">

								<input type="submit" value="Update"
									id="registerBtnGenSettings_lan0" style="margin-left: 5px;" />

							</div>

						</form>
						
						<div id="custom-modal-edit-gen-lan0" class="modal-edit-gen-lan0">
				<div class="modal-content-edit-gen-lan0">
				  <p>Are you sure you want to modify this general setting?</p>
				  <button id="confirm-button-edit-gen-lan0">Yes</button>
				  <button id="cancel-button-edit-gen-lan0">No</button>
				</div>
			  </div>
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
									<input type="button" value="Update" id="updateBtnBasicConf" />

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
											<td style="height: 50px; width: 230px;">
											<input type="text" id="name_lan0" name="name_lan0"
												maxlength="21" required style="height: 10px;"/>
												<span id="field_name_Error_lan0" class="error-message" style="display: block; margin-top: 5px;"></span>
												</td>
											
											<td>Protocol</td>
											<td><select class="textBox" id="protocol_lan0"
												name="protocol_lan0" style="height: 33px;">
													
													<option value="TCP" selected="selected">TCP</option>
													<option value="UDP">UDP</option>
											</select></td>
												
												
											<td>From IP</td>
											<td style="height: 50px; width: 230px;">
											<input type="text" id="from_ip_lan0" name="from_ip_lan0"
												maxlength="31" style="height: 10px;"/>
												<span id="field_from_ip_Error_lan0" class="error-message" style="display: block; margin-top: 5px;"></span>
												
												</td>
										</tr>
										<tr>
											
											<td>From port</td>
											<td><input type="text" id="from_port_lan0" name="from_port_lan0"
												maxlength="6" required/>
												<span id="field_from_port_Error_lan0" class="error-message" style="display: block; margin-top: 5px;"></span>
												</td>
												
												
												<td>To IP</td>
											<td style="height: 50px; width: 230px;">
											<input type="text" id="to_ip_lan0" name="to_ip_lan0"
												maxlength="31" style="height: 10px;"/>
												<span id="field_to_ip_Error_lan0" class="error-message" style="display: block; margin-top: 5px;"></span>
												
												</td>
												
												
												<td>To port</td>
											<td><input type="text" id="to_port_lan0" name="portNumber_lan0"
												maxlength="6" required/>
												<span id="field_to_port_Error_lan0" class="error-message" style="display: block; margin-top: 5px;"></span>
												</td>
											
												
												</tr>
												<tr>
										
											<td>Action</td>
											<td><select class="textBox" id="action_lan0" name="action_lan0"
												style="height: 33px;">
													<option value="ACCEPT" selected>ACCEPT</option>
													<option value="DROP">DROP</option>
											</select></td>
										</tr>

									</table>

									<div class="row"
										style="display: flex; justify-content: center; margin-top: 1%;">
										 <input
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
											<th>From IP</th>
											<th>From port</th>
											<th>To IP</th>
											<th>To port</th>
											<th>Action</th>
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

					<div class="form-container" style="width: 40%;">
						<form id="generalSettingsForm_lan1" style="width: 100%;">
							<input type="hidden" id="operation_action_lan1"
								name="operation_action_lan1" value="">

							<table>
								<tr>

									<td>Input</td>
									<td><select class="textBox" id="input_lan1"
										name="input_lan1" style="height: 33px; width: 120px;">
											<option value="ACCEPT">ACCEPT</option>
											<option value="REJECT">REJECT</option>
									</select> <span id="inputError_lan1" style="color: red;"></span></td>

									<td>Output</td>
									<td><select class="textBox" id="output_lan1"
										name="output_lan1" style="height: 33px; width: 120px;">
											<option value="ACCEPT">ACCEPT</option>
											<option value="REJECT">REJECT</option>
									</select> <span id="outputError_lan1" style="color: red;"></span></td>
								</tr>

								<tr>
									<td>Forward</td>
									<td><select class="textBox" id="forward_lan1"
										name="forward_lan1" style="height: 33px; width: 120px;">
											<option value="ACCEPT">ACCEPT</option>
											<option value="REJECT">REJECT</option>
									</select> <span id="forwardError_lan1" style="color: red;"></span></td>

									<td>Drop invalid packets</td>
									<td><select class="textBox" id="rule_drop_lan1"
										name="rule_drop_lan1" style="height: 33px; width: 120px;">
											<option value="ON">ON</option>
											<option value="OFF">OFF</option>
									</select> <span id="forwardError_lan1" style="color: red;"></span></td>
								</tr>
							</table>


							<div class="row"
								style="display: flex; justify-content: center; margin-top: 1%;">

								<input type="submit" value="Update"
									id="registerBtnGenSettings_lan1" style="margin-left: 5px;" />

							</div>

						</form>
						
			  
			  <div id="custom-modal-edit-gen-lan1" class="modal-edit-gen-lan1">
				<div class="modal-content-edit-gen-lan1">
				  <p>Are you sure you want to modify this general setting?</p>
				  <button id="confirm-button-edit-gen-lan1">Yes</button>
				  <button id="cancel-button-edit-gen-lan1">No</button>
				</div>
			  </div>
					</div>

						<div id="user-config-lan1" style="margin-left: 5px;">
							<h3 style="margin-top: 15px;">ADD TRAFFIC RULES</h3>
							<hr />
							<div class="form-container">
								<form id="trafficRulesForm_lan1">
									<input type="hidden" id="operation_action_lan1"
										name="operation_action_lan1" value="">

									<table class="bordered-table" style="margin-top: -1px;">

										<tr>
										<td>Name</td>
											<td style="height: 50px; width: 230px;">
											<input type="text" id="name_lan1" name="name_lan1"
												maxlength="21" required style="height: 10px;"/>
												<span id="field_name_Error_lan1" class="error-message" style="display: block; margin-top: 5px;"></span>
												</td>
												
												<td>Protocol</td>
											<td><select class="textBox" id="protocol_lan1"
												name="protocol_lan1" style="height: 33px;">
													
													<option value="TCP" selected="selected">TCP</option>
													<option value="UDP">UDP</option>
											</select></td>
											
											<td>From IP</td>
											<td style="height: 50px; width: 230px;">
											<input type="text" id="from_ip_lan1" name="from_ip_lan1"
												maxlength="31" style="height: 10px;"/>
												<span id="field_from_ip_Error_lan1" class="error-message" style="display: block; margin-top: 5px;"></span>
												
												</td>
																				
											</tr>
											
											<tr>
																						
											<td>From port</td>
											<td><input type="text" id="from_port_lan1" name="from_port_lan1"
												maxlength="6" required/>
												<span id="field_from_port_Error_lan1" class="error-message" style="display: block; margin-top: 5px;"></span>
												</td>
												
												
												<td>To IP</td>
											<td style="height: 50px; width: 230px;">
											<input type="text" id="to_ip_lan1" name="to_ip_lan1"
												maxlength="31" style="height: 10px;"/>
												<span id="field_to_ip_Error_lan1" class="error-message" style="display: block; margin-top: 5px;"></span>
												
												</td>
												
												
												<td>To port</td>
											<td><input type="text" id="to_port_lan1" name="to_port_lan1"
												maxlength="6" required/>
												<span id="field_to_port_Error_lan1" class="error-message" style="display: block; margin-top: 5px;"></span>
												</td>
											
											</tr>
											<tr>
										
											<td>Action</td>
											<td><select class="textBox" id="action_lan1" name="action_lan1"
												style="height: 33px;">
													<option value="ACCEPT" selected>ACCEPT</option>
													<option value="DROP">DROP</option>
											</select></td>
										</tr>

										
									</table>

									<div class="row"
										style="display: flex; justify-content: center; margin-top: 1%;">
										 <input
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
											<th>From IP</th>
											<th>From Port</th>
											<th>To IP</th>
											<th>To Port</th>
											<th>Action</th>
											<th id="actions_lan1">Actions</th>
										</tr>
									</thead>
									<tbody>

									</tbody>
								</table>
							</div>

						</div>
					
				</div>

				<div id="lan2" class="tab" style="display: block; margin-left: 3px;">

					<h3>GENERAL SETTINGS</h3>
					<hr>

					<div class="form-container" style="width: 40%;">
						<form id="generalSettingsForm_lan2" style="width: 100%;">
							<input type="hidden" id="operation_action_lan2"
								name="operation_action_lan2" value="">

							<table>
								<tr>

									<td>Input</td>
									<td><select class="textBox" id="input_lan2"
										name="input_lan2" style="height: 33px; width: 120px;">
											<option value="ACCEPT">ACCEPT</option>
											<option value="REJECT">REJECT</option>
									</select> <span id="inputError_lan2" style="color: red;"></span></td>

									<td>Output</td>
									<td><select class="textBox" id="output_lan2"
										name="output_lan2" style="height: 33px; width: 120px;">
											<option value="ACCEPT">ACCEPT</option>
											<option value="REJECT">REJECT</option>
									</select> <span id="outputError_lan2" style="color: red;"></span></td>
								</tr>

								<tr>
									<td>Forward</td>
									<td><select class="textBox" id="forward_lan2"
										name="forward_lan2" style="height: 33px; width: 120px;">
											<option value="ACCEPT">ACCEPT</option>
											<option value="REJECT">REJECT</option>
									</select> <span id="forwardError_lan2" style="color: red;"></span></td>

									<td>Drop invalid packets</td>
									<td><select class="textBox" id="rule_drop_lan2"
										name="rule_drop_lan2" style="height: 33px; width: 120px;">
											<option value="ON">ON</option>
											<option value="OFF">OFF</option>
									</select> <span id="forwardError_lan2" style="color: red;"></span></td>
								</tr>
							</table>


							<div class="row"
								style="display: flex; justify-content: center; margin-top: 1%;">

								<input type="submit" value="Update"
									id="registerBtnGenSettings_lan2" style="margin-left: 5px;" />

							</div>

						</form>
						
						<div id="custom-modal-edit-gen-lan2" class="modal-edit-gen-lan2">
				<div class="modal-content-edit-gen-lan2">
				  <p>Are you sure you want to modify this general setting?</p>
				  <button id="confirm-button-edit-gen-lan2">Yes</button>
				  <button id="cancel-button-edit-gen-lan2">No</button>
				</div>
			  </div>
					</div>

						<div id="user-config-lan2" style="margin-left: 5px;">
							<h3 style="margin-top: 15px;">ADD TRAFFIC RULES</h3>
							<hr />
							<div class="form-container">
								<form id="trafficRulesForm_lan2">
									<input type="hidden" id="operation_action_lan2"
										name="operation_action_lan2" value="">

									<table class="bordered-table" style="margin-top: -1px;">

										<tr>
										
											<td>Name</td>
											<td style="height: 50px; width: 230px;">
											<input type="text" id="name_lan2" name="name_lan2"
												maxlength="21" required style="height: 10px;"/>
												<span id="field_name_Error_lan2" class="error-message" style="display: block; margin-top: 5px;"></span>
												</td>
												
												<td>Protocol</td>
											<td><select class="textBox" id="protocol_lan2"
												name="protocol_lan2" style="height: 33px;">
													
													<option value="TCP" selected="selected">TCP</option>
													<option value="UDP">UDP</option>
											</select></td>
												
											<td>From IP</td>
											<td style="height: 50px; width: 230px;">
											<input type="text" id="from_ip_lan2" name="from_ip_lan2"
												maxlength="31" style="height: 10px;"/>
												<span id="field_from_ip_Error_lan2" class="error-message" style="display: block; margin-top: 5px;"></span>
												
												</td>
										</tr>
										<tr>
											
											<td>From port</td>
											<td><input type="text" id="from_port_lan2" name="from_port_lan2"
												maxlength="6" required/>
												<span id="field_from_port_Error_lan2" class="error-message" style="display: block; margin-top: 5px;"></span>
												</td>
												
												
												<td>To IP</td>
											<td style="height: 50px; width: 230px;">
											<input type="text" id="to_ip_lan2" name="to_ip_lan2"
												maxlength="31" style="height: 10px;"/>
												<span id="field_to_ip_Error_lan2" class="error-message" style="display: block; margin-top: 5px;"></span>
												
												</td>
												
												<td>To port</td>
											<td><input type="text" id="to_port_lan2" name="to_port_lan2"
												maxlength="6" required/>
												<span id="field_to_port_Error_lan2" class="error-message" style="display: block; margin-top: 5px;"></span>
												</td>
											
											</tr>
											<tr>
										
											<td>Action</td>
											<td><select class="textBox" id="action_lan2" name="action_lan2"
												style="height: 33px;">
													<option value="ACCEPT" selected>ACCEPT</option>
													<option value="DROP">DROP</option>
											</select></td>
										</tr>

																			</table>

									<div class="row"
										style="display: flex; justify-content: center; margin-top: 1%;">
										<input
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
											<th>From IP</th>
											<th>From Port</th>
											<th>To IP</th>
											<th>To Port</th>
											<th>Action</th>
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
							
							<div id="custom-modal-apply" class="modal-apply">
				<div class="modal-content-apply">
				  <p>Are you sure you want to apply settings?</p>
				  <button id="confirm-button-apply">Yes</button>
				  <button id="cancel-button-apply">No</button>
				</div>
			  </div>
							
			

		</section>
	</div>


	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>