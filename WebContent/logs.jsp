<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Logs</title>
<link rel="stylesheet" type="text/css" href="user_styles.css" />
<%@ include file="header.jsp"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	function loadLogFileList() {
		$.ajax({
			url : "logs",
			type : "GET",
			dataType : "json",
			success : function(data) {

				
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

	});
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
	</div>

	<div class="content">
		<h2>Logs</h2>
		<select id="log_file">
			<option value="">Select Log File First</option>
		</select>
	</div>

	<%@ include file="footer.jsp"%>
</body>
</html>