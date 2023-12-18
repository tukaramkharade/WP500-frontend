<!DOCTYPE html>
<html>
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32"
	href="images/WP_Connex_logo_favicon.png" />
	
<link rel="stylesheet" href="css_files/ionicons.min.css">
<link rel="stylesheet" href="css_files/normalize.min.css">
<link rel="stylesheet" href="css_files/fonts.txt" type="text/css">	
 <link rel="stylesheet" href="css_files/all.min.css">
<link rel="stylesheet" href="css_files/fontawesome.min.css">

<script src="jquery-3.6.0.min.js"></script>
<style>
h3 {
	margin-top: 70px;
}

.toggle-redundancy {
  position: relative;
  display: block;
  width: 49px;
  height: 20px;
  padding: 3px;
  border-radius: 50px;
  cursor: pointer;
  font-size: small;
  
}

.toggle-input-redundancy {
  position: absolute;
  top: 0;
  left: 0;
  opacity: 0;
}

.toggle-label-redundancy {
  position: relative;
  display: block;
  height: inherit;
  font-size: small;
  background: red;
  border-radius: inherit;
  box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.12), inset 0 0 3px rgba(0, 0, 0, 0.15);
}

.toggle-label-redundancy:before,
.toggle-label-redundancy:after {
  position: absolute;
  top: 158%;
  color: black;
  margin-top: -.5em;
  line-height: 1;
}

.toggle-label-redundancy:before {
  content: attr(data-off);
  right: 5px;
  color: black;
  text-shadow: 0 1px rgba(255, 255, 255, 0.5);
  font-size: small;
}

.toggle-label-redundancy:after {
  content: attr(data-on);
  left: 7px;
  color: black;
  text-shadow: 0 1px rgba(0, 0, 0, 0.2);
  opacity: 0;
  font-size: small;
}

.toggle-input-redundancy:checked~.toggle-label-redundancy {
  background: green;
}

.toggle-input-redundancy:checked~.toggle-label-redundancy:before {
  opacity: 0;
}

.toggle-input-redundancy:checked~.toggle-label-redundancy:after {
  opacity: 1;
}

.toggle-handle-redundancy {
	position: absolute;
    top: 4px;
    left: 3px;
    width: 19px;
    height: 18px;
    background: linear-gradient(to bottom, #FFFFFF 40%, #f0f0f0);
    border-radius: 50%;
}

.toggle-handle-redundancy:before {
  position: absolute;
  top: 50%;
  left: 50%;
  margin: -6px 0 0 -6px;
  width: 10px;
  height: 10px;
}

.toggle-input-redundancy:checked~.toggle-handle-redundancy {
  left: 33px;
  box-shadow: -1px 1px 5px rgba(0, 0, 0, 0.2);
}

/* Transition*/
.toggle-label-redundancy,
.toggle-handle-redundancy {
  transition: All 0.3s ease;
  -webkit-transition: All 0.3s ease;
  -moz-transition: All 0.3s ease;
  -o-transition: All 0.3s ease;
}

.container {
	margin: 0 auto;
	max-width: 40%;
}


</style>

<script>

</script>

<body>

<div class="sidebar">
		<%@ include file="common.jsp"%>
	</div>
	<div class="header">
		<%@ include file="header.jsp"%>
	</div>
	
	<div class="content">
		<section style="margin-left: 1em">
			<h3>REDUNDANCY SETTINGS</h3>
			<hr>
			<div class="container">
			
			<form id="redundancySettingsForm">
			<table class="bordered-table" style="margin-top: -1px;">
			
			
			<tr>
							<td style="height: 50px;">Redundancy enable</td>
							<td><label class="toggle-redundancy"> <input
									id="toggle_redundancy_enable" name="toggle_redundancy_enable"
									class="toggle-input-redundancy" type="checkbox"> <span
									class="toggle-label-redundancy" data-off="Disable" data-on="Enable"></span> <span
									class="toggle-handle-redundancy"></span>
							</label></td>
							</tr>
							
							<tr>
							<td style="height: 50px;">Redundancy role</td>
							<td><label class="toggle-redundancy"> <input
									id="toggle_redundancy_role" name="toggle_redundancy_role"
									class="toggle-input-redundancy" type="checkbox"> <span
									class="toggle-label-redundancy" data-off="Secondary" data-on="Primary"></span> <span
									class="toggle-handle-redundancy"></span>
							</label></td>
							
							</tr>
							
							<tr>
							
							<td>Partner IP</td>
							<td>
							<input id="partner_ip" class="config" type='text' name="partner_ip" style="width: 42%;" required>
							</td></tr>
							
							<tr>
							<td>Common IP 0</td>
							<td>
							<input id="common_ip_0" class="config" type='text' name="common_ip_0" style="width: 42%;" required>
							</td></tr>
							
							<tr>
							<td>Common Subnet 0</td>
							<td>
							<input id="common_subnet_0" class="config" type='text' name="common_subnet_0" style="width: 42%;" required>
							</td></tr>
							
							<tr>
							<td>Common IP 1</td>
							<td><input id="common_ip_1" class="config" type='text' name="common_ip_1" style="width: 42%;" required></td></tr>
							
							<tr>
							<td>Common Subnet 1</td>
							<td><input id="common_subnet_1" class="config" type='text' name="common_subnet_1" style="width: 42%;" required></td></tr>
							
							<tr>
							<td>Common IP 2</td>
							<td><input id="common_ip_2" class="config" type='text' name="common_ip_2" style="width: 42%;" required></td></tr>
							
							<tr>
							<td>Common Subnet 1</td>
							<td><input id="common_subnet_2" class="config" type='text' name="common_subnet_2" style="width: 42%;" required></td></tr>
							
							
							
							<tr><td></td></tr>
							
							
			</table>
			
			</form>
			</div>
			</section>
			</div>

</body>
</html>