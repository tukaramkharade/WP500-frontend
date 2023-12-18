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

<script src="moment.min.js"></script>

 <script src="chart.js"></script>
 
 <script src="chartjs-adapter-moment.min.js"></script>

<style type="text/css">
.modal-session-timeout,
.modal-ids,
.modal-ips {
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
.modal-content-ids,
.modal-content-ips  {
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
 
.overview{	
	width: 45%;
  
    color: black;
    font-size: 15px;
    /* Border properties */
    border: 2px solid #e74c3c; /* Border width, style, and color */
    border-radius: 10px; /* Border radius for rounded corners */
}

.overview h5{
font-size: 13px;
margin-left:5px;
}

p{
margin-left: 2%;
}

.last_threats {
    width: 100%; /* Use 100% for full width on all screens */
    max-width: 800px; /* Set a maximum width for larger screens if needed */
    margin: 0 auto; /* Center the container */
    color: black;
    border: 2px solid #e74c3c;
    border-radius: 10px;
}

#dataList li {
    display: flex;
    justify-content: space-between;
    margin-right: 2%; /* Adjust margin for spacing between items */
}


.last_threats h5{/* 
padding-left:7px; */
font-size: 13px;
margin-left:5px;
}

#dataList{
list-style: none;
 line-height: 1.8em;
font-size:14px;
}



.red-box {
    display: inline-block;
    width: 40px;
    height: 20px;
    background-color: red;
    color: white;
    text-align: center;
    line-height: 20px;
    margin-left: 20px;
    
}

.orange-box {
    display: inline-block;
    width: 43px;
    height: 20px;
    background-color: orange;
    color: white;
    text-align: center;
    line-height: 20px;
     margin-left: 20px;
}

.yellow-box {
    display: inline-block;
    width: 40px;
    height: 20px;
    background-color: yellow;
    color: white;
    text-align: center;
    line-height: 20px;
    margin-left: 20px;
}

.green-text {
    color: green;
    font-size: 17px;
}

.red-text {
    color: red;
}

.threats_count{
    width: 45%; 
    height: 375px;
    color: black;
    font-size: 12px;
   
}

.threats_priority{ 
width:45%;
height:460px;
    color: black;
    font-size: 12px;
     margin-left: 25px; 
    
}

.overviewText{
font-size: 17px;
}

.alert-high{
margin-top: 18px;
margin-left: -325px;
}

.alert-medium{
margin-top: 18px;
margin-left: -325px;
}

.alert-low{
margin-top: 18px;
margin-left: -325px;
}

#confirm-button-ids,
#confirm-button-ips,
#confirm-button-session-timeout {
  background-color: #4caf50;
  color: white;
}

#cancel-button-ids,
#cancel-button-ips {
  background-color: #f44336;
  color: white;
}

h3{
margin-top: 68px;
}

</style>
<script>
var chart = null;
var barChart = null;
var tokenValue;
var roleValue;

