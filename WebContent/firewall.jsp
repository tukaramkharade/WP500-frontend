<%-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<style type="text/css">
</style>
<link rel="stylesheet" type="text/css" href="user_styles.css">
<%@ include file="header.jsp"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	function loadFirewallList() {
		$.ajax({
			url : 'firewallData',
			type : 'GET',
			dataType : 'json',
			success : function(data) {
				// Clear existing table rows

				var firewallTable = $('#firewallListTable tbody');
				firewallTable.empty();
				
				

				// Iterate through the user data and add rows to the table
				$.each(data, function(index, firewall) {
					var row = $('<tr>');
					row.append($('<td>').text(firewall.lineNumber+""));
					row.append($('<td>').text(firewall.target+""))
					row.append($('<td>').text(firewall.protocol+""));				
					row.append($('<td>').text(firewall.opt+""));
					row.append($('<td>').text(firewall.source+""));
					row.append($('<td>').text(firewall.destination+""));

					var actions = $('<td>');
					var deleteButton = $('<button>').text('Delete').click(
							function() {
								deleteFirewall(firewall.lineNumber);
							});

					//	actions.append(editButton);
					actions.append(deleteButton);

					row.append(actions);

					firewallTable.append(row);

				});
			},
			error : function(xhr, status, error) {
				console.log('Error loading firewall data: ' + error);
			}
		});
	}

	function addFirewall() {
		var portNumber = $('#portNumber').val();
		var protocol = $('#protocol').val();
		var ip_addr = $('#ip_addr').val();

		$.ajax({
			url : 'firewallData',
			type : 'POST',
			data : {
				portNumber : portNumber,
				protocol : protocol,
				ip_addr : ip_addr
			},
			success : function(data) {
				// Display the registration status message
				alert(data.message);
				loadFirewallList();

				// Clear form fields
				$('#portNumber').val('');
				$('#protocol').val('');
				$('#ip_addr').val('');
			},
			error : function(xhr, status, error) {
				console.log('Error adding firewall: ' + error);
			}
		});

		$('#addFirewall').val('Add');
	}

	function deleteFirewall(firewallId) {
		// Perform necessary actions to delete the user
		// For example, make an AJAX call to a delete servlet

		alert(firewallId)
		var confirmation = confirm('Are you sure you want to delete this firewall setting?');
		if (confirmation) {
			$.ajax({
				url : 'firewallDeleteServlet',
				type : 'POST',
				data : {
					lineNumber : firewallId
				},
				success : function(data) {
					// Display the registration status message
					alert(data.message);

					// Refresh the user list
					loadFirewallList();
				},
				error : function(xhr, status, error) {
					// Handle the error response, if needed
					console.log('Error deleting user: ' + error);
				}
			});
		}
	}

	//Function to execute on page load
	$(document).ready(function() {
		// Load user list
		loadFirewallList();

		// Handle form submission
		$('#firewallForm').submit(function(event) {
			event.preventDefault();
			var buttonText = $('#addFirewall').val();

			if (buttonText == 'Add') {
				addFirewall();
			}
		});

	});
</script>
</head>
<body>
	<div class="container">
		<div class="sidenav">
			<%@ include file="common.jsp"%>
		</div>
		<div class="content">

			<h2>Firewall</h2>
			<form id="firewallForm" method="post">

				<label class="port_number">Port Number</label> <input type="text"
					id="portNumber" name="portNumber"> <label class="protocol">Protocol</label>
				<input type="text" class="protocol_input" id="protocol"
					name="protocol"> <label class="ip_addr">IP Address</label>
				<input type="text" class="ip_Addr_input" id="ip_addr" name="ip_addr">

				<input type="submit" value="Add" id="addFirewall">

			</form>

			<h2>Firewall Settings List</h2>
			<table id="firewallListTable">
				<thead>
					<tr>
						<th>Chain Number</th>
						<th>Target</th>
						<th>Protocol</th>
						<th>Opt</th>
						<th>Source</th>
						<th>Destination</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					
					<!-- User list table rows will be populated dynamically using JavaScript -->
				</tbody>
			</table>
		</div>
	</div>
	<%@ include file="footer.jsp"%>
</body>
</html> --%>

<!-- --------------------------------------------------------
 -->


<%-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>Insert title here</title>

