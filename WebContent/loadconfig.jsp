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
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style type="text/css">
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

#cancel-button-edit {
  background-color: #f44336;
  color: white;
}

</style>
<script>

var tokenValue;

	function loadConfig() {
		  var modal = document.getElementById('custom-modal-edit');
		  modal.style.display = 'block';		  
		  var confirmButton = document.getElementById('confirm-button-edit');
		  confirmButton.onclick = function () {		  
			  $.ajax({
					url : 'loadConfigurationServlet',
					type : 'GET',
					dataType : 'json',
					beforeSend: function(xhr) {
				        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
				    },
					success : function(data) {					
				        modal.style.display = 'none';
					},
					error : function(xhr, status, error) {					
					}
				});			
		  };		
		  var cancelButton = document.getElementById('cancel-button-edit');
		  cancelButton.onclick = function () {
		    modal.style.display = 'none';		   
		  };		
	}

	$(document).ready(function() {
		<%// Access the session variable
		HttpSession token = request.getSession();
		String tokenValue = (String) session.getAttribute("token");%>
		tokenValue = '<%=tokenValue%>';		
		 $('#loadConfig').click(function(){		
			 loadConfig();
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
		<h3>Load Configuration</h3>
		<hr>
		<div class="container">
			<input type="button" id="loadConfig" value="Load Configuration" />
		</div>		
		 <div id="custom-modal-edit" class="modal-edit">
				<div class="modal-content-edit">
				  <p>Are you sure you want to load the configuration?</p>
				  <button id="confirm-button-edit">Yes</button>
				  <button id="cancel-button-edit">No</button>
				</div>
			  </div>			  
		</section>
	</div>
	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>