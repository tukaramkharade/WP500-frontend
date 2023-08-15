<!-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%> -->
<!DOCTYPE html>
<html>

<title>WP500 Web Configuration</title>
<link
      rel="icon"  
      type="image/png"
      sizes="32x32"
      href="favicon.png"
    /> 

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
				
				var json1 = JSON.stringify(data);

						var json = JSON.parse(json1);

						if (json.status == 'fail') {
							var confirmation = confirm(json.msg);
							if (confirmation) {
								window.location.href = 'login.jsp';
							}
						}

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