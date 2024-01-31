<%  
    // Add X-Frame-Options header to prevent clickjacking
    response.setHeader("X-Frame-Options", "DENY");
response.setHeader("X-Content-Type-Options", "nosniff");

%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png" />

<link rel="stylesheet" href="css_files/ionicons.min.css">
<link rel="stylesheet" href="css_files/normalize.min.css">
<link rel="stylesheet" href="css_files/fonts.txt" type="text/css">	
<link rel="stylesheet" href="nav-bar.css" />
<script src="jquery-3.6.0.min.js"></script>

<style>
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
	text-align: center; /* Center-align the content */
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

.data-table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 20px;
}

.data-table th, .data-table td {
	border: 1px solid #ddd;
	padding: 8px;
	text-align: left;
}

.data-table th {
	background-color: #f2f2f2;
}

h3 {
    color: #2b3991;
    margin-bottom: 10px;
    font-size: 18px;
    margin-left: 5px;
    /* margin-top: -22px; */
}


 button {
            cursor: pointer;
            border-radius: 5px;
            border: none;
         
            font-size: small;
            margin-right: 10px;
             padding: 10px 20px;
        }
.table-container {
  display: flex;
  flex-wrap: wrap;
}

/* Updated styles for individual tables */
.white-list,
.black-list {
  border: 0.5px solid black;
  flex: 1;
  margin-right: 20px;
  margin-bottom: 20px;
  margin-left: 5px;
  width: calc(50% - 12.5px);
  overflow-x: auto; /* Add horizontal scroll for small screens */
}

/* Adjust the width of each column */
.white-list th,
.white-list td,
.black-list th,
.black-list td {
  min-width: 100px; /* Set the desired column width */
  max-width: 200px; /* Set the desired column width */
  word-wrap: break-word; /* Allow text to wrap in case it's too long */
}

.green-text {
	color: green;
}

.red-text {
	color: red;
}

