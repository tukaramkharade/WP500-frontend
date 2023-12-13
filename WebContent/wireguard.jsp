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

.container {
	width: 50%;
	margin: 0 auto;
}

.modal-edit {
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

.modal-content-edit {
	background-color: #d5d3d3;
	padding: 20px;
	border-radius: 5px;
	text-align: center;
	position: relative;
	width: 300px;
	transform: translate(0, -50%); /* Center vertically */
	top: 50%; /* Center vertically */
	left: 50%; /* Center horizontally */
	transform: translate(-50%, -50%);
	/* Center horizontally and vertically */
}

/* Style for buttons */
button {
	margin: 5px;
	padding: 10px 20px;
	border: none;
	cursor: pointer;
}

#confirm-button-edit {
	background-color: #4caf50;
	color: white;
}

#cancel-button-edit {
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
	transform: translate(-50%, -50%);
	/* Center horizontally and vertically */
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
    text-align: left !important;
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



</style>

<script>
var roleValue;
var tokenValue;

function getKeys(){
	$.ajax({
		url : "wireguardKeysServlet",
		type : "GET",
		dataType : "json",
		 data: {
	            action: "get"
	        },
		success : function(data) {
			$('#private_key').val(data.private_key);
			$('#public_key').val(data.public_key);

            
		},
		error : function(xhr, status, error) {
			console.log("Error showing wireguard keys data : " + error);
		},
	});
}

function readWireguardFile(){
	$.ajax({
		url : "wireguardServlet",
		type : "GET",
		dataType : "json",
		success : function(data) {
			
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
            var textToShow = data.wireguard_file_data.join('\n');
            // Set the text in the textarea
            $('#wireguard_file').val(textToShow);
            
		},
		error : function(xhr, status, error) {
			console.log("Error showing wireguard file data : " + error);
		},
		
	});
}

function generateWireguardKeys(){
	$.ajax({
		url : "wireguardKeysServlet",
		type : "GET",
		dataType : "json",
		 data: {
	            action: "generate_keys"
	        },
		success : function(data) {
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
			
			$('#private_key').val(data.private_key);
			$('#public_key').val(data.public_key);

            
		},
		error : function(xhr, status, error) {
			console.log("Error generating wireguard keys data : " + error);
		},
	});
}

function activateWireguard() {
    $.ajax({
        url: "wireguardKeysServlet",
        type: "GET",
        dataType: "json",
        data: {
            action: "activate_wireguard"
        },
        success: function (data) {
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
            // Check if the result is an array
            if (Array.isArray(data.activate_wireguard_result)) {
                // Join array elements with HTML line breaks
                var resultMessage = data.activate_wireguard_result.join('<br>');
                
                // Set the result message in the popup with HTML
                $("#popupMessage").html(resultMessage);

                // Show the popup
                $("#customPopup").show();
            } else {
                console.log("Invalid data format for activate_wireguard_result");
            }
        },
        error: function (xhr, status, error) {
            console.log("Error activating wireguard data: " + error);
        },
    });

    $("#closePopup").click(function () {
        // Hide the popup on close button click
        $("#customPopup").hide();
    });
}

function deActivateWireguard(){
	$.ajax({
        url: "wireguardKeysServlet",
        type: "GET",
        dataType: "json",
        data: {
            action: "deactivate_wireguard"
        },
        success: function (data) {
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
            // Check if the result is an array
            if (Array.isArray(data.deactivate_wireguard_result)) {
                // Join array elements with HTML line breaks
                var resultMessage = data.deactivate_wireguard_result.join('<br>');
                
                // Set the result message in the popup with HTML
                $("#popupMessage").html(resultMessage);

                // Show the popup
                $("#customPopup").show();
            } else {
                console.log("Invalid data format for deactivate_wireguard_result");
            }
        },
        error: function (xhr, status, error) {
            console.log("Error deactivating wireguard data: " + error);
        },
    });

    $("#closePopup").click(function () {
        // Hide the popup on close button click
        $("#customPopup").hide();
    });
}

