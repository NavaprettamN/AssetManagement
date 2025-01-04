<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/MaterialDesign-Webfont/3.6.95/css/materialdesignicons.css">

<style>
    .blur-overlay {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.5);
      backdrop-filter: blur(5px);
      z-index: 999; 
  }

  #changePasswordDiv {
      position: fixed;
      background: #fff;
      left: 30%;
      top: 20%;
      border-radius: 8px;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
      z-index: 1000;
      padding: 20px;
      max-width: 600px;
      width: 100%;
  }
  #profilePicEditDiv {
    position: fixed;
    background: #fff;
    left: 30%;
    top: 20%;
    border-radius: 8px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    z-index: 1000;
    padding: 20px;
    max-width: 600px;
    width: 100%;
    text-align: center;
    display: none;
}

#profilePicEditDiv h4 {
    margin-bottom: 20px;
    font-size: 1.5rem;
}

#profilePicContainer {
    margin-bottom: 20px;
}

#editProfilePic {
    width: 120px;
    height: 120px;
    border-radius: 50%;
    object-fit: cover;
    margin-bottom: 15px;
}

.form-group {
    margin-bottom: 15px;
}

.button-container {
    display: flex;
    justify-content: center;
    gap: 15px;
}

.btn-white {
    background-color: white;
    border: 2px solid #007bff;
    color: #007bff;
    border-radius: 50%;
    padding: 10px 20px;
    font-size: 1rem;
    cursor: pointer;
    transition: background-color 0.3s, color 0.3s;
}

.btn-white:hover {
    background-color: #007bff;
    color: white;
}

.close-btn {
    position: absolute;
    top: 10px;
    right: 10px;
    background: none;
    border: none;
    font-size: 1.5rem;
    cursor: pointer;
}

#editErrorMsg {
    color: red;
    margin-top: 10px;
}

#profilePic {
    position: relative;
    display: inline-block;
}

#editProfileBtn {
    position: absolute;
    top: 75px;
    right: 5px;
    background: rgba(255, 255, 255, 0); /* Semi-transparent background */
    border-radius: 50%;
    padding: 5px;
    cursor: pointer;
    z-index: 1; /* Make sure it's on top */
}

