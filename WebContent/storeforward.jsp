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
<title>WPConnex Web Configuration</title>
<style>
.pagination {
	display: flex;
	justify-content: flex-start;
	align-items: center;
}

#prevPage, #nextPage {
	margin-right: 10px; /* Add some spacing between the links */
	margin-left: 5px;
}
</style>

<link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png" />
<link rel="stylesheet" href="css_files/ionicons.min.css">
<link rel="stylesheet" href="css_files/normalize.min.css">
<link rel="stylesheet" href="css_files/fonts.txt" type="text/css">	
<link rel="stylesheet" href="nav-bar.css" />
<script src="jquery-3.6.0.min.js"></script>
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
 
 #confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
}

h3{
margin-top: 68px;
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
	var currentPage = 1; // Initial page
	var itemsPerPage = 100; // Items per page
	var total_pages = 0;
	var tokenValue;
	var roleValue;
	var csrfTokenValue;
	
	function getStoreForwardData() {
	    showLoader();
	    var csrfToken = document.getElementById('csrfToken').value;    
		$.ajax({
			url : 'storeForwardDataServlet',
			type : 'GET',
			dataType : 'json',
			data: {
				csrfToken: csrfToken
	        },
			beforeSend: function(xhr) {
		        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
		    },
			success : function(data) {
	            hideLoader();				
				if (data.status == 'fail') {					
					 var modal = document.getElementById('custom-modal-session-timeout');
					  modal.style.display = 'block';
					    var sessionMsg = document.getElementById('session-msg');
					    sessionMsg.textContent = data.message; // Assuming data.message contains the server message
					  var confirmButton = document.getElementById('confirm-button-session-timeout');
					  confirmButton.onclick = function () {
					        modal.style.display = 'none';
					        window.location.href = 'login.jsp';
					  };					  
				} 				 
				 total_pages = data.total_page; // Access the total_pages value
				var count = data.event_log_result.length;			
				if (data.event_log_result && Array.isArray(data.event_log_result)) {
					var storeForwardDataTable = $('#data-table tbody');
					storeForwardDataTable.empty();
					data.event_log_result.forEach(function(log) {
						var dateTime = log.date_time; 
						var dataString = log.data_string; 
						var brokerIp = log.broker_ip; 
						var publishTopic = log.publish_topic;
						var row = $("<tr>").append($("<td>").text(dateTime),
								$("<td>").text(dataString),
								$("<td>").text(brokerIp),
								$("<td>").text(publishTopic));
						storeForwardDataTable.append(row);
					});
				}
			},
			error : function(xhr, status, error) {
	            hideLoader();				
			}
		});
	}

	function getStoreForward(currentPage) {
		  var csrfToken = document.getElementById('csrfToken').value;		  
		$.ajax({
			url : 'storeForwardDataServlet',
			type : 'POST', // Use POST method
			data : {
				currentPage : currentPage,
				csrfToken: csrfToken
			}, // Pass current page number
			dataType : 'json',
			beforeSend: function(xhr) {
		        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
		    },
			success : function(data) {
				total_pages = data.total_page; // Access the total_pages value			
				var count = data.event_log_result.length;			
				if (data.event_log_result && Array.isArray(data.event_log_result)) {
					var storeForwardDataTable = $('#data-table tbody');
					storeForwardDataTable.empty();
					data.event_log_result.forEach(function(log) {
						var dateTime = log.date_time; 
						var dataString = log.data_string; 
						var brokerIp = log.broker_ip; 
						var publishTopic = log.publish_topic; 
						var row = $("<tr>").append($("<td>").text(dateTime),
								$("<td>").text(dataString),
								$("<td>").text(brokerIp),
								$("<td>").text(publishTopic));
						storeForwardDataTable.append(row);
					});
				}
			},
			error : function(xhr, status, error) {				
			}
		});
	}
	
	function clearTable() {
		$('#data-table tbody').empty();
	}
	function updatePageInfo() {
		$('#pageInfo').text('Page ' + currentPage);
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
	
	<%// Access the session variable
	HttpSession csrfToken = request.getSession();
	String csrfTokenValue = (String) session.getAttribute("csrfToken");%>
	csrfTokenValue = '<%=csrfTokenValue%>';		
	
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
    } else{
    	<%// Access the session variable
		HttpSession token = request.getSession();
		String tokenValue = (String) session.getAttribute("token");%>
		tokenValue = '<%=tokenValue%>';	
		getStoreForwardData();
		$('#prevPage').on('click', function() {
			if (currentPage > 1) {
				currentPage--;
				clearTable();
				getStoreForward(currentPage);
				updatePageInfo();
			}
		});
		$('#nextPage').on('click', function() {
			if (currentPage < total_pages) {
				currentPage++;
				clearTable();
				getStoreForward(currentPage);
				updatePageInfo();
			}
		});
    }		
	});
</script>
</head>
<body>
	<div class="sidebar"><%@ include file="common.jsp"%></div>
	<div class="header"><%@ include file="header.jsp"%></div>
	<div class="content">
		<section style="margin-left: 1em">	
		<input type="hidden" name="csrfToken" id="csrfToken" value="<%= csrfTokenValue %>" />	
		<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>
			<h3>STORE AND FORWARD</h3>
			<button onClick="window.location.reload();"
				style="cursor: pointer; background-color: #35449a; border-radius: 5px; border: none; color: white; font-size: small">Refresh
				Page</button>
			<div class="pagination" id="pagination">				
				<a href="#" id="prevPage">Previous</a> <span id="pageInfo">Page1</span>
				<a href="#" id="nextPage">Next</a>
			</div>				  
			<hr />			
			<div id="custom-modal-session-timeout" class="modal-session-timeout">
				<div class="modal-content-session-timeout">
					 <p id="session-msg"></p>
					  <button id="confirm-button-session-timeout">OK</button>
				</div>
    		</div>
			<div class="container">
				<table id="data-table">
					<thead>
						<tr>
							<th>Date time</th>
							<th>Data string</th>
							<th>Broker IP</th>
							<th>Publish topic IP</th>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
		</section>
	</div>	
	<div class="footer"><%@ include file="footer.jsp"%></div>	
</body>
</html>