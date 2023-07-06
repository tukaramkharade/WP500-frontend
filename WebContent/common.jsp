<!-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%> -->
<!DOCTYPE html>
<head>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" />

<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<style>
@charset "ISO-8859-1";
/* Global styles */
 body {
      font-family: Arial, sans-serif;
      margin: 0;
     
    }

    .container {
      display: flex;
    }

 

    .menu {
      list-style-type: none;
      padding: 0;
      margin: 0;
    }

    .menu li {
      position: relative;
    }

    .menu a {
      display: block;
      padding: 10px 20px;
      color: #333;
      text-decoration: none;
    }

    .menu a:hover {
      background-color: #ccc;
    }

    .submenu {
      display: none;
      position: absolute;
      top: 0;
      left: 100%;
      background-color: #f1f1f1;
      width: 200px;
    }

    .menu li:hover .submenu {
      display: block;
    }

    .submenu li {
      position: relative;
    }

    .submenu a {
      padding: 8px 16px;
      color: #333;
    }

    .submenu a:hover {
      background-color: #ccc;
    }

    :root {
      --blue: #2a2185;
      --white: #fff;
      --grey: #f5f5f5;
      --black1: #222;
      --black2: #999;
    }
  
    .container {
      width: 100%;
      position: relative;
    }
    .navigation {
      position: fixed;
      width: 17%;
      height: 100%;
    
      background: var(--blue);
    }

    .navigation ul li a {
      position: relative;
      width: 80%;
      display: flex;
      text-decoration: none;
      color: var(--white);
      display: block;
    }

    .navigation .menu ul li a {
      color: var(--blue);
    }
    .navigation .menu ul li a:hover {
      background-color: var(--blue);
      color: var(--white);
      width: auto;
    }
    .navigation .menu li a {
    
      position: relative;
      display: flex;
      align-items: center;
     
    }
    .navigation .menu li a .icon {
      width: 50px;
    }
    .navigation .menu li a .title {
      justify-content: left;
      width: 200px;
      padding: 0 10px;
    
    }
</style>
</head>
<body>
	<div class="container">
		<div class="navigation">
			<ul class="menu">
				<li><a href="overview.jsp"> <span class="icon"><i
							class="fa fa-file"></i></span> <span class="title">OVERVIEW</span></a></li>
				<li><a href="#"> <span class="icon"><i
							class="fa fa-info"></i></span> <span class="title">STATUS </span></a>
					<ul class="submenu">
						<li><a href="#">LOGS</a></li>
					</ul></li>
				<li><a href="#"> <span class="icon"><i
							class="fa fa-wifi"></i></span> <span class="title">LAN SETTINGS</span>
				</a>
					<ul class="submenu">
						<li><a href="lan.jsp">LAN</a></li>
					</ul></li>
				<li><a href="#"> <span class="icon"><i
							class="fa fa-link"></i></span> <span class="title">SERVICES</span></a>
					<ul class="submenu">
						<li><a href="firewall.jsp">FIREWALL</a></li>
						<li><a href="#">WEB SERVICES</a></li>
					</ul></li>
				<li><a href="#"> <span class="icon"><i
							class="fa fa-code"></i></span> <span class="title">STRATON</span></a>
					<ul class="submenu">
						<li><a href="#">APPLICATION</a></li>
						<li><a href="#">QUICK CLIENT</a></li>
					</ul></li>
				<li><a href="#"> <span class="icon"><i
							class="fa fa-dollar-sign"></i></span> <span class="title">ADMINISTRATION</span></a>
					<ul class="submenu">
						<li><a href="user.jsp">USER SETTINGS</a></li>
						<li><a href="#">FIRMWARE</a></li>
						<li><a href="#">LICENSE</a></li>
						<li><a href="#">BACKUP</a></li>
						<li><a href="#">REBOOT</a></li>
						<li><a href="#">CERTIFICATES</a></li>
					</ul></li>

				<li><a href="#"> <span class="icon"><i
							class="fa fa-user"></i></span> <span class="title">Contact</span></a></li>
			</ul>
		</div>
	</div>
</body>