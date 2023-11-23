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
}

.bordered-table td {
	border: 1px solid #ccc; /* Light gray border */
}

.delete-icon-td {
	cursor: pointer;
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

button {
	margin: 5px;
	padding: 10px 20px;
	border: none;
	cursor: pointer;
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

function generateCertificate(){
	
	var common_name = $('#common_name').val();
	var organization = $('#organization').val();
	var organizational_unit = $('#organizational_unit').val();
	var location = $('#location').val();
	var state = $('#state').val();
	var country = $('#country').val();
	var validity = $('#validity').val();
	
	// Collect IP addresses and DNS names into arrays
    var ipAddresses = [];
    var dnsNames = [];
    
    $('select[name="sub-alt-type"]').each(function() {
        var selectValue = $(this).val();
        var input = $(this).closest('tr').find('input[name="alt-name"]').val();
        
        if (selectValue === 'IP address' && input) {
            ipAddresses.push(input);
        } else if (selectValue === 'DNS name' && input) {
            dnsNames.push(input);
        }
    });
    
 // Convert IP addresses and DNS names arrays to JSON strings
    var ipAddressesJson = JSON.stringify(ipAddresses);
    var dnsNamesJson = JSON.stringify(dnsNames);
	
	$.ajax({
		url : 'CertificateServlet',
		type : 'POST',
		data : {
			common_name : common_name,
			organization : organization,
			organizational_unit : organizational_unit,
			state : state,
			location : location,
			country : country,
			validity : validity,
			ipAddresses: ipAddressesJson,
            dnsNames: dnsNamesJson
			
			
		},
		dataType: 'json', // Specify the expected data type as JSON
		 
		success : function(data) {
			
			
			// Display the custom popup message
 			$("#popupMessage").text(data.message);
  			$("#customPopup").show();
	
	        
			$('#common_name').val('');
		    $('#organization').val('');
		    $('#organizational_unit').val('');
		    $('#state').val('');
		    $('#location').val('');
		    $('#country').val('');
		    $('#validity').val('');
		    $('input[name="alt-name"]').val('');
	        $('select[name="sub-alt-type"]').val('Select type of subject alternative name');

	        
	     // Remove extra rows for IP addresses except the first one
	        $('tr:has(td:has(select[name="sub-alt-type"][value="IP address"])):gt(0)').remove();

	        // Remove extra rows for DNS names except the first one
	        $('tr:has(td:has(select[name="sub-alt-type"][value="DNS name"])):gt(0)').remove();
	    
	        

		},
		error : function(xhr, status, error) {
			console.log('Error generating certificate: ' + error);
		}
	});
	
	$("#closePopup").click(function () {
	    $("#customPopup").hide();
	  });
	
}

function applyCertificate(){
	
	$.ajax({
		
		type : "GET",
		url : "CertificateServlet", // Replace with the actual URL to retrieve TOTP details
		dataType : "json",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
	    },
	    success : function(data) {
			
			var json1 = JSON.stringify(data);

			var json = JSON.parse(json1);

			if (json.status == 'fail') {
				
				 var modal = document.getElementById('custom-modal-session-timeout');
				  modal.style.display = 'block';
				  
				  // Handle the confirm button click
				  var confirmButton = document.getElementById('confirm-button-session-timeout');
				  confirmButton.onclick = function () {
					  
					// Close the modal
				        modal.style.display = 'none';
				        window.location.href = 'login.jsp';
				  };
					  
			}
			
			// Display the custom popup message
 			$("#popupMessage").text(data.message);
  			$("#customPopup").show();
			
	    },
	    error : function(xhr, textStatus, errorThrown) {
			console.error("Error appying certificate: " + errorThrown);
		}
	    
	});
	
	$("#closePopup").click(function () {
	    $("#customPopup").hide();
	  });
}

$(document).ready(function () {
	
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
}else{
	<%// Access the session variable
			HttpSession token = request.getSession();
			String tokenValue = (String) session.getAttribute("token");%>

	tokenValue = '<%=tokenValue%>';

							$("#identity-store")
									.change(
											function() {
												var selectedValue = $(this)
														.val();
												if (selectedValue === "OPC UA-self-signed") {
													// If "OPC UA-self-signed" is selected, hide Self-signed HTTPS Certificate row
													$(
															"#self-signed-https-certificate-row")
															.hide();
													// Show the warning row
													$("#warning-row").show();
												} else if (selectedValue === "HTTPS-self-signed") {
													// If "OPC UA-self-signed" is selected, hide Self-signed HTTPS Certificate row
													$(
															"#self-signed-https-certificate-row")
															.show();
													// Show the warning row
													$("#warning-row").show();
												}
											});

							// Trigger the change event on page load to handle the initial selection
							$("#identity-store").trigger("change");

							var ipAddresses = [];
							var dnsNames = [];

							var addBtn = document.getElementById('addBtn');
							addBtn
									.addEventListener(
											'click',
											function() {
												var newRow = document
														.createElement('tr');

												// Create the first cell with an input element
												var cell1 = document
														.createElement('td');
												var input = document
														.createElement('input');
												input.type = 'text';
												input.id = 'alt-name';
												input.name = 'alt-name';
												input.style.height = '10px';
												cell1.appendChild(input);

												// Create the second cell with a select element
												var cell2 = document
														.createElement('td');
												var select = document
														.createElement('select');
												select.className = 'textbox';
												select.id = 'sub-alt-type';
												select.name = 'sub-alt-type';
												select.style.height = '34px';
												select.required = true;
												var option1 = document
														.createElement('option');
												option1.value = 'Select type of subject alternative name';
												option1.textContent = 'Select type of subject alternative name';
												var option2 = document
														.createElement('option');
												option2.value = 'IP address';
												option2.textContent = 'IP address';
												var option3 = document
														.createElement('option');
												option3.value = 'DNS name';
												option3.textContent = 'DNS name';
												select.appendChild(option1);
												select.appendChild(option2);
												select.appendChild(option3);
												cell2.appendChild(select);

												// Create the third cell with a delete button
												var cell3 = document
														.createElement('td');
												var deleteBtn = document
														.createElement('input');
												deleteBtn.type = 'button';
												deleteBtn.value = 'X';
												deleteBtn.className = 'deleteBtn';
												deleteBtn.style.height = '22px';
												deleteBtn.title = 'Remove subject alternative name';
												deleteBtn.addEventListener(
														'click', function() {
															newRow.remove();
														});
												cell3.appendChild(deleteBtn);

												// Add the cells to the new row
												newRow.appendChild(cell1);
												newRow.appendChild(cell2);
												newRow.appendChild(cell3);

												// Insert the new row before the addBtn
												var table = addBtn.parentNode.parentNode.parentNode;
												table
														.insertBefore(
																newRow,
																addBtn.parentNode.parentNode);

											});

							$('#regenerateBtn').click(function() {
								generateCertificate();
							});

							$('#apply').click(function() {
								applyCertificate();
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

			<h3>GENERATE CERTIFICATE</h3>
			<hr />

			<div class="container">
				<form id="certificateForm" style="margin-top: 0">

					<table class="bordered-table">
						<tr>
							<th colspan="2">Security Certificate</th>
						</tr>

						<tr>
							<td>Identity Store</td>
							<td><select class="identity-store" id="identity-store"
								name="identity-store" style="height: 34px; width: 20%;" required>
									<option value="Select identity store">Select identity
										store</option>
									<option value="HTTPS-self-signed">HTTPS-self-signed</option>
									<option value="OPC UA-self-signed" selected="selected">OPC
										UA-self-signed</option>
							</select></td>
						</tr>

						<tr id="self-signed-https-certificate-row">
							<td>Self-Signed HTTPS certificate</td>
							<td>
								<table class="inside-table">
									<tr>
										<th colspan="2">Distinguished name</th>
									</tr>

									<tr>
										<td>Common name</td>
										<td><input type="text" id="common_name"
											name="common_name" style="height: 10px;" /></td>
									</tr>

									<tr>
										<td>Organization</td>
										<td><input type="text" id="organization"
											name="organization" style="height: 10px;" /></td>
									</tr>

									<tr>

										<td>Organizationl unit</td>
										<td><input type="text" id="organizational_unit"
											name="organizational_unit" style="height: 10px;" /></td>
									</tr>

									<tr>
										<td>Location</td>
										<td><input type="text" id="location" name="location"
											style="height: 10px;" /></td>
									</tr>

									<tr>
										<td>State</td>
										<td><input type="text" id="state" name="state"
											style="height: 10px;" /></td>
									</tr>

									<tr>
										<td>Country</td>
										<td><input type="text" id="country" name="country"
											style="height: 10px;" /></td>
									</tr>

									<tr>
										<th colspan="2">Validity</th>
									</tr>

									<tr>
										<td>Validity not after</td>
										<td><input type="text" id="validity" name="validity"
											style="height: 10px; width: 20%;" /> (in days)</td>
									</tr>

									<tr>
										<th colspan="2">Subject alternative names</th>
									</tr>

									<tr>
										<th>Subject alternative name</th>
										<th>Type of subject alternative name</th>
										<th></th>
									</tr>

									<tr>
										<td><input type="text" id="alt-name" name="alt-name"
											style="height: 10px;" /></td>
										<td><select class="textbox" id="sub-alt-type"
											name="sub-alt-type" style="height: 34px;" required>
												<option value="Select type of subject alternative name">Select
													type of subject alternative name</option>
												<option value="IP address">IP address</option>
												<option value="DNS name">DNS name</option>
										</select></td>
										<td><input type="button" value="X" id="deleteBtn"
											style="height: 22px;" title="Remove subject alternative name" /></td>
									</tr>
									<tr>
										<td><input type="button" value="+" id="addBtn"
											style="height: 22px;" title="Add subject alternative name" /></td>
									</tr>


									<tr>
										<td colspan="3"><input
											style="height: 26px; margin-top: 15px; margin-bottom: 15px;"
											type="button" value="Re-generate HTTPS certificate"
											id="regenerateBtn" /></td>
									</tr>

									<tr>
										<td colspan="3">If you click the "Generate" button, the
											self-signed HTTPS certificate is only regenerated. <br>
											So that the certificate can be activated in the system, you
											must then press the "Apply" button when IdentityStore
											"HTTPS-self-signed" is selected.
										</td>
									</tr>
								</table>

							</td>
						</tr>

						<tr id="warning-row" style="display: none;">
							<td>Warning</td>
							<td style="color: red;">Applying the configuration can
								affect the real-time behavior of the system. Avoid
								reconfiguration during productive operation!</td>
						</tr>
					</table>

					<div class="row"
						style="display: flex; justify-content: right; margin-top: 2%;">
						<input type="button" value="Apply" id="apply"
							style="margin-bottom: 10px;" />

					</div>

				</form>
			</div>

			<div id="custom-modal-session-timeout" class="modal-session-timeout">
				<div class="modal-content-session-timeout">
					<p>Your session is timeout. Please login again</p>
					<button id="confirm-button-session-timeout">OK</button>
				</div>
			</div>

			<div id="customPopup" class="popup">
				<span class="popup-content" id="popupMessage"></span>
				<button id="closePopup">OK</button>
			</div>
		</section>
	</div>

	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>

</body>
</html>