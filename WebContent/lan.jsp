<%-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<title>LAN Settings</title>

<style type="text/css">

.slider.round {
  border-radius: 34px;
}

.slider.round:before {
  border-radius: 50%;
}

.btn_discard_0{
margin-top: 10px;
margin-bottom: 10px;
}

.btn_change_0{
margin-top: 10px;
margin-bottom: 10px;
}

.btn_discard_1{
margin-top: 10px;
margin-bottom: 10px;
}

.btn_change_1{
margin-top: 10px;
margin-bottom: 10px;
}

.btn_discard_2{
margin-top: 10px;
margin-bottom: 10px;
}

.btn_change_2{
margin-top: 10px;
margin-bottom: 10px;
}
</style>
<link rel="stylesheet" type="text/css" href="user_styles.css">
<%@ include file="header.jsp"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	// Function to load user data and populate the user list table

	function loadLanSettings() {
		$.ajax({
			url : 'lan',
			type : 'GET',
			dataType : 'json',
			success : function(data) {
				//alert(data.eth0_dhcp + " " + data.eth0_ipaddr + " " + data.eth0_subnet);

				//$('#dhcp_dis_1').val(data.eth0_dhcp);
				$('#ip_addr_dis_0').val(data.eth0_ipaddr);
				$('#subnet_mask_dis_0').val(data.eth0_subnet);

				$('#ip_addr_dis_1').val(data.eth1_ipaddr);
				$('#subnet_mask_dis_1').val(data.eth1_subnet);

				$('#ip_addr_dis_2').val(data.eth2_ipaddr);
				$('#subnet_mask_dis_2').val(data.eth2_subnet);
			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error: ' + error);
			}
		});
	}

	$(document).ready(function() {
		// Load user list
		loadLanSettings();

	});
</script>
</head>
<body>
	<div class="container">
		<div class="sidenav">
			<%@ include file="common.jsp"%>

		</div>

		<div class="content">
			<h2>LAN Setting</h2>

			<table>
				<tr>
					<th>TCP/IP(LAN 0)- Switched Mode</th>
					<th>Current IP</th>
					<th>New IP</th>
				</tr>
				<tr>
					<td>DHCP</td>
					<td><input type="checkbox"> <span class="slider round"></span></td>

				</tr>

				<tr>
					<td>IP Address</td>

					<td><input id="ip_addr_dis_0" class="status" disabled
						type='textbox' name="ip_addr_dis_0"></td>
					<td><input id="ip_addr_0" class="config" type='textbox'
						name="ip_addr_0"></td>
				</tr>
				<tr>
					<td>Subnet Mask</td>
					<td><input id="subnet_mask_dis_0" class="status" disabled
						type='textbox' name="subnet_mask_dis_0"></td>
					<td><input id="subnet_mask_0" class="config" type='textbox'
						name="subnet_mask_0"></td>
				</tr>


			</table>

			<input type="button" class="btn_discard_0" value="Discard"> <input
				type="button" class="btn_change_0" value="Apply changes & Reboot">

			<table>
				<tr>
					<th>TCP/IP(LAN 1)- Switched Mode</th>
					<th>Current IP</th>
					<th>New IP</th>
				</tr>
				<tr>
					<td>DHCP</td>
					<td><input type="checkbox"> <span class="slider round"></span></td>
				</tr>

				<tr>
					<td>IP Address</td>

					<td><input id="ip_addr_dis_1" class="status" disabled
						type='textbox' name="ip_addr_dis_1"></td>
					<td><input id="ip_addr_1" class="config" type='textbox'
						name="ip_addr_1"></td>
				</tr>
				<tr>
					<td>Subnet Mask</td>
					<td><input id="subnet_mask_dis_1" class="status" disabled
						type='textbox' name="subnet_mask_dis_1"></td>
					<td><input id="subnet_mask_1" class="config" type='textbox'
						name="subnet_mask_1"></td>
				</tr>


			</table>

			<input type="button" class="btn_discard_1" value="Discard"> <input
				type="button" class="btn_change_1" value="Apply changes & Reboot">

			<table>
				<tr>
					<th>TCP/IP(LAN 2)- Switched Mode</th>
					<th>Current IP</th>
					<th>New IP</th>
				</tr>
				<tr>
					<td>DHCP</td>
					<td><input type="checkbox"> <span class="slider round"></span></td>
				</tr>

				<tr>
					<td>IP Address</td>

					<td><input id="ip_addr_dis_2" class="status" disabled
						type='textbox' name="ip_addr_dis_2"></td>
					<td><input id="ip_addr_2" class="config" type='textbox'
						name="ip_addr_2"></td>
				</tr>
				<tr>
					<td>Subnet Mask</td>
					<td><input id="subnet_mask_dis_2" class="status" disabled
						type='textbox' name="subnet_mask_dis_2"></td>
					<td><input id="subnet_mask_2" class="config" type='textbox'
						name="subnet_mask_2"></td>
				</tr>


			</table>

			<input type="button" class="btn_discard_2" value="Discard"> <input
				type="button" class="btn_discard_2" value="Apply changes & Reboot">
		</div>
	</div>
	<%@ include file="footer.jsp"%>
</body>
</html>
 --%>
 
 
 
 <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<title>LAN Settings</title>

<style type="text/css">

/* .slider.round {
  border-radius: 34px;
}

.slider.round:before {
  border-radius: 50%;
} */

