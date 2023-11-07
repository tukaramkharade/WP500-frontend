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

button {
  margin: 5px;
  padding: 10px 20px;
  border: none;
  cursor: pointer;
}

#treeview .indented {
    margin-left: 10px; /* Adjust the margin as needed */
}

 #treeview ul {
        list-style-type: none;
        padding-left: 30px;
    }


    #treeview li {
        cursor: pointer;
        margin-bottom: 5px;
    }

    #treeview li::before {
        content: "\25B6"; /* Unicode character for a right-pointing triangle */
        margin-right: 5px;
    }

    #treeview li.expanded::before {
        content: "\25BE"; /* Unicode character for a down-pointing triangle */
    }

    #treeview li > ul {
        display: none;
    }

    #treeview li.expanded > ul {
        display: block;
    }

/* Style your modal and other elements as needed */


</style>

<script>

var roleValue;	
var tokenValue;
var textContent;
var textContent1;

function getOpcuaClientList(){
	
	$.ajax({
		
		url : 'QuickClientServlet',
		type : 'GET',
		dataType : 'json',
		beforeSend: function(xhr) {
	        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
	    },
	    success : function(data) {
	    	var json1 = JSON.stringify(data);

			var json = JSON.parse(json1);

			if (json.status == 'fail') {
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
			
			var treeData = data.data; // Assuming your data is structured as an array

            // Call populateTreeView with the treeData
            populateTreeView(treeData, $("#treeview"));
	    },
	    
	    error : function(xhr, status, error) {
			console.log('Error loading opcua client data: ' + error);
		}
	    
	});
	
}

/* function populateTreeView(nodes, container) {
    container.empty(); // Clear the existing content before populating

    
    
    for (var i = 0; i < nodes.length; i++) {
        var node = nodes[i];
        var ul = document.createElement("ul");
        container.append(ul);

        var li = document.createElement("li");
        li.textContent = node;
        ul.appendChild(li);
        

        // Add a click event handler for the dynamically generated <ul> elements
        ul.onclick = function (e) {
            e.stopPropagation();
             textContent = e.target.textContent.trim();
             //alert(textContent);
             getOPCNodes(textContent);
             
           
        };
        
        
    }
}  */

function populateTreeView(nodes, container) {
    container.empty(); // Clear the existing content before populating

    for (var i = 0; i < nodes.length; i++) {
        var node = nodes[i];
        var ul = document.createElement("ul");
        container.append(ul);

        var li = document.createElement("li");
        li.textContent = node; // You can leave this empty if the nodes have no specific property

        if (node.children && node.children.length > 0) {
            // Create an arrow icon if the node has children
            var arrow = document.createElement("span");
            arrow.classList.add("arrow");
            arrow.textContent = "\u25B6"; // Right-pointing triangle
            li.appendChild(arrow);
            li.addEventListener("click", function () {
                ul.classList.toggle("expanded");
                arrow.textContent = ul.classList.contains("expanded") ? "\u25BE" : "\u25B6";
            });
        }

        ul.appendChild(li);
        
     // Add a click event handler for the dynamically generated <ul> elements
          ul.onclick = function (e) {
            e.stopPropagation();
             textContent = e.target.textContent.trim();
             //alert(textContent);
             getOPCNodes(textContent);
             
           
        };  

         /* if (node.children && node.children.length > 0) {
            // If the node has children, recursively populate them
            populateTreeView(node.children, ul);
        }  */
         
        
        
    }
}







/* function getOPCNodes(opcname) {
    $.ajax({
        type: 'POST',
        url: 'QuickClientServlet',
        data: {
            opcname: opcname
        },
        success: function (response) {
        	
       	alert(response.data);
        	if (response.data) {
                var root = document.getElementById("treeview");

                if (root) {
                    // Check if ul already exists
                    var ul = root.querySelector("ul");
                    if (!ul) {
                        ul = document.createElement("ul");
                        ul.classList.add("populated"); // Add a class to mark as populated
                        root.appendChild(ul);
                    } else if (ul.classList.contains("populated")) {
                        // If ul is already populated, don't add again
                        return;
                    }

                    response.data.forEach(function (displayName) {
                        var li = document.createElement("li");
                        li.classList.add("arrow", "parent", "indented"); // Add "indented" class
                        li.textContent = displayName;
                        ul.appendChild(li);
                    });

                    ul.classList.add("populated"); // Mark ul as populated
                } else {
                    console.error("Root element not found.");
                }
            }
        },
        error: function () {
            alert('Error fetching displayNames');
        }
    });
}
 */
 
 
 function getOPCNodes(opcname) {
	    $.ajax({
	        type: 'POST',
	        url: 'QuickClientServlet',
	        data: {
	            opcname: opcname
	        },
	        success: function (response) {
	            alert(response.data);

	            if (response.data) {
	                var root = document.getElementById("treeview");

	                if (root) {
	                    // Check if ul already exists
	                    var ul = root.querySelector("ul");
	                    if (!ul) {
	                        ul = document.createElement("ul");
	                        ul.classList.add("populated"); // Add a class to mark as populated
	                        root.appendChild(ul);
	                    } else if (ul.classList.contains("populated")) {
	                        // If ul is already populated, don't add again
	                        return;
	                    }

	                    // Remove the 'selected' class from all nodes
	                    var selectedNodes = root.querySelectorAll('.selected');
	                    selectedNodes.forEach(function (node) {
	                        node.classList.remove('selected');
	                    });

	                    response.data.forEach(function (displayName) {
	                        var li = document.createElement("li");
	                        li.classList.add("arrow", "parent", "indented"); // Add "indented" class
	                        li.textContent = displayName;
	                        ul.appendChild(li);

	                        // Add a click event handler for the dynamically generated li elements
	                        li.addEventListener('click', function (event) {
	                            // Remove the 'selected' class from all nodes
	                            var nodes = root.querySelectorAll('.selected');
	                            nodes.forEach(function (node) {
	                                node.classList.remove('selected');
	                            });

	                            // Add the 'selected' class to the clicked node
	                            li.classList.add('selected');
	                        });
	                    });

	                    ul.classList.add("populated"); // Mark ul as populated
	                } else {
	                    console.error("Root element not found.");
	                }
	            }
	        },
	        error: function () {
	            alert('Error fetching displayNames');
	        }
	    });
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


getOpcuaClientList();

$("#treeview").on("click", "ul", function (e) {
    e.stopPropagation();
    $(this).toggleClass("expanded");
    $(this).find("li").toggleClass("expanded");
});

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
			
			<div class="treeview-container">
			
			 <div id="treeview">
    			
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