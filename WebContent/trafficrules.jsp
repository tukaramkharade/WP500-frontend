<!DOCTYPE html>
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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
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
.modal-delete {
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

.modal-content-delete {
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

.modal-edit {
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

.modal-content-edit {
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

.modal-delete-gen {
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

.modal-content-delete-gen {
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

.modal-edit-gen {
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

.modal-content-edit-gen {
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

.modal-edit-basic-conf {
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

.modal-content-edit-basic-conf {
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

/* Style for buttons */
button {
  margin: 5px;
  padding: 10px 20px;
  border: none;
  cursor: pointer;
}

#confirm-button-delete {
  background-color: #4caf50;
  color: white;
}

#cancel-button-delete {
  background-color: #f44336;
  color: white;
}

#confirm-button-edit {
  background-color: #4caf50;
  color: white;
}

#cancel-button-edit {
  background-color: #f44336;
  color: white;
}

#confirm-button-delete-gen {
  background-color: #4caf50;
  color: white;
}

#cancel-button-delete-gen {
  background-color: #f44336;
  color: white;
}

#confirm-button-edit-gen {
  background-color: #4caf50;
  color: white;
}

#cancel-button-edit-gen {
  background-color: #f44336;
  color: white;
}

#confirm-button-edit-basic-conf {
  background-color: #4caf50;
  color: white;
}

#cancel-button-edit-basic-conf {
  background-color: #f44336;
  color: white;
}

#confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
}


select,
option {
  
  padding: 4px;
  
  font-size: small;
  
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

/* Style for the close button */
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
    border-collapse: collapse;
   
  }

table{
margin-top: 1px;

}
  .container th, .container td {
    border: 1px solid #ccc; /* Light gray border */
    
    text-align: left;
    
  }
  
  /* styles.css */
.tab {
            display: none;
        }
        
        .tab-button {
            background-color: #f2f2f2;
            padding: 10px 20px;
            border: none;
            cursor: pointer;
        }
        
        .tab-button.active {
            background-color: #2b3991;
            color: white;
        }
        
        .tab-content {
            padding: 20px;
            border: 1px solid #ccc;
        }
        
        .form-container {
    margin: 0 auto;
    width: 80%;
    border-collapse: collapse;
    background-color: #f2f2f2;
     border-radius: 5px;
  padding: 20px;
  }
  
  
  .form-container td{
    border: 1px solid #ccc; /* Light gray border */
  }
  
  
  
</style>
<script>

