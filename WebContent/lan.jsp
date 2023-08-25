<!-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%> -->
<!DOCTYPE html>
<html>

<title>WP500 Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="favicon.png" />

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" type="text/css" href="nav-bar.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	// Function to load user data and populate the user list table

	var eth1_dhcp;
	var lan1_dhcp;
	var lan2_dhcp;
	var lan_type;
	
	var roleValue;
	
	function loadDHCPButton0(){
		
		lan_type = 'eth1';
		alert('lan type : '+lan_type);
	}
	
	function loadLanSettings() {
		$.ajax({
			url : 'lanServlet',
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
				$('#ip_addr_dis_0').val(data.eth1_ipaddr);
				$('#subnet_mask_dis_0').val(data.eth1_subnet);
				eth1_dhcp = data.eth1_dhcp;

				$('#ip_addr_dis_1').val(data.lan1_ipaddr);
				$('#subnet_mask_dis_1').val(data.lan1_subnet);
				lan1_dhcp = data.lan1_dhcp;

				$('#ip_addr_dis_2').val(data.lan2_ipaddr);
				$('#subnet_mask_dis_2').val(data.lan2_subnet);
				lan2_dhcp = data.lan2_dhcp;
			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error: ' + error);
			}
		});
	}
	
	
	function editEth1() {

		var lan_type = 'eth1';
		var eth1_ipaddr = $('#ip_addr_eth1').val();
		var eth1_subnet = $('#subnet_mask_eth1').val();
		
		//alert('eth1_dhcp : '+eth1_dhcp)
		
		
		$.ajax({
			
			url : 'lanServlet',
			type : 'POST',
			data : {
				eth1_ipaddr : eth1_ipaddr,
				eth1_subnet : eth1_subnet,
				eth1_dhcp : eth1_dhcp,
				lan_type : lan_type
			},
			success : function(data) {
				
				if(eth1_dhcp == '1'){
					alert('DHCP  = 1 Cannot update IP address and subnet mask');
					
					$('#ip_addr_eth1').prop('disabled', true); 
					$('#subnet_mask_eth1').prop('disabled', true); 
					
					$('#ip_addr_eth1').val(eth1_ipaddr);
					$('#subnet_mask_eth1').val(eth1_subnet);
					
				}else{
					
					alert(data.message);
					
					//clear fields
					$('#ip_addr_eth1').val('');
					$('#subnet_mask_eth1').val('');
					
				}
				
				

			},
			error : function(xhr, status, error) {
				console.log('Error updating lan : ' + error);
			}
		});

	}

	function changeButtonColor(isDisabled) {
        var $eth1_button_discard = $('#eth1_button_discard');
        var $eth1_button = $('#eth1_button');
        var $lan1_button_discard = $('#lan1_button_discard');
        var $lan1_button = $('#lan1_button');
        var $lan2_button_discard = $('#lan2_button_discard');
        var $lan2_button = $('#lan2_button');
     
       
        
        if (isDisabled) {
            $eth1_button_discard.css('background-color', 'gray'); // Change to your desired color
        } else {
            $eth1_button_discard.css('background-color', '#2b3991'); // Reset to original color
        }
        
        if (isDisabled) {
            $eth1_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $eth1_button.css('background-color', '#2b3991'); // Reset to original color
        }
        
        if (isDisabled) {
            $lan1_button_discard.css('background-color', 'gray'); // Change to your desired color
        } else {
            $lan1_button_discard.css('background-color', '#2b3991'); // Reset to original color
        }
        
        if (isDisabled) {
            $lan1_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $lan1_button.css('background-color', '#2b3991'); // Reset to original color
        }
        
        if (isDisabled) {
            $lan2_button_discard.css('background-color', 'gray'); // Change to your desired color
        } else {
            $lan2_button_discard.css('background-color', '#2b3991'); // Reset to original color
        }
        
        if (isDisabled) {
            $lan2_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $lan2_button.css('background-color', '#2b3991'); // Reset to original color
        }
	}
 
	$(document).ready(function() {
		
		<%
    	// Access the session variable
    	HttpSession role = request.getSession();
    	String roleValue = (String) session.getAttribute("role");
    	%>
    	
    	roleValue = '<%= roleValue %>'; // This will insert the session value into the JavaScript code
      

		loadLanSettings();
    	
		 if(roleValue == 'VIEWER' || roleValue == 'Viewer'){
   		  	
   		  var confirmation = confirm('You do not have enough privileges for role VIEWER');
   		  
   		  $('#eth1_button_discard').prop('disabled', true);
   		  $('#eth1_button').prop('disabled', true);
   		  $('#lan1_button_discard').prop('disabled', true);
 		  $('#lan1_button').prop('disabled', true);
 		  $('#lan2_button_discard').prop('disabled', true);
  		  $('#lan2_button').prop('disabled', true);
   		  
   		  changeButtonColor(true);
   	  }
		 
		$('#get_dhcp_0').click(function(){		
				/* loadLanDHCPSettings0(0); */
				
				loadDHCPButton0();

		 });	
		
		$('#eth1_button').click(function(){
			
			editEth1();
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
						<td><label class="toggle"> <input
								class="toggle-input" type="checkbox" id="checkbox0"> <span
								class="toggle-label" data-off="OFF" data-on="ON"></span> <span
								class="toggle-handle"></span>
						</label></td>
						<td><input type="button" value="DHCP IP 0" id="get_dhcp_0">

						</td>

					</tr>

					<tr>
						<td>IP Address</td>

						<td><input id="ip_addr_dis_0" class="status" disabled
							type='text' name="ip_addr_dis_0"></td>
							
						<td>
						<input id="ip_addr_eth1" class="config" type='text'
							name="ip_addr_eth1"></td>
					</tr>
					<tr>
						<td>Subnet Mask</td>
						<td><input id="subnet_mask_dis_0" class="status" disabled
							type='text' name="subnet_mask_dis_0"></td>
							
						<td><input id="subnet_mask_eth1" class="config" type='text'
							name="subnet_mask_eth1"></td>
					</tr>


				</table>
				<div style="margin-top: 1%;">
					<input type="button" value="Discard" style="background-color: #ef0803;" id="eth1_button_discard"> 
					<input type="button" value="Apply changes" id="eth1_button">
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
						<td><label class="toggle"> <input
								class="toggle-input" type="checkbox" id="checkbox1"> <span
								class="toggle-label" data-off="OFF" data-on="ON"></span> <span
								class="toggle-handle"></span>
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
					<input type="button" style="background-color: #ef0803;" value="Discard" id="lan1_button_discard"> 
					<input type="button" value="Apply changes" id="lan1_button">
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
						<td><label class="toggle"> <input
								class="toggle-input" type="checkbox" id="checkbox2"> <span
								class="toggle-label" data-off="OFF" data-on="ON"></span> <span
								class="toggle-handle"></span>
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
					<input type="button" style="background-color: #ef0803;" value="Discard" id="lan2_button_discard"> 
						<input type="button" value="Apply changes" id="lan2_button">
				</div>

			</div>
		</section>
	</div>
	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>