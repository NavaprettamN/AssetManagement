<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<style>
	#requestDivHead {
	    font-weight: bold !important;
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
	
	.filterBtn {
    padding: 8px 20px; /* Adjust button size */
    font-size: 16px;
    transition: all 0.3s ease; /* Smooth transition */
}

.filterBtn.active {
    background-color: #28a745; /* Green background for active button */
    color: white;
    border: none;
}

.filterBtn:hover {
    transform: translateY(-2px); /* Slight lift effect */
    box-shadow: 0 3px 6px rgba(0, 0, 0, 0.15); /* Enhanced shadow on hover */
}
	
	</style>
</head>
<body>
	<%@ include file="../navbar.jsp" %>
	<div class="main-content">
		<div class="container-fluid d-flex justify-content-start mb-3">
			<h2 class="p-2">Requests</h2>
		</div>
		
		<div class="container-fluid bg-white d-flex flex-column">
			 <div class="d-flex flex-row justify-content-center p-3 m-2">
	            <button class="btn filterBtn btn-primary me-3" data-filter="allocation">Allocation Requests</button>
	            <button class="btn filterBtn btn-outline-secondary me-3" data-filter="unallocation">Unallocation Requests</button>
	            <button class="btn filterBtn btn-outline-secondary" data-filter="history">History</button>
	        </div>
			
			<table class="table table-striped rounded-table">
				<thead class="font-weight-bold rounded p-2 mb-2" id="requestDivHead">
					<tr>
						<th>Employee</th>
						<th>Asset Desc</th>
						<th>Select Asset</th>
						<th>Priority</th>
						<th>Allocate</th>
						<th>Cancel</th>
					</tr>
				</thead>
				<thead class="font-weight-bold rounded p-2 mb-2" id="unallocateRequestDiv">
					<tr>
						<th>Employee</th>
						<th>Asset Desc</th>
						<th>Allocate</th>
					</tr>
				</thead>
				<thead class="font-weight-bold rounded p-2 mb-2" id="historyRequestDiv">
					<tr>
						<th>Employee</th>
						<th>Asset Desc</th>
						<th>Priority</th>
						<th>Status</th>
						<th>Allocate/Cancel Time</th>
					</tr>
				</thead>
				<tbody id="listRequestDiv">

				</tbody>
			</table>
		</div>
		
		<div id="myModal" class="modal fade">
			<div class="modal-dialog modal-confirm">
				<div class="modal-content">
					<div class="modal-header">
						<div class="icon-box">
							<i class="material-icons">&#xE876;</i>
						</div>				
						<h4 class="modal-title w-100">Message !</h4>	
					</div>
					<div class="modal-body">
						<p class="text-center" id="messageText"></p>
					</div>
					<div class="modal-footer">
						<button class="btn btn-success btn-block" data-dismiss="modal">OK</button>
					</div>
				</div>
			</div>
		</div> 
		<input type="hidden" value="" id="hiddenReqId" />
		<div id="cancelReasonModal" class="modal fade">
		    <div class="modal-dialog modal-confirm">
		        <div class="modal-content">
		            <div class="modal-header">
		                <h4 class="modal-title w-100">Cancel Request</h4>
		            </div>
		            <div class="modal-body">
		                <p>Please provide a reason for canceling this high-priority request:</p>
		                <textarea id="cancelReason" class="form-control" rows="3" placeholder="Enter reason..."></textarea>
		                <small id="reasonError" class="text-danger d-none">Reason is required!</small>
		            </div>
		            <div class="modal-footer">
		                <button class="btn btn-danger" id="confirmCancelBtn">Cancel Request</button>
		                <button class="btn btn-secondary" data-dismiss="modal" id="closeBtn">Close</button>
		            </div>
		        </div>
		    </div>
		</div>
		<div id="cancelReasonPanel" class="d-none">
		    <h4>Cancel Request</h4>
		    <p>Please provide a reason for canceling this high-priority request:</p>
		    <textarea id="cancelReason" class="form-control" rows="3" placeholder="Enter reason..."></textarea>
		    <small id="reasonError" class="text-danger d-none">Reason is required!</small>
		    <div class="mt-2">
		        <button class="btn btn-danger" id="confirmCancelBtn">Cancel Request</button>
		        <button class="btn btn-secondary" id="closePanelBtn">Close</button>
		    </div>
		</div>
	</div>
	<script>
	$(document).ready(function() {
		async function listRequest(filterType = "allocation") {
			
			var users = await getUsers();
			$.ajax({
				url: "GetRequestServlet",
				type: "GET",
				dataType: "json",
				success: async function(requests) {
					var requestDiv = "";
					var index = 0;
					var assets = await getAssets();
					var accessories = await getAccessories();
					requests.forEach(async function(request) {
						if(filterType === "allocation") {
							if(request.status === "Accepted") {
								
								var rowClass = index % 2 === 0? "bg-white": "bg-body-secondary";
								index++;
								var assetDesc = request.type === "Accessories"? request.accessories: request.type;
								requestDiv += "<tr class='col-12 rounded m-2 p-2'>";
								var user = users.find(u => u.empId === request.empId);
								var contextPath = "<%=request.getContextPath() %>";
								var popoverContent = "<div class=\"popover-content\">" +"<div class=\"text-center\">" +
								    "<img src=\"" + contextPath + "/" + user.profilePic + "?ver=<%= System.currentTimeMillis() %>" +"\" alt=\"Profile Picture\" class=\"img-fluid rounded-circle mb-3\" style=\"width: 100px; height: 100px;\" />" + 
								    "<h5>" + user.username + "</h5>" + 
								    "</div>" +
								    "<p><strong>Employee Id:</strong> " + user.empId + "</p>" +
								    "<p><strong>Department:</strong> " + user.department + "</p>" +
								    "<p><strong>Mail Id:</strong> " + user.empMail + "</p>";
		
								if (user.manager) {
								    popoverContent += "<p><strong>Manager:</strong> " + user.manager + "</p>";
								}
		
								popoverContent += "</div>";
								
								requestDiv += "<td class='col-md-2 popover-trigger' data-bs-toggle='popover' data-bs-title='"+ user.username + "' data-bs-content='" + popoverContent+ "' data-bs-trigger='hover' data-bs-html='true'>" + user.username + "</td>";
								requestDiv += "<td class='col-md-2'>" +
					            assetDesc +
					            "<button class='btn btn-link p-0 ms-2 eye-icon' " +
					                    "data-bs-toggle='popover' " +
					                    "data-bs-html='true' " +
					                    "data-bs-content='" + generateRequestDetails(request) + "'>" +
						                "<i class='bi bi-eye'></i>" +
						            "</button>" +
						        "</td>"
								if(request.type === "Accessories") {
									console.log("accessory")
									requestDiv +=
					                    "<td class='col-md-2'>" +
					                    "<select id='accessorySelect-" +
					                    request.reqId +
					                    "' class='accessorySelect form-select w-75' data-req-id='" +
					                    request.reqId +
					                    "'></select>" +
					                    "</td>";
					                populateAccessorySelect(request);
								}
								else {								
									requestDiv +=
					                    "<td class='col-md-2'>" +
					                    "<select id='assetSelect-" +
					                    request.reqId +
					                    "' class='assetSelect form-select w-75' data-req-id='" +
					                    request.reqId +
					                    "'></select>" +
					                    "</td>";
					                populateAssetSelect(request);
								}
				                if(request.priority === "High" && request.reqMsg != "" && request.reqMsg != null) {
									requestDiv += "<td class='col-md-2 popover-trigger' data-bs-toggle='popover' data-bs-title='Message' data-bs-content='" + request.reqMsg + "' data-bs-trigger='hover' data-bs-html='true'>" + request.priority + "</td>";
				                }
				                else {
									requestDiv += "<td class='col-md-2'>" +request.priority+ "</td>";
				                }
								requestDiv += "<td class='col-md-2'>" +"<button class='btn btn-primary rounded-2 shadow allocateBtn' data-req-id='"+request.reqId+"' data-req-type='"+request.type+"'><i class='bi bi-box me-1'></i> Allocate</button>"+ "</td>";
								requestDiv += "<td class='col-md-2'>" +
	                            "<button class='btn btn-danger shadow rounded-circle cancelBtn ms-1' data-priority='" +
	                            request.priority +
	                            "' data-req-id='" + request.reqId +
	                            "'><i class='bi bi-x-circle'></i></button>" +
	                            "</td>";
								requestDiv += "</tr>";
							}
							$("#unallocateRequestDiv").hide();
							$("#requestDivHead").show();
							$("#historyRequestDiv").hide();
						}
						else if(filterType === "unallocation") {
							if(request.status == "Unallocation Requested") {
								var rowClass = index % 2 === 0? "bg-white": "bg-body-secondary";
								index++;
								requestDiv += "<tr class='col-12 rounded m-2 p-2'>";
								var user = users.find(u => u.empId === request.empId);
								var contextPath = "<%=request.getContextPath() %>";
								var popoverContent = "<div class=\"popover-content\">" +"<div class=\"text-center\">" +
								    "<img src=\"" + contextPath + "/" + user.profilePic + "?ver=<%= System.currentTimeMillis() %>" +"\" alt=\"Profile Picture\" class=\"img-fluid rounded-circle mb-3\" style=\"width: 100px; height: 100px;\" />" + 
								    "<h5>" + user.username + "</h5>" + 
								    "</div>" +
								    "<p><strong>Employee Id:</strong> " + user.empId + "</p>" +
								    "<p><strong>Department:</strong> " + user.department + "</p>" +
								    "<p><strong>Mail Id:</strong> " + user.empMail + "</p>";
		
								if (user.manager) {
								    popoverContent += "<p><strong>Manager:</strong> " + user.manager + "</p>";
								}
		
								popoverContent += "</div>";
								
								requestDiv += "<td class='col-md-2 popover-trigger' data-bs-toggle='popover' data-bs-title='"+ user.username + "' data-bs-content='" + popoverContent+ "' data-bs-trigger='hover' data-bs-html='true'>" + user.username + "</td>";
								
								if(request.assetNo != null) {
									var asset = assets.find(a => a.assetNo === request.assetNo);
									requestDiv += "<td class='col-md-2'>" +
						            asset.type +
						            "<button class='btn btn-link p-0 ms-2 eye-icon' " +
						                    "data-bs-toggle='popover' " +
						                    "data-bs-html='true' " +
						                    "data-bs-content='" + generateRequestDetails(request) + "'>" +
							                "<i class='bi bi-eye'></i>" +
							            "</button>" +
							        "</td>"
									
								}
								else if (request.accessoryId != null) {
									var accessory = accessories.find(a => a.accessoryId == request.accessoryId);
									requestDiv += "<td class='col-md-2'>" +
						            accessory.accessory +
						            "<button class='btn btn-link p-0 ms-2 eye-icon' " +
						                    "data-bs-toggle='popover' " +
						                    "data-bs-html='true' " +
						                    "data-bs-content='" + generateRequestDetails(request) + "'>" +
							                "<i class='bi bi-eye'></i>" +
							            "</button>" +
							        "</td>"
									
								}
								requestDiv += "<td class='col-md-2'>" +"<button class='btn btn-primary unallocateBtn' data-req-id='"+request.reqId+"'>Unallocate</button>"+ "</td>";
								
								requestDiv += "</tr>";
							}
							$("#unallocateRequestDiv").show();
							$("#requestDivHead").hide();
							$("#historyRequestDiv").hide();

						}
						else if(filterType === "history") {
							if(request.status === "Allocated" || request.status === "Cancelled") {
								var rowClass = index % 2 === 0? "bg-white": "bg-body-secondary";
								index++;
								var assetDesc = request.type === "Accessories"? request.accessories: request.type;
								requestDiv += "<tr class='col-12 rounded m-2 p-2'>";
								var user = users.find(u => u.empId === request.empId);
								var contextPath = "<%=request.getContextPath() %>";
								var popoverContent = "<div class=\"popover-content\">" +"<div class=\"text-center\">" +
								    "<img src=\"" + contextPath + "/" + user.profilePic + "?ver=<%= System.currentTimeMillis() %>" +"\" alt=\"Profile Picture\" class=\"img-fluid rounded-circle mb-3\" style=\"width: 100px; height: 100px;\" />" + 
								    "<h5>" + user.username + "</h5>" + 
								    "</div>" +
								    "<p><strong>Employee Id:</strong> " + user.empId + "</p>" +
								    "<p><strong>Department:</strong> " + user.department + "</p>" +
								    "<p><strong>Mail Id:</strong> " + user.empMail + "</p>";
		
								if (user.manager) {
								    popoverContent += "<p><strong>Manager:</strong> " + user.manager + "</p>";
								}
		
								popoverContent += "</div>";
								
								requestDiv += "<td class='col-md-2 popover-trigger' data-bs-toggle='popover' data-bs-title='"+ user.username + "' data-bs-content='" + popoverContent+ "' data-bs-trigger='hover' data-bs-html='true'>" + user.username + "</td>";
								requestDiv += "<td class='col-md-2'>" +
					            assetDesc +
					            "<button class='btn btn-link p-0 ms-2 eye-icon' " +
					                    "data-bs-toggle='popover' " +
					                    "data-bs-html='true' " +
					                    "data-bs-content='" + generateRequestDetails(request) + "'>" +
						                "<i class='bi bi-eye'></i>" +
						            "</button>" +
						        "</td>"
								
				                if(request.priority == "High" && request.reqMsg != "") {
									requestDiv += "<td class='col-md-2 popover-trigger' data-bs-toggle='popover' data-bs-title='Message' data-bs-content='" + request.reqMsg + "' data-bs-trigger='hover' data-bs-html='true'>" + request.priority + "</td>";
				                }
				                else {
									requestDiv += "<td class='col-md-2'>" +request.priority+ "</td>";
				                }
								requestDiv += "<td class='col-md-2'>" +request.status+ "</td>";
								requestDiv += "<td class='col-md-2'>" + request.adminTime + "</td>";
								
								requestDiv += "</tr>";
							}
							
							else if(request.status === "Unallocated") {
								var assetType = (request.accessoryId == "" || request.accessoryId == null)? "Asset": "Accessories";
								requestDiv += "<tr class='col-12 rounded m-2 p-2'>";
								var user = users.find(u => u.empId === request.empId);
								var contextPath = "<%=request.getContextPath() %>";
								var popoverContent = "<div class=\"popover-content\">" +"<div class=\"text-center\">" +
								    "<img src=\"" + contextPath + "/" + user.profilePic + "?ver=<%= System.currentTimeMillis() %>" +"\" alt=\"Profile Picture\" class=\"img-fluid rounded-circle mb-3\" style=\"width: 100px; height: 100px;\" />" + 
								    "<h5>" + user.username + "</h5>" + 
								    "</div>" +
								    "<p><strong>Employee Id:</strong> " + user.empId + "</p>" +
								    "<p><strong>Department:</strong> " + user.department + "</p>" +
								    "<p><strong>Mail Id:</strong> " + user.empMail + "</p>";
		
								if (user.manager) {
								    popoverContent += "<p><strong>Manager:</strong> " + user.manager + "</p>";
								}
		
								popoverContent += "</div>";
								
								requestDiv += "<td class='col-md-2 popover-trigger' data-bs-toggle='popover' data-bs-title='"+ user.username + "' data-bs-content='" + popoverContent+ "' data-bs-trigger='hover' data-bs-html='true'>" + user.username + "</td>";
								var requestedAsset = null;
								console.log(assetType);
								if(assetType === "Asset") {
									requestedAsset = assets.find(asset => asset.assetNo === request.assetNo);
								}
								else if(assetType === "Accessories") {
									console.log(request);
									requestedAsset = accessories.find(accessory => accessory.accessoryId == request.accessoryId);									
								}
								
								requestDiv += "<td class='col-md-2'>" + (assetType === "Asset"? requestedAsset.type: requestedAsset.accessory) + 
					            "<button class='btn btn-link p-0 ms-2 eye-icon' " +
					                    "data-bs-toggle='popover' " +
					                    "data-bs-html='true' " +
					                    "data-bs-content='" + generateRequestDetails(request) + "'>" +
						                "<i class='bi bi-eye'></i>" +
						            "</button>" +
						        "</td>"
								
				                if(request.priority == "High" && request.reqMsg != "") {
									requestDiv += "<td class='col-md-2 popover-trigger' data-bs-toggle='popover' data-bs-title='Message' data-bs-content='" + request.reqMsg + "' data-bs-trigger='hover' data-bs-html='true'>" + request.priority + "</td>";
				                }
				                else {
									requestDiv += "<td class='col-md-2'>-</td>";
				                }
								requestDiv += "<td class='col-md-2'>" +request.status+ "</td>";
								requestDiv += "<td class='col-md-2'>" + request.adminTime + "</td>";
								
								requestDiv += "</tr>";
							}
							$("#unallocateRequestDiv").hide();
							$("#requestDivHead").hide();
							$("#historyRequestDiv").show();

						}
					})
					$("#listRequestDiv").html(requestDiv);
					$('[data-bs-toggle="popover"]').popover();
				}
			})
		}
		
		async function getAssets() {
			return $.ajax({
				url: "ListAssetServlet",
				type: "GET",
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
		
		$("#listRequestDiv").on("click", ".unallocateBtn", function() {
			var reqId = $(this).data("req-id");
			$.ajax({
				url: "UnallocateAssetServlet",
				type: "POST",
				data: {reqId: reqId},
				success: function(response) {
					console.log("success");
					listRequest("unallocation");
				},
				error: function(xhr,status,error) {
					console.log(error);
				}
			})
		})
		
		$(".filterBtn").on("click", function() {
	        const filterType = $(this).data("filter");
	        console.log(filterType);
	        listRequest(filterType);
	        document.querySelectorAll('.filterBtn').forEach(btn => btn.classList.remove('btn-primary', 'active'));
	        document.querySelectorAll('.filterBtn').forEach(btn => btn.classList.add('btn-outline-secondary'));
	
	        // Add active class to the clicked button
	        this.classList.add('btn-primary', 'active');
	        this.classList.remove('btn-outline-secondary');
	        $(this).removeClass("btn-secondary").addClass("btn-primary");
	    });
		listRequest();
		
		async function getUsers() {
		   	return $.ajax({
		   		url: "GetUserServlet",
		   		type: "GET",
		   		dataType: "json"
		   	})
		}
		
		function generateRequestDetails(request) {
		    var details = "<div>";

		    if (request.type) details += "<p><strong>Type:</strong> " + request.type + "</p>";
		    if (request.model) details += "<p><strong>Model:</strong> " + request.model + "</p>";
		    if (request.make) details += "<p><strong>Make:</strong> " + request.make + "</p>";
		    if (request.wired) details += "<p><strong>Wired:</strong> " + request.wired + "</p>";
		    if (request.graphics) details += "<p><strong>Graphics:</strong> " + request.graphics + "</p>";
		    if (request.os) details += "<p><strong>Operating System:</strong> " + request.os + "</p>";
		    if (request.accessories) details += "<p><strong>Accessories:</strong> " + request.accessories + "</p>";
		    if (request.hdd) details += "<p><strong>Hard Disk:</strong> " + request.hdd + "</p>";
		    if (request.managerId) details += "<p><strong>Manager ID:</strong> " + (request.managerId === "pass"?"None": request.managerId) + "</p>";
			if (request.managerTime) details += "<p><strong>Time of request:</strong> " + request.managerTime + "</p>";
			if (request.accessoryId) details += "<p><strong>Accessory Id:</strong> " + request.accessoryId + "</p>";
			if (request.assetNo) details += "<p><strong>Asset Number:</strong> " + request.assetNo + "</p>";
		
			if (request.requestTime && (request.status === "Unallocated" || request.status === "Unallocation Requested")) details += "<p><strong>Time of request:</strong> " + request.requestTime + "</p>";
		    if (details === "<div>") {
		        details += "<p>No details available for this request.</p>";
		    }

		    details += "</div>";
		    return details;
		}

		function populateAssetSelect(request) {
			$.ajax({
				url: "ListAssetServlet",
				type: "GET",
				dataType: "json",
				success: function(assets) {
					var options = "<option value='' selected>None</option>";
					assets.forEach(function (asset) {
						var matches = true;
						
						if(asset.empId != '') matches = false;
						else if(asset.type != request.type) matches = false;
						
						if(matches) {
							options += "<option value='"+asset.assetNo+"'>"+asset.make+" [" +asset.assetNo+"]</option>";
						}
					})
					$("select.assetSelect[data-req-id='" + request.reqId + "']").html(options);
				}
			})
		}
		function populateAccessorySelect(request) {
			$.ajax({
				url: "ListAccessoryServlet",
				type: "GET",
				dataType: "json",
				success: function(accessories) {
					var options = "<option value=''>None</option>";
					accessories.forEach(function (accessory) {
						var matches = true;
						if(accessory.empId != '') matches = false;
						else if(accessory.accessory != request.accessories) matches = false;
						
						if(matches) {
							options += "<option value='"+accessory.accessoryId+"'>"+accessory.accessory+", " +accessory.wired+"</option>";
						}
					})
					$("select.accessorySelect[data-req-id='" + request.reqId + "']").html(options);
				}
			})
		}
		
		
		$("#listRequestDiv").on("click", ".allocateBtn", function() {
			var reqId = $(this).data("req-id");
			var type = $(this).data('req-type');
			
			if(type === "Accessories") {
				var accessoryId = $("select.accessorySelect[data-req-id='"+reqId+"']").val();
				if(accessoryId === '') {
	                Swal.fire({
	            		title: "Please select an accessory",
	            		icon: "error",
	            		timer: 1500,
	            		showConfirmButton: false
	           		});
	                return;
				}
			}
			else {
				var assetNo = $("select.assetSelect[data-req-id='"+reqId+"']").val();
				console.log(assetNo);
				if(assetNo === '') {
	                Swal.fire({
	            		title: "Please select an asset",
	            		icon: "error",
	            		timer: 1500,
	            		showConfirmButton: false
	           		});
	                return;
				}
			}
			var accessoryId = $("select.accessorySelect[data-req-id='"+reqId+"']").val();
			var assetNo = $("select.assetSelect[data-req-id='"+reqId+"']").val();
			
			
			
			
			var status = "Allocated";
			console.log(reqId);

			if(type == "Accessories") {
				$.ajax({
					url: "AllocateAccessoryServlet",
					type: "POST", 
					data: {reqId: reqId, accessoryId: accessoryId, status: status},
					success: function() {
						Swal.fire({
		            		title: "Accessory Allocated",
		            		icon: "success",
		            		timer: 1500,
		            		showConfirmButton: false
		           		});
						listRequest();
						
					},
					error: function(xhr,status, error) {
						console.log(error);
					}
				})
				return;
			}
			else {				
				$.ajax({
					url: "AllocateAssetServlet",
					type: "POST", 
					data: {reqId: reqId, assetNo: assetNo, status: status},
					success: function(response) {
						Swal.fire({
		            		title: "Asset Allocated",
		            		icon: "success",
		            		timer: 1500,
		            		showConfirmButton: false
		           		});						listRequest();
					},
					error: function(xhr,status, error) {
						console.log(error);
					}
				})
			}
		})
		
		
		
		$("#listRequestDiv").on("click", ".trigger-btn",function() {
            var reqId = $(this).data("req-id");
			var reqMsg = decodeURIComponent($(this).data("req-msg"));
            $("#messageText").text(reqMsg);
        });
		
		$("#listRequestDiv").on("click", ".cancelBtn", function () {
		    
		    var reqId = $(this).data("req-id");
		    var priority = $(this).data("priority");
	        $("#hiddenReqId").val(reqId);
			console.log("cancel button req-id : ", reqId);
		    if (priority === "Low") {
		        cancelRequest(reqId, "");
		    } else if (priority === "High") {
		        $("#cancelReasonModal").modal("show");
		        $("#cancelReason").val(""); 
		        $("#reasonError").addClass("d-none"); 
		    }
		});
		
		$("#cancelReasonModal").on("hidden.bs.modal", function () {
		    console.log("Modal closed: data-req-id reset");
		});
		  function cancelRequest(reqId, resMsg) {
		        var status = "Cancelled";
		        $.ajax({
		            url: "AllocateAssetServlet",
		            type: "POST",
		            data: { reqId: reqId, status: status, resMsg: resMsg },
		            success: function(response) {
		                console.log(response);
		                $("#cancelReasonModal").modal("hide");
		                listRequest();
		            },
		            error: function(xhr, status, error) {
		                console.log(error);
		            }
		        });
		    }

		  $("#cancelReasonModal").on("click", "#confirmCancelBtn", function () {
			    var resMsg = $("#cancelReason").val();
			    var reqId = $("#hiddenReqId").val();
			    console.log(reqId);
			    if (!resMsg) {
			        $("#reasonError").removeClass("d-none");
			    } else {
			        $("#reasonError").addClass("d-none");
			        cancelRequest(reqId, resMsg);
			    	$("#hiddenReqId").val("");
			    }
			});
		    
		    $("#closeBtn").on("click", function() {
		    	$("#cancelReasonModal").modal("hide");
		    	$("#hiddenReqId").val("");
		    })
		    
		    
	})
	</script>
</body>
</html>