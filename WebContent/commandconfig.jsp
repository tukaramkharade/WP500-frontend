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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
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

#confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
}

h3{
margin-top: 68px;
}

</style>
<script>

var roleValue;
var tokenValue;

var json = {};
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
	
	 function loadTagList() {
 	    $.ajax({
 	      url: "alarmConfigTagListServlet",
 	      type: "GET",
 	      dataType: "json",
 	      success: function (data) {
 	        if (data.tag_list_result && Array.isArray(data.tag_list_result)) {
 	          var datalist = $("#variable");
 	          // Clear any existing options
 	         // datalist.empty();

 	          // Loop through the data and add options to the datalist
 	          data.tag_list_result.forEach(function (tag) {
 	            var option = $("<option>", {
 	              value: tag,
 	              text: tag,
 	            });
 	            datalist.append(option);
 	          });
 	        }
 	      },
 	      error: function (xhr, status, error) {
 	        console.log("Error showing tag list: " + error);
 	      },
 	    });
 	  } 
 
 function loadCommandSettings() {
		$.ajax({
			url : 'commandConfigServlet',
			type : 'GET',
			dataType : 'json',
			beforeSend: function(xhr) {
		        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
		    },
			success : function(data) {
				
				var json1 = JSON.stringify(data);

						var json = JSON.parse(json1);

						if (json.status == 'fail') {
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
						
				
									var unit_id = $('#unit_id').val(data.unit_id);
									var asset_id = $('#asset_id').val(data.asset_id);
									var broker_type = $('#broker_type').val(data.broker_type);
									var broker_ip = $('#broker_name').val(data.broker_ip);
									var interval = $('#interval').val(data.interval);
									
									var result = data.command_tag;
								
									if(roleValue == 'ADMIN' || roleValue == 'Admin'){
										
										$.each($.parseJSON(result), function(k, v) {
									
														    
														    var newRow = $("<tr>")
						    	        					.append($("<td>").text(k))
						    	        					.append($("<td>").text(v))
						    	        					.append(
					 	          $("<td>").html(
					 	            `<input
					 	                style="background-color :red"
					 	                type="button"
					 	                value="Delete"
					 	                onclick="deleteRow(this)"
					 	                addClass="tagDelBtn"
					 	              />`
					 	          )
					 	        );
															
						    	        					$("#table_data").append(newRow);
														});
														
										
									 }
								  else if(roleValue == 'VIEWER' || roleValue == 'Viewer'){
										
										$.each($.parseJSON(result), function(k, v) {
										
														    
														    var newRow = $("<tr>")
						    	        					.append($("<td>").text(k))
						    	        					.append($("<td>").text(v))
						    	        					
						    	        					$("#table_data").append(newRow);
														});
														
									}   

									if(unit_id != null){
										$('#addBtn').val('Edit');
									}
									else{
										$('#addBtn').val('Add');
									}
								
			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error: ' + error);
			}
		});
	
	} 
	    	
	       	function deleteCommand(){
	       	// Display the custom modal dialog
	   		  var modal = document.getElementById('custom-modal-delete');
	   		  modal.style.display = 'block';

	   		  // Handle the confirm button click
	   		  var confirmButton = document.getElementById('confirm-button-delete');
	   		  confirmButton.onclick = function () {
	   		    // Make the AJAX call to delete the user
	   		    $.ajax({
	   		      url: 'commandConfigServlet',
	   		      type: 'DELETE',
	   		     dataType : 'json',
	   		      success: function (data) {
	   		    	  
	   		        // Close the modal
	   		        modal.style.display = 'none';

	   		        // Refresh the user list
	   		       loadCommandSettings();
	   		      },
	   		      error: function (xhr, status, error) {
	   		        // Handle the error response, if needed
	   		        console.log('Error deleting command settings: ' + error);
	   		        // Close the modal
	   		        modal.style.display = 'none';
	   		      }
	   		    });
	   		    
	   		 $('#addBtn').val('Add');
	   		  };

	   		  // Handle the cancel button click
	   		  var cancelButton = document.getElementById('cancel-button-delete');
	   		  cancelButton.onclick = function () {
	   		    // Close the modal
	   		    modal.style.display = 'none';
	   		 $('#addBtn').val('Edit');
	   		  };
	       	}
	       	
	       	
	    	
	    	function validatefields(tag_name) {
	       		var tagnameError = document.getElementById("tagnameError");

	       		if (tag_name === "") {
	       			tagnameError.textContent = "Please enter tag name";
	       			return false;
	       		} else {
	       			tagnameError.textContent = "";
	       			return true;
	       		}
	       	}

	       	function validateOption(variable) {
	       		var variableError = document.getElementById("variableError");

	       		if (variable === "") {
	       			variableError.textContent = "Please select variable";
	       			return false;
	       		} else {
	       			variableError.textContent = "";
	       			return true;
	       		}
	       	}
	       	
	       	
	       	function validateInterval(interval) {
	    		var intervalError = document.getElementById("intervalError");

	    		if (interval == 'Select interval'){
	    			
	    			intervalError.textContent = "Please select interval";
	    			return false;
	    		} else {
	    			intervalError.textContent = "";
	    			return true;
	    		}
	    	}
	    	
	    	function validateBrokerType(broker_type) {
	    		var brokerTypeError = document.getElementById("brokerTypeError");

	    		if (broker_type == 'Select broker type'){
	    			
	    			brokerTypeError.textContent = "Please select broker type";
	    			return false;
	    		} else {
	    			brokerTypeError.textContent = "";
	    			return true;
	    		}
	    	}
	    	
	    	function validateBrokerIPAddress(broker_name) {
	    		var brokerIPAddressError = document.getElementById("brokerIPAddressError");

	    		if (broker_name == 'Select broker IP address'){
	    			
	    			brokerIPAddressError.textContent = "Please select broker ip address";
	    			return false;
	    		} else {
	    			brokerIPAddressError.textContent = "";
	    			return true;
	    		}
	    	}
	    	
	    	function changeButtonColor(isDisabled) {
	            var $add_button = $('#addBtn');
	            var $delete_button = $('#delBtn');
	            var $clear_button = $('#clearBtn');
	            var $save_button = $('#saveBtn');
	           
	            
	            if (isDisabled) {
	                $add_button.css('background-color', 'gray'); // Change to your desired color
	            } else {
	                $add_button.css('background-color', '#2b3991'); // Reset to original color
	            }
	            
	            if (isDisabled) {
	                $delete_button.css('background-color', 'gray'); // Change to your desired color
	            } else {
	                $delete_button.css('background-color', '#2b3991'); // Reset to original color
	            }
	            
	            if (isDisabled) {
	                $clear_button.css('background-color', 'gray'); // Change to your desired color
	            } else {
	                $clear_button.css('background-color', '#2b3991'); // Reset to original color
	            }
	            
	            if (isDisabled) {
	                $save_button.css('background-color', 'gray'); // Change to your desired color
	            } else {
	                $save_button.css('background-color', '#2b3991'); // Reset to original color
	            }
	             
	    	}
	    	
	    	 $(document).ready(function () {
	    		 
	    		 <%
	    	    	// Access the session variable
	    	    	HttpSession role = request.getSession();
	    	    	String roleValue = (String) session.getAttribute("role");
	    	    	%>
	    	    	
	    	    	roleValue = '<%= roleValue %>'; // This will insert the session value into the JavaScript code
	    	    	
	    	    	<%// Access the session variable
	    	    	HttpSession token = request.getSession();
	    	    	String tokenValue = (String) session.getAttribute("token");%>

	    	    	tokenValue = '<%=tokenValue%>';
	    	      
	    		 
	       	  // Load broker ip
	      	   loadCommandSettings();
	       	  
	      	 if(roleValue == 'VIEWER' || roleValue == 'Viewer'){
	    		  
	    		  $("#actions").hide(); 
	    		  $('#addBtn').prop('disabled', true);
	    		  $('#clearBtn').prop('disabled', true); 
	    		  $('#delBtn').prop('disabled', true);
	    		  $('#saveBtn').prop('disabled', true);
	    		 
	    		  changeButtonColor(true);
	    	  }
	       	  
	       	  loadBrokerIPList();
	       	  loadTagList();
	       	  
	       	  
	       	  $("#saveBtn").click(function () {
	       	    var tagName = $("#tag_name").val();
	       	    var value = $("#variable").val();

	       	    // Check if tagName and value are not empty
	       	    if (tagName.trim() !== "" && value.trim() !== "") {
	       	      var newRow = $("<tr>")
	       	        .append($("<td>").text(tagName))
	       	        .append($("<td>").text(value))
	       	        .append(
	       	          $("<td>").html(
	       	            `<input
	       	                style="background-color :red"
	       	                type="button"
	       	                value="Delete"
	       	                onclick="deleteRow(this)"
	       	              />`
	       	          )
	       	        );

	       	      $("#table_data").append(newRow);
	       	      $("#tag_name").val("");
	       	      $("#variable").val("");
	       	    }
	       	    
	       	     else  if (!validatefields(tagName)) {
					tagnameError.textContent = "Please enter tag name.";
					return;
				}
	    	    else if (!validateOption(value)) {
					variableError.textContent = "Please select variable.";
					return;
				} 
	       	    
	       	  });
	       	  
	       	     	  
	       	     	$('#commandConfigForm').submit(function(event) {
	       				event.preventDefault();
	       				var buttonText = $('#addBtn').val();
	       				
	       				var interval = $('#interval').find(":selected").val();
	       				var broker_type = $('#broker_type').find(":selected").val();
	       				var broker_name = $('#broker_name').find(":selected").val();
	       				var unit_id = $('#unit_id').val();
	       				var asset_id = $('#asset_id').val();
	       				var tag_name = $('#tag_name').val();
	       				
	       				
	       				if ((unit_id.length > 30)) {
	       					unitid_error.textContent = "You can write upto 30 maximum characters."
	       				}
	       				else {
	       					unitid_error.textContent = ""
	       				}

	       				if ((asset_id.length > 30)) {
	       					assetid_error.textContent = "You can write upto 30 maximum characters."
	       				} else {
	       					assetid_error.textContent = ""
	       				}

	       				if ((tag_name.length > 30)) {
	       					tagname_error.textContent = "You can write upto 30 maximum characters."
	       				}
	       				else {
	       					tagname_error.textContent = ""
	       				}
	       				
	       				if (!validateInterval(interval)) {
	       					intervalError.textContent = "Please select interval";
	       					return;
	       				}
	       				
	       				if (!validateBrokerType(broker_type)) {
	       					brokerTypeError.textContent = "Please select broker type";
	       					return;
	       				}
	       				
	       				if (!validateBrokerIPAddress(broker_name)) {
	       					brokerIPAddressError.textContent = "Please select broker ip address ";
	       					return;
	       				}

	       				if (buttonText == 'Add') {
	       					addCommandConfig();
	       				} else {
	       					editCommandConfig();
	       				}
	       			});
	       	  
	       	 $('#clearBtn').click(function(){
	    		  $('#unit_id').val('');
	  			$('#asset_id').val('');
	  			$('#broker_type').val('Select broker type');
	  			$('#broker_name').val('Select broker IP address');
	  			$('#interval').val('Select interval');	  
	  			$('#addBtn').val('Add'); 
	    	});
	       	 
	       	$("#delBtn").click(function () {
	       		deleteCommand();
	    	  });
	       	});
	
	    	function deleteRow(button) {
	    		var confirmation = confirm('Are you sure you want to delete this tag?');
	    		if (confirmation) {
	    	  $(button).closest("tr").remove();
	    		}
	    	}


		function tableToJson() {
				 const table = document.getElementById("table_data");
			// 	 const json = {};

			  for (var i = 1; i < table.rows.length; i++) {
			    const row = table.rows[i];
			    const tag = row.cells[0].textContent;
			    const variable = row.cells[1].textContent;
			    json[tag] = variable;
			    console.log(json);
			    
			  }

			  return json;
			}
				
		
		function editCommandConfig() {
			// Display the custom modal dialog
			  var modal = document.getElementById('custom-modal-edit');
			  modal.style.display = 'block';
			  
			// Handle the confirm button click
			  var confirmButton = document.getElementById('confirm-button-edit');
			  confirmButton.onclick = function () {

					var tagData = tableToJson();
					var unit_id = $('#unit_id').val();
				    var asset_id = $('#asset_id').val();
				    var broker_type = $('#broker_type').find(":selected").val();
				    var broker_name = $('#broker_name').find(":selected").val();
				    var interval = $('#interval').find(":selected").val();
				   
				    $.ajax({
						url : 'commandConfigServlet',
						type : 'POST',
						data : {
							unit_id : unit_id,
							asset_id : asset_id,
							broker_type : broker_type,
							broker_name : broker_name,
							interval : interval,
							tagData: JSON.stringify(tagData),
							action: 'update'
							
						},
						success : function(data) {
							modal.style.display = 'none';

							// Clear form fields
							$('#unit_id').val('');
							$('#asset_id').val('');
							$('#broker_type').val('Select broker type');
							$('#broker_name').val('Select broker IP address');
							$('#interval').val('Select interval');
							
							location.reload();
						},
						error : function(xhr, status, error) {
							console.log('Error updating command settings: ' + error);
						}
					});
				    
				    $('#addBtn').val('Add');
			  };
			  
			  var cancelButton = document.getElementById('cancel-button-edit');
			  cancelButton.onclick = function () {
			    // Close the modal
			    modal.style.display = 'none';
			    $('#addBtn').val('Edit');
			  };

		}
		
		function addCommandConfig() {

			var tagData = tableToJson();
		
		    var unit_id = $('#unit_id').val();
		    var asset_id = $('#asset_id').val();
		    var broker_type = $('#broker_type').find(":selected").val();
		    var broker_name = $('#broker_name').find(":selected").val();
		    var interval = $('#interval').find(":selected").val();
		   
			$.ajax({
				url : 'commandConfigServlet',
				type : 'POST',
				data : {
					unit_id : unit_id,
					asset_id : asset_id,
					broker_type : broker_type,
					broker_name : broker_name,
					interval : interval,
					tagData: JSON.stringify(tagData),
					action: 'add'
					
				},
				success : function(data) {
					// Display the custom popup message
	     			$("#popupMessage").text(data.message);
	      			$("#customPopup").show();
	      			
					// Clear form fields

					$('#unit_id').val('');
					$('#asset_id').val('');
					$('#broker_type').val('Select broker type');
					$('#broker_name').val('Select broker IP address');
					$('#interval').val('Select interval');
					
					location.reload();
					
				},
				error : function(xhr, status, error) {
					console.log('Error adding command config settings: ' + error);
				}
			});
			$("#closePopup").click(function () {
			    $("#customPopup").hide();
			  });

			$('#addBtn').val('Add');
		}
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
		<h3>COMMAND CONFIG SETTINGS</h3>
		<hr>
		<div class="container">
			<form id="commandConfigForm">
			
			<input type="hidden" id="action" name="action" value="">
				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: -20px;">
					<div class="col-75-1" style="width: 15%;">
						<input type="text" id="unit_id" name="unit_id"
							placeholder="Unit ID" required style="height: 17px" maxlength="31"/>
							<p id="unitid_error" style="color: red;"></p>
					</div>
					
					<div class="col-75-2" style="width: 15%;">
						<input type="text" id="asset_id" name="asset_id"
							placeholder="Asset ID" required style="height: 17px" maxlength="31"/>
							<p id="assetid_error" style="color: red;"></p>
					</div>
					
					<div class="col-75-3" style="width: 15%;">
						<select class="textBox" id="broker_type" name="broker_type"
							style="height: 35px">
							<option value="Select broker type">Select broker type</option>
							<option value="mqtt">mqtt</option>
							<option value="iothub">iothub</option>
						</select> <span id="brokerTypeError" style="color: red;"></span>
					</div>
					
					<div class="col-75-4" style="width: 15%;">
						<select class="textBox" id="broker_name" name="broker_name"
							style="height: 35px">
							<option value="Select broker IP address">Select broker
								IP address</option>
						</select> <span id="brokerIPAddressError" style="color: red;"></span>
					</div>
					
					<div class="col-75-5" style="width: 10%;">
						<select class="interval-select" id="interval" name="interval"
							style="height: 35px">
							<option value="Select interval">Select interval</option>
							<option value="5 sec">5 sec</option>
							<option value="10 sec">10 sec</option>
							<option value="15 sec">15 sec</option>
							<option value="20 sec">20 sec</option>
							<option value="25 sec">25 sec</option>
							<option value="30 sec">30 sec</option>
							<option value="1 min">1 min</option>
							<option value="5 min">5 min</option>
							<option value="10 min">10 min</option>
							<option value="15 min">15 min</option>
							<option value="20 min">20 min</option>
							<option value="25 min">25 min</option>
							<option value="30 min">30 min</option>
							<option value="1 hour">1 hour</option>
						</select> <span id="intervalError" style="color: red;"></span>
					</div>
				</div>

				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: 10px;">
					<div class="col-75-6" style="width: 15%;">
						<input type="text" id="tag_name" name="tag_name"
							placeholder="Tag name" style="height: 17px" maxlength="31"/> <span
							id="tagnameError" style="color: red;"></span>
							<p id="tagname_error" style="color: red;"></p>
					</div>

					<div class="col-75-7" style="width: 15%;">
						<select class="textBox" id="variable" name="variable"
							style="height: 35px">
							<option value="Select variable">Select variable</option>
						</select> <span id="variableError" style="color: red;"></span>
					</div>
				</div>

				<div class="row">

					<input style="margin-top: -31px; margin-left: 10%;" type="button"
						value="+" id="saveBtn" />

				</div>

				<div class="row" style="display: flex; justify-content: right;">
					<input style="margin-top: -31px; margin-left: 5px" type="button"
						value="Clear" id="clearBtn"/> <input
						style="margin-top: -31px; margin-left: 5px" type="submit"
						value="Add" id="addBtn" /> <input
						style="margin-top: -31px; margin-left: 5px" type="button"
						value="Delete" id="delBtn" onClick="window.location.reload();" />
				</div>

			</form>
		</div>
		
		<div id="custom-modal-delete" class="modal-delete">
				<div class="modal-content-delete">
				  <p>Are you sure you want to delete this command setting?</p>
				  <button id="confirm-button-delete">Yes</button>
				  <button id="cancel-button-delete">No</button>
				</div>
			  </div>
			  
			  <div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to edit this command setting?</p>
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
			  
			  <hr />
		</section>
		
		<section style="margin-left: 1em">
		<div class="container">
			<table id="table_data">
				<tr>
					<th>Tag Name</th>
					<th>Variable</th>
					<th id="actions">Action</th>
				</tr>
			</table>
		</div>
		</section>
	</div>
	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>