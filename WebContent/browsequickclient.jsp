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
<script src="jquery-3.6.0.min.js"></script>
<style>
ul.tree {
	list-style: none;
}

ul.tree li {
	padding-left: 20px;
	 cursor: pointer;
}

h3{
margin-top: 10px;
}

.quickclient_container {
    width: 60%;
    float: left; /* Add this line to make the container float to the left */
    background-color: #f2f2f2;
}

.status-container {
    float: right; /* Add this line to make the status-container float to the right */
    width: 35%; /* Adjust the width as needed */
    background-color: #f2f2f2;
}

.clearfix::after {
    content: "";
    clear: both;
    display: table;
}

textarea {
  width: 300px !important;
  height: 50px;
}

.button-container {
            display: flex;
            justify-content: flex-end;
            margin: 10px; /* Add margin as needed */
        }

        button {
            cursor: pointer;
            border-radius: 5px;
            border: none;      
            font-size: small;
            margin-right: 10px;
             padding: 10px 20px;
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

#confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
}
        
</style>
</head>
<body>
<script>
var csrfTokenValue;

$(document).ready(function() {
	<%// Access the session variable
	HttpSession csrfToken = request.getSession();
	String csrfTokenValue = (String) session.getAttribute("csrfToken");%>
	csrfTokenValue = '<%=csrfTokenValue%>';
});