#profilePic img {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    object-fit: cover;
}
  .close-btn {
      position: absolute;
      top: 10px;
      right: 10px;
      background: none;
      border: none;
      font-size: 1.5rem;
      cursor: pointer;
  }
  
  .form-group {
      margin-bottom: 15px;
  }
	.user-card-full {
	    overflow: hidden;
	}
	
	.card {
	    border-radius: 5px;
	    -webkit-box-shadow: 0 1px 20px 0 rgba(69,90,100,0.08);
	    box-shadow: 0 1px 20px 0 rgba(69,90,100,0.08);
	    border: none;
	    margin-bottom: 30px;
	}
	
	.m-r-0 {
	    margin-right: 0px;
	}
	
	.m-l-0 {
	    margin-left: 0px;
	}
	
	.user-card-full .user-profile {
	    border-radius: 5px 0 0 5px;
	}
	
	.bg-c-lite-green {
	   	background: -webkit-gradient(linear, left top, right top, from(#add8e6), to(#70a7d9));
    background: linear-gradient(to right, #add8e6, #70a7d9);
	}
	
	.user-profile {
	    padding: 20px 0;
	}
	
	.card-block {
	    padding: 1.25rem;
	}
	
	.m-b-25 {
	    margin-bottom: 25px;
	    
	}
	
	.img-radius {
		width: 100px; 
	    height: 100px;
	    border-radius: 50%; 
	    object-fit: cover; 
	}
	

	
	 
	h6 {
	    font-size: 14px;
	}
	
	.card .card-block p {
	    line-height: 25px;
	}
	
	@media only screen and (min-width: 1400px){
	p {
	    font-size: 14px;
	}
	}
	

	.b-b-default {
	    border-bottom: 1px solid #e0e0e0;
	}
	
	.m-b-20 {
	    margin-bottom: 20px;
	}
	
	.p-b-5 {
	    padding-bottom: 5px !important;
	}
	
	.card .card-block p {
	    line-height: 25px;
	}
	
	.m-b-10 {
	    margin-bottom: 10px;
	}
	
	.text-muted {
	    color: #919aa3 !important;
	}
	
	.b-b-default {
	    border-bottom: 1px solid #e0e0e0;
	}
	
	.f-w-600 {
	    font-weight: 600;
	}
	
	.m-b-20 {
	    margin-bottom: 20px;
	}
	
	.m-t-40 {
	    margin-top: 20px;
	}
	
	.p-b-5 {
	    padding-bottom: 5px !important;
	}
	
	.m-b-10 {
	    margin-bottom: 10px;
	}
	
	.m-t-40 {
	    margin-top: 20px;
	}
	
	.user-card-full .social-link li {
	    display: inline-block;
	}
	
	.user-card-full .social-link li a {
	    font-size: 20px;
	    margin: 0 10px 0 0;
	    -webkit-transition: all 0.3s ease-in-out;
	    transition: all 0.3s ease-in-out;
	}


  
  

</style>
<title>Insert title here</title>
</head>
<body>
	<%@include file="../navbar.jsp" %>
	<div class="main-content d-flex flex-column">
		<h2 class="p-2">Profile</h2>
        <div id="changePasswordDiv" style="display: none;">
            <button class="close-btn">&times;</button>
            <h4>Change Password</h4>
            <form id="changePasswordForm">
                <div class="form-group">
                    <label for="currentPassword">Current Password</label>
                    <input type="password" id="currentPassword" name="currentPassword" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="newPassword">New Password</label>
                    <input type="password" id="newPassword" name="newPassword" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-primary">Save</button>
                <p id="errorMsg"></p>
            </form>
        </div>   
        
        <div id="profilePicEditDiv" style="display: none;">
		    <button class="close-btn">&times;</button>
		    <h4>Edit Profile Picture</h4>
		
		    <div id="profilePicContainer">
		        <!-- Profile Picture will be dynamically added here -->
		        <img id="editProfilePic" src="https://img.icons8.com/bubbles/100/000000/user.png" class="img-radius" alt="User-Profile-Image">
		    </div>
		
		    <form id="editProfilePicForm">
		        <div class="form-group" style="display: none;">
		            <input type="file" id="profilePicInput" name="profilePic" class="form-control" accept="image/*">
		        </div>
		        <div class="form-group button-container">
		            <button type="button" id="editProfilePicBtn" class="btn btn-white">Edit Picture</button>
		            <button type="button" id="deleteProfilePicBtn" class="btn btn-white">Delete Picture</button>
		        </div>
		    </form>
		    <p id="editErrorMsg" style="color: red;"></p>
		</div>

        
		<div class="page-content page-container" id="page-content">
    <div class="padding">
        <div class="row container d-flex justify-content-center">	
			<div class="col-xl-10 col-md-12">
            	<div class="card user-card-full">
                      <div class="row m-l-0 m-r-0">
                          <div class="col-sm-4 bg-c-lite-green user-profile">
                              <div class="card-block text-center text-white">
                                  <div class="m-b-25" id="profilePic">
                                      <img src="https://img.icons8.com/bubbles/100/000000/user.png" class="img-radius" alt="User-Profile-Image">
	                                   <button class="btn btn-link p-0" id="editProfileBtn">
	                                  		<i class="mdi mdi-square-edit-outline feather icon-edit m-t-10 f-16" ></i>
	                                   </button>
                                  </div>
                                  <h6 class="f-w-600" id="username"></h6>
                                  <p id="role"></p>
                              </div>
                          </div>
                          <div class="col-sm-8">
                              <div class="card-block">
                                  <h6 class="m-b-20 p-b-5 b-b-default f-w-600">Information</h6>
                                  <div class="row">
                                      <div class="col-sm-6">
                                          <p class="m-b-10 f-w-600" >Email</p>
                                          <h6 class="text-muted f-w-400" id="empMail"></h6>
                                      </div>
                                      <div class="col-sm-6">
                                          <p class="m-b-10 f-w-600">Department</p>
                                          <h6 class="text-muted f-w-400" id="department"></h6>
                                      </div>
                                  </div>
                                  <h6 class="m-b-20 m-t-40 p-b-5 b-b-default f-w-600"></h6>
                                  <div class="row">
                                      <div class="col-sm-6">
                                          <p class="m-b-10 f-w-600">Manager</p>
                                          <h6 class="text-muted f-w-400" id="manager"></h6>
                                      </div>
                                      <div class="col-sm-6">
                                          <p class="m-b-10 f-w-600">Location</p>
                                          <h6 class="text-muted f-w-400" id="location"></h6>
                                      </div>
                                  </div>
                                  <div class="my-3 p-3">
								    	<button class="btn btn-primary" id="changePasswordBtn">Change Password</button>
								    </div>
                              </div>
                          </div>
                      </div>
                  </div>
              </div>
            </div>
          </div>
        </div>
	</div>
     
    <div class="blur-overlay" style="display: none;"></div>
	<script>
		$(document).ready(function(){ 
			
			function listProfile() {
				var empId = "<%=session.getAttribute("empId") %>";
				$.ajax({
					url: "GetUserServlet",
					type: "GET",
					dataType: "json",	
					success: function(users) {
						var contextPath = "<%=request.getContextPath() %>"
						var listProfileDiv = "";
						users.forEach(function(user) {
							if(user.empId == empId) {
								$("#username").text(user.username);	
								$("#role").text(user.isManager === "true"? "Manager": "Employee");
								$("#empMail").text(user.empMail);
								$("#department").text(user.department);
								$("#location").text(user.location);
					
								var managerFound = false;
								for(let i = 0; i < users.length;i++) {
									var manager = users[i];
									if(manager.empId == user.manager) {										
										managerFound = true;
										$("#manager").text(manager.username);
										break;
									}
								}
								if(!managerFound) {
									$("#manager").text("None");
								}
								var contextPath = "<%=request.getContextPath() %>";
								$("#profilePic img").attr("src", contextPath +  "/" + user.profilePic + "?ver=<%= System.currentTimeMillis() %>");
								$("#profilePicContainer img").attr("src", contextPath +  "/" + user.profilePic + "?ver=<%= System.currentTimeMillis() %>");
								return;
							}
						})
					}
				})
			}
			listProfile();
            $("#changePasswordBtn").click(function() {
                $("#changePasswordDiv").show();
                $(".blur-overlay").show();
            });

            $(".close-btn, .blur-overlay").click(function() {
            	$("#changePasswordForm")[0].reset();
                $("#changePasswordDiv").hide();
                $("#profilePicEditDiv").hide();
                $(".blur-overlay").hide();
            });

            $("#changePasswordForm").submit(function(event) {
                event.preventDefault();
                var formData = $(this).serialize();
                $.ajax({
                    url: "ChangePasswordServlet",  
                    type: "POST",
                    data: formData,
                    success: function(response) {
                    	if(response.status === "success") {                    		
	                        $("#changePasswordDiv").hide();
			            	$("#changePasswordForm")[0].reset();
	                        $(".blur-overlay").hide();
                    	}
                    	else if(response.status === "error") {
                    		$("#errorMsg").text(response.message);
			            	$("#changePasswordForm")[0].reset();
                    	}
                    },
                    error: function(xhr, status, error) {
                        alert("Error: " + error);
                    }
                });
            });
            
            $("#editProfileBtn").on("click", function() {
            	$("#profilePicEditDiv").show();
            	$(".blur-overlay").show();
            })
            
            $("#editProfilePicBtn").click(function() {
                $("#profilePicInput").click();
            });

            $("#deleteProfilePicBtn").click(function() {
            	$("#profilePicInput").val("");
            	$("#editProfilePicForm").submit();
            })
            
            $("#profilePicInput").change(function() {
                var file = this.files[0];
                console.log($("#profilePicInput").val());
                if (file && file.type === "image/png") {
                    $("#editProfilePicForm").submit();
                } else {
                    $("#editErrorMsg").text("Please select a valid PNG image.");
                }
            });

            $("#editProfilePicForm").submit(function(e) {
                e.preventDefault(); 

                var formData = new FormData(this);
				console.log(formData);
                $.ajax({
                    url: 'EditProfilePicServlet', 
                    type: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function(response) {
                        if (response.status === "success") {
                        	window.location.href = response.redirect
                        	$(".blur-overlay").show();
                            $("#profilePicEditDiv").hide();
                        } else {
                            $("#editErrorMsg").text("Error uploading image. Please try again.");
                        }
                    },
                    error: function() {
                        $("#editErrorMsg").text("An error occurred. Please try again.");
                    }
                });
            });
		})
	</script>
</body>
</html>