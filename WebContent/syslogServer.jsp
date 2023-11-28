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

.bordered-table {
	border-collapse: collapse; /* Optional: To collapse table borders */
	margin: 0 auto; /* Center the table horizontally */
	width: 100%; /* Full width for responsiveness */
}

.bordered-table td {
	border: 1px solid #ccc; /* Light gray border */
}

.container {
	margin: 0 auto;
	max-width: 50%;
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

</style>

<script>

var roleValue;	
var tokenValue;

function changeButtonColor(isDisabled) {
    var $applyBtn = $('#applyBtn');       
    
    if (isDisabled) {
        $applyBtn.css('background-color', 'gray'); // Change to your desired color
    } else {
        $applyBtn.css('background-color', '#2b3991'); // Reset to original color
    }   
}

$(document).ready(function() {
	<%// Access the session variable
	HttpSession role = request.getSession();
	String roleValue = (String) session.getAttribute("role");%>

roleValue = '<%=roleValue%>';

if (roleValue == 'OPERATOR' || roleValue == 'Operator') {

	$('#applyBtn').prop('disabled', true);
	
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
}else{
	<%// Access the session variable
	HttpSession token = request.getSession();
	String tokenValue = (String) session.getAttribute("token");%>

tokenValue = '<%=tokenValue%>';

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
			<h3>SYSLOG CONFIGURATION</h3>
			<hr>

			<div class="container">
				<form id="settingsForm">
					<table class="bordered-table" style="margin-top: -1px;">
						<tr>
							<td>Hostname</td>
							<td><input type="text" id="hostname" maxlength="31" name="hostname" required /></td>
							
							<td>Protocol</td>
							<td><select class="textBox" id="protocol" name="protocol" style="height: 33px;">
							<option value="Select protocol">Select protocol</option>
							<option value="TCP" selected="selected">TCP</option>
							<option value="UDP">UDP</option>
						</select></td>
						
							<td>Port</td>
							<td><input type="text" id="port_number" name="port_number" maxlength="6" required /></td>
						</tr>

					</table>

					<div class="row"
						style="display: flex; justify-content: center; margin-bottom: 2%; margin-top: 1%;">
						<input style="height: 26px;" type="button" value="Apply"
							id="applyBtn" />

					</div>
				</form>
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