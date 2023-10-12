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
<link rel="stylesheet" type="text/css" href="nav-bar.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
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
  transform: translate(-50%, -50%); /* Center horizontally and vertically */
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
  transform: translate(-50%, -50%); /* Center horizontally and vertically */
}


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

#cancel-button-edit{
  background-color: #f44336;
  color: white;
}

#confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
}
</style>

<script>
	// Function to load user data and populate the user list table

	var eth1_dhcp;
	var lan1_dhcp;
	var lan2_dhcp;
	var dhcp_type;
	var tokenValue;
	var roleValue;
	
	function getDhcpSettings() {
		var dhcp_type = 1;
		  $.ajax({
		    url: 'lanDhcpGetData1', 
		    type : 'POST', 
		    data: { 
		    	dhcp_type: dhcp_type 
		    	},
		    success: function(data) {
		      // Process the received JSON data
		      $('#ip_addr_dis_0').val(data.eth1_ipaddr);
				$('#subnet_mask_dis_0').val(data.eth1_subnet);
		       // $("#ip_addr_dis_0").text("eth1 ipaddr: " + data.eth1_ipaddr);
				//$("#subnet_mask_dis_0").text("eth1 subnet: " + data.eth1_subnet);
		    },
		    error: function(xhr, status, error) {
		      console.error('Error:', error);
		    }
		  });
		}
	
	function loadLanSettings() {
		$.ajax({
			url : 'lan',
			type : 'GET',
			dataType : 'json',
			beforeSend: function(xhr) {
		        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
		    },
			success : function(data) {
				
				var json1 = JSON.stringify(data);
				var json = JSON.parse(json1);
				handleStatus(json.status);
				//$('#dhcp_dis_1').val(data.eth0_dhcp);
				
				
				eth1_dhcp = data.eth1_dhcp;
				console.log('eth1_dhcp-->:', eth1_dhcp);
				if(eth1_dhcp == 0){
					getDhcpSettings();
				}else{
				$('#ip_addr_dis_0').val(data.eth1_ipaddr);
				$('#subnet_mask_dis_0').val(data.eth1_subnet);
				}
				$('#gateway_dis_0').val(data.eth1_gateway);
				$('#dns_dis_0').val(data.eth1_dns);	
				

				$('#ip_addr_dis_1').val(data.lan1_ipaddr);
				$('#subnet_mask_dis_1').val(data.lan1_subnet);
				$('#gateway_dis_1').val(data.lan1_gateway);
				$('#dns_dis_1').val(data.lan1_dns);	
				
				lan1_dhcp = data.lan1_dhcp;
				
				$('#ip_addr_dis_2').val(data.lan2_ipaddr);
				$('#subnet_mask_dis_2').val(data.lan2_subnet);
				$('#gateway_dis_2').val(data.lan2_gateway);
				$('#dns_dis_2').val(data.lan2_dns);
				
				lan2_dhcp = data.lan2_dhcp;
				$("#toggle_lan0").prop("checked", data.eth1_dhcp === "1");
	            $("#toggle_lan1").prop("checked", data.lan1_dhcp === "1");
	            $("#toggle_lan2").prop("checked", data.lan2_dhcp === "1");
				console.log('eth1_ipaddr:', data.eth1_ipaddr);
				console.log('eth1_subnet:', data.eth1_subnet);
				
				console.log('lan1_ipaddr:', data.lan1_ipaddr);
				console.log('lan1_subnet:', data.lan1_subnet);
				console.log('lan1_dhcp-->:', lan1_dhcp);
				console.log('lan2_ipaddr:', data.lan2_ipaddr);
				console.log('lan2_subnet:', data.lan2_subnet);
				console.log('lan2_dhcp-->:', lan2_dhcp);
				toggle0InputFields();
				toggle1InputFields();
				toggle2InputFields();
				//toggleDhcpSetting("0");
				//toggleDhcpSetting("1");
				//toggleDhcpSetting("2");
			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error: ' + error);
			}
		});
	}
	
	
	
	function editEth1() {
		// Display the custom modal dialog
		  var modal = document.getElementById('custom-modal-edit');
		  modal.style.display = 'block';
		  
		// Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-edit');
		  confirmButton.onclick = function () {
			  
			  var eth1_dhcp1 = $("#toggle_lan0").prop("checked") ? "1" : "0";
				console.log('eth1_dhcp1:', eth1_dhcp1);
				var lan_type = 'eth1';
				var eth1_ipaddr = $('#ip_addr_eth1').val();
				var eth1_subnet = $('#subnet_mask_eth1').val();   
				var eth1_gateway = $('#gateway_eth1').val();
				var eth1_dns = $('#dns_ip_eth1').val();
				
				$.ajax({
					
					url : 'lanUpdateServlet', 
					type : 'POST',
					data : {
						eth1_ipaddr : eth1_ipaddr,
						eth1_subnet : eth1_subnet,
						eth1_dhcp1 : eth1_dhcp1,
						lan_type : lan_type,
						eth1_gateway : eth1_gateway,
						eth1_dns : eth1_dns
					},
					success : function(data) {
						// Close the modal
				        modal.style.display = 'none';
							
							//clear fields
							$('#ip_addr_eth1').val('');
							$('#subnet_mask_eth1').val('');
							$('#gateway_eth1').val('');
							$('#dns_ip_eth1').val('');
					
					},
					error : function(xhr, status, error) {
						console.log('Error updating lan : ' + error);
					}
				});
			  
		  };
		  
		  var cancelButton = document.getElementById('cancel-button-edit');
		  cancelButton.onclick = function () {
		    // Close the modal
		    modal.style.display = 'none';
		    
		  };
	}
	
	function editLan1() {
		// Display the custom modal dialog
		  var modal = document.getElementById('custom-modal-edit');
		  modal.style.display = 'block';
		  
		// Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-edit');
		  confirmButton.onclick = function () {
			  
			  var lan1_dhcp1 = $("#toggle_lan1").prop("checked") ? "1" : "0";
				var lan1_type = 'lan1';
				var lan1_ipaddr = $('#ip_addr_lan1').val();
				var lan1_subnet = $('#subnet_mask_lan1').val();
				var lan1_gateway = $('#gateway_lan1').val();
				var lan1_dns = $('#dns_ip_lan1').val();
				
				$.ajax({
					
					url : 'upadateLan1', 
					type : 'POST',
					data : {
						lan1_ipaddr : lan1_ipaddr,
						lan1_subnet : lan1_subnet,
						lan1_dhcp1 : lan1_dhcp1,
						lan1_type : lan1_type,
						lan1_gateway : lan1_gateway,
						lan1_dns : lan1_dns
						
					},
					success : function(data) {					
							
						// Close the modal
				        modal.style.display = 'none';
						
							//clear fields
							$('#ip_addr_lan1').val('');
							$('#subnet_mask_lan1').val('');
							$('#gateway_lan1').val('');
							$('#dns_ip_lan1').val('');
					},
					error : function(xhr, status, error) {
						console.log('Error updating lan : ' + error);
					}
				});
				
		  };
		  
		  var cancelButton = document.getElementById('cancel-button-edit');
		  cancelButton.onclick = function () {
		    // Close the modal
		    modal.style.display = 'none';
		    
		  };
	}
	
	function editLan2() {
		// Display the custom modal dialog
		  var modal = document.getElementById('custom-modal-edit');
		  modal.style.display = 'block';
		  
		// Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-edit');
		  confirmButton.onclick = function () {
			
			  var lan1_dhcp2 = $("#toggle_lan2").prop("checked") ? "1" : "0";
				var lan2_type = 'lan2';
				var lan2_ipaddr = $('#ip_addr_lan2').val();
				var lan2_subnet = $('#subnet_mask_lan2').val();
				var lan2_gateway = $('#gateway_lan2').val();
				var lan2_dns = $('#dns_ip_lan2').val();
				
				$.ajax({
					
					url : 'upadateLan2',  
					type : 'POST',
					data : {
						lan2_ipaddr : lan2_ipaddr,
						lan2_subnet : lan2_subnet,
						lan1_dhcp2 : lan1_dhcp2,
						lan2_type : lan2_type,
						lan2_gateway : lan2_gateway,
						lan2_dns : lan2_dns
					},
					success : function(data) {					
						// Close the modal
				        modal.style.display = 'none';
							
							//clear fields
							$('#ip_addr_lan2').val('');
							$('#subnet_mask_lan2').val('');
							$('#gateway_lan2').val('');
							$('#dns_ip_lan2').val('');			

					},
					error : function(xhr, status, error) {
						console.log('Error updating lan : ' + error);
					}
				});
				
		  };
		  
		  var cancelButton = document.getElementById('cancel-button-edit');
		  cancelButton.onclick = function () {
		    // Close the modal
		    modal.style.display = 'none';
		    
		  };
	}
	
	
	function toggle0InputFields() {
        const toggle0 = document.getElementById("toggle_lan0");
        const ipInput0 = document.getElementById("ip_addr_eth1");
        const subnetInput0 = document.getElementById("subnet_mask_eth1");
        const gatway0 = document.getElementById("gateway_eth1");
        const dns0 = document.getElementById("dns_ip_eth1"); 
        
        if (toggle0.checked) {
        	 ipInput0.setAttribute("disabled", "disabled");
             subnetInput0.setAttribute("disabled", "disabled");
             gatway0.setAttribute("disabled", "disabled");
             dns0.setAttribute("disabled", "disabled");
        } else {
        	ipInput0.removeAttribute("disabled");
            subnetInput0.removeAttribute("disabled");
            gatway0.removeAttribute("disabled");
            dns0.removeAttribute("disabled");
           
        }
    }
	function toggle1InputFields() {
        const toggle1 = document.getElementById("toggle_lan1");
        const ipInput1 = document.getElementById("ip_addr_lan1");
        const subnetInput1 = document.getElementById("subnet_mask_lan1");
        const gatway1 = document.getElementById("gateway_lan1");
        const dns1 = document.getElementById("dns_ip_lan1");
        
        if (toggle1.checked) {
        	 ipInput1.setAttribute("disabled", "disabled");
             subnetInput1.setAttribute("disabled", "disabled");
             gatway1.setAttribute("disabled", "disabled");
             dns1.setAttribute("disabled", "disabled");
        } else {
        	ipInput1.removeAttribute("disabled");
            subnetInput1.removeAttribute("disabled");
            gatway1.removeAttribute("disabled");
            dns1.removeAttribute("disabled");
           
        }
    }
	function toggle2InputFields() {
        const toggle2 = document.getElementById("toggle_lan2");
        const ipInput2 = document.getElementById("ip_addr_lan2");
        const subnetInput2 = document.getElementById("subnet_mask_lan2");
        const gatway2 = document.getElementById("gateway_lan2");
        const dns2 = document.getElementById("dns_ip_lan2");
        
        if (toggle2.checked) {
        	ipInput2.setAttribute("disabled", "disabled");
            subnetInput2.setAttribute("disabled", "disabled");
            gatway2.setAttribute("disabled", "disabled");
            dns2.setAttribute("disabled", "disabled");
        } else {
        	ipInput2.removeAttribute("disabled");
            subnetInput2.removeAttribute("disabled");
            gatway2.removeAttribute("disabled");
            dns2.removeAttribute("disabled");
            
        }
    }
	
	function handleStatus(status) {
	    if (status === 'fail') {
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
	}

	
	
	
	
	function changeButtonColor(isDisabled) {
	    var $eth1button = $('#eth1_button');  
	    var $lan1button = $('#lan1_button');
	    var $lan2button = $('#lan2_button');
	   
	    var $discard1button = $('#discard1');  
	    var $discard2button = $('#discard2');
	    var $discard3button = $('#discard3');
	    
	     if (isDisabled) {
	        $eth1button.css('background-color', 'gray'); // Change to your desired color
	    } else {
	        $eth1button.css('background-color', '#2b3991'); // Reset to original color
	    }
	     
	     if (isDisabled) {
		        $lan1button.css('background-color', 'gray'); // Change to your desired color
		    } else {
		        $lan1button.css('background-color', '#2b3991'); // Reset to original color
		    }
	     
	     if (isDisabled) {
		        $discard1button.css('background-color', 'gray'); // Change to your desired color
		    } else {
		        $discard1button.css('background-color', '#2b3991'); // Reset to original color
		    }
	     
	     if (isDisabled) {
		        $eth1button.css('background-color', 'gray'); // Change to your desired color
		    } else {
		        $eth1button.css('background-color', '#2b3991'); // Reset to original color
		    }
		     
		     if (isDisabled) {
			        $discard2button.css('background-color', 'gray'); // Change to your desired color
			    } else {
			        $discard2button.css('background-color', '#2b3991'); // Reset to original color
			    }
		     
		     if (isDisabled) {
			        $discard3button.css('background-color', 'gray'); // Change to your desired color
			    } else {
			        $discard3button.css('background-color', '#2b3991'); // Reset to original color
			    }
	}
	
	
	$(document).ready(function() {
		
		<%// Access the session variable
		HttpSession role = request.getSession();
		String roleValue = (String) session.getAttribute("role");%>
	
	roleValue = '<%=roleValue%>';
		
		<%// Access the session variable
		HttpSession token = request.getSession();
		String tokenValue = (String) session.getAttribute("token");%>

		tokenValue = '<%=tokenValue%>';

		loadLanSettings();
		
		
	if (roleValue == 'VIEWER' || roleValue == 'Viewer') {
			
			$('#eth1_button').prop('disabled', true);
			$('#lan1_button').prop('disabled', true);
			$('#lan2_button').prop('disabled', true);
			
			$('#discard1').prop('disabled', true);
			$('#discard2').prop('disabled', true);
			$('#discard3').prop('disabled', true);
			
			changeButtonColor(true);
		}
		
		
		$('#get_dhcp_0').click(function(){		
				getDhcpSettings();
		 });	
		
		$('#eth1_button').click(function(){	
		    	editEth1();		  
		});
		
		$('#lan1_button').click(function(){		
			    	editLan1();		
			
		});
		
        $('#lan2_button').click(function(){
		    	editLan2();	 
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
			<h3>LAN SETTINGS</h3>
			<hr>
			<div class="container">
				<table>
					<tr>
						<th>TCP/IP(LAN 0)- Switched mode</th>
						<th>Current IP</th>
						<th>New IP</th>
					</tr>
					<tr>
						<td>DHCP</td>
						<td><label class="toggle"> <input id="toggle_lan0" name="toggle_lan0" onchange="toggle0InputFields()"
								class="toggle-input" type="checkbox" >
								 <span
								class="toggle-label" data-off="OFF" data-on="ON"></span> 
								<span
								class="toggle-handle"></span>
						</label></td>
						<tag>
   							 <td>
       							 <input type="button" value="DHCP IP 0" id="get_dhcp_0">
        							<p id="eth1_ipaddr1"></p>
       								 <p id="eth1_subnet1"></p>
    						</td>
						</tag>
					</tr>

					<tr>
						<td>IP address</td>

						<td><input id="ip_addr_dis_0" class="status" disabled
							type='text' name="ip_addr_dis_0" style="width: 18%;"></td>
							
						<td>
						<input id="ip_addr_eth1" class="config" type='text'
							name="ip_addr_eth1" style="width: 18%;"></td>
					</tr>
					<tr>
						<td>Subnet mask</td>
						<td><input id="subnet_mask_dis_0" class="status" disabled
							type='text' name="subnet_mask_dis_0" style="width: 18%;"></td>
							
						<td><input id="subnet_mask_eth1" class="config" type='text'
							name="subnet_mask_eth1" style="width: 18%;"></td>
					</tr>
					
					<tr>
						<td>Gateway</td>

						<td><input id="gateway_dis_0" class="status" disabled
							type='text' name="gateway_dis_0" style="width: 18%;"></td>
							
						<td>
						<input id="gateway_eth1" class="config" type='text'
							name="gateway_eth1" style="width: 18%;"></td>
					</tr>
					<tr>
						<td>DNS address</td>

						<td><input id="dns_dis_0" class="status" disabled
							type='text' name="dns_dis_0" style="width: 18%;"></td>
							
						<td>
						<input id="dns_ip_eth1" class="config" type='text'
							name="dns_ip_eth1" style="width: 18%;"></td>
					</tr>


				</table>
				<div style="margin-top: 1%;">
					<input type="button" value="Discard"
						style="background-color: #ef0803;" id="discard1"> 
						<input type="button"
						value="Apply changes" id="eth1_button">
				</div>
			</div>


			<div class="container" style="margin-top: 1%;">
				<table>
					<tr>
						<th>TCP/IP(LAN 1)- Switched mode</th>
						<th>Current IP</th>
						<th>New IP</th>
					</tr>
					<tr>
						<td>DHCP</td>
						<td><label class="toggle"> <input id="toggle_lan1" name="toggle_lan1" onchange="toggle1InputFields()"
								class="toggle-input" type="checkbox" > <span
								class="toggle-label" data-off="OFF" data-on="ON"></span> <span
								class="toggle-handle"></span>
						</label></td>
						<td><input type="button" value="DHCP IP 1" id="get_dhcp_1"></td>
						
					</tr>

					<tr>
						<td>IP address</td>

						<td><input id="ip_addr_dis_1" class="status" disabled
							type='text' name="ip_addr_dis_1" style="width: 18%;"></td>
						<td><input id="ip_addr_lan1" class="config" type='text'
							name="ip_addr_lan1" style="width: 18%;"></td>
					</tr>
					<tr>
						<td>Subnet mask</td>
						<td><input id="subnet_mask_dis_1" class="status" disabled
							type='text' name="subnet_mask_dis_1" style="width: 18%;"></td>
						<td><input id="subnet_mask_lan1" class="config" type='text'
							name="subnet_mask_lan1" style="width: 18%;"></td>
					</tr>
					<tr>
						<td>Gateway</td>

						<td><input id="gateway_dis_1" class="status" disabled
							type='text' name="gateway_dis_1" style="width: 18%;"></td>
							
						<td>
						<input id="gateway_lan1" class="config" type='text'
							name="gateway_lan1" style="width: 18%;"></td>
					</tr>
					<tr>
						<td>DNS address</td>

						<td><input id="dns_dis_1" class="status" disabled
							type='text' name="dns_dis_1" style="width: 18%;"></td>
							
						<td>
						<input id="dns_ip_lan1" class="config" type='text'
							name="dns_ip_lan1" style="width: 18%;"></td>
					</tr>


				</table>

				<div style="margin-top: 1%;">
					<input type="button" style="background-color: #ef0803;"
						value="Discard" id="discard2"> <input type="button"
						value="Apply changes" id="lan1_button">
				</div>
			</div>

			<div class="container" style="margin-top: 1%;">
				<table>
					<tr>
						<th>TCP/IP(LAN 2)- Switched mode</th>
						<th>Current IP</th>
						<th>New IP</th>
					</tr>
					<tr>
						<td>DHCP</td>
						<td><label class="toggle"> <input id="toggle_lan2" name="toggle_lan2" onchange="toggle2InputFields()"
								class="toggle-input" type="checkbox" > <span
								class="toggle-label" data-off="OFF" data-on="ON"></span> <span
								class="toggle-handle"></span>
						</label></td>
						<td><input type="button" value="DHCP IP 2" id="get_dhcp_2"></td>
					</tr>

					<tr>
						<td>IP address</td>

						<td><input id="ip_addr_dis_2" class="status" disabled
							type='text' name="ip_addr_dis_2" style="width: 18%;"></td>
						<td><input id="ip_addr_lan2" class="config" type='text'
							name="ip_addr_lan2" style="width: 18%;"></td>
					</tr>
					<tr>
						<td>Subnet mask</td>
						<td><input id="subnet_mask_dis_2" class="status" disabled
							type='text' name="subnet_mask_dis_2" style="width: 18%;"></td>
						<td><input id="subnet_mask_lan2" class="config" type='text'
							name="subnet_mask_lan2" style="width: 18%;"></td>
					</tr>
					<tr>
						<td>Gateway</td>

						<td><input id="gateway_dis_2" class="status" disabled
							type='text' name="gateway_dis_2" style="width: 18%;"></td>
							
						<td>
						<input id="gateway_lan2" class="config" type='text'
							name="gateway_lan2" style="width: 18%;"></td>
					</tr>
					<tr>
						<td>DNS address</td>

						<td><input id="dns_dis_2" class="status" disabled
							type='text' name="dns_dis_2" style="width: 18%;"></td>
							
						<td>
						<input id="dns_ip_lan2" class="config" type='text'
							name="dns_ip_lan2" style="width: 18%;"></td>
					</tr>


				</table>


				<div style="margin-top: 1%;">
					<input type="button" style="background-color: #ef0803;"
						value="Discard" id="discard3"> <input type="button"
						value="Apply changes" id="lan2_button">
				</div>

			</div>
			
			<div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to edit this lan setting?</p>
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
	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>