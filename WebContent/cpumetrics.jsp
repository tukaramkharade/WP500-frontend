<%  
    // Add X-Frame-Options header to prevent clickjacking
    response.setHeader("X-Frame-Options", "DENY");
%>

<!DOCTYPE html>
<html>
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32"
	href="images/WP_Connex_logo_favicon.png" />
	
<link rel="stylesheet" href="css_files/ionicons.min.css">
<link rel="stylesheet" href="css_files/normalize.min.css">
<link rel="stylesheet" href="css_files/fonts.txt" type="text/css">
<link rel="stylesheet" href="nav-bar.css" />
<link rel="stylesheet" href="css_files/all.min.css">
<link rel="stylesheet" href="css_files/fontawesome.min.css">
<script src="jquery-3.6.0.min.js"></script>

<style>
h3{
margin-top: 68px;
}

.ram_info{	
	max-width: 45%;
  margin-left: 15px;
    color: black;
    font-size: 15px;
    /* Border properties */
    border: 2px solid blue; /* Border width, style, and color */
    border-radius: 10px; /* Border radius for rounded corners */
}

.ram_info h5{
font-size: 13px;
margin-left:5px;
margin-top: 5px;
}

.memory_info{	
	max-width: 45%;
  margin-left: 15px;
    color: black;
    font-size: 15px;
    /* Border properties */
    border: 2px solid #e74c3c; /* Border width, style, and color */
    border-radius: 10px; /* Border radius for rounded corners */
}

.memory_info h5{
font-size: 13px;
margin-left:5px;
margin-top: 5px;
}

p{
margin-left: 2%;
}

.task_user_info {
    width: 100%; /* Use 100% for full width on all screens */
    max-width: 800px; /* Set a maximum width for larger screens if needed */
    margin: 0 auto; /* Center the container */
    color: black;
    border: 2px solid #e74c3c;
    border-radius: 10px;
}

.task_user_info h5{ 
margin-top: 5px;
font-size: 13px;
margin-left:5px;
}


.cpu_info {
    width: 100%; /* Use 100% for full width on all screens */
    max-width: 800px; /* Set a maximum width for larger screens if needed */
    margin: 0 auto; /* Center the container */
    color: black;
    border: 2px solid blue;
    border-radius: 10px;
}

.cpu_info h5{ 
margin-top: 5px;
font-size: 13px;
margin-left:5px;
}

