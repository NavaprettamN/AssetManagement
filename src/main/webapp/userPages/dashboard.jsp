<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
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
		<% if (session.getAttribute("isManager") != null) { 
			if(session.getAttribute("isManager") == "true") {%>
		    	<h2 class="p-2">Dashboard</h2>
		    	<div class="container-fluid d-flex justify-content-between">
		    		<div class="contanier-fluid bg-white d-flex col-3 p-4 rounded-2 shadow align-items-center">
		    			<div class="container col-4">
		    				<img src="<%=request.getContextPath() %>/images/dashboard-request-icon.png" class="w-100" alt="requests">
		    			</div>
		    			<div class="container d-flex flex-column">
		    				<p id="requestsNumber" class="fw-bold fs-2 m-0">0</p>
		    				<!-- <span id="requestNumberSpan"></span> -->
		    				<p>Total Requests</p>
		    			</div>
		    		</div>
		    		<!-- Main Card -->
					<div class="container-fluid bg-white d-flex col-3 p-4 rounded-2 shadow align-items-center" id="allocatedAssetsDiv">
					    <div class="container col-4">
					        <img src="<%=request.getContextPath() %>/images/dashboard-asset-icon.png" class="w-100" alt="requests">
					    </div>
					    <div class="container d-flex flex-column">
					        <p id="allocatedAssetNumber" class="fw-bold fs-2 m-0">0</p>
					        <p>Allocated Assets</p>
					    </div>
					</div>
					
					<!-- Modal -->
					<div id="allocatedAssetsModal" class="modal fade" tabindex="-1" aria-labelledby="allocatedAssetsModalLabel" aria-hidden="true">
					    <div class="modal-dialog">
					        <div class="modal-content">
					            <div class="modal-header">
					                <h5 class="modal-title" id="allocatedAssetsModalLabel">Allocated Assets</h5>
					                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					            </div>
					            <div class="modal-body">
					                <ul id="allocatedAssetsList" class="list-group">
					                    <!-- Dynamic list of allocated assets -->
					                </ul>
					            </div>
					        </div>
					    </div>
					</div>

		    		<div class="contanier-fluid bg-white d-flex col-3 p-4 rounded-2 shadow align-items-center">
		    			<div class="container col-4">
		    				<img src="<%=request.getContextPath() %>/images/dashboard-people-icon.png" class="w-100" alt="requests">
		    			</div>
		    			<div class="container d-flex flex-column">
		    				<p id="peopleNumber" class="fw-bold fs-2 m-0">0</p>
		    				<p>Total People</p>
		    			</div>
		    		</div>
		    	</div>
		    	
		    	
		    	<div class="container-fluid d-flex my-5 justify-content-between">
		    		<div class="container-fluid bg-white col-7 m-0 rounded shadow align-self-start">
		    			<p class="fw-bold fs-5 p-2">Quick Accept</p>
					    
					    <table class="table table-striped rounded-table">
							<thead>
								<tr>
									<th>Emp Id</th>
									<th>Emp Name</th>
									<th>Requested</th>
									<th>Priority</th>
									<th>Action</th>
								</tr>
							</thead>
							<tbody id="quickAcceptRequest">
	
							</tbody>
						</table>
					</div>  
		    		<div class="container bg-white col-4 m-0 shadow rounded align-self-start">
		    			<p class="fw-bold fs-5 p-2">Status</p>
					    
					    <table class="table table-striped rounded-table">
							<thead>
								<tr>
									<th>Asset Desc</th>
									<th>Status</th>
								</tr>
							</thead>
							<tbody id="statusDiv">
	
							</tbody>
						</table>
					    
		    		</div>
		    	</div>
             <% }
			else if(session.getAttribute("isManager") == "false") { %>
				<h2 class="p-2">Dashboard</h2>
		    	<div class="container-fluid d-flex justify-content-between">
		    		<div class="contanier-fluid bg-white d-flex col-3 p-4 rounded-2 shadow align-items-center">
		    			<div class="container col-4">
		    				<img src="<%=request.getContextPath() %>/images/dashboard-request-icon.png" class="w-100" alt="requests">
		    			</div>
		    			<div class="container d-flex flex-column">
		    				<p id="userRequestNumber" class="fw-bold fs-2 m-0">0</p>
		    				<!-- <span id="requestNumberSpan"></span> -->
		    				<p>Total Requests</p>
		    			</div>
		    		</div>
		    		<!-- Main Card -->
					<div class="container-fluid bg-white d-flex col-3 p-4 rounded-2 shadow align-items-center" id="allocatedAssetsDiv">
					    <div class="container col-4">
					        <img src="<%=request.getContextPath() %>/images/dashboard-asset-icon.png" class="w-100" alt="requests">
					    </div>
					    <div class="container d-flex flex-column">
					        <p id="allocatedAssetNumber" class="fw-bold fs-2 m-0">0</p>
					        <p>Allocated Assets</p>
					    </div>
					</div>
					
					<!-- Modal -->
					<div id="allocatedAssetsModal" class="modal fade" tabindex="-1" aria-labelledby="allocatedAssetsModalLabel" aria-hidden="true">
					    <div class="modal-dialog">
					        <div class="modal-content">
					            <div class="modal-header">
					                <h5 class="modal-title" id="allocatedAssetsModalLabel">Allocated Assets</h5>
					                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					            </div>
					            <div class="modal-body">
					                <ul id="allocatedAssetsList" class="list-group">
					                    <!-- Dynamic list of allocated assets -->
					                </ul>
					            </div>
					        </div>
					    </div>
					</div>

		    		<div class="contanier-fluid bg-white d-flex col-3 p-4 rounded-2 shadow align-items-center">
		    			<div class="container col-4">
		    				<img src="<%=request.getContextPath() %>/images/dashboard-people-icon.png" class="w-100" alt="requests">
		    			</div>
		    			<div class="container d-flex flex-column">
		    				<p id="pendingRequestsNumber" class="fw-bold fs-2 m-0">0</p>
		    				<!-- <span id="requestNumberSpan"></span> -->
		    				<p>Pending Requests</p>
		    			</div>
		    		</div>
		    	</div>
		    	
		    	
		    	<div class="container-fluid d-flex my-5 justify-content-between">
		    		<div class="container-fluid bg-white col-7 m-0 rounded shadow align-self-start">
		    			<p class="fw-bold fs-5 p-2">Quick Request</p>
		    			<form id="requestForm">
		                    <div class="d-flex flex-wrap justify-content-between">
		                        <div class="col-md-4 mx-5 my-3" id="typeField">
		                            <label for="type" class="form-label">Type</label>
		                            <select id="type" class="form-select" name="type">
		                                <option value="Laptop" selected>Laptop</option>
		                                <option value="Desktop">Desktop</option>
		                                <option value="Printer">Printer</option>
		                                <option value="Server">Server</option>
		                                <option value="Accessories">Accessories</option>
		                                <option value="Others">Others</option>
		                            </select>
		                        </div>
		                        <div class="col-md-4 mx-5 my-3" id="priorityField">
								    <label for="priority" class="form-label">Priority</label>
								    <select id="priority" class="form-select" name="priority">
								        <option value="Low" selected>Low</option>
								        <option value="High">High</option>
								    </select>
								</div>
		                        <div class="col-md-4 mx-5 my-3" id="accessoryTypeField" style="display: none;">
								    <label for="accessoryType" class="form-label">Accessory Type</label>
								    <select id="accessoryType" class="form-select" name="accessorytype">
								        <option value="Mouse">Mouse</option>
								        <option value="Keyboard">Keyboard</option>
								        <option value="Headphones">Headphones</option>
								        <option value="Others">Others</option>
								    </select>
								</div>
								<div class="col-md-4 mx-5 my-3" id="wiredField" style="display: none;">
								    <label for="wired" class="form-label">Wired/Wireless</label>
								    <select id="wired" class="form-select" name="wired">
								        <option value="Wired">Wired</option>
								        <option value="Wireless">Wireless</option>
								    </select>
								</div>
			                    <div class="col-md-12 my-3 mt-4 text-center">
			                        <button type="button" class="btn btn-primary" id="makeRequest">+ Make Request</button>
			                    </div>
		                    </div>
	                	</form>
					</div>  
		    		<div class="container bg-white col-4 m-0 shadow rounded align-self-start">
		    			<p class="fw-bold fs-5 p-2">Status</p>
					    <table class="table table-striped rounded-table">
							<thead>
								<tr>
									<th>Asset Desc</th>
									<th>Status</th>
								</tr>
							</thead>
							<tbody id="statusDiv">
	
							</tbody>
						</table>
					    
		    		</div>
		    	</div>
				
			
			<%}
             }%>
	</div>
	<script>
		$(document).ready(function() {
			
			async function getRequests() {
				return $.ajax({
					url: "GetRequestServlet",
					type: "GET",
					dataType: "json"
				})
			}
			
			$("#allocatedAssetsDiv").on("click", async function() {
				var requests = await getRequests();
				var assets = await getAssets();
				var accessories = await getAccessories();
			    const allocatedAssetsList = document.getElementById("allocatedAssetsList");
			    allocatedAssetsList.innerHTML = "";
				var empId = "<%=session.getAttribute("empId") %>";
			    assets.forEach(function(asset) {
			    	var assetFound = false;
			    	if(asset.empId === empId) {		
				        const listItem = document.createElement("li");
				        listItem.className = "list-group-item d-flex justify-content-between align-items-center";
				        requests.forEach(function(request) {
				        	console.log(request);
				        	if(request.assetNo === asset.assetNo && request.status === "Unallocation Requested") {
				        		assetFound = true;
						        listItem.innerHTML = asset.type + "[" + asset.assetNo + "]" + 
					            "<button class='btn btn-secondary btn-sm' data-asset-no='" + asset.assetNo + "'>Requested</button>";
					            return;
				        	}
				        })
				        if(!assetFound) {				        	
					        listItem.innerHTML = 
					            asset.type + "[" + asset.assetNo + "]" + 
					            "<button class='btn btn-danger btn-sm unallocateBtn' data-asset-no='" + asset.assetNo + "'>Unallocate</button>";				        
				        }
				        assetFound = false;
				        allocatedAssetsList.appendChild(listItem);
			    	}
			    });
			    accessories.forEach(function(accessory) {
		            var accessoryFound = false;
		            if (accessory.empId === empId) {
		                const listItem = document.createElement("li");
		                listItem.className = "list-group-item d-flex justify-content-between align-items-center";
		                
		                requests.forEach(function(request) {
		                    	console.log("accessory Id : ", accessory.accessoryId);
		                    	console.log("requestAccessory Id : ", request.accessoryId);
		                	
		                    if (request.accessoryId == accessory.accessoryId && request.status == "Unallocation Requested") {
		                    	console.log("accessory found");
		                        accessoryFound = true;
		                        listItem.innerHTML = accessory.accessory + "[" + accessory.wired + "]" +
		                            "<button class='btn btn-secondary btn-sm' data-accessory-id='" + accessory.accessoryId + "'>Requested</button>";
		                        return;
		                    }
		                });
		                if (!accessoryFound) {
		                    listItem.innerHTML =
		                        accessory.accessory + "[" + accessory.wired + "]" +
		                        "<button class='btn btn-danger btn-sm unallocateBtn' data-accessory-id='" + accessory.accessoryId + "'>Unallocate</button>";
		                }
		                accessoryFound = false;
		                allocatedAssetsList.appendChild(listItem);
		            }
		        });
				
			    const modal = new bootstrap.Modal(document.getElementById("allocatedAssetsModal"));
			    modal.show();
			}) 

			$("#allocatedAssetsList").on("click", ".unallocateBtn", function() {
				var assetNo = $(this).data("asset-no");
				var accessoryId = $(this).data("accessory-id");
				var empId = "<%=session.getAttribute("empId") %>";
				console.log(assetNo)
			    $.ajax({
			    	url: "AddUnallocationRequestServlet",
			    	type: "POST",
			    	data: {assetNo: assetNo, empId: empId, accessoryId: accessoryId},
			    	success: function() {
			    		updateModalContent();
			    	}
			    })
			})
			
			async function getAccessories() {
				return $.ajax({
					url: "GetAccessoryServlet",
					type: "GET",
					dataType: "json"
				})
			}
			
			async function updateModalContent() {
		        var requests = await getRequests();
		        var assets = await getAssets();
		        var accessories = await getAccessories();
		        var allocatedAssetsList = document.getElementById("allocatedAssetsList");
		        allocatedAssetsList.innerHTML = "";
		
		        var empId = "<%=session.getAttribute("empId") %>";
		        
		        assets.forEach(function(asset) {
		            var assetFound = false;
		            if (asset.empId === empId) {
		                const listItem = document.createElement("li");
		                listItem.className = "list-group-item d-flex justify-content-between align-items-center";
		                
		                requests.forEach(function(request) {
		                    if (request.assetNo === asset.assetNo && request.status === "Unallocation Requested") {
		                        assetFound = true;
		                        listItem.innerHTML = asset.type + "[" + asset.assetNo + "]" +
		                            "<button class='btn btn-secondary btn-sm unallocateBtn' data-asset-no='" + asset.assetNo + "'>Requested</button>";
		                        return;
		                    }
		                });
		                if (!assetFound) {
		                    listItem.innerHTML =
		                        asset.type + "[" + asset.assetNo + "]" +
		                        "<button class='btn btn-danger btn-sm unallocateBtn' data-asset-no='" + asset.assetNo + "'>Unallocate</button>";
		                }
		                assetFound = false;
		                allocatedAssetsList.appendChild(listItem);
		            }
		        });
		        
		        accessories.forEach(function(accessory) {
		            var accessoryFound = false;
		            if (accessory.empId === empId) {
		                const listItem = document.createElement("li");
		                listItem.className = "list-group-item d-flex justify-content-between align-items-center";
		                
		                requests.forEach(function(request) {
		                    	console.log("accessory Id : ", accessory.accessoryId);
		                    	console.log("requestAccessory Id : ", request.accessoryId);
		                	
		                    if (request.accessoryId == accessory.accessoryId && request.status == "Unallocation Requested") {
		                    	console.log("accessory found");
		                        accessoryFound = true;
		                        listItem.innerHTML = accessory.accessory + "[" + accessory.wired + "]" +
		                            "<button class='btn btn-secondary btn-sm' data-accessory-id='" + accessory.accessoryId + "'>Requested</button>";
		                        return;
		                    }
		                });
		                if (!accessoryFound) {
		                    listItem.innerHTML =
		                        accessory.accessory + "[" + accessory.wired + "]" +
		                        "<button class='btn btn-danger btn-sm unallocateBtn' data-accessory-id='" + accessory.accessoryId + "'>Unallocate</button>";
		                }
		                accessoryFound = false;
		                allocatedAssetsList.appendChild(listItem);
		            }
		        });
		    }
			
			async function getAssets() {
				return $.ajax({
					url:"ListAssetServlet",
					type:"GET",
					dataType: "json"
				})
			}
			
			async function getAccessories() {
				return $.ajax({
					url: "ListAccessoryServlet",
					type: "GET",
					dataType: "json"
				})
			}
			
			async function loadNumbers() {
				var empId = "<%=session.getAttribute("empId") %>";
				console.log(empId);
				var people = 0;
				$.ajax({
					url: "GetUserServlet",
					type: "GET",
					dataType: "json",
					success: function(users) {
						users.forEach(function(user) {
							if(user.manager === empId) {
								people++;
							}	
						})
						$("#peopleNumber").text(people);
					},
					error: function(xhr, status, error) {
						console.log(error);
					}
				})
				
				var allocatedAssets = 0;
				
				var assets = await getAssets();
				var accessories = await getAccessories();
				assets.forEach(function(asset) {
					if(asset.empId === empId) allocatedAssets++;
				})
				
				
				accessories.forEach(function(accessory) {
					if(accessory.empId === empId) allocatedAssets++;
				})
				
				$("#allocatedAssetNumber").text(allocatedAssets);
				
			}
			
			loadNumbers();
			
			function listQuickAccept() {
				var empId = "<%=session.getAttribute("empId") %>";
				console.log("testing", empId);
				$.ajax({
					url: "GetRequestServlet",
					type: "GET",
					dataType: "json",
					success: function(requests) {
						$.ajax({
							url: "GetUserServlet",
							type: "GET",
							dataType: "json",
							success: function(users) {
								var index = 0;
								var quickAcceptDiv = "";
								var requestsNumber = 0;
								requests.forEach(function(request) {
									if(request.managerId === empId && request.status == "Requested") {
										
										var rowClass = index % 2 === 0? "bg-white": "bg-body-secondary";
										quickAcceptDiv += "<tr class='col-12 m-2 p-2 rounded'>";
										quickAcceptDiv += "<td class='col-md-2'>"+request.empId+"</td>";
										for(let i = 0; i < users.length; i++) {
											var user = users[i];
											if(user.empId == request.empId) {
												console.log("testing : 3");
												quickAcceptDiv += "<td class='col-md-3'>"+user.username+"</td>";
												break;
											}
										}
										
										if(request.type === "Accessories") {
											quickAcceptDiv += "<td class='col-md-3'>"+request.accessories +"</td>";
										}
										else {											
											quickAcceptDiv += "<td class='col-md-3'>"+request.type +"</td>";
										}
										
										if(request.priority == "High" && request.reqMsg != "" && request.reqMsg != null) {
											quickAcceptDiv += "<td class='col-md-2 popover-trigger' data-bs-toggle='popover' data-bs-title='Message' data-bs-content='" + request.reqMsg+ "' data-bs-trigger='hover' data-bs-html='true'>"+request.priority+"</td>";											
										}
										else {											
											quickAcceptDiv += "<td class='col-md-2'>"+request.priority+"</td>";
										}
										quickAcceptDiv += "<td class='col-md-2'>"+ "<button type='button' data-req-id='"+request.reqId+"' data-priority='"+ request.priority +"' class='btn btn-primary acceptBtn'>Accept</button>" +"</td>";
										quickAcceptDiv += "</td>";
										index++;
										requestsNumber++;
									}
								})
								$("#quickAcceptRequest").html(quickAcceptDiv);
								$('[data-bs-toggle="popover"]').popover();
								$("#requestsNumber").text(requestsNumber);
								var statusDiv = "";
								index = 0;
								var userRequestNumber = 0;
								var allocatedAssets = 0;
								var pendingRequests = 0;
								requests.forEach(function(request) {
									if(request.empId == empId) {
										var rowClass = index % 2 === 0? "bg-white": "bg-body-secondary";
										statusDiv += "<tr class='col-12 m-2 p-2 rounded'>";
										if(request.type === "Accessories") {
											statusDiv += "<td class='col-md-6'>"+ request.accessories + "</td>";											
										}
										else {											
											statusDiv += "<td class='col-md-6'>"+ request.type + "</td>";
										}
										statusDiv += "<td class='col-md-6'>"+ request.status +"</td>";
										statusDiv += "</td>";
										index++;
									}
									
									if(request.empId == empId) {
										userRequestNumber++;
										if(request.status == "Allocated") {
											allocatedAssets++;
											console.log(allocatedAssets);
										}
										if(request.status == "Requested") {
											pendingRequests++;
										}
									}
								})
								$("#userRequestNumber").text(userRequestNumber);
								
								$("#pendingRequestsNumber").text(pendingRequests);
								$("#statusDiv").html(statusDiv);
							},
							error: function(xhr, status, error) {
								console.log(error);
							}
						})
					},
					error: function(xhr,status, error) {
						console.log(error);
					}
				})
			}
			listQuickAccept();
			
			$("#quickAcceptRequest").on("click", ".acceptBtn", function() {
				var reqId = $(this).data('req-id');
				var priority = $(this).data('priority');
				console.log("testing button: 10");
				var status = "Accepted"
				$.ajax({
					url: "AcceptRejectServlet",
					type: "POST", 
					data: {reqId: reqId, status: status, priority: priority},
					success: function(response) {
						console.log(response);
						listQuickAccept();
					},
					error: function(xhr, status, error) {
						console.log(error);
					}
				})
			})
			
			$("#type").change(function() {
				var type = $("#type").val();
				if(type == "Accessories") {
					$("#accessoryTypeField, #wiredField").show();
				}
				else {
					$("#accessoryTypeField, #wiredField").hide();
				}
			})
			
			$("#requestForm").on("click", "#makeRequest", function() {
				var type = $("#type").val();
				var priority = $("#priority").val();
				console.log(priority);
				var accessoryType = $("#accessoryType").val();
				var wired = $("#wired").val();
				
				$.ajax({
					url: "AddRequestServlet",
					type: "POST",
					data: {priority: priority, type: type, accessoryType: accessoryType, wired: wired},
					success: function() {
						listQuickAccept();
					},
					error: function(xhr, status, error) {
						console.log(error);
					}
				})
				
			})
		})
	</script>
</body>
</html>