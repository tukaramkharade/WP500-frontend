<%  
    // Add X-Frame-Options header to prevent clickjacking
    response.setHeader("X-Frame-Options", "DENY");
%>

<!DOCTYPE html>
<html>

<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png" />

<link rel="stylesheet" href="css_files/ionicons.min.css">
<link rel="stylesheet" href="css_files/normalize.min.css">
<link rel="stylesheet" href="css_files/fonts.txt" type="text/css">
<link rel="stylesheet" type="text/css" href="nav-bar.css">
<script src="jquery-3.6.0.min.js"></script>

<style>

h3{
margin-top: 75px;
}

.modal-session-timeout,
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

.modal-content-session-timeout,
.modal-content-edit  {
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

#confirm-button-edit,
#confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
}

#cancel-button-edit{
  background-color: #f44336;
  color: white;
}

 .validation-container {
            position: relative;
            width: 70%; /* Adjust the width as needed */
        }

        .validation-message {
            color: red;
            margin-top: 5px;
            position: absolute;
            bottom: 0;
        }
        
        
        .popup {
  display: block;
  position: absolute;
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
   
   
   .toggle {
  position: relative;
  display: block;
  width: 49px;
  height: 20px;
  padding: 3px;
  border-radius: 50px;
  cursor: pointer;
  font-size: small;
  z-index: 1 !important; /* Lower z-index for the toggle switch */
}

.toggle-label,
.toggle-handle {
position: relative;
  transition: All 0.3s ease;
  -webkit-transition: All 0.3s ease;
  -moz-transition: All 0.3s ease;
  -o-transition: All 0.3s ease;
   z-index: 1 !important;
}

#loader-overlay {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(255, 255, 255, 0.7); /* Transparent white background */
    z-index: 1000; /* Ensure the loader is on top of other elements */
    justify-content: center;
    align-items: center;
}