<link rel="stylesheet" type="text/css" href="user_styles.css" />
<%@ include file="header.jsp"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	function loadFirewallList() {
		$.ajax({
			url : "firewallData",
			type : "GET",
			dataType : "json",
			success : function(data) {
				// Clear existing table rows

				var firewallTable = $("#firewallListTable tbody");
				firewallTable.empty();

				// Iterate through the user data and add rows to the table
				$.each(data, function(index, firewall) {
					var row = $("<tr>");
					row.append($("<td>").text(firewall.lineNumber + ""));
					row.append($("<td>").text(firewall.target + ""));
					row.append($("<td>").text(firewall.protocol + ""));
					row.append($("<td>").text(firewall.opt + ""));
					row.append($("<td>").text(firewall.source + ""));
					row.append($("<td>").text(firewall.destination + ""));

					var actions = $("<td>");
					var deleteButton = $("<button>").text("Delete").click(
							function() {

								deleteFirewall(firewall.lineNumber);
							});

					//	actions.append(editButton);
					actions.append(deleteButton);

					row.append(actions);

					firewallTable.append(row);
				});
			},
			error : function(xhr, status, error) {
				console.log("Error loading firewall data: " + error);
			},
		});
	}

	function addFirewall() {
		var portNumber = $("#portNumber").val();
		var protocol = $("#protocol").val();
		var ip_addr = $("#ip_addr").val();

		$.ajax({
			url : "firewallData",
			type : "POST",
			data : {
				portNumber : portNumber,
				protocol : protocol,
				ip_addr : ip_addr,
			},
			success : function(data) {
				// Display the registration status message
				alert(data.message);
				loadFirewallList();

				// Clear form fields
				$("#portNumber").val("");
				$("#protocol").val("");
				$("#ip_addr").val("");
			},
			error : function(xhr, status, error) {
				console.log("Error adding firewall: " + error);
			},
		});

		$("#addFirewall").val("Add");
	}

	function deleteFirewall(firewallId) {
		// Perform necessary actions to delete the user
		// For example, make an AJAX call to a delete servlet

		alert(firewallId)
		var confirmation = confirm('Are you sure you want to delete this firewall setting?');
		if (confirmation) {
			$.ajax({
				url : 'firewallDeleteServlet',
				type : 'POST',
				data : {
					lineNumber : firewallId
				},
				success : function(data) {
					// Display the registration status message
					alert(data.message);

					// Refresh the user list
					loadFirewallList();
				},
				error : function(xhr, status, error) {
					// Handle the error response, if needed
					console.log('Error deleting user: ' + error);
				}
			});
		}
	}

	//Function to execute on page load
	$(document).ready(function() {
		// Load user list
		loadFirewallList();

		// Handle form submission
		$("#firewallForm").submit(function(event) {
			event.preventDefault();
			var buttonText = $("#addFirewall").val();

			if (buttonText == "Add") {
				addFirewall();
			}
		});
	});
</script>

<style type="text/css">
.content1 {
	display: flex;
	justify-content: space-around;
}

input[type="submit"] {
	padding: 5px 10px;
	background-color: #6c45ed;
	color: white;
	border: none;
	border-radius: 4px;
	cursor: pointer;
}

.content {
	flex: 1;
	padding: 20px;
}



h2 {
	color: #283587;
}

th {
	background-color: #e2e6f9;
	color: #283587;
	  font-family:'Gill Sans', 'Gill Sans MT', Calibri, 'Trebuchet MS', sans-serif;
	
}

.content1 {
	width: 85%;
	display: flex;
	justify-content: space-between;
}

.text {
	margin-left: 20px;
	height: 30px;
}

.submitBtn {
	width: 75px;
	height: 30px;
	background-color:green;
}
</style>
</head>
<body>
	<div class="container">
		<div class="sidebar">
			<%@ include file="common.jsp"%>
		</div>
		<div class="content">
			<h2>Firewall</h2>
			<form id="firewallForm" method="post" class="content1">
				<label class="port_number">Port Number <input
					type="text" id="portNumber" class="text" name="portNumber" /></label>
				<label class="protocol">Protocol <input
					type="text" class="text" id="protocol" name="protocol" /></label>
				<label class="ip_addr">IP Address <input
					type="text" class="text" id="ip_addr" name="ip_addr" />
				</label> <input type="submit" class="submitBtn" value="Add" id="addFirewall" />
			</form>

			<h2>Firewall Settings List</h2>
			<table id="firewallListTable">
				<thead>
					<tr>
						<th>Chain Number</th>
						<th>Target</th>
						<th>Protocol</th>
						<th>Opt</th>
						<th>Source</th>
						<th>Destination</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					<!-- User list table rows will be populated dynamically using JavaScript -->
				</tbody>
			</table>
		</div>
	</div>
	<%@ include file="footer.jsp"%>
</body>
</html> --%>


<!-- -------------------------------------------------------------------------- -->