function latestActiveThreats(){
	$.ajax({
        url: "dashboard",
        method: "GET",
        dataType: "json",
        beforeSend: function(xhr) {
	        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
	    },
        success: function (data) {
        	
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
        	
            // Iterate through the data and populate the list
            var dataList = $("#dataList");
            var prority = null;
            
            
            data.result.forEach(function(item) {
				var listItem = $("<li></li>");
                
                if(item.priority == '1'){	
                	 priority = 'high';
                	listItem.html("<span class='time-high'>" +item.timeStamp + "</span>" + "<span class='alert-high'>" +item.alertMessage + "</span>" + item.threat_id + " <span class='red-box'>" + priority + "</span>");
				}else if(item.priority == '2'){
					 priority = 'medium';
                	listItem.html("<span class='time-medium'>" +item.timeStamp + "</span>" + "<span class='alert-medium'>" +item.alertMessage + "</span>" + item.threat_id + " <span class='orange-box'>" + priority + "</span>");
				}else if(item.priority == '3'){
					 priority = 'low';
                	listItem.html("<span class='time-low'>" +item.timeStamp + "</span>"  + "<span class='alert-low'>" +item.alertMessage + "</span>" + item.threat_id + " <span class='yellow-box'>" + priority + "</span>");
				} 
            
                dataList.append(listItem);
                dataList.append("<hr>"); 
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
		beforeSend: function(xhr) {
	        xhr.setRequestHeader('Authorization', 'Bearer ' + tokenValue);
	    },
		success : function(data) {
			
			alert(data.status_service);
			if (data.status_service == 'success') {
    			var status_service = 'Running';
    			$("#status").html("System Status: <span class='green-text'>" + status_service + "</span>");
			} else {
    			var status = 'Stop';
    			$("#status").html("System Status: <span class='red-text'>" + status_service + "</span>");
	}
		
			$("#last_update").html("Last Update: <span class='overviewText'>" + data.last_update + "</span>");
			$("#active_threat_count").html("Active threat count: <span class='overviewText'>" + data.active_threats_count + "</span>");
			$("#total_threat").html("Total threat: <span class='overviewText'>" + data.total_count + "</span>");
			$("#ack_count").html("Total acknowledged threat: <span class='overviewText'>" + data.threats_log_count + "</span>");
			$("#unack_count").html("Total unacknowledged threat: <span class='overviewText'>" + data.active_threats_count + "</span>");
		},
		error : function(xhr, status, error) {
			// Handle any errors that occur during the AJAX request
			console.error("Error fetching count:", status, error);
		}
	});
}

	function updateLineChart(data) {
		
		if (chart) {
			chart.destroy();
		  }
		
		
		 var ctx = document.getElementById('lineChart').getContext('2d');
		
		chart = new Chart(ctx, {
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
	
	function updateBarChart(){
	
	 var start_time = $('#start_time').val();
	var end_time = $('#end_time').val();
	
	$.ajax({
        url: 'dashboard',
        type: 'POST',
        data: {
        	
        	start_time : start_time,
			end_time : end_time,
            action: 'threat_priority' // Specify the action to retrieve data
        },
        success: function (data) {
            // Extract data for the chart
            var labels = Object.keys(data);
            
            labels.sort(function (a, b) {
                return new Date(a) - new Date(b);
            });
            
            var dataset1 = labels.map(function (date) {
                return data[date]["1"];
            });
            var dataset2 = labels.map(function (date) {
                return data[date]["2"];
            });
            var dataset3 = labels.map(function (date) {
                return data[date]["3"];
            });
            
           
    		if (barChart) {
    			barChart.destroy();
    		  }

            // Create the bar chart
            var ctx = document.getElementById("barChart").getContext("2d");
            
            
             barChart = new Chart(ctx, {
                type: "bar",
                data: {
                    labels: labels,
                    datasets: [
					{
    					label: "High",
    					data: dataset1,
   						 backgroundColor: "rgba(255, 0, 0, 1)",
					},
					{
   						 label: "Medium",
    					 data: dataset2,
   						 backgroundColor: "rgba(255, 165, 0, 1)"
					},
					{
    					label: "Low",
   						data: dataset3,
    					backgroundColor: "rgba(0, 128, 0, 1)",
					},
                    ],
                },
                options: {
                    scales: {
                        x: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Date', // Add the X-axis label here
                            },
                        },
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Threat Count Priority', // Add the Y-axis label here
                            },
                        },
                    },
                },
            });
        },
        error: function (xhr, status, error) {
            console.error("Error fetching data:", error);
        },
    });
	}	
	
	
	function updateBarChartToday(){
		
		$.ajax({
	        url: 'dashboard',
	        type: 'POST',
	        data: {
	        
	            action: 'threat_today_bar' // Specify the action to retrieve data
	        },
	        success: function (data) {
	            // Extract data for the chart
	            var labels = Object.keys(data);
	            
	            labels.sort(function (a, b) {
	                return new Date(a) - new Date(b);
	            });
	            
	            var dataset1 = labels.map(function (date) {
	                return data[date]["1"];
	            });
	            var dataset2 = labels.map(function (date) {
	                return data[date]["2"];
	            });
	            var dataset3 = labels.map(function (date) {
	                return data[date]["3"];
	            });

	            
	            
	    		if (barChart) {
	    			barChart.destroy();
	    		  }
	    		  
	            // Create the bar chart
	            var ctx = document.getElementById("barChart").getContext("2d");
	            
	            
	            barChart = new Chart(ctx, {
	                type: "bar",
	                data: {
	                    labels: labels,
	                    datasets: [
{
    label: "High",
    data: dataset1,
    backgroundColor: "rgba(255, 0, 0, 1)",
},
{
    label: "Medium",
    data: dataset2,
    backgroundColor: "rgba(255, 165, 0, 1)"
},
{
    label: "Low",
    data: dataset3,
    backgroundColor: "rgba(0, 128, 0, 1)",
},
	                    ],
	                },
	                options: {
	                    scales: {
	                        x: {
	                            beginAtZero: true,
	                            title: {
	                                display: true,
	                                text: 'Date', // Add the X-axis label here
	                            },
	                        },
	                        y: {
	                            beginAtZero: true,
	                            title: {
	                                display: true,
	                                text: 'Threat Count Priority', // Add the Y-axis label here
	                            },
	                        },
	                    },
	                },
	            });
	        },
	        error: function (xhr, status, error) {
	            console.error("Error fetching data:", error);
	        },
	    });
		}	
	
function updateBarChartYesterday(){
		
		$.ajax({
	        url: 'dashboard',
	        type: 'POST',
	        data: {
	        
	            action: 'threat_yesterday_bar' // Specify the action to retrieve data
	        },
	        success: function (data) {
	            // Extract data for the chart
	            var labels = Object.keys(data);
	            
	            labels.sort(function (a, b) {
	                return new Date(a) - new Date(b);
	            });
	            
	            var dataset1 = labels.map(function (date) {
	                return data[date]["1"];
	            });
	            var dataset2 = labels.map(function (date) {
	                return data[date]["2"];
	            });
	            var dataset3 = labels.map(function (date) {
	                return data[date]["3"];
	            });

	          
	    		if (barChart) {
	    			barChart.destroy();
	    		  }
	    		
	            // Create the bar chart
	            var ctx = document.getElementById("barChart").getContext("2d");
	            
	            barChart = new Chart(ctx, {
	                type: "bar",
	                data: {
	                    labels: labels,
	                    datasets: [
{
    label: "High",
    data: dataset1,
    backgroundColor: "rgba(255, 0, 0, 1)",
},
{
    label: "Medium",
    data: dataset2,
    backgroundColor: "rgba(255, 165, 0, 1)"
},
{
    label: "Low",
    data: dataset3,
    backgroundColor: "rgba(0, 128, 0, 1)",
},
	                    ],
	                },
	                options: {
	                    scales: {
	                        x: {
	                            beginAtZero: true,
	                            title: {
	                                display: true,
	                                text: 'Date', // Add the X-axis label here
	                            },
	                        },
	                        y: {
	                            beginAtZero: true,
	                            title: {
	                                display: true,
	                                text: 'Threat Count Priority', // Add the Y-axis label here
	                            },
	                        },
	                    },
	                },
	            });
	        },
	        error: function (xhr, status, error) {
	            console.error("Error fetching data:", error);
	        },
	    });
		}	
		
function updateBarChartWeek(){
	
	$.ajax({
        url: 'dashboard',
        type: 'POST',
        data: {
        
            action: 'threat_week_bar' // Specify the action to retrieve data
        },
        success: function (data) {
            // Extract data for the chart
            var labels = Object.keys(data);
            
            labels.sort(function (a, b) {
                return new Date(a) - new Date(b);
            });
            
            var dataset1 = labels.map(function (date) {
                return data[date]["1"];
            });
            var dataset2 = labels.map(function (date) {
                return data[date]["2"];
            });
            var dataset3 = labels.map(function (date) {
                return data[date]["3"];
            });

          
    		if (barChart) {
    			barChart.destroy();
    		  }
    		
            // Create the bar chart
            var ctx = document.getElementById("barChart").getContext("2d");
            
            barChart = new Chart(ctx, {
                type: "bar",
                data: {
                    labels: labels,
                    datasets: [
{
    label: "High",
    data: dataset1,
    backgroundColor: "rgba(255, 0, 0, 1)",
},
{
    label: "Medium",
    data: dataset2,
    backgroundColor: "rgba(255, 165, 0, 1)"
},
{
    label: "Low",
    data: dataset3,
    backgroundColor: "rgba(0, 128, 0, 1)",
},
                    ],
                },
                options: {
                    scales: {
                        x: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Date', // Add the X-axis label here
                            },
                        },
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Threat Count Priority', // Add the Y-axis label here
                            },
                        },
                    },
                },
            });
        },
        error: function (xhr, status, error) {
            console.error("Error fetching data:", error);
        },
    });
	}	
	
