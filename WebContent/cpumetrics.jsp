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
    border: 2px solid #e74c3c; /* Border width, style, and color */
    border-radius: 10px; /* Border radius for rounded corners */
}

.ram_info h5{
font-size: 13px;
margin-left:5px;
margin-top: 5px;
}

p{
margin-left: 2%;
}

.cpu_info {
    width: 100%; /* Use 100% for full width on all screens */
    max-width: 800px; /* Set a maximum width for larger screens if needed */
    margin: 0 auto; /* Center the container */
    color: black;
    border: 2px solid #e74c3c;
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
		
			
			$("#Architecture").html("Architecture: <span class='overviewText'>" + data.Architecture + "</span>");
			$("#Version").html("Version: <span class='overviewText'>" + data.Version + "</span>");
			$("#AvailableProcessors").html("Available Processors: <span class='overviewText'>" + data.AvailableProcessors + "</span>");
			$("#SystemLoadAverage").html("System load Average: <span class='overviewText'>" + data.SystemLoadAverage + "</span>");
			$("#Name").html("Name: <span class='overviewText'>" + data.Name + "</span>");
			
		},
		error : function(xhr, status, error) {
			// Handle any errors that occur during the AJAX request
			console.error("Error fetching ram info:", status, error);
		}
	});
}


function getMemoryInfo() {
	$.ajax({
		url : "CPUMetricsServlet", // Replace with your server endpoint to get the current time
		type : "GET",
		dataType : "json",

		success : function(data) {
		
			
			$("#Architecture").html("Architecture: <span class='overviewText'>" + data.Architecture + "</span>");
			$("#Version").html("Version: <span class='overviewText'>" + data.Version + "</span>");
			$("#AvailableProcessors").html("Available Processors: <span class='overviewText'>" + data.AvailableProcessors + "</span>");
			$("#SystemLoadAverage").html("System load Average: <span class='overviewText'>" + data.SystemLoadAverage + "</span>");
			$("#Name").html("Name: <span class='overviewText'>" + data.Name + "</span>");
			
		},
		error : function(xhr, status, error) {
			// Handle any errors that occur during the AJAX request
			console.error("Error fetching ram info:", status, error);
		}
	});
}


$(document).ready(function() {
	getRAMInfo();
	getCPUInfo();
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
                    <p id="UsedMemory"></p>
                    <p id="TotalMemory"></p>
                    <p id="SharedMemory"></p>
                    <p id="AvailableMemory"></p>
                    <p id="BufferCache"></p>
                    <p id="FreeMemory"></p>
                </div>
 
               
            </div>
        </section>
    </div>
</body>
	</html>