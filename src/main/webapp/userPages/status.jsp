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
	 .filter-btn {
        cursor: pointer;
        font-size: 14px;
        padding: 8px 16px;
        border: 1px solid #ddd;
        border-radius: 4px;
        margin-right: 10px;
        background-color: #f8f9fa;
        color: #343a40;
    }

    .filter-btn.active {
        background-color: #5AC8FA;
        color: #fff;
        border-color: #5AC8FA;
    }

</style>
<title>Insert title here</title>
</head>
<body>
<%@ include file="../navbar.jsp" %>
	<div class="main-content d-flex flex-column">
		<h2 class="p-2">Status</h2>
		<%if(session.getAttribute("isManager") != null) {
			if(session.getAttribute("isManager") == "true") {%>
			    <!-- Filters -->
                  <div class="mb-3 d-flex flex-row justify-content-center">
                      <button class="filter-btn active" id="currentRequestsBtn" data-filter="current">Current Requests</button>
                      <button class="filter-btn" id="historyRequestsBtn" data-filter="history">History</button>
                  </div>
				<div class="container-fluid d-flex justify-content-between">
			   		<div class="container-fluid bg-white col-7 m-0 rounded shadow align-self-start">
					   	<p class="fw-bold fs-5 p-2">Employee Requests</p>
					    
                    
					    <table class="table table-striped rounded-table">
							<thead>
								<tr>
									<th>Emp Id</th>
									<th>Emp Name</th>
									<th>Requested</th>
									<th>Priority</th>
									<th>Status</th>
								</tr>
							</thead>
							<tbody id="listEmployeeStatus">
		
							</tbody>
						</table>
					    
					</div>
			   		<div class="container-fluid bg-white col-4 m-0 rounded shadow align-self-start">
					    <p class="fw-bold fs-5 p-2">Your Requests</p>
					    
					    
					    <table class="table table-striped rounded-table">
							<thead>
								<tr>
									<th>Requested</th>
									<th>Priority</th>
									<th>Status</th>
									<th>Withdraw</th>
								</tr>
							</thead>
							<tbody id="listStatus">
		
							</tbody>
						</table>
					    
					</div>  
				</div>
			<%}
			else if(session.getAttribute("isManager") == "false") {%>
				<div class="container-fluid d-flex justify-content-between">
			   		<div class="container-fluid bg-white col-12 m-0 rounded shadow">
					   <p class="fw-bold fs-5 p-2">Requests</p>
					    
					    <!-- Filters -->
	                    <div class="mb-3">
	                        <button class="filter-btn active" id="currentRequestsBtn" data-filter="current">Current Requests</button>
	                        <button class="filter-btn" id="historyRequestsBtn" data-filter="history">History</button>
	                    </div>
						    
					    <table class="table table-striped rounded-table">
							<thead>
								<tr>
									<th>Requested</th>
									<th>Priority</th>
									<th>Status</th>
									<th>Withdraw</th>
								</tr>
							</thead>
							<tbody id="listStatus">
		
							</tbody>
						</table>
					</div>  
				</div>
		<% }
		}%>
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
	</div>
	<script>
	$(document).ready(function() {
	    function listStatus(filter = "current") {
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
	                        var listEmployeeStatusDiv = "";
	                        var index = 0;
	                        requests.forEach(function(request) {
	                            if (request.managerId == empId) {
	                                var isCurrentRequest = ["Requested", "Accepted"].includes(request.status);
	                                var isHistoryRequest = ["Rejected", "Cancelled", "Allocated"].includes(request.status);

	                                if ((filter === "current" && isCurrentRequest) || (filter === "history" && isHistoryRequest)) {
	                                    listEmployeeStatusDiv += "<tr class='col-12 rounded m-2 p-2'>";
	                                    listEmployeeStatusDiv += "<td class='col-md-2'>" + request.empId + "</td>";
	                                    for (let i = 0; i < users.length; i++) {
	                                        var user = users[i];
	                                        if (user.empId == request.empId) {
	                                            listEmployeeStatusDiv += "<td class='col-md-3'>" + user.username + "</td>";
	                                            break;
	                                        }
	                                    }
	                                    var assetDesc = request.type === "Accessories" ? request.accessories : request.type;
	                                    listEmployeeStatusDiv += "<td class='col-md-3'>" + assetDesc + "</td>";
	                                    if (request.priority == "High" && request.status == "Requested" && request.reqMsg != null && request.reqMsg != "") {
	                                        listEmployeeStatusDiv += "<td class='col-md-2 popover-trigger' data-bs-toggle='popover' data-bs-title='Request Message' data-bs-content='" + request.reqMsg + "' data-bs-trigger='hover' data-bs-html='true'>" + request.priority + "</td>";
	                                    } else if (request.priority == "High" && request.status == "Cancelled") {
	                                        listEmployeeStatusDiv += "<td class='col-md-2 popover-trigger' data-bs-toggle='popover' data-bs-title='Response Message' data-bs-content='" + request.resMsg + "' data-bs-trigger='hover' data-bs-html='true'>" + request.priority + "</td>";
	                                    } else {
	                                        listEmployeeStatusDiv += "<td class='col-md-2'>" + request.priority + "</td>";
	                                    }
	                                    listEmployeeStatusDiv += "<td class='col-md-2'>" + request.status + "</td>";
	                                    listEmployeeStatusDiv += "</div>";
	                                    index++;
	                                }
	                            }
	                        });
	                        $("#listEmployeeStatus").html(listEmployeeStatusDiv);
	                        $('[data-bs-toggle="popover"]').popover();
	                    }
	                });
	                var listStatusDiv = "";
	                var index = 0;

	                requests.forEach(function(request) {
	                    if (request.empId == empId) {
	                        var isCurrentRequest = ["Requested", "Accepted"].includes(request.status);
	                        var isHistoryRequest = ["Rejected", "Cancelled", "Allocated"].includes(request.status);

	                        if ((filter === "current" && isCurrentRequest) || (filter === "history" && isHistoryRequest)) {
	                            listStatusDiv += "<tr class='col-12 rounded p-2 m-2'>";
	                            var assetDesc = request.type === "Accessories" ? request.accessories : request.type;

	                            listStatusDiv += "<td class='col-md-3'>" + assetDesc + "</td>";
	                            if ((request.status == "Rejected" || request.status == "Cancelled") && request.priority == "High") {
	                                listStatusDiv += "<td class='col-md-3 popover-trigger' data-bs-toggle='popover' data-bs-title='Message' data-bs-content='" + request.resMsg + "' data-bs-trigger='hover' data-bs-html='true'>" +
	                                    request.priority + "</td>";
	                            } else {
	                                listStatusDiv += "<td class='col-md-3'>" + request.priority + "</td>";
	                            }
	                            listStatusDiv += "<td class='col-md-3'>" + request.status + "</td>";
	                            if (request.status == "Requested" || request.managerId == "pass") {
	                                listStatusDiv += "<td class='col-md-3 '>" + "<button class='btn btn-danger p-2 border-0 withdrawBtn' data-req-id='" + request.reqId + "'><i class='bi bi-x-circle-fill me-1'></i>" + <%if(session.getAttribute("isManager").equals("false")){%> "Withdraw"<%} else {%> "" <%}%> + "</button>" + "</td>";
	                            } else {
	                                listStatusDiv += "<td class='col-md-3 '>" + "<button class='btn btn-secondary p-2 border-0' disabled><i class='bi bi-x-circle-fill me-1' style='opacity: 0.5;'></i> Withdraw</button>" + "</td>";
	                            }
	                            listStatusDiv += "</tr>";
	                            index++;
	                        }
	                    }
	                });
	                $("#listStatus").html(listStatusDiv);
	                $('[data-bs-toggle="popover"]').popover();
	            },
	            error: function(xhr, status, error) {
	                console.log(error);
	            }
	        });
	    }

	    // Initialize the filters
	    listStatus();

	    // Filter buttons
	    $("#currentRequestsBtn").click(function() {
	        listStatus("current");
	        $("#currentRequestsBtn").addClass("active");
	        $("#historyRequestsBtn").removeClass("active");
	    });

	    $("#historyRequestsBtn").click(function() {
	        listStatus("history");
	        $("#historyRequestsBtn").addClass("active");
	        $("#currentRequestsBtn").removeClass("active");
	    });

	    $("#listStatus").on("click", ".trigger-btn", function() {
	        console.log("button pressed");
	        var resMsg = $(this).data('req-resmsg');
	        console.log(resMsg);
	        $("#messageText").text(resMsg);
	    });

	    $("#listStatus").on("click", ".withdrawBtn", function() {
	        var reqId = $(this).data("req-id");
	        console.log(reqId);
	        $.ajax({
	            url: "WithdrawRequestServlet",
	            type: "POST",
	            data: { reqId: reqId },
	            success: function(response) {
	                listStatus();
	            },
	            error: function(xhr, status, error) {
	                console.log(error);
	            }
	        });
	    });
	});

	</script>
</body>
</html>