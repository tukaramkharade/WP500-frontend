<%
    response.setHeader("X-Frame-Options", "DENY");
    response.setHeader("X-Content-Type-Options", "nosniff");
    HttpSession session1 = request.getSession();
    String secureFlag = "Secure";
    String httpOnlyFlag = "HttpOnly";
    String sameSiteFlag = "SameSite=None"; // Add this line for SameSite attribute
    String cookieValue = session1.getId();
    String headerKey = "Set-Cookie";
    String headerValue = String.format("%s=%s; %s; %s; %s", session1.getId(), cookieValue, secureFlag, httpOnlyFlag, sameSiteFlag);
    response.setHeader(headerKey, headerValue);
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
<style>

h3{
margin-top: 68px;
}

.modal-delete,
.modal-update,
.modal-session-timeout{
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
.modal-content-update,
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
 
button {
  margin: 5px;
  padding: 10px 20px;
  border: none;
  cursor: pointer;
}

#confirm-button-delete,
#confirm-button-update,
#confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
}

#cancel-button-delete,
#cancel-button-update {
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
<script type="text/javascript">

var roleValue;
var csrfTokenValue;
function deleteFile(file){
	 var csrfToken = document.getElementById('csrfToken').value;	 
	  var modal = document.getElementById('custom-modal-delete');
	  modal.style.display = 'block';
	  var confirmButton = document.getElementById('confirm-button-delete');
	  confirmButton.onclick = function () {	  
		  $.ajax({
				url : 'FirmwareListServlet',
				type : 'POST',
				data : {
					file : file,
					action : 'delete',
					csrfToken: csrfToken
				},
				success : function(data) {				
					modal.style.display = 'none';
					loadFirmwareFiles();
				},
				error : function(xhr, status, error) {				
				}
			});	  
	  };	  
	  var cancelButton = document.getElementById('cancel-button-delete');
	  cancelButton.onclick = function () {
	    modal.style.display = 'none';
	  };
}

function updateFirmwareFile(file){
	 var csrfToken = document.getElementById('csrfToken').value;	 
	  var modal = document.getElementById('custom-modal-update');
	  modal.style.display = 'block';
	  var confirmButton = document.getElementById('confirm-button-update');
	  confirmButton.onclick = function () {		  
		  $.ajax({
				url : 'FirmwareListServlet',
				type : 'POST',
				data : {
					file : file,
					action : 'update',
					csrfToken: csrfToken
				},
				success : function(data) {				
					modal.style.display = 'none';
					loadFirmwareFiles();					
					$("#popupMessage").text(data.message);
	      			$("#customPopup").show();	      			
				},
				error : function(xhr, status, error) {					
				}
			});		  
	  };	  
	  var cancelButton = document.getElementById('cancel-button-update');
	  cancelButton.onclick = function () {
	    modal.style.display = 'none';
	  };	  
	  $("#closePopup").click(function () {
		    $("#customPopup").hide();
		  });
}

