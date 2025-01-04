<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Add Assets</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<style>
.extra-small-text {
	font-size: 0.75rem;
}

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
    <div class="main-content">
        <div class="container-fluid">
            <h2>Add Assets</h2>
            <div class="container-fluid bg-white p-4">
                <form id="addAssetForm">
                    <div class="d-flex flex-wrap justify-content-between">
                        <div class="col-md-4 mx-5 my-3" id="typeField">
                            <label for="type" class="form-label">Type<span id="requiredStar" class="text-danger">*</span></label>
                            <select id="type" class="form-select">
                                <option value="Laptop" selected>Laptop</option>
                                <option value="Desktop">Desktop</option>
                                <option value="Printer">Printer</option>
                                <option value="Server">Server</option>
                                <option value="Accessories">Accessories</option>
                                <option value="Others">Others</option>
                            </select>
                        </div>
                        <div class="col-md-4 mx-5 my-3" id="serialNoField">
                            <label for="serialNo" class="form-label">Serial No<span id="requiredStar" class="text-danger">*</span></label>
                            <input type="text" id="serialNo" class="form-control" placeholder="Enter Serial No">
                        </div>
                        <div class="col-md-4 mx-5 my-3" id="assetNoField">
                            <label for="assetNo" class="form-label">Asset Number<span id="requiredStar" class="text-danger">*</span></label>
                            <input type="text" id="assetNo" class="form-control" placeholder="Enter Asset No">
                            <p id="assetNoFound" class="text-danger m-0 p-0 extra-small-text">Asset no already present</p>
                        </div>
                        <div class="col-md-4 mx-5 my-3" id="modelField">
                            <label for="model" class="form-label">Model<span id="requiredStar" class="text-danger">*</span></label>
                            <input type="text" id="model" class="form-control" placeholder="Enter the Model">
                        </div>
                        <div class="col-md-4 mx-5 my-3" id="makeField">
                            <label for="make" class="form-label">Make<span id="requiredStar" class="text-danger">*</span></label>
                            <input type="text" id="make" class="form-control" placeholder="Asset Company">
                        </div>
                        <div class="col-md-4 mx-5 my-3" id="processorField">
                            <label for="processor" class="form-label">Processor<span id="requiredStar" class="text-danger">*</span></label>
                            <input type="text" id="processor" class="form-control" placeholder="Enter the Processor">
                        </div>
                        <div class="col-md-4 mx-5 my-3" id="ramField">
                            <label for="ram" class="form-label">RAM<span id="requiredStar" class="text-danger">*</span></label>
                            <input type="text" id="ram" class="form-control" placeholder="Enter the RAM">
                        </div>
                        <div class="col-md-4 mx-5 my-3" id="osField">
                            <label for="os" class="form-label">OS<span id="requiredStar" class="text-danger">*</span></label>
                            <input type="text" id="os" class="form-control" placeholder="Enter the OS">
                        </div>
                        <div class="col-md-4 mx-5 my-3" id="hddField">
                            <label for="hdd" class="form-label">HDD<span id="requiredStar" class="text-danger">*</span></label>
                            <input type="text" id="hdd" class="form-control" placeholder="Enter the HDD">
                        </div>
                        <div class="col-md-4 mx-5 my-3" id="graphicField">
                            <label for="graphics" class="form-label">Graphics<span id="requiredStar" class="text-danger">*</span></label>
                            <input type="text" id="graphics" class="form-control" placeholder="Enter the Graphics">
                        </div>
                        <div class="col-md-4 mx-5 my-3" id="accessoryTypeField">
						    <label for="accessoryType" class="form-label">Accessory Type<span id="requiredStar" class="text-danger">*</span></label>
						    <select id="accessoryType" class="form-select">
						        <option value="Mouse">Mouse</option>
						        <option value="Keyboard">Keyboard</option>
						        <option value="Headphones">Headphones</option>
						        <option value="Others">Others</option>
						    </select>
						</div>
						<div class="col-md-4 mx-5 my-3" id="wiredField">
						    <label for="wired" class="form-label">Wired/Wireless<span id="requiredStar" class="text-danger">*</span></label>
						    <select id="wired" class="form-select">
						        <option value="Wired">Wired</option>
						        <option value="Wireless">Wireless</option>
						    </select>
						</div>
                    </div>
                    <div class="mt-4 text-center">
                        <button type="submit" class="btn btn-primary" id="addAsset">+ Add Asset</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script>
    $(document).ready(function () {
        $("#type").change(updateFieldVisibility);
        updateFieldVisibility();

        function updateFieldVisibility() {
            var type = $("#type").val();
			$("#assetNoFound").hide();
            if (type === "Server" || type === "Printer" || type === "Others") {
                $("#processorField, #ramField, #osField, #hddField, #graphicField, #accessoryTypeField, #wiredField").hide();
                $("#makeField, #modelField, #assetNoField, #serialNoField").show();

                $("#processor, #ram, #os, #hdd, #graphics, #accessoryType, #wired").removeAttr("required");
                $("#make, #model, #serialNo, #assetNo").attr("required", "required");
            } 
            else if (type === "Accessories") {
                $("#accessoryTypeField, #wiredField").show();
                $("#processorField, #ramField, #osField, #hddField, #graphicField, #assetNoField, #serialNoField").hide();
                $("#makeField, #modelField").hide();

                $("#processor, #ram, #os, #hdd, #graphics, #assetNo, #serialNo, #make, #model").removeAttr("required");
                $("#accessoryType, #wired").attr("required", "required");
            } 
            else {
                $("#makeField, #modelField, #processorField, #ramField, #osField, #hddField, #graphicField, #assetNoField, #serialNoField").show();
                $("#accessoryTypeField, #wiredField").hide();

                $("#make, #model, #processor, #assetNo, #serialNo, #ram, #os, #hdd, #graphics").attr("required", "required");
                $("#accessoryType, #wired").removeAttr("required");
            }
        }

        $("#addAssetForm").on("submit", async function (event) {
            event.preventDefault(); 

            
            if (!this.checkValidity()) {
                this.reportValidity();
                return;
            }

            var type = $("#type").val();
            var formData;

            if (type === "Accessories") {
                formData = {
                    accessoryType: $("#accessoryType").val(),
                    wired: $("#wired").val()
                };

                $.ajax({
                    url: "AddAccessoryServlet",
                    type: "POST",
                    data: formData,
                    success: function () {
                    	Swal.fire({
                    		title: "Accessory Added",
                    		icon: "success",
                    		timer: 1500,
                    		showConfirmButton: false
                   		});
                    	$("#addAssetForm")[0].reset(); 
                        updateFieldVisibility(); 
                    },
                    error: function (xhr, status, error) {
                        console.error("Error adding accessory:", error);
                    }
                });
            } else {
                formData = {
                    type: type,
                    assetNo: $("#assetNo").val(),
                    serialNo: $("#serialNo").val(),
                    model: $("#model").val(),
                    make: $("#make").val(),
                    processor: $("#processor").val(),
                    ram: $("#ram").val(),
                    os: $("#os").val(),
                    hdd: $("#hdd").val(),
                    graphics: $("#graphics").val()
                };
                
                var assets = await getAssets();
            	var assetNo = $("#assetNo").val();
            	
            	var asset = assets.find(a => a.assetNo === assetNo);
            	
            	if(asset) {
            		Swal.fire({
                		title: "Asset number already present",
                		icon: "error",
                		timer: 1500,
                		showConfirmButton: false
               		});
            	}
            	else {
            		$("#assetNoFound").hide();
	                $.ajax({
	                    url: "AddAssetServlet",
	                    type: "POST",
	                    data: formData,
	                    success: function () {
	                    	Swal.fire({
	                    		title: "Asset Added",
	                    		icon: "success",
	                    		timer: 1500,
	                    		showConfirmButton: false
	                   		});
	                        $("#addAssetForm")[0].reset(); 
	                        updateFieldVisibility(); 
	                    },
	                    error: function (xhr, status, error) {
	                        console.error("Error adding asset:", error);
	                    }
	                });
            	}
            }
        });
        
        $("#assetNo").on("input", async function() {
        	var assets = await getAssets();
        	var assetNo = $("#assetNo").val();
        	
        	var asset = assets.find(a => a.assetNo === assetNo);
        	
        	if(asset) {
        		$("#assetNoFound").show();
        	}
        	else {
        		$("#assetNoFound").hide();
        	}
        })
        
        async function getAssets() {
        	return $.ajax({
        		url: "ListAssetServlet",
        		type: "GET",
        		dataType: "json"
        	})
        }
    });
    </script>
</body>
</html>
