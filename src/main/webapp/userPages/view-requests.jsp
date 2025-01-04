<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
</head>
<body>
<%@ include file="../navbar.jsp" %>
	<div class="main-content d-flex flex-column">
		<h2 class="p-2">Requests</h2>
		<div class="container-fluid d-flex justify-content-between">
	   		<div class="container-fluid bg-white col-12 m-0 rounded shadow">
			    
			    <table class="table table-striped rounded-table">
					<thead>
						<tr>
							<th>Emp Id</th>
							<th>Emp Name</th>
							<th>Requested</th>
							<th>Priority</th>
							<th>Action</th>
							<th>Action</th>
						</tr>
					</thead>
					<tbody id="listRequestsDiv">

					</tbody>
				</table>
			</div>  
		</div>
		<input type="hidden" value="" id="hiddenReqId" />
		<div id="rejectReasonModal" class="modal fade">
		    <div class="modal-dialog modal-confirm">
		        <div class="modal-content">
		            <div class="modal-header">
		                <h4 class="modal-title w-100">Reject Request</h4>
		            </div>
		            <div class="modal-body">
		                <p>Please provide a reason for Rejecting this high-priority request:</p>
		                <textarea id="rejectReason" class="form-control" rows="3" placeholder="Enter reason..."></textarea>
		                <small id="reasonError" class="text-danger d-none">Reason is required!</small>
		            </div>
		            <div class="modal-footer">
		                <button class="btn btn-danger" id="confirmRejectBtn">Reject Request</button>
		                <button class="btn btn-secondary" id="closeBtn" data-dismiss="modal">Close</button>
		            </div>
		        </div>
		    </div>
		</div>
	</div>
	<script>
		$(document).ready(function() {
			function listRequests() {
				var empId = "<%=session.getAttribute("empId") %>";
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
								var listRequestDiv = "";
								var index = 0;
								requests.forEach(function(request) {
									if(request.managerId == empId && request.status == "Requested") {
										var rowClass = index % 2 === 0? "bg-white": "bg-body-secondary";
										listRequestDiv += "<tr class='col-12 rounded m-2 p-2'>";
										listRequestDiv += "<td class='col-md-1'>"+ request.empId +"</td>";
										for(let i = 0; i < users.length; i++) {
											var user = users[i];
											if(user.empId == request.empId) {
												console.log(user);
												listRequestDiv += "<td class='col-md-3'>"+ user.username +"</td>";
												break;
											}
										}
										var assetDesc = request.type === "Accessories"?request.accessories: request.type;
										listRequestDiv += "<td class='col-md-2'>"+ assetDesc +"<button class='btn btn-link p-0 ms-2 eye-icon' " +
					                    "data-bs-toggle='popover' " +
					                    "data-bs-html='true' " +
					                    "data-bs-content='" + generateRequestDetails(request) + "'>" +
						                "<i class='bi bi-eye'></i>" +
						            	"</button></td>";
																	
										if(request.priority === "High" && request.reqMsg !== "" && request.reqMsg != null) {
											listRequestDiv += "<td class='col-md-2 popover-trigger' data-bs-toggle='popover' data-bs-title='Message' data-bs-content='" + request.reqMsg+ "' data-bs-trigger='hover' data-bs-html='true'>"+ request.priority +"</td>";
										}
										else {
											listRequestDiv += "<td class='col-md-2'>"+ request.priority +"</td>";											
										}
										listRequestDiv += "<td class='col-md-2'>"+ "<button class='btn btn-primary acceptBtn' data-req-id='"+request.reqId+"' data-priority='"+request.priority+"'  data-req-msg='"+ request.reqMsg +"' type='button'>Accept</button>" +"</td>";
										listRequestDiv += "<td class='col-md-2'>"+ "<button class='btn btn-danger rejectBtn' type='button' data-req-id='"+ request.reqId +"' data-priority='"+request.priority+"'>Reject</button>" +"</td>";
										listRequestDiv += "</tr>";
										index++;
									}
								})
								$("#listRequestsDiv").html(listRequestDiv);
								$('[data-bs-toggle="popover"]').popover();
							},
							error: function(xhr, status, error) {
								console.log(error);
							}
						})
					},
					error: function(xhr, status, error) {
						console.log(error);
					}
				})
			}
			listRequests();
			
			$("#listRequestsDiv").on("click", ".acceptBtn", function() {
				var reqId = $(this).data('req-id');
				var reqMsg = $(this).data('req-msg');
				var priority = $(this).data('priority');
				var status = "Accepted";
				$.ajax({
					url: "AcceptRejectServlet",
					type: "POST",
					data: {reqId: reqId, status: status, reqMsg: reqMsg, priority: priority},
					success: function() {
						listRequests();
					},
					error: function(xhr, status, error) {
						console.log(error);
					}
				})
			})
			
			$("#listRequestsDiv").on("click", ".rejectBtn", function() {
				var reqId = $(this).data('req-id');
				var priority = $(this).data('priority');
				var status = "Rejected";
				$("#hiddenReqId").val(reqId);
				console.log(priority);
				if(priority == "High") {
					$("#rejectReasonModal").modal("show");
				}
				else {
					acceptReject(reqId, status, "");
				}
			})
			
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
			    details += "<p><strong>Time of Request</strong> " + request.requestTime + "</p>";
			    if (details === "<div>") {
			        details += "<p>No details available for this request.</p>";
			    }
	
			    details += "</div>";
			    return details;
			}
			
			$("#rejectReasonModal").on("click", "#closeBtn", function() {
				$("#rejectReasonModal").modal("hide");
				$("#rejectReason").val("");
				$("#reasonError").addClass("d-none");
			})
			$("#rejectReasonModal").on("click", "#confirmRejectBtn", function() {
				var reqId = $("#hiddenReqId").val();
				var status ="Rejected";
				var resMsg = $("#rejectReason").val();
				if (!resMsg) {
			        $("#reasonError").removeClass("d-none");
				}
				else {					
					acceptReject(reqId, status, resMsg);
					$("#rejectReasonModal").modal("hide");
					$("#rejectReason").val("");
					$("#reasonError").addClass("d-none");
				}
			})
			$("#rejectReasonModal").on("hidden.bs.modal", function () {
			    console.log("Modal closed: data-req-id reset");
				$("#reasonError").addClass("d-none");
			});
			function acceptReject(reqId, status, resMsg) {
				$.ajax({
					url: "AcceptRejectServlet",
					type: "POST",
					data: {reqId: reqId, status: status, resMsg: resMsg},
					success: function() {
						listRequests();
					},
					error: function(xhr, status, error) {
						console.log(error);
					}
				})			
			}
		})
	</script>
</body>
</html>