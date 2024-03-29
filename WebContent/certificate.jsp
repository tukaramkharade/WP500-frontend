<%
    response.setHeader("X-Frame-Options", "DENY");
    response.setHeader("X-Content-Type-Options", "nosniff");
    HttpSession session1 = request.getSession();
    String secureFlag = "Secure";
    String httpOnlyFlag = "HttpOnly";
    String sameSiteFlag = "SameSite=None"; // Add this line for SameSite attribute
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

.modal-session-timeout,
.modal-apply-certificate {
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

.modal-content-session-timeout,
.modal-content-apply-certificate{
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

#confirm-button-session-timeout,
#confirm-button-apply-certificate {
	background-color: #4caf50;
	color: white;
}

#cancel-button-apply-certificate {
  background-color: #f44336;
  color: white;
}
</style>

<script>
var roleValue;
var tokenValue;
var csrfTokenValue;

function validateName(name) {
    var regex = /^[a-zA-Z][a-zA-Z0-9]*$/;
    if (!regex.test(name)) {
        return 'Invalid common name; symbols not allowed';
    }
    return null; 
}

function validateOrg(org) {
    var regex = /^[a-zA-Z][a-zA-Z0-9]*$/;
    if (!regex.test(org)) {
        return 'Invalid organization name; symbols not allowed';
    }
    return null; 
}

function validateOrgUnit(orgUnit) {
    var regex = /^[a-zA-Z][a-zA-Z0-9]*$/;
    if (!regex.test(orgUnit)) {
        return 'Invalid organizational unit; symbols not allowed';
    }
    return null; 
}

function validateLocation(location) {
    var regex = /^[a-zA-Z][a-zA-Z0-9]*$/;
    if (!regex.test(location)) {
        return 'Invalid location; symbols not allowed';
    }
    return null; 
}

function validateState(state) {
    var regex = /^[a-zA-Z][a-zA-Z0-9]*$/;
    if (!regex.test(state)) {
        return 'Invalid state; symbols not allowed';
    }
    return null; 
}

function validateCountry(country) {
    var regex = /^[a-zA-Z][a-zA-Z0-9]*$/;

    if (!regex.test(country)) {
        return 'Invalid country; symbols not allowed';
    }
    return null; 
}

function validateNumbers(number) {
	const
	numberPattern = /\b\d{1,10}\b/g;
	if (!numberPattern.test(number)) {
		return "Enter validity";	
	} 
		return null;	
}

