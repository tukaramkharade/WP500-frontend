
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>WP500 Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="favicon.png" />
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
<script>
	
var roleValue;

	var json = {};

      function loadBrokerIPList() {
        $.ajax({
          url: "jsonBuilderData",
          type: "GET",
          dataType: "json",
          success: function (data) {
            if (data.broker_ip_result && Array.isArray(data.broker_ip_result)) {
              var selectElement = $("#broker_name");
              // Clear any existing options
           //   selectElement.empty();

              // Loop through the data and add options to the select element
              data.broker_ip_result.forEach(function (filename) {
                var option = $("<option>", {
                  value: filename,
                  text: filename,
                });
                selectElement.append(option);
              });
            }
          },
          error: function (xhr, status, error) {
            console.log("Error showing broker ip list : " + error);
          },
        });
      }
      
      function loadTagList() {
    	    $.ajax({
    	      url: "alarmConfigTagListServlet",
    	      type: "GET",
    	      dataType: "json",
    	      success: function (data) {
    	        if (data.tag_list_result && Array.isArray(data.tag_list_result)) {
    	          var datalist = $("#variable");
    	          // Clear any existing options
    	          datalist.empty();

    	          // Loop through the data and add options to the datalist
    	          data.tag_list_result.forEach(function (tag) {
    	            var option = $("<option>", {
    	              value: tag,
    	              text: tag,
    	            });
    	            datalist.append(option);
    	          });
    	        }
    	      },
    	      error: function (xhr, status, error) {
    	        console.log("Error showing tag list: " + error);
    	      },
    	    });
    	  }
      
       function loadAlarmSettings() {
  		$.ajax({
  			url : 'alarmConfigAddData',
  			type : 'GET',
  			dataType : 'json',
  			success : function(data) {
				// Clear existing table rows
				// Iterate through the user data and add rows to the table
				
				var json1 = JSON.stringify(data);

						var json = JSON.parse(json1);

						if (json.status == 'fail') {
							var confirmation = confirm(json.msg);
							if (confirmation) {
								window.location.href = 'login.jsp';
							}
						}
						
			//	$.each(data,function(index, alarmConfig) {
							
									/* var unit_id = alarmConfig.unit_id;
									var asset_id = alarmConfig.asset_id;
									var broker_type = alarmConfig.broker_type;
									var broker_ip = alarmConfig.broker_ip;
									var interval = alarmConfig.interval;
									var alarm_tag = alarmConfig.alarm_tag; */
									
									alert(data.unit_id + ' ' + data.alarm_tag);
									
									$('#unit_id').val(data.unit_id);
									$('#asset_id').val(data.asset_id);
									$('#broker_type').val(data.broker_type);
									$('#broker_name').val(data.broker_ip);
									$('#interval').val(data.interval);
									//var alarm_tag = $('#alarm_tag').val(data.alarm_tag);
									
									var result = data.alarm_tag;

									if(roleValue == 'ADMIN' || roleValue == 'Admin'){
									$.each($.parseJSON(result), function(k, v) {
									
									if(k != null){
										var newRow = $("<tr>")
	    	        					.append($("<td>").text(k))
	    	        					.append($("<td>").text(v))
	    	        					.append(
    	          $("<td>").html(
    	            `<input
    	                style="background-color :red"
    	                type="button"
    	                value="Delete"
    	                onclick="deleteRow(this)"
    	              />`
    	          )
									
									    
    	        );
									}				
	    	        					$("#table_data").append(newRow);
									});
									}else if(roleValue == 'VIEWER' || roleValue == 'Viewer'){
										
										$.each($.parseJSON(result), function(k, v) {
										    
										    var newRow = $("<tr>")
		    	        					.append($("<td>").text(k))
		    	        					.append($("<td>").text(v))
		    	        					
		    	        					$("#table_data").append(newRow);
										});
									}
									
									
									if(unit_id != null){
										$('#addBtn').val('Edit');
									}
									else{
										$('#addBtn').val('Add');
									}
									//alert(JSON.stringify(alarm_tag));
									
									$('#unit_id').val(unit_id);
									$('#asset_id').val(asset_id);
									$('#broker_type').val(broker_type);
									$('#broker_name').val(broker_ip);
									$('#interval').val(interval);
									//$('#table_data').val(JSON.stringify(alarm_tag));
									
									
							//	});
			},
  			error : function(xhr, status, error) {
  				// Handle the error response, if needed
  				console.log('Error: ' + error);
  			}
  		});
  	
  	} 
       
       function deleteAlarm() {
   		
   		var confirmation = confirm('Are you sure you want to delete this alarm settings?');
   		if (confirmation) {
   			$.ajax({
   				url : 'alarmConfigTagListServlet',
   				type : 'POST',
   				dataType : 'json',
   				success : function(data) {
   					// Display the registration status message
   					alert(data.message);

   					// Refresh the user list
   					loadAlarmSettings();
   				},
   				error : function(xhr, status, error) {
   					// Handle the error response, if needed
   					console.log('Error deleting alarm settings: '
   							+ error);
   				}
   			});
   		}
   	}
       
       function validatefields(tag_name) {
   		var tagnameError = document.getElementById("tagnameError");

   		if (tag_name === "") {
   			tagnameError.textContent = "Please enter tag name";
   			return false;
   		} else {
   			tagnameError.textContent = "";
   			return true;
   		}
   	}

   	function validateOption(variable) {
   		var variableError = document.getElementById("variableError");

   		if (variable === "") {
   			variableError.textContent = "Please select variable";
   			return false;
   		} else {
   			variableError.textContent = "";
   			return true;
   		}
   	}
   	
   	function validateInterval(interval) {
		var intervalError = document.getElementById("intervalError");

		if (interval == 'Select interval'){
			
			intervalError.textContent = "Please select interval";
			return false;
		} else {
			intervalError.textContent = "";
			return true;
		}
	}
	
	function validateBrokerType(broker_type) {
		var brokerTypeError = document.getElementById("brokerTypeError");

		if (broker_type == 'Select broker type'){
			
			brokerTypeError.textContent = "Please select broker type";
			return false;
		} else {
			brokerTypeError.textContent = "";
			return true;
		}
	}
	
	function validateBrokerIPAddress(broker_name) {
		var brokerIPAddressError = document.getElementById("brokerIPAddressError");

		if (broker_name == 'Select broker IP address'){
			
			brokerIPAddressError.textContent = "Please select broker ip address";
			return false;
		} else {
			brokerIPAddressError.textContent = "";
			return true;
		}
	}
     
	
	function changeButtonColor(isDisabled) {
        var $add_button = $('#addBtn');
        var $delete_button = $('#delBtn');
        var $clear_button = $('#clearBtn');
        var $save_button = $('#saveBtn');
        
        
        if (isDisabled) {
            $add_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $add_button.css('background-color', '#2b3991'); // Reset to original color
        }
        
        if (isDisabled) {
            $delete_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $delete_button.css('background-color', '#2b3991'); // Reset to original color
        }
        
        if (isDisabled) {
            $clear_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $clear_button.css('background-color', '#2b3991'); // Reset to original color
        }
        
        if (isDisabled) {
            $save_button.css('background-color', 'gray'); // Change to your desired color
        } else {
            $save_button.css('background-color', '#2b3991'); // Reset to original color
        }
    }
	
      $(document).ready(function () {
    	  
    	  <%
    	// Access the session variable
    	HttpSession role = request.getSession();
    	String roleValue = (String) session.getAttribute("role");
    	%>
    	
    	roleValue = '<%= roleValue %>'; // This will insert the session value into the JavaScript code
        
    	//alert(roleValue);
    	
    	  loadAlarmSettings();
    	  
    	  if(roleValue == 'VIEWER' == roleValue == 'Viewer'){
    		  
    		  var confirmation = confirm('You do not have enough privileges for role VIEWER');
    		  $("#actions").hide();
    		  $('#addBtn').prop('disabled', true);
    		  $('#clearBtn').prop('disabled', true); 
    		  $('#delBtn').prop('disabled', true);
    		  $('#saveBtn').prop('disabled', true);
    		  changeButtonColor(true);
    	  }
    	  
    	  loadBrokerIPList();
    	  loadTagList();
    	  
    	  
    	  $("#saveBtn").click(function () {
    	    var tagName = $("#tag_name").val();
    	    var value = $("#variable").val();
    	    
    	    // Check if tagName and value are not empty
    	    if (tagName.trim() !== "" && value.trim() !== "") {
    	      var newRow = $("<tr>")
    	        .append($("<td>").text(tagName))
    	        .append($("<td>").text(value))
    	        .append(
    	          $("<td>").html(
    	            `<input
    	                style="background-color :red"
    	                type="button"
    	                value="Delete"
    	                onclick="deleteRow(this)"
    	              />`
    	          )
    	        );

    	      $("#table_data").append(newRow);
    	      $("#tag_name").val("");
    	      $("#variable").val("");
    	    } else  if (!validatefields(tagName)) {
				tagnameError.textContent = "Please enter tag name.";
				return;
			}
    	    else if (!validateOption(value)) {
				variableError.textContent = "Please select variable.";
				return;
			}
    	     
    	  });
    	  
    	  
      	$('#alarmConfigForm').submit(function(event) {
			event.preventDefault();
			var buttonText = $('#addBtn').val();
			
			var interval = $('#interval').find(":selected").val();
			var broker_type = $('#broker_type').find(":selected").val();
			var broker_name = $('#broker_name').find(":selected").val();
			
			if (!validateInterval(interval)) {
				intervalError.textContent = "Please select interval";
				return;
			}
			
			if (!validateBrokerType(broker_type)) {
				brokerTypeError.textContent = "Please select broker type";
				return;
			}
			
			if (!validateBrokerIPAddress(broker_name)) {
				brokerIPAddressError.textContent = "Please select broker ip address ";
				return;
			}


			if (buttonText == 'Add') {
				addAlarmConfig();
			} else {
				editAlarmConfig();
			}
		});
      	  
    	  $('#clearBtn').click(function(){
    		  $('#unit_id').val('');
  			$('#asset_id').val('');
  			$('#broker_type').val('Select broker type');
  			$('#broker_name').val('Select broker IP address');
  			$('#interval').val('Select interval');
    		  
    	});
    	  
    	  $("#delBtn").click(function () {
    		  deleteAlarm();
    	  });
      });

