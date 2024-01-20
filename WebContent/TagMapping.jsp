<%  
    // Add X-Frame-Options header to prevent clickjacking
    response.setHeader("X-Frame-Options", "DENY");
%>

<!DOCTYPE html>
<html>
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png" />
<link rel="stylesheet" href="css_files/ionicons.min.css">
<link rel="stylesheet" href="css_files/normalize.min.css">
<link rel="stylesheet" href="css_files/fonts.txt" type="text/css">	
<link rel="stylesheet" href="nav-bar.css" />
<link rel="stylesheet" href="css_files/all.min.css">
<link rel="stylesheet" href="css_files/fontawesome.min.css">
<script src="jquery-3.6.0.min.js"></script>
<script src="xlsx.full.min.js"></script>


<style>
.modal-delete,
.modal-edit,
.modal-session-timeout  {
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

/* Style for buttons */
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
    width: 40%;
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

</style>

<script>
	// Function to load user data and populate the user list table

	var roleValue;	
	var tokenValue;
	var csrfTokenValue;
	var existingData = [];
	//var nodeid;
	
	

	function loadTagList() {
		
		
	//	var pv_address = $('#pv_address').val(nodeid);
	//	$("#pv_address").prop("disabled", true);
	
	// Display loader when the request is initiated
	    showLoader();
	    var csrfToken = document.getElementById('csrfToken').value;
		$.ajax({
					url : 'tagMapping',
					type : 'GET',
					dataType : 'json',
					data: {
						csrfToken: csrfToken
			        },
					beforeSend: function(xhr) {
				        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
				    },
					success : function(data) {
						// Hide loader when the response has arrived
			            hideLoader();
						
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
						
						
						// Clear existing table rows
						var tagTable = $('#tagListTable tbody');
						tagTable.empty();
						
						
						if(roleValue == 'Admin' || roleValue == 'ADMIN'){
														
							data.result.forEach(function(tag) {
								var tag_name = tag.tag_name; 
								var pv_address = tag.pv_address; 
								
								var row = $("<tr>").append($("<td>").text(tag_name),									
										$("<td>").text(pv_address));
								
								var actions = $('<td>')
								
								var editButton = $(
										'<button data-toggle="tooltip" class="editBtn" data-placement="top" title="Edit" style="color: #35449a;">')
										.html('<i class="fas fa-edit"></i>')
										.click(
												function() {
													
													setTagName(tag.tag_name);
													setPVAddress(tag.pv_address);
													
												});
								var deleteButton = $(
										'<button data-toggle="tooltip" class="delBtn" data-placement="top" title="Delete" style="color: red">')
										.html('<i class="fas fa-trash-alt"></i>')
										.click(
												function() {
												
												deleteTag(tag.tag_name);
													
												});
								
								actions.append(editButton);
								actions.append(deleteButton);
								row.append(actions);
									
								tagTable.append(row);
								
							});
							
						}else if(roleValue == 'OPERATOR' || roleValue == 'Operator'){
							data.result.forEach(function(tag) {
								
								var tag_name = tag.tag_name; 
								var pv_address = tag.pv_address; 
								
								var row = $("<tr>").append($("<td>").text(tag_name),									
										$("<td>").text(pv_address));
								
								tagTable.append(row);
							});
						}
										},
					error : function(xhr, status, error) {
						// Hide loader when the response has arrived
			            hideLoader();
						
					}
				});
	}

	function setTagName(tagId) {

		$('#tag_name').val(tagId);
	}

	function setPVAddress(tagId) {

		$('#pv_address').val(tagId);
		$('#registerBtn').val('Update');
	}

	
	function deleteTag(tag_name) {
		 var csrfToken = document.getElementById('csrfToken').value;
		 
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
						csrfToken: csrfToken,
						action: 'delete'
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
						
						modal.style.display = 'none';
						loadTagList();
						
						 location.reload();
					},
					error : function(xhr, status, error) {
						
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
	 var csrfToken = document.getElementById('csrfToken').value;
	 
	    $.ajax({
	        url: 'ExportExcelServlet',
	        type: 'GET',
	        dataType: 'json',
	        data: {
				csrfToken: csrfToken
	        },
	        beforeSend: function (xhr) {
	            xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
	        },
	        success: function (data) {
	        	
	        	if (data && data.length > 0) {
	                exportToExcel(data);
	            } else {
	            	
	            	$("#popupMessage").text('No data to export.');
	      			$("#customPopup").show();
	      			
	                
	            }
	        },
	        error: function (xhr, status, error) {
	            
	        }
	    });
	    
	    $("#closePopup").click(function () {
		    $("#customPopup").hide();
		  });
	}
 
	function exportToExcel(data) {
     var excelData = [];
     // Iterate through the data and push to excelData array
     data.forEach(function (tag) {
         var rowData = [tag.tag_name, tag.pv_address];
         
         excelData.push(rowData);
     });

     // Create a new workbook and add a worksheet
     var ws = XLSX.utils.aoa_to_sheet([['Tag Name', 'PV Address']].concat(excelData));
     var wb = XLSX.utils.book_new();
     XLSX.utils.book_append_sheet(wb, ws, 'TAG Mapping List');

     // Save the workbook to an Excel file
     XLSX.writeFile(wb, 'tag_mapping_list.xlsx');
 }

 
 function editTag(){
	 	  
	  var tag_name = $('#tag_name').val();
		var pv_address = $('#pv_address').val();
		 var csrfToken = document.getElementById('csrfToken').value;
		
		$('#field_tag_Error').text('');
	    $('#field_pv_Error').text('');
	    
	    // Validate username
	    var tagnameError = validateTagName(tag_name);
	    if (tagnameError) {
	        $('#field_tag_Error').text(tagnameError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }

	    // Validate first name
	    var pvError = validatePVaddr(pv_address);
	    if (pvError) {
	        $('#field_pv_Error').text(pvError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }
	    
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-edit');
	  modal.style.display = 'block';
	  
	// Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-edit');
	  confirmButton.onclick = function () {
	
						
			$.ajax({
				url : 'tagMapping',
				type : 'POST',
				data : {
					tag_name : tag_name,
					pv_address : pv_address,
					csrfToken: csrfToken,
					action: 'update'

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
					
				    loadTagList();

					// Clear form fields
					$('#tag_name').val('');
					$('#pv_address').val('');
				},
				error : function(xhr, status, error) {
					
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
 
 
//Validation for username
	function validatePVaddr(pv) {
	    var regex = /^[a-zA-Z][a-zA-Z0-9.$_-]*$/;

	    if (!regex.test(pv)) {
	        return 'Invalid PV address; the allowed symbols are $_-';
	    }

	    return null; // Validation passed
	}

	// Validation for first name
	function validateTagName(tagName) {
 var regex = /^[a-zA-Z][a-zA-Z0-9]*$/;

 if (!regex.test(tagName)) {
     return 'Invalid tag name; symbols not allowed';
 }

 return null; // Validation passed
}
 
	// Function to handle form submission and add a new tag
	function addTag() {		
		
		var tag_name = $('#tag_name').val();
		var pv_address = $('#pv_address').val();
		 var csrfToken = document.getElementById('csrfToken').value;
		
		$('#field_tag_Error').text('');
	    $('#field_pv_Error').text('');
	    
	    // Validate username
	    var tagnameError = validateTagName(tag_name);
	    if (tagnameError) {
	        $('#field_tag_Error').text(tagnameError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }

	    // Validate first name
	    var pvError = validatePVaddr(pv_address);
	    if (pvError) {
	        $('#field_pv_Error').text(pvError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
	        return;
	    }
	
		$.ajax({
			url : 'tagMapping',
			type : 'POST',
			data : {
				tag_name : tag_name,
				pv_address : pv_address,
				csrfToken: csrfToken,
				action: 'add'
				
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
				
				// Display the custom popup message
     			$("#popupMessage").text(data.message);
      			$("#customPopup").show();

      
      			loadTagList();

				// Clear form fields

				$('#tag_name').val('');
				$('#pv_address').val('');
				
			},
			error : function(xhr, status, error) {
				
			}
		});
		$("#closePopup").click(function () {
		    $("#customPopup").hide();
		  });

		$('#registerBtn').val('Add');
	}
	
	function changeButtonColor(isDisabled) {
        var $add_button = $('#registerBtn');       
        var $clear_button = $('#clearBtn');
        var $exportButton = $('#exportButton'); 
        var $processExcel = $('#processExcel'); 
        
        
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
        
        if (isDisabled) {
            $exportButton.css('background-color', 'gray'); // Change to your desired color
        } else {
            $exportButton.css('background-color', '#2b3991'); // Reset to original color
        } 
        
        
        if (isDisabled) {
            $processExcel.css('background-color', 'gray'); // Change to your desired color
        } else {
            $processExcel.css('background-color', '#2b3991'); // Reset to original color
        } 
        
    }
	function processExcel() {
	    var fileInput = document.getElementById('fileInput');
	    var file = fileInput.files[0];

	    var reader = new FileReader();

	    reader.onload = function(e) {
	        var data = new Uint8Array(e.target.result);
	        var workbook = XLSX.read(data, { type: 'array' });

	        workbook.SheetNames.forEach(function(sheetName) {
	            var excelData = XLSX.utils.sheet_to_json(workbook.Sheets[sheetName]);

	            var dataArray = excelData.map(function(row) {
	                return {
	                    tag_name: row['Tag Name'],
	                    pv_address: row['PV Address']
	                };
	            });

	            // Format dataArray according to your desired structure
	            var formattedDataArray = dataArray.map(function(item) {
	                return {
	                    tag_name: item.tag_name,
	                    pv_address: item.pv_address
	                };
	            });	            
	            formattedDataArray.forEach(function(obj) {
	               
	            });
	           
	            addNewTag(formattedDataArray);
	        });
	    };

	    if (file) {
	        reader.readAsArrayBuffer(file);
	    }
	}

		
	function addNewTag(dataArray) {
		 var csrfToken = document.getElementById('csrfToken').value;
	    $.ajax({
	        url: 'tagMapping',
	        type: 'POST',
	        data: {
	            bulk_data: JSON.stringify(dataArray), // Pass the array directly
	            csrfToken: csrfToken,
	            action: 'add_bulk'
	        },
	        traditional: true, // Use traditional serialization to handle arrays
	        success: function(data) {
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
	        	
	        	$("#popupMessage").text(data.message);
      			$("#customPopup").show();
      			loadTagList();      			
	        },
	        error: function(xhr, status, error) {
	          
	        }	        
	    });

	    $("#closePopup").click(function() {
	        $("#customPopup").hide();
	    });

	    $('#registerBtn').val('Add');
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
	
	// Function to execute on page load
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

							$('#registerBtn').prop('disabled', true);
							$('#clearBtn').prop('disabled', true);
							$('#exportButton').prop('disabled', true);
							$('#processExcel').prop('disabled', true);
														
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

					    	loadTagList();
					    	
					    	// Handle form submission
							$('#tagForm').submit(function(event) {
												event.preventDefault();
												var buttonText = $('#registerBtn').val();
												
												var tag_name = $('#tag_name').val();										
											    var pv_address = $('#pv_address').val();							
											    if (buttonText == 'Add') {
													addTag();
												} else {
													editTag();
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
							
							$('#processExcel').click(function() {
								processExcel();
							});
					    	
					    }

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
				<form id="tagForm">

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
					<td>Tag Name</td>
					<td style="height: 50px; width: 230px;">
					<input type="text" id="tag_name" maxlength="31" name="tag_name" required style="width: 200px;"/>
					<span id="field_tag_Error" class="error-message" style="display: block; margin-top: 5px;"></span>
							
					</td>	
					
					<td>PV address</td>
					<td><input type="text" id="pv_address" name="pv_address" maxlength="31" required style="width: 200px;"/> 
				<span id="field_pv_Error" class="error-message" style="display: block; margin-top: 5px;"></span>
					
					</tr>
					
					</table>
					
					<div class="row" style="display: flex; justify-content: center; margin-bottom: 2%; margin-top: 1%;">			
						<input style="height: 26px;" type="button" value="Clear" id="clearBtn" /> 
						<input style="margin-left: 5px; height: 26px;" type="submit" value="Add" id="registerBtn" />
						<input style="margin-left: 5px; height: 26px;" type="button" value="Export Data" id="exportButton" />
					</div>
					<div>
					<input type="file" id="fileInput" accept=".xlsx, .xls" />
					<input type="button" value="Process Excel" id="processExcel">
					</div>
					
				</form>
					   		
    		
			</div>
			
			<div id="custom-modal-delete" class="modal-delete">
				<div class="modal-content-delete">
				  <p>Are you sure you want to delete this tag?</p>
				  <button id="confirm-button-delete">Yes</button>
				  <button id="cancel-button-delete">No</button>
				</div>
			  </div>
			  
			  <div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to modify this tag?</p>
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

			<h3 style="margin-top: 15px;">TAG MAPPING LIST</h3>
			<hr>
			<div class="table-container">
				<table id="tagListTable">
					<thead>
						<tr>
							<th>Tag Name</th>
							<th>PV address</th>						
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