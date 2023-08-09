
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>WP500 Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="favicon.png" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>

var json = {};
	function loadBrokerIPList() {
		$.ajax({
			url : "commandConfigServlet",
			type : "GET",
			dataType : "json",
			success : function(data) {
				if (data.broker_ip_result
						&& Array.isArray(data.broker_ip_result)) {

					var selectElement = $("#broker_name");
					// Clear any existing options
					selectElement.empty();

					// Loop through the data and add options to the select element
					data.broker_ip_result.forEach(function(filename) {
						var option = $("<option>", {
							value : filename,
							text : filename,
						});
						selectElement.append(option);
					});

				}
			},
			error : function(xhr, status, error) {
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

	/* $(document).ready(function() {

		// Load broker ip
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
	    	    } else {
	    	      alert("Tag Name and Value cannot be empty. Please fill in both fields.");
	    	    }
	    	  });
	    	  $("#addBtn").click(function () {
	    		 // convertTableDataToJSON();
	    		  tableToJson();
	    		  addAlarmConfig();
	    		  
	    		  /* $('#alarmConfigForm').submit(function(event) {
	    				event.preventDefault();
	    				var buttonText = $('#saveBtn').val();

	    				if (buttonText == 'save') {
	    					addAlarmConfig();
	    				}
	    			}); 

	      	   
	      	  });
	    	}); */
	    	
	    	
/* 	    	-----------------------------------------------------------------------
 */	    	
 
 
 
 function loadCommandSettings() {
		$.ajax({
			url : 'commandConfigEditServlet',
			type : 'GET',
			dataType : 'json',
			success : function(data) {
				// Clear existing table rows
				// Iterate through the user data and add rows to the table
				$.each(data,function(index, commandConfig) {
									
									var unit_id = commandConfig.unit_id;
									var asset_id = commandConfig.asset_id;
									var broker_type = commandConfig.broker_type;
									var broker_ip = commandConfig.broker_ip;
									var interval = commandConfig.interval;
									var command_tag = commandConfig.command_tag;
									
									var result = command_tag;

									$.each($.parseJSON(result), function(k, v) {
						//			    alert(k + ' and ' + v);
									    
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
										
	    	        					$("#table_data").append(newRow);
									});
									
									
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
									$('#broker_ip').val(broker_ip);
									$('#interval').val(interval);
									//$('#table_data').val(JSON.stringify(alarm_tag));
									
									
								});
			},
			error : function(xhr, status, error) {
				// Handle the error response, if needed
				console.log('Error: ' + error);
			}
		});
	
	} 
	    	
	    	function deleteCommand() {
	       		
	       		var confirmation = confirm('Are you sure you want to delete the command settings?');
	       		if (confirmation) {
	       			$.ajax({
	       				url : 'commandConfigDeleteServlet',
	       				type : 'GET',
	       				dataType : 'json',
	       				success : function(data) {
	       					// Display the registration status message
	       					alert(data.message);

	       					// Refresh the user list
	       					loadAlarmSettings();
	       				},
	       				error : function(xhr, status, error) {
	       					// Handle the error response, if needed
	       					console.log('Error deleting command settings: '
	       							+ error);
	       				}
	       			});
	       		}
	       	}
	    	
	    	 $(document).ready(function () {
	       	  // Load broker ip
	       	   loadCommandSettings();
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
	       	    } else {
	       	      alert("Tag Name and Value cannot be empty. Please fill in both fields.");
	       	    }
	       	  });
	       	  /* $("#addBtn").click(function () {
	       		 // convertTableDataToJSON();
	       		  tableToJson();
	       		addCommandConfig();
	       		  
	       	     	  }); */
	       	     	  
	       	     	  
	       	     	$('#commandConfigForm').submit(function(event) {
	       				event.preventDefault();
	       				var buttonText = $('#addBtn').val();

	       				if (buttonText == 'Add') {
	       					addCommandConfig();
	       				} else {
	       					editCommandConfig();
	       				}
	       			});
	       	  
	       	 $('#clearBtn').click(function(){
	    		  $('#unit_id').val('');
	  			$('#asset_id').val('');
	  			$('#broker_type').val('');
	  			$('#broker_name').val('');
	  			$('#interval').val('');
	    		  
	    	  
	    	});
	       	 
	       	$("#delBtn").click(function () {
	    		  deleteCommand();
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
		
		function editCommandConfig() {

			var tagData = tableToJson();
		//	alert('tag data : '+tagData)

		    var unit_id = $('#unit_id').val();
		    var asset_id = $('#asset_id').val();
		    var broker_type = $('#broker_type').find(":selected").val();
		    var broker_name = $('#broker_name').find(":selected").val();
		    var interval = $('#interval').find(":selected").val();
		    // Modify the next two lines to get the tag_name and variable from the JSON data
		   /*  var tag_name = Object.keys(tagData)[0];
		    var variable = tagData[tag_name]; */

			
			$.ajax({
				url : 'commandConfigEditServlet',
				type : 'POST',
				data : {
					unit_id : unit_id,
					asset_id : asset_id,
					broker_type : broker_type,
					broker_name : broker_name,
					interval : interval,
					//tagData: tagData
					tagData: JSON.stringify(tagData)
					/* tag_name : tag_name,
					variable : variable */
					
				},
				success : function(data) {
					// Display the registration status message
					alert(data.message);
			//		loadMqttList();

					// Clear form fields

					$('#unit_id').val('');
					$('#asset_id').val('');
					$('#broker_type').val('');
					$('#broker_name').val('');
					$('#interval').val('');
					/* $('#tag_name').val('');
					$('#variable').val(''); */
				},
				error : function(xhr, status, error) {
					console.log('Error updating command settings: ' + error);
				}
			});

			$('#addBtn').val('Add');
		}

		
		
		function addCommandConfig() {

			var tagData = tableToJson();
		//	alert('tag data : '+tagData)

		    var unit_id = $('#unit_id').val();
		    var asset_id = $('#asset_id').val();
		    var broker_type = $('#broker_type').find(":selected").val();
		    var broker_name = $('#broker_name').find(":selected").val();
		    var interval = $('#interval').find(":selected").val();
		    // Modify the next two lines to get the tag_name and variable from the JSON data
		   /*  var tag_name = Object.keys(tagData)[0];
		    var variable = tagData[tag_name]; */

			
			$.ajax({
				url : 'commandConfigServlet',
				type : 'POST',
				data : {
					unit_id : unit_id,
					asset_id : asset_id,
					broker_type : broker_type,
					broker_name : broker_name,
					interval : interval,
					tagData: JSON.stringify(tagData)
					//tagData: JSON.stringify(tagData)
					/* tag_name : tag_name,
					variable : variable */
					
				},
				success : function(data) {
					// Display the registration status message
					alert(data.message);
			//		loadMqttList();

					// Clear form fields

					$('#unit_id').val('');
					$('#asset_id').val('');
					$('#broker_type').val('');
					$('#broker_name').val('');
					$('#interval').val('');
					/* $('#tag_name').val('');
					$('#variable').val(''); */
				},
				error : function(xhr, status, error) {
					console.log('Error adding command config settings: ' + error);
				}
			});

			$('#addBtn').val('Add');
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
		<h3>COMMAND CONFIG SETTINGS</h3>
		<hr>
		<div class="container">
			<form id="commandConfigForm">
				<div class="row" style="display:flex; flex-content:space-between; margin-top: -20px;">
					<div class="col-75-1" style="width: 20%;">
						<input type="text" id="unit_id" name="unit_id"
							placeholder="Unit ID" required style="height: 17px;" />

					</div>
				<!-- </div>

				<div class="row"> -->
					<div class="col-75-2"
						style="width: 20%;">
						<input type="text" id="asset_id" name="asset_id"
							placeholder="Asset ID" required style="height: 17px;" />

					</div>
				<!-- </div>

				<div class="row"> -->
					<div class="col-75-3"
						style="width: 20%;">
						<select class="textBox" id="broker_type" name="broker_type"
							style="height: 35px;">
							<option value="">Select Broker Type</option>
							<option value="mqtt">mqtt</option>
							<option value="iothub">iothub</option>
						</select>
					</div>
				<!-- </div>

				<div class="row"> -->
					<div class="col-75-4"
						style="width: 20%;">
						<select class="textBox" id="broker_name" name="broker_name"
							style="height: 35px;">
							<option value=""></option>
						</select>
					</div>
				<!-- </div>

				<div class="row"> -->
					<div class="col-75-5"
						style="width: 20%;">
						<select class="interval-select" id="interval" name="interval"
							style="height: 35px;">
							<option value="">Select Interval</option>
							<option value="30 sec">30 sec</option>
							<option value="1 min">1 min</option>
							<option value="5 min">5 min</option>
							<option value="10 min">10 min</option>
							<option value="15 min">15 min</option>
							<option value="20 min">20 min</option>
							<option value="25 min">25 min</option>
							<option value="30 min">30 min</option>
							<option value="1 hour">1 hour</option>

						</select>
					</div>
				</div>

				<div class="row" style="display:flex; flex-content:space-between; margin-top: 10px;">
					<div class="col-75-6" style="width: 20%;">
						<input type="text" id="tag_name" name="tag_name"
							placeholder="Tag Name" style="height: 17px;" />

					</div>
				<!-- </div>

				<div class="row"> -->
					<div class="col-75-7"
						style="width: 20%;">
						<select class="textBox" id="variable" name="variable"
							style="height: 35px;">
							<option value=""></option>
						</select>
					</div>
				</div>
				
				<div class="row"><input style="margin-top: -31px; margin-left:-50px " type="button"
						value="Plus" id="saveBtn" /> </div>
						
				<div class="row" style="display:flex;justify-content:right;">					
						<input
						style="margin-top: -31px;margin-left:5px" type="button"
						value="Clear" id="clearBtn" /> <input
						style="margin-top: -31px;margin-left:5px" type="submit"
						value="Add" id="addBtn" onClick="window.location.reload();"/>
						<input
						style="margin-top: -31px;margin-left:5px" type="button"
						value="Delete" id="delBtn" onClick="window.location.reload();"/> 
				</div>

				<!-- <div class="row">
					<input style="margin-top: -31px; margin-left: 10%;" type="button"
							value="Save" id="saveBtn" />
						<input style="margin-top: -31px; margin-left: 85%;" type="button"
							value="Clear" id="clearBtn" /> 
							<input
						style="margin-top: -31px; margin-left: 75.2%;" type="button"
						value="Delete" id="delBtn" />
						<input style="margin-top: -31px" type="submit"
						value="Add" id="addBtn" />
				</div> -->

			</form>
		</div>
		</section>
		
		<section style="margin-left: 1em">
		<div class="container">
			<table id="table_data">
				<tr>
					<th>Tag Name</th>
					<th>Variable</th>
					<th>Action</th>
				</tr>
			</table>
		</div>
		</section>
	</div>
	<div class="footer">
		<%@ include file="footer.jsp"%>
	</div>
</body>
</html>