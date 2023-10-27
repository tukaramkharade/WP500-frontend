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

<style>
h3{
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
        
</style>

<script>
$(document).ready(function () {
    $("#identity-store").change(function () {
        var selectedValue = $(this).val();
        if (selectedValue === "OPC UA-self-signed") {
            // If "OPC UA-self-signed" is selected, hide Self-signed HTTPS Certificate row
            $("#self-signed-https-certificate-row").hide();
            // Show the warning row
            $("#warning-row").show();
        } else if(selectedValue === "HTTPS-self-signed"){
        	// If "OPC UA-self-signed" is selected, hide Self-signed HTTPS Certificate row
            $("#self-signed-https-certificate-row").show();
            // Show the warning row
            $("#warning-row").show();
        }
    });
    
 // Trigger the change event on page load to handle the initial selection
    $("#identity-store").trigger("change");
 
    var addBtn = document.getElementById('addBtn');
    addBtn.addEventListener('click', function () {
      var newRow = document.createElement('tr');
      
      // Create the first cell with an input element
      var cell1 = document.createElement('td');
      var input = document.createElement('input');
      input.type = 'text';
      input.id = 'alt-name';
      input.name = 'alt-name';
      input.style.height = '10px';
      cell1.appendChild(input);
      
      // Create the second cell with a select element
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
      
      // Create the third cell with a delete button
      var cell3 = document.createElement('td');
      var deleteBtn = document.createElement('input');
      deleteBtn.type = 'button';
      deleteBtn.value = 'X';
      deleteBtn.className = 'deleteBtn';
      deleteBtn.style.height = '22px';
      deleteBtn.title = 'Remove subject alternative name';
      deleteBtn.addEventListener('click', function () {
        newRow.remove();
      });
      cell3.appendChild(deleteBtn);

      // Add the cells to the new row
      newRow.appendChild(cell1);
      newRow.appendChild(cell2);
      newRow.appendChild(cell3);

      // Insert the new row before the addBtn
      var table = addBtn.parentNode.parentNode.parentNode;
      table.insertBefore(newRow, addBtn.parentNode.parentNode);
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
		
		<h3>GENERATE CERTIFICATE</h3>
			<hr>

			<div class="container">
				<form id="certificateForm">
				
				<table class="bordered-table">
				<tr>
				<th colspan="2">HTTPS Certificate</th>
				</tr>
				
				<tr>
				<td>Identity Store</td>
				<td><select class="identity-store" id="identity-store" name="identity-store" style="height: 34px; width: 20%;" required>
							<option value="Select identity store">Select identity store</option>
							<option value="HTTPS-self-signed">HTTPS-self-signed</option>
							<option value="OPC UA-self-signed" selected="selected">OPC UA-self-signed</option>
						</select>
						</td>
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
				<td><input type="text" id="common_name" name="common_name" style="height: 10px;"/></td>
				</tr>
				
				<tr>
				<td>Organization</td>
				<td><input type="text" id="organization" name="organization" style="height: 10px;"/></td>
				</tr>
				
				<tr>
				
				<td>Organizationl unit</td>
				<td><input type="text" id="organizational_unit" name="organizational_unit" style="height: 10px;"/></td>
				</tr>
				
				<tr>
				<td>Location</td>
				<td><input type="text" id="location" name="location" style="height: 10px;"/></td>
				</tr>
				
				<tr>	
				<td>State</td>
				<td><input type="text" id="state" name="state" style="height: 10px;"/></td>
				</tr>
				
				<tr>
				<td>Country</td>
				<td><input type="text" id="country" name="country" style="height: 10px;"/></td>
				</tr>
				
				<tr>
				<th colspan="2">Validity</th>			
				</tr>
				
				<tr>
				<td>Validity not after</td>
				<td><input type="text" id="validity" name="validity" style="height: 10px; width: 20%;"/> (in days)</td>
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
				<td><input type="text" id="alt-name" name="alt-name" style="height: 10px;"/></td>
				<td><select class="textbox" id="sub-alt-type" name="sub-alt-type" style="height: 34px;" required>
							<option value="Select type of subject alternative name">Select type of subject alternative name</option>
							<option value="IP address">IP address</option>
							<option value="DNS name">DNS name</option>
						</select></td>
						<td><input type="button" value="X" id="deleteBtn" style="height: 22px;" title="Remove subject alternative name"/></td>
				</tr>
				<tr>
				<td><input type="button" value="+" id="addBtn" style="height: 22px;" title="Add subject alternative name"/></td>
				</tr>
				
				
				<tr>
				<td colspan="3"><input style="height: 26px; margin-top: 15px; margin-bottom: 15px;" type="submit" value="Re-generate HTTPS certificate" id="regenerateBtn" /></td>
				</tr>
				
				<tr>
				<td colspan="3">If you click the "Generate" button, the self-signed HTTPS certificate is only regenerated.
				<br> So that the certificate can be activated in the system, you must then press the "Apply" button when IdentityStore "HTTPS-self-signed" is selected.</td>
				</tr>
				</table>
				
				</td>
				</tr>
				
				<tr id="warning-row" style="display: none;">
				<td>Warning</td>
				<td style="color: red;">Applying the configuration can affect the real-time behavior of the system. Avoid reconfiguration during productive operation!</td>
				</tr>
				</table>
				
				<div class="row"
					style="display: flex; justify-content: right; margin-top: 2%;">
					<input type="button" value="Apply" id="apply" style="margin-bottom: 10px;"/> 
					
				</div>
				
				</form>
				</div>
		</section>
		</div>

	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>

</body>
</html>