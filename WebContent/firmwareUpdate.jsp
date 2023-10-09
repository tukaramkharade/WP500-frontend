<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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
        		<input type="file" name="file">
        		<input type="submit" value="Upload" onclick="redirectToFirmwareUpdate();">
        		
        		<input type="button" value="Firmware update">
    		</form>
			</div>
			
			<h3>UPLOAD CRT FILE</h3>
			<hr>
			<div class="container">
			
			<form action="UploadServlet" method="post" enctype="multipart/form-data">
        		<input type="file" name="file">
        		<input type="submit" value="Upload" onclick="redirectToFirmwareUpdate();">
        		
        		
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
 
        // Function to show a custom popup with a message
        function showPopup(message) {
            var popup = document.getElementById("customPopup");
            var popupMessage = document.getElementById("popupMessage");
            
            // Set the message content
            popupMessage.innerHTML = message;
            
            // Show the popup
            popup.style.display = "block";
            
            // Hide the popup after 3 seconds (adjust the timeout as needed)
            setTimeout(function() {
                popup.style.display = "none";
            }, 3000);
        }
    </script>
</body>
</html>
