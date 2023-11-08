<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>

<title>Dynamic Tree View</title>
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
</style>
</head>
<body>
	<h1>Dynamic Tree View</h1>
	<ul id="tree" class="tree">
		<li class="expandable" id="root">OPC Servers</li>
	</ul>

	<button id="addNodeButton">Add Child Node 000</button>
	<input type="text" id="newNodeName" placeholder="Enter child node name">

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
</body>
</html>
