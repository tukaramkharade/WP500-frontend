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
h3 {
	margin-top: 70px;
}

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

/* Style for buttons */
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
var tokenValue;

function readBannerText(){
	// Display loader when the request is initiated
    showLoader();
	
	$.ajax({
		url : "bannerTextServlet",
		type : "GET",
		dataType : "json",
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
			// Assuming data.banner_text_data is an array, join it to create a string
            var textToShow = data.banner_text_data.join('\n');

            // Set the text in the textarea
            $('#banner_text').val(textToShow);
		},
		error : function(xhr, status, error) {
			// Hide loader when the response has arrived
            hideLoader();
			console.log("Error showing banner text data : " + error);
		},
	});
}

function updateBannerText() {
	
	 var modal = document.getElementById('custom-modal-edit');
	  modal.style.display = 'block';
	  
	// Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-edit');
	  confirmButton.onclick = function () {
		  
    // Get the textarea value
    var textareaValue = $('#banner_text').val();

    // Split the textarea value into an array using the newline character ("\n")
    var lines = textareaValue.split('\n');

    // Display the array in the console (you can replace this with your update logic)
    console.log("Lines Array:", lines);

    // Convert the lines array to a JSON string
    var linesJson = JSON.stringify(lines);

    // Use $.ajax to send the data to the servlet
    $.ajax({
        url: "bannerTextServlet",
        type: "POST",
       
        data: JSON.stringify({
            lines: linesJson
        }), // Send as a JSON object
        success: function(response) {
        	// Close the modal
	        modal.style.display = 'none';
        	
            readBannerText();
        },
        error: function(error) {
            console.log("Error updating data:", error);
        }
    });
};

var cancelButton = document.getElementById('cancel-button-edit');
cancelButton.onclick = function () {
  // Close the modal
  modal.style.display = 'none';
  location.reload();
};	
}


function changeButtonColor(isDisabled) {
    var $update_button = $('#update');       
   
    if (isDisabled) {
        $update_button.css('background-color', 'gray'); // Change to your desired color
    } else {
        $update_button.css('background-color', '#2b3991'); // Reset to original color
    } 
    
}

//Function to show the loader
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
	
	$('#update').prop('disabled', true);
	
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
	
	 readBannerText();
		
		$('#update').click(function () {
			updateBannerText();
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
			<h3>BANNER TEXT</h3>
			<hr>
			<div class="container">
			
			<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>
			
			<form id="bannerForm">
			<textarea id="banner_text" name="banner_text" rows="10"
							cols="100" required style="margin-top: -30px; margin-left: -19px; height: 500px;"></textarea>
							
			<div class="row" style="display: flex; justify-content: center; margin-bottom: 2%; margin-top: 1%;">
					
					 <input style="height: 26px;" type="button" value="Update" id="update"/> 
					
				</div>
			</form>
			</div>
			
			 <div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to modify this banner?</p>
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
			</section>
			</div>

</body>
</html>