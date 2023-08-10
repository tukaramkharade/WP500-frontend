
<%-- <!DOCTYPE html>
<head>
    
    <title>Login</title>
    <link rel="stylesheet" href="nav-bar.css" />
    <!-- <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            background-image: url("images/background.jpg");
            background-repeat: no-repeat;
            background-size: cover;
        }
        
        .container {
            max-width: 400px;
            margin-top: 18%;
            margin-left:35%;
            padding: 20px;
            background-color: #cdd1ef;           
            border-radius: 5px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.3);
        }
        
        h1 {
            text-align: center;
            color: #f7f4f4;
            margin-top: 150px;
        }
        
        .error-message {
            color: red;
        }
        
        label {
            display: block;
            margin-bottom: 10px;
            color: #000209;
        }
        
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        
        input[type="submit"] {
            width: 100%;
            padding: 10px;
            background-color: #6c45ed;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            margin-bottom: 15px;

        }
        
        input[type="submit"]:hover {
            background-color: #6b13ee;
            
        }
        img{
            margin-left: 35%;
            margin-bottom: 20px;
            height: 50px;
        }
        /* @media screen and (max-width:600px) {
            .container{
                max-width: 200px;
            margin-top: 25%;
            margin-left:50%;
            }
            
        } */
       
    </style> -->
</head>
<body style="background-color: #2e3891d4;">
    
     <!-- Display error message if there is an error parameter in the URL
    <% if (request.getParameter("error") != null) { %>
        <p style="color: red;">Invalid username or password.</p>
    <% } %>  -->
    
    <form action="WP500Login" method="post" class="container" style="width: 24em; border-radius: 30px; margin-left: 37em;margin-top: 12em; background-color: #ffffff8f;padding-bottom: 30px;">
        <div>
            <img src="images/tasm2m.png" alt="Tasm2mLogo" style="width: 78%; float: center;"/>
        </div>
            <label for="username" style="float: left;">Username:</label>
        <input type="text" id="username" name="username" required><br>
        
        <label for="password" style="float: left;">Password:</label>
        <input type="password" id="password" name="password" required><br><br>
      
        <input style="padding: 5px 140px;font-size:medium" type="submit" value="Login">
    </form>
   
</body>
</html> --%>



<!-- ------------------------------------------------------------------------------------------ -->


<!DOCTYPE html>
<head>
    
   <title>WP500 Web Configuration</title>
<link rel="icon" type="image/png" sizes="32x32" href="favicon.png" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css" />
<link href="https://fonts.googleapis.com/css?family=Lato:400,300,700"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css" />
<link rel="stylesheet" href="nav-bar.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #2e3891d4;
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
            padding: 5px;
            margin-bottom: 10px;
        }
        
        .container input[type="submit"] {
            padding: 5px 140px;
            font-size: medium;
        }
    </style>       
       
</head>
<body style="background-color: #2e3891d4;">
    
     <!-- <%-- Display error message if there is an error parameter in the URL --%>
    <% if (request.getParameter("error") != null) { %>
        <p style="color: red;">Invalid username or password.</p>
    <% } %>  -->
    
    <form action="WP500Login" method="post" class="container" style="width: 24em; border-radius: 30px; background-color: #ffffff8f;padding-bottom: 30px;">
        <div>
            <img src="images/tasm2m.png" alt="Tasm2mLogo" style="width: 78%; float: center;"/>
        </div>
            <label for="username" style="float: left;">Username:</label>
        <input type="text" id="username" name="username" required><br>
        
        <label for="password" style="float: left;">Password:</label>
        <input type="password" id="password" name="password" required><br><br>
      
        <input style="padding: 5px 140px;font-size:medium" type="submit" value="Login">
    </form>
   
</body>
</html>