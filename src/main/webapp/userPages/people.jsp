<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>People</title>
<!-- Bootstrap 5 CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css">
<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
<!-- jQuery (required for AJAX) -->
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<!-- Chart.js -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.bundle.min.js"></script>

<style>
    .profile-pic-container {
        width: 100%;
        position: relative;
    }

    .profile-pic-container img {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        object-fit: cover;
        cursor: pointer;
    }

    #chartContainer {
        display: none;
        position: absolute;
        width: 25%;
        z-index: 1050; /* Ensure it's above other elements */
        background: white;
        border: 1px solid #ddd;
        border-radius: 5px;
        padding: 10px;
        box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
    }

    canvas {
        width: 100% !important;
        height: auto !important;
    }
</style>
</head>
<body>
<%@ include file="../navbar.jsp" %>
<div class="main-content d-flex flex-column">
    <h2 class="p-2">People</h2>
    <div class="container-fluid d-flex justify-content-between">
        <div class="container-fluid bg-white col-12 m-0 rounded shadow">
            
            <table class="table table-striped rounded-table">
				<thead>
					<tr>
						<th>Profile</th>
						<th>Employee Id</th>
						<th>Employee Name</th>
						<th>Mail ID</th>
					</tr>
				</thead>
				<tbody id="listEmployee">

				</tbody>
			</table>
            
        </div>
    </div>

    <!-- Hidden Chart Container -->
    <div id="chartContainer">
    	<p id="chartHeader">Request Data</p>
        <canvas id="myChart" width="20" height="20"></canvas>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    // Employee listing logic
    function listEmployee() {
        var managerId = "<%=session.getAttribute("empId") %>"; // Replace with actual session attribute
        $.ajax({
            url: "GetUserServlet",
            type: "GET",
            dataType: "json",
            success: function (users) {
                // Sort employees
                users.sort(function (a, b) {
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

                var listEmployeeDiv = "";
                var index = 0;
                var contextPath = "<%=request.getContextPath() %>"; // Replace with actual context path
                users.forEach(function (user) {
                    if (user.manager == managerId) {
                        var rowClass = index % 2 === 0 ? "bg-white" : "bg-body-secondary";
                        listEmployeeDiv += "<tr class='col-12 rounded m-2 p-2'>"
                                         + "<td class='col-md-2 profile-pic-container'>"
                                         + "<img src='" + contextPath + "/" + user.profilePic + "' "
                                         + "class='profile-pic' data-empid='" + user.empId + "'>"
                                         + "</td>"
                                         + "<td class='col-md-2'>" + user.empId + "</td>"
                                         + "<td class='col-md-3'>" + user.username + "</td>"
                                         + "<td class='col-md-5'>" + user.empMail + "</td>"
                                         + "</tr>";
                        index++;
                    }
                });
                $("#listEmployee").html(listEmployeeDiv);

                // Add click event listener to profile pics
                $(".profile-pic").on("click", function (event) {
                    const rect = this.getBoundingClientRect();
                    const empId = $(this).data("empid");
                    
                    
                    
                    showChart(rect, empId);
                });
            }
        });
    }

    listEmployee();

    async function getRequests(empId) {
    	return $.ajax({
    		url: "GetRequestServlet",
    		type: "GET",
    		dataType: "json"
    	})
    }
    
    const chartContainer = document.getElementById("chartContainer");
    const chartCanvas = document.getElementById("myChart");
    let chart; 
    
    async function showChart(rect, empId) {
        chartContainer.style.display = "block";
        chartContainer.style.top = rect.bottom + window.scrollY - 20 + "px";
        chartContainer.style.left = rect.left + window.scrollX + 50 + "px";

        var requests = await getRequests();
        var acceptedCount = 0;
        var rejectedCount = 0;
        var requestedCount = 0;
        requests.forEach(function(request) {
        	if(request.empId === empId) {
        		if(request.status === "Accepted") {
        			acceptedCount++;
        		}
        		else if(request.status === "Requested") {
        			requestedCount++;
        		}
        		if(request.status === "Rejected") {
        			rejectedCount++;
        		}
        	}
        })
        
        if (chart) {
            chart.destroy();
        }
		
        if(requestedCount === 0 && acceptedCount === 0 && rejectedCount === 0) {
        	$("#chartHeader").text("No data");
        	return;
        }
        
        const ctx = chartCanvas.getContext("2d");
        chart = new Chart(ctx, {
        	type: 'doughnut',
            data: {
                labels: ['Requested', 'Accepted', 'Rejected'],
                datasets: [{
                    data: [requestedCount, acceptedCount, rejectedCount],
                    backgroundColor: ['#FFCA28', '#4CAF50', '#F44336']
                }]
            },
            options: {
                
            }
        });
    }

    function hideChart() {
        chartContainer.style.display = "none";
        $("#chartHeader").text("");
    }

    // Hide the chart when clicking outside
    document.addEventListener("click", function (event) {
        if (!chartContainer.contains(event.target) && !event.target.classList.contains("profile-pic")) {
            hideChart();
        }
    });
    
    
});
</script>
</body>
</html>
