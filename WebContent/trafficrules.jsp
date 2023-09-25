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

#confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
}
</style>
<script>

var roleValue; 
var tokenValue;

	function loadTrafficRulesList() {
		$
				.ajax({
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
													'<button data-toggle="tooltip" class="delBtn" data-placement="top" title="Delete"style="color: red">')
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
				// Display the registration status message
				alert(data.message);
				loadTrafficRulesList();

				// Clear form fields
				$('#name').val('');
				$('#iface').val('eth0');
				$('#portNumber').val('');
				$('#macAddress').val('');
				$('#protocol').val('tcp');
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

		$("#registerBtn").val("Add");
	}
	
	function deleteTrafficRules(trafficRulesId) {
		  // Display the custom modal dialog
		  var modal = document.getElementById('custom-modal-delete');
		  modal.style.display = 'block';

		  // Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-delete');
		  confirmButton.onclick = function () {
		    // Make the AJAX call to delete the user
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

				alert(data.message);
				loadTrafficRulesList();

			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log("Error applying traffic rules: " + error);
			},
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
				
				if(type == 'ip'){
					
					$("#macAddress").prop("disabled", true);
				}else if(type == 'mac'){
					
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
						$('#protocol').val('tcp');
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
		    $('#registerBtn').val('Edit');
		  };
	}
	

	function setName(trafficRulesId) {

		$('#name').val(trafficRulesId);
		$("#name").prop("disabled", true);
		$('#registerBtn').val('Edit');

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
		
		if(trafficRulesId == 'ip'){
			
			$("#macAddress").prop("disabled", true);
		}else if(trafficRulesId == 'mac'){
			
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
					$('#registerBtnGenSettings').val('Edit');
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
				// Display the registration status message
				alert(data.message);
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
				$('#registerBtnGenSettings').val('Edit');		
		  };
		  
		  var cancelButton = document.getElementById('cancel-button-edit-gen');
		  cancelButton.onclick = function () {
		    // Close the modal
		    modal.style.display = 'none';
		    $('#registerBtnGenSettings').val('Edit');
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
					// Display the registration status message
					alert(data.message);
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
	    $('#registerBtnGenSettings').val('Edit');
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
				// Display the registration status message
				alert(data.message);
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
			//     alert("You have Selected  :: "+$(this).val());

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
			$('#protocol').val('tcp');
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

		<div class="container">
			<form id="generalSettingsForm">
			<input type="hidden" id="operation_action" name="operation_action" value="">

				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: -25px;">

					<div class="col-75-2" style="width: 10%; text-align: left;">
						<label>Input</label> <select class="textBox" id="input"
							name="input" style="height: 35px;">
							<option value="Accept">Accept</option>
							<option value="Reject">Reject</option>
						</select> <span id="inputError" style="color: red;"></span>
					</div>
					<div class="col-75-2" style="width: 10%; text-align: left;">
						<label>Output</label> <select class="textBox" id="output"
							name="output" style="height: 35px;">
							<option value="Accept">Accept</option>
							<option value="Reject">Reject</option>
						</select> <span id="outputError" style="color: red;"></span>
					</div>
					<div class="col-75-2" style="width: 10%; text-align: left;">
						<label>Forward</label> <select class="textBox" id="forward"
							name="forward" style="height: 35px;">
							<option value="Accept">Accept</option>
							<option value="Reject">Reject</option>
						</select> <span id="forwardError" style="color: red;"></span>
					</div>
					<div class="col-75-2" style="width: 10%; text-align: left;">
						<label>Drop invalid packets</label> <select class="textBox"
							id="rule_drop" name="rule_drop" style="height: 35px;">
							<option value="On">On</option>
							<option value="Off">Off</option>
						</select> <span id="forwardError" style="color: red;"></span>
					</div>
				</div>


				<div class="row"
					style="display: flex; justify-content: right; margin-top: -1%;">
					<input type="button" value="Apply" id="applyBtnGenSettings" /> 
					<input type="submit" value="Add" id="registerBtnGenSettings"
						style="margin-left: 5px;" /> 
						<input type="button" value="Delete"
						id="delBtnGenSettings" style="margin-left: 5px;" />
				</div>

			</form>
		</div>
		
		<div id="custom-modal-delete-gen" class="modal-delete-gen">
				<div class="modal-content-delete-gen">
				  <p>Are you sure you want to delete this general setting?</p>
				  <button id="confirm-button-delete">Yes</button>
				  <button id="cancel-button-delete">No</button>
				</div>
			  </div>
			  
			  <div id="custom-modal-edit-gen" class="modal-edit-gen">
				<div class="modal-content-edit-gen">
				  <p>Are you sure you want to edit this general setting?</p>
				  <button id="confirm-button-edit-gen">Yes</button>
				  <button id="cancel-button-edit-gen">No</button>
				</div>
			  </div>
			  

		<h3>TRAFFIC RULES</h3>
		<hr>
		<div class="container">

			<form id="trafficRulesForm">
			<input type="hidden" id="action" name="action" value="">

				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: 10px;">

					<div class="col-75-5" style="width: 15%;">
						<input type="text" id="name" name="name" placeholder="Name" maxlength="31"/>
						<p id="nameError" style="color: red;"></p>
					</div>

					<div class="col-75-4" style="width: 10%;">
						
						<select class="textBox" id="iface" name="iface"
							style="height: 35px;">
							<option value="Select interface">Select interface</option>
							<option value="eth0">eth0</option>
							<option value="eth1">eth1</option>
							<option value="lan1">lan1</option>
							<option value="lan2">lan2</option>

						</select>

					</div>

					<div class="col-75-2" style="width: 10%;">
						<select class="textBox" id="type" name="type"
							style="height: 35px;">
							<option value="Select type">Select type</option>
							<option value="ip">ip</option>
							<option value="mac">mac</option>

						</select>
					</div>

					<div class="col-75-1" style="width: 15%;">
						<input type="text" id="macAddress" name="macAddress"
							placeholder="Source MAC address" maxlength="31"/>
							<p id="macAddrError" style="color: red;"></p>
					</div>

					<div class="col-75-2" style="width: 10%;">
						<select class="textBox" id="protocol" name="protocol"
							style="height: 35px;">
							<option value="Select protocol">Select protocol</option>
							<option value="tcp">tcp</option>
							<option value="udp">udp</option>

						</select>
					</div>
					
					<div class="col-75-3" style="width: 15%;">
						<input type="text" id="ip_addr" name="ip_addr"
							placeholder="Source IP address" maxlength="31"/>
							<p id="sourceIpError" style="color: red;"></p>
					</div>

					<div class="col-75-1" style="width: 10%;">
						<input type="text" id="portNumber" name="portNumber"
							placeholder="Destination Port" maxlength="6"/>
							<p id="destPortError" style="color: red;"></p>
					</div>
					
					<div class="col-75-2" style="width: 10%;">
						<select class="textBox" id="action" name="action"
							style="height: 35px;">
							<option value="ACCEPT">ACCEPT</option>
							<option value="REJECT">REJECT</option>

						</select>
					</div>
				</div>

				
				<div class="row"
					style="display: flex; justify-content: right; margin-top: 2%;">
					<input type="button" value="Apply" id="applyBtnRules" /> 
					<input style="margin-left: 5px;" type="button" value="Clear" id="clearBtn" /> 
					<input style="margin-left: 5px;" type="submit" value="Add" id="registerBtn" />
				</div>
			</form>
		</div>
		
		<div id="custom-modal-delete" class="modal-delete">
				<div class="modal-content-delete">
				  <p>Are you sure you want to delete this traffic rule?</p>
				  <button id="confirm-button-delete">Yes</button>
				  <button id="cancel-button-delete">No</button>
				</div>
		</div>
			  
		 <div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to edit this traffic rule?</p>
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


		<h3>TRAFFIC RULES LIST</h3>
		<hr>
		<div class="container">
			<table id="trafficRulesListTable">
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
					<!-- User list table rows will be populated dynamically using JavaScript -->
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