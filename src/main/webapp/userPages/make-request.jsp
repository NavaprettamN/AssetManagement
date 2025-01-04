<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>

    .form-container {
        background-color: #ffffff;
        border-radius: 10px;
        box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        padding: 30px;
    }
    
    .form-control {
        background-color: #f5f7fa;
        border: 1px solid #d9d9d9;
        height: 50px;
        font-size: 14px;
    }

    .form-control::placeholder {
        color: #a0aec0;
    }

    .btn-primary {
        background-color: #4f46e5;
        border: none;
        height: 50px;
        font-size: 16px;
        border-radius: 8px;
        box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.1);
    }
    
    .btn-primary:hover {
        background-color: #4338ca;
    }
</style>
</head>
<body>
<%@ include file="../navbar.jsp" %>
	<div class="main-content d-flex flex-column">
		<div class="container-fluid">
            <h2>Make Request</h2>
            <div class="container-fluid bg-white p-3 ">
                <form id="requestForm">
                    <div class="d-flex flex-wrap justify-content-between">
                        <div class="col-md-4 mx-5 my-3" id="typeField">
                            <label for="type" class="form-label">Type<span id="requiredStar" class="text-danger">*</span></label>
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
						    <label for="priority" class="form-label">Priority<span id="requiredStar" class="text-danger">*</span></label>
						    <select id="priority" class="form-select" name="priority">
						        <option value="Low" selected>Low</option>
						        <option value="High">High</option>
						    </select>
						</div>
                        <div class="col-md-4 mx-5 my-3" id="modelField">
                            <label for="model" class="form-label">Model</label>
                            <input type="text" id="model" class="form-control" placeholder="Enter the Model" name="model">
                        </div>
                        <div class="col-md-4 mx-5 my-3" id="makeField">
                            <label for="make" class="form-label">Make</label>
                            <input type="text" id="make" name="make" class="form-control" placeholder="Asset Company">
                        </div>
                        <div class="col-md-4 mx-5 my-3" id="processorField">
                            <label for="processor" class="form-label">Processor</label>
                            <input type="text" id="processor" name="processor" class="form-control" placeholder="Enter the Processor">
                        </div>
                        <div class="col-md-4 mx-5 my-3" id="ramField">
                            <label for="ram" class="form-label">RAM</label>
                            <input type="text" id="ram" name="ram" class="form-control" placeholder="Enter the RAM">
                        </div>
                        <div class="col-md-4 mx-5 my-3" id="osField">
                            <label for="os" class="form-label">OS</label>
                            <input type="text" id="os" name="os" class="form-control" placeholder="Enter the OS">
                        </div>
                        <div class="col-md-4 mx-5 my-3" id="hddField">
                            <label for="hdd" class="form-label">HDD</label>
                            <input type="text" id="hdd" name="hdd" class="form-control" placeholder="Enter the HDD">
                        </div>
                        <div class="col-md-4 mx-5 my-3" id="graphicField">
                            <label for="graphics" class="form-label">Graphics</label>
                            <input type="text" id="graphics" name="graphics" class="form-control" placeholder="Enter the Graphics">
                        </div>
                        <div class="col-md-4 mx-5 my-3" id="accessoryTypeField">
						    <label for="accessoryType" class="form-label">Accessory Type</label>
						    <select id="accessoryType" class="form-select" name="accessoryType">
						        <option value="Mouse">Mouse</option>
						        <option value="Keyboard">Keyboard</option>
						        <option value="Headphones">Headphones</option>
						        <option value="Others">Others</option>
						    </select>
						</div>
						<div class="col-md-4 mx-5 my-3" id="wiredField">
						    <label for="wired" class="form-label">Wired/Wireless</label>
						    <select id="wired" class="form-select" name="wired">
						        <option value="Wired">Wired</option>
						        <option value="Wireless">Wireless</option>
						    </select>
						</div>
						<div class="col-md-4 mx-5 my-3" id="messageField">
						    <label for="reqMsg" class="form-label">Message</label>
						    <textarea rows="" cols="" id="reqMsg" class="form-control" name="reqMsg"></textarea>
						</div>
                    </div>
                    <div class="mx-5 my-3 mt-4 text-center">
                        <button type="button" class="btn btn-primary" id="makeRequest">+ Make Request</button>
                    </div>
                </form>
            </div>
        </div>
	</div>
	<script>
	$(document).ready(function() {
		
		$("#type").change(updateFieldVisibility);
        updateFieldVisibility();
		function updateFieldVisibility() {
            var type = $("#type").val();

            if (type === "Server" || type === "Printer" || type === "Others") {
                $("#processorField, #ramField, #osField, #hddField, #graphicField, #accessoryTypeField, #wiredField").hide();
                $("#makeField, #modelField").show();

                $("#processor, #ram, #os, #hdd, #graphics, #accessoryType, #wired").removeAttr("required");
                $("#make, #model").attr("required", "required");
            } 
            else if (type === "Accessories") {
                $("#accessoryTypeField, #wiredField").show();

                $("#processorField, #ramField, #osField, #hddField, #graphicField").hide();
                $("#makeField, #modelField").hide();

                // Update 'required' attributes
                $("#processor, #ram, #os, #hdd, #graphics, #assetNo, #serialNo").removeAttr("required");
                $("#accessoryType, #wired").attr("required", "required");
            } 
            else {
                // Show all fields for Laptop, Desktop, etc.
                $("#makeField, #modelField, #processorField, #ramField, #osField, #hddField, #graphicField").show();
                $("#accessoryTypeField, #wiredField").hide()

                // Update 'required' attributes
                $("#make, #model, #processor, #ram, #os, #hdd, #graphics").attr("required", "required");
                $("#accessoryType, #wired").removeAttr("required");
            }
        }
	
		function handlePriorityChange() {
	        var priority = $("#priority").val();
	        console.log(priority);
	        if (priority === "High") {
	            $("#messageField").show();
	            $("#message").attr("required", "required");
	        } else {
	            $("#messageField").hide();
	            $("#message").removeAttr("required");
	        }
	    }
		handlePriorityChange();

	    $("#priority").change(function () {
	        handlePriorityChange();
	    });
		
		$("#makeRequest").on("click", function() {
			var formData = $("#requestForm").serialize();
			console.log(formData);
			$.ajax({
				url: "AddRequestServlet",
				type: "POST",
				data: formData,
				success: function(response) {
					console.log(response);
					$("#requestForm")[0].reset();
					$("#messageField").hide();
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