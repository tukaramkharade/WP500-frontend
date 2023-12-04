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

<style>

h3{
margin-top: 68px;
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
.modal-update {
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
.modal-content-update {
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
#confirm-button-update {
  background-color: #4caf50;
  color: white;
}

#cancel-button-update {
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
#progress-bar-container {
    width: 100%;
    background-color: #f3f3f3;
    border-radius: 5px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    margin-bottom: 20px;
}

#progress-bar {
    width: 0;
    height: 30px;
    background-color: #4caf50;
    text-align: center;
    line-height: 30px;
    color: white;
    border-radius: 5px;
    transition: width 0.3s ease-in-out;
}
.container {
    display: flex;
    flex-direction: column;
    align-items: center;
}

.forms-container {
    display: flex;
    justify-content: space-between;
    width: 80%;
    margin-bottom: 20px;
}

.upload-form,
.download-form {
    width: 45%;
    padding: 20px;
    border: 1px solid #ccc;
    border-radius: 5px;
}

.download-form {
    background-color: #f9f9f9;
}

.progress-container {
    width: 80%;
}

#progress-bar-container:hover #progress-bar {
    background-color: #45a049;
}

#progress-bar-container:hover {
    background-color: #e0e0e0;
}
.button-container {
    margin-top: 10px; /* Adjust the margin-top value as needed */
}
 

</style>

<script type="text/javascript">

function deleteFile(file){
	
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-delete');
	  modal.style.display = 'block';

	  // Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-delete');
	  confirmButton.onclick = function () {
		  
		  $.ajax({
				url : 'FirmwareListServlet',
				type : 'POST',
				data : {
					file : file,
					action : 'delete' 
				},
				success : function(data) {
					
					modal.style.display = 'none';
					loadFirmwareFiles();
				},
				error : function(xhr, status, error) {
					// Handle the error response, if needed
					console.log('Error deleting firmware file: ' + error);
				}
			});
		  
	  };
	  
	  var cancelButton = document.getElementById('cancel-button-delete');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	  };
	
	
}
function updateFirmwareFile(file){	
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-update');
	  modal.style.display = 'block';
	  // Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-update');
	  confirmButton.onclick = function () {		  
		  $.ajax({
				url : 'FirmwareListServlet',
				type : 'POST',
				data : {
					file : file,
					action : 'update' 
				},
				success : function(data) {
					
					modal.style.display = 'none';
					loadFirmwareFiles();
				},
				error : function(xhr, status, error) {
					// Handle the error response, if needed
					console.log('Error updating firmware file: ' + error);
				}
			});		  
	  };	  
	  var cancelButton = document.getElementById('cancel-button-update');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	  };
}

function loadFirmwareFiles() {
    $.ajax({
        url: "FirmwareListServlet",
        type: "GET",
        dataType: "json",
        success: function (data) {
            if (data.firmware_files_result && Array.isArray(data.firmware_files_result)) {
                var table = $("#firmware_list_table tbody");

                // Clear any existing rows in the table
                table.empty();
                
                var json1 = JSON.stringify(data);

				var json = JSON.parse(json1);

				if (json.status == 'fail') {
					var modal = document.getElementById('custom-modal-session-timeout');
					  modal.style.display = 'block';
					  
					  // Handle the confirm button click
					  var confirmButton = document.getElementById('confirm-button-session-timeout');
					  confirmButton.onclick = function () {					  
						
					        modal.style.display = 'none';
					        window.location.href = 'login.jsp';					           			           
					  };
				}

                // Loop through the data and add rows to the table
                data.firmware_files_result.forEach(function (file) {
                    var row = $("<tr>");
                    row.append($("<td>").text(file));
                    var deleteButton = $('<button data-toggle="tooltip" class="delBtn" data-placement="top" title="Delete" style="color: red;">')
                        .html('<i class="fas fa-trash-alt"></i>')
                        .click(function() {
                            deleteFile(file);
                        });
                    var updateButton = $('<button data-toggle="tooltip" class="updBtn" data-placement="top" title="Update-Firmware" style="color: red">')
                    .html('<i class="fa fa-play"></i>')
                    .click(function() {
                    	updateFirmwareFile(file);
                    });                   
                    row.append($("<td>").append(deleteButton));
                    row.append($("<td>").append(updateButton));
                    table.append(row);
                });
            }
        },
        error: function (xhr, status, error) {
            console.log("Error loading firmware files list: " + error);
        },
    });
}
var progressInterval;

