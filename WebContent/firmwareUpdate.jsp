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
					file : file
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
						  
						// Close the modal
					        modal.style.display = 'none';
					        window.location.href = 'login.jsp';
					  };
				}

                // Loop through the data and add rows to the table
                data.firmware_files_result.forEach(function (file) {
                    var row = $("<tr>");
                    row.append($("<td>").text(file));
                    var deleteButton = $('<button data-toggle="tooltip" class="delBtn" data-placement="top" title="Delete" style="color: red">')
                        .html('<i class="fas fa-trash-alt"></i>')
                        .click(function() {
                            deleteFile(file);
                        });
                    row.append($("<td>").append(deleteButton));
                    table.append(row);
                });
            }
        },
        error: function (xhr, status, error) {
            console.log("Error loading firmware files list: " + error);
        },
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
			
			<form action="UploadServlet" method="post" enctype="multipart/form-data">
        		<input type="file" name="file" id="fileInput">
        		<input type="submit" value="Upload" id="file_upload" onclick="redirectToFirmwareUpdate();">
        		
        		<input type="button" value="Firmware update" id="firmware_update">
    		</form>
			</div>
			
			<div id="custom-modal-delete" class="modal-delete">
				<div class="modal-content-delete">
				  <p>Are you sure you want to delete this firmware file?</p>
				  <button id="confirm-button-delete">Yes</button>
				  <button id="cancel-button-delete">No</button>
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
			<table id="firmware_list_table">
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
	
	<!-- Custom Popup -->
    <div id="customPopup" class="popup">
        <span class="popup-content" id="popupMessage"></span>
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
     	
    
     	if(roleValue == 'VIEWER' || roleValue == 'Viewer'){
     		
     		$('#file_upload').prop('disabled', true);
			$('#firmware_update').prop('disabled', true);
			$('#crt_file_upload').prop('disabled', true);		
			$('#fileInput').prop('disabled', true); 
			
			
			changeButtonColor(true);
     	}
     	
     	loadFirmwareFiles();
    });
    </script>
</body>
</html>