function generateCertificate(){	
	var common_name = $('#common_name').val();
	var organization = $('#organization').val();
	var organizational_unit = $('#organizational_unit').val();
	var location = $('#location').val();
	var state = $('#state').val();
	var country = $('#country').val();
	var validity = $('#validity').val();
	var csrfToken = document.getElementById('csrfToken').value;	
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
    $('#field_name_Error').text('');
    $('#field_org_Error').text('');
    $('#field_orgunit_Error').text('');
    $('#field_loc_Error').text('');
    $('#field_state_Error').text('');
    $('#field_country_Error').text('');
    $('#field_validity_Error').text('');

    var nameError = validateName(common_name);
    if (nameError) {
        $('#field_name_Error').text(nameError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
        return;
    }
    var orgError = validateOrg(organization);
    if (orgError) {
        $('#field_org_Error').text(orgError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
        return;
    }
    var orgUnitError = validateOrgUnit(organizational_unit);
    if (orgUnitError) {
        $('#field_orgunit_Error').text(orgUnitError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
        return;
    }    
    var locError = validateLocation(location);
    if (locError) {
        $('#field_loc_Error').text(locError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
        return;
    }
    var stateError = validateState(state);
    if (stateError) {
        $('#field_state_Error').text(stateError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
        return;
    }
    var countryError = validateCountry(country);
    if (countryError) {
        $('#field_country_Error').text(countryError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
        return;
    }  
    var validityError = validateNumbers(validity);
    if (validityError) {
        $('#field_validity_Error').text(validityError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
        return;
    }   
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
			csrfToken: csrfToken,
			ipAddresses: ipAddressesJson,
            dnsNames: dnsNamesJson				
		},
		dataType: 'json', // Specify the expected data type as JSON		 
		success : function(data) {					
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
	        $('tr:has(td:has(select[name="sub-alt-type"][value="IP address"])):gt(0)').remove();
	        $('tr:has(td:has(select[name="sub-alt-type"][value="DNS name"])):gt(0)').remove();	    	        
		},
		error : function(xhr, status, error) {			
		}
	});	
	$("#closePopup").click(function () {
	    $("#customPopup").hide();
	  });	
}

function applyCertificate(){	
	  var modal = document.getElementById('custom-modal-apply-certificate');
	  modal.style.display = 'block';	  
	  var confirmButton = document.getElementById('confirm-button-apply-certificate');
	  confirmButton.onclick = function () {		  
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
				 var modal1 = document.getElementById('custom-modal-session-timeout');
				 modal1.style.display = 'block';			  
				 var confirmButton1 = document.getElementById('confirm-button-session-timeout');
				 confirmButton1.onclick = function () {				  
				        modal1.style.display = 'none';
				        window.location.href = 'login.jsp';
				 };					  
			}			
			 modal.style.display = 'none';		 
			 $("#popupMessage").text(data.message);
   			$("#customPopup").show();		 
	    },
	    error : function(xhr, textStatus, errorThrown) {
			console.error("Error appying certificate: " + errorThrown);
		}    
	});
	  };	  
	  var cancelButton = document.getElementById('cancel-button-apply-certificate');
	  cancelButton.onclick = function () {
	    modal.style.display = 'none';	    
	  };		  
	$("#closePopup").click(function () {
	    $("#customPopup").hide();
	  });
}

function changeButtonColor(isDisabled) {
    var $regenerateBtn = $('#regenerateBtn');       
    var $apply_btn = $('#apply');
   
    if (isDisabled) {
        $regenerateBtn.css('background-color', 'gray'); // Change to your desired color
    } else {
        $regenerateBtn.css('background-color', '#2b3991'); // Reset to original color
    } 
    
    if (isDisabled) {
        $apply_btn.css('background-color', 'gray'); // Change to your desired color
    } else {
        $apply_btn.css('background-color', '#2b3991'); // Reset to original color
    }   
}

