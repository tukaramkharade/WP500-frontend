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
ul.tree {
	list-style: none;
}

ul.tree li {
	padding-left: 20px;
}

.expandable:before {
	content: "▶";
	margin-right: 5px;
	cursor: pointer;
}

.expandable.collapsed:before {
	content: "▼";
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

/* Add the following style to clear the float and prevent overlapping content */
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
            background-color: #35449a;
            border-radius: 5px;
            border: none;
            color: white;
            font-size: small;
            margin-right: 10px;
             padding: 10px 20px;
        }
        
</style>
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
		
		
		 <div class="button-container">
        <button onClick="window.location.reload();">Reload</button>
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
	<td>Read Status:</td>
	<td><p id="read_status"></p></td>
	</tr>
	
	<tr>
	<td>Node</td>
	<td><textarea id="node"></textarea></td>
	</tr>
	
	<tr>
	<td>Value:</td>
	<td><p id="value"></p></td>
	</tr>
	
	<tr>
	<td>Quality:</td>
	<td><p id="quality"></p></td>
	</tr>
	
	<tr>
	<td>Data Type:</td>
	<td><p id="datatype"></p></td>
	</tr>
	
	<tr>
	<td>Timestamp:</td>
	<td><p id="timestamp"></p></td>
	</tr>
	
	</table>
	
	<div class="row" style="display: flex; justify-content: center; margin-bottom: 2%; margin-top: 1%;">
					
					<input style="height: 26px;" type="button" value="Add Tag" id="addTag"/> 
					
				</div>
	
	</div>
	
		
		
	</section>
	</div>

	<script>
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
                // Toggle the 'collapsed' class
                event.target.classList.toggle('collapsed');
                // Remove the 'selected' class from all nodes
                const nodes = document.querySelectorAll('.selected');
                nodes.forEach((node) => {
                    node.classList.remove('selected');
                });
                // Add the 'selected' class to the clicked node
                event.target.classList.add('selected');
                
                const clickedNodeName = event.target.textContent;
                //alert('Clicked node name: ' + clickedNodeName);
          
                const nodeid = event.target.dataset.nodeid;
                const opcname = event.target.dataset.opcname;
                const type = event.target.dataset.type;
                const browsename = event.target.dataset.browsename;
                
                loadopcnodesList(nodeid,opcname,type,browsename);
                event.target.classList.toggle('collapsed');
            }
            
        });
        
        
        
 function loadopcnodesList(nodeid,opcname,type,browsename) {
        	
    		$.ajax({
    					url : 'BrowseQuickCLient',
    					type : 'POST',
    					dataType : 'json',
    					data : {
    						node : nodeid,
    						type : type,
    						opcname : opcname,
    						browsename : browsename
    					},
    					success : function(response) {
    						
    						if (type === "Variable") {
    							
    							const nodeid = response.nodeid;
    					        const status = response.status;
    					        const value = response.value;
    					        const timestamp = response.timestamp;
    					        const dataType = response.dataType;
    					        const quality = response.quality;
    					        
    					       // alert('nodeid: '+nodeid);
    					       
    					     // Update the HTML elements with the retrieved values
    					        $('#node').val(nodeid);
    					        $('#read_status').text(status);    					        
    					        $('#value').text(value !== "null" ? value : '');
    					        $('#timestamp').text(timestamp);
    					        $('#datatype').text(dataType);
    					        $('#quality').text(quality);
    							
    						}else{
    							
    							const selectedNode = document.querySelector('.selected');
				                if (selectedNode) {
				                    const ul = selectedNode.querySelector('ul');
				                    
				                    if (!ul) {
				                        const newUl = document.createElement('ul');
				                        selectedNode.appendChild(newUl);
				                    }else {
				                        // Clear the existing <ul> by removing its child nodes
				                        while (ul.firstChild) {
				                            ul.removeChild(ul.firstChild);
				                        }
				                    }
				
				                    $.each(response.data,function(index, node) {
		 		                      ///  alert(node.nodeid); // For debugging
		 		                        
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
    						console.log('Error loading user data: ' + error);
    					}
    				});
    	}


        
      
        function loadopcList() {
        	
    		$.ajax({
    					url : 'BrowseQuickCLient',
    					type : 'GET',
    					dataType : 'json',
    					
    					success : function(response) {
    						const root = document.getElementById('root');
    		                if (root) {
    		                    let ul = root.querySelector('ul');
    		                    if (!ul) {
    		                        ul = document.createElement('ul');
    		                        root.appendChild(ul);
    		                    }else {
    		                        // Clear the existing <ul> by removing its child nodes
    		                        while (ul.firstChild) {
    		                            ul.removeChild(ul.firstChild);
    		                        }
    		                    }

    		                    response.data.forEach(function(displayName) {
    		                     //   alert(displayName); // For debugging
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
    		                    console.log('Element with ID "root" not found');
    		                }
    			            
    					},
    					error : function(xhr, status, error) {
    						console.log('Error loading user data: ' + error);
    					}
    				});
    	}

        
        $(document).ready(function() {
        	loadopcList();
        	
        	
        	 $('#addTag').click(function() {
        		 window.location.href = "TagMapping.jsp";
   		  });
        });
    </script>
</body>
</html>
