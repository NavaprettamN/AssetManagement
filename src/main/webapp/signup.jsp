<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <title>Signup</title>
    <style>
        /* Custom CSS */
        body, html {
		    overflow: hidden;
		}

		/* After the animation, allow scrolling */
		body.slide-in, html.slide-in {
		    overflow: auto;
		}
		
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f7fa;
        }
        .container-fluid {
            display: flex;
            height: 100vh;
        }
        /* Left Signup Panel */
        .left-pane {
            background-color: #ffffff;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            width: 30%;
            box-shadow: 4px 0 12px rgba(0, 0, 0, 0.1);
        }
        #countDown {
		    color: red;
		    font-weight: bold;
		    font-size: 1.2rem; /* Adjust size as needed */
		    text-align: center; /* Center align the timer if needed */
		}
        .left-pane img {
            width: 120px;
            margin-bottom: 1rem;
        }
        .left-pane h2 {
            font-size: 2rem;
            font-weight: bold;
        }
        .form-label {
            font-weight: 600;
            color: #555;
        }
        .btn-primary {
            background-color: #3B82F6;
            border: none;
        }
        .btn-primary:hover {
            background-color: #2563EB;
        }
        #message {
            color: red;
            font-weight: bold;
            margin-top: 1rem;
            display: none;
        }
        /* Right Branding Panel */
        .right-pane {
            background-color: #f5f7fa;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            width: 70%;
            text-align: center;
        }
        .right-pane h2 {
            font-size: 2rem;
            font-weight: bold;
            color: #333;
        }
        .right-pane p {
            font-size: 1.2rem;
            color: #666;
        }
        .illustration {
            max-width: 70%;
            margin-top: 2rem;
        }
        /* Slide up animation */
@keyframes slide-up {
    from {
        transform: translateY(0%);
        opacity: 1;
    }
    to {
        transform: translateY(-100%);
        opacity: 0;
    }
}

/* Slide in animation */
@keyframes slide-in {
    from {
        transform: translateY(100%);
        opacity: 0;
    }
    to {
        transform: translateY(0%);
        opacity: 1;
    }
}

.slide-up {
    animation: slide-up 1s forwards;
}

.slide-in {
    animation: slide-in 1s forwards;
}
    </style>
</head>
<body>
	
