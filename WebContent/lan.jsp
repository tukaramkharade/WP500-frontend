
<%-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
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
.btn_discard_0 {
	padding: 5px 10px;
	background-color: #ef0803;
	color: white;
	border: none;
	width: 85px;
	height: 30px;
	border-radius: 4px;
	cursor: pointer;
}

.btn_change_0 {
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

 tr th {
	background-color: #e2e6f9;
	color: #283587;
	
	
}

h2 {
	color: #283587;
}

.text {
	height: 30px;
}

.toggle {
	position: relative;
	display: block;
	width: 55px;
	height: 25px;
	padding: 3px;	
	border-radius: 50px;
	cursor: pointer;
}

.toggle-input {
	position: absolute;
	top: 0;
	left: 0;
	opacity: 0;
}

.toggle-label {
	position: relative;
	display: block;
	height: inherit;
	font-size: 12px;
	background: red;
	border-radius: inherit;
	box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.12), inset 0 0 3px
		rgba(0, 0, 0, 0.15);
}

.toggle-label:before, .toggle-label:after {
	position: absolute;
	top: 50%;
	color: black;
	margin-top: -.5em;
	line-height: 1;
}

.toggle-label:before {
	content: attr(data-off);
	right: 5px;
	color: #fff;
	text-shadow: 0 1px rgba(255, 255, 255, 0.5);
}

.toggle-label:after {
	content: attr(data-on);
	left: 7px;
	color: #fff;
	text-shadow: 0 1px rgba(0, 0, 0, 0.2);
	opacity: 0;
}

.toggle-input:checked ~.toggle-label {
	background: green;
}

.toggle-input:checked ~.toggle-label:before {
	opacity: 0;
}

.toggle-input:checked ~.toggle-label:after {
	opacity: 1;
}

