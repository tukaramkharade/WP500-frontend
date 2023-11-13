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
  
  #confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
}

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
		
		<h3>QUICK CLIENT</h3>
			<hr>
			
			 <div class="button-container">
        <button onClick="window.location.reload();">Reload</button>
    </div>
    
    <div class="container">
    <ul id="tree" class="tree">
		<li class="expandable" id="root">OPC Servers</li>
	</ul>
	
	<button id="addNodeButton">Add Child Node 000</button>
	<input type="text" id="newNodeName" placeholder="Enter child node name">
    
    
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