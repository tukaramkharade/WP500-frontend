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

.bordered-table, .bordered-table1 {
  border-collapse: collapse; /* Optional: To collapse table borders */
  margin: 0 auto; /* Center the table horizontally */
}

.bordered-table td, .bordered-table1 td{
  border: 1px solid #ccc; /* Light gray border */
 
}

   .form-container {
    margin: 0 auto;
    width: 50%;
    border-collapse: collapse;
    background-color: #f2f2f2;
     border-radius: 5px;
  padding: 20px;
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
var csrfTokenValue;

var json = {};
//Global variable to store tag name and variable values
var tagVariableValues = {};

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
				
			},
		});
	}
	
	 function loadTagList() {
		 var csrfToken = document.getElementById('csrfToken').value;
 	    $.ajax({
 	      url: "alarmConfigTagListServlet",
 	      type: "GET",
 	      dataType: "json",
 	     data: {
				csrfToken: csrfToken
	        },
 	      success: function (data) {
 	        if (data.tag_list_result && Array.isArray(data.tag_list_result)) {
 	          var datalist = $(".variable");
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
 	       
 	      },
 	    });
 	  } 
 
 function loadCommandSettings() {
	 
	// Display loader when the request is initiated
	    showLoader();
	
	    var csrfToken = document.getElementById('csrfToken').value;
	 
		$.ajax({
			url : 'commandConfigServlet',
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
				
				var interval = data.intervalString;
				
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
  				
  				var result = data.result;
  				
  	            var commandTag = JSON.parse(result.command_tag);
  	           
  	            
  	          initializeTable(commandTag);
  	        
  	            
  	          $('#unit_id').val(result.unit_id);
              $('#asset_id').val(result.asset_id);
              $('#broker_name').val(result.broker_ip);
              $('#status').val(result.command_status);

              if (result.broker_type != null && result.intrval != null) {
                  // If broker_type and intrval are present, set their values
                  $('#broker_type').val(result.broker_type);
                  $('#interval').val(interval);
              } else {
                  // If broker_type or intrval is null, set default values
                  $('#broker_type').val('defaultBrokerType');
                  $('#interval').val('defaultInterval');
              }
				
									if (result.unit_id != null) {
						                $('#addBtn').val('Update');
						            } else {
						                $('#addBtn').val('Add');
						            }
									
			},
			error : function(xhr, status, error) {
				// Hide loader when the response has arrived
	            hideLoader();
			}
		});
	
	} 
 
  
  function initializeTable(commandTag) {
	    var table = $('.bordered-table1');

	    // Empty the existing table content
	    table.empty();

	    // Create the initial row with input fields
	    var initialRow = $('<tr>');
	  
	    var cell1 = $('<th>').text('Tag List').css('width', '20%');
	    var cell2 = $('<th>').text('Variable').css('width', '20%');
	    var cell3 = $('<th>').text('Action').css('width', '10%');

	    initialRow.append(cell1, cell2, cell3);
	    table.append(initialRow);

	    // Create the initial data row with input fields
	    var dataRow = $('<tr>');

	    var dataCell1 = $('<td>').append($('<input>', {
	        type: 'text',
	        class: 'tag_name',
	        style: 'height: 10px; width: 200px;',
	        value: Object.keys(commandTag)[0]
	    }));
	    var dataCell2 = $('<td>').append($('<select>', {
	        class: 'variable',
	        style: 'height: 32px;',
	        required: true
	    }).append($('<option>', {
	        value: Object.values(commandTag)[0],
	        text: Object.values(commandTag)[0]
	    })));
	    
	    var cell3 = $('<td>');
	    var deleteBtn = $('<input>', {
	        type: 'button',
	        value: 'X',
	        class: 'deleteBtn',
	        style: 'height: 22px;',
	        title: 'Remove tag'
	    });
	    deleteBtn.on('click', function () {
	    	dataRow.remove();
	    });
	    cell3.append(deleteBtn);
	    
	   
	    dataRow.append(dataCell1, dataCell2, cell3);
	    table.append(dataRow);

	    // Iterate over the rest of the keys and values of the commandTag
	    $.each(Object.entries(commandTag).slice(1), function (_, [key, value]) {
	        var newRow = $('<tr>');
	        var cell1 = $('<td style="width: 100px;">').append($('<input>', {
	            type: 'text',
	            class: 'tag_name',
	            style: 'height: 10px; width: 200px;',
	            value: key
	        }));
	        var cell2 = $('<td>').append($('<select>', {
	            class: 'variable',
	            style: 'height: 32px;',
	            required: true
	        }).append($('<option>', {
	            value: value,
	            text: value
	        })));
	        
	        var cell3 = $('<td>');
	   	    var deleteBtn = $('<input>', {
	   	        type: 'button',
	   	        value: 'X',
	   	        class: 'deleteBtn',
	   	        style: 'height: 22px;',
	   	        title: 'Remove tag'
	   	    });
	   	    deleteBtn.on('click', function () {
	   	        newRow.remove();
	   	    });
	   	    cell3.append(deleteBtn);
	     
	        newRow.append(cell1, cell2, cell3);
	        table.append(newRow);
	    });

	    // Create the row with the "+" button
	    var addButtonRow = $('<tr>');
	    var addButtonCell = $('<td>').append($('<input>', {
	        type: 'button',
	        value: '+',
	        class: 'saveBtn', // Add a class for easy selection
	        style: 'height: 22px;',
	        title: 'Add tags'
	    }));
	    addButtonRow.append(addButtonCell);
	    table.append(addButtonRow);

	    // Attach a click event handler to the dynamically added "+" button
	    table.on('click', '.saveBtn', function () {
	        addRow();
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
	       	
	       	
	    	
	    	/* function validatefields(tag_name) {
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
 */
	    	
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
	  	   	
	   	
	   	function updateTagVariableValues() {
	   	    // Assuming input and select are global variables or are accessible in the same scope
	   	    var tagValues = {};

	   	    // Iterate over each row
	   	    $('.bordered-table1 tr').each(function () {
	   	        var tagName = $(this).find('.tag_name').val();
	   	        var variable = $(this).find('.variable').val();

	   	        // Add the new key-value pair to the local tagValues object
	   	        tagValues[tagName] = variable;
	   	    });

	   	    // Update the global tagVariableValues with the collected key-value pairs
	   	    tagVariableValues = tagValues;

	   	    // Return the updated object if needed (optional)
	   	    return tagVariableValues;
	   	}

	   	
	  // Function to dynamically add a new row
	   	function addRow() {
	   	    var newRow = $('<tr>');

	   	    var cell1 = $('<td style="width: 100px;">');
	   	    var input = $('<input>', {
	   	        type: 'text',
	   	        class: 'tag_name',
	   	        name: 'tag_name',
	   	        style: 'height: 10px; width: 200px;'
	   	    });
	   	    cell1.append(input);

	   	    var cell2 = $('<td>');
	   	    var select = $('<select>', {
	   	        class: 'variable',
	   	        name: 'variable',
	   	        style: 'height: 32px;',
	   	        required: true
	   	    });
	   	    var option = $('<option>', {
	   	        value: 'Select variable',
	   	        text: 'Select variable'
	   	    });
	   	    select.append(option);
	   	    cell2.append(select);

	   	    var cell3 = $('<td>');
	   	    var deleteBtn = $('<input>', {
	   	        type: 'button',
	   	        value: 'X',
	   	        class: 'deleteBtn',
	   	        style: 'height: 22px;',
	   	        title: 'Remove tag'
	   	    });
	   	    deleteBtn.on('click', function () {
	   	        newRow.remove();
	   	    });
	   	    cell3.append(deleteBtn);

	   	    newRow.append(cell1, cell2, cell3);

	   	    // Insert the new row before the last row (Add button row)
	   	    var table = $('.bordered-table1');
	   	    var lastRow = table.find('tr').last();
	   	    newRow.insertBefore(lastRow);

	   	// Load tag list for the new dropdown
	   	    loadTagList();

	   	 input.on('blur', function () {
	         // Call updateTagVariableValues to ensure tagVariableValues is up-to-date
	         updateTagVariableValues();

	         // Log or use the updated tagVariableValues as needed
	         var jsonString = JSON.stringify(tagVariableValues);
	         
	     });
	   	}
 
 

	    	 $(document).ready(function () {
	    		 
	    		 <%
	    	    	// Access the session variable
	    	    	HttpSession role = request.getSession();
	    	    	String roleValue = (String) session.getAttribute("role");
	    	    	%>
	    	    	
	    	    	roleValue = '<%= roleValue %>'; // This will insert the session value into the JavaScript code
	    	    	
	    	    	

	    	    	<%// Access the session variable
	    			HttpSession csrfToken = request.getSession();
	    			String csrfTokenValue = (String) session.getAttribute("csrfToken");%>

	    			csrfTokenValue = '<%=csrfTokenValue%>';
	    	    	
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

		        // Update the session-msg content with the message from the server
			    var sessionMsg = document.getElementById('session-msg');
			    sessionMsg.textContent = 'You are not allowed to redirect like this !!'; 
		        
		        
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
      	  
      	$('.deleteBtn').on('click', function () {
      	    // Find the parent row and remove it
      	    $(this).closest('tr').remove();
      	});
      	  
      	$('#saveBtn').on('click', function () {
      		 addRow();
      	   
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
 			$('#interval').val('1 min');	  
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
				    
				    var tagData = updateTagVariableValues();
					var unit_id = $('#unit_id').val();
				    var asset_id = $('#asset_id').val();
				    var broker_type = $('#broker_type').find(":selected").val();		   
				    var interval = $('#interval').find(":selected").val();
				    var status = $('#status').find(":selected").val();
				    var csrfToken = document.getElementById('csrfToken').value;
				   
				    // Clear previous error messages
				    $('#field_unitid_Error').text('');
				    $('#field_assetid_Error').text('');
				 
					 // Validate username
				    var unitIdError = validateUnitId(unit_id);
				    if (unitIdError) {
				        $('#field_unitid_Error').text(unitIdError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
				        return;
				    }

				    // Validate first name
				    var assetIdError = validateAssetId(asset_id);
				    if (assetIdError) {
				        $('#field_assetid_Error').text(assetIdError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
				        return;
				    }
			
			// Display the custom modal dialog
			  var modal = document.getElementById('custom-modal-edit');
			  modal.style.display = 'block';
			  
			// Handle the confirm button click
			  var confirmButton = document.getElementById('confirm-button-edit');
			  confirmButton.onclick = function () {

				 
				    
				    $.ajax({
						url : 'commandConfigServlet',
						type : 'POST',
						data : {
							unit_id : unit_id,
							asset_id : asset_id,
							broker_type : broker_type,
							broker_name : broker_name,
							interval : interval,
							status : status,
							tagData: JSON.stringify(tagVariableValues),
							csrfToken: csrfToken,
							action: 'update'
							
						},
						success : function(data) {
							modal.style.display = 'none';
							
							loadCommandSettings();

							// Clear form fields
							$('#unit_id').val('');
							$('#asset_id').val('');
							$('#broker_type').val('mqtt');
							$('#broker_name').val('Select broker IP address');
							$('#interval').val('1 min');
							$('#status').val('Enable');
							
							location.reload();
						},
						error : function(xhr, status, error) {
							
						}
					});
				    
				    $('#addBtn').val('Add');
			  };
			  
			  var cancelButton = document.getElementById('cancel-button-edit');
			  cancelButton.onclick = function () {
			    // Close the modal
			    modal.style.display = 'none';
			    location.reload();
			    $('#addBtn').val('Update');
			  };

		}
		
		//Validation for first name
		function validateUnitId(unitid) {
		var regex = /^[a-zA-Z][a-zA-Z0-9]*$/;

		if (!regex.test(unitid)) {
		    return 'Invalid unit id; symbols not allowed';
		}

		return null; // Validation passed
		}

		//Validation for first name
		function validateAssetId(assetId) {
		var regex = /^[a-zA-Z][a-zA-Z0-9]*$/;

		if (!regex.test(assetId)) {
		    return 'Invalid Asset id; symbols not allowed';
		}

		return null; // Validation passed
		}
		
		function addCommandConfig() {

		 var tagData = updateTagVariableValues();
		
		    var unit_id = $('#unit_id').val();
		    var asset_id = $('#asset_id').val();
		    var broker_type = $('#broker_type').find(":selected").val();
		    var broker_name = $('#broker_name').find(":selected").val();
		    var interval = $('#interval').find(":selected").val();
		    var status = $('#status').find(":selected").val();  
		    var csrfToken = document.getElementById('csrfToken').value;
		    
		    var errorSpanStatus = $('#brokerIPAddressError'); // Assuming you have a <span> element for error messages
			  
			// Check if the selected status is "Select status"
			    if (broker_name === "Select broker IP address") {
			        // Display an error message and prevent saving
			        errorSpanStatus.text("Please select a valid IP address.");
			        return;
			    }

			    // Clear any previous error messages
			    errorSpanStatus.text("");
			    
			    // Clear previous error messages
			    $('#field_unitid_Error').text('');
			    $('#field_assetid_Error').text('');
			 
				 // Validate username
			    var unitIdError = validateUnitId(unit_id);
			    if (unitIdError) {
			        $('#field_unitid_Error').text(unitIdError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
			        return;
			    }

			    // Validate first name
			    var assetIdError = validateAssetId(asset_id);
			    if (assetIdError) {
			        $('#field_assetid_Error').text(assetIdError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
			        return;
			    }

			   
			
		   
			$.ajax({
				url : 'commandConfigServlet',
				type : 'POST',
				data : {
					unit_id : unit_id,
					asset_id : asset_id,
					broker_type : broker_type,
					broker_name : broker_name,
					interval : interval,
					status : status,
					tagData: JSON.stringify(tagVariableValues),
					csrfToken: csrfToken,
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
					$('#interval').val('1 min');
					$('#status').val('Enable');
					
					location.reload();
					
				},
				error : function(xhr, status, error) {
					
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
			<input type="hidden" name="csrfToken" id="csrfToken" value="<%= csrfTokenValue %>" />
			
			<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>
			
			<table class="bordered-table" style="margin-top: -1px;">
			
			<tr>
			<td>Unit ID</td>
			<td style="padding: 5px; height: 50px; width: 230px;">
			<input type="text" id="unit_id" name="unit_id" required style="height: 10px; " maxlength="31"/>
			<span id="field_unitid_Error" class="error-message" style="display: block; margin-top: 5px;"></span>
							</td>
			<td>Asset ID</td>
			<td><input type="text" id="asset_id" name="asset_id" required style="height: 10px" maxlength="31"/>
			<span id="field_assetid_Error" class="error-message" style="display: block; margin-top: 5px;"></span>
							</td>
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
							
							<option value="1 min" selected>1 min</option>
							<option value="5 min">5 min</option>
							<option value="10 min">10 min</option>
							<option value="15 min">15 min</option>
							<option value="20 min">20 min</option>
							<option value="25 min">25 min</option>
							<option value="30 min">30 min</option>
							<option value="1 hour">1 hour</option>
							</select>
							</td>
						
			<td>Status</td>
			<td><select class="textBox" id="status" name="status" style="height: 33px" required>
							<option value="Enable" selected>Enable</option>
							<option value="Disable">Disable</option>
						</select> </td>
			
			</tr>
			
			</table>
			<br>
					
			<table class="bordered-table1">
			
			<tr>
			<th style="width: 20%">Tag List</th>
			<th style="width: 20%">Variable</th>
			<th style="width: 10%">Action</th>
			</tr>
			
			 <tr>
			
						<td><input type="text" id="tag_name" name="tag_name" class="tag_name"
											style="height: 10px; width: 200px;" /></td>
											
										<td><select class="variable" id="variable"
											name="variable" style="height: 32px;" required>
												<option value="Select variable">Select variable</option>
										</select></td>
										<td><input type="button" value="X" id="deleteBtn" class="deleteBtn"
											style="height: 22px;" title="Remove tags" /></td>
						
						
			</tr> 
			<tr>
										<td><input type="button" value="+" id="saveBtn" class="saveBtn"
											style="height: 22px;" title="Add tags" /></td>
									</tr>
				
				</table>
				
				<div class="row" style="display: flex; justify-content: center; margin-bottom: 2%; margin-top: 1%;">
					
					<input style="height: 26px;" type="button" value="Clear" id="clearBtn"/> 
						<input style="margin-left: 5px; height: 26px;" type="submit" value="Add" id="addBtn" /> 
						<input style="margin-left: 5px; height: 26px;" type="button" value="Delete" id="delBtn" />
						
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
				  <p>Are you sure you want to modify this command setting?</p>
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
			  
		
		</section>

		
	</div>

	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>