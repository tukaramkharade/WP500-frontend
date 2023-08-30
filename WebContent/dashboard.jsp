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
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

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
width: 540px;
    height: 200px;
    color: black;
    font-size: 12px;
    margin-left: 15px;
     /* Border properties */
    border: 2px solid #e74c3c; /* Border width, style, and color */
    border-radius: 10px; /* Border radius for rounded corners */
   
}

#itemList{
list-style: none;
}


</style>
<script>

$(document).ready(function() {
    $.ajax({
        url: "getList",
        type: "GET",
        dataType: "json",
        success: function(data) {
            var listItems = '';
            $.each(data, function(index, item) {
                listItems += '<li>' + item + '</li>';
            });
            $('#itemList').html(listItems);
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
		<h3>CYBERGUARD DASHBOARD</h3>
		<hr />
		
		<div class="container">
		
		<div class="row"
					style="display: flex; flex-content: space-between; margin-top: -15px;">
						<input type="button" value="Today" id="today"/> 
						<input style="margin-left: 5px" type="button" value="Yesterday" id="yesterday" /> 
						<input style="margin-left: 5px" type="button" value="Week" id="week" />
						<input style="margin-left: 5px" type="button" value="Month" id="month" />
						<input style="margin-left: 25px; width: 13%;" type="button" value="Custom" id="custom" />
						<label style="margin-left: 5px;">From</label><input style="margin-left: 3px" type="datetime-local" id="fromdate" name="fromdate" />
						<label style="margin-left: 5px;">To</label><input style="margin-left: 3px" type="datetime-local" id="todate" name="todate" />
						<input style="margin-left: 15px" type="button" value="Apply" id="apply" />					
				</div>
				
				<div class="row"
					style="display: flex; flex-content: space-between; margin-top: 10px;">
					
					
					<div class="overview">
						<h5>Overview</h5>
						<p>System Status : Running</p>
						<p>Last Update : </p>
						<p>Active threat count : </p>
						<p>Total threat : </p>
						<p>Total acknowledged threat : </p>
						<p>Total unacknowledged threats : </p>
					</div>
					
					<div class="last_threats">
						<h5>Last Threats</h5>
						<ul id="itemList">
        					<!-- List items will be populated here -->
    					</ul>
						<input style="margin-left: 460px; margin-top: 70px;" type="button" value="Show all" id="show_all" /> 
						
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