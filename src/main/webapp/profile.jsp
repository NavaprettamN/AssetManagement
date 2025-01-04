<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Asset Request Form</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script>
    $(document).ready(function() {
        
        fetchRequests();
	
        function updateFieldVisibility() {
        	var type = $("#type").val();
        	
        	if (type === "Server" || type === "Printer" || type === "Others") {
                $("#accessoryField, #wiredField, #notLaptop").hide();
                $("#notAccessoryField").show();
            }
            else if (type === "Accessories") {
                $("#notAccessoryField").hide();
            	$("#accessoryField, #wiredField").show();
            }
            else if(type === "Laptop" || type === "Desktop"){
                $("#notAccessoryField, #notLaptop").show();
                $("#accessoryField, #wiredField").hide();
            }
           
        }
        
        updateFieldVisibility();
        $("#type").change(updateFieldVisibility);
        
        function fetchRequests() { 
            $.ajax({
                url: "GetRequestServlet", // Create this servlet to fetch requests
                type: "GET",
                dataType: "json",
                success: function(response) {
                    // Assuming response is an array of request objects
                    // console.log(response);
                    populateRequests(response);
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
            	console.log(request);
            	var empId = "<%= session.getAttribute("empId") %>";
            	if(request.managerId === empId) {
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
                    "<button class='accept-btn'>Accept</button>" +
                    "<button class='reject-btn'>Reject</button>" +
                    "</div>";
                requestField.append(requestDiv);
            	}
                
            });

            $(".accept-btn").on("click", function() {
                var requestId = $(this).closest('.request').data('id');
                updateRequestStatus(requestId, 'accepted');
            });

            $(".reject-btn").on("click", function() {
                var requestId = $(this).closest('.request').data('id');
                updateRequestStatus(requestId, 'rejected');
            });
        }

        function updateRequestStatus(requestId, status) {
            $.ajax({
                url: "AcceptRejectServlet", 
                type: "POST",
                data: { id: requestId, status: status },
                success: function(response) {
                    console.log(response);
                    fetchRequests();
                },
                error: function(xhr, status, error) {
                    console.log(error);
                }
            });
        }
        
        $("#requestForm").on("submit", function(event) {
        	event.preventDefault();
        	$.ajax({
        		url: "AddRequestServlet", 
        		type: "POST", 
        		data: $(this).serialize(), // {data: "something"}
        		success: function() {
        			console.log("added Successfully");
        			fetchRequests();
        			$("#requestForm")[0].reset();
        		}, 
        		error: function() {
        			console.log("error");
        		}
        	})
        })
        
        
        function loadRequestAjax() {
        	$.ajax({
        		url: "GetRequestServlet",
        		type: "get",
        		dataType: "json",
        		success: function(response) {
        			loadRequest(response);
        		},
        		error: function(xhr, status, error) {
        			console.log(error);
        		}
        	})
        }
        function loadRequest(requests) {
        	var requestDiv = "<div class='requestList'>";
        	var empId = "<%=session.getAttribute("empId")%>";
        	console.log(empId);
        	requests.forEach(function(request){
       			if(request.empId === empId && request.status != "Allocated") {
	        		requestDiv += "<div class='request-item'>";
	        		requestDiv += "<p>"+request.type+"</p>";
	        		requestDiv += "<p>"+request.make+"</p>";
	        		requestDiv += "<p>"+request.model+"</p>";
	        		requestDiv += "<p>"+request.status+"</p>";
	        		requestDiv += "<button class='withdraw-btn' data-request-id='"+request.reqId+"'>Withdraw Request</button>";
        		}
        	})
        	requestDiv += "</div>";
        	$("#requestList").html(requestDiv);
        	
        }
        
        $("withdraw-btn").on("click", function() {
        	var requestId = $(this).data("request-id");
        	withdrawRequest(requestId);
        })
        
        function withdrawRequest(requestId) {
        	$.ajax({
        		url: "WithdrawRequestServlet",
        		type: "POST",
        		data: {requestId: requestId},
        		success: function(response) {
        			console.log("success")
        		},
        		error: function(xhr, status, error) {
        			console.log(error);
        		}
        	})
        }
        loadRequestAjax();
    });
    </script>
</head>
<body>
<%@include file="../navbar.jsp" %>
	<div class="main-content">
	    <% if (session.getAttribute("isManager") != null && "true".equals(session.getAttribute("isManager"))) { %>
	        <h1>Manager, Hi</h1>
	        
	        <div id="requestField">
	
	        </div>
	    <% } %>
	    <img src="<%= request.getContextPath() %>/images/profilepic/<%=session.getAttribute("empId") %>.png" alt="Profile Picture" class="img-thumbnail rounded-circle" style="width: 150px; height: 150px;">
	    
	    <h1>Asset Request Form</h1>
	    <form id="requestForm">
	        <label for="type">Type:</label>
	        <select id="type" name="type" required>
	            <option value="Laptop">Laptop</option>
	            <option value="Desktop">Desktop</option>
	            <option value="Printer">Printer</option>
	            <option value="Server">Server</option>
	            <option value="Other">Other</option>
	            <option value="Accessories">Accessories</option>
	        </select><br><br>
		    <div id="notAccessoryField">
		        
		
		        <label for="make">Make:</label>
		        <input type="text" id="make" name="make"><br><br>
		
		        <label for="model">Model:</label>
		        <input type="text" id="model" name="model"><br><br>
				<div id="notLaptop">
					<label for="os">OS:</label>
			        <input type="text" id="os" name="os"><br><br>
			        
			        <label for="hdd">HDD:</label>
			        <input type="text" id="hdd" name="hdd"><br><br>
			
			        <label for="ram">RAM:</label>
			        <input type="text" id="ram" name="ram"><br><br>
			
			        <label for="graphics">Graphics:</label>
			        <input type="text" id="graphics" name="graphics"><br><br>
			
			        <label for="priority">Priority:</label>
			        <select id="priority" name="priority">
			            <option value="" selected>--select--</option>
			            <option value="Low">Low</option>
			            <option value="High">High</option>
			        </select><br><br>
				</div>
		
		        <div id="messageField" style="display:none;">
		            <label for="message">Message:</label>
		            <textarea id="message" name="message"></textarea><br><br>
		        </div>
		    </div>
			<div id="accessoryField">
	            <label for="accessory">Accessory:</label>
	            <select id="accessory" name="accessories">
		            <option value="" selected>--select--</option>
		            <option value="Mouse">Mouse</option>
		            <option value="Keyboard">Keyboard</option>
		            <option value="Headphone">Headphone</option>
		            <option value="Others">Others</option>
	        	</select><br><br>
	        </div>
	        <div id="wiredField">
	            <label for="wired">wired:</label>
	            <select id="wired" name="wired">
		            <option value="" selected>--select--</option>
		            <option value="Wired">Wired</option>
		            <option value="Wireless">Wireless</option>
	        	</select><br><br>
	        </div>
	        <button type="submit">Submit</button>
	    </form>
	    <div id="requestList">
	    
	    </div>
	</div>
</body>
</html>