function wireguardStatus() {
    $.ajax({
        url: "wireguardKeysServlet",
        type: "GET",
        dataType: "json",
        data: {
            action: "wireguard_status"
        },
        success: function (data) {
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
            // Check if the result is an array and not empty
            if (Array.isArray(data.wireguard_status_result) && data.wireguard_status_result.length > 0) {
                // Join array elements with HTML line breaks
                var resultMessage = data.wireguard_status_result.join('<br>');
                
                // Set the result message in the popup with HTML
                $("#popupMessage").html(resultMessage);

                // Show the popup
                $("#customPopup").show();
            } else {
                // Handle empty array case or any other specific behavior
                $("#popupMessage").html("No data available.");

                // Show the popup
                $("#customPopup").show();
            }
        },
        error: function (xhr, status, error) {
            console.log("Error getting wireguard status: " + error);
        },
    });

    $("#closePopup").click(function () {
        // Hide the popup on close button click
        $("#customPopup").hide();
    });
}

function updateWireguardFile() {
	
	 var modal = document.getElementById('custom-modal-edit');
	  modal.style.display = 'block';
	  
	// Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-edit');
	  confirmButton.onclick = function () {
		  
   // Get the textarea value
   var textareaValue = $('#wireguard_file').val();

   // Split the textarea value into an array using the newline character ("\n")
   var lines = textareaValue.split('\n');

   // Display the array in the console (you can replace this with your update logic)
   console.log("Lines Array:", lines);

   // Convert the lines array to a JSON string
   var linesJson = JSON.stringify(lines);

   // Use $.ajax to send the data to the servlet
   $.ajax({
       url: "wireguardServlet",
       type: "POST",
      
       data: JSON.stringify({
           lines: linesJson
       }), // Send as a JSON object
       success: function(response) {
    	   if (response.status == 'fail') {
				
				 var modal1 = document.getElementById('custom-modal-session-timeout');
				  modal1.style.display = 'block';
				  
				// Update the session-msg content with the message from the server
				    var sessionMsg = document.getElementById('session-msg');
				    sessionMsg.textContent = response.message; // Assuming data.message contains the server message

				  
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
       	
	        $("#popupMessage").text(response.message);
  			$("#customPopup").show();
  			
       	
	        readWireguardFile();
       },
       error: function(error) {
           console.log("Error updating data:", error);
       }
   });
   
   $("#closePopup").click(function () {
	    $("#customPopup").hide();
	  });
};

var cancelButton = document.getElementById('cancel-button-edit');
cancelButton.onclick = function () {
 // Close the modal
 modal.style.display = 'none';
 location.reload();
};	
}


$(document).ready(function() {
	
	<%// Access the session variable
			HttpSession role = request.getSession();
			String roleValue = (String) session.getAttribute("role");%>

roleValue = '<%=roleValue%>';

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

							getKeys();
							readWireguardFile();

							$('#update').click(function() {
								updateWireguardFile();
							});
							
							$('#generate_new_key').click(function() {
								generateWireguardKeys();
							});
							
							$('#activate').click(function() {
								activateWireguard();
							});
							
							$('#deactivate').click(function() {
								deActivateWireguard();
							});
							
							$('#status').click(function() {
								wireguardStatus();
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
			<h3>WIREGUARD</h3>
			<hr>
			<div class="container">

				<form id="wireguardForm">

					<input type="hidden" id="action" name="action" value="">

					<table class="bordered-table">
						<tr>
							<td style="width: 10%;">Private key:</td>
							<td><input type="text" id="private_key" disabled></td>
						</tr>

						<tr>
							<td style="width: 10%;">Public key:</td>
							<td><input type="text" id="public_key" disabled></td>
						</tr>
					</table>


					<div class="row"
						style="display: flex; justify-content: right; margin-bottom: 2%; margin-top: 1%;">

						<input style="height: 26px;" type="button"
							value="Generate new key" id="generate_new_key" />

					</div>

					<table class="bordered-table">
						<tr>
							<td colspan="2"><textarea id="wireguard_file"
									name="wireguard_file" rows="10" cols="100" required
									style="height: 500px;"></textarea></td>
						</tr>


					</table>

					<div class="row"
						style="display: flex; justify-content: center; margin-bottom: 2%; margin-top: 1%;">

						<input style="height: 26px;" type="button" value="Update"
							id="update" /> <input style="height: 26px; margin-left: 10px;"
							type="button" value="Activate" id="activate" /> <input
							style="height: 26px; margin-left: 10px;" type="button"
							value="Deactivate" id="deactivate" /> <input
							style="height: 26px; margin-left: 10px;" type="button"
							value="Status" id="status" />

					</div>
				</form>
			</div>

			<div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
					<p>Are you sure you want to modify this wireguard file?</p>
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

</body>
</html>