function updateBarChartMonth(){
	
	$.ajax({
        url: 'dashboard',
        type: 'POST',
        data: {
        
            action: 'threat_month_bar' // Specify the action to retrieve data
        },
        success: function (data) {
            // Extract data for the chart
            var labels = Object.keys(data);
            
            labels.sort(function (a, b) {
                return new Date(a) - new Date(b);
            });
            
            var dataset1 = labels.map(function (date) {
                return data[date]["1"];
            });
            var dataset2 = labels.map(function (date) {
                return data[date]["2"];
            });
            var dataset3 = labels.map(function (date) {
                return data[date]["3"];
            });

          
    		if (barChart) {
    			barChart.destroy();
    		  }
    		
            // Create the bar chart
            var ctx = document.getElementById("barChart").getContext("2d");
            
            barChart = new Chart(ctx, {
                type: "bar",
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: "High",
                            data: dataset1,
                            backgroundColor: "rgba(255, 0, 0, 1)",
                        },
                        {
                            label: "Medium",
                            data: dataset2,
                            backgroundColor: "rgba(255, 165, 0, 1)"
                        },
                        {
                            label: "Low",
                            data: dataset3,
                            backgroundColor: "rgba(0, 128, 0, 1)",
                        },
                    ],
                },
                options: {
                    scales: {
                        x: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Date', // Add the X-axis label here
                            },
                        },
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Threat Count Priority', // Add the Y-axis label here
                            },
                        },
                    },
                },
            });
        },
        error: function (xhr, status, error) {
            console.error("Error fetching data:", error);
        },
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
	 
 function threatCountsLineChartToday(){
		
	        // AJAX request to fetch data from the servlet
	        $.ajax({
	            url: 'dashboard', // Replace with your servlet URL
	            type: 'POST',
	            data: {
	                action: 'threat_today_line' // Specify the action to retrieve data
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
 
 function threatCountsLineChartYesterday(){
		
     // AJAX request to fetch data from the servlet
     $.ajax({
         url: 'dashboard', // Replace with your servlet URL
         type: 'POST',
         data: {
             action: 'threat_yesterday_line' // Specify the action to retrieve data
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
 
 function threatCountsLineChartWeek(){
		
     // AJAX request to fetch data from the servlet
     $.ajax({
         url: 'dashboard', // Replace with your servlet URL
         type: 'POST',
         data: {
             action: 'threat_week_line' // Specify the action to retrieve data
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
 
 function threatCountsLineChartMonth(){
		
     // AJAX request to fetch data from the servlet
     $.ajax({
         url: 'dashboard', // Replace with your servlet URL
         type: 'POST',
         data: {
             action: 'threat_month_line' // Specify the action to retrieve data
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
 
 /* function getCurrentTimeInIndia() {
	    // Get the current date in local time
	    const date = new Date();

	    // Set date to the beginning of today in local time
	    date.setHours(0, 0, 0, 0);

	    // Get the offset in minutes for IST (Indian Standard Time)
	    const ISTOffset = 330; // IST is UTC+5:30

	    // Calculate the total offset in milliseconds
	    const offset = ISTOffset * 60 * 1000;

	    // Convert the local date to IST by adding the offset
	    const ISTTime = new Date(date.getTime() + offset);

	    // Subtract 24 hours from ISTTime to get the beginning of yesterday in IST
	    const ISTTimeYesterday = new Date(ISTTime.getTime() - (24 * 60 * 60 * 1000));

	    // Format both ISTTimeYesterday and current ISTTime as strings in "yyyy-MM-ddTHH:mm" format
	    const formattedYesterday = ISTTimeYesterday.toISOString().slice(0, 16);
	    const formattedToday = ISTTime.toISOString().slice(0, 16);

	    // Set yesterday's IST time as the value of the "startdatetime" input field
	    document.getElementById('start_time').value = formattedYesterday;

	    // Set today's IST time as the value of the "enddatetime" input field
	    document.getElementById('end_time').value = formattedToday;

	    // Debugging: Log both calculated times to the console
	    console.log('Yesterday\'s IST time:', formattedYesterday);
	    console.log('Today\'s IST time:', formattedToday);
	}
 */ 
 
 function snortDetails() {
     var snort_type = $('#snort_type').val();
     
     if(snort_type == 'IDS'){
    	 
    	// Display the custom modal dialog
		  var modal = document.getElementById('custom-modal-ids');
		  modal.style.display = 'block';
		  
		// Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-ids');
		  confirmButton.onclick = function () {
			  
			  $.ajax({
					url : 'dashboard',
					type : 'POST',
					data : {
						snort_type : snort_type,
						action: 'snort_type'
					},
					success : function(data) {
						
						// Close the modal
				        modal.style.display = 'none';

					},
					error : function(xhr, status, error) {
						console.log('Error updating snort details: ' + error);
					}
				});
			  
		  }
		  
		  var cancelButton = document.getElementById('cancel-button-ids');
		  cancelButton.onclick = function () {
		    // Close the modal
		    modal.style.display = 'none';
		    $('#snort_type').val('Select snort type');
		    
		  };
    	 
     }else if(snort_type == 'IPS'){
    	 
    	// Display the custom modal dialog
		  var modal = document.getElementById('custom-modal-ips');
		  modal.style.display = 'block';
		  
		// Handle the confirm button click
		  var confirmButton = document.getElementById('confirm-button-ips');
		  confirmButton.onclick = function () {
			  
			  $.ajax({
					url : 'dashboard',
					type : 'POST',
					data : {
						snort_type : snort_type,
						action: 'snort_type'
					},
					success : function(data) {
						
						// Close the modal
				        modal.style.display = 'none';

					},
					error : function(xhr, status, error) {
						console.log('Error updating snort details: ' + error);
					}
				});
			  
		  }
		  
		  var cancelButton = document.getElementById('cancel-button-ips');
		  cancelButton.onclick = function () {
		    // Close the modal
		    modal.style.display = 'none';
		    $('#snort_type').val('Select snort type');
		  };
     }
 }

 
 
 
$(document).ready(function() {
	<%// Access the session variable
	HttpSession role = request.getSession();
	String roleValue = (String) session.getAttribute("role");%>

roleValue = '<%=roleValue%>';

if (roleValue === "null") {
    var modal = document.getElementById('custom-modal-session-timeout');
    modal.style.display = 'block';

    // Handle the confirm button click
    var confirmButton = document.getElementById('confirm-button-session-timeout');
    confirmButton.onclick = function() {
        // Close the modal
        modal.style.display = 'none';
        window.location.href = 'login.jsp';
    };
} else{
	
	<%// Access the session variable
	HttpSession token = request.getSession();
	String tokenValue = (String) session.getAttribute("token");%>

	tokenValue = '<%=tokenValue%>';
	
	latestActiveThreats();
	countDetails();
	/* getCurrentTimeInIndia();
	setInterval(getCurrentTimeInIndia, 60000); */
	
	var today = new Date();

    // Set the "To" date picker value to today's date
    document.getElementById('end_time').value = formatDate(today);

    // Get yesterday's date
    var yesterday = new Date();
    yesterday.setDate(today.getDate() - 1);

    // Set the "From" date picker value to yesterday's date
    document.getElementById('start_time').value = formatDate(yesterday);

    // Function to format the date as YYYY-MM-DD
    function formatDate(date) {
        var year = date.getFullYear();
        var month = (date.getMonth() + 1).toString().padStart(2, '0');
        var day = date.getDate().toString().padStart(2, '0');
        return year + '-' + month + '-' + day;
    }
	
	threatCountsLineChart();
	updateBarChart();
	
	$('#apply').click(function() {
		threatCountsLineChart();
		updateBarChart();
	});
		
	$('#today').click(function() {
		threatCountsLineChartToday();
		updateBarChartToday();
	});
	
	$('#yesterday').click(function() {
		threatCountsLineChartYesterday();
		updateBarChartYesterday();
	});
	
	$('#week').click(function() {
		threatCountsLineChartWeek();
		updateBarChartWeek();
	});
	
	$('#month').click(function() {
		threatCountsLineChartMonth();
		updateBarChartMonth();		
	});
	
	
	$('#show_all').click(function() {
		window.location.href = 'activethreats.jsp';
	});
	
	$('#snort_type').change(function() {
		snortDetails();
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
		<h3>CYBERGUARD DASHBOARD</h3>
		<hr />
		
		<div class="container">
		
		<input type="hidden" id="action" name="action" value="">
		
		
		<div class="row"
					style="display: flex; flex-content: space-between; margin-top: -10px; margin-left: -10px;">
						<input type="button" value="Today" id="today"/> 
						<input style="margin-left: 5px" type="button" value="Yesterday" id="yesterday" /> 
						<input style="margin-left: 5px" type="button" value="Week" id="week" />
						<input style="margin-left: 5px" type="button" value="Month" id="month" />
						<!-- <label style="margin-left: 5px;">From</label><input style="margin-left: 3px" type="datetime-local" id="start_time" name="start_time" />
						<label style="margin-left: 5px;">To</label><input style="margin-left: 3px" type="datetime-local" id="end_time" name="end_time" /> -->
						
						<label for="datepicker" style="margin-left: 5px;">From</label>
    						<input type="date" id="start_time" name="start_time">
    						
    						<label for="datepicker" style="margin-left: 5px;">To</label>
    						<input type="date" id="end_time" name="end_time">
    
						<input style="margin-left: 15px" type="button" value="Apply" id="apply" />						
						
						 <div style="display: flex; justify-content: flex-end; width: 100%;">
    						<div style="text-align: right; width: 15%;">
        						<select class="snort_type" id="snort_type" name="snort_type" style="height: 33px; ">
           							<option value="Select snort type">Select snort type</option>
            						<option value="IDS">IDS</option>
            						<option value="IPS">IPS</option>
        						</select>
    						</div>
    						<span style="color: red; font-size: 12px;" id="snortError"></span>
						</div> 
										
				</div>
				
				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: 10px; height:25%; margin-left: -10px;">
					
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
    					
    					<div style="display: flex; justify-content: right;margin-right:10px;margin-top:1px;">
    					<input type="button" value="Show all" id="show_all" /> 
    					
    					</div>			
					</div>					
				</div>
				
				<div class="row"
					style="display: flex; flex-content: space-between; ">
					<div class="threats_count">
					<h5>Day wise threats count</h5>
					 <canvas id="lineChart" ></canvas>
					</div>
					
					<div class="threats_priority">
					<h5 style="margin-left: 50px;">Day wise threats priority</h5>
					  <canvas id="barChart"  ></canvas>
					</div>
				</div>	
				
				<div id="custom-modal-session-timeout" class="modal-session-timeout">
					<div class="modal-content-session-timeout">
						 <p id="session-msg"></p>
						<button id="confirm-button-session-timeout">OK</button>
					</div>
				 </div>			
				 
				 <div id="custom-modal-ids" class="modal-ids">
					<div class="modal-content-ids">
						<p>Are you sure you want to update to IDS</p>
						<button id="confirm-button-ids">Yes</button>
				  		<button id="cancel-button-ids">No</button>
					</div>
				 </div>		
				 
				 <div id="custom-modal-ips" class="modal-ips">
					<div class="modal-content-ips">
						<p>Are you sure you want to update to IPS</p>
						<button id="confirm-button-ips">Yes</button>
				  		<button id="cancel-button-ips">No</button>
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