.toggle-handle {
	position: absolute;
	top: 4px;
	left: 2px;
	width: 25px;
	height: 25px;
	background: linear-gradient(to bottom, #FFFFFF 40%, #f0f0f0);
	border-radius: 50%;
}

.toggle-handle:before {
	position: absolute;
	top: 50%;
	left: 50%;
	margin: -6px 0 0 -6px;
	width: 10px;
	height: 10px;	
}

.toggle-input:checked ~.toggle-handle {
	left: 33px;
	box-shadow: -1px 1px 5px rgba(0, 0, 0, 0.2);
}

/* Transition*/
.toggle-label, .toggle-handle {
	transition: All 0.3s ease;
	-webkit-transition: All 0.3s ease;
	-moz-transition: All 0.3s ease;
	-o-transition: All 0.3s ease;
}

.dhcp_btn{
background-color: #6c45ed;
border-radius:4px;
color:white;
border: none;
width: 100px;
height: 25px;
cursor: pointer;
}
</style>
<link rel="stylesheet" type="text/css" href="nav-bar.css">
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
				//alert(data.eth0_ipaddr + " " + data.eth0_subnet);

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
	
	
	//eth_type = 0
	function loadLanDHCPSettings0(eth_type) {
		var eth_type = 0;
		//alert(eth_type)
		
		$.ajax({
			url : 'lan',
			type : 'POST',
			data : {
				eth_type : eth_type
			},
			success : function(data) {
				
				/* alert(data.message_dhcp);
				alert(data.eth1_dhcp);
				alert(data.eth1_subnet);
				alert(data.eth1_ipaddr); */

			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error: ' + error);
			}
		});
	}
	
	//eth_type = 1
	function loadLanDHCPSettings1(eth_type) {
		var eth_type = 1;
		//alert(eth_type)
		
		$.ajax({
			url : 'lan',
			type : 'POST',
			data : {
				eth_type : eth_type
			},
			success : function(data) {
				
				if(data.eth1_dhcp == 1){
					$('#ip_addr_1').prop('disabled', true); 
					$('#subnet_mask_1').prop('disabled', true);
					
					$('#ip_addr_1').val(data.eth1_ipaddr);
					$('#subnet_mask_1').val(data.eth1_subnet);
					
					$('#checkbox1').prop('disabled', true);
				}

			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error: ' + error);
			}
		});
	}
	
	//eth_type = 2
	function loadLanDHCPSettings2(eth_type) {
		var eth_type = 2;
		//alert(eth_type)
		
		$.ajax({
			url : 'lan',
			type : 'POST',
			data : {
				eth_type : eth_type
			},
			success : function(data) {
				
				/* alert(data.message_dhcp);
				alert(data.eth1_dhcp);
				alert(data.eth1_subnet);
				alert(data.eth1_ipaddr); */

			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error: ' + error);
			}
		});
	}


	$(document).ready(function() {

		loadLanSettings();
		 $('#get_dhcp_0').click(function(){		
				loadLanDHCPSettings0(0);

		 });	
		 
		 $('#get_dhcp_1').click(function(){		
				loadLanDHCPSettings1(1);

		 });
		 
		 $('#get_dhcp_2').click(function(){		
				loadLanDHCPSettings2(2);

		 });
			
		/* $('#checkbox0').click(function() {

			if (this.checked) {
				$('#ip_addr_0').prop('disabled', true); // If checked disable item
				$('#subnet_mask_0').prop('disabled', true); // If checked disable item
				

			} else {
				$('#ip_addr_0').prop('disabled', false); // If checked enable item
				$('#subnet_mask_0').prop('disabled', false); // If checked disable item
			}

		});
		
		
		$('#checkbox1').click(function() {

			if (this.checked) {
				$('#ip_addr_1').prop('disabled', true); // If checked disable item
				$('#subnet_mask_1').prop('disabled', true); // If checked disable item
				

			} else {
				$('#ip_addr_1').prop('disabled', false); // If checked enable item
				$('#subnet_mask_1').prop('disabled', false); // If checked disable item
			}

		});
		
		$('#checkbox2').click(function() {

			if (this.checked) {
				$('#ip_addr_2').prop('disabled', true); // If checked disable item
				$('#subnet_mask_2').prop('disabled', true); // If checked disable item
				

			} else {
				$('#ip_addr_2').prop('disabled', false); // If checked enable item
				$('#subnet_mask_2').prop('disabled', false); // If checked disable item
			}

		}); */

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
					<td><label class="toggle"> <input class="toggle-input"
							type="checkbox" id="checkbox0"> <span class="toggle-label"
							data-off="OFF" data-on="ON"></span> <span class="toggle-handle"></span>
					</label></td>
					<td><input type="button" value="DHCP IP 0" class="dhcp_btn" id="get_dhcp_0">
					
					</td>

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
					<td><label class="toggle"> <input class="toggle-input"
							type="checkbox" id="checkbox1"> <span class="toggle-label"
							data-off="OFF" data-on="ON"></span> <span class="toggle-handle"></span>
					</label></td>
					<td><input type="button" value="DHCP IP 1" class="dhcp_btn" id="get_dhcp_1"></td>
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
					<td><label class="toggle"> <input class="toggle-input"
							type="checkbox" id="checkbox2"> <span class="toggle-label"
							data-off="OFF" data-on="ON"></span> <span class="toggle-handle"></span>
					</label></td>
					<td><input type="button" class="dhcp_btn" value="DHCP IP 2" id="get_dhcp_2"></td>
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
</html> --%>


<!-- ------------------------------------------------------------------------------------------------- -->

<!-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%> -->
<!DOCTYPE html>
<html>
<title>LAN Settings</title>

<link
rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css"
/>
<link
href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
rel="stylesheet"
type="text/css"
/>
<link
rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css"
/>
<link rel="stylesheet" type="text/css" href="nav-bar.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	// Function to load user data and populate the user list table

	function loadLanSettings() {
		$.ajax({
			url : 'lan',
			type : 'GET',
			dataType : 'json',
			success : function(data) {
				//alert(data.eth0_ipaddr + " " + data.eth0_subnet);

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
	
	
	//eth_type = 0
	function loadLanDHCPSettings0(eth_type) {
		var eth_type = 0;
		//alert(eth_type)
		
		$.ajax({
			url : 'lan',
			type : 'POST',
			data : {
				eth_type : eth_type
			},
			success : function(data) {
				
				/* alert(data.message_dhcp);
				alert(data.eth1_dhcp);
				alert(data.eth1_subnet);
				alert(data.eth1_ipaddr); */

			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error: ' + error);
			}
		});
	}
	
	//eth_type = 1
	function loadLanDHCPSettings1(eth_type) {
		var eth_type = 1;
		//alert(eth_type)
		
		$.ajax({
			url : 'lan',
			type : 'POST',
			data : {
				eth_type : eth_type
			},
			success : function(data) {
				
				if(data.eth1_dhcp == 1){
					$('#ip_addr_1').prop('disabled', true); 
					$('#subnet_mask_1').prop('disabled', true);
					
					$('#ip_addr_1').val(data.eth1_ipaddr);
					$('#subnet_mask_1').val(data.eth1_subnet);
					
					$('#checkbox1').prop('disabled', true);
				}

			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error: ' + error);
			}
		});
	}
	
	//eth_type = 2
	function loadLanDHCPSettings2(eth_type) {
		var eth_type = 2;
		//alert(eth_type)
		
		$.ajax({
			url : 'lan',
			type : 'POST',
			data : {
				eth_type : eth_type
			},
			success : function(data) {
				
				/* alert(data.message_dhcp);
				alert(data.eth1_dhcp);
				alert(data.eth1_subnet);
				alert(data.eth1_ipaddr); */

			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error: ' + error);
			}
		});
	}


	$(document).ready(function() {

		loadLanSettings();
		 $('#get_dhcp_0').click(function(){		
				loadLanDHCPSettings0(0);

		 });	
		 
		 $('#get_dhcp_1').click(function(){		
				loadLanDHCPSettings1(1);

		 });
		 
		 $('#get_dhcp_2').click(function(){		
				loadLanDHCPSettings2(2);

		 });
			
		/* $('#checkbox0').click(function() {

			if (this.checked) {
				$('#ip_addr_0').prop('disabled', true); // If checked disable item
				$('#subnet_mask_0').prop('disabled', true); // If checked disable item
				

			} else {
				$('#ip_addr_0').prop('disabled', false); // If checked enable item
				$('#subnet_mask_0').prop('disabled', false); // If checked disable item
			}

		});
		
		
		$('#checkbox1').click(function() {

			if (this.checked) {
				$('#ip_addr_1').prop('disabled', true); // If checked disable item
				$('#subnet_mask_1').prop('disabled', true); // If checked disable item
				

			} else {
				$('#ip_addr_1').prop('disabled', false); // If checked enable item
				$('#subnet_mask_1').prop('disabled', false); // If checked disable item
			}

		});
		
		$('#checkbox2').click(function() {

			if (this.checked) {
				$('#ip_addr_2').prop('disabled', true); // If checked disable item
				$('#subnet_mask_2').prop('disabled', true); // If checked disable item
				

			} else {
				$('#ip_addr_2').prop('disabled', false); // If checked enable item
				$('#subnet_mask_2').prop('disabled', false); // If checked disable item
			}

		}); */

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
			<h3>LAN Setting</h3>
			<hr>
			<div class="container">
			<table>
				<tr>
					<th>TCP/IP(LAN 0)- Switched Mode</th>
					<th>Current IP</th>
					<th>New IP</th>
				</tr>
				<tr>
					<td>DHCP</td>
					<td><label class="toggle"> <input class="toggle-input"
							type="checkbox" id="checkbox0"> <span class="toggle-label"
							data-off="OFF" data-on="ON"></span> <span class="toggle-handle"></span>
					</label>
					
				</td>
					<td><input type="button" value="DHCP IP 0" id="get_dhcp_0">
					
					</td>

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
			<div style="margin-top: 1%;">
			<input type="button" value="Discard" style="background-color: #ef0803;"> <input
				type="button" value="Apply changes & Reboot">
			</div>
			</div>	

			
			<div class="container" style="margin-top: 1%;">
			<table>
				<tr>
					<th>TCP/IP(LAN 1)- Switched Mode</th>
					<th>Current IP</th>
					<th>New IP</th>
				</tr>
				<tr>
					<td>DHCP</td>
					<td><label class="toggle"> <input class="toggle-input"
							type="checkbox" id="checkbox1"> <span class="toggle-label"
							data-off="OFF" data-on="ON"></span> <span class="toggle-handle"></span>
					</label></td>
					<td><input type="button" value="DHCP IP 1" id="get_dhcp_1"></td>
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
			
			<div style="margin-top: 1%;">
			<input type="button" style="background-color: #ef0803;" value="Discard"> <input
				type="button" value="Apply changes & Reboot">
			</div>
			</div>

			<div class="container" style="margin-top: 1%;">
			<table>
				<tr>
					<th>TCP/IP(LAN 2)- Switched Mode</th>
					<th>Current IP</th>
					<th>New IP</th>
				</tr>
				<tr>
					<td>DHCP</td>
					<td><label class="toggle"> <input class="toggle-input"
							type="checkbox" id="checkbox2"> <span class="toggle-label"
							data-off="OFF" data-on="ON"></span> <span class="toggle-handle"></span>
					</label></td>
					<td><input type="button" value="DHCP IP 2" id="get_dhcp_2"></td>
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

			
			<div style="margin-top: 1%;">
			<input type="button" style="background-color: #ef0803;" value="Discard"> <input
				type="button" value="Apply changes & Reboot">
			</div>
		
			</div>	
			</section>
		</div>
		<div class="footer">
			<%@ include file="footer.jsp"%>
		  </div>
</body>
</html>