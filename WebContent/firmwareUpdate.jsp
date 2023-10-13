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

</style>
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
    });
    </script>
</body>
</html>
