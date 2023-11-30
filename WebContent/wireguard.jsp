<!DOCTYPE html>
<html>
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32"
	href="images/WP_Connex_logo_favicon.png" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
h3 {
	margin-top: 70px;
}

.container{
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
  transform: translate(-50%, -50%); /* Center horizontally and vertically */
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
  transform: translate(-50%, -50%); /* Center horizontally and vertically */
  }
  
  #confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
}
</style>

<script>


function readWireguardFile(){
	$.ajax({
		url : "wireguardServlet",
		type : "GET",
		dataType : "json",
		success : function(data) {
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
       	// Close the modal
	        modal.style.display = 'none';
       	
	        readWireguardFile();
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


$(document).ready(function() {
	readWireguardFile();
	
	$('#update').click(function () {
		updateWireguardFile();
    });
	
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
			
			<table class="bordered-table">
			<tr>
			<td>Name: </td>
			<td><input type="text"></td>
			</tr>
			
			<tr>
			<td>Public key: </td>
			<td><input type="text"></td>
			</tr>
			
			<tr>
			<td colspan="2"><textarea id="wireguard_file" name="wireguard_file" rows="10"
							cols="100" required style="height: 500px;"></textarea></td>
			</tr>
			
			
			</table>
			
			<div class="row" style="display: flex; justify-content: center; margin-bottom: 2%; margin-top: 1%;">
					
					 <input style="height: 26px;" type="button" value="Update" id="update"/> 
					
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
				  <p>Your session is timeout. Please login again</p>
				  <button id="confirm-button-session-timeout">OK</button>
				</div>
			  </div>
			  
			</section>
			</div>

</body>
</html>