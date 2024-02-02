<%
    response.setHeader("X-Frame-Options", "DENY");
    response.setHeader("X-Content-Type-Options", "nosniff");
    HttpSession session1 = request.getSession();
    String secureFlag = "Secure";
    String httpOnlyFlag = "HttpOnly";
    String sameSiteFlag = "SameSite=None"; 
    String cookieValue = session1.getId();
    String headerKey = "Set-Cookie";
    String headerValue = String.format("%s=%s; %s; %s; %s", session1.getId(), cookieValue, secureFlag, httpOnlyFlag, sameSiteFlag);
    response.setHeader(headerKey, headerValue);
%>

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

function getKeys(){
    showLoader();
    var csrfToken = document.getElementById('csrfToken').value;
	$.ajax({
		url : "wireguardKeysServlet",
		type : "GET",
		dataType : "json",
		 data: {
	            action: "get",
	            csrfToken: csrfToken
	        },
		success : function(data) {			
            hideLoader();			
			$('#private_key').val(data.private_key);
			$('#public_key').val(data.public_key);           
		},
		error : function(xhr, status, error) {
            hideLoader();		
		},
	});
}

function readWireguardFile(){
	var csrfToken = document.getElementById('csrfToken').value;
	
	$.ajax({
		url : "wireguardServlet",
		type : "GET",
		dataType : "json",
		data: {
			csrfToken: csrfToken
        },
		success : function(data) {			
			if (data.status == 'fail') {				
				 var modal = document.getElementById('custom-modal-session-timeout');
				 modal.style.display = 'block';				  
				 var sessionMsg = document.getElementById('session-msg');
				 sessionMsg.textContent = data.message; // Assuming data.message contains the server message				  
				 var confirmButton = document.getElementById('confirm-button-session-timeout');
				 confirmButton.onclick = function () {					  
				        modal.style.display = 'none';
				        window.location.href = 'login.jsp';
				 };					  
			} 		
            var textToShow = data.wireguard_file_data.join('\n');
            $('#wireguard_file').val(textToShow);            
		},
		error : function(xhr, status, error) {			
		},		
	});
}

function generateWireguardKeys(){
	var csrfToken = document.getElementById('csrfToken').value;
	
	$.ajax({
		url : "wireguardKeysServlet",
		type : "GET",
		dataType : "json",
		 data: {
	            action: "generate_keys",
	            csrfToken: csrfToken
	        },
		success : function(data) {
			if (data.status == 'fail') {				
				 var modal = document.getElementById('custom-modal-session-timeout');
				 modal.style.display = 'block';			  
				 var sessionMsg = document.getElementById('session-msg');
				 sessionMsg.textContent = data.message; // Assuming data.message contains the server message		  
				 var confirmButton = document.getElementById('confirm-button-session-timeout');
				 confirmButton.onclick = function () {					  
				        modal.style.display = 'none';
				        window.location.href = 'login.jsp';
				 };					  
			} 			
			$('#private_key').val(data.private_key);
			$('#public_key').val(data.public_key);          
		},
		error : function(xhr, status, error) {			
		},
	});
}

function activateWireguard() {
	var csrfToken = document.getElementById('csrfToken').value;
	
    $.ajax({
        url: "wireguardKeysServlet",
        type: "GET",
        dataType: "json",
        data: {
            action: "activate_wireguard",
            csrfToken: csrfToken
        },
        success: function (data) {
        	if (data.status == 'fail') {				
				 var modal = document.getElementById('custom-modal-session-timeout');
				 modal.style.display = 'block';				  
				 var sessionMsg = document.getElementById('session-msg');
				 sessionMsg.textContent = data.message; // Assuming data.message contains the server message			  
				 var confirmButton = document.getElementById('confirm-button-session-timeout');
				 confirmButton.onclick = function () {					  
				        modal.style.display = 'none';
				        window.location.href = 'login.jsp';
				 };				  
			} 
            if (Array.isArray(data.activate_wireguard_result)) {
                var resultMessage = data.activate_wireguard_result.join('<br>');              
                $("#popupMessage").html(resultMessage);
                $("#customPopup").show();
            } else {            
            }
        },
        error: function (xhr, status, error) {          
        },
    });
    $("#closePopup").click(function () {
        $("#customPopup").hide();
    });
}

function deActivateWireguard(){
	var csrfToken = document.getElementById('csrfToken').value;
	$.ajax({
        url: "wireguardKeysServlet",
        type: "GET",
        dataType: "json",
        data: {
            action: "deactivate_wireguard",
            csrfToken: csrfToken
        },
        success: function (data) {
        	if (data.status == 'fail') {			
				 var modal = document.getElementById('custom-modal-session-timeout');
				 modal.style.display = 'block';
				 var sessionMsg = document.getElementById('session-msg');
				 sessionMsg.textContent = data.message; // Assuming data.message contains the server message			  
				 var confirmButton = document.getElementById('confirm-button-session-timeout');
				 confirmButton.onclick = function () {					  
				        modal.style.display = 'none';
				        window.location.href = 'login.jsp';
				 };				  
			} 
            if (Array.isArray(data.deactivate_wireguard_result)) {
                var resultMessage = data.deactivate_wireguard_result.join('<br>');              
                $("#popupMessage").html(resultMessage);
                $("#customPopup").show();
            } else {              
            }
        },
        error: function (xhr, status, error) {           
        },
    });
    $("#closePopup").click(function () {
        $("#customPopup").hide();
    });
}

