<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Add New Asset</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
	<style>
		
		#dashboard-item {
            background-color: #E2EBFD;			
		}
		#dashboard-item a {
			color: #0056b3;
		}
		.table-striped {
			border: white;
		}
		#userTable
		#userTableBody tr {
			border-radius: 10px;
		}
		#searchInput {
		  max-width: 300px;
		}
		
		#searchButton {
		  display: inline-block;
		}
		
		
	</style>
<script>
function assignManager(userId, managerId) {
    $.ajax({
        url: "AssignManagerServlet",
        type: "POST",
        data: { userId: userId, managerId: managerId },
        
        success: function(response) {
            console.log("Manager assigned successfully:", response);
        },
        error: function(error) {
            console.error("Error assigning manager:", error);
        }
    });
}
$(document).ready(function(){
	$("#searchButton").on("click", function() {
        var searchTerm = $("#searchInput").val().toLowerCase();
        console.log(searchTerm);
       	var usernameDiv = $(".username");
        $(".username").each(function() {
			var username = $(this).text().toLowerCase();
			console.log(username);
        	if (username.includes(searchTerm)) {
	        	console.log("is the table check happening?");
                $(this).parents(".row").show();
            } else {
                $(this).parents(".row").hide();
            }
        });
    });

    function updateFieldVisibility() {
        var type = $("#type").val();
        if (type === "Server" || type === "Printer" || type === "Others") {
            $("#processorField, #ramField, #osField, #hddField, #graphicField").hide();
            $("#makeField, #modelField").show();
            $("#graphics, #hdd, #model, #processor, #ram, #os").removeAttr("required");
        }
        else if (type === "Accessories") {
            $("#makeField, #modelField, #processorField, #assetNoField, #serialNoField, #ramField, #osField, #hddField, #graphicField").hide();
            $("#make, #model, #processor, #assetNo, #serialNo, #ram, #os, #hdd, #graphics").removeAttr("required");
        	$("#wiredField, #accessoryField").show();
        }
        else {
            $("#makeField, #modelField, #processorField, #ramField, #osField", ).show();
            $("#makeField, #modelField, #processorField, #assetNoField, #serialNoField, #ramField, #osField, #hddField, #graphicField").show();
            $("#wiredField, #accessoryField").hide();
            $("#wired, #accessory").removeAttr("required");
            $("#make, #model, #processor").attr("required", "required");
        }
    }


    updateFieldVisibility();
    $("#type").change(updateFieldVisibility);

    $("#addAssetForm").on("submit", function(event){
        event.preventDefault(); 
        var type = $("#type").val();
        if(type === "Accessories") {
        	$.ajax({
        		url: "AddAccessoryServlet",
        		type: "POST",
        		data: $(this).serialize(),
        		success : function(response) {
        			loadAccessoryList();
        		},
        		error: function(xhr, status, error) {
        			alert("error: " + error);
        		}
        	})
        }
        else {        	
	        $.ajax({
	            url: "AddAssetServlet",
	            type: "POST",
	            data: $(this).serialize(),
	            success: function(response){
	             	console.log("testing: load asset ajax");
	                loadAssetList();
	            },
	            error: function(xhr, status, error){
	                alert("Error: " + error);
	            }
	        });
        }
    });

    loadAssetList();
    loadAccessoryList();

    function loadAssetList() {
        $.ajax({
            url: "ListAssetServlet",
            type: "GET",
            dataType: "json",
            success: function(data){
                var table = "<table border='1'><tr><th>Asset No</th><th>Serial No</th><th>Type</th><th>Make</th><th>Model</th><th>Processor</th><th>RAM</th><th>HDD</th><th>Graphics</th><th>OS</th><th>Status</th><th>EmpId</th><th>Action</th></tr>";
                $.each(data, function(index, asset){
                    table += "<tr>";
                    table += "<td>" + asset.assetNo + "</td>";
                    table += "<td>" + asset.serialNo + "</td>";
                    table += "<td>" + asset.type + "</td>";
                    table += "<td>" + asset.make + "</td>";
                    table += "<td>" + asset.model + "</td>";
                    table += "<td>" + asset.processor + "</td>";
                    table += "<td>" + asset.ram + "</td>";
                    table += "<td>" + asset.hdd + "</td>";
                    table += "<td>" + asset.graphics + "</td>";
                    table += "<td>" + asset.os + "</td>";
                    table += "<td>" + asset.status + "</td>";
                    table += "<td>" + asset.empId + "</td>";
                    table += "<td><button class='deleteBtn' data-assetno='" + asset.assetNo + "'>Delete</button></td>";
                    table += "</tr>";
                });
                table += "</table>";
                $("#assetList").html(table);
            },
            error: function(xhr, status, error){
                alert("Error: " + error);
            }
        });
    }
    
    function loadAccessoryList() {
    	$.ajax({
    		url: "ListAccessoryServlet",
    		type: "GET", 
    		dataType: "json",
    		success: function(data) {
    			var table ="<table border='1'><tr><th>Accessory ID</th><th>Accessory</th><th>Wired</th><th>Status</th><th>EmpId</th>";
    			$.each(data, function(index, accessory){
    				table += "<tr>";
                    table += "<td>" + accessory.accessoryId + "</td>";
                    table += "<td>" + accessory.accessory + "</td>";
                    table += "<td>" + accessory.wired + "</td>";
                    table += "<td>" + accessory.status + "</td>";
                    table += "<td>" + accessory.empId + "</td>";
                    table += "<td><button class='deleteBtn' data-accessoryno='" + accessory.accessoryId + "'>Delete</button></td>";
                    table += "</tr>";
    			})
    			table += "</table>";
    			$("#accessoryList").html(table);
    		},
    		error: function(xhr, status, error) {
    			alert("error: " + error);
    		}
    	})
    }

    $("#assetList").on("click", ".deleteBtn", function(){
        var assetNo = $(this).data("assetno");
        $.ajax({
            url: "DeleteAssetServlet",
            type: "POST",
            data: { assetNo: assetNo },
            success: function(response){
                loadAssetList();
            },
            error: function(xhr, status, error){
                alert("Error: " + error);
            }
        });
    });
    
    $("#accessoryList").on("click", ".deleteBtn", function() {
    	var accessoryId = $(this).data("accessoryno");
    	$.ajax({
    		url: "DeleteAccessoryServlet",
    		type: "POST",
    		data: {accessoryId: accessoryId},
    		success: function(response) {
    			loadAccessoryList();
    		},
    		error: function(xhr, status, error) {
    			alert("error: " + error);
    		}
    	})
    })
    
    
    
    
    function loadUser() {
        $.ajax({
            url: "GetUserServlet",
            type: "GET",
            dataType: "json",
            success: function(users) {
                var userRows = "";
                users.forEach((user, index) => {
                    if (user.isAdmin == null) {
                        let rowClass = index % 2 === 0 ? "bg-white" : "bg-body-secondary";
                        userRows += "<div class='row "+rowClass+" rounded p-2 mb-2'>";
                        userRows += "<div class='col-md-3'> " + user.empId + "</div>";
                        userRows += "<div class='col-md-3 username'>" + user.username + "</div>";
                        userRows += "<div class='col-md-3'>" + user.isManager + "</div>";
                        userRows += "<div class='col-md-3'>";
                        userRows += "<select class='form-select' onchange='assignManager(\""+user.empId+"\", this.value)'>";
                        userRows += "<option value=''>None</option>";
                        users.forEach(manager => {
                            if (manager.empId != user.empId) {
                                let selected = manager.empId === user.manager ? "selected" : "";
                                userRows += "<option value='"+manager.empId+"'" + selected + ">"+manager.username+"</option>";
                            }
                        });
                        userRows += "</select></div></div>";
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
    function populateAssetDropdown(request) {
        $.ajax({
            url: "ListAssetServlet", 
            type: "GET",
            dataType: "json",
            success: function(assets) {
                var dropdown = $("select.assetDropdown[data-requestid='" + request.reqId + "']");
                assets.forEach(function(asset) {
                    var matches = true;
                    
                    if(asset.status === "Allocated") matches = false;
	                if (request.make && asset.make !== request.make) matches = false;
                    if (matches) {
                        dropdown.append("<option value='" + asset.assetNo + "'>" + asset.make + " " + asset.model + "</option>");
                    }
                });
            },
            error: function(xhr, status, error) {
                console.log("Error fetching assets:", error);
            }
        });
    }

    function fetchRequests() {
        $.ajax({
            url: "GetRequestServlet", 
            type: "GET",
            dataType: "json",
            success: function(response) {
                // console.log(response);
                populateRequests(response);
                response.forEach(function(request) {
                    populateAssetDropdown(request);
                });
            },
            error: function(xhr, status, error) {
                console.log(error);
            }
        });
        
    }
    

    function populateRequests(requests) {
    	var requestField = $("#requestField");
        requestField.empty(); 

        requests.forEach(function(request) {
        	
        	if(request.status == "accepted") {
        		console.log("testing : admin requests");
        		var description = request.type + ": " +
                "OS: " + request.os + ", " +
                "Make: " + request.make + ", " +
                "Model: " + request.model + ", " +
                "HDD: " + request.hdd + ", " +
                "RAM: " + request.ram + ", " +
                "Graphics: " + request.graphics + ", " +
                "Accessories: " + request.accessories + ", " +
                "Wired: " + request.wired + ", " +
                "Priority: " + request.priority;

        		var requestDiv = "<div class='request' data-id='" + request.reqId + "'>" +
        	    "<p>" + description + "</p>" +
        	    "<p>Status: " + request.status + "</p>" +
        	    "<select class='assetDropdown' data-requestid='" + request.reqId + "'>" +
        	    "<option value=''>Select Asset</option>" +
        	    "</select>" +
        	    "<button class='allocate-btn'>Allocate</button>" +
        	    "<button class='cancel-btn'>Cancel</button>" +
        	    "</div>";
            	requestField.append(requestDiv);
        	}
        	
            
        });
        $(".allocate-btn").on("click", function() {
        	console.log("testing allocation button");
        	var requestId = $(this).closest('.request').data('id');
            var assetNo = $(this).siblings("select.assetDropdown").val();
            var status = "Allocated";
    		console.log(status);
    		console.log(assetNo);
    		
            if (!assetNo) {
                alert("Please select an asset to allocate.");
                return;
            }
        	
            $.ajax({
                url: "AllocateAssetServlet", 
                type: "POST",
                data: { requestId: requestId, assetNo: assetNo, status: status },
                success: function(response) {
                    console.log("Asset allocated successfully:", response);
                    loadAssetList();
                    fetchRequests();
                },
                error: function(xhr, status, error) {
                    console.log("Error allocating asset:", error);
                }
            });
    		
        });
	
        $(".cancel-btn").on("click", function() {
        	console.log("testing cancel button");
        	var requestId = $(this).closest('.request').data('id');
            var assetNo = $(this).siblings("select.assetDropdown").val();
            var status = "Cancelled";
    		console.log(requestId);
    		
        	
            $.ajax({
                url: "AllocateAssetServlet",
                type: "POST",
                data: { requestId: requestId, assetNo: assetNo, status: status },
                success: function(response) {
                    console.log("Request Cancelled successfully:", response);
                    
                    fetchRequests();
                },
                error: function(xhr, status, error) {
                    console.log("Error cancelling request:", error);
                }
            });
    		
        });
        
    }

    fetchRequests();
	
});
</script>
</head>
<body>
    <%@include file="/navbar.jsp"%>
    <div class="main-content">
		<% if (session.getAttribute("isAdmin") != null) { %>
		    <% if (session.getAttribute("isAdmin").equals("admin")) { %>
	        	<div class="col">
					<h2>Add New Asset</h2>
					<form id="addAssetForm" class="mb-4">
					    <div class="row mb-2" id="assetNoField">
					        <label for="assetNo" class="col-form-label">Asset No:</label>
					        <input type="text" id="assetNo" name="assetNo" class="form-control" required>
					    </div>
					    <div class="row mb-2" id="serialNoField">
					        <label for="serialNo" class="col-form-label">Serial No:</label>
					        <input type="text" id="serialNo" name="serialNo" class="form-control" required>
					    </div>
					    <button type="submit" class="btn btn-primary">Add Asset</button>
					</form>
					
					<h3>Assets</h3>
					<div id="assetList" class="table-responsive mb-4">
					
					</div>
					<h3>Accessories</h3>
					<div id="accessoryList" class="table-responsive mb-4">
					</div>
					
					<h3>Requests</h3>
					<div id="requestField" class="table-responsive mb-4">
					
					</div>
            	</div>
             <% } %>
          <% } %>
          
          <% if (session.getAttribute("isAdmin") != null && session.getAttribute("isAdmin").equals("superAdmin")) { %>
			<div class="container-fluid">
				<h2>Dashboard</h2>
				<div class="container-fluid p-4 bg-white border rounded">
					<div class="mb-3">
                        <input type="text" id="searchInput" class="form-control" placeholder="Search by username">
                        <button id="searchButton" class="btn btn-primary mt-2">Search</button>
                    </div>
					<div id="userListContainer" class="container-fluid">
					    <!-- User List Header -->
					    <div class="row font-weight-bold rounded p-2 mb-2 d-none d-md-flex">
					        <div class="col-md-3">Employee ID</div>
					        <div class="col-md-3">Username</div>
					        <div class="col-md-3">Is Manager</div>
					        <div class="col-md-3">Assign Manager</div>
					    </div>
					
					    <div id="userListBody">
					    
					    </div>
					</div>  	
				</div>
			</div>
        <% } %>
    </div>
</body>
</html>
