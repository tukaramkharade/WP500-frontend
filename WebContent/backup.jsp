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
<script src="jquery-3.6.0.min.js"></script>

<style>

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

button {
  margin: 5px;
  padding: 10px 20px;
  border: none;
  cursor: pointer;
}

#confirm-button-edit,
#confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
}

#cancel-button-edit {
  background-color: #f44336;
  color: white;
}

h3{
margin-top: 68px;
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
.container {
    margin: 0 auto;
    width: 40%;
  }
  .note {
	color: red;
	margin-top: 5%;
}

</style>
<script>

var roleValue;	
var tokenValue;
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
                    	if (data.status == 'error') {
							
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

function downloadZipFile() {
    var selectedFileName = $("#fileName").val();

    if (selectedFileName !== "") {
        // Create a hidden anchor element to trigger the file download
        var downloadLink = document.createElement("a");
        downloadLink.href = "downloadBackupFile"; // Replace with the appropriate endpoint for downloading the ZIP file
        downloadLink.style.display = "none";
        document.body.appendChild(downloadLink);

        downloadLink.click(); // Simulate a click on the anchor element to trigger the download

        document.body.removeChild(downloadLink); // Clean up the element after download
    } else {
        // Handle the case when no file name is entered
        $("#popupMessage").text("Please enter a file name first.");
        $("#customPopup").show();
    }

    $("#closePopup").click(function () {
        $("#customPopup").hide();
    });
}
function createBackupFile() {
	$.ajax({
		url : 'downloadBackupFile',
		type : 'POST',
		data : {
			action: 'createBackupFile'
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
		},
		error : function(xhr, status, error) {
			console.log('Error adding tag: '+ error);
		}
	});
	$("#closePopup").click(function () {
	    $("#customPopup").hide();
	  });
	
}	
function restoreBackupFile() {
	$.ajax({
		url : 'downloadBackupFile',
		type : 'POST',
		data : {
			action: 'restoreBackupFile'
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
		},
		error : function(xhr, status, error) {
			console.log('Error adding tag: '+ error);
		}
	});
	$("#closePopup").click(function () {
	    $("#customPopup").hide();
	  });
	
}	

	$(document).ready(function() {

		<%
    	// Access the session variable
    	HttpSession role = request.getSession();
    	String roleValue = (String) session.getAttribute("role");
    	%>
    	
    	roleValue = '<%= roleValue %>';
    	
    	
    	if(roleValue == 'OPERATOR' || roleValue == 'Operator'){
  		  
  		$('#reboot').prop('disabled', true);
  		  
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
	    }else{
	    	<%// Access the session variable
	    	HttpSession token = request.getSession();
	    	String tokenValue = (String) session.getAttribute("token");%>

	    	tokenValue = '<%=tokenValue%>';
	    	
	    	$('#downloadZipFile').click(function() {
	    		event.preventDefault(); 
	    		downloadZipFile();
			});
	    	$('#restoreButton').click(function(event) {
	               event.preventDefault();
	               validateAndUpload('fileInput', '.zip');
	         });	
	    	$('#generateBackupFile').click(function(event) {
	               event.preventDefault(); 
	               createBackupFile();
	         });
	    	$('#restoreBackupFile').click(function(event) {
	               event.preventDefault(); 
	               restoreBackupFile();
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
			<h3>BACKUP</h3>
			<hr>

			<div class="container">				
					<input style="margin-left: 5px;" type="submit" value="Start Backup" id="generateBackupFile" title="Click to begin backup process" />
				
					<input type="button" id="downloadZipFile" value="Download Backup" />
				<div class="note">
					<p>Step 1: Start the backup process. Please wait for some time while the backup is being generated.</p>
					<p>Step 2: Download the backup file.</p>
				</div>	
			</div>			
		</section>

		<section style="margin-left: 1em">
			<h3>RESTORE</h3>
			<hr>
			<div class="container">
  				  <form action="UploadServlet" method="post" enctype="multipart/form-data" class="upload-form" style="margin-bottom: 10px;">
      					  <input type="file" name="file" id="fileInput" style="margin-right: 10px;">
       					  <input type="submit" value="Upload Restore File" id="restoreButton">
   						  <input style="margin-left: 5px;" type="submit" value="Restore Backup" id="restoreBackupFile">
 				   </form>
 				  <div class="note">
       				 <p>Step 1: Upload the restore file by selecting it above.</p>
       				 <p>Step 2: Start the restore process by clicking on the 'Restore Backup' button.</p>
   				  </div>
					 
			</div>

			<div class="progress-container">
				<h3>File Progress</h3>
				<div id="progress-bar-container">
					<div id="progress-bar"></div>
				</div>
			</div>
			
			
		</section>
		
		<div id="custom-modal-session-timeout" class="modal-session-timeout">
				<div class="modal-content-session-timeout">
				  <p id="session-msg"></p>
				  <button id="confirm-button-session-timeout">OK</button>
				</div>
			  </div>
	</div>

	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>