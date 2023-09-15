<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>WPConnex Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="images/WP_Connex_logo_favicon.png" />
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

<style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        
        .container {
            width: 24em;
            border-radius: 30px;
            background-color: #ffffff8f;
            padding-bottom: 30px;
            text-align: center;
        }
        
        .container img {
            width: 78%;
        }
        
        .container label {
            display: block;
            text-align: left;
        }
        
        .container input[type="text"],
        .container input[type="password"] {
            width: 100%;
            padding: 5px 0;
            margin-bottom: 10px;
        }
        
        .container input[type="submit"] {
            padding: 5px 140px;
            font-size: medium;
        }
    </style>

<script type="text/javascript"></script>
</head>
<body>

<form class="container">

<p style="font-size: medium;">Please change your old password</p>

		<label for="username" style="float: left;">Username:</label>
        <input required type="text" id="username" name="username" ><br>
        
        <label for="old_password" style="float: left;">Old password:</label>
        <input required type="password" id="old_password" name="old_password" >
        
        <label for="new_password" style="float: left;">New password:</label>
        <input required type="password" id="new_password" name="new_password" >
        
        <input font-size: medium" type="submit" value="Submit" id="change_password">

</form>

</body>
</html>