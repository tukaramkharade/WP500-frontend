<%-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<head>
    
    <title>Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
        }
        
        .container {
            max-width: 400px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.3);
        }
        
        h1 {
            text-align: center;
            color: #333;
        }
        
        .error-message {
            color: red;
        }
        
        label {
            display: block;
            margin-bottom: 10px;
            color: #666;
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
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
        }
        
        input[type="submit"]:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <h1>Login Page</h1>
    
    Display error message if there is an error parameter in the URL
    <% if (request.getParameter("error") != null) { %>
        <p style="color: red;">Invalid username or password.</p>
    <% } %>
    
    <form action="WP500Login" method="post">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required><br><br>
        
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br><br>
        
        <input type="submit" value="Login">
    </form>
</body>
</html>
 --%>
 
 
<!--  ----------------------------------------------------------------------------------------------------------------------------------------- -->

<!-- <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%> -->
<!DOCTYPE html>
<head>
    
    <title>Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            background-image: url("images/background.jpg");
            background-repeat: no-repeat;
            background-size: cover;
        }
        
        .container {
            max-width: 400px;
            margin-top: 150px;
            margin-left:530px;
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
       
    </style>
</head>
<body >
    
    <!-- <%-- Display error message if there is an error parameter in the URL --%>
    <% if (request.getParameter("error") != null) { %>
        <p style="color: red;">Invalid username or password.</p>
    <% } %> -->
    
    <form action="WP500Login" method="post" class="container">
        <img src="images/tasLogo.jpg" alt="Tasm2mLogo"/>
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required><br><br>
        
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br><br>
      
        <input type="submit" value="Login">
    </form>
   
</body>
</html>