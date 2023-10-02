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

<style>/* Styles for the circular toggle switch */
/* Style for the container */
        .toggle-container {
            display: inline-block;
            position: relative;
            width: 59px;
            height: 30px;
            background-color: #ccc;
            border-radius: 15px; /* Half of the height for circular edges */
            cursor: pointer;
        }

        /* Style for the switch (circle) */
        .toggle-switch {
            position: absolute;
            top: 2px;
            left: 2px;
            width: 26px; /* Width of the circle */
            height: 26px; /* Height of the circle */
            background-color: #fff;
            border-radius: 50%; /* Makes it circular */
            transition: 0.3s; /* Smooth transition */
        }

        /* Style for the checked state */
        .toggle-container.active .toggle-switch {
            left: 32px; /* Move the circle to the right */
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

</style>


<!-- <script>

 function updateTOTP(){
	
	// Display the custom modal dialog
	  var modal = document.getElementById('custom-modal-edit');
	  modal.style.display = 'block';
	  
	// Handle the confirm button click
	  var confirmButton = document.getElementById('confirm-button-edit');
	  confirmButton.onclick = function () {
		  
		  var toggleContainer = document.querySelector('.toggle-container');

		   toggleContainer.addEventListener('click', function () {
		        toggleSwitch(this);
		        // Get the current state of the toggle (enabled/disabled)
		        var isActive = toggleContainer.classList.contains('active');
		        
		        
		        alert('toggle state : '+isActive);
		        $.ajax({
		        	url : 'TOTPServlet',
					type : 'POST',
					data : {
						toggleState: isActive 
						
					},
					success : function(data) {
						// Close the modal
				        modal.style.display = 'none';
						
					}
		    		
		    	});
		    	
		        
		  
		   });
		  
	  };
	  
	  var cancelButton = document.getElementById('cancel-button-edit');
	  cancelButton.onclick = function () {
	    // Close the modal
	    modal.style.display = 'none';
	   
	  }; 
	
 }
	
</script> -->

<script>

var isActive;
        
        
        function updateTOTP(element){
        	
        	 element.classList.toggle('active');
             
             var toggleContainer = document.querySelector('.toggle-container');
             isActive = toggleContainer.classList.contains('active');
             
             if (isActive) {
                 // Toggle switch is enabled
                 sendDataToServlet("enable");
                 alert('Toggle switch is enabled');
             } else {
                 // Toggle switch is disabled
                 sendDataToServlet("disable");
                 alert('Toggle switch is disabled');
             }
        }
        
        function sendDataToServlet(status) {
            $.ajax({
                type: "POST",
                url: "TOTPServlet",
                data: { 
                	status: status 
                	}, // Send the status to the servlet
                success: function(response) {
                    // Handle the response from the servlet if needed
                    console.log("Data sent successfully");
                },
                error: function(xhr, textStatus, errorThrown) {
                    // Handle any errors that occur during the AJAX request
                    console.error("Error sending data: " + errorThrown);
                }
            });
        }
        
        $(document).ready(function() {
        	
        	$('.toggle-container').click(function() {
        		updateTOTP(this);
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
			<h3>TWO FACTOR AUTHENTICATION</h3>
			<hr>
			
			<div class="container">
			
			<input type="hidden" id="action" name="action" value="">
			
			<div class="toggle-container">
        		<!-- The switch (circle) -->
        	<div class="toggle-switch"></div>
    		</div>
			 	
			</div>
			
			<div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to edit the TOTP authentication?</p>
				  <button id="confirm-button-edit">Yes</button>
				  <button id="cancel-button-edit">No</button>
				</div>
			  </div>
			
		</section>
	</div>
	
</body>
</html>