function wireguardStatus() {
	var csrfToken = document.getElementById('csrfToken').value;
    $.ajax({
        url: "wireguardKeysServlet",
        type: "GET",
        dataType: "json",
        data: {
            action: "wireguard_status",
            csrfToken: csrfToken
        },
        success: function (data) {
        	if (data.status == 'fail') {			
				 var modal = document.getElementById('custom-modal-session-timeout');
				 modal.style.display = 'block';				  
				 var sessionMsg = document.getElementById('session-msg');
				 sessionMsg.textContent = data.message; // Assuming data.message contains the server message				  
				 var confirmButton = document.getElementById('confirm-button-session-timeout');
				 confirmButton.onclick = function () {					  
				        modal.style.display = 'none';
				        window.location.href = 'login.jsp';
				 };					  
			} 
            if (Array.isArray(data.wireguard_status_result) && data.wireguard_status_result.length > 0) {
                var resultMessage = data.wireguard_status_result.join('<br>');               
                $("#popupMessage").html(resultMessage);
                $("#customPopup").show();
            } else {
                $("#popupMessage").html("No data available.");
                $("#customPopup").show();
            }
        },
        error: function (xhr, status, error) {           
        },
    });
    $("#closePopup").click(function () {
        $("#customPopup").hide();
    });
}

function updateWireguardFile() {
	var csrfToken = document.getElementById('csrfToken').value;
	 var modal = document.getElementById('custom-modal-edit');
	 modal.style.display = 'block';  
	 var confirmButton = document.getElementById('confirm-button-edit');
	 confirmButton.onclick = function () {		  
     var textareaValue = $('#wireguard_file').val();
     var lines = textareaValue.split('\n');
     var linesJson = JSON.stringify(lines);
   $.ajax({
       url: "wireguardServlet",
       type: "POST",          
       data: {
       	lines: linesJson,
			csrfToken: csrfToken
       },
       success: function(response) {
    	   if (response.status == 'fail') {				
				 var modal1 = document.getElementById('custom-modal-session-timeout');
				 modal1.style.display = 'block';				  
				 var sessionMsg = document.getElementById('session-msg');
				 sessionMsg.textContent = response.message; // Assuming data.message contains the server message			  
				 var confirmButton1 = document.getElementById('confirm-button-session-timeout');
				 confirmButton1.onclick = function () {				  
				        modal1.style.display = 'none';
				        window.location.href = 'login.jsp';
				 };				  
			} 
	        modal.style.display = 'none';     	
	        $("#popupMessage").text(response.message);
  			$("#customPopup").show();			       	
	        readWireguardFile();
       },
       error: function(error) {         
       }
   });
   
   $("#closePopup").click(function () {
	    $("#customPopup").hide();
	  });
};

var cancelButton = document.getElementById('cancel-button-edit');
cancelButton.onclick = function () {
 modal.style.display = 'none';
 location.reload();
};	
}

function changeButtonColor(isDisabled) {
    var $update_button = $('#update');       
    var $generate_button = $('#generate_new_key');
    var $activate_button = $('#activate');
    var $deactivate_button = $('#deactivate');
    var $status_button = $('#status');   
    
     if (isDisabled) {
        $update_button.css('background-color', 'gray'); // Change to your desired color
    } else {
        $update_button.css('background-color', '#2b3991'); // Reset to original color
    }    
    if (isDisabled) {
        $generate_button.css('background-color', 'gray'); // Change to your desired color
    } else {
        $generate_button.css('background-color', '#2b3991'); // Reset to original color
    }    
    if (isDisabled) {
        $activate_button.css('background-color', 'gray'); // Change to your desired color
    } else {
        $activate_button.css('background-color', '#2b3991'); // Reset to original color
    }    
    if (isDisabled) {
        $deactivate_button.css('background-color', 'gray'); // Change to your desired color
    } else {
        $deactivate_button.css('background-color', '#2b3991'); // Reset to original color
    }   
    if (isDisabled) {
        $status_button.css('background-color', 'gray'); // Change to your desired color
    } else {
        $status_button.css('background-color', '#2b3991'); // Reset to original color
    } 
}

function showLoader() {
    $('#loader-overlay').show();
}

function hideLoader() {
    $('#loader-overlay').hide();
}

$(document).ready(function() {
	
	<%// Access the session variable
			HttpSession role = request.getSession();
			String roleValue = (String) session.getAttribute("role");%>
roleValue = '<%=roleValue%>';

<%// Access the session variable
HttpSession csrfToken = request.getSession();
String csrfTokenValue = (String) session.getAttribute("csrfToken");%>
csrfTokenValue = '<%=csrfTokenValue%>';
	
if(roleValue == 'OPERATOR' || roleValue == 'Operator'){
	  
	$('#update').prop('disabled', true);
	$('#generate_new_key').prop('disabled', true);
	$('#activate').prop('disabled', true);
	$('#deactivate').prop('disabled', true);
	$('#status').prop('disabled', true);
	changeButtonColor(true);
}

if (roleValue === "null") {
    var modal = document.getElementById('custom-modal-session-timeout');
    modal.style.display = 'block';
    var sessionMsg = document.getElementById('session-msg');
    sessionMsg.textContent = 'You are not allowed to redirect like this !!';    
    var confirmButton = document.getElementById('confirm-button-session-timeout');
    confirmButton.onclick = function() {
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
					<input type="hidden" name="csrfToken" id="csrfToken" value="<%= csrfTokenValue %>" />
					
					<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>
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