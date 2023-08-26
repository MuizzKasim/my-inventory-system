
<div class='container p-5'>
	{{content()}}
	<div class="mb-4">
		<h4 class='text-danger'>Exploring as {{username}}</h4>
		<h1>Delete</h1>
	</div>

	<p>Explore the
		<code>Delete</code>
		operation in this page.</p>

	<div class='card'>
		<div class='container p-3 pb-0'>
			<form id="selectForm" method="post" accept-charset="UTF-8" autocomplete="off" enctype="multipart/form-data">
				<div class='form-group mb-4'>
					<label for='' class='form-label fw-bold'>Select Data:</label>
					{% if user_login %}
						<select class='form-control' id='load' name='load'>
							<option value='' selected readonly>None</option>
							{% for id,name in items %}
								<option value={{id}}>{{name}}</option>
							{% endfor %}
						</select>
					{% else %}
						<select class='form-control' id='load' name='load' disabled>
							<option value='' selected disabled>None</option>
						</select>
						<div class='mb-0 mt-3 d-flex justify-content-center'>
							<p class='p-0 m-0'>You must first <a type='button' id='signinBtn' class='btn btn-warning' href='{{url('login')}}'>Sign in</a> to interact with this compoennt</p>
						</div>
					{% endif %}
				</div>
			</form>
		</div>
	</div>

	<div class='d-flex justify-content-center '>
		<div class='card mt-5 p-3 w-75'>
			<div class='card-header bg-white py-3'>
				<h4 class='fw-bold '>
					<i>Inventory Details</i>
				</h4>
			</div>
			<form id="deleteForm" method="post" accept-charset="UTF-8" autocomplete="off" enctype="multipart/form-data" action='api/delete'>
				<div class='container p-3'>
					<div class='form-group mb-4'>
						<label for='' class='form-label fw-bold'>ID</label>
						<input type='text' class='form-control w-25 alert alert-secondary py-1' id='id' name='id' readonly>
						<div  class='invalid-feedback'></div>
					</div>
					<div class='form-group mb-4'>
						<label for='' class='form-label fw-bold'>Name</label>
						<input type='text' class='form-control alert alert-secondary py-1' id='name' name='name'  readonly>
						<div  class='invalid-feedback'></div>
					</div>
					<div class='form-group mb-4'>
						<label for='' class='form-label fw-bold'>Type</label>
						<input type='text' class='form-control alert alert-secondary py-1' id='type' name='type'  readonly>
						<div  class='invalid-feedback'></div>
					</div>
					<div class='form-group mb-4'>
						<label for='' class='form-label fw-bold'>Quantity</label>
						<input type='number' step='1' class='form-control alert alert-secondary py-1' id='quantity' name='quantity' readonly>
						<div  class='invalid-feedback'></div>
					</div>
					<div class='form-group mb-4'>
                        <label for='price' class='form-label fw-bold'>Price</label>
                        <input type='number' step='0.01' min='0' class='form-control alert alert-secondary py-1' id='price' name='price' readonly>
						<div  class='invalid-feedback'></div>
                    </div>
					<div class='form-group mb-4'>
						<label for='' class='form-label fw-bold'>Description</label>
						<textarea class='form-control alert alert-secondary py-1' id='description' name='description' rows='3' readonly></textarea>
						<div  class='invalid-feedback'></div>
					</div>
				</div>
				<div class='card-footer bg-white pt-4'>
					<div class='d-flex justify-content-between align-items-center'>
						<div>
							<p class='text-danger fs-6'>* denotes required fields</p>
							<p></p>
						</div>
						{% if user_login %}
                            {% if roleId == 1 %}
                                <div>
									<button type='submit' id='submitBtn' class='btn btn-danger'>
										<i class="bi bi-database-fill-x"></i>
										Delete
									</button>
								</div>
							{% else %}
								<div>
									<p>User not authorized to perform this action</p>
								</div>
                            {% endif %}
                        {% else %}
                            <div>
                                <p>You must first <a type='button' id='signinBtn' class='btn btn-warning' href='{{url('login')}}'>Sign in</a></p>
                            </div>
                        {% endif %}
					</div>
				</div>
			</form>
		</div>
	</div>
	
	<div class='card my-5 p-3'>
        <h4 class='fw-bold '><i>Feedback Responses</i></h4>
        <div class='card-body'>
            <div id='feedback'>
        
            </div>
        </div>
    </div>

</div>

<script>

// Select logic
var id;
var data;

$(document).ready(function(){
	$('#load').on('change', function() {
        id = $(this).val();

		// Ajax Call
		let ajaxURL = window.location.protocol + '//' + window.location.hostname +'/my-inventory-system/api/get/'+id;
		$.ajax({
			url: ajaxURL,
			dataSrc: 'data',
			success: function(response){
				data = JSON.parse(response).data[0];
				changeForm(data);
			},
			error: function(xhr, status, error){
				parse = xhr.responseText;
				alert(parse['message']);
			}
		});
		
    });	
});

function changeForm(data){
	$('#id').val(data.id);
	$('#name').val(data.name);
	$('#type').val(data.type);
	$('#description').val(data.description);
	$('#quantity').val(data.quantity);
	$('#price').val(data.price);
}

// Form logic
$(document).ready(function() {
    $('#deleteForm').submit(function(e) {
        e.preventDefault();
        var formData = $(this).serialize();
		
        $.ajax({
            type: 'POST',
            url: $(this).attr('action'),
            data: formData,
            success: function(response) {
                message = response.message;

				$('#feedback').append(`
                <div class='alert alert-success alert-dismissible fade show mb-2' role='alert'>
                    <p class='mb-0'><i class="bi bi-check-circle-fill"></i> ${message}</p>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                `);
                window.location.href = '#feedback';
            },
            error: function(xhr, status, error) {
                message = xhr.responseJSON.message;
				statusCode = xhr.status;

				if(statusCode == 400){
                    feedback = xhr.responseJSON.feedback;
                    for (let key in feedback){
                        clearInvalidField('#'+key); // clear old feedback first before adding new feedback
                        setInvalidField('#'+key, feedback[key]);
                    }
                }else{
					if(statusCode == 404){
						template = `<div class='alert alert-warning alert-dismissible fade show mb-2' role='alert'>
										<p class='mb-0'><i class="bi bi-exclamation-triangle-fill"></i> ${message}</p>
										<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
									</div>`	
					}else{
						//status code 500
						template = `<div class='alert alert-danger alert-dismissible fade show mb-2' role='alert'>
										<p class='mb-0'><i class="bi bi-exclamation-triangle-fill"></i> ${message}</p>
										<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
									</div>`
					}

					$('#feedback').append(`${template}`);
					window.location.href = '#feedback';
				}
            },
			complete: function(xhr, status){
				var url = window.location.href;
				url = url.includes('#')? url.substring(0, url.indexOf('#')) : url;

				setTimeout(() => {
					location.replace(url);
				}, 2000);
			}
        });
    });
});

// For Form Feedback Rendering and Clearing 
function setInvalidField(field, message){
    $(field).closest('.form-group').find('.invalid-feedback').html(message);
    $(field).addClass('is-invalid');
}

function clearInvalidField(field){
    $(field).closest('.form-group').find('.invalid-feedback').html('');
    $(field).removeClass('is-invalid');
}
</script>
