<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <title>Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f7fa;
            height: 100vh;
            margin: 0;
        }
        body, html {
		    overflow: hidden;
		}

		/* After the animation, allow scrolling */
		body.slide-in, html.slide-in {
		    overflow: auto;
		}
        .container-fluid {
            display: flex;
            width: 100%;
			height: 100vh;
            
        }
        /* Left Panel (Login Form) */
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
        .left-pane img {
            width: 120px;
            margin-bottom: 1rem;
        }
        .left-pane h2 {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 2rem;
            color: #1f2937;
        }
        .form-label {
            font-weight: 600;
            color: #555;
        }
        .form-control {
            background-color: #f5f7fa;
            border: none;
            box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        .btn-primary {
            background-color: #3B82F6;
            border: none;
            width: 100%;
        }
        .btn-primary:hover {
            background-color: #2563EB;
        }
        .link-text {
            color: #3B82F6;
            text-decoration: none;
        }
        .link-text:hover {
            text-decoration: underline;
        }
        /* Right Panel (Branding) */
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
            margin-top: 1rem;
        }
        .illustration {
            max-width: 70%;
            margin-top: 2rem;
        }
         /* Add animation for the transition */
        /* Slide-up animation */
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

/* Apply animation */
.slide-up {
    animation: slide-up 1s forwards;
}


/* Slide-in animation */
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

/* Animation classes */

.slide-in {
    animation: slide-in 1s forwards;
}
	#password::-ms-reveal {
        display: none; /* Hides the default icon in Edge */
    }

    /* Ensure the input field does not show the default browser password visibility toggle */
    #password {
        -webkit-appearance: none; /* Removes default browser appearance */
        -moz-appearance: none; /* For Firefox */
        appearance: none; /* For other browsers */
    }

    </style>
</head>
<body>
	<div id="page-content" class="container-fluid slide-in">
        <!-- Right Pane (Branding and Illustration) -->
        <div class="right-pane">
            <h2>Asset Management</h2>
            <img src="images/illustration.png" alt="Illustration" class="illustration">
            <p>Digitizing Asset Management For You</p>
        </div>

        <!-- Left Pane (Login Form) -->
        <div class="left-pane">
            <img src="images/eds-logo.png" alt="EDS Logo">
            <h2>Login</h2>
            <form class="w-100" id="loginForm">
                <div class="mb-3">
                    <label for="empId" class="form-label">Employee ID</label>
                    <input type="text" class="form-control" name="empId" id="empId" placeholder="Enter Your Employee ID" required>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <div class="input-group">
                        <input type="password" class="form-control" name="password" id="password" placeholder="Enter Your Password" required  autocomplete="" autocorrect="off">
                        <span class="input-group-text" id="togglePassword" style="cursor: pointer;">
                            <i class="bi bi-eye-slash"></i>
                        </span>
                    </div>
                </div>
                <div class="d-flex justify-content-between">
                    <a href="./resetpassword" class="link-text" id="resetPassword">Reset Password?</a>
                </div>
                <button class="btn btn-primary mt-3" type="submit">Login</button>
                <p class="text-danger mt-2"></p>
            </form>
            <p class="text-center mt-3">New User? <a href="./signup" id="signupLink" class="link-text">Sign Up</a></p>
        </div>
    </div>
    <script>
        $(document).ready(function() {
	        // Toggle password visibility
	        document.getElementById("togglePassword").addEventListener("click", function () {
			    const passwordField = document.getElementById("password");
			    const icon = this.querySelector("i");
			    if (passwordField.type === "password") {
			        passwordField.type = "text"; // Show password
			        icon.classList.replace("bi-eye-slash", "bi-eye"); // Change to open eye icon
			    } else {
			        passwordField.type = "password"; // Hide password
			        icon.classList.replace("bi-eye", "bi-eye-slash"); // Change to closed eye icon
			    }
			});


	    	document.getElementById("signupLink").addEventListener("click", function (e) {
			    e.preventDefault();
			    const pageContent = document.getElementById("page-content");
			
			    pageContent.style.transition = "transform 1s, opacity 1s"; // Smooth transition for transform and opacity
			    pageContent.style.transform = "translateY(-100%)"; // Move the content upwards
			    pageContent.style.opacity = "0"; // Fade out the content
			
			
			    // Remove the animation class after animation ends and redirect
			    setTimeout(() => {
			        window.location.href = "./signup"; // Redirect to the signup page
				    }, 500); // Delay matching the duration of the animation
			});
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
	      	
	      	 $("#loginForm").on("submit", function (e) {
	             e.preventDefault(); // Prevent default form submission

	             const form = document.getElementById("loginForm");
	             if (!form.checkValidity()) {
	                 form.reportValidity(); // Show HTML5 validation messages
	                 return;
	             }

	             const empId = $("#empId").val();
	             const password = $("#password").val();

	             $.ajax({
	                 url: "AuthServlet", // Update the servlet URL
	                 type: "POST",
	                 data: {
	                     empId: empId,
	                     password: password
	                 },
	                 dataType: "json",
	                 success: function (response) {
	                     // Assuming response contains 'success' or 'error' as a JSON object
	                     if (response.status === "success") {
	                    	 console.log(response);
	                         window.location.href = response.redirect; // Redirect on success
	                     } else {
	                         $("p.text-danger").text(response.errorMsg || "Invalid credentials. Please try again.");
	                     }
	                 },
	                 error: function (xhr,status,error) {
	                     console.log(error)
	                     $("p.text-danger").text("An error occurred. Please try again later.");
	                 }
	             });
	         });
      	})
    </script>
</body>
</html>