<div id="page-content" class="container-fluid slide-in">
        <div class="left-pane">
            <img src="images/eds-logo.png" alt="EDS Logo">
            <h2 class="mb-4">Sign Up</h2>

            <!-- OTP Form -->
            <form id="sendOtpForm" class="w-100">
                <div class="mb-3">
                    <label for="empId" class="form-label">Employee ID</label>
                    <input type="text" class="form-control" name="empId" id="empId" placeholder="Enter Your Employee ID" required>
                </div>
                
                <div class="mb-3">
                    <label for="empMail" class="form-label">Email<span id="requiredStar" class="text-danger">*</span></label>
                    <input type="email" class="form-control" name="empMail" id="empMail" placeholder="Enter Your Employee Email ID" required>
                </div>
                
                <button id="generateOtp" class="btn btn-primary w-100 mb-3" type="button">Generate OTP</button>
                
                <div id="otpDiv" class="mb-3" style="display: none;">
                    <label for="otp" class="form-label">OTP<span id="requiredStar" class="text-danger">*</span></label>
                    <input type="text" class="form-control" name="otp" id="otp" placeholder="Enter the OTP" required>
                    <button type="button" class="btn btn-primary w-100 mt-2" id="otpButton">Validate</button>
                </div>
                <p id="countDown"></p>
            </form>

            <!-- Create Account Form -->
            <form id="createAccountForm" class="w-100" style="display: none;" enctype="multipart/form-data">
                <div class="mb-3">
                    <label for="username" class="form-label">Employee Username<span id="requiredStar" class="text-danger">*</span></label>
                    <input type="text" class="form-control" name="username" id="username" placeholder="Enter username" required>
                </div>
                
                <div class="mb-3">
                    <label for="password" class="form-label">Password<span id="requiredStar" class="text-danger">*</span></label>
                    <input type="password" class="form-control" name="password" id="password" placeholder="Enter your password" required>
               		<span id="passwordError" class="text-danger" style="font-size: 0.9rem;"></span>
               		
                </div>
                
                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">Confirm Password<span id="requiredStar" class="text-danger">*</span></label>
                    <input type="password" class="form-control" name="confirmPassword" id="confirmPassword" placeholder="Re-enter your password" required>
                    <span id="confirmPasswordError" class="text-danger" style="font-size: 0.9rem;"></span>
                </div>
                
                <div class="mb-3">
                    <label for="profilePic" class="form-label">Upload Profile Picture</label>
                    <input type="file" class="form-control" name="profilePic" id="profilePic" accept="image/png">
                </div>
                
                <div class="mb-3">
                    <label for="department" class="form-label">Department<span id="requiredStar" class="text-danger">*</span></label>
                    <select class="form-select" name="department" id="department" required>
                        <option value="" disabled selected>Select your department</option>
                        <option value="Consultancy">Consultancy</option>
                        <option value="IT">IT</option>
                        <option value="Sales">Sales</option>
                        <option value="Accountance">Accountance</option>
                        <option value="Admin">Admin</option>
                        <option value="HR">HR</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="location" class="form-label">Employee Location<span id="requiredStar" class="text-danger">*</span></label>
                    <input type="text" class="form-control" name="location" id="location" placeholder="Enter your location" required>
                </div>
                
                <button type="button" class="btn btn-primary w-100" id="createAccountButton">Create Account</button>
            </form>

            <p id="message"></p>
            
            <p class="text-center mt-3">Existing user? <a href="./" id="loginLink" class="text-primary">Login</a></p>
        </div>

        <div class="right-pane">
            <h2>Asset Management</h2>
            <p>Digitizing Asset Management For You</p>
            <img src="images/illustration.png" alt="Illustration" class="illustration">
        </div>
    </div>
    <script>
    
    $(document).ready(function () {
    	    $("#loginLink").on("click", function (e) {
    	        e.preventDefault();
    	        const pageContent = $("#page-content");

    	        // Add slide-up animation
    	        pageContent.addClass("slide-up");

    	        // Redirect after animation completes
    	        setTimeout(() => {
    	            window.location.href = "./"; // Redirect to login page
    	        }, 1000); // Match with the animation duration
    	    });

    	    // On page load, apply slide-in animation
    	    const pageContent = $("#page-content");
    	    pageContent.addClass("slide-in");
        function start() {
            $("#sendOtpForm").show();
            $("#createAccountForm").hide();
            $("#message").hide();
            
            $.ajax({
            	url: "CheckUserCreatedServlet",
            	type: "GET",
            	success: function() {
            		console.log("clean users");
            	},
            	error: function(xhr, status, error) {
            		console.log(error);
            	}
            })
        }
        start();
        
        
        
        $("#generateOtp").on("click", function(event) {
            event.preventDefault();
            var empId = $("#empId").val();
            var empMail = $("#empMail").val();
            
            $.ajax({
                url: "SendOtpServlet", 
                type: "POST",
                data: { empId: empId, empMail: empMail },
                success: function(response) {
                    if (response.status === "error") {
                        $("#message").text(response.message).show();
                    } else {
                        $("#otpDiv").show();
                        $("#message").hide();
                        $("#generateOtp").attr("disabled", true);
                        var otpExpiration = Date.now() + 2 * 60 * 1000;
                        startCountdown(otpExpiration);	
                    }
                },
                error: function(xhr, status, error) {
                    console.log(error);
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
                    $("#generateOtp").attr("disabled", false);
                    start();
                    // Disable the Verify OTP button
                    $("#otpDiv").hide();
 
                    // UI changes: show sendOtpForm and hide generateOtpForm
                    $("#sendOtpForm").show();
                    $("#createAccountForm").hide();
                    $("#message").show();
                    $("#generateOtp").text("Resend OTP");
                }
            }, 1000);
        }
        
        $("#otpButton").on("click", function(event) {
            event.preventDefault();
            var empId = $("#empId").val();
            var otp = $("#otp").val();
            
            $.ajax({
                url: "VerifyOtpServlet",
                type: "POST",
                data: {empId: empId, otp: otp},
                success: function(response) {
                    if(response.status === "success") {
                        $("#sendOtpForm").hide();
                        $("#createAccountForm").show();
                        $("#message").hide();
                    } else {
                        $("#message").text(response.message).show();
                    }
                }, 
                error: function(xhr, status, error) {
                    console.log(error);
                }
            });
        });
       
        const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

        // Validate password strength as user types
        $("#password").on("input", function () {
            checkPasswordMatch();
        });

        // Validate confirm password as user types
        $("#confirmPassword").on("input", function () {
            checkPasswordMatch();
        });

        // Check if passwords match
        function checkPasswordMatch() {
        	const password = $("#password").val();
            const passwordError = $("#passwordError");

            if (passwordRegex.test(password)) {
                passwordError.text("").css("color", "green");
                
            } else {
                passwordError.text("Password must contain at least 8 characters, including uppercase, lowercase, number, and special character (@$!%*?&).").css("color", "red");
                return false;
            }
            
            const confirmPassword = $("#confirmPassword").val();
            const confirmPasswordError = $("#confirmPasswordError");

            if (confirmPassword === "") {
                confirmPasswordError.text("");
                return false;
            }

            if (password === confirmPassword) {
                confirmPasswordError.text("").css("color", "green");
                return true;
            } else {
                confirmPasswordError.text("Passwords do not match").css("color", "red");
                return false;
            }
        }
        
        
        $("#createAccountButton").on("click", function() {
        	var form = $("#createAccountForm")[0];
            if (form.checkValidity() === false) {
                form.reportValidity(); // Show validation messages for invalid fields
                return; // Stop form submission
            }
            
            var valid = checkPasswordMatch();
            
            if(!valid) return;
            
            var formData = new FormData($('#createAccountForm')[0]);
            console.log(formData);
            $.ajax({
                url: "AddUserServlet",
                type: "POST",
                processData: false, 
                contentType: false, 
                data: formData,
                success: function(response) {
                    if(response.status === "success") {
                        window.location.href = response.redirect;
                    } else {
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
