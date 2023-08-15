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

<style type="text/css">
.switch {
	position: relative;
	display: inline-block;
	width: 50px;
	height: 14px;
}

.switch input {
	opacity: 0;
	width: 0;
	height: 0;
}

.slider {
	position: absolute;
	cursor: pointer;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-color: #ccc;
	-webkit-transition: .4s;
	transition: .4s;
}

.slider:before {
	position: absolute;
	content: "";
	height: 27px;
	width: 26px;
	left: 6.3px;
	bottom: 2px;
	background-color: white;
	-webkit-transition: .4s;
	transition: .4s;
}

input:checked+.slider {
	background-color: #2196F3;
}

input:focus+.slider {
	box-shadow: 0 0 1px #2196F3;
}

input:checked+.slider:before {
	-webkit-transform: translateX(26px);
	-ms-transform: translateX(26px);
	transform: translateX(26px);
}

/* Rounded sliders */
.slider.round {
	border-radius: 54px;
}

.slider.round:before {
	border-radius: 50%;
}
</style>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>

function validateInput(input) {
	var inputError = document.getElementById("inputError");

	if (input == 'Select input'){
		
		inputError.textContent = "Please select input";
		return false;
	} else {
		inputError.textContent = "";
		return true;
	}
}

function validateOutput(output) {
	var outputError = document.getElementById("outputError");

	if (output == 'Select output'){
		
		outputError.textContent = "Please select output";
		return false;
	} else {
		outputError.textContent = "";
		return true;
	}
}

function validateForward(forward) {
	var forwardError = document.getElementById("forwardError");

	if (forward == 'Select forward'){
		
		forwardError.textContent = "Please select forward";
		return false;
	} else {
		forwardError.textContent = "";
		return true;
	}
}


$(document).ready(function() {
	$('#generalSettingsForm')
	.submit(
			function(event) {
				event.preventDefault();
				
				var input = $('#input').find(":selected").val();
				var output = $('#output').find(":selected").val();
				var forward = $('#forward').find(":selected").val();
				
				if (!validateInput(input)) {
					inputError.textContent = "Please select input";
					return;
				}

				if (!validateOutput(output)) {
					outputError.textContent = "Please select output";
					return;
				}
				
				if (!validateForward(forward)) {
					forwardError.textContent = "Please select forward";
					return;
				}
				
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
		<h3>GENERAL SETTINGS</h3>
		<hr>
		
		<div class="container">
			<form id="generalSettingsForm" method="post">
			
			<div class="row"
					style="display: flex; flex-content: space-between; margin-top: 10px;">
					
					<div class="col-75-2" style="width: 20%;">
						<select class="textBox" id="input" name="input"
								style="height: 35px;">
								<option value="Select input">Select input</option>
								<option>Accept</option>
								<option>Reject</option>
							</select>
							
							<span id="inputError" style="color:red;"></span>
					</div>
					<div class="col-75-2" style="width: 20%;">
						<select class="textBox" id="output" name="output"
								style="height: 35px;">
								<option value="Select output">Select output</option>
								<option>Accept</option>
								<option>Reject</option>
							</select>
							
							<span id="outputError" style="color:red;"></span>
					</div>
					<div class="col-75-2" style="width: 20%;">
						<select class="textBox" id="forward" name="forward"
								style="height: 35px;">
								<option value="Select forward">Select forward</option>
								<option>Accept</option>
								<option>Reject</option>
							</select>
							
							<span id="forwardError" style="color:red;"></span>
					</div>
					</div>
					
					<div class="row">
					<div
						style="width: 40%; margin-top: 30px; display: flex; justify-content: left;">

						<label for="enable">Drop invalid packets</label> <label class="switch">
							<input type="checkbox" checked> <span
							class="slider round"></span>
						</label>

					</div>

				</div>
				
			</form>
			</div>
		</section>
		</div>

</body>
</html>