function deleteRow(button) {
	var confirmation = confirm('Are you sure you want to delete this tag?');
	if (confirmation) {
  $(button).closest("tr").remove();
	}
}

function tableToJson() {
		 const table = document.getElementById("table_data");
	// 	 const json = {};

	  for (var i = 1; i < table.rows.length; i++) {
	    const row = table.rows[i];
	    const tag = row.cells[0].textContent;
	    const variable = row.cells[1].textContent;
	    json[tag] = variable;
	    console.log(json);
	  }

	  return json;
	}
	
function editAlarmConfig() {

	var tagData = tableToJson();
	//alert('tag data : '+tagData)

    var unit_id = $('#unit_id').val();
    var asset_id = $('#asset_id').val();
    var broker_type = $('#broker_type').find(":selected").val();
    var broker_name = $('#broker_name').find(":selected").val();
    var interval = $('#interval').find(":selected").val();
   
	$.ajax({
		url : 'alarmConfigServlet',
		type : 'POST',
		data : {
			unit_id : unit_id,
			asset_id : asset_id,
			broker_type : broker_type,
			broker_name : broker_name,
			interval : interval,
			tagData: JSON.stringify(tagData)
			
		},
		success : function(data) {
			// Display the registration status message
			alert(data.message);

			// Clear form fields

			$('#unit_id').val('');
			$('#asset_id').val('');
			$('#broker_type').val('Select broker type');
			$('#broker_name').val('Select broker IP address');
			$('#interval').val('Select interval');
			
			location.reload();
		},
		error : function(xhr, status, error) {
			console.log('Error updating alarm settings: ' + error);
		}
	});

	$('#addBtn').val('Add');
}

