<%  
    // Add X-Frame-Options header to prevent clickjacking
    response.setHeader("X-Frame-Options", "DENY");
%>

<!DOCTYPE html>
<html>
<head>
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

.modal-content-delete,
.modal-content-session-timeout{
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

.modal-delete,
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

/* Style for buttons */
#confirm-button-session-timeout,
#confirm-button-delete1 {
	background-color: #4caf50;
	color: white;
}

h3 {
	margin-top: -8px;
}

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

#cancel-button-delete1 {
  background-color: #f44336;
  color: white;
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
.form-container {
        display: flex;
        flex-direction: row;
        align-items: center;
    }

    .form-container label {
        margin-right: 10px;
    }

    .form-container input {
        margin-right: 10px;
    }

</style>
<script>
var roleValue;
var tokenValue;

	function loadStratonLiveDataList() {
		// Display loader when the request is initiated
	    showLoader();
		
		$.ajax({
			url : 'stratonLiveDataServlet',
			type : 'GET',
			dataType : 'json',
			beforeSend: function(xhr) {
		        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
		    },
			success : function(data) {
				// Hide loader when the response has arrived
	            hideLoader();
				
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
				
				var stratonLiveTable = $('#data-table tbody');
				stratonLiveTable.empty();

				// Iterate through the user data and add rows to the table
				data.result.forEach(function(stratonLiveData) {

					var row = $('<tr>');
					row.append($('<td>').text(stratonLiveData.tag_name + ""));
					row.append($('<td>').text(stratonLiveData.value + ""));
					row.append($('<td>').text(stratonLiveData.extError + ""));
					row.append($('<td>').text(stratonLiveData.access + ""));
					row.append($('<td>').text(stratonLiveData.error + ""));

					stratonLiveTable.append(row);

				});
			},
			error : function(xhr, status, error) {
				// Hide loader when the response has arrived
	            hideLoader();
				
				console.log('Error loading straton live data: ' + error);
			}
		});
	}
	   function openTab(tabName, button) {
           var tabContents = document.querySelectorAll('.tab-content');
           for (var i = 0; i < tabContents.length; i++) {
               tabContents[i].style.display = 'none';
           }

           var tabButtons = document.querySelectorAll('.tab-button');
           for (var i = 0; i < tabButtons.length; i++) {
               tabButtons[i].classList.remove('active');
           }

           button.classList.add('active');

           var tabContent = document.getElementById(tabName);
           if (tabContent) {
               tabContent.style.display = 'block';
           }
       }
	function myFunction() {
		var input, filter, table, tr, td, i, txtValue;
		input = document.getElementById("searchInput");
		filter = input.value.toUpperCase();
		table = document.getElementById("data-table");
		tr = table.getElementsByTagName("tr");
		for (i = 0; i < tr.length; i++) {
			td = tr[i].getElementsByTagName("td")[0];
			if (td) {
				txtValue = td.textContent || td.innerText;
				if (txtValue.toUpperCase().indexOf(filter) > -1) {
					tr[i].style.display = "";
				} else {
					tr[i].style.display = "none";
				}
			}
		}
	}
	  function validateAndUpload(fileInputId, allowedExtension) {
	        var fileInput = document.getElementById(fileInputId);
	        var file = fileInput.files[0];

	        if (file) {
	            var fileName = file.name;
	            var fileExtension = fileName.substring(fileName.lastIndexOf('.')).toLowerCase();

	            if (fileExtension === allowedExtension) {
	                // Valid file extension, perform upload logic
	                var formData = new FormData();
	                formData.append('file', file);

	                $.ajax({
	                    url: 'UploadServlet',
	                    type: 'POST',
	                    data: formData,
	                    processData: false,
	                    contentType: false,
	                    success: function(data) {
	                    	if (data.status === 'success') {
	                            $("#popupMessage").text('File uploaded successfully.');
	                  			$("#customPopup").show();	                           
	                            loadStratonFiles();  // Refresh the Straton file list
	                        } else {
	                            $("#popupMessage").text('Error uploading file: ' +data.message);
	                  			$("#customPopup").show();
	                        }
	                    },
	                    error: function(xhr, status, error) {
	                        // Handle error response, if needed
	                        console.log('Error uploading file: ' + error);
	                    }
	                });
	                
	            } else {
	                $("#popupMessage").text('Invalid file extension. Please select a file with ' + allowedExtension + ' extension.');
	      			$("#customPopup").show();
	            }
	        } else {
	            $("#popupMessage").text('Please select a file to upload.');
	  			$("#customPopup").show();
	        }
	        $("#closePopup").click(function () {
			    $("#customPopup").hide();
			  });
	    }
	  function loadStratonFiles() {
		    $.ajax({
		        url: "stratonListServelt",
		        type: "GET",
		        dataType: "json",
		        success: function (data) {
		            
		                var table = $("#straton_list_table tbody");

		                // Clear any existing rows in the table
		                table.empty();
		                
		                if(roleValue == 'ADMIN' || roleValue == 'Admin'){
		                	 // Loop through the data and add rows to the table
			                data.firmware_files_result.forEach(function (file) {
			                    var row = $("<tr>");
			                    row.append($("<td>").text(file));
			                    var deleteButton = $('<button data-toggle="tooltip" class="delBtn" data-placement="top" title="Delete" style="color: red">')
			                        .html('<i class="fas fa-trash-alt"></i>')
			                        .click(function() {
			                        	deleteStratonFile(file);
			                        });
			                    row.append($("<td>").append(deleteButton));
			                    table.append(row);
			                });
		                }else if(roleValue == 'OPERATOR' || roleValue == 'Operator'){
		                	
		                	data.firmware_files_result.forEach(function (file) {
			                    var row = $("<tr>");
			                    row.append($("<td>").text(file));
			                    
			                    table.append(row);
		                });
		                }
		                
		        },
		        error: function (xhr, status, error) {
		            console.log("Error loading firmware files list: " + error);
		        },
		    });
		}
	  function deleteStratonFile(file){
			
			// Display the custom modal dialog
			  var modal = document.getElementById('custom-straton-modal-delete');
			  modal.style.display = 'block';

			  // Handle the confirm button click
			  var confirmButton = document.getElementById('confirm-button-delete1');
			  confirmButton.onclick = function () {
				  
				  $.ajax({
						url : 'stratonListServelt',
						type : 'POST',
						data : {
							file : file
						},
						success : function(data) {
							
							modal.style.display = 'none';
							loadStratonFiles();
						},
						error : function(xhr, status, error) {
							// Handle the error response, if needed
							console.log('Error deleting firmware file: ' + error);
						}
					});
				  $("#closePopup").click(function () {
					    $("#customPopup").hide();
					  });
				  
			  };
			  
			  var cancelButton = document.getElementById('cancel-button-delete1');
			  cancelButton.onclick = function () {
			    // Close the modal
			    modal.style.display = 'none';
			  };
			  $("#closePopup").click(function () {
				    $("#customPopup").hide();
				  });
			
		}
	  function fetchStatusData() {
		    $.ajax({
		        url: 'stratonStatusData',
		        type: 'GET',
		        dataType: 'json',
		        success: function(data) {
		            // Handle the JSON response here
		            console.log('sys_cyclecount:', data.sys_cyclecount);
		            console.log('sys_flags:', data.sys_flags);
		            console.log('sys_cycletime:', data.sys_cycletime);
		            console.log('sys_appname:', data.sys_appname);
		            console.log('sys_cyclemax:', data.sys_cyclemax);
		            console.log('sys_appversion:', data.sys_appversion);
		            console.log('message:', data.message);
		            console.log('sys_cycleoverflows:', data.sys_cycleoverflows);
		        },
		        error: function(jqXHR, textStatus, errorThrown) {
		            console.error('AJAX request failed: ' + textStatus, errorThrown);
		        }
		    });
		}
	  function downloadStratonFile() {
		    var selectedFileName = $("#fileName").val();

		    if (selectedFileName !== "") {
		        $.ajax({
		            type: "POST", // Use POST method to send data
		            url: "downloadSratonFile",
		            data: { userFileName: selectedFileName },
		            success: function (data, textStatus, xhr) {
		            	 var filename = "";
		                 var disposition = xhr.getResponseHeader('Content-Disposition');

		                 // Access custom headers
		                 var customStatus = xhr.getResponseHeader('X-Status');
		                 var customMessage = xhr.getResponseHeader('X-Message');

		                 // Handle custom headers
		                 if (customStatus === 'success') {
		                     // File download was successful
		                     if (disposition && disposition.indexOf('attachment') !== -1) {
		                         var filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
		                         var matches = filenameRegex.exec(disposition);
		                         if (matches != null && matches[1]) filename = matches[1].replace(/['"]/g, '');
		                     }

		                     var blob = new Blob([data], { type: 'application/octet-stream' });

		                     if (typeof window.navigator.msSaveBlob !== 'undefined') {
		                         window.navigator.msSaveBlob(blob, filename);
		                     } else {
		                         var URL = window.URL || window.webkitURL;
		                         var downloadUrl = URL.createObjectURL(blob);

		                         if (filename) {
		                             var a = document.createElement("a");
		                             a.href = downloadUrl;
		                             a.download = filename;
		                             document.body.appendChild(a);
		                             a.click();
		                             document.body.removeChild(a);
		                         } else {
		                             window.location.href = downloadUrl;
		                         }

		                         setTimeout(function () {
		                             URL.revokeObjectURL(downloadUrl);
		                         }, 100);
		                     }
		                     }
		            },
		            error: function (xhr, textStatus, errorThrown) {
		                // Handle AJAX error
		                $("#popupMessage").text("Error: " + errorThrown);
		                $("#customPopup").show();
		            }
		        });
		    } else {
		        // Handle the case when no file name is entered
		        $("#popupMessage").text("Please enter a file name first.");
		        $("#customPopup").show();
		    }

		    $("#closePopup").click(function () {
		        $("#customPopup").hide();
		    });
		}
	  
	  
	  
	  function changeButtonColor(isDisabled) {
	        var $stratonUpdateButton = $('#stratonUpdateButton');       
	        var $straton_download = $('#straton_download');
	       
	        
	         if (isDisabled) {
	            $stratonUpdateButton.css('background-color', 'gray'); // Change to your desired color
	        } else {
	            $stratonUpdateButton.css('background-color', '#2b3991'); // Reset to original color
	        }
	        
	        if (isDisabled) {
	            $straton_download.css('background-color', 'gray'); // Change to your desired color
	        } else {
	            $straton_download.css('background-color', '#2b3991'); // Reset to original color
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
	
	if(roleValue == 'OPERATOR' || roleValue == 'Operator'){
		
		$('#stratonUpdateButton').prop('disabled', true);
		$('#straton_download').prop('disabled', true);
		
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
    } else{
    	<%// Access the session variable
		HttpSession token = request.getSession();
		String tokenValue = (String) session.getAttribute("token");%>

	tokenValue = '<%=tokenValue%>';
					loadStratonLiveDataList();
					loadStratonFiles();
					fetchStatusData();
					
					$('#stratonUpdateButton').click(function(event) {
			            event.preventDefault(); // Prevent the form from submitting
			            validateAndUpload('fileInput', '.cod');
			        });	
					$('#straton_download').click(function(event) {
			               event.preventDefault(); // Prevent the form from submitting
			               downloadStratonFile();
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
            <div class="container" style="margin-left: -22px;">
            <div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>

                <div class="tab-container" style="margin-top: -15px;">
                    <button class="tab-button active" onclick="openTab('straton-live-data-content', this)" style="margin-left: 5px;">STRATON LIVE DATA</button>
                    <button class="tab-button" onclick="openTab('straton-update', this)">STRATON UPDATE</button>
                    <div id="straton-live-data-content" class="tab-content" style="display: block; margin-left: -15px;">
                        <h3>STRATON LIVE DATA</h3>
                        <hr />
                        <button onClick="window.location.reload();" style="cursor: pointer; background-color: #35449a; border-radius: 5px; border: none; color: white; font-size: small">Refresh Page</button>
                        <div id="search">
                            <input id="searchInput" type="text" placeholder="Search" onkeyup="myFunction()" style="margin-top: 5px; margin-bottom: 10px; width: 400px;">
                        </div>
                        
                        <table id="data-table">
                            <thead>
                                <tr>
                                    <th>Tag name</th>
                                    <th>Value</th>
                                    <th>Exterror</th>
                                    <th>Access</th>
                                    <th>Error</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Table rows will be dynamically generated here -->
                            </tbody>
                        </table>
                        <div id="custom-modal-session-timeout" class="modal-session-timeout">
        <div class="modal-content-session-timeout">
          <p id="session-msg"></p>
            <button id="confirm-button-session-timeout">OK</button>
        </div>
    </div>
                    </div>
                    <div id="straton-update" class="tab-content" style="display: none;">
                    	 		  <h3>STRATON UPDATE</h3>
        <hr>

        <div class="container">

            <form action="UploadServlet" method="post" enctype="multipart/form-data">
                <input type="file" name="file" id="fileInput">
                <input type="submit" value="Upload" id="stratonUpdateButton">

                <!-- <input type="button" value="Straton update" id="firmware_update"> -->
                <div id="custom-straton-modal-delete" class="modal-delete">
				
			  </div>
            </form>
            <div class="form-container">
            
            <label for="fileUrl">Enter File Name</label>
            <input type="text" id="fileName" name="fileName" required style="width: 200px;">
           <div>
              <input type="button" value="Download Straton File" id="straton_download" >
           </div>
            
            </div>
            <div id="customPopup" class="popup">
  				<span class="popup-content" id="popupMessage"></span>
  				<button id="closePopup">OK</button>
			</div>
			 <div id="custom-straton-modal-delete" class="modal-delete">
				<div class="modal-content-delete">
				  <p>Are you sure you want to delete this straton file?</p>
				  <button id="confirm-button-delete1">Yes</button>
				  <button id="cancel-button-delete1">No</button>
				</div>
			  </div>
			
        </div>        

        <h3>STRATON FILE LIST</h3>
        <hr />

        <div class="container">
            <table id="straton_list_table" style="margin-left: -17px;">
                <thead>
                    <tr>
                        <th>File</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>
                    <!-- Table rows for firmware files will go here -->
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
