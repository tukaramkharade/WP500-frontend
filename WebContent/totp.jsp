<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Insert title here</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
    var secretKey;
        // Function to make an Ajax request
        function getImageAndSecretKey() {
            $.ajax({
                type: "GET",
                url: "imageServlet", // URL of your servlet               
                success: function (data) {
                    // Handle the response data (data.qr_image and data.secret_key)
                    if (data.qr_image && data.secret_key) {
                    	secretKey = data.secret_key;
                        // You can use data.qr_image and data.secret_key here
                        displayQRImage(data.qr_image);
                        console.log("QR Image: " + data.qr_image);
                        console.log("Secret Key: " + data.secret_key);
                        // Update your HTML elements with the data if needed
                    } else {
                        // Handle the case where the response does not contain the expected data
                        console.error("Invalid response data");
                    }
                },
                error: function () {
                    // Handle errors here
                    console.error("Ajax request failed");
                }
            });
        }
        function displayQRImage(base64Image) {
            // Create an img element
            var imgElement = document.createElement("img");

            // Set the src attribute with the base64 image data
            imgElement.src = "data:image/png;base64," + base64Image; // Assuming the image is in PNG format

            // Append the image to a container element in your HTML (e.g., a <div>)
            var container = document.getElementById("imageContainer"); // Replace "imageContainer" with the ID of your container element
            container.appendChild(imgElement);
        }
        function sendOTP() {
            // Get the OTP value from the input field
            var otpValue = document.getElementById("otp").value;
            console.log("OTP -->"+otpValue);
            $.ajax({
    			url : "imageServlet",
    			type : "POST",
    			data : {
    				otp: otpValue,
    				secretKey: secretKey    				
    			},
                success: function (response) {
                    // Handle the response from the server, if needed
                    console.log("OTP -->"+response.otp_result);
                },
                error: function () {
                    // Handle errors here
                    console.error("Ajax request failed");
                }
            });
        }
    </script>
</head>
<body>
    <!-- Button to trigger the Ajax request -->
    <button onclick="getImageAndSecretKey()">Get Image and Secret Key</button>
    <div id="imageContainer"></div>
    <input type="text" id="otp" placeholder="Enter OTP">
    
    <button onclick="sendOTP()">Send OTP</button>
</body>
</html>
