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
</style>

<script>
	function updateSettings() {
		// Display the custom modal dialog
		var modal = document.getElementById('custom-modal-edit');
		modal.style.display = 'block';

		// Handle the confirm button click
		var confirmButton = document.getElementById('confirm-button-edit');
		confirmButton.onclick = function() {

			var toggle_enable_ftp = $("#toggle_enable_ftp").prop("checked") ? "1": "0";
			var toggle_enable_ssh = $("#toggle_enable_ssh").prop("checked") ? "1": "0";
			var toggle_enable_usbtty = $("#toggle_enable_usbtty").prop("checked") ? "1" : "0";
			var lan_type = 'general';

			$.ajax({

				url : 'updateSettings',
				type : 'POST',
				data : {
					toggle_enable_ftp : toggle_enable_ftp,
					toggle_enable_ssh : toggle_enable_ssh,
					toggle_enable_usbtty : toggle_enable_usbtty,
					lan_type : lan_type

				},
				success : function(data) {
					
					var json1 = JSON.stringify(data);

					var json = JSON.parse(json1);

					if (json.status == 'fail') {
						var modal1 = document.getElementById('custom-modal-session-timeout');
						  modal1.style.display = 'block';
						  
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

				},
				error : function(xhr, status, error) {
					console.log('Error updating settings : ' + error);
				}
			});

		};

		var cancelButton = document.getElementById('cancel-button-edit');
		cancelButton.onclick = function() {
			// Close the modal
			modal.style.display = 'none';

		};
	}
	
	$(document).ready(function() {
		$('#applyBtn').click(function() {
			updateSettings();

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
			<h3>SETTINGS</h3>
			<hr>

			<div class="container">

				<form id="settingsForm">
					<table class="bordered-table" style="margin-top: -1px;">
						<tr>
							<td>FTP</td>
							<td><label class="toggle"> <input
									id="toggle_enable_ftp" name="toggle_enable_ftp"
									class="toggle-input" type="checkbox"> <span
									class="toggle-label" data-off="OFF" data-on="ON"></span> <span
									class="toggle-handle"></span>
							</label></td>
							<td>SSH</td>
							<td><label class="toggle"> <input
									id="toggle_enable_ssh" name="toggle_enable_ssh"
									class="toggle-input" type="checkbox"> <span
									class="toggle-label" data-off="OFF" data-on="ON"></span> <span
									class="toggle-handle"></span>
							</label></td>
							<td>USBTTY</td>
							<td><label class="toggle"> <input
									id="toggle_enable_usbtty" name="toggle_enable_usbtty"
									class="toggle-input" type="checkbox"> <span
									class="toggle-label" data-off="OFF" data-on="ON"></span> <span
									class="toggle-handle"></span>
							</label></td>
						</tr>

					</table>

					<div class="row"
						style="display: flex; justify-content: center; margin-bottom: 2%; margin-top: 1%;">
						<input style="height: 26px;" type="button" value="Apply"
							id="applyBtn" />

					</div>
				</form>
			</div>

			<div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
					<p>Are you sure you want to modfiy this lan setting?</p>
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