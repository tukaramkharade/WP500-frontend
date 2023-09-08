<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
 <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
 <script src="https://cdnjs.cloudflare.com/ajax/libs/chartjs-adapter-moment/1.0.1/chartjs-adapter-moment.min.js" 
 integrity="sha512-hVy4KxCKgnXi2ok7rlnlPma4JHXI1VPQeempoaclV1GwRHrDeaiuS1pI6DVldaj5oh6Opy2XJ2CTljQLPkaMrQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<style type="text/css">

.overview{
	
	width: 540px;
    height: 200px;
    color: black;
    font-size: 12px;
    /* Border properties */
    border: 2px solid #e74c3c; /* Border width, style, and color */
    border-radius: 10px; /* Border radius for rounded corners */
}

p{
margin-left: 2%;
}

.last_threats{
width: 380px;
    height: 200px;
    color: black;
    font-size: 12px;
    margin-left: 25px;
     /* Border properties */
    border: 2px solid #e74c3c; /* Border width, style, and color */
    border-radius: 10px; /* Border radius for rounded corners */
   
}

#dataList{
list-style: none;
padding: 0;

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

.green-text {
    color: green;
}

.red-text {
    color: red;
}

.threats_count{
width: 540px;
    height: 400px;
    color: black;
    font-size: 12px;
    /* Border properties */
    border: 2px solid #e74c3c; /* Border width, style, and color */
    border-radius: 10px; /* Border radius for rounded corners */
}


</style>
<script>

function latestActiveThreats(){
	$.ajax({
        url: "dashboard",
        method: "GET",
        dataType: "json",
        success: function (data) {
            // Iterate through the data and populate the list
            var dataList = $("#dataList");
            $.each(data, function (index, item) {
				
				var row = $('<tr>');
				row.append($('<td>').text(item.timeStamp+ " "));
				row.append($('<td>').text(item.alertMessage + " "));
				row.append($('<td>').text(item.threat_id + " "));
				
				if(item.priority == '1'){							
					row.append($('<td>').append($('<div>').addClass('red-box').text('high')));
				}else if(item.priority == '2'){
					row.append($('<td>').append($('<div>').addClass('orange-box').text('medium')));
				}else if(item.priority == '3'){
					row.append($('<td>').append($('<div>').addClass('yellow-box').text('low')));
				}
					
                dataList.append(row);
            });
        },
        error: function (error) {
            console.error("Error fetching data: " + error);
        }
    });
}

function countDetails(){
	$.ajax({
		url : "countDetailsServlet", // Replace with your server endpoint to get the current time
		type : "GET",
		dataType : "json",
		success : function(data) {
			
			if (data.status == 'success') {
    			var status = 'Running';
    			$("#status").html("System Status: <span class='green-text'>" + status + "</span>");
			} else {
    			var status = 'Stop';
    			$("#status").html("System Status: <span class='red-text'>" + status + "</span>");
}
			$("#last_update").text("Last Update: " + data.last_update);
			$("#active_threat_count").text("Active threat count: " + data.active_threats_count);
			$("#total_threat").text("Total threat: " + data.total_count);
			$("#ack_count").text("Total acknowledged threat: " + data.threats_log_count);
			$("#unack_count").text("Total unacknowledged threat: " + data.active_threats_count);
		},
		error : function(xhr, status, error) {
			// Handle any errors that occur during the AJAX request
			console.error("Error fetching count:", status, error);
		}
	});
}

	function updateLineChart(data) {
		var ctx = document.getElementById('lineChart').getContext('2d');
		var chart = new Chart(ctx, {
		    type: 'line',
		    data: {
		    	
		        labels: data.labels, // Array of date labels
		        datasets: [{
		            label: 'Threat Count',
		            data: data.values, // Array of threat count values
		            borderColor: 'blue',
		            fill: false
		        }]
		
		    },
		    options: {
		        responsive: true,
		        maintainAspectRatio: false,
		        scales: {
		            x: {
		                type: 'time', // Use time scale for dates
		                time: {
		                    parser: 'YYYY-MM-DD', // Specify the date format
		                    unit: 'day',
		                    displayFormats: {
		                        day: 'YYYY-MM-DD'
		                    }
		                },
		                title: {
		                    display: true,
		                    text: 'Date'
		                }
		            },
		            y: {
		                beginAtZero: true,
		                title: {
		                    display: true,
		                    text: 'Threat Count'
		                }
		            }
		        }
		    }
		});

        }
		
	
 function threatCountsLineChart(){
	 var start_time = $('#start_time').val();
		var end_time = $('#end_time').val();
		
	        // AJAX request to fetch data from the servlet
	        $.ajax({
	            url: 'dashboard', // Replace with your servlet URL
	            type: 'POST',
	            data: {
	            	
	            	start_time : start_time,
	    			end_time : end_time,
	                action: 'threat_count' // Specify the action to retrieve data
	            },
	            success: function(response) {
	            	if (typeof response === 'object') {
	                    updateLineChart(response); // Use the response object directly
	                } else {
	                    // Parse the JSON response
	                    var data = JSON.parse(response);
	                    updateLineChart(data); // Update the line chart with the fetched data
	                }
	            },
	            error: function(error) {
	                console.error('Error fetching data:', error);
	            }
	        });
	
 }
	
        

$(document).ready(function() {
//	latestActiveThreats();
//	countDetails();
	
	$('#apply').click(function() {
		threatCountsLineChart();
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
		<h3>CYBERGUARD DASHBOARD</h3>
		<hr />
		
		<div class="container">
		
		<input type="hidden" id="action" name="action" value="">
		
		<div class="row"
					style="display: flex; flex-content: space-between; margin-top: -15px;">
						<input type="button" value="Today" id="today"/> 
						<input style="margin-left: 5px" type="button" value="Yesterday" id="yesterday" /> 
						<input style="margin-left: 5px" type="button" value="Week" id="week" />
						<input style="margin-left: 5px" type="button" value="Month" id="month" />
						<input style="margin-left: 25px; width: 13%;" type="button" value="Custom" id="custom" />
						<label style="margin-left: 5px;">From</label><input style="margin-left: 3px" type="datetime-local" id="start_time" name="start_time" />
						<label style="margin-left: 5px;">To</label><input style="margin-left: 3px" type="datetime-local" id="end_time" name="end_time" />
						<input style="margin-left: 15px" type="button" value="Apply" id="apply" />					
				</div>
				
				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: 10px;">
					
					
					<div class="overview">
						<h5>Overview</h5>
						<p id="status"></p>
						<p id="last_update"></p>
						<p id="active_threat_count"></p>
						<p id="total_threat"></p>
						<p id="ack_count"></p>
						<p id="unack_count"></p>
					</div>
					
					<div class="last_threats">
						<h5>Last Threats</h5>
						<ul id="dataList">
        					<!-- List items will be populated here -->
    					</ul>
						<input style="margin-left: 300px; margin-top: 40px;" type="button" value="Show all" id="show_all" /> 
						
					</div>
					
				</div>
				
				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: 10px;">
					<div class="threats_count">
					 <canvas id="lineChart" width="400" height="400"></canvas>
					</div>
					</div>
				
				
		
		</div>
		</section>
		</div>
		
		<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>