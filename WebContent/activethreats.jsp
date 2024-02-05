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
<link rel="stylesheet" href="css_files/ionicons.min.css">
<link rel="stylesheet" href="css_files/normalize.min.css">
<link rel="stylesheet" href="css_files/fonts.txt" type="text/css">
<link rel="stylesheet" href="nav-bar.css" />
<link rel="stylesheet" href="css_files/all.min.css">
<link rel="stylesheet" href="css_files/fontawesome.min.css">	
<script src="jquery-3.6.0.min.js"></script>
<style type="text/css">
.modal-session-timeout,
.modal-ack{
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

.modal-content-session-timeout,
.modal-content-ack
 {
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
.red-box {
    display: inline-block;
    width: 40px;
    height: 20px;
    background-color: red;
    color: white;
    text-align: center;
    line-height: 20px;
}

.orange-box {
    display: inline-block;
    width: 40px;
    height: 20px;
    background-color: orange;
    color: white;
    text-align: center;
    line-height: 20px;
}

.yellow-box {
    display: inline-block;
    width: 40px;
    height: 20px;
    background-color: yellow;
    color: white;
    text-align: center;
    line-height: 20px; 
}

#confirm-button-ack,
#confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
  margin: 5px;
  padding: 10px 20px;
  border: none;
  cursor: pointer;
}

#cancel-button-ack {
  background-color: #f44336;
  color: white;
  margin: 5px;
  padding: 10px 20px;
  border: none;
  cursor: pointer;
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
  text-align: center; 
  width: 20%;
}

#closePopup {
  display: block; 
  margin-top: 30px; 
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
    background: rgba(255, 255, 255, 0.7); 
    z-index: 1000; 
    justify-content: center;
    align-items: center;
}

#loader {
    text-align: center;
   margin-left: 120px;
    background: rgba(255, 255, 255, 0.2); 
    border-radius: 5px;
}
</style>
<script>

var roleValue;
var tokenValue;
var csrfTokenValue;
function getActiveThreats() {	
   showLoader();
    var csrfToken = document.getElementById('csrfToken').value;  
	$.ajax({
		url : 'activeThreatServlet',
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
				 sessionMsg.textContent = data.message; 			 
				 var confirmButton = document.getElementById('confirm-button-session-timeout');
				 confirmButton.onclick = function () {				  
				       modal.style.display = 'none';
				        window.location.href = 'login.jsp';
				 };				  
			} 			
			var activeThreatsTable = $('#data-table tbody');
			activeThreatsTable.empty();						 
			 if(roleValue == 'ADMIN' || roleValue == 'Admin'){				 
				 data.result.forEach(function(activeThreats) {
					 var row = $('<tr>');
						row.append($('<td>').text(activeThreats.timestamp + ""));						
						if(activeThreats.priority == '1'){							
							row.append($('<td>').append($('<div>').addClass('red-box').text('high')));
						}else if(activeThreats.priority == '2'){
							row.append($('<td>').append($('<div>').addClass('orange-box').text('medium')));
						}else if(activeThreats.priority == '3'){
							row.append($('<td>').append($('<div>').addClass('yellow-box').text('low')));
						}						
						row.append($('<td>').text(activeThreats.threat_id + ""));
						row.append($('<td>').text(activeThreats.alert_message + ""));						
						row.append($('<td>').text(activeThreats.src_ip + ""));
						row.append($('<td>').text(activeThreats.src_port + ""));
						row.append($('<td>').text(activeThreats.dest_ip + ""));
						row.append($('<td>').text(activeThreats.dest_port + ""));
						row.append($('<td>').text(activeThreats.protocol_type + ""));						
						var actions = $('<td>')
						var ackButton = $(
										'<button data-toggle="tooltip" class="editBtn" data-placement="top" title="Acknowledge" style="color: #35449a;">')
										.html('<i class="fas fa-check"></i>')
										.click(
												function() {
													ackThreats(activeThreats.threat_id);
												});					
						actions.append(ackButton);
						row.append(actions);
						activeThreatsTable.append(row);
				 });			 
			 }else if(roleValue == 'OPERATOR' || roleValue == 'Operator'){
				 data.result.forEach(function(activeThreats) {
					 var row = $('<tr>');
						row.append($('<td>').text(activeThreats.timestamp + ""));					
						if(activeThreats.priority == '1'){							
							row.append($('<td>').append($('<div>').addClass('red-box').text('high')));
						}else if(activeThreats.priority == '2'){
							row.append($('<td>').append($('<div>').addClass('orange-box').text('medium')));
						}else if(activeThreats.priority == '3'){
							row.append($('<td>').append($('<div>').addClass('yellow-box').text('low')));
						}
						row.append($('<td>').text(activeThreats.threat_id + ""));
						row.append($('<td>').text(activeThreats.alert_message + ""));						
						row.append($('<td>').text(activeThreats.src_ip + ""));
						row.append($('<td>').text(activeThreats.src_port + ""));
						row.append($('<td>').text(activeThreats.dest_ip + ""));
						row.append($('<td>').text(activeThreats.dest_port + ""));
						row.append($('<td>').text(activeThreats.protocol_type + ""));										
						activeThreatsTable.append(row);
				 });
			 }		
		},
		error : function(xhr, status, error) {
            hideLoader();
		}
	});
}