</script>
<div class="sidebar">
		<%@ include file="common.jsp"%>
	</div>
	<div class="header">
		<%@ include file="header.jsp"%>
	</div>
	<input type="hidden" name="csrfToken" id="csrfToken" value="<%= csrfTokenValue %>" />	
	<div class="content">
		<section style="margin-left: 1em">		
		<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>
		 <div class="button-container">
        <button onClick="window.location.reload();" style="color:white; background-color: #2b3991">Reload</button>
    </div> 		
		<div class="quickclient_container">		
		<h3>QUICK CLIENT</h3>
		<hr/>			
	<ul id="tree" class="tree">
		<li class="expandable" id="root">OPC Servers</li>
	</ul>
	<button id="addNodeButton" style="display: none;"></button>
	</div>	
	<div class="status-container">	
	<h3>STATUS INFORMATION</h3>
	<hr/>	
	<table class="bordered-table" style="margin-top: -1px;">
	<tr>
	<td>Node</td>
	<td><textarea id="node"></textarea></td>
	<td></td>
	</tr>
	<tr>
	<td>Value:</td>
	<td><p id="value"></p></td>
	<td></td>
	</tr>
	<tr>
	<td>Quality:</td>
	<td><p id="quality"></p></td>
	<td></td>
	</tr>
	<tr>
	<td>Data Type:</td>
	<td><p id="datatype"></p></td>
	<td></td>
	</tr>
	<tr>
	<td>Timestamp:</td>
	<td><p id="timestamp"></p></td>
	<td></td>
	</tr>
	<tr>
	<td>Add tag name</td>
	<td><input type="text" id="tag_name" name="tag_name" maxlength="31" style="width: 200px; margin-bottom: 10px;" required/>
	<span id="field_tag_Error" class="error-message" style="display: block; margin-top: 5px;"></span>
	</td>
	<td><input style="height: 26px;" type="button" value="Add Tag" id="addTag"/></td>
	</tr>
	</table>
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
	<script>

	var roleValue;
	var tokenValue;
        document.getElementById('addNodeButton').addEventListener('click', function(event) {
            const newNodeText = document.getElementById('newNodeName').value;
            if (newNodeText) {
                const selectedNode = document.querySelector('.selected');
                if (selectedNode) {
                    const ul = selectedNode.querySelector('ul');
                    if (!ul) {
                        const newUl = document.createElement('ul');
                        selectedNode.appendChild(newUl);
                    }
                    const li = document.createElement('li');
                    li.textContent = newNodeText;
                    li.classList.add('expandable');
                    ul.appendChild(li);
                }
            }
        });

        const tree = document.getElementById('tree');
        tree.addEventListener('click', function(event) {
            if (event.target.tagName === 'LI') {
                event.target.classList.toggle('collapsed');
                const nodes = document.querySelectorAll('.selected');
                nodes.forEach((node) => {
                    node.classList.remove('selected');
                });
                event.target.classList.add('selected');            
                const clickedNodeName = event.target.textContent;      
                const nodeid = event.target.dataset.nodeid;
                const opcname = event.target.dataset.opcname;
                const type = event.target.dataset.type;
                const browsename = event.target.dataset.browsename;              
                loadopcnodesList(nodeid,opcname,type,browsename);
                event.target.classList.toggle('collapsed');
            }         
        });
        
        function changeButtonColor(isDisabled) {
            var $add_tag_button = $('#addTag');               
             if (isDisabled) {
                $add_tag_button.css('background-color', 'gray'); // Change to your desired color
            } else {
                $add_tag_button.css('background-color', '#2b3991'); // Reset to original color
            }          
        }
        
    	function validateTag(tag) {
        var regex = /^[a-zA-Z][a-zA-Z0-9]*$/;
        if (!regex.test(tag)) {
            return 'Invalid Tag name; symbols not allowed';
        }
        return null; /
    }
        
        function addTag() {		   		
    		var tag_name = $('#tag_name').val();
    		var pv_address = $('#node').val();
    		 var csrfToken = document.getElementById('csrfToken').value; 		
    		if (tag_name === '' || pv_address === '') { 	      
    	       $("#popupMessage").text('Tag name and PV address are required!');
          			$("#customPopup").show();       			
    	        return;
    	    }    	  
    	    $('#field_tag_Error').text('');   	   		
    	    var tagError = validateTag(tag_name);
    	    if (tagError) {
    	        $('#field_tag_Error').text(tagError).css({'color': 'red', 'max-width': '200px'}); // Adjust max-width as needed
    	        return;
    	    }   
    		$.ajax({
    			url : 'tagMapping',
    			type : 'POST',
    			data : {
    				tag_name : tag_name,
    				pv_address : pv_address,
    				csrfToken: csrfToken,
    				action: 'add'  				
    			},
    			success : function(data) {  				
         			$("#popupMessage").text(data.message);
          			$("#customPopup").show();
    				$('#tag_name').val('');   				
    			},
    			error : function(xhr, status, error) { 				
    			}
    		});   		
    	}	
 
 function loadopcnodesList(nodeid,opcname,type,browsename) {     	
	 var csrfToken = document.getElementById('csrfToken').value; 
    		$.ajax({
    					url : 'BrowseQuickCLient',
    					type : 'POST',
    					dataType : 'json',
    					data : {
    						node : nodeid,
    						type : type,
    						opcname : opcname,
    						browsename : browsename,
    						csrfToken: csrfToken
    					},
    					success : function(response) {						
    						if (type === "Variable") { 							
    							const nodeid = response.nodeid;
    					        const status = response.status;
    					        const value = response.value;
    					        const timestamp = response.timestamp;
    					        const dataType = response.dataType;
    					        const quality = response.quality;    					          					       
    					        $('#node').val(nodeid);
    					        $('#read_status').text(status);    					        
    					        $('#value').text(value !== "null" ? value : '');
    					        $('#timestamp').text(timestamp);
    					        $('#datatype').text(dataType);
    					        $('#quality').text(status);							
    						}else{						
    							const selectedNode = document.querySelector('.selected');
				                if (selectedNode) {
				                    const ul = selectedNode.querySelector('ul');				                    
				                    if (!ul) {
				                        const newUl = document.createElement('ul');
				                        selectedNode.appendChild(newUl);
				                    }else {
				                        while (ul.firstChild) {
				                            ul.removeChild(ul.firstChild);
				                        }
				                    }				
				                    $.each(response.data,function(index, node) {		 		                        
		 		                       const li = document.createElement('li');
					                    li.textContent = node.browsename;
					                    li.dataset.opcname = node.opcname; // Store nodeid as a data attribute
					                    li.dataset.browsename = node.browsename;
					                    li.dataset.type = node.type;
					                    li.dataset.nodeid = node.nodeid;       
					                    li.classList.add('expandable');
					                    ul.appendChild(li);					                    
		 		                    });			                    
				                }
    						}  						
    					},
    					error : function(xhr, status, error) {  						
    					}
    				});
    	}
 
        function loadopcList() {   	
    	    showLoader();     	
    		$.ajax({
    					url : 'BrowseQuickCLient',
    					type : 'GET',
    					dataType : 'json',  					
    					success : function(response) {
    			            hideLoader();  						
    						if (response.status == 'fail') {  							
   							 var modal = document.getElementById('custom-modal-session-timeout');
   							  modal.style.display = 'block';						  
   							    var sessionMsg = document.getElementById('session-msg');
   							    sessionMsg.textContent = response.message; // Assuming data.message contains the server message							  
   							  var confirmButton = document.getElementById('confirm-button-session-timeout');
   							  confirmButton.onclick = function () {							  
   							        modal.style.display = 'none';
   							        window.location.href = 'login.jsp';
  							  };								  
   						}  						
    						const root = document.getElementById('root');
    		                if (root) {
    		                    let ul = root.querySelector('ul');
    		                    if (!ul) {
    		                        ul = document.createElement('ul');
    		                        root.appendChild(ul);
    		                    }else {
    		                        while (ul.firstChild) {
    		                            ul.removeChild(ul.firstChild);
    		                        }
    		                    }

    		                    response.data.forEach(function(displayName) {
    		                        const li = document.createElement('li');
    		                        li.textContent = displayName;  		                        
    		                        li.classList.add('expandable'); 		                        
    		                        li.dataset.opcname = displayName; // Store nodeid as a data attribute
				                    li.dataset.browsename = displayName;
				                    li.dataset.type = 'server';
				                    li.dataset.nodeid = 'server';		                       
    		                        ul.appendChild(li);
    		                    });
    		                } else {  		                    
    		                }  			            
    					},
    					error : function(xhr, status, error) {
    			            hideLoader();   						    						
    					}
    				});
    	}

   	 function showLoader() {
   	     $('#loader-overlay').show();
   	 }

   	 function hideLoader() {
   	     $('#loader-overlay').hide();
   	 }
        
        $(document).ready(function() {        	
        	<%// Access the session variable
			HttpSession role = request.getSession();
			String roleValue = (String) session.getAttribute("role");%>
		roleValue = '<%=roleValue%>';				
		
		if (roleValue == 'OPERATOR' || roleValue == 'Operator') {
			$('#addTag').prop('disabled', true);
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
    		
    		$("#closePopup").click(function () {
    		    $("#customPopup").hide();
    		  });   		    		
    		loadopcList();        	
      	  $('#addTag').click(function() {
      		  addTag();
 		  }); 
    	    }
        	
        });
    </script>
</body>
</html>