function addAlarmConfig() {

	var tagData = tableToJson();

    var unit_id = $('#unit_id').val();
    var asset_id = $('#asset_id').val();
    var broker_type = $('#broker_type').find(":selected").val();
    var broker_name = $('#broker_name').find(":selected").val();
    var interval = $('#interval').find(":selected").val();
    // Modify the next two lines to get the tag_name and variable from the JSON data
  
	$.ajax({
		url : 'alarmConfigAddData',
		type : 'POST',
		data : {
			unit_id : unit_id,
			asset_id : asset_id,
			broker_type : broker_type,
			broker_name : broker_name,
			interval : interval,
			tagData: JSON.stringify(tagData)
			
		},
		success : function(data) {
			// Display the registration status message
			alert(data.message);
	//		loadMqttList();
	//loadAlarmSettings();

			// Clear form fields

			$('#unit_id').val('');
			$('#asset_id').val('');
			$('#broker_type').val('Select broker type');
			$('#broker_name').val('Select broker IP address');
			$('#interval').val('Select interval');

			location.reload();
		},
		error : function(xhr, status, error) {
			console.log('Error adding alarm settings: ' + error);
		}
	});

	$('#addBtn').val('Add');
}


    </script>
</head>

<body>
	<div class="sidebar"><%@ include file="common.jsp"%></div>
	<div class="header"><%@ include file="header.jsp"%></div>
	<div class="content">
		<section style="margin-left: 1em">
		<h3>ALARM CONFIG SETTINGS</h3>
		<hr />

		<div class="container">
			<form id="alarmConfigForm" action="alarmConfigAddData">
				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: -20px;">
					<div class="col-75-1" style="width: 20%;">
						<input type="text" id="unit_id" name="unit_id"
							placeholder="Unit ID" required style="height: 17px" />
					</div>
					<!-- </div>
				<div class="row"> -->
					<div class="col-75-2" style="width: 20%;">
						<input type="text" id="asset_id" name="asset_id"
							placeholder="Asset ID" required style="height: 17px" />
					</div>
					<!-- </div>

				<div class="row"> -->
					<div class="col-75-3" style="width: 20%;">
						<select class="textBox" id="broker_type" name="broker_type"
							style="height: 35px">
							<option value="Select broker type">Select broker type</option>
							<option value="mqtt">mqtt</option>
							<option value="iothub">iothub</option>
						</select> <span id="brokerTypeError" style="color: red;"></span>
					</div>
					<!-- </div>

				<div class="row"> -->
					<div class="col-75-4" style="width: 20%;">
						<select class="textBox" id="broker_name" name="broker_name"
							style="height: 35px">
							<option value="Select broker IP address">Select broker
								IP address</option>
						</select> <span id="brokerIPAddressError" style="color: red;"></span>
					</div>
					<!-- </div>

				<div class="row"> -->
					<div class="col-75-5" style="width: 20%;">
						<select class="interval-select" id="interval" name="interval"
							style="height: 35px">
							<option value="Select interval">Select interval</option>
							<option value="5 sec">5 sec</option>
							<option value="10 sec">10 sec</option>
							<option value="15 sec">15 sec</option>
							<option value="20 sec">20 sec</option>
							<option value="25 sec">25 sec</option>
							<option value="30 sec">30 sec</option>
							<option value="1 min">1 min</option>
							<option value="5 min">5 min</option>
							<option value="10 min">10 min</option>
							<option value="15 min">15 min</option>
							<option value="20 min">20 min</option>
							<option value="25 min">25 min</option>
							<option value="30 min">30 min</option>
							<option value="1 hour">1 hour</option>
						</select> <span id="intervalError" style="color: red;"></span>
					</div>
				</div>

				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: 10px;">
					<div class="col-75-6" style="width: 20%;">
						<input type="text" id="tag_name" name="tag_name"
							placeholder="Tag name" style="height: 17px" /> <span
							id="tagnameError" style="color: red;"></span>
					</div>

					<div class="col-75-7" style="width: 20%;">
						<select class="textBox" id="variable" name="variable"
							style="height: 35px">
							<option value=""></option>
						</select> <span id="variableError" style="color: red;"></span>
					</div>
				</div>

				<div class="row">

					<!--  <button style="font-size:medium; margin-top: -28px; margin-left:-50px; background-color: #2b3991; color: white; border: none;
  				border-radius: 10px; float: center;" 
						 id="saveBtn">
						 	<i class="fa fa-plus"></i></button> -->

					<input style="margin-top: -31px; margin-left: 10%;" type="button"
						value="+" id="saveBtn" />

				</div>

				<div class="row" style="display: flex; justify-content: right;">
					<input style="margin-top: -31px; margin-left: 5px" type="button"
						value="Clear" id="clearBtn" /> <input
						style="margin-top: -31px; margin-left: 5px" type="submit"
						value="Add" id="addBtn" /> <input
						style="margin-top: -31px; margin-left: 5px" type="button"
						value="Delete" id="delBtn" onClick="window.location.reload();" />
				</div>
			</form>
		</div>
		<hr />
		</section>

		<section style="margin-left: 1em">
		<div class="container">
			<table id="table_data">
				<tr>
					<th>Tag Name</th>
					<th>Variable</th>
					<th id="actions">Action</th>
				</tr>
			</table>
		</div>
		</section>
	</div>

	<div class="footer"><%@ include file="footer.jsp"%></div>
</body>
</html>
