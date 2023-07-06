<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<title>Overview</title>
<link rel="stylesheet" type="text/css" href="user_styles.css">
</head>
<body>
	<header>
 <div style="width: 100%;height:10%;background-color: #f1f2f6;">
	<img src="images/tasLogo.jpg" style="height: 40px; width: 80px; margin-left: 5px;margin-top: 5px;background-color: #f1f2f6;">
    </div>	</header>
	<div class="container">
		<div class="sidebar">
			<%@ include file="common.jsp"%>
		</div>

		<div class="content">
			<h2>Overview</h2>
			<img src="image001.png" width="300" height="300">

			<div class="general-data-table">
				<table>
					<tr>
						<th colspan=2>General Data</th>
					</tr>

					<tr>
						<td>Vendor</td>
						<td>TAS</td>
					</tr>

					<tr>
						<td>Address</td>
						<td>INDIA</td>
					</tr>

					<tr>
						<td>Internet</td>
						<td>http://www.tasm2m.com</td>
					</tr>

					<tr>
						<td>Type</td>
						<td>AXC F 2152</td>
					</tr>

					<tr>
						<td>Order No.</td>
						<td>2404267</td>
					</tr>

					<tr>
						<td>Serial No.</td>
						<td>1364211569</td>
					</tr>

					<tr>
						<td>Firmware Version</td>
						<td>2022.6.0(22.6.0.43)</td>
					</tr>

					<tr>
						<td>Hardware Version</td>
						<td>02</td>
					</tr>

					<tr>
						<td>FPGA Version</td>
						<td>1.1.80</td>
					</tr>

				</table>
			</div>
		</div>
	</div>
<%@ include file="footer.jsp" %>
</body>
</html>