function loadFirmwareFiles() {
    showLoader();
    var csrfToken = document.getElementById('csrfToken').value;  
    $.ajax({
        url: "FirmwareListServlet",
        type: "GET",
        dataType: "json",
        data: {
			csrfToken: csrfToken
        },
        success: function (data) {      	
            hideLoader();        	
        	if (data.status == 'fail') {				
				 var modal = document.getElementById('custom-modal-session-timeout');
				 modal.style.display = 'block';			  
				 var sessionMsg = document.getElementById('session-msg');
				 sessionMsg.textContent = data.message; // Assuming data.message contains the server message				  
				 var confirmButton = document.getElementById('confirm-button-session-timeout');
				 confirmButton.onclick = function () {				  
				        modal.style.display = 'none';
				        window.location.href = 'login.jsp';
				  };				  
			} 		
                var table = $("#firmware_list_table tbody");
                table.empty();                       
                if(roleValue == 'ADMIN' || roleValue == 'Admin'){
                    data.firmware_files_result.forEach(function (file) {
                        var row = $("<tr>");
                        row.append($("<td>").text(file));
                        var actions = $('<td>');                      
                        var deleteButton = $('<button data-toggle="tooltip" class="delBtn" data-placement="top" title="Delete" style="color: red;">')
                            .html('<i class="fas fa-trash-alt"></i>')
                            .click(function() {
                                deleteFile(file);
                            });
                        var updateButton = $('<button data-toggle="tooltip" class="updBtn" data-placement="top" title="Update Firmware" style="color: red">')
                        .html('<i class="fa fa-play"></i>')
                        .click(function() {
                        	updateFirmwareFile(file);
                        	getFirmwareStatus();
                        });                                         
                        actions.append(deleteButton);
    					actions.append(updateButton);					
    					row.append(actions);  					
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
            hideLoader();        	
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
                        $("#popupMessage").text('File uploaded successfully.');
                        $("#customPopup").show();
                        loadStratonFiles();  // Refresh the Straton file list
                    } else {
                        $("#popupMessage").text('Error uploading file: ' + data.message);
                        $("#customPopup").show();
                    }
                },
                error: function(xhr, status, error) {
                    clearInterval(progressInterval); // Stop the progress interval on error                 
                }
            });
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
    $.ajax({
        url: 'UploadServlet', // Replace with your servlet URL
        type: 'GET',
        dataType: 'json',
        success: function(data) {     	
            var progress = data.progress;         
            $('#progress-bar').css('width', progress + '%');
            $('#progress-bar').text(progress + '%');
            if (progress === 100) {
                $('#progress-bar').css('width', '0%');
                $('#progress-bar').text('');
            }
        },
        error: function(xhr, status, error) {
        }
    });
}

function firmwareProgress() {
   $.ajax({
       url: 'firmwareFileDownloadURL', // Replace with your servlet URL
       type: 'GET',
       dataType: 'json',
       success: function(data) {     
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
                        $("#popupMessage").text('File uploaded successfully.');
                        $("#customPopup").show();
                        loadStratonFiles();  // Refresh the Straton file list
                    } else {
                        $("#popupMessage").text('Error uploading file: ' + data.message);
                        $("#customPopup").show();
                    }
                },
                error: function(xhr, status, error) {
                    clearInterval(progressInterval); // Stop the progress interval on error                    
                }
            });
            progressInterval = setInterval(firmwareProgress, 1000);
            $("#closePopup").click(function () {
                $("#customPopup").hide();
                $('#progress-bar').css('width', '0%');
                $('#progress-bar').text('');	
            });
        }   
        
function redirectToFirmwareUpdate() {
    window.location.href = 'firmwareUpdate.jsp';
}

function changeButtonColor(isDisabled) {
    var $file_upload_button = $('#file_upload');       
    var $firmware_update_button = $('#firmwareUpdateButton');
    var $firmware_download = $('#firmware_download');    
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
    if (isDisabled) {
        $firmware_download.css('background-color', 'gray'); // Change to your desired color
    } else {
        $firmware_download.css('background-color', '#2b3991'); // Reset to original color
    } 
}

function getFirmwareStatus(){
	 var csrfToken = document.getElementById('csrfToken').value; 
	$.ajax({
		url : "firmwareStatusServlet",
		type : "GET",
		dataType : "json",
		data: {
			csrfToken: csrfToken
        },
		success : function(data) {		
			if (data.status == 'fail') {			
				 var modal = document.getElementById('custom-modal-session-timeout');
				 modal.style.display = 'block';				  
				 var sessionMsg = document.getElementById('session-msg');
				 sessionMsg.textContent = data.message; // Assuming data.message contains the server message		  
				 var confirmButton = document.getElementById('confirm-button-session-timeout');
				 confirmButton.onclick = function () {					  
				        modal.style.display = 'none';
				        window.location.href = 'login.jsp';
				  };					  
			} 
           var textToShow = data.firmware_status_data.join('\n');			
           $('#firmware_status').val('');
           $('#firmware_status').val(textToShow);
		},
		error : function(xhr, status, error) {			
		},
	});
}

 function showLoader() {
     $('#loader-overlay').show();
 }

 function hideLoader() {
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

	if(roleValue == 'OPERATOR' || roleValue == 'Operator'){		
		$('#file_upload').prop('disabled', true);
		$('#crt_file_upload').prop('disabled', true);		
		$('#fileInput').prop('disabled', true); 
		$('#firmwareUpdateButton').prop('disabled', true);
		$('#firmware_download').prop('disabled', true);				
		changeButtonColor(true);
	}
	
	if (roleValue === "null") {
        var modal = document.getElementById('custom-modal-session-timeout');
        modal.style.display = 'block';
	    var sessionMsg = document.getElementById('session-msg');
	    sessionMsg.textContent = 'You are not allowed to redirect like this !!'; 	    
        var confirmButton = document.getElementById('confirm-button-session-timeout');
        confirmButton.onclick = function() {
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
			<input type="hidden" name="csrfToken" id="csrfToken" value="<%= csrfTokenValue %>" />		
			<div class="container">
			<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>
    <div class="forms-container">
        <form action="UploadServlet" method="post" enctype="multipart/form-data" class="upload-form">
            <input type="file" name="file" id="fileInput">
            <input type="submit" value="Upload" id="firmwareUpdateButton">          
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
        <h3 style="margin-top: -7px;">File Upload Progress</h3>
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
				<p id="session-msg"></p>
				  <button id="confirm-button-session-timeout">OK</button>
				</div>
			  </div>			
			<h3 style="margin-top: -23px;">FIRMWARE FILE LIST</h3>
			<hr />		
			<div class="container">
			<table id="firmware_list_table" style="margin-left: -17px;">
			<thead>
			<tr>
			<th style="width: 20%;">File</th>
			<th>Action</th>
			</tr>
			</thead>		
			<tbody>
			</tbody>
			</table>		
			</div>		
			<div class="firmware-status-container" style="width: 80%; margin-bottom: 20px;">
    <h3>Firmware Status</h3>
    <textarea id="firmware_status" name="firmware_status" 
							 style="margin-left: 19px; height: 200px; width: 1000px;"></textarea>
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
</body>
</html>