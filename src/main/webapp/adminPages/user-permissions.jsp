<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10.10.1/dist/sweetalert2.all.min.js"></script>
    <title>Manage Users</title>
    <style>
	.user-section {
	    margin-top: 20px;
	}
	
	.table {
	    table-layout: fixed; /* Ensures fixed layout for table columns */
	    width: 100%;
	}
	
	.table th, .table td {
	    overflow: hidden;
	    text-overflow: ellipsis;
	    white-space: nowrap; /* Prevents wrapping */
	}
	
	.profile-pic-container img{
	    width: 50px;
	    height: 50px;
	    border-radius: 50%;
	    object-fit: cover;
	
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
	
	.text-truncate {
	    overflow: hidden;
	    text-overflow: ellipsis;
	    white-space: nowrap;
	}
	
/* General button styles */
button.btn {
    margin: 5px;
    padding: 8px 12px;
    font-size: 14px;
    border-radius: 5px; /* Subtle rounded edges */
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s ease-in-out; /* Smooth hover effect */
}

/* "Activate" button specific styles */
button.activeUser {
    background-color: #28a745; /* Green color */
    color: #fff;
    border: none;
}

button.activeUser:hover {
    background-color: #218838; /* Darker green on hover */
}

/* "Remove Role" button specific styles */
button.removeBtn {
    background-color: #dc3545; /* Red color */
    color: #fff;
    border: none;
}

button.removeBtn:hover {
    background-color: #c82333; /* Darker red on hover */
}

/* Icon styles */
button i {
    margin-right: 5px; /* Add spacing between the icon and text */
    font-size: 16px;
}

/* Optional: Tooltip style for better UX */
[data-bs-toggle="tooltip"] {
    cursor: pointer;
}

    </style>
</head>
<body>
<%@include file="../navbar.jsp" %>
<div class="main-content">
    <h3>Current Administrators</h3>
    <div id="adminSection" class="user-section">
		<div class="container-fluid p-4 bg-white border rounded">
	    
	        <table class="table table-striped rounded-table">
	            <thead>
	                <tr class="col-12">
	                    <th class="col-2">Profile</th>
	                    <th class="col-2">Employee ID</th>
	                    <th class="col-2">Username</th>
	                    <th class="col-3">Role</th>
	                    <th class="col-1">Action</th>
	                </tr>
	            </thead>
	            <tbody id="adminTableBody"></tbody>
	        </table>
        </div>
    </div>

    <div id="userSection" class="user-section">
    	<h3 id="userListHeading">Users Eligible for Administrator role</h3>
    	<div class="container-fluid p-4 bg-white border rounded">
	        <table class="table table-striped rounded-table">
	            <thead>
	                <tr class="col-12">
	                    <th class="col-2">Profile</th>
	                    <th class="col-2">Employee ID</th>
	                    <th class="col-2">Username</th>
	                    <th class="col-3">Role</th>
	                    <th class="col-1">Action</th>
	                </tr>
	            </thead>
	            <tbody id="userTableBody"></tbody>
	        </table>
        </div>
    </div>
</div>

<script>
function loadUsers() {
    $.ajax({
        url: "GetUserServlet",
        type: "GET",
        dataType: "json",
        success: function(users) {
            let adminCount = 0;
            let superAdminCount = 0;

            let adminSectionHTML = "";
            let userSectionHTML = "";

            users.forEach(function(user) {
                if (user.isAdmin === 'admin') {
                    adminCount++;
                    adminSectionHTML += createUserRow(user, 'Admin');
                } else if (user.isAdmin === 'superAdmin') {
                    superAdminCount++;
                    var empId = "<%=session.getAttribute("empId") %>";
                    if(user.empId !== empId)
                    	adminSectionHTML += createUserRow(user, 'SuperAdmin');
                }
            });

            users.forEach(function(user) {
                if ((user.isAdmin == '' || user.isAdmin == null) && user.isManager !== "true" && user.active == "Yes") {
                    userSectionHTML += createUserDropdownRow(user, adminCount, superAdminCount);
                }
            });

            $('#adminTableBody').html(adminSectionHTML);
            if (adminCount < 2 || superAdminCount < 2) {
                $('#userTableBody').html(userSectionHTML);
                $("#userSection").show();
            } else {
                $('#userTableBody').html("");
                $("#userSection").hide();
            }
        },
        error: function(error) {
            console.error("Error fetching users:", error);
        }
    });
}

function createUserRow(user, role) {
    return "<tr class='col-12'>" +
           "<td class='profile-pic-container col-1'><img src='<%=request.getContextPath()%>/" + user.profilePic + "' alt='Profile Picture'></td>" +
           "<td class='col-2'>" + user.empId + "</td>" +
           "<td class='text-truncate col-3' style='max-width: 200px;' data-bs-toggle='tooltip' title='" + user.username + "'>" + user.username + "</td>" +
           "<td class='col-2'>" + role + "</td>" +
           "<td class='col-2'><button class='btn btn-danger removeBtn' data-emp-id='" + user.empId + "'> <i class='bi bi-trash'></i></button></td>" +
           "</tr>";
}

function createUserDropdownRow(user, adminCount, superAdminCount) {
    let roleOptions = "";

    if (adminCount < 2) {
        roleOptions += "<option value='Admin'>Admin</option>";
    }

    if (superAdminCount < 2) {
        roleOptions += "<option value='SuperAdmin'>SuperAdmin</option>";
    }

    return "<tr class='col-12'>" +
           "<td class='profile-pic-container col-1'><img src='<%=request.getContextPath()%>/" + user.profilePic + "' alt='Profile Picture'></td>" +
           "<td class='col-2'>" + user.empId + "</td>" +
           "<td class='text-truncate col-3' style='max-width: 200px;' data-bs-toggle='tooltip' title='" + user.username + "'>" + user.username + "</td>" +
           "<td class='col-2'><select class='form-select w-75' data-emp-id='" + user.empId + "'>" +
           "<option value=''>Select Role</option>" + roleOptions +
           "</select></td>" +
           "<td class='col-2'><button class='btn btn-primary activeUser' data-emp-id='" + user.empId + "'><i class='bi bi-person-check'></i></button></td>" +
           "</tr>";
}

$(document).ready(function() {
    loadUsers();

    $(document).on('click', '.activeUser', function() {
        const empId = $(this).data('emp-id');
        const selectedRole = $("select[data-emp-id='"+ empId + "']").val();
        if (selectedRole) {
	    	Swal.fire({
	    		title: "Employee " + empId + " has been set as " + selectedRole,
	    		icon: "success",
	    		timer: 1500,
	    		showConfirmButton: false
	   		});
            $.ajax({
                url: "AssignAdminServlet",
                type: "POST",
                data: {
                    empId: empId,
                    role: selectedRole
                },
                success: function(response) {
                    loadUsers();
                },
                error: function(error) {
                    console.error("Error assigning role:", error);
                }
            });
        }
    });

    $("#adminSection").on("click", ".removeBtn", function() {
        const empId = $(this).data('emp-id');
       	Swal.fire({
    		title: "Employee " + empId + " has been removed from the Admin list",
    		icon: "success",
    		timer: 1500,
    		showConfirmButton: false
   		});
        $.ajax({
            url: "AssignAdminServlet",
            type: "POST",
            data: { empId: empId },
            success: function(response) {
                loadUsers();
            },
            error: function(error) {
                console.error("Error assigning role:", error);
            }
        });
    });
});
</script>
</body>
</html>
