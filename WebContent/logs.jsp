<%-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Logs</title>
<link rel="stylesheet" type="text/css" href="nav-bar.css" />
<%@ include file="header.jsp"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	function loadLogFileList() {
		$
				.ajax({
					url : "logs",
					type : "GET",
					dataType : "json",
					success : function(data) {
						if (data.log_file_result
								&& Array.isArray(data.log_file_result)) {
							var selectElement = $('#log_file');
							// Clear any existing options
							selectElement.empty();

							// Loop through the data and add options to the select element
							data.log_file_result.forEach(function(filename) {
								var option = $('<option>', {
									value : filename,
									text : filename
								});
								selectElement.append(option);
							});
						}
					},
					error : function(xhr, status, error) {
						console.log("Error logs: " + error);
					},
				});
	}

	//Function to execute on page load
	$(document).ready(function() {
		// Load log file list
		loadLogFileList();
		
		displayData(currentPage);
		const totalPages = Math.ceil(dataArray.length / itemsPerPage);
		generatePaginationControls(totalPages);

	});
	/* function loadLogFile() {
		// Get the selected log file value from the dropdown
		var selectedLogFile = document.getElementById("log_file").value;

		if (selectedLogFile !== "") {
			// Here, you can perform the logic to load the log file data using JavaScript or make an AJAX call to the server
			// For demonstration purposes, let's just show an alert with the selected log file name
			alert("Loading log file: " + selectedLogFile);
		} else {
			alert("Please select a log file first.");
		}
	} */
	function loadLogFile() {
		// Get the selected log file value from the dropdown
		var selectedLogFile = document.getElementById("log_file").value;

		if (selectedLogFile !== "") {
			// Make an AJAX POST request to fetch the log data
			$
					.ajax({
						url : "logs", // Replace this with the appropriate server-side URL to handle the AJAX POST
						type : "POST",
						data : {
							log_file : selectedLogFile
						}, // Send the selected log file name as POST data
						//dataType : "json",
						success : function(data) {
							// Data is the JSON array returned from the server
							if (data.log_file_data
									&& Array.isArray(data.log_file_data)) {
								var tableBody = $("#log_table_body");
								tableBody.empty(); // Clear any existing data

								// Loop through the log data and add rows to the table
								data.log_file_data.forEach(function(log) {

									var sub_log1 = log.substring(0, 24)
									var sub_log2 = log.substring(24, 33)

									var sub_log3 = log.substring(48)

									if (sub_log3.match(/^\d/)) {

										sub_log3 = log.substring(49)
									}

									if (sub_log3.startsWith("]")) {
										//	console.log(true)
										sub_log3 = log.substring(50)
									}

									var row = $("<tr>").append(
											$("<td>").text(sub_log1),
											$("<td>").text(sub_log2),
											$("<td>").text(sub_log3));
									tableBody.append(row);
								});

								var count = data.log_file_data.length
								console.log("count : " + count)

								var totalPages = Math.ceil(count / 100);
								console.log("Per page records : " + totalPages)

								

								// Show the table
								$("#log_table").show();
							}
						},
						error : function(xhr, status, error) {
							console.log("Error logs: " + error);
						},
					});
		} else {
			alert("Please select a log file first.");
		}
	}
	
	
	
/* 	-----------------------------------------------------*/
 
 //pagination code
								
								 const dataArray = Array.from({ length: 100 },  index, $("#log_table_body"));
								
								 const itemsPerPage = 10; // Number of items to display per page
								 let currentPage = 1; // Current page number
								 
								// Function to display data for the current page
								 function displayData(currentPage) {
								   const dataContainer = document.getElementById('log_table_body');
								   dataContainer.innerHTML = '';
							}
								 
								 const startIndex = (currentPage - 1) * itemsPerPage;
								  const endIndex = startIndex + itemsPerPage;
								  
								// Get the items for the current page and display them
								  const itemsToShow = dataArray.slice(startIndex, endIndex);
								  itemsToShow.forEach(function(item) {
								    const itemElement = document.createElement('div');
								    itemElement.textContent = item;
								    dataContainer.appendChild(itemElement);
								  });
								
							
							function generatePaginationControls(totalPages) {
								  const paginationContainer = document.getElementById('pagination-container');
								  paginationContainer.innerHTML = '';
								  const previousButton = document.createElement('button');
								  previousButton.textContent = 'Previous';
								  previousButton.disabled = currentPage === 1;
								  previousButton.addEventListener('click', function() {
								    if (currentPage > 1) {
								      currentPage--;
								      displayData(currentPage);
								      updatePaginationControls();
								    }
								  });

								  const nextButton = document.createElement('button');
								  nextButton.textContent = 'Next';
								  nextButton.disabled = currentPage === totalPages;
								  nextButton.addEventListener('click', function() {
								    if (currentPage < totalPages) {
								      currentPage++;
								      displayData(currentPage);
								      updatePaginationControls();
								    }
								  });

								  paginationContainer.appendChild(previousButton);
								  
								// Generate page number buttons
								  for (var i = 1; i <= totalPages; i++) {
								    const pageButton = document.createElement('button');
								    pageButton.textContent = i;
								    pageButton.disabled = currentPage === i;
								    pageButton.addEventListener('click', function() {
								      currentPage = i;
								      displayData(currentPage);
								      updatePaginationControls();
								    });
								    
								    paginationContainer.appendChild(pageButton);
								  }

								  paginationContainer.appendChild(nextButton);
								}
							
							// Function to update pagination controls when the current page changes
							function updatePaginationControls() {
							  const totalPages = Math.ceil(dataArray.length / itemsPerPage);
							  const pageButtons = document.querySelectorAll('#pagination-container button');
							  pageButtons.forEach((function(index) {
							    button.disabled = currentPage === index + 1;
							  }));
							}
							
							// Initial setup
							
 
 
 </script>