<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
    <title>Insert title here</title>

    <link rel="stylesheet" type="text/css" href="user_styles.css" />
    <%@ include file="header.jsp"%>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
      function loadFirewallList() {
        $.ajax({
          url: "firewallData",
          type: "GET",
          dataType: "json",
          success: function (data) {
            // Clear existing table rows

            var firewallTable = $("#firewallListTable tbody");
            firewallTable.empty();

            // Iterate through the user data and add rows to the table
            $.each(data, function (index, firewall) {
              var row = $("<tr>");
              row.append($("<td>").text(firewall.lineNumber + ""));
              row.append($("<td>").text(firewall.target + ""));
              row.append($("<td>").text(firewall.protocol + ""));
              row.append($("<td>").text(firewall.opt + ""));
              row.append($("<td>").text(firewall.source + ""));
              row.append($("<td>").text(firewall.destination + ""));

              var actions = $("<td>");
              var deleteButton = $("<button>").text("Delete").click(
						function() {

							deleteFirewall(firewall.lineNumber);
						});

              //	actions.append(editButton);
              actions.append(deleteButton);

              row.append(actions);

              firewallTable.append(row);
            });
          },
          error: function (xhr, status, error) {
            console.log("Error loading firewall data: " + error);
          },
        });
      }

      function addFirewall() {
        var portNumber = $("#portNumber").val();
        var protocol = $("#protocol").val();
        var ip_addr = $("#ip_addr").val();

        $.ajax({
          url: "firewallData",
          type: "POST",
          data: {
            portNumber: portNumber,
            protocol: protocol,
            ip_addr: ip_addr,
          },
          success: function (data) {
            // Display the registration status message
            alert(data.message);
            loadFirewallList();

            // Clear form fields
            $("#portNumber").val("");
            $("#protocol").val("");
            $("#ip_addr").val("");
          },
          error: function (xhr, status, error) {
            console.log("Error adding firewall: " + error);
          },
        });

        $("#addFirewall").val("Add");
      }

      function deleteFirewall(firewallId) {
  		// Perform necessary actions to delete the user
  		// For example, make an AJAX call to a delete servlet

  		alert(firewallId)
  		var confirmation = confirm('Are you sure you want to delete this firewall setting?');
  		if (confirmation) {
  			$.ajax({
  				url : 'firewallDeleteServlet',
  				type : 'POST',
  				data : {
  					lineNumber : firewallId
  				},
  				success : function(data) {
  					// Display the registration status message
  					alert(data.message);

  					// Refresh the user list
  					loadFirewallList();
  				},
  				error : function(xhr, status, error) {
  					// Handle the error response, if needed
  					console.log('Error deleting user: ' + error);
  				}
  			});
  		}
  	}
      //Function to execute on page load
      $(document).ready(function () {
        // Load user list
        loadFirewallList();

        // Handle form submission
        $("#firewallForm").submit(function (event) {
          event.preventDefault();
          var buttonText = $("#addFirewall").val();

          if (buttonText == "Add") {
            addFirewall();
          }
        });
      });
    </script>

    <style type="text/css">
    
       input[type="submit"] {
        padding: 5px 10px;
        background-color: #6c45ed;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
      }

      .content {
        flex: 1;
        padding: 0;
       
      }

      .container {
        display: flex;
      }
      h2 {
        color: #283587;
      }
      th {
        background-color: #e2e6f9;
        color: #283587;
      }
      .content1 {
      
        display: flex;
        justify-content: left;
      }
      .text {
        margin-left: 5px;
        height: 30px;
        margin-right: 10px;
      }
      .submitBtn {
        width: 75px;
        height: 35px;
      } 
    </style>
  </head>
  <body>
    <div class="container">
    <div class="sidebar">
      <%@ include file="common.jsp"%></div>
      <div class="content">
        <h2>Firewall</h2>
        <form id="firewallForm" method="post" class="content1">
          <label class="port_number"
            >Port Number :
            <input type="text" id="portNumber" class="text" name="portNumber"
          /></label>
          <label class="protocol"
            >Protocol :
            <input type="text" class="text" id="protocol" name="protocol"
          /></label>
          <label class="ip_addr"
            >IP Address :
            <input type="text" class="text" id="ip_addr" name="ip_addr" />
          </label>
          <input type="submit" class="submitBtn" value="Add" id="addFirewall" />
        </form>

        <h2>Firewall Settings List</h2>
        <table id="firewallListTable">
          <thead>
            <tr>
              <th>Chain Number</th>
              <th>Target</th>
              <th>Protocol</th>
              <th>Opt</th>
              <th>Source</th>
              <th>Destination</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <!-- User list table rows will be populated dynamically using JavaScript -->
          </tbody>
        </table>
      </div>
    </div>
    <%@ include file="footer.jsp"%>
  </body>
</html>