#loader {
    text-align: center;
   margin-left: 120px;
    background: rgba(255, 255, 255, 0.2); /* Transparent white background */
    border-radius: 5px;
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
	var dhcpType;
	
	function getDhcpSettings(dhcpType) {
		var dhcp_type = dhcpType;
		  $.ajax({
		    url: 'lanDhcpGetData1', 
		    type : 'POST', 
		    data: { 
		    	dhcp_type: dhcp_type 
		    	},
		    success: function(data) {
		    	if (data.status === 'success') {
	                if (data.eth0_dhcp === '0') {
	                    $('#ip_addr_dis_0').val(data.eth1_ipaddr);
	                    $('#subnet_mask_dis_0').val(data.eth1_subnet);
	                } else if (data.eth0_dhcp === '1') {
	                    $('#ip_addr_dis_1').val(data.eth1_ipaddr);
	                    $('#subnet_mask_dis_1').val(data.eth1_subnet);
	                } else if (data.eth0_dhcp === '2') {
	                    $('#ip_addr_dis_2').val(data.eth1_ipaddr);
	                    $('#subnet_mask_dis_2').val(data.eth1_subnet);
	                }else{
	                	loadLanSettingsIfDhcpNot();
	                }
	            } else {
	            	loadLanSettingsIfDhcpNot();
	                console.error('Error: Data status is not success');
	            }
		    },
		    error: function(xhr, status, error) {
		      console.error('Error:', error);
		    }
		  });
		}
	
	function loadLanSettings() {
		
		// Display loader when the request is initiated
	    showLoader();
		
		$.ajax({
			url : 'lan',
			type : 'GET',
			dataType : 'json',
			beforeSend: function(xhr) {
		        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
		    },
			success : function(data) {
				// Hide loader when the response has arrived
	            hideLoader();
				
				if(data.status == 'fail'){
					var modal = document.getElementById('custom-modal-session-timeout');
					  modal.style.display = 'block';
					  
					// Update the session-msg content with the message from the server
					    var sessionMsg = document.getElementById('session-msg');
					    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

					  
					  // Handle the confirm button click
					  var confirmButton = document.getElementById('confirm-button-session-timeout');
					  confirmButton.onclick = function () {
						  
						// Close the modal
					        modal.style.display = 'none';
					        window.location.href = 'login.jsp';
					  };
				}
								
				eth1_dhcp = data.eth1_dhcp;
				console.log('eth1_dhcp-->:', eth1_dhcp);
				if(eth1_dhcp == 1){
					dhcpType=0;
					getDhcpSettings(dhcpType);
				}else{
				$('#ip_addr_dis_0').val(data.eth1_ipaddr);
				$('#subnet_mask_dis_0').val(data.eth1_subnet);
				}
				
				$('#gateway_dis_0').val(data.eth1_gateway);
				$('#dns_dis_0').val(data.eth1_dns);	
				
				lan1_dhcp = data.lan1_dhcp;
				if(lan1_dhcp == 1){
					dhcpType=1;
					getDhcpSettings(dhcpType);
				}else{
					$('#ip_addr_dis_1').val(data.lan1_ipaddr);
					$('#subnet_mask_dis_1').val(data.lan1_subnet);
				}	

				
				$('#gateway_dis_1').val(data.lan1_gateway);
				$('#dns_dis_1').val(data.lan1_dns);	
				//$('#toggle_enable_lan1').val(data.lan1_enable);
				$('#toggle_enable_lan1').prop('checked', data.lan1_enable == 1);
				
				lan2_dhcp = data.lan2_dhcp;
				if(lan2_dhcp == 1){
					dhcpType=2;
					getDhcpSettings(dhcpType);
				}else{
					$('#ip_addr_dis_2').val(data.lan2_ipaddr);
					$('#subnet_mask_dis_2').val(data.lan2_subnet);
				}			
				
				$('#gateway_dis_2').val(data.lan2_gateway);
				$('#dns_dis_2').val(data.lan2_dns);
				
				 $('#toggle_enable_lan2').prop('checked', data.lan2_enable == 1);
				 
				//$('#toggle_enable_lan2').val(data.lan2_enable);
				
				
				$("#toggle_lan0").prop("checked", data.eth1_dhcp === "1");
	            $("#toggle_lan1").prop("checked", data.lan1_dhcp === "1");
	            $("#toggle_lan2").prop("checked", data.lan2_dhcp === "1");
				
				toggle0InputFields();
				toggle1InputFields();
				toggle2InputFields();
				
			},
			error : function(xhr, status, error) {
				// Hide loader when the response has arrived
	            hideLoader();
				
				// Handle the error response, if needed
				console.log('Error: ' + error);
			}
		});
	}
	function loadLanSettingsIfDhcpNot() {
		$.ajax({
			url : 'lan',
			type : 'GET',
			dataType : 'json',
			beforeSend: function(xhr) {
		        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
		    },
			success : function(data) {
				if(data.status == 'fail'){
					var modal = document.getElementById('custom-modal-session-timeout');
					  modal.style.display = 'block';
					  
					// Update the session-msg content with the message from the server
					    var sessionMsg = document.getElementById('session-msg');
					    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

					  
					  // Handle the confirm button click
					  var confirmButton = document.getElementById('confirm-button-session-timeout');
					  confirmButton.onclick = function () {
						  
						// Close the modal
					        modal.style.display = 'none';
					        window.location.href = 'login.jsp';
					  };
				}
								
				eth1_dhcp = data.eth1_dhcp;
				console.log('eth1_dhcp-->:', eth1_dhcp);
				
				$('#ip_addr_dis_0').val(data.eth1_ipaddr);
				$('#subnet_mask_dis_0').val(data.eth1_subnet);
				$('#gateway_dis_0').val(data.eth1_gateway);
				$('#dns_dis_0').val(data.eth1_dns);	
				
				lan1_dhcp = data.lan1_dhcp;				
				$('#ip_addr_dis_1').val(data.lan1_ipaddr);
				$('#subnet_mask_dis_1').val(data.lan1_subnet);		
				$('#gateway_dis_1').val(data.lan1_gateway);
				$('#dns_dis_1').val(data.lan1_dns);	
				$('#toggle_enable_lan1').val(data.lan1_enable);
				
				lan2_dhcp = data.lan2_dhcp;
				
				$('#ip_addr_dis_2').val(data.lan2_ipaddr);
				$('#subnet_mask_dis_2').val(data.lan2_subnet);
				$('#gateway_dis_2').val(data.lan2_gateway);
				$('#dns_dis_2').val(data.lan2_dns);
				$('#toggle_enable_lan2').val(data.lan2_enable);			
				
				$("#toggle_lan0").prop("checked", data.eth1_dhcp === "1");
	            $("#toggle_lan1").prop("checked", data.lan1_dhcp === "1");
	            $("#toggle_lan2").prop("checked", data.lan2_dhcp === "1");				
				toggle0InputFields();
				toggle1InputFields();
				toggle2InputFields();				
			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error: ' + error);
			}
		});
	}
	
	
	
	function editEth1() {
		
		var eth1_ipaddr = $('#ip_addr_eth1').val();
		var eth1_subnet = $('#subnet_mask_eth1').val();   
		 var eth1_dhcp1 = $("#toggle_lan0").prop("checked") ? "1" : "0";
        
	if (!eth1_ipaddr && !eth1_subnet && eth1_dhcp1 == 0) {
        // Display the custom popup message
        $("#popupMessage").text("Please provide both subnet and ipaddr.");
        $("#customPopup").show();
        return; // Don't proceed further if fields are blank
        
    }else{
	
		// Display the custom modal dialog
		  var modal = document.getElementById('custom-modal-edit');
		  modal.style.display = 'block';
		  
		// Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-edit');
		  confirmButton.onclick = function () {
			  
			 
				console.log('eth1_dhcp1:', eth1_dhcp1);
				var lan_type = 'lan0';
				
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
						
				        loadLanSettings();
							
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
	}
	
	function editLan1() {
		
		var lan1_ipaddr = $('#ip_addr_lan1').val();
		var lan1_subnet = $('#subnet_mask_lan1').val();
		var lan1_dhcp1 = $("#toggle_lan1").prop("checked") ? "1" : "0";
        
	if (!lan1_subnet && !lan1_ipaddr && lan1_dhcp1 == 0) {
        // Display the custom popup message
        $("#popupMessage").text("Please provide both subnet and ipaddr.");
        $("#customPopup").show();
        return; // Don't proceed further if fields are blank
        
    }else{
	
		// Display the custom modal dialog
		  var modal = document.getElementById('custom-modal-edit');
		  modal.style.display = 'block';
		  
		// Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-edit');
		  confirmButton.onclick = function () {
			  
			  
				var lan1_type = 'lan1';
				
				var lan1_gateway = $('#gateway_lan1').val();
				var lan1_dns = $('#dns_ip_lan1').val();
				 var toggle_enable_lan1 = $("#toggle_enable_lan1").prop("checked") ? "1" : "0";
				
				$.ajax({
					
					url : 'upadateLan1', 
					type : 'POST',
					data : {
						lan1_ipaddr : lan1_ipaddr,
						lan1_subnet : lan1_subnet,
						lan1_dhcp1 : lan1_dhcp1,
						lan1_type : lan1_type,
						lan1_gateway : lan1_gateway,
						lan1_dns : lan1_dns,
						toggle_enable_lan1 : toggle_enable_lan1
						
					},
					success : function(data) {					
							
						// Close the modal
				        modal.style.display = 'none';
						
				        loadLanSettings();
						
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
	}
	
	
	function editLan2() {
		 var lan2_ipaddr = $('#ip_addr_lan2').val();
	        var lan2_subnet = $('#subnet_mask_lan2').val();
	        var lan1_dhcp2 = $("#toggle_lan2").prop("checked") ? "1" : "0";
	        
	       
			if (!lan2_subnet && !lan2_ipaddr && lan1_dhcp2 == 0) {
				// Display the custom popup message
	            $("#popupMessage").text("Please provide both subnet and ipaddr.");
	            $("#customPopup").show();
	            
	         // Hide the toggle switch
	            $("#toggle_enable_lan1").closest("td").hide();
	            
			
			
			return;
             // Don't proceed further if fields are blank
            
			}
			else {
				
	    // Display the custom modal dialog
	    var modal = document.getElementById('custom-modal-edit');
	    modal.style.display = 'block';
	 
	    // Handle the confirm button click
	    var confirmButton = document.getElementById('confirm-button-edit');
	    confirmButton.onclick = function () {
	 
	        var lan1_dhcp2 = $("#toggle_lan2").prop("checked") ? "1" : "0";
	       
	        
	        var lan2_type = 'lan2';
	       
	        var lan2_gateway = $('#gateway_lan2').val();
	        var lan2_dns = $('#dns_ip_lan2').val();
	        var toggle_enable_lan2 = $("#toggle_enable_lan2").prop("checked") ? "1" : "0";
	 
	        $.ajax({
	            url: 'upadateLan2',
	            type: 'POST',
	            data: {
	                lan2_ipaddr: lan2_ipaddr,
	                lan2_subnet: lan2_subnet,
	                lan1_dhcp2: lan1_dhcp2,
	                lan2_type: lan2_type,
	                lan2_gateway: lan2_gateway,
	                lan2_dns: lan2_dns,
	                toggle_enable_lan2: toggle_enable_lan2
	            },
	            success: function (data) {
	                // Close the modal
	                modal.style.display = 'none';
	                
	                loadLanSettings();
	 
	                // Clear fields
	                $('#ip_addr_lan2').val('');
	                $('#subnet_mask_lan2').val('');
	                $('#gateway_lan2').val('');
	                $('#dns_ip_lan2').val('');
	            },
	            error: function (xhr, status, error) {
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
		        $lan2button.css('background-color', 'gray'); // Change to your desired color
		    } else {
		        $lan2button.css('background-color', '#2b3991'); // Reset to original color
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
	
	function validateIPAddress(inputId, spanId) {
	    var ipAddress = document.getElementById(inputId).value;
	    var ipRegex = /^(\d{1,3}\.){0,3}\d{1,3}$/;
	    var validationMessageSpan = document.getElementById(spanId);

	    if (ipRegex.test(ipAddress)) {
	        validationMessageSpan.innerHTML = "";
	        return true; // IP address is valid
	    } else {
	        validationMessageSpan.innerHTML = "Invalid IP Address. Please enter a valid IP address.";
	        return false; // IP address is invalid
	    }
	}

	function validateIPAddressOrBlank(inputId, spanId) {
	    var value = document.getElementById(inputId).value.trim();
	    
	    // Allow blank value or validate IP address
	    if (value === "" || /^(\d{1,3}\.){0,3}\d{1,3}$/.test(value)) {
	        document.getElementById(spanId).innerHTML = "";
	        return true;
	    } else {
	        document.getElementById(spanId).innerHTML = "Invalid input. Please enter a valid IP address or leave it blank.";
	        return false;
	    }
	}
	
	// Function to show the loader
	 function showLoader() {
	     // Show the loader overlay
	     $('#loader-overlay').show();
	 }

	 // Function to hide the loader
	 function hideLoader() {
	     // Hide the loader overlay
	     $('#loader-overlay').hide();
	 }
	 
	
	$(document).ready(function() {
		
		$("#closePopup").click(function () {
	        $("#customPopup").hide();
	     // Show the toggle switch
            $("#toggle_enable_lan1").closest("td").show();
	    });
		
		<%// Access the session variable
		HttpSession role = request.getSession();
		String roleValue = (String) session.getAttribute("role");%>
	
	roleValue = '<%=roleValue%>';
		
	if (roleValue == 'OPERATOR' || roleValue == 'Operator') {
			
			$('#eth1_button').prop('disabled', true);
			$('#lan1_button').prop('disabled', true);
			$('#lan2_button').prop('disabled', true);
			
			$('#discard1').prop('disabled', true);
			$('#discard2').prop('disabled', true);
			$('#discard3').prop('disabled', true);
			
			changeButtonColor(true);
		}
	
	if (roleValue === "null") {
        var modal = document.getElementById('custom-modal-session-timeout');
        modal.style.display = 'block';
        
        // Update the session-msg content with the message from the server
	    var sessionMsg = document.getElementById('session-msg');
	    sessionMsg.textContent = 'You are not allowed to redirect like this !!'; 

        // Handle the confirm button click
        var confirmButton = document.getElementById('confirm-button-session-timeout');
        confirmButton.onclick = function() {
            // Close the modal
            modal.style.display = 'none';
            window.location.href = 'login.jsp';
        };
    } else{
    	<%// Access the session variable
		HttpSession token = request.getSession();
		String tokenValue = (String) session.getAttribute("token");%>

		tokenValue = '<%=tokenValue%>';

		loadLanSettings();
		
		$('#get_dhcp_0').click(function(){		
			getDhcpSettings();
	 });	
	
		$('#eth1_button').click(function () {
		    if (!isFieldDisabled('ip_addr_eth1') &&
		        !isFieldDisabled('subnet_mask_eth1') &&
		        !isFieldDisabled('gateway_eth1') &&
		        !isFieldDisabled('dns_ip_eth1') &&
		        validateIPAddress('ip_addr_eth1', 'validationMessage') &&
		        validateIPAddress('subnet_mask_eth1', 'validationMessage1') &&
		        validateIPAddressOrBlank('gateway_eth1', 'validationMessage2') &&
		        validateIPAddressOrBlank('dns_ip_eth1', 'validationMessage3')) {
		        editEth1();
		    }
		});

		$('#lan1_button').click(function () {
		    if (!isFieldDisabled('ip_addr_lan1') &&
		        !isFieldDisabled('subnet_mask_lan1') &&
		        !isFieldDisabled('gateway_lan1') &&
		        !isFieldDisabled('dns_ip_lan1') &&
		        validateIPAddress('ip_addr_lan1', 'validationMessage5') &&
		        validateIPAddress('subnet_mask_lan1', 'validationMessage6') &&
		        validateIPAddressOrBlank('gateway_lan1', 'validationMessage7') &&
		        validateIPAddressOrBlank('dns_ip_lan1', 'validationMessage8')) {
		        editLan1();
		    }
		});

		$('#lan2_button').click(function () {
		     if (!isFieldDisabled('ip_addr_lan2') &&
		        !isFieldDisabled('subnet_mask_lan2') &&
		        !isFieldDisabled('gateway_lan2') &&
		        !isFieldDisabled('dns_ip_lan2') &&
		         validateIPAddress('ip_addr_lan2', 'validationMessage9') &&
		        validateIPAddress('subnet_mask_lan2', 'validationMessage10') &&
		        validateIPAddressOrBlank('gateway_lan2', 'validationMessage11') &&
		        validateIPAddressOrBlank('dns_ip_lan2', 'validationMessage12') 
		        ) { 
		        editLan2();
		    }else{
		    	editLan2();
		    }
		    
		     
		});

		function isFieldDisabled(fieldId) {
		    return $('#' + fieldId).prop('disabled');
		}

		
		
    }
		
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
			<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>
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
							type='text' name="ip_addr_dis_0" style="width: 30%;"></td>
							
						<td>
						 <div class="validation-container">
                    <input id="ip_addr_eth1" class="config" type='text' name="ip_addr_eth1" style="width: 42%;" required>
                    <span id="validationMessage" class="validation-message" style="margin-left: 10px;"></span>
                </div>
            
					</td>
					</tr>
					<tr>
						<td>Subnet mask</td>
						<td><input id="subnet_mask_dis_0" class="status" disabled
							type='text' name="subnet_mask_dis_0" style="width: 30%;"></td>
							
						<td>
							
					<div class="validation-container">
                    <input id="subnet_mask_eth1" class="config" type='text' name="subnet_mask_eth1" style="width: 42%;" required>
                    <span id="validationMessage1" class="validation-message" style="margin-left: 10px;"></span>
                </div>		
							</td>
					</tr>
					
					<tr>
						<td>Gateway</td>

						<td><input id="gateway_dis_0" class="status" disabled
							type='text' name="gateway_dis_0" style="width: 30%;"></td>
							
						<td>
						
						<div class="validation-container">
                    <input id="gateway_eth1" class="config" type='text' name="gateway_eth1" style="width: 42%;">
                    <span id="validationMessage2" class="validation-message" style="margin-left: 10px;"></span>
                </div>			
							
							</td>
					</tr>
					<tr>
						<td>DNS address</td>

						<td><input id="dns_dis_0" class="status" disabled
							type='text' name="dns_dis_0" style="width: 30%;"></td>
							
						<td>
						
							<div class="validation-container">
                    <input id="dns_ip_eth1" class="config" type='text' name="dns_ip_eth1" style="width: 42%;">
                    <span id="validationMessage3" class="validation-message" style="margin-left: 10px;"></span>
                </div>	
							
							</td>
					</tr>


				</table>
				<div style="margin-top: 1%;">
					
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
							type='text' name="ip_addr_dis_1" style="width: 30%;"></td>
						
						
						<td>
					
						<div class="validation-container">
                    <input id="ip_addr_lan1" class="config" type='text' name="ip_addr_lan1" style="width: 42%;" required>
                    <span id="validationMessage5" class="validation-message" style="margin-left: 10px;"></span>
                </div>	
                	
							</td>
					</tr>
					<tr>
						<td>Subnet mask</td>
						<td>
						<input id="subnet_mask_dis_1" class="status" disabled
							type='text' name="subnet_mask_dis_1" style="width: 30%;"></td>
							
						<td>
						
							<div class="validation-container">
                    <input id="subnet_mask_lan1" class="config" type='text' name="subnet_mask_lan1" style="width: 42%;" required>
                    <span id="validationMessage6" class="validation-message" style="margin-left: 10px;"></span>
                </div>	
							
							</td>
					</tr>
					<tr>
						<td>Gateway</td>

						<td><input id="gateway_dis_1" class="status" disabled
							type='text' name="gateway_dis_1" style="width: 30%;"></td>
							
						<td>
						
							<div class="validation-container">
                    <input id="gateway_lan1" class="config" type='text' name="gateway_lan1" style="width: 42%;">
                    <span id="validationMessage7" class="validation-message" style="margin-left: 10px;"></span>
                </div>	
							
							</td>
					</tr>
					<tr>
						<td>DNS address</td>

						<td><input id="dns_dis_1" class="status" disabled
							type='text' name="dns_dis_1" style="width: 30%;"></td>
							
						<td>
						
							<div class="validation-container">
                    <input id="dns_ip_lan1" class="config" type='text' name="dns_ip_lan1" style="width: 42%;">
                    <span id="validationMessage8" class="validation-message" style="margin-left: 10px;"></span>
                </div>	
							
							
							</td>
					</tr>
					
					<tr>
						<td>Enable Port</td>

						<td><label class="toggle"> <input id="toggle_enable_lan1" name="toggle_enable_lan1"
								class="toggle-input" type="checkbox" > <span
								class="toggle-label" data-off="OFF" data-on="ON"></span> <span
								class="toggle-handle"></span>
						</label></td>
					</tr>


				</table>

				<div style="margin-top: 1%;">
					<input type="button"
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
							type='text' name="ip_addr_dis_2" style="width: 30%;"></td>
							
						<td>
						<div class="validation-container">
                    <input id="ip_addr_lan2" class="config" type='text' name="ip_addr_lan2" style="width: 42%;" required>
                    <span id="validationMessage9" class="validation-message" style="margin-left: 10px;"></span>
                </div>	
							
							</td>
					</tr>
					<tr>
						<td>Subnet mask</td>
						<td><input id="subnet_mask_dis_2" class="status" disabled
							type='text' name="subnet_mask_dis_2" style="width: 30%;"></td>
							
						<td>
						
							<div class="validation-container">
                    <input id="subnet_mask_lan2" class="config" type='text' name="subnet_mask_lan2" style="width: 42%;" required>
                    <span id="validationMessage10" class="validation-message" style="margin-left: 10px;"></span>
                </div>	
                
							</td>
					</tr>
					<tr>
						<td>Gateway</td>

						<td><input id="gateway_dis_2" class="status" disabled
							type='text' name="gateway_dis_2" style="width: 30%;"></td>
							
						<td>
						
						<div class="validation-container">
                    <input id="gateway_lan2" class="config" type='text' name="gateway_lan2" style="width: 42%;">
                    <span id="validationMessage11" class="validation-message" style="margin-left: 10px;"></span>
                </div>	
                	
							</td>
					</tr>
					<tr>
						<td>DNS address</td>

						<td><input id="dns_dis_2" class="status" disabled
							type='text' name="dns_dis_2" style="width: 30%;"></td>
							
						<td>
						
							<div class="validation-container">
                    <input id="dns_ip_lan2" class="config" type='text' name="dns_ip_lan2" style="width: 42%;">
                    <span id="validationMessage12" class="validation-message" style="margin-left: 10px;"></span>
                </div>	
							</td>
					</tr>
					
					<tr>
						<td>Enable Port</td>

						<td><label class="toggle"> <input id="toggle_enable_lan2" name="toggle_enable_lan2"
								class="toggle-input" type="checkbox" > <span
								class="toggle-label" data-off="OFF" data-on="ON"></span> <span
								class="toggle-handle"></span>
						</label></td>
					</tr>


				</table>


				<div style="margin-top: 1%; margin-bottom: 5px;">
					 <input type="button"
						value="Apply changes" id="lan2_button">
				</div>

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
				 <p id="session-msg"></p>
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