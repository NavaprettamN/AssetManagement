<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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
	
  #editDiv {
      position: fixed;
      background: #fff;
      left: 30%;
      border-radius: 8px;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
      z-index: 1000; 
      padding: 20px;
      max-width: 600px;
      width: 100%;
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
  .profile-pic-container {
   		width: 100%;
	    display: flex;
	    justify-content: center;
	    align-items: center;
	}
	
	.profile-pic-container img {
	    width: 50px;  
	    height: 50px;
	    border-radius: 50%; 
	    object-fit: cover;
	}
	.tooltip-box {
	    position: absolute;
	    background: #000;
	    color: #fff;
	    padding: 5px 10px;
	    border-radius: 5px;
	    z-index: 1000;
	    font-size: 12px;
	    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
	    white-space: nowrap;
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
	
	.popover {
	    opacity: 0;
	    transform: translateY(-10px);
	    transition: opacity 0.3s ease, transform 0.3s ease;
	}
	
	.popover.show {
	    opacity: 1;
	    transform: translateY(0); 
	}
</style>
	<title>Insert title here</title>
</head>
<body>
	<%@ include file="../navbar.jsp" %>
	<div class="main-content d-flex flex-column">		
		<h2 class="p-2">Assets</h2>
		<div class="container-fluid bg-white">
			<div class="container-fluid m-3 d-flex">
				<div class="col-2 mx-3">				
					<label for="type">Type</label>
					<select name ="type" id="type" class="form-select col-8">
						<option value="asset" selected>Asset</option>
						<option value="accessory">Accessory</option>
					</select>			
				</div>
				<div class="col-2 mx-3" id="descriptionDiv">				
					<label for="description">Description</label>
					<select name ="description" id="description" class="form-select col-8">
						<option value="details" selected>Details</option>
						<option value="allocation">Allocation Details</option>
					</select>			
				</div>
				<div class="col-2 mx-3" id="accessoryTypeFilterDiv">				
					<label for="accessoryTypeFilter">Accessory Type</label>
					<select name ="accesoryTypeFilter" id="accessoryTypeFilter" class="form-select col-8">
						<option value="All" selected>All</option>
						<option value="Mouse">Mouse</option>
						<option value="Keyboard">Keyboard</option>
						<option value="Headphones">Headphones</option>
						<option value="Others">Others</option>
					</select>			
				</div>
				<div class="col-2 mx-3" id="searchDiv">
					<label for="searchInput">Search</label>
					<input type="text" id="searchInput" class="form-control me-2" placeholder="Search by Asset No">
				</div>
				<div class="col-4" id="filterDiv">
					<label for="filterDiv">Filters</label>
					<div id="filterInnerDiv">					
					    <button id="filterAll" class="btn btn-outline-primary me-2 px-4">All</button>
					    <button id="filterAllocated" class="btn btn-outline-success me-2">Allocated</button>
					    <button id="filterNotAllocated" class="btn btn-outline-danger">Not Allocated</button>
					</div>
                </div>
			</div>
			<table class="table table-striped rounded-table">
				<thead>
					<tr class="fw-bold rounded p-2 mb-2" id="assetDetail">
						<th class="col-md-1">Asset No</th>
				        <th class="col-md-1">Serial No</th>
				        <th class="col-md-1">Type</th>
				        <th class="col-md-1">Make</th>
				        <th class="col-md-1">Model</th>
				        <th class="col-md-1">Processor</th>
				        <th class="col-md-1">RAM</th>
				        <th class="col-md-1">OS</th>
				        <th class="col-md-1">HDD</th>
				        <th class="col-md-1">Graphics</th>
				        <th class="col-md-2">Delete</th>
					</tr>
					<tr class="fw-bold rounded p-2 mb-2" id="assetAllocationDetail">
				        <th class="col-md-1">Asset No</th>
				        <th class="col-md-1">Serial No</th>
				        <th class="col-md-1">Type</th>
				        <th class="col-md-1">Make</th>
				        <th class="col-md-1">Model</th>
				        <th class="col-md-2">Status</th>
				        <th class="col-md-2">Assigned</th>
				        <th class="col-md-1">Edit</th>
				        <th class="col-md-2">Delete</th>
				    </tr>
				    <tr class="fw-bold rounded p-2 mb-2" id="accessoryDetail">
				        <th class="col-md-2">Type</th>
				        <th class="col-md-2">Wired</th>
				        <th class="col-md-2">Status</th>
				        <th class="col-md-3">Assigned</th>
				        <th class="col-md-1">Edit</th>
				        <th class="col-md-2">Delete</th>
				    </tr>
				</thead>
				<tbody id="listAssetDiv">
	
				</tbody>
			</table>
		</div>
		
		<div id="editDiv" style="display: none;">
    		<button class="close-btn">&times;</button>
             <form id="editForm">
                 <div class="d-flex flex-wrap"> 
                     <div class="col-md-4 mx-4 my-3" id="allocationField">
                         <label for="type" class="form-label">Allocation</label>
                         <select id="allocationSelect" name="allocation" class="form-select">
                         	
                         </select>
                     </div>
                     <div class="col-md-4 mx-4 my-3" id="typeField">
                         <label for="type" class="form-label">Type</label>
                         <input type="text" id="assetType" name="type" class="form-control" placeholder="Enter Type">
                     </div>
                     <div class="col-md-4 mx-4 my-3" id="serialNoField">
                         <label for="serialNo" class="form-label">Serial No</label>
                         <input type="text" id="serialNo" name="serialNo" class="form-control" placeholder="Enter Serial No">
                     </div>
                     <div class="col-md-4 mx-4 my-3" id="assetNoField">
                         <label for="assetNo" class="form-label">Asset Number</label>
                         <input type="text" id="assetNo" name="assetNo" class="form-control" placeholder="Enter Asset No">
                     </div>
                     <div class="col-md-4 mx-4 my-3" id="modelField">
                         <label for="model" class="form-label">Model</label>
                         <input type="text" id="model" name="model" class="form-control" placeholder="Enter the Model">
                     </div>
                     <div class="col-md-4 mx-4 my-3" id="makeField">
                         <label for="make" class="form-label">Make</label>
                         <input type="text" id="make" name="make" class="form-control" placeholder="Asset Company">
                     </div>
                     <div class="col-md-4 mx-4 my-3" id="processorField">
                         <label for="processor" class="form-label">Processor</label>
                         <input type="text" id="processor" name="processor" class="form-control" placeholder="Enter the Processor">
                     </div>
                     <div class="col-md-4 mx-4 my-3" id="ramField">
                         <label for="ram" class="form-label">RAM</label>
                         <input type="text" id="ram" name="ram" class="form-control" placeholder="Enter the RAM">
                     </div>
                     <div class="col-md-4 mx-4 my-3" id="osField">
                         <label for="os" class="form-label">OS</label>
                         <input type="text" id="os" name="os" class="form-control" placeholder="Enter the OS">
                     </div>
                     <div class="col-md-4 mx-4 my-3" id="hddField">
                         <label for="hdd" class="form-label">HDD</label>
                         <input type="text" id="hdd" name="hdd" class="form-control" placeholder="Enter the HDD">
                     </div>
                     <div class="col-md-4 mx-4 my-3" id="graphicField">
                         <label for="graphics" class="form-label">Graphics</label>
                         <input type="text" id="graphics" name="graphics" class="form-control" placeholder="Enter the Graphics">
                     </div>
                    <div class="col-md-4 mx-4 my-3" id="accessoryTypeField">
                         <label for="accessoryType" class="form-label">Accessory</label>
                         <input type="text" id="accessoryType" name="accessoryType" class="form-control" placeholder="Enter the accessoryType">
                     </div>
                     <div class="col-md-4 mx-4 my-3" id="wiredField">
                         <label for="wired" class="form-label">Wired</label>
                         <input type="text" id="wired" name="wired" class="form-control" placeholder="wired">
                     </div>
                  <div class=" col-md-4 mx-4 my-3 mt-4 align-self-center text-center">
                      <button type="button" class="btn btn-primary" id="saveBtn">Save</button>
                  </div>
                 </div>
             </form>    
         </div>
	</div>
	<script>
		$(document).ready(function() {
			$('[data-bs-toggle="popover"]').popover();
			$("#editDiv").hide();
			$("body").append('<div class="blur-overlay" style="display:none;"></div>');
			
			$("#searchInput").on("keyup", function() {
			    var searchTerm = $(this).val().toLowerCase();
			    listAsset('', searchTerm); // Always pass the search term to the function
			});

			$("#filterAll").on("click", function() {
			    var searchTerm = $("#searchInput").val().toLowerCase(); // Capture current search term
			    listAsset('', searchTerm); // Pass search term with no filter
			});

			$("#filterAllocated").on("click", function() {
			    var searchTerm = $("#searchInput").val().toLowerCase(); // Capture current search term
			    listAsset("allocated", searchTerm); // Pass "allocated" filter with search term
			});

			$("#filterNotAllocated").on("click", function() {
			    var searchTerm = $("#searchInput").val().toLowerCase(); // Capture current search term
			    listAsset("not allocated", searchTerm); // Pass "not allocated" filter with search term
			});

			$("#accessoryTypeFilter").on("change", function() {
				var filter = $("#accessoryTypeFilter").val();
			    listAsset('', ''); // Trigger listAsset with no filter but with search term
			});

			async function listAsset(filter = '', searchTerm = '') {
			    var type = $("#type").val();
			    var description = $("#description").val();
			    var accessoryType = $("#accessoryTypeFilter").val().toLowerCase();

			    console.log(accessoryType);
			    var users = await getUsers(); 

			    var filteredAssets = [];
			    if(type === "asset") {
			        $.ajax({
			            url: "ListAssetServlet",
			            type: "GET",
			            dataType: "json",
			            success: function(assets) {
			                if(description === "details") { 
			                    // Filter assets based on search term, allocated status, and accessory type
			                    filteredAssets = assets.filter(function(asset) {
			                        var assetNoMatch = asset.assetNo.toLowerCase().includes(searchTerm);
			                        console.log("asset match", assetNoMatch);
			                        var statusMatch = (filter === '' || asset.status.toLowerCase() === filter);
			                        var typeMatch = (accessoryType === 'all' || asset.type.toLowerCase() === accessoryType);

			                        return assetNoMatch && statusMatch && typeMatch;
			                    });
			                    
			                    console.log("filtered assets : ", filteredAssets);

			                    var assetDiv = "";
			                    filteredAssets.forEach(function(asset, index) {
			                        var rowClass = index % 2 === 0 ? "bg-white" : "bg-body-secondary";
			                        assetDiv += "<tr class='col-12 "+rowClass+" rounded p-2 m-2'>";
			                        assetDiv += "<td class='col-md-1 assetNo'>"+ asset.assetNo + "</td>";
			                        assetDiv += "<td class='col-md-1'>"+ asset.serialNo + "</td>";
			                        assetDiv += "<td class='col-md-1'>"+ asset.type + "</td>";
			                        assetDiv += "<td class='col-md-1'>"+ asset.make + "</td>";
			                        assetDiv += "<td class='col-md-1'>"+ asset.model + "</td>";
			                        assetDiv += "<td class='col-md-1'>"+ asset.processor + "</td>";
			                        assetDiv += "<td class='col-md-1'>"+ asset.ram + "</td>";
			                        assetDiv += "<td class='col-md-1'>"+ asset.os + "</td>";
			                        assetDiv += "<td class='col-md-1'>"+ asset.hdd + "</td>";
			                        assetDiv += "<td class='col-md-1'>"+ asset.graphics + "</td>";
			                        if(asset.empId != '') {
			                            assetDiv += "<td class='col-md-2'>"+ "<button class='btn btn-danger rounded-circle shadow-none border border-danger-subtle' data-asset-no='"+asset.assetNo+"' type='button' disabled" + "><i class='bi bi-trash'></i></button></td>";
			                        }
			                        else {
			                            assetDiv += "<td class='col-md-2'>"+ "<button class='btn btn-danger rounded-circle shadow border border-danger deleteBtn' data-asset-no='"+asset.assetNo+"' type='button'" + "><i class='bi bi-trash'></i></button></td>";										
			                        }
			                        assetDiv += "</tr>";
			                    });
			                }
			                else if (description === "allocation") {
			                    filteredAssets = assets.filter(function(asset) {
			                        var assetNoMatch = asset.assetNo.toLowerCase().includes(searchTerm);
			                        console.log("asset no match : ", assetNoMatch);
			                        var statusMatch = (filter === '' || asset.status.toLowerCase() === filter);
			                        var typeMatch = (accessoryType === 'all' || asset.type.toLowerCase() === accessoryType);
									console.log("overall: ", assetNoMatch && statusMatch && typeMatch);
			                        return assetNoMatch && statusMatch && typeMatch;
			                    });
								
			                    console.log("filtered  assets : ", filteredAssets);
			                    
			                    var assetDiv = "";
			                    var contextPath = "<%=request.getContextPath() %>";
			                    filteredAssets.forEach(function(asset, index) {
			                        var rowClass = index % 2 === 0 ? "bg-white" : "bg-body-secondary";
			                        assetDiv += "<tr class='col-12 rounded p-2 m-2'>";
			                        assetDiv += "<td class='col-md-1 assetNo'>"+ asset.assetNo + "</td>";
			                        assetDiv += "<td class='col-md-1'>"+ asset.serialNo + "</div>";
			                        assetDiv += "<td class='col-md-1'>"+ asset.type + "</td>";
			                        assetDiv += "<td class='col-md-1'>"+ asset.make + "</td>";
			                        assetDiv += "<td class='col-md-1'>"+ asset.model + "</td>";
			                        assetDiv += "<td class='col-md-2 status'>"+ asset.status + "</td>";
			                        if(asset.empId != "") {
			                            const user = users.find(u => u.empId === asset.empId);
			                            var popoverContent = "<div class=\"popover-content\">" +"<div class=\"text-center\">" +
			                                "<img src=\"" + contextPath + "/" + user.profilePic + "\" alt=\"Profile Picture\" class=\"img-fluid rounded-circle mb-3\" style=\"width: 100px; height: 100px;\" />" + 
			                                "<h5>" + user.username + "</h5>" + 
			                                "</div>" +
			                                "<p><strong>Employee Id:</strong> " + user.empId + "</p>" +
			                                "<p><strong>Department:</strong> " + user.department + "</p>" +
			                                "<p><strong>Mail Id:</strong> " + user.empMail + "</p>";

			                            if (user.manager) {
			                                popoverContent += "<p><strong>Manager:</strong> " + user.manager + "</p>";
			                            }

			                            popoverContent += "</div>";
			                            assetDiv += "<td class='col-md-2 popover-trigger' data-bs-toggle='popover' data-bs-title='"+ user.username + "' data-bs-content='" + popoverContent+ "' data-bs-trigger='hover' data-bs-html='true'>"+ user.username+ "</td>";
			                        }
			                        else {
			                            assetDiv += "<td class='col-md-2'>"+ asset.empId + "</td>";										
			                        }
			                        assetDiv += "<td class='col-md-1'>"+ "<button class='btn btn-primary rounded-circle shadow editBtn' data-asset-no='"+asset.assetNo+"' type='button'><i class='bi bi-pencil'></i></button></td>";
			                        if(asset.empId != "") {
			                            assetDiv += "<td class='col-md-2'>"+ "<button class='btn btn-danger rounded-circle shadow-none border border-danger-subtle' data-asset-no='"+asset.assetNo+"' type='button' disabled" + "><i class='bi bi-trash'></i></button></td>";
			                        }
			                        else {
			                            assetDiv += "<td class='col-md-2'>"+ "<button class='btn btn-danger rounded-circle shadow border border-danger deleteBtn' data-asset-no='"+asset.assetNo+"' type='button'" + "><i class='bi bi-trash'></i></button></td>";										
			                        }
			                        assetDiv += "</tr>";
			                    });
			                }
			                $("#listAssetDiv").html(assetDiv);
			                $('[data-bs-toggle="popover"]').popover();
			            },
			            error: function(xhr, status, error) {
			                console.log(error);
			            }
			        });
			    }
			    else if(type === "accessory") {
			        $.ajax({
			            url: "ListAccessoryServlet",
			            type: "GET", 
			            dataType: "json",
			            success: function(accessories) {
			                var accessoryDiv = "";
			                var contextPath = "<%=request.getContextPath() %>";

			                filteredAssets = accessories.filter(function(accessory) {
			                    var statusMatch = (filter === '' || accessory.status.toLowerCase() === filter);
			                    var typeMatch = (accessoryType === 'all' || accessory.accessory.toLowerCase() === accessoryType);

			                    return  statusMatch && typeMatch;
			                });

			                filteredAssets.forEach(function(accessory, index) {
			                    var rowClass = index % 2 === 0 ? "bg-white" : "bg-body-secondary";
			                    accessoryDiv += "<tr class='col-12 rounded m-2 p-2'>";
			                    accessoryDiv += "<td class='col-md-2 type'>"+ accessory.accessory +"</td>";
			                    accessoryDiv += "<td class='col-md-2'>"+ accessory.wired +"</div>";
			                    accessoryDiv += "<td class='col-md-2 status'>"+ accessory.status +"</td>";
			                    if(accessory.empId != '') {
			                        const user = users.find(u => u.empId === accessory.empId);
			                        var popoverContent = "<div class=\"popover-content\">" +"<div class=\"text-center\">" +
			                            "<img src=\"" + contextPath + "/" + user.profilePic + "\" alt=\"Profile Picture\" class=\"img-fluid rounded-circle mb-3\" style=\"width: 100px; height: 100px;\" />" + 
			                            "<h5>" + user.username + "</h5>" + 
			                            "</div>" +
			                            "<p><strong>Employee Id:</strong> " + user.empId + "</p>" +
			                            "<p><strong>Department:</strong> " + user.department + "</p>" +
			                            "<p><strong>Mail Id:</strong> " + user.empMail + "</p>";

			                        if (user.manager) {
			                            popoverContent += "<p><strong>Manager:</strong> " + user.manager + "</p>";
			                        }

			                        popoverContent += "</div>";
			                        accessoryDiv += "<td class='col-md-2 popover-trigger' data-bs-toggle='popover' data-bs-title='"+ user.username + "' data-bs-content='" + popoverContent + "' data-bs-trigger='hover' data-bs-html='true'>" + user.username + "</td>";
			                    }
			                    else {
			                        accessoryDiv += "<td class='col-md-2'>"+ accessory.empId + "</td>";										
			                    }
			                    
		                    	accessoryDiv += "<td class='col-md-2'>"+ "<button class='btn btn-primary rounded-circle shadow editBtnAccessory' data-asset-no='"+accessory.accessory+"' type='button'" + "><i class='bi bi-pencil'></i></button></td>";
			                    
			                    if(accessory.empId == '')
			                    	accessoryDiv += "<td class='col-md-2'>"+ "<button class='btn btn-danger rounded-circle shadow-none border border-danger-subtle deleteBtnAccessory' data-accessory-id='"+accessory.accessoryId+"' type='button'" + "><i class='bi bi-trash'></i></button></td>";
		                    	else
			                    	accessoryDiv += "<td class='col-md-2'>"+ "<button class='btn btn-danger rounded-circle shadow border border-danger deleteBtnAccessory disabled' data-accessory-id='"+accessory.accessoryId+"' type='button'" + "><i class='bi bi-trash'></i></button></td>";
			                    
		                    	accessoryDiv += "</tr>";
			                });

			                $("#listAssetDiv").html(accessoryDiv);
			                $('[data-bs-toggle="popover"]').popover();
			            },
			            error: function(xhr, status, error) {
			                console.log(error);
			            }
			        });
			    }
			}
			listAsset();
			
			async function getUsers() {
				return $.ajax({
					url: "GetUserServlet",
					type: "GET",
					dataType: "json",
				})
			}
			
			
			$("#listAssetDiv").on("click", ".editBtn", function () {
				var assetNo = $(this).data('asset-no');
				$.ajax({
					url: "ListAssetServlet",
					type: "GET",
					dataType: "json",
					success: function(assets) {
						assets.forEach(function(asset) {
							console.log(asset);
							if(asset.assetNo == assetNo) {
								if(asset.type == "Laptop" || asset.type == "Desktop") {									
									$("#allocation").val(asset.empId);
									populateAllocationSelect(asset.empId);
									$("#processorField").show();
									$("#ramField").show();
									$("#osField").show();
									$("#hddField").show();
									$("#graphicField").show();
									$("#assetType").val(asset.type);
									$("#serialNo").val(asset.serialNo);
									$("#assetNo").val(asset.assetNo);
									$("#model").val(asset.model);
									$("#make").val(asset.make);
									$("#processor").val(asset.processor);
									$("#ram").val(asset.ram);
									$("#os").val(asset.os);
									$("#hdd").val(asset.hdd);
									$("#graphics").val(asset.graphics);
									$("#saveBtn").attr("data-asset-no", asset.assetNo);
									$("#accessoryTypeField").hide();
									$("#wiredField").hide();
									return;
								}
								else if(asset.type == "Printer" || asset.type == "Server" || asset.type == "Others") {
									$("#allocation").val(asset.empId);
									populateAllocationSelect(asset.empId);
									$("#assetType").val(asset.type);
									$("#serialNo").val(asset.serialNo);
									$("#assetNo").val(asset.assetNo);
									$("#model").val(asset.model);
									$("#make").val(asset.make);
									$("#processorField").hide();
									$("#ramField").hide();
									$("#osField").hide();
									$("#hddField").hide();
									$("#graphicField").hide();
									$("#saveBtn").attr("data-asset-no", asset.assetNo);
									$("#accessoryTypeField").hide();
									$("#wiredField").hide();
									return;
								}
									
							}
						}) 
					},
					error: function(xhr, status, error) {
						console.log(error);
					}
				})
				$("#assetType").attr("disabled", "disabled");
				$("#serialNo").attr("disabled", "disabled");
				$("#assetNo").attr("disabled", "disabled");
		        $("#editDiv").show();
		        $(".blur-overlay").show();
		    });
			
			$("#listAssetDiv").on("click", ".deleteBtn", function() {
				var assetNo = $(this).data('asset-no');
				$.ajax({
					url: "DeleteAssetServlet",
					type: "POST",
					data: {assetNo: assetNo},
					success: function() {
						listAsset();
					},
					error: function(xhr, status, error) {
						console.log(error);
					}
				})
			})
			$("#listAssetDiv").on("click", ".deleteBtnAccessory", function() {
				var accessoryId = $(this).data('accessory-id');
				$.ajax({
					url: "DeleteAccessoryServlet",
					type: "POST",
					data: {accessoryId: accessoryId},
					success: function() {
						listAsset();
					},
					error: function(xhr, status, error) {
						console.log(error);
					}
				})
			})
			
			$("#listAssetDiv").on("click", ".editBtnAccessory", function() {
				var accessoryId = $(this).data('accessory-id');
				console.log(accessoryId);
				$.ajax({
					url: "ListAccessoryServlet", 
					type: "GET", 
					dataType: "json",
					success: function(accessories) {
						accessories.forEach(function(accessory) {
							if(accessory.accessoryId == accessoryId)  {
								$("#allocation").val(accessory.empId);
								populateAllocationSelect(accessory.empId);
								$("#assetType").val("Accessory");
								$("#assetType").attr("disabled", "disabled");
								$("#serialNoField").hide();
								$("#assetNoField").hide();
								$("#modelField").hide();
								$("#makeField").hide();
								$("#processorField").hide();
								$("#ramField").hide();
								$("#osField").hide();
								$("#hddField").hide();
								$("#graphicField").hide();
								$("#saveBtn").attr("data-accessory-id", accessoryId);
								$("#accessoryTypeField").show();
								$("#accessoryType").val(accessory.accessory);
								$("#wiredField").show();
								$("#wired").val(accessory.wired);
								return;
							}
						})
					},
					error: function(xhr, status, error) {
						console.log(error);
					}
				})
				$("#assetType").attr("disabled", "disabled");
				$("#accessoryType").attr("disabled", "disabled");
				$("#editDiv").show();
		        $(".blur-overlay").show();
			})
			
			function populateAllocationSelect(empId) {
				$.ajax({
					url: "GetUserServlet",
					type: "GET",
					dataType: "json",
					success: function(users) {
						var optionHtml = "<option value='' selected>None</option>";
						users.forEach(function(user) {
							var selected = user.empId == empId? "selected": "";
							if(user.isAdmin == null)
								optionHtml += "<option value='"+user.empId+"' "+selected+">"+user.empId+"</option>";
						})
						$("#allocationSelect").html(optionHtml);
					},
					error: function(xhr, status, error) {
						console.log(error);
					}
				})
			}
			
			$("#editDiv").on("click", "#saveBtn", function(event) {
				event.preventDefault();
			    $("#editForm :disabled").prop("disabled", false);
			    var accessoryId= $(this).data("accessory-id");
			    var formData = $("#editForm").serialize();
				var assetType = $("#assetType").val();
				if(assetType == "Accessory") {
					formData += "&accessoryId=" + encodeURIComponent(accessoryId);
					$.ajax({
						url: "EditAccessoryServlet",
						type: "POST", 
						data: formData,
						success: function(response) {
							console.log(response);
							listAsset();
							$("#editDiv").hide();
						    $(".blur-overlay").hide();
						},
						error: function(chr, status, error) {
							console.log(error);
						}
					})
					$(this).removeData("accessory-id");
				}
				else {					
					$.ajax({
						url: "EditAssetServlet",
						type: "POST",
						data: formData,
						success: function(response) {
							console.log(response);
							listAsset();
							 $("#editDiv").hide();
						     $(".blur-overlay").hide();
						},
						error: function(xhr, status, error) {
							console.log(error);
						}
					})
				}
			})
		    $("#editDiv").on("click", ".close-btn", function () {
		        $("#editDiv").hide();
		        $(".blur-overlay").hide();
		    });

		    $(".blur-overlay").on("click", function () {
		        $("#editDiv").hide();
		        $(this).hide();
		    });
			
			function headerVisibility() {
				var type = $("#type").val();
				var description = $("#description").val();
				console.log(type);
				if (type === "asset") {
				    $("#descriptionDiv").show();
				    $("#searchDiv").show(); 
				    $("#accessoryTypeFilterDiv").hide();
				    if (description === "details") {
				        $("#assetDetail").show();
				        $("#assetAllocationDetail").hide();
				        $("#accessoryDetail").hide();
					    $("#filterDiv").hide();

				    } else if (description === "allocation") {
				        $("#assetDetail").hide();
				        $("#assetAllocationDetail").show();
				        $("#accessoryDetail").hide();
					    $("#filterDiv").show();
				    }
				} else if (type === "accessory") {
				    $("#assetDetail").hide();
				    $("#assetAllocationDetail").hide();
				    $("#accessoryDetail").show();
				    $("#descriptionDiv").hide();
				    $("#searchDiv").hide(); 
				    $("#filterDiv").show();
				    $("#accessoryTypeFilterDiv").show();
				}

			}
			headerVisibility();
			$("#type, #description").change(function() {
				listAsset();			
			    headerVisibility();
			});
		})
	
	</script>
</body>
</html>