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
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>WPConnex Web Configuration</title>
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
var roleValue;
var tokenValue;
var csrfTokenValue;
	function searchLogData() {
		var csrfToken = document.getElementById('csrfToken').value;
		var searchQuery = document.getElementById("search_query").value.trim();
		var selectedLogFile = document.getElementById("log_file").value;
		if (selectedLogFile === "") {			
     			$("#popupMessage").text("Please select a log file first.");
      			$("#customPopup").show();
			return;
		}
		if (searchQuery === "") {	
			$("#popupMessage").text("Please enter a search query.");
      			$("#customPopup").show();    			
			return;
		}
		var tableBody = $("#log_table_body");		
		tableBody.empty(); // Clear the table body before adding search results
		$.ajax({
			url : "search_logs", // Replace this with the appropriate server-side URL to handle the search
			type : "POST",
			data : {
				search_query : searchQuery,
				log_file : selectedLogFile,
				csrfToken: csrfToken
			},
			beforeSend: function(xhr) {
		        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
		    },
			success : function(data) {
				if (data.log_search_result && Array.isArray(data.log_search_result)) {
					var tableBody = $("#log_table_body");
					data.log_search_result.forEach(function(log) {
						var myArray = log.split(",");
						var split_log0 = myArray[0];
						var split_log1 = myArray[1];
						var split_log2 = myArray[2];
						var split_log4 = myArray[4];
						var split_log5 = myArray[5];
						var row = $("<tr>").append(
								$('<td style="width: 20%;">').text(split_log0),
								$("<td>").text(split_log1),
								$("<td>").text(split_log2),
								$("<td>").text(split_log4),
								$("<td>").text(split_log5));
						tableBody.append(row);
					});
					var count = data.log_search_result.length;					
					var totalPages = Math.ceil(count / 100);					
					$("#log_table").show();
				}
			},
			error : function(xhr, status, error) {			
			},
		});	
		$("#closePopup").click(function () {
		    $("#customPopup").hide();
		  });
	}

	function loadLogFileList() {
	    showLoader();
	    var csrfToken = document.getElementById('csrfToken').value;		
		$.ajax({
					url : "logs",
					type : "GET",
					dataType : "json",
					data: {
						csrfToken: csrfToken
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
						if (data.log_file_result && Array.isArray(data.log_file_result)) {
							var selectElement = $("#log_file");
							selectElement.empty();							
							data.log_file_result.forEach(function(filename) {
								var option = $("<option>", {
									value : filename,
									text : filename,
								});
								selectElement.append(option);
							});
						}
					},
					error : function(xhr, status, error) {
			            hideLoader();						
					},
				});
	}
	
	function downloadLogFile() {
	    var selectedLogFile = $("#log_file").val();
	    var token = '<%= session.getAttribute("token") %>';
	    if (selectedLogFile !== "") {
	        var sanitizedLogFile = encodeURIComponent(selectedLogFile);
	        var sanitizedToken = encodeURIComponent(token);
	        $.ajax({
	            type: "POST",
	            url: "DownloadLogServlet",
	            data: {
	                log_file: sanitizedLogFile,
	                token: sanitizedToken
	            },
	            success: function (data, status, xhr) {
	                var downloadStatus = xhr.getResponseHeader('X-Status');
	                var customMessage = xhr.getResponseHeader('X-Message');
	                var filename = "";
	                var disposition = xhr.getResponseHeader('Content-Disposition');
	                if (downloadStatus === 'success') {
	                	if (disposition && disposition.indexOf('attachment') !== -1) {
	                        var filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
	                        var matches = filenameRegex.exec(disposition);
	                        if (matches != null && matches[1]) filename = matches[1].replace(/['"]/g, '');
	                    }
	                    var blob = new Blob([data], { type: 'application/octet-stream' });
	                    if (typeof window.navigator.msSaveBlob !== 'undefined') {
	                        window.navigator.msSaveBlob(blob, filename);
	                    } else {
	                        var URL = window.URL || window.webkitURL;
	                        var downloadUrl = URL.createObjectURL(blob);
	                        if (filename) {
	                            var a = document.createElement("a");
	                            a.href = downloadUrl;
	                            a.download = filename;
	                            document.body.appendChild(a);
	                            a.click();
	                            document.body.removeChild(a);
	                        } else {
	                            window.location.href = downloadUrl;
	                        }
	                        setTimeout(function () {
	                            URL.revokeObjectURL(downloadUrl);
	                        }, 100);
	                        xhr.getResponseHeader = function () {
	                            return null;
	                        };
	                    }
	                    $("#popupMessage").text("File download initiated.");
	                } else {
	                    $("#popupMessage").text(customMessage || "Error initiating file download");
	                }
	                $("#customPopup").show();
	            },
	            error: function (xhr, status, error) {
	                $("#popupMessage").text("Error initiating file download. Please try again.");
	                $("#customPopup").show();
	            }
	        });
	    } else {
	        $("#popupMessage").text("Please select a log file first.");
	        $("#customPopup").show();
	    }
	    $("#closePopup").click(function () {
	        $("#customPopup").hide();
	    });
	}	

	function changeButtonColor(isDisabled) {
        var $load_button = $('#loadLogFileButton');
        var $export_button = $('#exportButton');      
        if (isDisabled) {
            $load_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $load_button.css('background-color', '#2b3991'); // Reset to original color
        }       
        if (isDisabled) {
            $export_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $export_button.css('background-color', '#2b3991'); // Reset to original color
        }
	}
	
	 function showLoader() {
	     $('#loader-overlay').show();
	 }

	 function hideLoader() {
	     $('#loader-overlay').hide();
	 }
	 
	$(document).ready(function() {	
		<%
	    	    	HttpSession role = request.getSession();
	    	    	String roleValue = (String) session.getAttribute("role");
	    	    	%>	    	    	
	    	    	roleValue = '<%= roleValue %>';
	    	    	
	    	    	<%// Access the session variable
	    			HttpSession csrfToken = request.getSession();
	    			String csrfTokenValue = (String) session.getAttribute("csrfToken");%>
	    			csrfTokenValue = '<%=csrfTokenValue%>';
	    	    	
	    	    	if(roleValue == 'OPERATOR' || roleValue == 'Operator'){		  	    		  
		  	    		$('#loadLogFileButton').prop('disabled', true);
		  	    		$('#exportButton').prop('disabled', true);		  	    		
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
		    	    	
			loadLogFileList();			
			$("#exportButton").click(function() {
		       downloadLogFile();
		    });					
			$(document).on("click", "#loadLogFileButton", function() {
				var searchQuery = $("#search_query").val().trim();
				if (searchQuery !== "") {				
					searchLogData();
				} else {
					loadLogFile();
				}
			});
	    		    }  	    	
	});

	function loadLogFile() {
		var selectedLogFile = document.getElementById("log_file").value;
		var tableBody = $("#log_table_body");
		var csrfToken = document.getElementById('csrfToken').value;		
		tableBody.empty();
		if (selectedLogFile !== "") {
			$.ajax({
						url : "logs", // Replace this with the appropriate server-side URL to handle the AJAX POST
						type : "POST",
						data : {
							log_file : selectedLogFile,
							csrfToken: csrfToken
						}, 
						success : function(data) {						
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
							if (data.log_file_data && Array.isArray(data.log_file_data)) {
								var tableBody = $("#log_table_body");
								tableBody.empty(); 
								data.log_file_data.forEach(function(log) {
									var myArray = log.split(",");
									var split_log0 = myArray[0];
									var split_log1 = myArray[1];
									var split_log2 = myArray[2];
									var split_log4 = myArray[4];
									var split_log5 = myArray[5];
									var row = $("<tr>").append(
											$('<td style="width: 20%;">').text(split_log0),
											$("<td>").text(split_log1),
											$("<td>").text(split_log2),
											$("<td>").text(split_log4),
											$("<td>").text(split_log5)
									);
									tableBody.append(row);
								});
								var count = data.log_file_data.length;								
								var totalPages = Math.ceil(count / 100);								
								$("#log_table").show();
							}
						},
						error : function(xhr, status, error) {							
						},
					});
		} else {
 			$("#popupMessage").text("Please select a log file first.");
  			$("#customPopup").show();			
  			$("#closePopup").click(function () {
  			    $("#customPopup").hide();
  			  });
		}
	}
	
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
		<h3>LOGS</h3>
		<hr />
			<input type="hidden" name="csrfToken" id="csrfToken" value="<%= csrfTokenValue %>" />
			<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>
		<div class="row"
			style="display: flex; flex-content: space-between; margin-top: 5px;">
			<div style="width: 20%;">
				<label for="log_file">Choose a log file:</label>
			</div>
			<div style="width: 25%; margin-left: -11%;">
				<select id="log_file">
					<option value="">Select Log File First</option>
				</select>
			</div>
			<div
				style="width: 20%; margin-left: 1%; margin-right: 1%; float: left;">
				<input type="text" id="search_query" placeholder=" Search">
			</div>
			<div>
				<input style="margin-left: 1%; margin-top: 5%;" type="button"
					id="loadLogFileButton" value="Load log file">
			</div>
			<div>
    			<input style="margin-left: 10%; margin-top: 5%;flex-content: space-between;" type="button" id="exportButton" value="Export log file">
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
	<div class="container" style="margin-top: 1%;">
		<table id="log_table">
			<thead>
				<tr>
					<th style="width: 15%">Date and time</th>
					<th style="width: 8%">Log type</th>
					<th style="width: 15%">Line number</th>
					<th>Class</th>
					<th style="width: 55%">Message</th>
				</tr>
			</thead>
			<tbody id="log_table_body"></tbody>
		</table>
	</div>
	</section>
	</div>
	</div>
	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>