<style type="text/css">
.combo {
	margin-left: 250px;
}

h2 {
	margin-left: 250px;
	margin-top: 65px;
}

.log_label {
	margin-left: 250px;
}
</style>
</head>
<body>
	<div class="container">
		<div class="sidebar">
			<%@ include file="common.jsp"%></div>



		<div class="content">
			<h1>Logs</h1>
			<label for="log_file">Choose a log file:</label> <select
				id="log_file">
				<option value="">Select Log File First</option>
				<!-- <option value="log1.txt">Log 1</option>
				<option value="log2.txt">Log 2</option> -->
				<!-- Add more log file options as needed -->
			</select>
			<button onclick="loadLogFile()">Load Log File</button>


			<!-- Table to display the log data -->

			<table id="log_table">

				<thead>
					<tr>
						<th style="width: 30%">Date and Time</th>
						<th style="width: 20%">Log Level</th>
						<th>Message</th>


					</tr>
				</thead>
				<tbody id="log_table_body">
				</tbody>
			</table>

		</div>

	</div>
	
	<div id="pagination-container"></div>
	<%@ include file="footer.jsp"%>
</body>
</html> --%>



<!-- --------------------------------------------------------------------------------------------------------------------- -->

<!-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%> -->
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
    <title>WP500 Web Configuration</title>
<link
      rel="icon"  
      type="image/png"
      sizes="32x32"
      href="favicon.png"
    /> 
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css"
    />
    <link
      href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
      rel="stylesheet"
      type="text/css"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css"
    />
    <link rel="stylesheet" href="nav-bar.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
      function loadLogFileList() {
        $.ajax({
          url: "logs",
          type: "GET",
          dataType: "json",
          success: function (data) {
            if (data.log_file_result && Array.isArray(data.log_file_result)) {
              var selectElement = $("#log_file");
              // Clear any existing options
              selectElement.empty();

              // Loop through the data and add options to the select element
              data.log_file_result.forEach(function (filename) {
                var option = $("<option>", {
                  value: filename,
                  text: filename,
                });
                selectElement.append(option);
              });
            }
          },
          error: function (xhr, status, error) {
            console.log("Error logs: " + error);
          },
        });
      }

      //Function to execute on page load
      $(document).ready(function () {
        // Load log file list
        loadLogFileList();
      });
      /* function loadLogFile() {
		// Get the selected log file value from the dropdown
		var selectedLogFile = document.getElementById("log_file").value;

		if (selectedLogFile !== "") {
			// Here, you can perform the logic to load the log file data using JavaScript or make an AJAX call to the server
			// For demonstration purposes, let's just show an alert with the selected log file name
			alert("Loading log file: " + selectedLogFile);
		} else {
			alert("Please select a log file first.");
		}
	} */
      function loadLogFile() {
        // Get the selected log file value from the dropdown
        var selectedLogFile = document.getElementById("log_file").value;

        if (selectedLogFile !== "") {
          // Make an AJAX POST request to fetch the log data
          $.ajax({
            url: "logs", // Replace this with the appropriate server-side URL to handle the AJAX POST
            type: "POST",
            data: {
              log_file: selectedLogFile,
            }, // Send the selected log file name as POST data
            //dataType : "json",
            success: function (data) {
              // Data is the JSON array returned from the server
              if (data.log_file_data && Array.isArray(data.log_file_data)) {
                var tableBody = $("#log_table_body");
                tableBody.empty(); // Clear any existing data

                // Loop through the log data and add rows to the table
                data.log_file_data.forEach(function (log) {
                	
                  /* var sub_log1 = log.substring(0, 24);
                  var sub_log2 = log.substring(24, 33);

                  var sub_log3 = log.substring(48);

                  if (sub_log3.match(/^\d/)) {
                    sub_log3 = log.substring(49);
                  }

                  if (sub_log3.startsWith("]")) {
                    //	console.log(true)
                    sub_log3 = log.substring(50);
                  }
 */

 			//let text = "How are you doing today?";
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
                   /*  $("<td>").text(sub_log2),
                    $("<td>").text(sub_log3) */
                  );
                  tableBody.append(row);
                });

                var count = data.log_file_data.length;
                console.log("count : " + count);

                var totalPages = Math.ceil(count / 100);
                console.log("Per page records : " + totalPages);

                // Show the table
                $("#log_table").show();
              }
            },
            error: function (xhr, status, error) {
              console.log("Error logs: " + error);
            },
          });
        } else {
          alert("Please select a log file first.");
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
		<div class="row" style="margin-top: 3%;">
			<div style="width: 20%; float: left;">
			  <label for="log_file">Choose a log file:</label>
			</div>
			<div style="width: 40%; float: left;">
				<select id="log_file">
					<option value="">Select Log File First</option>
				</select>	
			</div>

			<div>
			<input style="margin-left: 1%;margin-top: 2px;"
				type="button" onclick="loadLogFile()" value="Load Log File">
			</div>
		  </div>

        <!-- Table to display the log data -->
		<div class="container" style="margin-top: 1%;">
        <table id="log_table">
          <thead>
            <tr>
              <th style="width: 15%">Date and Time</th>
              <th style="width: 8%">Log Type</th>
             <th style="width: 15%">Line Number</th>
              <th>Class</th>
              <th style="width: 55%">Message</th>
              
            </tr>
          </thead>
          <tbody id="log_table_body"></tbody>
        </table>
	</div>
      </section>
    </div>
	<div class="footer">
		<%@ include file="footer.jsp"%>
	  </div>
  </body>
</html>