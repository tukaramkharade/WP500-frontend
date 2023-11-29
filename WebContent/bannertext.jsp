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

<script type="text/javascript">

function readBannerText(){
	$.ajax({
		url : "bannerTextServlet",
		type : "GET",
		dataType : "json",
		success : function(data) {
			// Assuming data.banner_text_data is an array, join it to create a string
            var textToShow = data.banner_text_data.join('\n');

            // Set the text in the textarea
            $('#banner_text').val(textToShow);
		},
		error : function(xhr, status, error) {
			console.log("Error showing banner text data : " + error);
		},
	});
}

function updateBannerText(){
	
	// Get the textarea value
    var textareaValue = $('#bannerForm textarea').val();

    // Split the textarea value into an array using the newline character ("\n")
    var data = textareaValue.split('\n');

    // Display the array in the console (you can replace this with your update logic)
    alert("Data Array: " + data.join(', '));
    console.log(data);
    
    $.ajax({
             url: 'bannerTextServlet',
             type : "POST",
             contentType: 'application/json', // Specify the content type
             data: JSON.stringify({ data: data }),
             success: function(response) {
                 alert("Update successful:", response);
                 readBannerText();
             },
             error: function(error) {
                 console.log("Error updating data:", error);
             }
         });
    
}

$(document).ready(function() {
	readBannerText();
	
	$('#update').click(function () {
		updateBannerText();
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
			<h3>BANNER TEXT</h3>
			<hr>
			<div class="container">
			
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
				  <p>Are you sure you want to modify this mqtt setting?</p>
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