function validateAndUpload(fileInputId, allowedExtension) {
    var fileInput = document.getElementById(fileInputId);
    var file = fileInput.files[0];

    if (file) {
        var fileName = file.name;
        var fileExtension = fileName.substring(fileName.lastIndexOf('.')).toLowerCase();

        if (fileExtension === allowedExtension) {
            var formData = new FormData();
            formData.append('file', file);

            $.ajax({
                url: 'UploadServlet',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(data) {
                    clearInterval(progressInterval); // Stop the progress interval
                    if (data.status === 'success') {
                        // File uploaded successfully logic
                        $("#popupMessage").text('File uploaded successfully.');
                        $("#customPopup").show();
                        loadStratonFiles();  // Refresh the Straton file list
                    } else {
                        // Error uploading file logic
                        $("#popupMessage").text('Error uploading file: ' + data.message);
                        $("#customPopup").show();
                    }
                },
                error: function(xhr, status, error) {
                    clearInterval(progressInterval); // Stop the progress interval on error
                    console.log('Error uploading file: ' + error);
                }
            });

            // Start the progress interval only if a file is being uploaded
            progressInterval = setInterval(updateProgress, 1000);
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
        $('#progress-bar').css('width', '0%');
        $('#progress-bar').text('');	
    });
}
function updateProgress() {
	 console.log('updateProgress');
    $.ajax({
        url: 'UploadServlet', // Replace with your servlet URL
        type: 'GET',
        dataType: 'json',
        success: function(data) {
        	console.log('updateProgress'+data.progress);
            var progress = data.progress;
            
            $('#progress-bar').css('width', progress + '%');
            $('#progress-bar').text(progress + '%');
            if (progress === 100) {
                $('#progress-bar').css('width', '0%');
                $('#progress-bar').text('');
            }
        },
        error: function(xhr, status, error) {
            console.error('Error fetching progress:', error);
        }
    });
}
function firmwareProgress() {
	 console.log('updateProgress');
   $.ajax({
       url: 'firmwareFileDownloadURL', // Replace with your servlet URL
       type: 'GET',
       dataType: 'json',
       success: function(data) {
       	console.log('updateProgress'+data.progress);
           var progress = data.progress;
           
           $('#progress-bar').css('width', progress + '%');
           $('#progress-bar').text(progress + '%');
           if (progress === 100) {
               $('#progress-bar').css('width', '0%');
               $('#progress-bar').text('');
           }
       },
       error: function(xhr, status, error) {
           console.error('Error fetching progress:', error);
       }
   });
}
function firmwareDownload() {
	 var fileUrl = $('#fileUrl').val();

     $.ajax({
         url: 'firmwareFileDownloadURL',
         type: 'POST',
         data: { fileUrl: fileUrl },
         success: function(data) {
                    clearInterval(progressInterval); // Stop the progress interval
                    if (data.status === 'success') {
                        // File uploaded successfully logic
                        $("#popupMessage").text('File uploaded successfully.');
                        $("#customPopup").show();
                        loadStratonFiles();  // Refresh the Straton file list
                    } else {
                        // Error uploading file logic
                        $("#popupMessage").text('Error uploading file: ' + data.message);
                        $("#customPopup").show();
                    }
                },
                error: function(xhr, status, error) {
                    clearInterval(progressInterval); // Stop the progress interval on error
                    console.log('Error uploading file: ' + error);
                }
            });

            // Start the progress interval only if a file is being uploaded
            progressInterval = setInterval(firmwareProgress, 1000);
            $("#closePopup").click(function () {
                $("#customPopup").hide();
                $('#progress-bar').css('width', '0%');
                $('#progress-bar').text('');	
            });
        }   
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
			<h3>FIRMWARE UPDATE</h3>
			<hr>
			
			<div class="container">
    <div class="forms-container">
        <form action="UploadServlet" method="post" enctype="multipart/form-data" class="upload-form">
            <input type="file" name="file" id="fileInput">
            <input type="submit" value="Upload" id="firmwareUpdateButton">
            <input type="button" value="Firmware update" id="firmware_update">
        </form>
        <form id="downloadForm" class="download-form">
            <label for="fileUrl">Enter File URL:</label>
            <input type="text" id="fileUrl" name="fileUrl" required>
            <div class="button-container">
            <input type="button" value="Download Firmware File" id="firmware_download">
        </div>
        </form>
    </div>
    <div class="progress-container">
        <h3>File Upload Progress</h3>
        <div id="progress-bar-container">
            <div id="progress-bar"></div>
        </div>
    </div>