.overviewText{
font-size: 17px;
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

/* Style for the close button */
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


.modal-session-timeout{
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

.modal-content-session-timeout
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
 
#confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
  margin: 5px;
  padding: 10px 20px;
  border: none;
  cursor: pointer;
}


 
</style>

<script>
var roleValue;
var tokenValue;


function getRAMInfo() {
	
	$.ajax({
		url : "CPUMetricsServlet", // Replace with your server endpoint to get the current time
		type : "GET",
		dataType : "json",

		success : function(data) {
			
		
			if (data.status == 'fail') {
				
				 var modal = document.getElementById('custom-modal-session-timeout');
				  modal.style.display = 'block';
				  
				// Update the session-msg content with the message from the server
				    var sessionMsg = document.getElementById('session-msg');
				    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

				  
				  // Handle the confirm button click
				  var confirmButton = document.getElementById('confirm-button-session-timeout');
				  confirmButton.onclick = function () {
					  
					// Close the modal
				        modal.style.display = 'none';
				        window.location.href = 'login.jsp';
				  };
					  
			} 
			
			$("#UsedMemory").html("Used memory: <span class='overviewText'>" + data.UsedMemory + "</span>");
			$("#TotalMemory").html("Total memory: <span class='overviewText'>" + data.TotalMemory + "</span>");
			$("#SharedMemory").html("Shared memory: <span class='overviewText'>" + data.SharedMemory + "</span>");
			$("#AvailableMemory").html("Available memory: <span class='overviewText'>" + data.AvailableMemory + "</span>");
			$("#BufferCache").html("Buffer cache: <span class='overviewText'>" + data.BufferCache + "</span>");
			$("#FreeMemory").html("Free memory: <span class='overviewText'>" + data.FreeMemory + "</span>");
		},
		error : function(xhr, status, error) {
			
			// Handle any errors that occur during the AJAX request
			console.error("Error fetching ram info:", status, error);
		}
	});
}


function getCPUInfo() {
	
	$.ajax({
		url : "CPUMetricsServlet", // Replace with your server endpoint to get the current time
		type : "GET",
		dataType : "json",

		success : function(data) {
			if (data.status == 'fail') {
				
				 var modal = document.getElementById('custom-modal-session-timeout');
				  modal.style.display = 'block';
				  
				// Update the session-msg content with the message from the server
				    var sessionMsg = document.getElementById('session-msg');
				    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

				  
				  // Handle the confirm button click
				  var confirmButton = document.getElementById('confirm-button-session-timeout');
				  confirmButton.onclick = function () {
					  
					// Close the modal
				        modal.style.display = 'none';
				        window.location.href = 'login.jsp';
				  };
					  
			} 
			
			$("#Architecture").html("Architecture: <span class='overviewText'>" + data.Architecture + "</span>");
			$("#Version").html("Version: <span class='overviewText'>" + data.Version + "</span>");
			$("#AvailableProcessors").html("Available Processors: <span class='overviewText'>" + data.AvailableProcessors + "</span>");
			$("#SystemLoadAverage").html("System load Average: <span class='overviewText'>" + data.SystemLoadAverage + "</span>");
			$("#Name").html("Name: <span class='overviewText'>" + data.Name + "</span>");
			
		},
		error : function(xhr, status, error) {
			
			
			// Handle any errors that occur during the AJAX request
			console.error("Error fetching cpu info:", status, error);
		}
	});
}


function getMemoryInfo() {
	
	 
	$.ajax({
		url : "CPUMetricsServlet", // Replace with your server endpoint to get the current time
		type : "GET",
		dataType : "json",

		success : function(data) {
			if (data.status == 'fail') {
				
				 var modal = document.getElementById('custom-modal-session-timeout');
				  modal.style.display = 'block';
				  
				// Update the session-msg content with the message from the server
				    var sessionMsg = document.getElementById('session-msg');
				    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

				  
				  // Handle the confirm button click
				  var confirmButton = document.getElementById('confirm-button-session-timeout');
				  confirmButton.onclick = function () {
					  
					// Close the modal
				        modal.style.display = 'none';
				        window.location.href = 'login.jsp';
				  };
					  
			} 
			
			$("#TotalSwapSpaceSize").html("Architecture: <span class='overviewText'>" + data.TotalSwapSpaceSize + "</span>");
			$("#AvailableSwapSpaceSize").html("Version: <span class='overviewText'>" + data.AvailableSwapSpaceSize + "</span>");
			$("#CommittedVirtualMemorySize").html("Available Processors: <span class='overviewText'>" + data.CommittedVirtualMemorySize + "</span>");
			$("#AvailablePhysicalMemory").html("System load Average: <span class='overviewText'>" + data.AvailablePhysicalMemory + "</span>");
			$("#TotalPhysicalMemory").html("Name: <span class='overviewText'>" + data.TotalPhysicalMemory + "</span>");
			
		},
		error : function(xhr, status, error) {
			
			
			// Handle any errors that occur during the AJAX request
			console.error("Error fetching memory info:", status, error);
		}
	});
}

function getTaskInfo(){
	
	 
	$.ajax({
		url : "CPUMetricsServlet", // Replace with your server endpoint to get the current time
		type : "GET",
		dataType : "json",

		success : function(data) {
			
			if (data.status == 'fail') {
				
				 var modal = document.getElementById('custom-modal-session-timeout');
				  modal.style.display = 'block';
				  
				// Update the session-msg content with the message from the server
				    var sessionMsg = document.getElementById('session-msg');
				    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

				  
				  // Handle the confirm button click
				  var confirmButton = document.getElementById('confirm-button-session-timeout');
				  confirmButton.onclick = function () {
					  
					// Close the modal
				        modal.style.display = 'none';
				        window.location.href = 'login.jsp';
				  };
					  
			} 
			
			$("#numberOfUsers").html("Number of users: <span class='overviewText'>" + data.numberOfUsers + "</span>");
			$("#taskDetails").html("Task details: <span class='overviewText'>" + data.taskDetails + "</span>");
			
			
		},
		error : function(xhr, status, error) {
			
			
			// Handle any errors that occur during the AJAX request
			console.error("Error fetching task info:", status, error);
		}
	});
}

function loadCPURunningTaskInfo(){
	 
	 
	$.ajax({				
				url : 'CPUMetricsServlet',
				type : 'GET',
				dataType : 'json',
			
				success : function(data) {
				
					if (data.status == 'fail') {
						
						 var modal = document.getElementById('custom-modal-session-timeout');
						  modal.style.display = 'block';
						  
						// Update the session-msg content with the message from the server
						    var sessionMsg = document.getElementById('session-msg');
						    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

						  
						  // Handle the confirm button click
						  var confirmButton = document.getElementById('confirm-button-session-timeout');
						  confirmButton.onclick = function () {
							  
							// Close the modal
						        modal.style.display = 'none';
						        window.location.href = 'login.jsp';
						  };
							  
					} 
					
					// Clear existing table rows
					var cpuTable = $('#cpu_running_task_table tbody');
					cpuTable.empty();
					
						data.cpu_running_task_jsArray.forEach(function(cpu) {
							
							var RES = cpu.RES; 
							var MEM = cpu['%MEM']; 
							var PR = cpu.PR; 
							var CPU = cpu['%CPU']; 
							var S = cpu.S; 
							var PID = cpu.PID; 
							var COMMAND = cpu.COMMAND; 
							var NI = cpu.NI; 
							var USER = cpu.USER; 
							var SHR = cpu.SHR; 
							var TIME = cpu['TIME+']; 
							var VIRT = cpu.VIRT; 

							var row = $("<tr>").append($("<td>").text(RES),
									$("<td>").text(MEM),
									$("<td>").text(PR),
									$("<td>").text(CPU),
									$("<td>").text(S),
									$("<td>").text(PID),
									$("<td>").text(COMMAND),
									$("<td>").text(NI),
									$("<td>").text(USER),
									$("<td>").text(SHR),
									$("<td>").text(TIME),
									$("<td>").text(VIRT)
																
							);
													
					cpuTable.append(row);
							
						});
				
				},
				error : function(xhr, status, error) {
					
					
					console.log('Error loading cpu runnig task data: ' + error);
				}
			});
}

function loadDiskInfo(){
	 showLoader();
	
	$.ajax({				
				url : 'CPUMetricsServlet',
				type : 'GET',
				dataType : 'json',
			
				success : function(data) {
					// Hide loader when the response has arrived
		            hideLoader();
					
		            if (data.status == 'fail') {
						
						 var modal = document.getElementById('custom-modal-session-timeout');
						  modal.style.display = 'block';
						  
						// Update the session-msg content with the message from the server
						    var sessionMsg = document.getElementById('session-msg');
						    sessionMsg.textContent = data.message; // Assuming data.message contains the server message

						  
						  // Handle the confirm button click
						  var confirmButton = document.getElementById('confirm-button-session-timeout');
						  confirmButton.onclick = function () {
							  
							// Close the modal
						        modal.style.display = 'none';
						        window.location.href = 'login.jsp';
						  };
							  
					} 
					
					// Clear existing table rows
					var diskTable = $('#disk_info_table tbody');
					diskTable.empty();
					
						data.disk_info_jsArray.forEach(function(disk) {
							
							var Used = disk.Used;  
							var Size = disk.Size; 
							var Use = disk['Use%']; 
							var Available = disk.Available; 
							var Filesystem = disk.Filesystem; 
							var MountedOn = disk.MountedOn; 
							 

							var row = $("<tr>").append($("<td>").text(Used),
									$("<td>").text(Size),
									$("<td>").text(Use),
									$("<td>").text(Available),
									$("<td>").text(Filesystem),
									$("<td>").text(MountedOn)
																
							);
													
							diskTable.append(row);
							
						});
				
				},
				error : function(xhr, status, error) {
					// Hide loader when the response has arrived
		            hideLoader();
					
					console.log('Error loading disk data: ' + error);
				}
			});
}

//Function to show the loader
function showLoader() {
    // Show the loader overlay
    $('#loader-overlay').show();
}

// Function to hide the loader
function hideLoader() {
    // Hide the loader overlay
    $('#loader-overlay').hide();
}

$(document).ready(function() {
	
	<%
	// Access the session variable
	HttpSession role = request.getSession();
	String roleValue = (String) session.getAttribute("role");
	%>
	
	roleValue = '<%= roleValue %>'; 
	
	
	if (roleValue === "null") {
        var modal = document.getElementById('custom-modal-session-timeout');
        modal.style.display = 'block';

        // Update the session-msg content with the message from the server
	    var sessionMsg = document.getElementById('session-msg');
	    sessionMsg.textContent = 'You are not allowed to redirect like this !!'; 
	    
        // Handle the confirm button click
        var confirmButton = document.getElementById('confirm-button-session-timeout');
        confirmButton.onclick = function() {
            // Close the modal
            modal.style.display = 'none';
            window.location.href = 'login.jsp';
        };
    } else{
    	getRAMInfo();
    	getCPUInfo();
    	getMemoryInfo();
    	getTaskInfo();
    	loadCPURunningTaskInfo();
    	loadDiskInfo();
    }
	
	
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
            <h3>CPU Metrics</h3>
            <hr>
            
            	<div id="loader-overlay">
    <div id="loader">
        <i class="fas fa-spinner fa-spin fa-3x"></i>
        <p>Loading...</p>
    </div>
</div>
 
            <div class="row" style="display: flex; flex-wrap: wrap; margin-top: 10px; margin-left: -10px;">
                <div class="ram_info" style="flex: 1; margin-right: 10px;">
                    <h5>RAM Information</h5>
                    <p id="UsedMemory"></p>
                    <p id="TotalMemory"></p>
                    <p id="SharedMemory"></p>
                    <p id="AvailableMemory"></p>
                    <p id="BufferCache"></p>
                    <p id="FreeMemory"></p>
                </div>
 
                <div class="cpu_info" style="flex: 1;">
                    <h5>CPU Information</h5>
                    <p id="Architecture"></p>
                    <p id="Version"></p>
                    <p id="AvailableProcessors"></p>
                    <p id="SystemLoadAverage"></p>
                    <p id="Name"></p>
                    
                    
                </div>
            </div>
            
  
            <div class="row" style="display: flex; flex-wrap: wrap; margin-top: 10px; margin-left: -10px;">
                <div class="ram_info" style="flex: 1; margin-right: 10px;">
                    <h5>Memory Information</h5>
                    <p id="TotalSwapSpaceSize"></p>
                    <p id="AvailableSwapSpaceSize"></p>
                    <p id="CommittedVirtualMemorySize"></p>
                    <p id="AvailablePhysicalMemory"></p>
                    <p id="TotalPhysicalMemory"></p>
                </div>
 
                <div class="cpu_info" style="flex: 1;">
                    <h5>Task User Information</h5>
                    <p id="numberOfUsers"></p>
                    <p id="taskDetails"></p>
                    
                    
                </div>
            </div>
            
            <div class="table-container">
			<h3 style="margin-top: 15px;">CPU Running task information</h3>
			
			<hr />
				<table id="cpu_running_task_table" style="width: 100%; margin-top: 5px;">
					<thead>
						<tr>
							<th>RES</th>
							<th>%MEM</th>
							<th>PR</th>
							<th>%CPU</th>
							<th>S</th>
							<th>PID</th>
							<th>COMMAND<th>
							<th>NI</th>
							<th>USER</th>
							<th>SHR</th>
							<th>TIME+<th>
							<th>VIRT</th>
							
						</tr>
					</thead>
					<tbody>
						
					</tbody>
				</table>
			</div>
			
			<br>
			
			<div class="table-container">
			<h3 style="margin-top: 15px;">Disk information</h3>
			
			<hr />
				<table id="disk_info_table" style="width: 100%; margin-top: 5px;">
					<thead>
						<tr>
							<th>Used</th>
							<th>Size</th>
							<th>Use%</th>
							<th>Available</th>
							<th>Filesystem</th>
							<th>MountedOn</th>
							
							
						</tr>
					</thead>
					<tbody>
						
					</tbody>
				</table>
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
			  
        </section>
    </div>
</body>
	</html>