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

#treeview li {
    list-style: none;
    cursor: pointer;
}

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
            populateTreeView(treeData, $("#treeview"));
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

function getOPCNodes(opcname){
	
	
	$.ajax({
	      type: 'POST',
	      url: 'QuickClientServlet', // Replace with the actual server endpoint
	      data: {
	    	  opcname : opcname
	      },
	      success: function (response) {
	        // Check the response status and handle it accordingly
	        /* if (response.status === 'success' && response.data && response.data[0].displayName) {
	          var displayName = response.data[0].displayName;
	          $('#display-displayName').text('Display Name: ' + displayName);
	          $('#display-displayName').show();
	        } else {
	          $('#display-displayName').text('Display Name Not Found');
	          $('#display-displayName').show();
	        } */
	      },
	      error: function () {
	     //   alert('Error fetching displayName');
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
$("#treeview ul").hide();

// Toggle child nodes when clicking on parent nodes
$("#treeview li:has(ul)").click(function(e) {
    e.stopPropagation();
    $(this).children("ul").slideToggle();
});

/* $('#treeview').on('mouseover', 'li', function() {
     textContent = $(this).text();
     getOPCNodes(textContent);
   
  }); */
  
  $('#treeview').on('click', 'li', function() {
	    var textContent = $(this).text();
	    getOPCNodes(textContent);
	});

  // Hide the displayed text when the mouse moves away from the tree view item
  $('#treeview').on('mouseout', 'li', function() {
    $('#display-hovered-text').hide();
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
			
			 <ul id="treeview">
        		<li id="root"></li>
    		</ul>
    		<div id="display-hovered-text" style="display: none;"></div>
    		 <!-- <div id="display">
    			<div id="display-displayName" style="display: none;"></div>
  			</div> -->
			
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