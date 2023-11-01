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

#treeview ul {
    list-style-type: none;
    padding-left: 20px;
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
            populateTreeView(treeData, $("#root"));
	    },
	    
	    error : function(xhr, status, error) {
			console.log('Error loading opcua client data: ' + error);
		}
	    
	});
	
}

function populateTreeView(nodes, container) {
    container.empty(); // Clear the existing content before populating

    for (var i = 0; i < nodes.length; i++) {
        var node = nodes[i];
        var listItem = $("<li>").text(node);

        container.append(listItem);
    }
}


function getOPCNodes(opcname) {
    $.ajax({
        type: 'POST',
        url: 'QuickClientServlet',
        data: {
            opcname: opcname
        },
        success: function (response) {
            if (response.displayNames) {
                var root = document.getElementById("root");

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

                    response.displayNames.forEach(function (displayName) {
                        var li = document.createElement("li");
                        li.classList.add("arrow", "parent");
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



$(document).ready(function() {
	<%// Access the session variable
	HttpSession role = request.getSession();
	String roleValue = (String) session.getAttribute("role");%>

roleValue = '<%=roleValue%>';

				<%// Access the session variable
HttpSession token = request.getSession();
String tokenValue = (String) session.getAttribute("token");%>

tokenValue = '<%=tokenValue%>';

//Hide child nodes initially
$("#root ul").hide();

// Toggle child nodes when clicking on parent nodes
$("#root li:has(ul)").click(function(e) {
    e.stopPropagation();
    $(this).children("ul").slideToggle();
});

  
  $('#root').on('click', 'li', function() {
	  var textContent = $(this).text();
      var ul = $(this).children("ul");

      if (ul.length === 0) {
          getOPCNodes(textContent);
      }
	});

  $('#root').on('click', function() {
      var ul = $(this).find("ul");
      var isExpanded = ul.is(":visible");

      if (isExpanded) {
          ul.slideUp();
      } else {
          ul.slideDown();
      }

      $(this).toggleClass("expanded"); // Toggle the expanded class
  });
  
  // Hide the displayed text when the mouse moves away from the tree view item
  /* $('#root').on('mouseout', 'li', function() {
    $('#display-hovered-text').hide();
  }); */
  
  document.addEventListener("DOMContentLoaded", function () {
	    var treeView = document.getElementById("treeview");

	    // Add click event to expand/collapse nodes
	    treeView.addEventListener("click", function (event) {
	        if (event.target.tagName === "LI" && event.target !== treeView) {
	            event.stopPropagation();
	            var ul = event.target.querySelector("ul");
	            if (ul) {
	                ul.style.display = ul.style.display === "none" ? "block" : "none";
	                event.target.classList.toggle("expanded");
	            }
	        }
	    });
	});
  
getOpcuaClientList();


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
    			<ul id="root">
        			<li></li>
    			</ul>
			</div>
    		<!-- <div id="display-hovered-text" style="display: none;"></div> -->
    		
			
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