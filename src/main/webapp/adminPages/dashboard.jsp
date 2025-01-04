<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dashboard</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet" crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
	crossorigin="anonymous"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
	<link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css'>
	
<style>
.highlight {
	background-color: yellow;
	color: black;
	font-weight: bold;
}

#searchInput {
	max-width: 300px;
}

#searchInput {
    padding-left: 2.375rem;
}
.form-control-feedback {
    position: absolute;
    z-index: 2;
    display: block;
    width: 2.375rem;
    height: 2.375rem;
    line-height: 2.375rem;
    text-align: center;
    pointer-events: none;
    color: #aaa;
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

#searchButton {
	display: inline-block;
}

.profile-pic-container {

}

.profile-pic-container img {
	width: 50px;
	height: 50px;
	border-radius: 50%;
	object-fit: cover;
}

.popover-trigger {
	font-family: 'San Francisco', 'Helvetica Neue', sans-serif;
	font-size: 16px;
	font-weight: 500;
	color: #4A4A4A;
	background: linear-gradient(to right, #5AC8FA, #5856D6);
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
	position: relative;
	cursor: pointer;
	transition: transform 0.25s ease, color 0.3s ease, text-shadow 0.25s
		ease;
}

.popover-trigger:hover {
	transform: translateY(-1px) scale(1.03);
	text-shadow: 0 2px 4px rgba(90, 90, 90, 0.3);
}

.popover {
	opacity: 0;
	transform: translateY(-10px);
	transition: opacity 0.3s ease, transform 0.3s ease;
}

.popover.show {
	opacity: 1;
	transform: translateY(0);
}

.extra-small-text {
	font-size: 0.75rem;
}

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

#editManagerDiv {
	position: fixed;
	background: #fff;
	left: 30%;
	top: 10%;
	border-radius: 8px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
	z-index: 1000;
	padding: 20px;
	max-width: 600px;
	width: 100%;
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

#userListBody td {
}
.popover-trigger {
	    font-family: 'San Francisco', 'Helvetica Neue', sans-serif;
	    font-size: 16px;
	    font-weight: 500;
	    color: #4A4A4A;
	    background: linear-gradient(to right, #5AC8FA, #5856D6); 
	    -webkit-background-clip: text;
	    -webkit-text-fill-color: transparent; 
	    position: relative;
	    cursor: pointer;
	    transition: transform 0.25s ease, color 0.3s ease, text-shadow 0.25s ease;
	}
	
	.popover-trigger:hover {
	    transform: translateY(-1px) scale(1.03); 
	    text-shadow: 0 2px 4px rgba(90, 90, 90, 0.3); 
	}

</style>

<script>

$(document).ready(function(){
	$("#editManagerDiv").hide();
	$("body").append('<div class="blur-overlay" style="display:none;"></div>');
	
	let activeFilter = "All"; // Default filter

    $("#searchInput").on("keyup", function () {
        loadUser();
    });

    $("#filterAll").on("click", function () {
        activeFilter = "All";
        loadUser();
    });

    $("#filterManagers").on("click", function () {
        activeFilter = "Managers";
        loadUser();
    });

    $("#filterActive").on("click", function () {
        activeFilter = "Active";
        loadUser();
    });

    $("#filterInactive").on("click", function () {
        activeFilter = "Inactive";
        loadUser();
    });
    function loadUser() {
        $.ajax({
            url: "GetUserServlet",
            type: "GET",
            dataType: "json",
            success: function(users) {
            	users.sort(function(a, b) {
            	    const empIdRegex = /^([a-zA-Z]*)(\d+)$/;
            	    const matchA = a.empId.match(empIdRegex);
            	    const matchB = b.empId.match(empIdRegex);

            	    if (matchA && matchB) {
            	        const prefixA = matchA[1];
            	        const prefixB = matchB[1];
            	        const numA = parseInt(matchA[2], 10);
            	        const numB = parseInt(matchB[2], 10);

            	        if (prefixA !== prefixB) {
            	            return prefixA.localeCompare(prefixB);
            	        }
            	        return numA - numB;
            	    }

            	    if (matchA && !matchB) return -1;
            	    if (!matchA && matchB) return 1;

            	    return a.empId.localeCompare(b.empId);
            	});

            	
                var userRows = "";
                var contextPath = "<%=request.getContextPath()%>";
                const searchTerm = $("#searchInput").val().toLowerCase();
                const highlightStart = "<span class='highlight'>";
                const highlightEnd = "</span>";

                users.forEach((user, index) => {
                	const matchesSearch =
                        user.empId.toLowerCase().includes(searchTerm) ||
                        user.username.toLowerCase().includes(searchTerm);

                    let matchesFilter = true;
                    switch (activeFilter) {
                        case "Managers":
                            matchesFilter = user.isManager === "true";
                            break;
                        case "Active":
                            matchesFilter = user.active === "Yes";
                            break;
                        case "Inactive":
                            matchesFilter = user.active === "No";
                            break;
                        default:
                            matchesFilter = true;
                            break;
                    }
                	if (matchesSearch && matchesFilter && user.isAdmin == null) {
                        let rowClass = index % 2 === 0 ? "bg-white" : "bg-body-secondary";
                        
                        const empIdHighlighted = user.empId.replace(
                                new RegExp(searchTerm, "gi"),
                                (match) => highlightStart + match + highlightEnd
                            );

                            const usernameHighlighted = user.username.replace(
                                new RegExp(searchTerm, "gi"),
                                (match) => highlightStart + match + highlightEnd
                            );

                        
                        userRows += "<tr class='col-12'>";
                        userRows += "<td class='profile-pic-container col-1'>" + "<img src='" + contextPath +  "/" + user.profilePic + "' alt='Profile Picture'>"+ "</td>";                        
                        userRows += "<td class='text-truncate empId col-2' style='max-width: 100px;' data-bs-toggle='tooltip' title='" + user.empId + "'>" + empIdHighlighted + "</td>";
                        userRows += "<td class='text-truncate username col-2' style='max-width: 150px' data-bs-toggle='tooltip' title='" + user.username + "'>" + usernameHighlighted + "</td>";
                        var isManager = (user.isManager === "true")? "fw-bold": "";
                        if(user.isManager === "true") {
                        	userRows += "<td class='isManager managerBtn popover-trigger'>Manager</td>";
                        }
                        else {                    	
	                        userRows += "<td class='isManager "+ isManager + " col-2'>User</td>";
                        }
                        userRows += "<td class='col-3'>";
                        userRows += "<select class='form-select w-75' data-emp-id='"+user.empId+"'>";
                        userRows += "<option value=''>None</option>";
                        users.forEach(manager => {
                        	if(manager.isAdmin == null && manager.manager != user.empId) {                        		
	                            if (manager.empId != user.empId) {
	                                let selected = manager.empId === user.manager ? "selected" : "";
	                                userRows += "<option value='"+manager.empId+"'" + selected + ">"+manager.username+"</option>";
	                            }
                        	}
                        });
                        userRows += "</select></td>";
           				if(user.active == "Yes") 
                        	userRows += "<td class='col-2'>" +"<button class='btn btn-primary activeUser' data-emp-id='" + user.empId+ "' data-ismanager='" + user.isManager + "'><i class='bi bi-check-circle'></i> Active</button>"+ "</td>";
                        else if(user.active == "No")
                        	userRows += "<td class='col-2'>" +"<button class='btn btn-danger activeUser' data-emp-id='" + user.empId+ "' data-ismanager='" + user.isManager + "'><i class='bi bi-dash-circle'></i> Inactive</button>"+ "</td>";
                        userRows += "</tr>";
	                    
                	}
                });
                $('#userListBody').html(userRows);
            },
            error: function(error) {
                console.error("Error fetching users:", error);
            }
        });
    }
    loadUser();
    
    
 // Main logic when clicking the manager button
    $("#userListBody").on("click", ".managerBtn", async function () {
        const managerId = $(this).closest("tr").find(".empId").text().trim();
        $(".blur-overlay").show();
        $("#editManagerDiv").show();
        console.log("Current Manager ID:", managerId);	

        $("#currManager").val(managerId);

        var users = await getUsers(); // Fetch user list
        
        // Populate new manager dropdown
        renderNewManagerDropdown(users, managerId);
        
        // Populate user list with checkboxes
        renderUserList(users, managerId);

        // Attach the 'change' event listener to checkboxes AFTER rendering the user list
        $("#userList").on("change", "input[type='checkbox']", function () {
            renderNewManagerDropdown(users, managerId);
        });
    });

    // Function to render the dropdown dynamically
    function renderNewManagerDropdown(users, managerId) {
	    const selectedUsers = [];
	    // Collect selected checkboxes
	    $("#userList input[type='checkbox']:checked").each(function () {
	        selectedUsers.push($(this).val());
	    });
	    console.log(selectedUsers);
	
	    // Generate dropdown options excluding selected users and current manager
	    var newManagerHtml = "<option value='' selected>None</option>";
	    users.forEach(function (user) {
	        console.log(user.empId);
	        var found = selectedUsers.find(function (u) { return u === user.empId; });
	        console.log("found : ", found);
	        if ((user.isAdmin == null || user.isAdmin == "") && !found && user.empId !== managerId) {
	            newManagerHtml += "<option value=\"" + user.empId + "\">" + user.username + "</option>";
	        }
	    });
	
	    // Update the dropdown content
	    $("#newManagerDiv").html(
	        "<label for='newManager' class='form-label'>New Manager</label>" +
	        "<select name='newManagerSelect' id='newManagerSelect' class='form-select'>" +
	        newManagerHtml +
	        "</select>"
	    );
	}


 // Function to render the user list with checkboxes
    function renderUserList(users, managerId) {
        var userListHtml = "";
        console.log("managerId", managerId);
        users.forEach(function (user) {
            console.log("render user list : ", user);
            if (user.manager === managerId) {
                console.log("true");
                userListHtml +=
                    "<div class=\"form-check\">" +
                    "<input class=\"form-check-input\" type=\"checkbox\" value=\"" + user.empId + "\" id=\"user-" + user.empId + "\">" +
                    "<label class=\"form-check-label\" for=\"user-" + user.empId + "\">" +
                    user.username +
                    "</label>" +
                    "</div>";
            }
        });

        if (userListHtml === "") {
            userListHtml = "<p class=\"text-muted\">No users found under the current manager.</p>";
        }
        console.log(userListHtml);

        $("#userList").html(userListHtml);
    }


    
    $("#saveBtn").on("click", function () {
        const newManagerId = $("#newManagerSelect").val();
        const selectedUsers = [];

        $("#userList input[type='checkbox']:checked").each(function () {
            selectedUsers.push($(this).val());
        });

        console.log("Selected Users:", selectedUsers);

        if (selectedUsers.length === 0) {
            alert("Please select at least one user.");
            return;
        }

        assignManager(selectedUsers, newManagerId);

        $("#editManagerDiv").hide();
        $(".blur-overlay").hide();
    });

    $(".blur-overlay").on("click", function () {
        $("#editManagerDiv").hide();
        $(this).hide();
    });
    
    $("#editManagerDiv").on("click", ".close-btn", function () {
        $("#editManagerDiv").hide();
        $(".blur-overlay").hide();
    });
    
    function assignManager(userIdArray, managerId) {
    	const userIdString = userIdArray.join(",");
    	console.log(userIdString);
    	$.ajax({
            url: "AssignManagerServlet",
            type: "POST",
            data: { empId: userIdString, managerId: managerId },
            success: function(response) {
                console.log("Manager assigned successfully:", response);
                
                loadUser();
            },
            error: function(error) {
                console.error("Error assigning manager:", error);
            }
        });
    }
    
    $("#userListBody").on("change", ".form-select", function() {
    	var userId = $(this).data("emp-id");
        var managerId = $(this).val();

        console.log("Assigning manager:");
        console.log("User ID: " + userId);
        console.log("Manager ID: " + managerId);

        $.ajax({
            url: "AssignManagerServlet",
            type: "POST",
            data: { empId: userId, managerId: managerId },
            success: function(response) {
                console.log("Manager assigned successfully:", response);
                Swal.fire({
            		title: "Manager Assigned",
            		icon: "success",
            		timer: 1500,
            		showConfirmButton: false
           		});
                loadUser();
            },
            error: function(error) {
                console.error("Error assigning manager:", error);
            }
        });
    })
  $("#userListBody").on("click", ".activeUser", function() {
    var empId = $(this).data("emp-id");
    var activeText = $(this).text();
    var isManager = $(this).data("ismanager");
	console.log(isManager);
    if (isManager == "" || isManager == "false") {
        $.ajax({
            url: "ActiveInactiveUserServlet",
            type: "POST",
            data: { empId: empId },
            dataType: "json",
            success: function(response) {
            	if(response.status === "success") {            		
	                if (activeText === "Active") {
	                    Swal.fire({
	                        title: "Employee has been set Inactive",
	                        icon: "success",
	                        timer: 1500,
	                        showConfirmButton: false
	                    });
	                } else {
	                    Swal.fire({
	                        title: "Employee has been set Active",
	                        icon: "success",
	                        timer: 1500,
	                        showConfirmButton: false
	                    });
	                }
            	}
            	else if(response.status === "error") {
            		Swal.fire({
                        title: "Employee has assets allocated",
                        icon: "error",
                        timer: 1500,
                        showConfirmButton: false
                    });
            	}
                loadUser();
            },
            error: function(xhr, status, error) {
                console.log(error);
            }
        });
    } else if (isManager === "true" || isManager === true) {
    	console.log("this is happening");
        Swal.fire({
            title: "This user is a manager",
            text: "Please change the managers of the users under them. If this user is set inactive, all users under them will have their managers set to None. Do you want to continue?",
            icon: "warning",
            showCancelButton: true,
            confirmButtonText: "Yes, proceed",
            cancelButtonText: "Cancel"
	        }).then((result) => {
	            if (result.isConfirmed) {
	                // User confirmed, proceed with the AJAX call
	                $.ajax({
	                    url: "ActiveInactiveUserServlet",
	                    type: "POST",
	                    data: { empId: empId },
	                    success: function() {
	                        if (activeText === "Active") {
	                            Swal.fire({
	                                title: "Manager has been set Inactive",
	                                icon: "success",
	                                timer: 1500,
	                                showConfirmButton: false
	                            });
	                        } else {
	                            Swal.fire({
	                                title: "Manager has been set Active",
	                                icon: "success",
	                                timer: 1500,
	                                showConfirmButton: false
	                            });
	                        }
	                        loadUser();
	                    },
	                    error: function(xhr, status, error) {
	                        console.log(error);
	                    }
	                });
	            } else {
	                // User canceled, do nothing
	                Swal.fire({
	                    title: "Action Canceled",
	                    icon: "info",
	                    timer: 1500,
	                    showConfirmButton: false
	                });
	            }
	        });
	    }
	
	    console.log(activeText);
	    console.log(empId);
	});

    function loadNumbers() {
    	$.ajax({
    		url: "GetNumberServlet",
    		type: "GET",
    		datatype: "json",
    		success: function(response) {
    			console.log(response);
    			$("#assetNumber").text(response.assetNumber);
    			$("#accessoryNumber").text(response.accessoryNumber);
    		},
    		error: function(xhr, status, error) {
    			console.log(error);
    		}
    	})
    	
    }
    loadNumbers();
    
    async function populateQuickAllocateAsset() {
    	var users = await getUsers();
    	
    	$.ajax({
            url: "GetRequestServlet", 
            type: "GET",
            dataType: "json",
            success: function(requests) {
            	$.ajax({
            		url: "ListAssetServlet",
            		dataType: "json",
            		type: "GET",
            		success: function(assets) {
		                var requestDiv = "";
		                var alertDiv = "";
		                var requestNumber = 0;
		                var indexQuick = 1;
		                var indexAlert = 1;
		                requests.forEach(function(request) {
		                	if(request.priority === "High" && request.status === "Accepted") {
		                		indexAlert++;
		                		var assetDesc = request.type === "Accessories"? request.accessories: request.type;
		                		var rowClass = indexAlert % 2 === 0 ? "bg-white" : "bg-body-secondary";
		                		alertDiv += "<tr class='col-12'>";
								var user = users.find(u => u.empId === request.empId);
		                        alertDiv += "<td class='col-md-6 text-truncate'><div> " + user.username +"</div><div class='text-muted extra-small-text'>#"+ user.empId + "</div></td>";
		                		alertDiv += "<td class='col-md-6'>" + assetDesc + "</td>";
		                		alertDiv += "</tr>";
		                	}
		                	if(request.status == "Accepted" && request.status != "Allocated") {
		                		console.log(request.status);
		                		indexQuick++;
		                		requestNumber++;
		                		
		                		var assetDesc = request.type === "Accessories"? request.accessories: request.type;
			                	let rowClass = indexQuick % 2 === 0 ? "bg-white" : "bg-body-secondary";
		                        requestDiv += "<tr>";
		                        var user = users.find(u => u.empId === request.empId);
		                        
		                        requestDiv += "<td class='col-md-4 text-truncate'>";
		                        requestDiv += "<div class='d-flex flex-column'>";
		                        requestDiv += "<span class='text-truncate' style='white-space: nowrap; margin-top'>" + user.username + "</span>";
		                        requestDiv += "<span class='text-muted extra-small-text' style='font-size: 0.85rem; white-space: nowrap;'>#" + user.empId + "</span>";
		                        requestDiv += "</div>";
		                        requestDiv += "</td>";		                        
		                        requestDiv += "<td class='col-md-2'>" + assetDesc + "</td>";
		                        if(request.priority === "High" && request.reqMsg != null && request.reqMsg != "") 
		                        	requestDiv += "<td class='col-md-1 popover-trigger' data-bs-toggle='popover' data-bs-title='Message' data-bs-content='" + request.reqMsg+ "' data-bs-trigger='hover' data-bs-html='true'>" + request.priority + "</td>";
	                        	else 
		                        	requestDiv += "<td class='col-md-1'>" + request.priority + "</td>";
		                        var assetFound = false;
		                        for(var i = 0; i<assets.length;i++) {
		                        	var asset = assets[i];
		                        	var matches = true;
		                            if(request.type !== asset.type) matches = false;
		         	                if (request.make && asset.make !== request.make) matches = false;
		                            if(asset.status === "Allocated") matches = false;
	                            	console.log("checking matches");
		                            if (matches) {
		                            	requestDiv += "<td class='col-md-3'>" +(asset.type === "Accessories"? asset.accessories: asset.make) + ", " + asset.assetNo + "</td>";
		                            	assetFound = true;
		                            	break;
		                            }
		                        }
		                        if(!assetFound) 
		                        	requestDiv += "<td class='col-md-3'>" +"None"+"</td>";
		                        requestDiv += "<td class='col-md-2'>";
		                        if(!assetFound)
		                        	requestDiv += "<button type='button' class='btn btn-secondary' disabled>Allocate</button>";
		                        else if(assetFound)
		                        	requestDiv += "<button type='button' class='btn btn-primary allocateBtn' data-req-id='"+ request.reqId +"' data-asset-no='"+ asset.assetNo+"'>Allocate</button>";
		                        requestDiv += "</td></tr>";
		                	}
		                	
		                })
		                $("#quickAllocateRequest").html(requestDiv);
		                $('[data-bs-toggle="popover"]').popover();
		                $("#requestNumber").text(requestNumber);
		                $("#alertDiv").html(alertDiv);
		                
            		},
            		error: function(xhr, status, error) {
            			console.log(error);
            		}
            	})
                
            },
            error: function(xhr, status, error) {
                console.log("Error fetching assets:", error);
            }
        });
    }
    populateQuickAllocateAsset();
    
    async function getUsers() {
    	return $.ajax({
    		url: "GetUserServlet",
    		type: "GET",
    		dataType: "json"
    	})
    }
   	$("#quickAllocateRequest").on("click", ".allocateBtn", function() {
   		var reqId = $(this).data("req-id");
   		var assetNo = $(this).data("asset-no");
   		var status = "Allocated";
        console.log(reqId);
        console.log(assetNo);
        $.ajax({
     		url: "AllocateAssetServlet", 
			type: "POST",
			data: {assetNo: assetNo, reqId: reqId, status: status},
			success: function() {
				Swal.fire({
            		title: "Asset Allocated",
            		icon: "success",
            		timer: 1500,
            		showConfirmButton: false
           		});
				populateQuickAllocateAsset();
			},
			error: function(xhr, status, error) {
			 	console.log(error);
			}
        })
	});
});
</script>
</head>
<body>
	<%@ include file="../navbar.jsp"%>
	<div class="main-content d-flex flex-column">
		<%
		if (session.getAttribute("isAdmin") != null) {
		%>
		<%
		if (session.getAttribute("isAdmin").equals("admin")) {
		%>
		<h2 class="p-2">Dashboard</h2>
		<div class="container-fluid d-flex justify-content-between">
			<div
				class="contanier-fluid bg-white d-flex col-3 p-4 rounded-2 shadow align-items-center">
				<div class="container col-4">
					<img
						src="<%=request.getContextPath()%>/images/dashboard-request-icon.png"
						class="w-100" alt="requests">
				</div>
				<div class="container d-flex flex-column">
					<p id="requestNumber" class="fw-bold fs-2 m-0">0</p>
					<!-- <span id="requestNumberSpan"></span> -->
					<p>Total Requests</p>
				</div>
			</div>
			<div
				class="contanier-fluid bg-white d-flex col-3 p-4 rounded-2 shadow align-items-center">
				<div class="container col-4">
					<img
						src="<%=request.getContextPath()%>/images/dashboard-asset-icon.png"
						class="w-100" alt="requests">
				</div>
				<div class="container d-flex flex-column">
					<p id="assetNumber" class="fw-bold fs-2 m-0">0</p>
					<!-- <span id="requestNumberSpan"></span> -->
					<p>Total Assets</p>
				</div>
			</div>
			<div
				class="contanier-fluid bg-white d-flex col-3 p-4 rounded-2 shadow align-items-center">
				<div class="container col-4">
					<img
						src="<%=request.getContextPath()%>/images/dashboard-accessory-icon.png"
						class="w-100" alt="requests">
				</div>
				<div class="container d-flex flex-column">
					<p id="accessoryNumber" class="fw-bold fs-2 m-0">0</p>
					<!-- <span id="requestNumberSpan"></span> -->
					<p>Total Accessories</p>
				</div>
			</div>
		</div>


		<div class="container-fluid d-flex my-5 justify-content-between">
			<div
				class="container-fluid bg-white col-7 m-0 px-4 rounded shadow align-self-start">
				<p class="fw-bold fs-5 p-2">Quick Allocate</p>
				<div class="col-12">
					<table class="table table-striped rounded-table">
						<thead>
							<tr>
								<th>Employee</th>
								<th>Asset Desc</th>
								<th>Priority</th>
								<th>Top Asset</th>
								<th>Allocate</th>
							</tr>
						</thead>
						<tbody id="quickAllocateRequest">

						</tbody>
					</table>
				</div>
			</div>
			<div
				class="container bg-white col-4 m-0 px-4 shadow rounded align-self-start">
				<p class="fw-bold fs-5 p-2">Alerts</p>
				<div class="col-12">
					<table id="quickAllocateRequest" class="table table-striped rounded-table">
						<thead>
							<tr>
								<th>Employee Name</th>
								<th>Asset Desc</th>
								
							</tr>
						</thead>
						<tbody id="alertDiv">

						</tbody>
					</table>
				</div>
			</div>
		</div>
		<%
		}
		%>
		<%
		}
		%>

		<%
		if (session.getAttribute("isAdmin") != null && session.getAttribute("isAdmin").equals("superAdmin")) {
		%>
		<div class="container-fluid">
			<h2>Dashboard</h2>
			<div class="container-fluid p-4 bg-white border rounded">
				<div class="mb-3 d-flex justify-content-between align-items-center">
				    <div class="d-flex align-items-center">
				        <span class="fa fa-search form-control-feedback me-2"></span>
				        <input type="text" id="searchInput" class="form-control" placeholder="Search by username or ID">
				    </div>
				    <div class="float-end">
				        <button id="filterAll" class="btn btn-outline-primary me-2">All Users</button>
				        <button id="filterManagers" class="btn btn-outline-primary me-2">Managers</button>
				        <button id="filterActive" class="btn btn-outline-success me-2">Active Users</button>
				        <button id="filterInactive" class="btn btn-outline-danger">Inactive Users</button>
				    </div>
				</div>
				<div class="col-md-12">
					<table class="table table-striped rounded-table">
						<thead>
							<tr>
								<th>Profile</th>
								<th>Employee Id</th>
								<th>Employee Name</th>
								<th>Role</th>
								<th>Manager</th>
								<th>Active/Inactive</th>
							</tr>
						</thead>
						<tbody id="userListBody">

						</tbody>
					</table>
				</div>
			</div>
		</div>
		<%
		}
		%>
	</div>
	<div id="editManagerDiv" style="display: none;">
		<button class="close-btn">&times;</button>
		<form id="editManagerForm">
			<div class="d-flex flex-wrap">
				<div class="col-md-4 mx-4 my-3" id="currManagerDiv">
					<label for="currManager" class="form-label">Current Manager</label>
					<input type="text" id="currManager" name="currManager"
						class="form-control" placeholder="Current Manager" disabled>
				</div>

				<div class="col-md-4 mx-4 my-3" id="newManagerDiv">
					<label for="newManager" class="form-label">New Manager</label>
				</div>

				<!-- User List -->
				<div class="col-md-12 mx-4 my-3" id="userListDiv">
					<label for="userList" class="form-label">Users Under
						Current Manager</label>
					<div id="userList" class="form-control overflow-auto"
						style="height: 200px; padding: 10px; width: 500px">
					</div>
				</div>

				<div class="col-md-4 mx-4 my-3 mt-4 align-self-center text-center">
					<button type="button" class="btn btn-primary" id="saveBtn">Save</button>
				</div>
			</div>
		</form>
	</div>

</body>
</html>