$(document).ready(function () {
	
	<%// Access the session variable
			HttpSession role = request.getSession();
			String roleValue = (String) session.getAttribute("role");%>

roleValue = '<%=roleValue%>';

<%// Access the session variable
HttpSession csrfToken = request.getSession();
String csrfTokenValue = (String) session.getAttribute("csrfToken");%>

csrfTokenValue = '<%=csrfTokenValue%>';
	

if (roleValue == 'OPERATOR' || roleValue == 'Operator') {

	$('#regenerateBtn').prop('disabled', true);
	$('#apply').prop('disabled', true);
	
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
}else{
	<%// Access the session variable
			HttpSession token = request.getSession();
			String tokenValue = (String) session.getAttribute("token");%>
	tokenValue = '<%=tokenValue%>';

							$("#identity-store").change(function() {
												var selectedValue = $(this).val();
												if (selectedValue === "OPC UA-self-signed") {
													$("#self-signed-https-certificate-row").hide();
													$("#warning-row").show();
												} else if (selectedValue === "HTTPS-self-signed") {
													$("#self-signed-https-certificate-row").show();
													$("#warning-row").show();
												}
											});
							$("#identity-store").trigger("change");
							var ipAddresses = [];
							var dnsNames = [];
							var addBtn = document.getElementById('addBtn');
							addBtn.addEventListener('click',function() {
												var newRow = document.createElement('tr');
												var cell1 = document.createElement('td');
												var input = document.createElement('input');
												input.type = 'text';
												input.id = 'alt-name';
												input.name = 'alt-name';
												input.style.height = '10px';
												cell1.appendChild(input);
												var cell2 = document.createElement('td');
												var select = document.createElement('select');
												select.className = 'textbox';
												select.id = 'sub-alt-type';
												select.name = 'sub-alt-type';
												select.style.height = '34px';
												select.required = true;
												var option1 = document.createElement('option');
												option1.value = 'Select type of subject alternative name';
												option1.textContent = 'Select type of subject alternative name';
												var option2 = document.createElement('option');
												option2.value = 'IP address';
												option2.textContent = 'IP address';
												var option3 = document.createElement('option');
												option3.value = 'DNS name';
												option3.textContent = 'DNS name';
												select.appendChild(option1);
												select.appendChild(option2);
												select.appendChild(option3);
												cell2.appendChild(select);
												var cell3 = document.createElement('td');
												var deleteBtn = document.createElement('input');
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
												newRow.appendChild(cell1);
												newRow.appendChild(cell2);
												newRow.appendChild(cell3);
												var table = addBtn.parentNode.parentNode.parentNode;
												table
														.insertBefore(newRow, addBtn.parentNode.parentNode);
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
		<input type="hidden" name="csrfToken" id="csrfToken" value="<%= csrfTokenValue %>" />	
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
									<option value="Select identity store">Select identity store</option>
									<option value="HTTPS-self-signed">HTTPS-self-signed</option>
									<option value="OPC UA-self-signed" selected="selected">OPC UA-self-signed</option>
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
										<td style="height: 50px;">
										<input type="text" id="common_name" name="common_name" style="height: 10px;" required/>
											<span id="field_name_Error" class="error-message" style="display: block; margin-top: 5px;"></span>
											</td>
									</tr>
									<tr>
										<td>Organization</td>
										<td style="height: 50px;">
										<input type="text" id="organization" name="organization" style="height: 10px;" required/>
											<span id="field_org_Error" class="error-message" style="display: block; margin-top: 5px;"></span>
											</td>
									</tr>
									<tr>
										<td>Organizational unit</td>
										<td style="height: 50px;">
										<input type="text" id="organizational_unit" name="organizational_unit" style="height: 10px;" required/>
											<span id="field_orgunit_Error" class="error-message" style="display: block; margin-top: 5px;"></span>
											</td>										
									</tr>
									<tr>
										<td>Location</td>
										<td style="height: 50px;">
										<input type="text" id="location" name="location" style="height: 10px;" required/>
										<span id="field_loc_Error" class="error-message" style="display: block; margin-top: 5px;"></span>
										</td>
									</tr>
									<tr>
										<td>State</td>
										<td style="height: 50px;">
										<input type="text" id="state" name="state" style="height: 10px;" required/>
										<span id="field_state_Error" class="error-message" style="display: block; margin-top: 5px;"></span>
										</td>
									</tr>
									<tr>
										<td>Country</td>
										<td style="height: 50px;">
										<input type="text" id="country" name="country" style="height: 10px;" required/>
										<span id="field_country_Error" class="error-message" style="display: block; margin-top: 5px;"></span>
										</td>
									</tr>
									<tr>
										<th colspan="2">Validity</th>
									</tr>
									<tr>
										<td>Validity not after</td>
										<td style="height: 50px;">
										<input type="text" id="validity" name="validity" style="height: 10px; width: 20%;" required/> (in days)											
											<span id="field_validity_Error" class="error-message" style="display: block; margin-top: 5px;"></span>
											</td>
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
										<td><input type="text" id="alt-name" name="alt-name" style="height: 10px;" /></td>
										<td><select class="textbox" id="sub-alt-type" name="sub-alt-type" style="height: 34px;" required>
												<option value="Select type of subject alternative name">Select type of subject alternative name</option>
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
						<input type="button" value="Apply" id="apply" style="margin-bottom: 10px;" />
					</div>
				</form>
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
			<div id="custom-modal-apply-certificate" class="modal-apply-certificate">
				<div class="modal-content-apply-certificate">
				  <p>Are you sure you want to apply certificate?</p>
				  <button id="confirm-button-apply-certificate">Yes</button>
				  <button id="cancel-button-apply-certificate">No</button>
				</div>
			  </div>			  
		</section>
	</div>
	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>