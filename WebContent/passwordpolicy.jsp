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
 .container {
    margin: -16px auto;
    width: 95%;
  }

 .bordered-table {
  border-collapse: collapse; /* Optional: To collapse table borders */
  margin: 0 auto; /* Center the table horizontally */
}

.bordered-table td {
  border: 1px solid #ccc; /* Light gray border */
 
}

.block-list{
 border-collapse: collapse;
}

.block-list td{
 border: 1px solid #ccc;
}
</style>

<script>

function addRow() {
    var table = document.getElementById('block-list');
    var newRow = table.insertRow(table.rows.length - 1);
    
    var cell1 = newRow.insertCell(0);
    var cell2 = newRow.insertCell(1);
    var cell3 = newRow.insertCell(2);
    
    var input = document.createElement('input');
    input.type = 'text';
    input.name = 'blocked_password';
    input.style.height = '10px';
    input.style.width = '900px';
    
    var deleteBtn = document.createElement('input');
    deleteBtn.type = 'button';
    deleteBtn.value = 'X';
    deleteBtn.className = 'deleteBtn';
    deleteBtn.style.height = '22px';
    deleteBtn.title = 'Remove block list entry';
    deleteBtn.onclick = function () {
      removeRow(this);
    };

    cell1.appendChild(input);
    cell2.appendChild(document.createTextNode('')); // Empty cell
    cell3.appendChild(deleteBtn);
  }

  function removeRow(button) {
    var row = button.parentNode.parentNode;
    row.parentNode.removeChild(row);
  }
  
  function populateBlockList(passwordBlockedList) {
	    var table = document.getElementById('block-list');

	    // Clear existing rows (except header)
	    while (table.rows.length > 1) {
	        table.deleteRow(1);
	    }

	    // Populate with new rows
	    for (var i = 0; i < passwordBlockedList.length; i++) {
	        var newRow = table.insertRow(table.rows.length - 1);
	        var cell1 = newRow.insertCell(0);
	        var cell2 = newRow.insertCell(1);
	        var cell3 = newRow.insertCell(2);

	        cell1.innerHTML = '<input type="text" name="blocked_password" style="width: 900px; height: 10px;" value="' + passwordBlockedList[i] + '" />';
	        cell2.innerHTML = ''; // Empty cell
	        cell3.innerHTML = '<input type="button" value="X" class="deleteBtn" style="height: 22px;" title="Remove block list entry" onclick="removeRow(this)" />';
	    }
	}
  
  function getPasswordPolicy() {
	  $.ajax({
		  url : 'PasswordPolicyServlet',
			type : 'GET',
			dataType : 'json',
			success : function(data) {
				
				$('#password_policy').val(data.password_policy);
				$('#min_char_count').val(data.characters_count);
				$('#password_policy_role').val(data.password_policy_role);
				$('#min_asccii_char_count').val(data.ascii_ch_count);
				$('#min_num_count').val(data.number_count);
				$('#min_mix_char_count').val(data.mixed_ch_count);
				$('#allowed_spl_char').val(data.allowed_special_ch);
				$('#min_spl_char_count').val(data.special_ch_count);
				 var passwordBlockedList = data.password_blocked_list;
		            populateBlockList(passwordBlockedList);
				
			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log("Error loading password policy: " + error);
			},
	  });
	 }
  
  

$(document).ready(function() {
	getPasswordPolicy();
});
</script>

<body>

<div class="container">
		 <h3>Password Policy</h3>
		 <hr>
		 
		 <form id="passwordPolicyForm"  onsubmit="return false;">
		 
		 <input type="hidden" id="password_policy_action" name="password_policy_action" value="">
		 
		 <table class="bordered-table">
		 <tr>
				<th colspan="3">Roles Configuration</th>
				</tr>
				
				<tr>
				<td>Password policy</td>
				<td colspan="2"><select class="password_policy" id="password_policy" name="password_policy" style="height: 34px; width: 20%;" required>
							<option value="Select password policy">Select password policy</option>
							<option value="Enable">Enable</option>
							<option value="Disable" selected="selected">Disable</option>
						</select>
						</td>
				</tr>
				
				<tr>
				<td>Password policy role</td>
				<td colspan="2"><select class="password_policy_role" id="password_policy_role" name="password_policy_role" style="height: 34px; width: 20%;" required>
							<option value="Select password policy role">Select password policy role</option>
							<option value="Admin ruleset" selected="selected">Admin ruleset</option>
							<option value="Default ruleset">Default ruleset</option>
						</select>
						</td>
				</tr>
				
				<tr>
				<th colspan="3">Password Conplexity rules</th>
				</tr>
				
				<tr>
				<td>Minimum ASCII characters count</td>
				<td><input type="text" id="min_asccii_char_count" name="min_asccii_char_count" style="height: 10px;"/></td>
				<td>Number of ASCII characters a new password must at least contain.</td>
				</tr>
				
				<tr>
				<td>Minimum mixed characters count</td>
				<td><input type="text" id="min_mix_char_count" name="min_mix_char_count" style="height: 10px;"/></td>
				<td>Number of mixed-case characters a new password must at least contain.</td>
				</tr>
				
				<tr>
				<td>Minimum numbers count</td>
				<td><input type="text" id="min_num_count" name="min_num_count" style="height: 10px;"/></td>
				<td>Number count a new password must at least contain.</td>
				</tr>
				
				<tr>
				<td>Minimum special characters count</td>
				<td><input type="text" id="min_spl_char_count" name="min_spl_char_count" style="height: 10px;"/></td>
				<td>Number of special characters a new password must at least contain.</td>
				</tr>
				
				<tr>
				<td>Allowed special characters</td>
				<td><input type="text" id="allowed_spl_char" name="allowed_spl_char" style="height: 10px;"/></td>
				<td>ASCII special characters that are allowed for the special character count rule.</td>
				</tr>
				
				<tr>
				<td>Minimum characters count</td>
				<td><input type="text" id="min_char_count" name="min_char_count" style="height: 10px;"/></td>
				<td>Number of characters a new password must at least contain in general.</td>
				</tr>
				 </table>
				
	<table id="block-list">
	<tr>
	<th colspan="3">Blocked passwords</th>
	</tr>
  <tr>
    <td colspan="2"><input type="text" name="blocked_password" style="width: 900px; height: 10px;" /></td>
    <td><input type="button" value="X" class="deleteBtn" style="height: 22px;" title="Remove block list entry" onclick="removeRow(this)" /></td>
  </tr>

  <tr>
    <td><input type="button" value="+" style="height: 22px;" title="Add block list entry" onclick="addRow()" /></td>
  </tr>
</table>

	<div class="row" style="display: flex; justify-content: center; margin-bottom: 2%; margin-top: 1%;">
					
					<!-- <input style="height: 26px;" type="button" value="Delete" id="delPasswordPolicy"/> --> 
					<input style="margin-left: 5px; height: 26px;" type="submit" value="Apply" id="addPassword" />
				</div>

		
		 </form>
		 </div>
		 
		 
</body>

</html>