function getSearchThreats() {
    var startdatetime = $('#startdatetime').val();
    var enddatetime = $('#enddatetime').val();
    var csrfToken = document.getElementById('csrfToken').value;  
    $.ajax({
        url: 'activeThreatServlet',
        type: 'POST',
        data: {
            startdatetime: startdatetime,
            enddatetime: enddatetime,
            csrfToken: csrfToken,
            action : 'get_threats'
        },
        beforeSend: function(xhr) {
	        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
	    },
        success: function (data) {
			var activeThreatsTable = $('#data-table tbody');
			activeThreatsTable.empty();			
			 var json1 = JSON.stringify(data);
			var json = JSON.parse(json1);
			if (json.status == 'fail') {
				var confirmation = confirm(json.msg);
				if (confirmation) {
					window.location.href = 'login.jsp';
				}
			} 
				$.each(data, function(index, activeThreats) {			
						var row = $('<tr>');
						row.append($('<td>').text(activeThreats.timestamp + ""));						
						if(activeThreats.priority == '1'){							
							row.append($('<td>').append($('<div>').addClass('red-box').text('high')));
						}else if(activeThreats.priority == '2'){
							row.append($('<td>').append($('<div>').addClass('orange-box').text('medium')));
						}else if(activeThreats.priority == '3'){
							row.append($('<td>').append($('<div>').addClass('yellow-box').text('low')));
						}					
						row.append($('<td>').text(activeThreats.threat_id + ""));
						row.append($('<td>').text(activeThreats.alert_message + ""));						
						row.append($('<td>').text(activeThreats.src_ip + ""));
						row.append($('<td>').text(activeThreats.src_port + ""));
						row.append($('<td>').text(activeThreats.dest_ip + ""));
						row.append($('<td>').text(activeThreats.dest_port + ""));
						row.append($('<td>').text(activeThreats.protocol_type + ""));
						row.append($('<td>').text(activeThreats.ack_at + ""));
						row.append($('<td>').text(activeThreats.ack_by + ""));					
						var actions = $('<td>')
						var ackButton = $(
										'<button style="background-color: #35449a; border: none; border-radius: 5px; margin-left: 5px; color: white">')
										.text('Acknowledge')
										.click(
												function() {
													ackThreats(activeThreats.threat_id);
												});				
						actions.append(ackButton);
						row.append(actions);
						activeThreatsTable.append(row);
					});	
        },
        error: function (xhr, status, error) {
        }
    });
}

function ackThreats(threat_id){
	 var csrfToken = document.getElementById('csrfToken').value;
	  var modal = document.getElementById('custom-modal-ack');
	  modal.style.display = 'block';	  
	  var confirmButton = document.getElementById('confirm-button-ack');
	  confirmButton.onclick = function () {
		  $.ajax({
				url : 'activeThreatServlet',
				type : 'POST',
				data : {
					threat_id : threat_id,
					csrfToken: csrfToken,
					 action : 'get_ack_threats'				
				},
				success : function(data) {				
					  modal.style.display = 'none';
			},
				error : function(xhr, status, error) {
			}
			});
		  location.reload();
	  };
	  
	  var cancelButton = document.getElementById('cancel-button-ack');
	  cancelButton.onclick = function () {
	    modal.style.display = 'none';
	    location.reload();
	  };
}