.btn_discard_0{
	padding: 5px 10px;
  background-color: #ef0803;
  color: white;
  border: none;
  width: 85px;
  height: 30px;
  border-radius: 4px;
  cursor: pointer;
}

.btn_change_0{
margin-top: 10px;
margin-bottom: 10px;
padding: 5px 10px;
  background-color: #6c45ed;
  color: white;
  border: none;
  width: 185px;
  height: 30px;
  border-radius: 4px;
  cursor: pointer;
}


input[type="text"] input[type="password"] {
  width: 400px;
  min-height: 80px;
  padding: 5px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

	table {
  border-collapse: collapse;
  width: 100%;
}

th, td {
  padding: 8px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

.content table tr th {
  background-color: #e2e6f9;
  color: #283587;
}
h2{
	color: #283587;
}
.text{
	height: 30px;
}
</style>
<link rel="stylesheet" type="text/css" href="user_styles.css">
<%@ include file="header.jsp"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	// Function to load user data and populate the user list table

	function loadLanSettings() {
		$.ajax({
			url : 'lan',
			type : 'GET',
			dataType : 'json',
			success : function(data) {
				//alert(data.eth0_dhcp + " " + data.eth0_ipaddr + " " + data.eth0_subnet);

				//$('#dhcp_dis_1').val(data.eth0_dhcp);
				$('#ip_addr_dis_0').val(data.eth0_ipaddr);
				$('#subnet_mask_dis_0').val(data.eth0_subnet);

				$('#ip_addr_dis_1').val(data.eth1_ipaddr);
				$('#subnet_mask_dis_1').val(data.eth1_subnet);

				$('#ip_addr_dis_2').val(data.eth2_ipaddr);
				$('#subnet_mask_dis_2').val(data.eth2_subnet);
			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error: ' + error);
			}
		});
	}

	$(document).ready(function() {
		// Load user list
		loadLanSettings();

	});
</script>
</head>
<body>
	<div class="container">
		<div class="sidebar">
			<%@ include file="common.jsp"%>

		</div>

		<div class="content">
			<h2>LAN Setting</h2>

			<table>
				<tr>
					<th>TCP/IP(LAN 0)- Switched Mode</th>
					<th>Current IP</th>
					<th>New IP</th>
				</tr>
				<tr>
					<td>DHCP</td>
					<td><input type="checkbox"> <span class="slider round"></span></td>
					<td></td>

				</tr>

				<tr>
					<td>IP Address</td>

					<td><input id="ip_addr_dis_0" class="status" disabled
						type='text' name="ip_addr_dis_0"></td>
					<td><input id="ip_addr_0" class="config" type='text'
						name="ip_addr_0"></td>
				</tr>
				<tr>
					<td>Subnet Mask</td>
					<td><input id="subnet_mask_dis_0" class="status" disabled
						type='text' name="subnet_mask_dis_0"></td>
					<td><input id="subnet_mask_0" class="config" type='text'
						name="subnet_mask_0"></td>
				</tr>


			</table>

			<input type="button" class="btn_discard_0" value="Discard"> <input
				type="button" class="btn_change_0" value="Apply changes & Reboot">

			<table>
				<tr>
					<th>TCP/IP(LAN 1)- Switched Mode</th>
					<th>Current IP</th>
					<th>New IP</th>
				</tr>
				<tr>
					<td>DHCP</td>
					<td><input type="checkbox"> <span class="slider round"></span></td>
					<td></td>
				</tr>

				<tr>
					<td>IP Address</td>

					<td><input id="ip_addr_dis_1" class="status" disabled
						type='text' name="ip_addr_dis_1"></td>
					<td><input id="ip_addr_1" class="config" type='text'
						name="ip_addr_1"></td>
				</tr>
				<tr>
					<td>Subnet Mask</td>
					<td><input id="subnet_mask_dis_1" class="status" disabled
						type='text' name="subnet_mask_dis_1"></td>
					<td><input id="subnet_mask_1" class="config" type='text'
						name="subnet_mask_1"></td>
				</tr>


			</table>

			<input type="button" class="btn_discard_0" value="Discard"> <input
				type="button" class="btn_change_0" value="Apply changes & Reboot">

			<table>
				<tr>
					<th>TCP/IP(LAN 2)- Switched Mode</th>
					<th>Current IP</th>
					<th>New IP</th>
				</tr>
				<tr>
					<td>DHCP</td>
					<td><input type="checkbox"> <span  class="slider round"></span></td>
					<td></td>
				</tr>

				<tr>
					<td>IP Address</td>

					<td><input id="ip_addr_dis_2" class="status" disabled
						type='text' name="ip_addr_dis_2"></td>
					<td><input id="ip_addr_2" class="config" type='text'
						name="ip_addr_2"></td>
				</tr>
				<tr>
					<td>Subnet Mask</td>
					<td><input id="subnet_mask_dis_2" class="status" disabled
						type='text' name="subnet_mask_dis_2"></td>
					<td><input id="subnet_mask_2" class="config" type='text'
						name="subnet_mask_2"></td>
				</tr>


			</table>

			<input type="button" class="btn_discard_0" value="Discard"> <input
				type="button" class="btn_change_0" value="Apply changes & Reboot">
		</div>
	</div>
	<%@ include file="footer.jsp"%>
</body>
</html>