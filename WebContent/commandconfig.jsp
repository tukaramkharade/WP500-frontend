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

#confirm-button-delete,
 #confirm-button-session-timeout,
 #confirm-button-edit{
  background-color: #4caf50;
  color: white;
}

#cancel-button-delete,
#cancel-button-edit {
  background-color: #f44336;
  color: white;
}

h3{
margin-top: 68px;
}

.bordered-table {
  border-collapse: collapse; /* Optional: To collapse table borders */
  margin: 0 auto; /* Center the table horizontally */
}

.bordered-table td {
  border: 1px solid #ccc; /* Light gray border */
  text-align: center;
   vertical-align: middle;
}

   .form-container {
    margin: 0 auto;
    width: 50%;
    border-collapse: collapse;
    background-color: #f2f2f2;
     border-radius: 5px;
  padding: 20px;
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
				
									var unit_id = $('#unit_id').val(data.unit_id);
									var asset_id = $('#asset_id').val(data.asset_id);							
									var broker_ip = $('#broker_name').val(data.broker_ip);
									
									if(data.broker_type != null && data.interval != null){
										var broker_type = $('#broker_type').val(data.broker_type);
										var interval = $('#interval').val(data.interval);
									}else{
										var brokerTypeSelect = $('#broker_type');
										var intervalSelect = $('#interval');

										// Set default values for broker type and interval
										brokerTypeSelect.text(data.broker_type);
										intervalSelect.text(data.interval);
									}
									
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
								  else if(roleValue == 'OPERATOR' || roleValue == 'Operator'){
										
										$.each($.parseJSON(result), function(k, v) {
										
														    
														    var newRow = $("<tr>")
						    	        					.append($("<td>").text(k))
						    	        					.append($("<td>").text(v))
						    	        					
						    	        					$("#table_data").append(newRow);
														});
														
									}   

									if(unit_id != null){
										$('#addBtn').val('Update');
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
	   		        location.reload();
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
	   		 $('#addBtn').val('Update');
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
	    	    	
	    	    	
	      	 if(roleValue == 'OPERATOR' || roleValue == 'Operator'){
	    		  
	    		  $("#actions").hide(); 
	    		  $('#addBtn').prop('disabled', true);
	    		  $('#clearBtn').prop('disabled', true); 
	    		  $('#delBtn').prop('disabled', true);
	    		  $('#saveBtn').prop('disabled', true);
	    		 
	    		  changeButtonColor(true);
	    	  }
	      	 
	      	if (roleValue === "null") {
		        var modal = document.getElementById('custom-modal-session-timeout');
		        modal.style.display = 'block';

		        // Handle the confirm button click
		        var confirmButton = document.getElementById('confirm-button-session-timeout');
		        confirmButton.onclick = function() {
		            // Close the modal
		            modal.style.display = 'none';
		            window.location.href = 'login.jsp';
		        };
		    } else{
		    	<%// Access the session variable
    	    	HttpSession token = request.getSession();
    	    	String tokenValue = (String) session.getAttribute("token");%>

    	    	tokenValue = '<%=tokenValue%>';
    	
      	   loadCommandSettings();
      	   
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
      				
      				if (buttonText == 'Add') {
      					addCommandConfig();
      				} else {
      					editCommandConfig();
      				}
      			});
      	  
      	 $('#clearBtn').click(function(){
   		  $('#unit_id').val('');
 			$('#asset_id').val('');
 			$('#broker_type').val('mqtt');
 			$('#broker_name').val('Select broker IP address');
 			$('#interval').val('5 sec');	  
 			$('#addBtn').val('Add'); 
   	});
      	 
      	$("#delBtn").click(function () {
      		deleteCommand();
   	  });
       	  
		    }
	       	  
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
			 var broker_name = $('#broker_name').find(":selected").val();
			 var errorSpanStatus = $('#brokerIPAddressError'); // Assuming you have a <span> element for error messages
			  
				// Check if the selected status is "Select status"
				    if (broker_name === "Select broker IP address") {
				        // Display an error message and prevent saving
				        errorSpanStatus.text("Please select a valid IP address.");
				        return;
				    }

				    // Clear any previous error messages
				    errorSpanStatus.text("");
			
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
							$('#broker_type').val('mqtt');
							$('#broker_name').val('Select broker IP address');
							$('#interval').val('5 sec');
							
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
			    $('#addBtn').val('Update');
			  };

		}
		
		function addCommandConfig() {

			var tagData = tableToJson();
		
		    var unit_id = $('#unit_id').val();
		    var asset_id = $('#asset_id').val();
		    var broker_type = $('#broker_type').find(":selected").val();
		    var broker_name = $('#broker_name').find(":selected").val();
		    var interval = $('#interval').find(":selected").val();
		    
		    
		    var errorSpanStatus = $('#brokerIPAddressError'); // Assuming you have a <span> element for error messages
			  
			// Check if the selected status is "Select status"
			    if (broker_name === "Select broker IP address") {
			        // Display an error message and prevent saving
			        errorSpanStatus.text("Please select a valid IP address.");
			        return;
			    }

			    // Clear any previous error messages
			    errorSpanStatus.text("");
		   
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
					$('#broker_type').val('mqtt');
					$('#broker_name').val('Select broker IP address');
					$('#interval').val('5 sec');
					
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
		<hr />

		<div class="form-container">
			<form id="commandConfigForm">
			
			<input type="hidden" id="action" name="action" value="">
			
			<table class="bordered-table" style="margin-top: -1px;">
			
			<tr>
			<td>Unit ID</td>
			<td style="padding: 5px;"><input type="text" id="unit_id" name="unit_id" required style="height: 10px; " maxlength="31"/>
							<p id="unitid_error" style="color: red;"></p></td>
			<td>Asset ID</td>
			<td><input type="text" id="asset_id" name="asset_id" required style="height: 10px" maxlength="31"/>
							<p id="assetid_error" style="color: red;"></p></td>
			</tr>
			
			<tr>
			<td>Broker type</td>
			<td><select class="textBox" id="broker_type" name="broker_type" style="height: 33px">
							
							<option value="mqtt" selected>mqtt</option>
							<option value="iothub">iothub</option>
						</select> 
						</td>
						
			<td>Broker IP address</td>
			<td><select class="textBox" id="broker_name" name="broker_name"
							style="height: 33px">
							<option value="Select broker IP address">Select broker
								IP address</option>
							
						</select>
						 <span id="brokerIPAddressError" style="color: red;"></span></td>
			</tr>
			
			<tr>
			<td>Interval</td>
			<td><select class="interval-select" id="interval" name="interval"
							style="height: 33px">
							
							<option value="5 sec" selected>5 sec</option>
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
							</select>
							</td>
						
			<td></td>
			<td></td>
			
			</tr>
			
			</table>
			
			<div class="row" style="display: flex; justify-content: center; margin-bottom: 2%; margin-top: 1%;">
					
					<input style="height: 26px;" type="button" value="Clear" id="clearBtn"/> 
						<input style="margin-left: 5px; height: 26px;" type="submit" value="Add" id="addBtn" /> 
						<input style="margin-left: 5px; height: 26px;" type="button" value="Delete" id="delBtn" />
						
					</div>
					
			<table class="bordered-table">
			
			 <tr>
			<td>Tag name</td>
			<td><input type="text" id="tag_name" name="tag_name" style="height: 10px" maxlength="31"/> 
					<span id="tagnameError" style="color: red;"></span>
					<p id="tagname_error" style="color: red;"></p></td>
			<td>Variable</td>
			<td><select class="textBox" id="variable" name="variable" style="height: 33px">
							<option value="Select variable">Select variable</option>
						</select> <span id="variableError" style="color: red;"></span></td>
						
						<td><input type="button" value="+" id="saveBtn" style="height: 26px; margin-left: 5%;" /></td>
			</tr> 
				
				</table>
					
			</form>
		</div>
		
		<div id="custom-modal-delete" class="modal-delete">
				<div class="modal-content-delete">
				  <p>Are you sure you want to delete this alarm setting?</p>
				  <button id="confirm-button-delete">Yes</button>
				  <button id="cancel-button-delete">No</button>
				</div>
			  </div>
			  
			  <div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to modify this alarm setting?</p>
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