</div>

			
			<div id="custom-modal-delete" class="modal-delete">
				<div class="modal-content-delete">
				  <p>Are you sure you want to delete this firmware file?</p>
				  <button id="confirm-button-delete">Yes</button>
				  <button id="cancel-button-delete">No</button>
				</div>
			  </div>
			  <div id="custom-modal-update" class="modal-update">
				<div class="modal-content-update">
				  <p>Are you sure you want to update this firmware file?</p>
				  <button id="confirm-button-update">Yes</button>
				  <button id="cancel-button-update">No</button>
				</div>
			  </div>
			  
			  <div id="custom-modal-session-timeout" class="modal-session-timeout">
				<div class="modal-content-session-timeout">
				  <p>Your session is timeout. Please login again</p>
				  <button id="confirm-button-session-timeout">OK</button>
				</div>
			  </div>
			
			<h3>FIRMWARE FILE LIST</h3>
			<hr />
			
			<div class="container">
			<table id="firmware_list_table" style="margin-left: -17px;">
			<thead>
			<tr>
			<th>File</th>
			<th>Action</th>
			</tr>
			</thead>
			
			<tbody>
			</tbody>
			</table>
			
			</div>
			
			</section>
			</div>
	
	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
	
			<div id="customPopup" class="popup">
  				<span class="popup-content" id="popupMessage"></span>
  				<button id="closePopup">OK</button>
			</div>
    
    <script>
    
 // JavaScript function to redirect to 'firmwareUpdate.jsp'
    function redirectToFirmwareUpdate() {
        window.location.href = 'firmwareUpdate.jsp';
    }
 
    
 
    function changeButtonColor(isDisabled) {
        var $file_upload_button = $('#file_upload');       
        var $firmware_update_button = $('#firmware_update');
      
        
        
         if (isDisabled) {
            $file_upload_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $file_upload_button.css('background-color', '#2b3991'); // Reset to original color
        }
        
        if (isDisabled) {
            $firmware_update_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $firmware_update_button.css('background-color', '#2b3991'); // Reset to original color
        } 
        
       
    }
    
 
    $(document).ready(function() {
   	 <%
    	// Access the session variable
    	HttpSession role = request.getSession();
    	String roleValue = (String) session.getAttribute("role");
    	%>
    	
    	var roleValue = '<%= roleValue %>'; // This will insert the session value into the JavaScript code
    	
   
    	if(roleValue == 'OPERATOR' || roleValue == 'Operator'){
    		
    		$('#file_upload').prop('disabled', true);
			$('#firmware_update').prop('disabled', true);
			$('#crt_file_upload').prop('disabled', true);		
			$('#fileInput').prop('disabled', true); 
			
			
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
	    }
    	
    	else{
    		<%// Access the session variable
			HttpSession token = request.getSession();
			String tokenValue = (String) session.getAttribute("token");%>

			tokenValue = '<%=tokenValue%>';
    		
    		$('#firmwareUpdateButton').click(function(event) {
               event.preventDefault(); // Prevent the form from submitting
               validateAndUpload('fileInput', '.swu');
           });	
    		$('#firmware_download').click(function(event) {
                event.preventDefault(); // Prevent the form from submitting
                firmwareDownload();
            });
        	
        	loadFirmwareFiles();
    		
    	}
    	
   });
    </script>
</body>
</html>
