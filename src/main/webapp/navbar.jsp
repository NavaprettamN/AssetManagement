<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Side Navigation Bar</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10.10.1/dist/sweetalert2.all.min.js"></script>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .main-content {
			padding-left: 18%;
			padding-right: 1%;
			width: auto;
			height: auto;
			min-height: 100vh;
			background-color: #f1f4fa;
		}
		
        .sidebar {
            height: 100vh;
            width: 15%;
            background-color: #FFFFFF;
            border-right: 1px solid #ddd;
            position: fixed;
            top: 0;
            left: 0;
            overflow-y: auto;
            padding-top: 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .logo {
            text-align: center;
            padding: 20px 0;
        }
        .logo img {
            width: 60%;
        }
        
        .profile-text {
            text-align: center;
            color: #777;
            margin-bottom: 30px;
            font-size: 1.2em;
            padding: 0px 30px 0px 30px;
        }
        
        .nav {
            flex-grow: 1;
        }

        .nav-item {
            font-size: 1.1em;
            padding: 15px 20px;
            color: #333;
            display: flex;
            align-items: center;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        .nav-item:hover {
            background-color: #E2EBFD;
        }
        .nav-item:hover .nav-link {
            color: #0056b3;
        }
        .nav-item .nav-link {
            color: #333;
            padding: 0;
            display: flex;
            align-items: center;
            width: 100%;
        }
        .nav-item.active {
		    background-color: #D6E4FF;
		}
		
		.nav-item.active .nav-link {
		    color: #004085;
		    font-weight: bold;
		}
		
		.nav-item.active .icon {
		    filter: brightness(1.2);
		}
        .nav-item img.icon {
            width: 24px;
            height: 24px;
            margin-right: 10px;
        }
        .nav-item.disabled {
            opacity: 0.5;
        }
        
        .profileDiv {
		    display: flex;
		    align-items: center;
		    justify-content: space-between;
		    padding: 20px;
		    
		}
		
		.profileDiv img {
		    width: 40px; 
		    height: 40px;
		    border-radius: 50%; 
		    object-fit: cover; 
		}
		
		.profileDiv img#logout-icon {
		    width: 30px; 
		    height: 30px;
		    border-radius: 50%; 
		    object-fit: cover; 
		}
		
		.profileDiv p {
		    flex-grow: 1;
		    text-align: center;
		    margin: 0;
		    font-size: 1em;
		    color: #333;
		    white-space: nowrap; 
		    overflow: hidden; 
		    text-overflow: ellipsis; 
		}
		
		tbody td {
			align-content: center;
			border-color: white !important;
		}
		
		table.rounded-table {
			border-collapse: separate;
			border-spacing: 0px;
		}
		
		table.rounded-table th {
			border-style: none;
		}
		
		tr:nth-child(odd) td:first-child {
			border-radius: 5px 0px 0px 5px;
		}
		
		tr:nth-child(odd) td:last-child {
			border-radius: 0px 5px 5px 0px;
		}
		
        
    </style>
</head>
<body>

<div class="sidebar">
    <div>
        <div class="logo">
            <img src="<%=request.getContextPath() %>/images/eds-logo.png" alt="Logo">
        </div>
        <%
			    String currentUrl = request.getRequestURI();
            	log(currentUrl);
		%>
        <%if(session.getAttribute("isAdmin") != null) {%>
	        <% if(session.getAttribute("isAdmin").equals("superAdmin")) { %>
	            <div class="profile-text p-3">
	                <h4>Welcome, <%=session.getAttribute("username").toString().split(" ")[0] %></h4>
	                <p class="fs-6">(SuperAdmin)</p>
	                
	            </div>
	            <ul class="nav flex-column">
	                <li class=" nav-item <%= currentUrl.contains("dashboard") ? "active" : "" %>"" id="dashboard-item">
	                    <a class="nav-link" href="<%=request.getContextPath() %>/admin-profile/dashboard">
	                        <img src="<%=request.getContextPath() %>/images/<%= currentUrl.contains("dashboard") ? "dashboard-icon-active.png" : "dashboard-icon.png" %>" class="icon" alt="Dashboard Icon">
	                        Dashboard	
	                    </a>
	                </li>
	                <li class=" nav-item <%= currentUrl.contains("user-permissions") ? "active" : "" %>"" id="dashboard-item">
	                    <a class="nav-link" href="<%=request.getContextPath() %>/admin-profile/user-permissions">
	                        <img src="<%=request.getContextPath() %>/images/<%= currentUrl.contains("user-permissions") ? "people-icon-active.png" : "people-icon.png" %>"" class="icon" alt="People Icon">
	                        User Permissions	
	                    </a>
	                </li>
	                
	            </ul>
	        <% } else if(session.getAttribute("isAdmin").equals("admin")) { %>
	            <div class="profile-text">
	                <h4>Welcome, <%=session.getAttribute("username").toString().split(" ")[0]%></h4>
					<p class="fs-6">(Admin)</p>
	                
	            </div>
	            
				<ul class="nav flex-column">
				    <li class="nav-item <%= currentUrl.contains("dashboard") ? "active" : "" %>">
				        <a class="nav-link" href="<%=request.getContextPath() %>/admin-profile/dashboard">
				            <img src="<%=request.getContextPath() %>/images/<%= currentUrl.contains("dashboard") ? "dashboard-icon-active.png" : "dashboard-icon.png" %>" class="icon" alt="Dashboard Icon">
				            Dashboard
				        </a>
				    </li> 
				    <li class="nav-item <%= currentUrl.contains("/add-asset") ? "active" : "" %>">
				        <a class="nav-link" href="<%=request.getContextPath() %>/admin-profile/add-asset">
				            <img src="<%=request.getContextPath() %>/images/<%= currentUrl.contains("/add-asset") ? "add-asset-icon-active.png" : "add-asset-icon.png" %>" class="icon" alt="Add Assets Icon">
				            Add Assets
				        </a>
				    </li>
				    <li class="nav-item <%= currentUrl.contains("/asset") ? "active" : "" %>">
				        <a class="nav-link" href="<%=request.getContextPath() %>/admin-profile/asset">
				            <img src="<%=request.getContextPath() %>/images/<%= currentUrl.contains("/asset") ? "asset-icon-active.png" : "asset-icon.png" %>" class="icon" alt="Assets Icon">
				           	Assets
				        </a>
				    </li>
				    <li class="nav-item <%= currentUrl.contains("/request") ? "active" : "" %>">
				        <a class="nav-link" href="<%=request.getContextPath() %>/admin-profile/request">
				            <img src="<%=request.getContextPath() %>/images/<%= currentUrl.contains("/request") ? "request-icon-active.png" : "request-icon.png" %>" class="icon" alt="Assets Icon">
				           	Requests
				        </a>
				    </li>
				    
				    
	            </ul>
	        <% } %>
        <% } else if(session.getAttribute("isManager") != null) { %>
        	<% if(session.getAttribute("isManager") == "true") { %>
        		<div class="profile-text">
	                <h4>Welcome, <%=session.getAttribute("username").toString().split(" ")[0] %></h4>
	                <p class="fs-6">(Manager)</p>
	            </div>
	            
				<ul class="nav flex-column">
				    <li class="nav-item <%= currentUrl.contains("dashboard") ? "active" : "" %>">
				        <a class="nav-link" href="<%=request.getContextPath() %>/profile/dashboard">
				            <img src="<%=request.getContextPath() %>/images/<%= currentUrl.contains("dashboard") ? "dashboard-icon-active.png" : "dashboard-icon.png" %>" class="icon" alt="Dashboard Icon">
				            Dashboard
				        </a>
				    </li> 
				    <li class="nav-item <%= currentUrl.contains("/view-requests") ? "active" : "" %>">
				        <a class="nav-link" href="<%=request.getContextPath() %>/profile/view-requests">
				            <img src="<%=request.getContextPath() %>/images/<%= currentUrl.contains("/view-requests") ? "asset-icon-active.png" : "asset-icon.png" %>" class="icon" alt="Add Assets Icon">
				            View Requests
				        </a>
				    </li>
				    <li class="nav-item <%= currentUrl.contains("/make-request") ? "active" : "" %>">
				        <a class="nav-link" href="<%=request.getContextPath() %>/profile/make-request">
				            <img src="<%=request.getContextPath() %>/images/<%= currentUrl.contains("/make-request") ? "add-asset-icon-active.png" : "add-asset-icon.png" %>" class="icon" alt="Assets Icon">
				           	Make Request
				        </a>
				    </li>
				    <li class="nav-item <%= currentUrl.contains("/status") ? "active" : "" %>">
				        <a class="nav-link" href="<%=request.getContextPath() %>/profile/status">
				            <img src="<%=request.getContextPath() %>/images/<%= currentUrl.contains("/status") ? "request-icon-active.png" : "request-icon.png" %>" class="icon" alt="Assets Icon">
				           	Status
				        </a>
				    </li>
				    <li class="nav-item <%= currentUrl.contains("/people") ? "active" : "" %>">
				        <a class="nav-link" href="<%=request.getContextPath() %>/profile/people">
				            <img src="<%=request.getContextPath() %>/images/<%= currentUrl.contains("/people") ? "people-icon-active.png" : "people-icon.png" %>" class="icon" alt="Assets Icon">
				           	People
				        </a>
				    </li>
				    
	            </ul>
	            <% }
        	else if(session.getAttribute("isManager") == "false") { %>
	            <div class="profile-text">
	                <h4>Welcome, <%=session.getAttribute("username").toString().split(" ")[0]%></h4>
	                <p class="fs-6">(Employee)</p>
	            </div>
	            
				<ul class="nav flex-column">
				    <li class="nav-item <%= currentUrl.contains("dashboard") ? "active" : "" %>">
				        <a class="nav-link" href="<%=request.getContextPath() %>/profile/dashboard">
				            <img src="<%=request.getContextPath() %>/images/<%= currentUrl.contains("dashboard") ? "dashboard-icon-active.png" : "dashboard-icon.png" %>" class="icon" alt="Dashboard Icon">
				            Dashboard
				        </a>
				    </li> 
				    
				    <li class="nav-item <%= currentUrl.contains("/make-request") ? "active" : "" %>">
				        <a class="nav-link" href="<%=request.getContextPath() %>/profile/make-request">
				            <img src="<%=request.getContextPath() %>/images/<%= currentUrl.contains("/make-request") ? "add-asset-icon-active.png" : "add-asset-icon.png" %>" class="icon" alt="Assets Icon">
				           	Make Request
				        </a>
				    </li>
				    <li class="nav-item <%= currentUrl.contains("/status") ? "active" : "" %>">
				        <a class="nav-link" href="<%=request.getContextPath() %>/profile/status">
				            <img src="<%=request.getContextPath() %>/images/<%= currentUrl.contains("/status") ? "request-icon-active.png" : "request-icon.png" %>" class="icon" alt="Assets Icon">
				           	Status
				        </a>
				    </li>
				    
				    
	            </ul>
	            <%}
        	} %>
    </div>
    <div class="profileDiv">
	    <% if (session.getAttribute("isAdmin") == null) { %>
	        <a href="<%=request.getContextPath() %>/profile/user-profile">
	            <img src="<%=request.getContextPath() %>/images/profilepic/<%=session.getAttribute("empId") %>.png?ver=<%= System.currentTimeMillis() %>" alt="Profile Icon" 
	            id="profile-icon-user" 
	            onerror="this.onerror=null;this.src='<%=request.getContextPath() %>/images/profilepic/default.png';">
	        </a>
	    <% } else { %>
	       <a href="<%=request.getContextPath() %>/admin-profile/admin-user-profile">
	            <img src="<%=request.getContextPath() %>/images/profilepic/<%=session.getAttribute("empId") %>.png?ver=<%= System.currentTimeMillis() %>" alt="Profile Icon" 
	            id="profile-icon-user" 
	            onerror="this.onerror=null;this.src='<%=request.getContextPath() %>/images/profilepic/default.png';">
	        </a>
	    <% } %>
	    
	    <p id="profileName">Loading...</p>
	    
	    <a href="<%=request.getContextPath() %>/LogoutServlet">
	        <img src="<%=request.getContextPath() %>/images/logout-icon.png" alt="Logout Icon" id="logout-icon">
	    </a>
	</div>

</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
	$(document).ready(function() {
		function loadProfileName() {
			var isAdmin = "<%=session.getAttribute("isAdmin") %>";
			var empId = "<%=session.getAttribute("empId") %>";
			
			var username = "<%=session.getAttribute("username") %>";
			var firstName = username.split(" ")[0];			
			console.log(empId);
			console.log(isAdmin);
			if(isAdmin != "null") {
				$("#profileName").text(firstName);				
			}
			else {
				$("#profileName").text(firstName);
			}
		}
		loadProfileName();
		
	})
</script>
</body>
</html>