var roleValue; 
var tokenValue;
var globalId;
var globalAction;
var globalData = [];


	function loadTrafficRulesList() {
		$.ajax({
					url : "trafficRulesServlet",
					type : "GET",
					dataType : "json",
					beforeSend: function(xhr) {
				        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
				    },
					success : function(data) {
						// Clear existing table rows

						var trafficRulesTable = $("#trafficRulesListTable tbody");
						trafficRulesTable.empty();

						var json1 = JSON.stringify(data);

						var json = JSON.parse(json1);

						handleStatus(json.status);

						// Iterate through the traffic rules data and add rows to the table
						
						if(roleValue == 'Admin' || roleValue == 'ADMIN'){
							$.each(data,function(index, trafficrules) {
											var row = $("<tr>");
											row.append($("<td>").text(trafficrules.name + ""));
											row.append($("<td>").text(trafficrules.protocol+ ""));
											row.append($("<td>").text(trafficrules.iface + ""));
											row.append($("<td>").text(trafficrules.ipAddress+ ""));
											row.append($("<td>").text(trafficrules.macAddress+ ""));
											row.append($("<td>").text(trafficrules.portNum + ""));
											row.append($("<td>").text(trafficrules.action + ""));
											row.append($("<td>").text(trafficrules.type + ""));

											var actions = $("<td>");

											var editButton = $(
													'<button data-toggle="tooltip" class="editBtn" data-placement="top" title="Edit" style="color: #35449a;">')
													.html('<i class="fas fa-edit"></i>')
													.click(
															function() {
																setName(trafficrules.name);
																setInterface(trafficrules.iface);
																setProtocol(trafficrules.protocol);
																setPortNumber(trafficrules.portNum);
																setMacAddress(trafficrules.macAddress);
																setIPAddress(trafficrules.ipAddress);
																setType(trafficrules.type);
																setAction(trafficrules.action);

															});

											var deleteButton = $(
													'<button data-toggle="tooltip" class="delBtn" data-placement="top" title="Delete" style="color: red">')
													.html('<i class="fas fa-trash-alt"></i>')
													.click(
															function() {
																
																deleteTrafficRules(trafficrules.name);
															});

											
											actions.append(editButton);
											actions.append(deleteButton);

											row.append(actions);

											trafficRulesTable.append(row);
										});
						}else if(roleValue == 'VIEWER' || roleValue == 'Viewer'){
							$.each(data,function(index, trafficrules) {
								var row = $("<tr>");
								row.append($("<td>").text(trafficrules.name + ""));
								row.append($("<td>").text(trafficrules.protocol+ ""));
								row.append($("<td>").text(trafficrules.iface + ""));
								row.append($("<td>").text(trafficrules.ipAddress+ ""));
								row.append($("<td>").text(trafficrules.macAddress+ ""));
								row.append($("<td>").text(trafficrules.portNum + ""));
								row.append($("<td>").text(trafficrules.action + ""));
								row.append($("<td>").text(trafficrules.type + ""));

								trafficRulesTable.append(row);
							});
						}
					},
					error : function(xhr, status, error) {
						console.log("Error loading traffic rules data: "
								+ error);
					},
				});
	}

	function addTrafficRules() {
		var name = $('#name').val();
		var iface = $('#iface').find(":selected").val();
		var portNumber = $('#portNumber').val();
		var macAddress = $('#macAddress').val();
		var protocol = $('#protocol').find(":selected").val();
		var ip_addr = $('#ip_addr').val();
		var type = $('#type').find(":selected").val();
		var action = $('#action').find(":selected").val();
		
	
		$.ajax({
			url : "trafficRulesServlet",
			type : "POST",
			data : {
				name : name,
				iface : iface,
				portNumber : portNumber,
				macAddress : macAddress,
				protocol : protocol,
				ip_addr : ip_addr,
				type : type,
				action : action,
				operation_action: 'add'
			},
			success : function(data) {
			
				// Display the custom popup message
     			$("#popupMessage").text(data.message);
      			$("#customPopup").show();

      			
				loadTrafficRulesList();

				// Clear form fields
				$('#name').val('');
				$('#iface').val('eth0');
				$('#portNumber').val('');
				$('#macAddress').val('');
				$('#protocol').val('TCP');
				$('#ip_addr').val('');
				$('#type').val('Select type');
				$('#action').val('ACCEPT');

				$('#ip_addr').prop('disabled', false);
				$('#macAddress').prop('disabled', false);
			},
			error : function(xhr, status, error) {
				console.log("Error adding traffic rules: " + error);
			},
		});
		
		$("#closePopup").click(function () {
		    $("#customPopup").hide();
		  });

		$("#registerBtn").val("Add");
	}
 
 function deleteTrafficRules(trafficRulesId) {
	 
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-delete');
	  modal.style.display = 'block';

	  // Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-delete');
	  confirmButton.onclick = function () {
		  
		  $.ajax({
			  url: 'trafficRulesServlet',
		      type: 'POST',
		      data: {
		    	  name : trafficRulesId,
					operation_action: 'delete'
		      },
		      success: function (data) {
   		        
		    	  // Close the modal
			        modal.style.display = 'none';

			        // Refresh the user list
			        loadTrafficRulesList();
			      },
			      error: function (xhr, status, error) {
			        // Handle the error response, if needed
			        console.log('Error deleting traffic rules: ' + error);
			        // Close the modal
			        modal.style.display = 'none';
			      }
			    });
		  
	  };
	  
	  // Handle the cancel button click
	  var cancelButton = document.getElementById('cancel-button-delete');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	  };
 }
 
	function applyTrafficRules() {

		$.ajax({
			url : "trafficRulesApplyServlet",
			type : "GET",
			dataType : "json",
			success : function(data) {

			// Display the custom popup message
     			$("#popupMessage").text(data.message);
      			$("#customPopup").show();
				loadTrafficRulesList();

			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log("Error applying traffic rules: " + error);
			},
		});
		$("#closePopup").click(function () {
		    $("#customPopup").hide();
		  });
	}
	
	function editTrafficRules() {
		// Display the custom modal dialog
		  var modal = document.getElementById('custom-modal-edit');
		  modal.style.display = 'block';
		  
		// Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-edit');
		  confirmButton.onclick = function () {
			  
			  var name = $('#name').val();
				var iface = $('#iface').find(":selected").val();
				var portNumber = $('#portNumber').val();
				var macAddress = $('#macAddress').val();
				var protocol = $('#protocol').find(":selected").val();
				var ip_addr = $('#ip_addr').val();
				var type = $('#type').find(":selected").val();
				var action = $('#action').find(":selected").val();
				
				if(type == 'IP'){
					
					$("#macAddress").prop("disabled", true);
				}else if(type == 'MAC'){
					
					$("#ip_addr").prop("disabled", true);
				}
				
				$.ajax({
					url : 'trafficRulesServlet',
					type : 'POST',
					data : {
						name : name,
						iface : iface,
						portNumber : portNumber,
						macAddress : macAddress,
						protocol : protocol,
						ip_addr : ip_addr,
						type : type,
						action : action,
						operation_action: 'update'
					},
					success : function(data) {
						// Close the modal
				        modal.style.display = 'none';
						
						loadTrafficRulesList();

						// Clear form fields
						$('#name').val('');
						$('#iface').val('eth0');
						$('#portNumber').val('');
						$('#macAddress').val('');
						$('#protocol').val('TCP');
						$('#ip_addr').val('');
						$('#type').val('Select type');
						$('#action').val('ACCEPT');

						$("#name").prop("disabled", false);
						$('#ip_addr').prop('disabled', false);
						$('#macAddress').prop('disabled', false);
					},
					error : function(xhr, status, error) {
						console.log('Error updating traffic rule: ' + error);
					}
				});
				$('#registerBtn').val('Add');
		  };
		  
		  var cancelButton = document.getElementById('cancel-button-edit');
		  cancelButton.onclick = function () {
		    // Close the modal
		    modal.style.display = 'none';
		    $('#registerBtn').val('Update');
		  };
	}
	

	function setName(trafficRulesId) {

		$('#name').val(trafficRulesId);
		$("#name").prop("disabled", true);
		$('#registerBtn').val('Update');

	}

	function setInterface(trafficRulesId) {

		$('#iface').val(trafficRulesId);
	}

	function setProtocol(trafficRulesId) {

		$('#protocol').val(trafficRulesId);
	}

	function setPortNumber(trafficRulesId) {

		$('#portNumber').val(trafficRulesId);
	}

	function setMacAddress(trafficRulesId) {
	$('#macAddress').val(trafficRulesId);

	}

	function setIPAddress(trafficRulesId) {

		$('#ip_addr').val(trafficRulesId);

	}

	function setType(trafficRulesId) {

		$('#type').val(trafficRulesId);
		
		if(trafficRulesId == 'IP'){
			
			$("#macAddress").prop("disabled", true);
		}else if(trafficRulesId == 'MAC'){
			
			$("#ip_addr").prop("disabled", true);
		}
	}

	function setAction(trafficRulesId) {

		$('#action').val(trafficRulesId);
	}

	function getGeneralSettings() {

		$.ajax({
			url : "generalSettingsServlet",
			type : "GET",
			dataType : "json",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
		    },
			success : function(data) {

				$('#input').val(data.input);
				$('#output').val(data.output);
				$('#forward').val(data.forword);
				$('#rule_drop').val(data.rule_drop);

				if ($('#input').val(data.input) != null) {
					$('#registerBtnGenSettings').val('Update');
				} else {
					$('#registerBtnGenSettings').val('Add');
				}

			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log("Error loading general Settings: " + error);
			},
		});

	}

	function addGeneralSettings() {

		var input = $('#input').val();
		var output = $('#output').val();
		var forward = $('#forward').val();
		var rule_drop = $('#rule_drop').val();

		$.ajax({
			url : 'generalSettingsServlet',
			type : 'POST',
			data : {
				input : input,
				output : output,
				forward : forward,
				rule_drop : rule_drop,
				operation_action: 'add'

			},
			success : function(data) {
				
				// Display the custom popup message
     			$("#popupMessage").text(data.message);
      			$("#customPopup").show();
      			
				getGeneralSettings()

				// Clear form fields

				$('#input').val('accept');
				$('#output').val('accept');
				$('#forward').val('accept');
				$('#rule_drop').val('on');

			},
			error : function(xhr, status, error) {
				console.log('Error adding general setting: ' + error);
			}
		});
		$("#closePopup").click(function () {
		    $("#customPopup").hide();
		  });

		$('#registerBtnGenSettings').val('Add');

	}

	function editGeneralSettings() {
		// Display the custom modal dialog
		  var modal = document.getElementById('custom-modal-edit-gen');
		  modal.style.display = 'block';
		  
		// Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-edit-gen');
		  confirmButton.onclick = function () {
			  
			  var input = $('#input').val();
				var output = $('#output').val();
				var forward = $('#forward').val();
				var rule_drop = $('#rule_drop').val();
				
				$.ajax({
					url : 'generalSettingsServlet',
					type : 'POST',
					data : {
						input : input,
						output : output,
						forward : forward,
						rule_drop : rule_drop,
						operation_action: 'update'

					},
					success : function(data) {
						// Close the modal
				        modal.style.display = 'none';
						getGeneralSettings()

						// Clear form fields

						$('#input').val('');
						$('#output').val('');
						$('#forward').val('');
						$('#rule_drop').val('');

					},
					error : function(xhr, status, error) {
						console.log('Error editing general setting: ' + error);
					}
				});
				$('#registerBtnGenSettings').val('Update');		
		  };
		  
		  var cancelButton = document.getElementById('cancel-button-edit-gen');
		  cancelButton.onclick = function () {
		    // Close the modal
		    modal.style.display = 'none';
		    $('#registerBtnGenSettings').val('Update');
		  };
	}
 
 function deleteGeneralSettings() {
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-delete-gen');
	  modal.style.display = 'block';

	  // Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-delete-gen');
	  confirmButton.onclick = function () {
		  
		  var input = $('#input').val();
			var output = $('#output').val();
			var forward = $('#forward').val();
			var rule_drop = $('#rule_drop').val();
			
			$.ajax({
				url : 'generalSettingsServlet',
				type : 'POST',
				data : {
					input : input,
					output : output,
					forward : forward,
					rule_drop : rule_drop,
					operation_action: 'delete'

				},
				success : function(data) {
					modal.style.display = 'none';
					getGeneralSettings()

					// Clear form fields

					$('#input').val('');
					$('#output').val('');
					$('#forward').val('');
					$('#rule_drop').val('');

				},
				error : function(xhr, status, error) {
					console.log('Error deleting general setting: ' + error);
				}
			});
		  
			$('#registerBtnGenSettings').val('Add');
	  };
	  
	  var cancelButton = document.getElementById('cancel-button-delete-gen');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	    $('#registerBtnGenSettings').val('Update');
	  };
 }
	
	function applyGeneralSettings() {
		var input = $('#input').val();
		var output = $('#output').val();
		var forward = $('#forward').val();
		var rule_drop = $('#rule_drop').val();

		$.ajax({
			url : 'generalSettingsApplyServlet',
			type : 'POST',
			data : {
				input : input,
				output : output,
				forward : forward,
				rule_drop : rule_drop

			},
			success : function(data) {
				
				// Display the custom popup message
     			$("#popupMessage").text(data.message);
      			$("#customPopup").show();

				getGeneralSettings()

				// Clear form fields

				$('#input').val('');
				$('#output').val('');
				$('#forward').val('');
				$('#rule_drop').val('');

			},
			error : function(xhr, status, error) {
				console.log('Error applying general setting: ' + error);
			}
		});
		$("#closePopup").click(function () {
		    $("#customPopup").hide();
		  });

	}

	function getBasicConfiguration(){
		
		$.ajax({
			url : "BasicConfigurationServlet",
			type : "GET",
			dataType : "json",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
		    },
		    success : function(data) {
				// Clear existing table rows

				var basicConfigTable = $("#basic-config-table tbody");
				basicConfigTable.empty();

				var json1 = JSON.stringify(data);

				var json = JSON.parse(json1);

				handleStatus(json.status);

					$.each(data,function(index, basicConfig) {
									var row = $("<tr>");
									
									// Add the data-basic-config-id attribute with the basicConfigId value
								    row.attr("data-basic-config-id", basicConfig.basicConfigId);

									
									row.append($("<td>").text(basicConfig.id));
									row.append($("<td>").append($("<input>").attr("type", "text").val(basicConfig.direction).prop("disabled", true)));
									row.append($("<td>").append($("<input>").attr("type", "text").val(basicConfig.lan_type).prop("disabled", true)));
									row.append($("<td>").append($("<input>").attr("type", "text").val(basicConfig.protocol).prop("disabled", true)));
									row.append($("<td>").append($("<input>").attr("type", "text").val(basicConfig.to_port).prop("disabled", true)));
									row.append($("<td>").append($("<input>").attr("type", "text").val(basicConfig.comment).prop("disabled", true)));
									
									// Assuming you have a table row (row) and a variable basicConfig with a property: action
									var actionOptions = ["ACCEPT", "REJECT", "DROP", "CONTINUE"];
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
	
	
	function changeButtonColor(isDisabled) {
        var $add_button_tr = $('#registerBtn');       
        var $clear_button_tr = $('#clearBtn');
        var $apply_button_tr = $('#applyBtnRules');
        var $add_button_gs = $('#registerBtnGenSettings');       
        var $delete_button_gs = $('#delBtnGenSettings');
        var $apply_button_gs = $('#applyBtnGenSettings');
        
        
         if (isDisabled) {
            $add_button_tr.css('background-color', 'gray'); // Change to your desired color
        } else {
            $add_button_tr.css('background-color', '#2b3991'); // Reset to original color
        }
        
        if (isDisabled) {
            $clear_button_tr.css('background-color', 'gray'); // Change to your desired color
        } else {
            $clear_button_tr.css('background-color', '#2b3991'); // Reset to original color
        } 
        
        if (isDisabled) {
            $apply_button_tr.css('background-color', 'gray'); // Change to your desired color
        } else {
            $apply_button_tr.css('background-color', '#2b3991'); // Reset to original color
        } 
        
        if (isDisabled) {
            $add_button_gs.css('background-color', 'gray'); // Change to your desired color
        } else {
            $add_button_gs.css('background-color', '#2b3991'); // Reset to original color
        }
        
        if (isDisabled) {
            $delete_button_gs.css('background-color', 'gray'); // Change to your desired color
        } else {
            $delete_button_gs.css('background-color', '#2b3991'); // Reset to original color
        } 
        
        if (isDisabled) {
            $apply_button_gs.css('background-color', 'gray'); // Change to your desired color
        } else {
            $apply_button_gs.css('background-color', '#2b3991'); // Reset to original color
        } 
        
    }
	
	function handleStatus(status) {
	    if (status === 'fail') {
	        var modal = document.getElementById('custom-modal-session-timeout');
	        modal.style.display = 'block';

	        // Handle the confirm button click
	        var confirmButton = document.getElementById('confirm-button-session-timeout');
	        confirmButton.onclick = function () {
	            // Close the modal
	            modal.style.display = 'none';
	            window.location.href = 'login.jsp';
	        };
	    }
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

        var tabButtons = document.getElementsByClassName("tab-button");
        for (var i = 0; i < tabButtons.length; i++) {
            tabButtons[i].classList.remove("active");
        }

        if (button) {
            button.classList.add("active");
        }
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

	
	//Function to execute on page load
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
		    	
		// Load traffic rules list
		loadTrafficRulesList();
		
		
		
		if (roleValue == 'VIEWER' || roleValue == 'Viewer') {

			 $("#actions").hide();
			$('#registerBtn').prop('disabled', true);
			$('#clearBtn').prop('disabled', true);
			$('#applyBtnRules').prop('disabled', true);
			$('#registerBtnGenSettings').prop('disabled', true);
			$('#delBtnGenSettings').prop('disabled', true);
			$('#applyBtnGenSettings').prop('disabled', true);

			changeButtonColor(true);
		}
		
		getGeneralSettings();

		 $("#type").change(function(event) {

			if ($(this).val() == 'ip' || $(this).val() == 'IP') {
				 
				$("#macAddress").prop("disabled", true);
				$("#macAddress").val('');
				
				var isDisabled = $('#ip_addr').prop('disabled');
				 
				 if(isDisabled){
					 $("#ip_addr").prop("disabled", false);
				 }
				
			} else if ($(this).val() == 'mac' || $(this).val() == 'MAC') {
				$("#ip_addr").prop("disabled", true);
				$("#ip_addr").val('');
				
				var isDisabled = $('#macAddress').prop('disabled');
				 
				 if(isDisabled){
					 $("#macAddress").prop("disabled", false);
				 }
			}
		}); 

		$('#applyBtnRules').click(function() {
			applyTrafficRules();

		});

		$('#applyBtnGenSettings').click(function() {
			applyGeneralSettings();

		});

		$("#delBtnGenSettings").click(function() {
			deleteGeneralSettings();
		});
		
		
		
		$("#applyBtnBasicConf").click(function() {
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
		

		$('#generalSettingsForm').submit(function(event) {
			event.preventDefault();
			var buttonText = $('#registerBtnGenSettings').val();

			if (buttonText == 'Add') {
				addGeneralSettings();
			} else {
				editGeneralSettings();
			}
		});

		// Handle form submission
		$("#trafficRulesForm").submit(function(event) {
			event.preventDefault();
			var buttonText = $("#registerBtn").val();
			
			var name = $('#name').val();
			var macAddress = $('#macAddress').val();
			var ip_addr = $('#ip_addr').val();
			var portNumber = $('#portNumber').val();
			
			if((name.length > 30)){

				nameError.textContent = "You can write upto 30 maximum characters."
                	return;
            }

            else{

            	nameError.textContent =""

            }  
			
			if((macAddress.length > 30)){

				macAddrError.textContent = "You can write upto 30 maximum characters."
                	return;
            }

            else{

            	macAddrError.textContent =""

            }  
            
            if((ip_addr.length > 30)){

            	sourceIpError.textContent = "You can write upto 30 maximum characters."
                	return;
            }

            else{

            	sourceIpError.textContent =""

            }  
            
           if((portNumber.length > 30)){

        	   destPortError.textContent = "You can write upto 30 maximum characters."
                	return;
            }

            else{

            	destPortError.textContent =""

            }  
            
            
			if (buttonText == "Add") {
				addTrafficRules();
			} else {
				editTrafficRules();
			}
		});

		$('#clearBtn').click(function() {
			$('#name').val('');
			$('#iface').val('eth0');
			$('#portNumber').val('');
			$('#macAddress').val('');
			$('#protocol').val('TCP');
			$('#ip_addr').val('');
			$('#type').val('Select type');
			$('#action').val('ACCEPT');
			 $('#registerBtn').val('Add');
			$('#ip_addr').prop('disabled', false);
			$('#macAddress').prop('disabled', false);

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

		<div class="form-container">
			<form id="generalSettingsForm" style="width: 100%;">
			<input type="hidden" id="operation_action" name="operation_action" value="">

				<table>
				<tr>
				
				<td>Input</td>
				<td><select class="textBox" id="input" name="input" style="height: 33px; width: 120px; ">
							<option value="Accept">Accept</option>
							<option value="Reject">Reject</option>
						</select> <span id="inputError" style="color: red;"></span></td>
				
				<td>Output</td>
				<td>
				<select class="textBox" id="output" name="output" style="height: 33px; width: 120px;">
							<option value="Accept">Accept</option>
							<option value="Reject">Reject</option>
						</select> <span id="outputError" style="color: red;"></span>
				</td>
				</tr>
				
				<tr>
				<td>Forward</td>
				<td> <select class="textBox" id="forward" name="forward" style="height: 33px; width: 120px;">
							<option value="Accept">Accept</option>
							<option value="Reject">Reject</option>
						</select> <span id="forwardError" style="color: red;"></span></td>
				
				<td>Drop invalid packets</td>
				<td><select class="textBox" id="rule_drop" name="rule_drop" style="height: 33px; width: 120px;">
							<option value="On">On</option>
							<option value="Off">Off</option>
						</select> <span id="forwardError" style="color: red;"></span></td>
				</tr>
				</table>


				<div class="row"
					style="display: flex; justify-content: center; margin-top: 1%;">
					<input type="button" value="Apply" id="applyBtnGenSettings" /> 
					<input type="submit" value="Add" id="registerBtnGenSettings" style="margin-left: 5px;" /> 
					<input type="button" value="Delete" id="delBtnGenSettings" style="margin-left: 5px;" />
				</div>

			</form>
		</div>
		
		<div id="custom-modal-delete-gen" class="modal-delete-gen">
				<div class="modal-content-delete-gen">
				  <p>Are you sure you want to delete this general setting?</p>
				  <button id="confirm-button-delete-gen">Yes</button>
				  <button id="cancel-button-delete-gen">No</button>
				</div>
			  </div>
			  
			  <div id="custom-modal-edit-gen" class="modal-edit-gen">
				<div class="modal-content-edit-gen">
				  <p>Are you sure you want to modify this general setting?</p>
				  <button id="confirm-button-edit-gen">Yes</button>
				  <button id="cancel-button-edit-gen">No</button>
				</div>
			  </div>
			  
		<h3>CONFIGURATION</h3>
		<hr /> 
		<div class="container">
		
		<div class="tab-container">
    <button class="tab-button active" onclick="openTab('basic-config', this)">Basic Configuration</button>
    <button class="tab-button" onclick="openTab('user-config', this)">User Configuration</button>

    <div id="basic-config" class="tab" style="display: block;">
        <div class="container">
        
       
       <table id="basic-config-table" style="margin-left: -15px; width: 102.2%;">
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
						<!-- User list table rows will be populated dynamically using JavaScript -->
					</tbody>
  
        
        </table>
        
        
        
        <div class="row"
					style="display: flex; justify-content: right; margin-top: 2%;">
					<input type="button" value="Apply" id="applyBtnBasicConf" /> 
					
				</div>
				
        </div>
        
         <div id="custom-modal-edit-basic-conf" class="modal-edit-basic-conf">
				<div class="modal-content-edit-basic-conf">
				  <p>Are you sure you want to modify the basic configuration?</p>
				  <button id="confirm-button-edit-basic-conf">Yes</button>
				  <button id="cancel-button-edit-basic-conf">No</button>
				</div>
			  </div>
    </div>


    <div id="user-config" class="tab">
    <h3 style="margin-top: 15px;">ADD TRAFFIC RULES</h3>
    <hr/>
        <div class="form-container">
        <form id="trafficRulesForm">
			<input type="hidden" id="operation_action" name="operation_action" value="">
			
			<table class="bordered-table" style="margin-top: -1px;">
			
			<tr>
			<td>Name</td>
			<td><input type="text" id="name" name="name" maxlength="31" style="height: 10px;"/>
						<p id="nameError" style="color: red;"></p></td>
			<td>Interface</td>
			<td><select class="textBox" id="iface" name="iface"
							style="height: 33px;">
							<option value="Select interface">Select interface</option>	
							<option value="lan0">lan0</option>
							<option value="lan1">lan1</option>
							<option value="lan2">lan2</option>
						</select></td>
			
			<td>Type</td>
			<td><select class="textBox" id="type" name="type"
							style="height: 33px;">
							<option value="Select type">Select type</option>
							<option value="IP">IP</option>
							<option value="MAC">MAC</option>
						</select></td>
			<td>Source MAC address</td>
			<td><input type="text" id="macAddress" name="macAddress" maxlength="31" style="height: 10px;"/>
							<p id="macAddrError" style="color: red;"></p></td>
			</tr>
			
			<tr>
			<td>Protocol</td>
			<td><select class="textBox" id="protocol" name="protocol" style="height: 33px;">
							<option value="Select protocol">Select protocol</option>
							<option value="TCP" selected="selected">TCP</option>
							<option value="UDP">UDP</option>
						</select></td>
			<td>Source IP address</td>
			<td><input type="text" id="ip_addr" name="ip_addr" maxlength="31"/>
							<p id="sourceIpError" style="color: red;"></p></td>
			
			<td>Port</td>
			<td><input type="text" id="portNumber" name="portNumber" maxlength="6"/>
							<p id="destPortError" style="color: red;"></p></td>
			<td>Action</td>
			<td><select class="textBox" id="action" name="action" style="height: 33px;">
							<option value="ACCEPT">ACCEPT</option>
							<option value="REJECT">REJECT</option>
						</select></td>
			</tr>
				
				</table>
				
				<div class="row" style="display: flex; justify-content: center; margin-top: 1%;">
					<input type="button" value="Apply" id="applyBtnRules" /> 
					<input style="margin-left: 5px;" type="button" value="Clear" id="clearBtn" /> 
					<input style="margin-left: 5px;" type="submit" value="Add" id="registerBtn" />
				</div>
			</form>
        
        </div>
        
    <div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to modify this traffic rule?</p>
				  <button id="confirm-button-edit">Yes</button>
				  <button id="cancel-button-edit">No</button>
				</div>
		 </div>
		 
		 <div id="custom-modal-session-timeout" class="modal-session-timeout">
				<div class="modal-content-session-timeout">
				  <p>Your session is timeout. Please login again</p>
				  <button id="confirm-button-session-timeout">OK</button>
				</div>
		 </div>
		 
		  <div id="customPopup" class="popup">
  				<span class="popup-content" id="popupMessage"></span>
  				<button id="closePopup">OK</button>
			  </div>
			  
			  <h3 style="margin-top: 15px;">TRAFFIC RULES LIST</h3>
		<hr>
		<div class="table-container">
			<table id="trafficRulesListTable" style="margin-left: -15px; width: 102.2%;">
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
						<th id="actions">Actions</th>
					</tr>
				</thead>
				<tbody>
					
				</tbody>
			</table>
		</div>
			  
        
    </div>
</div>
		</div>
		
		</section>
	</div>
<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>