function checkDateField() {
    var startdatetime = $('#startdatetime').val();
    var enddatetime = $('#enddatetime').val();
    var errorMessage = '';
    if (startdatetime.trim() === '') {
        errorMessage += 'Start Date/Time is required.\n';
    }
    if (enddatetime.trim() === '') {
        errorMessage += 'End Date/Time is required.\n';
    }
    if (errorMessage === '' && startdatetime !== '' && enddatetime !== '') {
        getSearchThreats(); 
    } else {
      
    		$("#popupMessage").text(errorMessage);
			$("#customPopup").show();
         }
}

function getCurrentTimeInIndia() {
    const date = new Date();
    var ISTOffset = 330;
    var offset = ISTOffset * 60 * 1000;
    var ISTTime = new Date(date.getTime() + offset);
    var ISTTime24HoursAgo = new Date(ISTTime.getTime() - (24 * 60 * 60 * 1000));
    var formattedCurrentTime = ISTTime.toISOString().slice(0, 16);
    var formattedTime24HoursAgo = ISTTime24HoursAgo.toISOString().slice(0, 16);
    document.getElementById('enddatetime').value = formattedCurrentTime;
    document.getElementById('startdatetime').value = formattedTime24HoursAgo;   
}

function changeButtonColor(isDisabled) {
    var $loadThreatsbutton = $('#loadThreats');        
     if (isDisabled) {
        $loadThreatsbutton.css('background-color', 'gray'); 
    } else {
        $loadThreatsbutton.css('background-color', '#2b3991');
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
	String roleValue = (String) session.getAttribute("role");%>
	roleValue = '<%=roleValue%>';
<%
HttpSession csrfToken = request.getSession();
String csrfTokenValue = (String) session.getAttribute("csrfToken");%>
csrfTokenValue = '<%=csrfTokenValue%>';
	
	if (roleValue == 'OPERATOR' || roleValue == 'Operator') {
		$("#acknowledge").hide();
		$('#loadThreats').prop('disabled', true);
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
    	<%
    	HttpSession token = request.getSession();
    	String tokenValue = (String) session.getAttribute("token");%>
    	tokenValue = '<%=tokenValue%>';
    		
    		getActiveThreats();
    		getCurrentTimeInIndia();
    		$(document).on("click", "#loadThreats", function() {
            checkDateField();
        });
    	setInterval(getCurrentTimeInIndia, 60000);   	
    	$("#closePopup").click(function () {
    	    $("#customPopup").hide();
    	  });
    }
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
		<h3>ACTIVE THREATS</h3>
		<hr />
		<input type="hidden" name="csrfToken" id="csrfToken" value="<%= csrfTokenValue %>" />
			<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>
		<div class="row" style="display: flex; flex-content: space-between; margin-top: 5px;">			
			<div style="width: 20%;">
				<label for="choose_date">Choose a date:</label>
			</div>		
			<div style="width: 25%; margin-left: -11%;margin-top: 5px;">
				<input type="datetime-local" id="startdatetime" name="startdatetime" >
			</div>		
			<div style="width: 10%; margin-left: -10%;">
				<label for="to">  to  </label>
			</div>		
			<div style="width: 25%; margin-left: -8%;margin-top: 5px;">
				<input type="datetime-local" id="enddatetime" name="enddatetime" >
			</div>		
			<div>
				<input style="margin-left: 1%; margin-top: 5%;" type="button"
					id="loadThreats" value="Load threats">
			</div>		
			</div>			
			<div id="custom-modal-ack" class="modal-ack">
				<div class="modal-content-ack">
				  <p>Are you sure you want to acknowledge this threat?</p>
				  <button id="confirm-button-ack">Yes</button>
				  <button id="cancel-button-ack">No</button>
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
		<div class="container">
				<table id="data-table">
				<thead>
						<tr>
							<th>Timestamp</th>
							<th>Priority</th>
							<th>Threat ID</th>
							<th>Alert message</th>
							<th>Src IP</th>
							<th>Src port</th>
							<th>Dest IP</th>
							<th>Dest port</th>
							<th>Protocol type</th>
							<th id="acknowledge">Acknowledge</th>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
				</div>
		</section>
		</div>
	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>