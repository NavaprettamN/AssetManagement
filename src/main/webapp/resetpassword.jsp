<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Password Recovery</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Custom CSS to match the style */
        body {
            background-color: #f4f7fc;
            font-family: Arial, sans-serif;
        }
        #countDown {
		    color: red;
		    font-weight: bold;
		    font-size: 1.2rem; /* Adjust size as needed */
		    text-align: center; /* Center align the timer if needed */
		}
        .container {
            max-width: 400px;
            margin-top: 80px;
            padding: 30px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .logo {
            text-align: center;
            margin-bottom: 20px;
        }
        .logo img {
            width: 100px;
        }
        .logo h1 {
            font-size: 1.5rem;
            color: #6e1d76;
            font-weight: bold;
            margin: 0;
        }
        .logo p {
            font-size: 0.9rem;
            color: #a08ca8;
        }
        .form-group label {
            font-weight: 500;
            color: #6e1d76;
        }
        .btn-primary {
            background-color: #4a5de8;
            border: none;
            width: 100%;
            font-size: 1rem;
            padding: 10px;
            border-radius: 5px;
        }
        .btn-primary:hover {
            background-color: #374bdb;
        }
        #message {
            color: red;
            margin-top: 10px;
            text-align: center;
        }
    </style>
</head>
<body>

<div class="container text-center">
    <div class="logo">
        <img src="images/eds-logo.png" alt="Company Logo">
        <h1>EDS</h1>
        <p>Asset Management</p>
    </div>
    <h4 class="mb-4">Recover</h4>
    <div id="sendOtpForm">
        <div class="form-group text-left">
            <label for="empId">Employee ID</label>
            <input type="text" class="form-control" id="empId" name="empId" placeholder="Enter Your Employee ID">
        </div>
        <button type="button" class="btn btn-primary" id="generateOtp">Send OTP</button>
    </div>

    <div id="generateOtpForm" style="display: none;">
        <div class="form-group text-left">
            <label for="otp">Enter the OTP</label>
            <input type="text" class="form-control" id="otp" name="otp" placeholder="Enter OTP">
        </div>
        <button type="button" class="btn btn-primary" id="verifyOtp">Verify OTP</button>
        <p id="countDown"></p>
    </div>

    <div id="newPassword" style="display: none;">
        <div class="form-group text-left">
            <label for="password">Enter New Password</label>
            <input type="password" class="form-control" id="password" name="password" placeholder="New Password">
        </div>
        <div class="form-group text-left">
            <label for="confirmPassword">Re-Enter Password</label>
            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Confirm Password">
        </div>
        <button type="button" class="btn btn-primary" id="newPasswordButton">Confirm</button>
    </div>

    <p id="message"></p>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
    function start(){
        $("#message").hide();
        $("#generateOtpForm").hide();
        $("#newPassword").hide();
    }
    
    start();
    
    $(document).ready(function() {
        $("#generateOtp").on("click", function() {
            var empId = $("#empId").val();
            $.ajax({
                url: "ResetPasswordOtpServlet",
                type: "POST",
                data: {empId: empId},
                success: function(response) {
                    if(response.status === "success") {
                        $("#sendOtpForm").show();
                        $("#generateOtpForm").show();
                        $("#message").text("Otp is sent to Mail Id " + response.message + "*******@****.com").show();
	                    $("#generateOtp").attr("disabled", true);
                        var otpExpiration = Date.now() + 1 * 60 * 1000;
                        startCountdown(otpExpiration);	
                    }
                    else if(response.status === "error") {
                        $("#message").text(response.message).show();
                    }
                }
            });
        });
        
        function startCountdown(otpExpiration) {
            const countdownElement = $("#countDown");
            const interval = setInterval(() => {
                const remainingTime = otpExpiration - Date.now();
 
                if (remainingTime > 0) {
                    const minutes = Math.floor(remainingTime / (1000 * 60));
                    const seconds = Math.floor((remainingTime % (1000 * 60)) / 1000);
                    countdownElement.text("OTP expires in " + minutes + "m " + seconds + "s");
                } else {
                    clearInterval(interval);
                    
                    countdownElement.text("OTP has expired. Please request a new OTP.");
                    start();
                    // Disable the Verify OTP button
                    $("#generateOtp").attr("disabled", false);
                    $("#otpDiv").hide();
 
                    start();
                    
                    $("#generateOtp").text("Resend OTP");
                }
            }, 1000);
        }
        
        $("#verifyOtp").on("click", function() {
            var empId = $("#empId").val();
            var otp = $("#otp").val();
            console.log("clicked");
            $.ajax({
                url: "ResetPasswordOtpVerifyServlet",
                type: "POST",
                data: {empId: empId, otp: otp},
                success: function(response) {
                	console.log(response);
                    if(response.status === "success") {
                        $("#message").hide();
                        $("#newPassword").show();
                        $("#sendOtpForm").hide();
                        $("#generateOtpForm").hide();
                    }
                    else if(response.status === "error") {
                    	console.log("Error msg");
                        $("#message").text(response.message).show();
                    }
                },
                error: function(xhr,status,error) {
                	console.log("error");
                	
                }
            });
        });
        
        $("#newPasswordButton").on("click", function() {
            var empId = $("#empId").val();
            var password = $("#password").val();
            var confirmPassword = $("#confirmPassword").val();
            
            $.ajax({
                url: "resetpassword",
                type: "POST",
                data: {empId: empId, password: password, confirmPassword: confirmPassword},
                success: function(response) {
                    if(response.status === "success")
                        window.location.href = response.redirect;
                    else {
                        $("#message").text(response.message).show();
                        $("#message").text(response.message).show();
                    }
                },
                error: function(xhr, status, error) {
                    console.log(error);
                }
            });
        });
    });
</script>

</body>
</html>