.button-container {
            display: flex;
            justify-content: flex-end;
            margin: 10px; /* Add margin as needed */
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
<script>

var roleValue;
var tokenValue;
var csrfTokenValue;

function getProcessData() {
	// Display loader when the request is initiated
    showLoader();
	
    var csrfToken = document.getElementById('csrfToken').value;
	$.ajax({
        url: "processGetData", // URL to your servlet or server endpoint
        type: "POST", // Change the request type to POST
        data: {
        	process_type: "process_list" ,
        	csrfToken: csrfToken
        	}, // Pass the process_type parameter
        beforeSend: function(xhr) {
            xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
        },
        success: function(data) {
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
        	
			
            populateTable(data.white_list_process, "white_list_table");
            populateTable(data.black_list_process, "black_list_table");
            
            if (roleValue === 'OPERATOR' || roleValue === 'Operator') {
                $('#loadLogFileButton').prop('disabled', true);
                changeButtonColor(true);
            }
        },
        error: function(xhr, status, error) {
        	// Hide loader when the response has arrived
            hideLoader();
        	
            console.error("Error occurred: " + error);
            // Handle the error here (show error message to the user, etc.)
        }
    });
}

    $("#closePopup").click(function () {
        $("#customPopup").hide();
    });

    function populateTable(data, tableId) {
        var tableBody = $("#" + tableId + "_body");
        tableBody.empty();
        var textColorClass = (tableId === "white_list_table") ? "green-text" : "red-text";

        if (data && Array.isArray(data)) {
            data.forEach(function (row) {
                var tableRow = $("<tr>");
                Object.keys(row).forEach(function (key) {
                    var cellValue = row[key];
                    var cell;

                    if (key === "COMMAND") {
                        // Modify the appearance of COMMAND based on table type
                        var modifiedCommand = cellValue;
                        if (tableId === "white_list_table" || tableId === "black_list_table") {
                        	 if (cellValue.length > 20 && cellValue.length <= 30) {
                                 modifiedCommand = cellValue.substring(0, 20) + "..........";
                             } else if (cellValue.length > 30) {
                                 modifiedCommand = cellValue.substring(0, 30) + "..........";
                             }
                            modifiedCommand = modifiedCommand.replace(/^\[(.*?)\]$/, "$1");                          
                            modifiedCommand = modifiedCommand.replace(/[{}]/g, ''); // Remove curly braces
                            
                        } else {
                            modifiedCommand = "[" + cellValue + "]";
                        }
                        cell = $("<td>").text(modifiedCommand).addClass(textColorClass);
                    }  
                    else {
                        cell = $("<td>").text(cellValue).addClass(textColorClass);
                    }

                    tableRow.append(cell);
                });
                tableBody.append(tableRow);
            });
        }
    }

	function changeButtonColor(isDisabled) {
        var $load_button = $('#loadLogFileButton');
        
        if (isDisabled) {
            $load_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $load_button.css('background-color', '#2b3991'); // Reset to original color
        }
	}
	
	// Function to show the loader
	 function showLoader() {
	     // Show the loader overlay
	     $('#loader-overlay').show();
	 }

	 // Function to hide the loader
	 function hideLoader() {
	     // Hide the loader overlay
	     $('#loader-overlay').hide();
	 }
	
	//Function to execute on page load
	$(document).ready(function() {
		// Load log file list
		
		<%// Access the session variable
			HttpSession role = request.getSession();
			String roleValue = (String) session.getAttribute("role");%>
	    	    	
	    	    	roleValue = '<%=roleValue%>'; 
	    	    	
	    	    	<%// Access the session variable
	    			HttpSession csrfToken = request.getSession();
	    			String csrfTokenValue = (String) session.getAttribute("csrfToken");%>

	    			csrfTokenValue = '<%=csrfTokenValue%>';
	    	    	
						if (roleValue == 'OPERATOR' || roleValue == 'Operator') {

							$('#loadLogFileButton').prop('disabled', true);

							changeButtonColor(true);
						}
						
						if (roleValue === "null") {
					        var modal = document.getElementById('custom-modal-session-timeout');
					        modal.style.display = 'block';
					        
					        // Update the session-msg content with the message from the server
						    var sessionMsg = document.getElementById('session-msg');
						    sessionMsg.textContent = 'You are not allowed to redirect like this !!'; 

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
					    	    	
					    	    	getProcessData();
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
			<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>
<input type="hidden" name="csrfToken" id="csrfToken" value="<%= csrfTokenValue %>" />
		
		<div class="button-container">
        <button onClick="window.location.reload();" style="color:white; background-color: #2b3991">Reload</button>
    </div>
    
			<h3 style="margin-top: -8px;">Process</h3>
			<hr />

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
			
			

			<div class="table-container" style="display: flex;">
				<!-- White List Table -->
				<div class="white-list">
					<h3>White List Process</h3>
					<table id="white_list_table">
						<colgroup>
							<col style="width: 10%;">
							<!-- Adjust the width as needed -->
							<col style="width: 20%;">
							<!-- Adjust the width as needed -->
							<col style="width: 30%;">
							<!-- Adjust the width as needed -->
							<col style="width: 10%;">
							<!-- Adjust the width as needed -->
						</colgroup>
						<thead>
							<tr>
								<th>PID</th>
								<th>Time</th>
								<th>Command</th>
								<th>User</th>
							</tr>
						</thead>
						<tbody id="white_list_table_body"></tbody>
					</table>

				</div>

				<!-- Black List Table -->
				<div class="black-list">
					<h3>Black List Process</h3>
					<table id="black_list_table">
						<colgroup>
							<col style="width: 10%;">
							<!-- Adjust the width as needed -->
							<col style="width: 20%;">
							<!-- Adjust the width as needed -->
							<col style="width: 30%;">
							<!-- Adjust the width as needed -->
							<col style="width: 10%;">
							<!-- Adjust the width as needed -->
						</colgroup>
						<thead>
							<tr>
								<th>PID</th>
								<th>Time</th>
								<th>Command</th>
								<th>User</th>
							</tr>
						</thead>
						<tbody id="black_list_table_body"></tbody>
					</table>
				</div>
			</div>
		</section>
	</div>

	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>


</html>