<!DOCTYPE html>
<html>
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
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.0/xlsx.full.min.js"></script>
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
  
  #confirm-button-session-timeout {
  background-color: #4caf50;
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

.note {
    color: red;
    margin-top: 5%; 
}

h3{
margin-top: 70px;
}

.container {
    margin: 0 auto;
    width: 80%;
  }

 .bordered-table {
  border-collapse: collapse; /* Optional: To collapse table borders */
  margin: 0 auto; /* Center the table horizontally */
}

.bordered-table td {
  border: 1px solid #ccc; /* Light gray border */
}


</style>

<script>
	// Function to load user data and populate the user list table

	var roleValue;	
	var tokenValue;
	
	

	function loadMqttList() {
		
		$.ajax({
					url : 'tagMapping',
					type : 'GET',
					dataType : 'json',
					beforeSend: function(xhr) {
				        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
				    },
					success : function(data) {
						// Clear existing table rows
						var mqttTable = $('#mqttListTable tbody');
						mqttTable.empty();
						
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

						// Iterate through the user data and add rows to the table
						
						
						if(roleValue == 'Admin' || roleValue == 'ADMIN'){
							$.each(data,function(index, mqtt) {
								var row = $('<tr>');
								row.append($('<td>').text(mqtt.tag_name+ ""));
								row.append($('<td>').text(mqtt.pv_address + ""));							
																
								var actions = $('<td>')
								
								var editButton = $(
										'<button data-toggle="tooltip" class="editBtn" data-placement="top" title="Edit" style="color: #35449a;">')
										.html('<i class="fas fa-edit"></i>')
										.click(
												function() {
													setMqtt(mqtt.prefix);
													setBrokerIPAddress(mqtt.tag_name);
													setPortNumber(mqtt.pv_address);
													
												});
								var deleteButton = $(
										'<button data-toggle="tooltip" class="delBtn" data-placement="top" title="Delete" style="color: red">')
										.html('<i class="fas fa-trash-alt"></i>')
										.click(
												function() {
												
												deleteMqtt(mqtt.tag_name);
													
												});
								
								actions.append(editButton);
								actions.append(deleteButton);
								row.append(actions);
									
								mqttTable.append(row);

							});
							
						}else if(roleValue == 'VIEWER' || roleValue == 'Viewer'){
							$.each(data,function(index, mqtt) {
								var row = $('<tr>');
								row.append($('<td>').text(mqtt.tag_name+ ""));
								row.append($('<td>').text(mqtt.pv_address + ""));							
																
								var actions = $('<td>')
								
								
								var getStatusButton = $(
										'<button data-toggle="tooltip" class="statusBtn" data-placement="top" title="Get Status" style="color: #35449a;">')
										.html('<i class="fas fa-info-circle"></i>')
										.click(
												function() {
													getMqttStatus(mqtt.tag_name);
												});

															actions.append(getStatusButton);

								row.append(actions);
									
								mqttTable.append(row);

							});
						}
										},
					error : function(xhr, status, error) {
						console.log('Error loading mqtt data: ' + error);
					}
				});
	}


	function setMqtt(mqttId) {
		// Make an AJAX GET request to retrieve user details for editing

		$('#prefix').val(mqttId);
		$("#prefix").prop("disabled", true);
		$('#registerBtn').val('Update');
	}

	function setBrokerIPAddress(mqttId) {

		$('#tag_name').val(mqttId);
	}

	function setPortNumber(mqttId) {

		$('#pv_address').val(mqttId);
	}

	

	 
	function deleteMqtt(tag_name) {
		// Display the custom modal dialog
		  var modal = document.getElementById('custom-modal-delete');
		  modal.style.display = 'block';

		  // Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-delete');
		  confirmButton.onclick = function () {
			  $.ajax({
					url : 'tagMapping',
					type : 'POST',
					data : {
						tag_name : tag_name,
						action: 'delete'
					},
					success : function(data) {
						
						modal.style.display = 'none';
						loadMqttList();
					},
					error : function(xhr, status, error) {
						// Handle the error response, if needed
						console.log('Error deleting mqtt settings: ' + error);
					}
				});
			  
		  };
		  
		  var cancelButton = document.getElementById('cancel-button-delete');
		  cancelButton.onclick = function () {
		    // Close the modal
		    modal.style.display = 'none';
		  };
		  
	}
	
	function fetchDataAndExportToExcel() {
	    $.ajax({
	        url: 'tagMapping',
	        type: 'GET',
	        dataType: 'json',
	        beforeSend: function (xhr) {
	            xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
	        },
	        success: function (data) {
	        	
	        	if (data && data.length > 0) {
	                exportToExcel(data);
	            } else {
	                console.error('No data to export.');
	            }
	        },
	        error: function (xhr, status, error) {
	            console.log('Error loading mqtt data: ' + error);
	        }
	    });
	}
	function exportToExcel(data) {
        var excelData = [];
        // Iterate through the data and push to excelData array
        data.forEach(function (mqtt) {
            var rowData = [mqtt.tag_name, mqtt.pv_address];
            excelData.push(rowData);
        });

        // Create a new workbook and add a worksheet
        var ws = XLSX.utils.aoa_to_sheet([['Tag Name', 'PV Address']].concat(excelData));
        var wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws, 'TAG Mapping List');

        // Save the workbook to an Excel file
        XLSX.writeFile(wb, 'tag_mapping_list.xlsx');
    }

 
 function editMqtt(){
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-edit');
	  modal.style.display = 'block';
	  
	// Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-edit');
	  confirmButton.onclick = function () {
		  
		  var tag_name = $('#tag_name').val();
			var pv_address = $('#pv_address').val();
						
			$.ajax({
				url : 'tagMapping',
				type : 'POST',
				data : {
					tag_name : tag_name,
					pv_address : pv_address,
					action: 'update'

				},
				success : function(data) {
					
					// Close the modal
				    modal.style.display = 'none';
					
					loadMqttList();

					// Clear form fields
					$('#tag_name').val('');
					$('#pv_address').val('');
				},
				error : function(xhr, status, error) {
					console.log('Error updating mqtt: ' + error);
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
 
	// Function to handle form submission and add a new mqtt
	function addMqtt() {
		
		var tag_name = $('#tag_name').val();
		var pv_address = $('#pv_address').val();
	
		$.ajax({
			url : 'tagMapping',
			type : 'POST',
			data : {
				tag_name : tag_name,
				pv_address : pv_address,
				action: 'add'
				
			},
			success : function(data) {
				
				// Display the custom popup message
     			$("#popupMessage").text(data.message);
      			$("#customPopup").show();

      
				loadMqttList();

				// Clear form fields

				$('#tag_name').val('');
				$('#pv_address').val('');
				
			},
			error : function(xhr, status, error) {
				console.log('Error adding mqtt settings: ' + error);
			}
		});
		$("#closePopup").click(function () {
		    $("#customPopup").hide();
		  });

		$('#registerBtn').val('Add');
	}	
	
		
	//change color of disabled buttons
	
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
	
	 function redirectToMQTT() {
	        window.location.href = 'mqtt.jsp';
	    }

	// Function to execute on page load
	$(document).ready(function() {
						
			<%// Access the session variable
			HttpSession role = request.getSession();
			String roleValue = (String) session.getAttribute("role");%>
    	
    	roleValue = '<%=roleValue%>';

						<%// Access the session variable
	HttpSession token = request.getSession();
	String tokenValue = (String) session.getAttribute("token");%>

	tokenValue = '<%=tokenValue%>';

						loadMqttList();
						
						
						if (roleValue == 'VIEWER' || roleValue == 'Viewer') {

							$('#registerBtn').prop('disabled', true);
							$('#clearBtn').prop('disabled', true);
							$('#crtFileInput').prop('disabled', true); 
							
							changeButtonColor(true);
						}										

						// Handle form submission
						$('#mqttForm').submit(function(event) {
											event.preventDefault();
											var buttonText = $('#registerBtn').val();
											
											var tag_name = $('#tag_name').val();										
										    var pv_address = $('#pv_address').val();							
										    if (buttonText == 'Add') {
												addMqtt();
											} else {
												editMqtt();
											}									
										});
						

						$('#clearBtn').click(function() {
							$('#tag_name').val('');
							$('#pv_address').val('');
							$('#registerBtn').val('Add');
						});
						$('#exportButton').on('click', function() {							
						    fetchDataAndExportToExcel();
						});

					});
</script>

<body>

	<div class="sidebar">
		<%@ include file="common.jsp"%>
	</div>
	<div class="header">
		<%@ include file="header.jsp"%>
	</div>
	<div class="content">
		<section style="margin-left: 1em">
			<h3>ADD TAG</h3>
			<hr>

			<div class="container">
				<form id="mqttForm">

					<input type="hidden" id="action" name="action" value="">
					<table class="bordered-table" style="margin-top: -1px;">

					<tr>
					<td>Tag Name</td>
					<td><input type="text" id="tag_name" maxlength="31" name="tag_name" required />
							<p id="broker_ip_error" style="color: red;"></p>
					</td>	
					
					</tr>
					<tr>
					<td>PV address</td>
					<td><input type="text" id="pv_address" name="pv_address" maxlength="31" required /> <span style="color: red; font-size: 12px;"
								id="portNoError"></span>
							<p id="pv_address_error" style="color: red;"></p></td>
					</tr>
					
					<!-- <tr>
					<td>Publishing format</td>
					<td><input type="text" id="publishing_format" name="publishing_format" maxlength="31" placeholder="Publishing format" required /></td>
					<td></td>
					<td></td>
					</tr> -->
								
					</table>
					
					<div class="row" style="display: flex; justify-content: center; margin-bottom: 2%; margin-top: 1%;">			
						<input style="height: 26px;" type="button" value="Clear" id="clearBtn" /> 
						<input style="margin-left: 5px; height: 26px;" type="submit" value="Add" id="registerBtn" />
						<input style="margin-left: 5px; height: 26px;" type="submit" value="Export Data" id="exportButton" />
					</div>
					
				</form>
					   		
    		
			</div>
			
			<div id="custom-modal-delete" class="modal-delete">
				<div class="modal-content-delete">
				  <p>Are you sure you want to delete this mqtt setting?</p>
				  <button id="confirm-button-delete">Yes</button>
				  <button id="cancel-button-delete">No</button>
				</div>
			  </div>
			  
			  <div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to modify this mqtt setting?</p>
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

			<h3 style="margin-top: 15px;">TAG MAPPING LIST</h3>
			<hr>
			<div class="table-container">
				<table id="mqttListTable">
					<thead>
						<tr>
							<th>Tag Name</th>
							<th>Pv address</th>						
							<th> Actions</th>
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