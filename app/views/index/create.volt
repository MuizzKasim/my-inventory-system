
<div class='container p-5'>
    {{content()}}
    <div class="mb-4">
        <h4 class='text-danger'>Exploring as {{username}}</h4>
        <h1>Create</h1>
    </div>

    <p>Explore the <code>Create</code> operation in this page.</p>
    
    <div class='d-flex justify-content-center '>
        <div class='card mt-5 p-3 w-75'>
            <div class='card-header bg-white py-3'>
                <h4 class='fw-bold '><i>Create Inventory Form</i></h4>
            </div>
            <form id="createForm" method="post" accept-charset="UTF-8" autocomplete="off" action='api/create'>
                <div class='container p-3'>
                    <div class='form-group mb-4'>
                        <label for='name' class='form-label fw-bold'>Name<span class='text-danger fs-6'>*</span></label>
                        <input type='text' class='form-control' id='name' name='name' placeholder='eg. Logitech G502, MSI GK40, HP V20 19.5 inch....' required>
                        <div  class='invalid-feedback'></div>
                    </div>
                    <div class='form-group mb-4'>
                        <label for='type' class='form-label fw-bold'>Type<span class='text-danger fs-6'>*</span></label>
                        <input type='text' class='form-control' id='type' name='type'  placeholder='eg. Mouse, Keyboard, Monitor, Printer...' required>
                        <div  class='invalid-feedback'></div>
                    </div>
                    <div class='form-group mb-4'>
                        <label for='quantity' class='form-label fw-bold'>Quantity<span class='text-danger fs-6'>*</span></label>
                        <input type='number' step='1' min='0' class='form-control' id='quantity' name='quantity'  placeholder='eg. 1' required>
                        <div  class='invalid-feedback'></div>
                    </div>
                    <div class='form-group mb-4'>
                        <label for='price' class='form-label fw-bold'>Price<span class='text-danger fs-6'>*</span></label>
                        <input type='number' step='0.01' min='0' class='form-control' id='price' name='price'  placeholder='eg. 5.00' required>
                        <div  class='invalid-feedback'></div>
                    </div>
                    <div class='form-group mb-4'>
                        <label for='description' class='form-label fw-bold'>Description</label>
                        <textarea class='form-control' id='description' name='description' rows='3' placeholder='optional'></textarea>
                        <div  class='invalid-feedback'></div>
                    </div>
                </div>
                <div class='card-footer bg-white pt-4'>
                    <div class='d-flex justify-content-between align-items-center'>
                        <div>
                            <p class='text-danger fs-6'>* denotes required fields</p>
                        </div>
                        {% if user_login %}
                                <div>
                                    <button type='submit' id='submitBtn' class='btn btn-success'><i class="bi bi-database-fill-add"></i> Create </button>
                                </div>
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
// Create Form
$(document).ready(function() {
    $('#createForm').submit(function(e) {
        e.preventDefault();
        var formData = $(this).serialize();
        
        $.ajax({
            type: 'POST',
            url: $(this).attr('action'),
            data: formData,
            success: function(response) {
                // console.log(response)
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
                statusCode = xhr.status;
                // console.log(statusCode);
                message = xhr.responseJSON.message;

                if(statusCode == 400){
                    feedback = xhr.responseJSON.feedback;
                    for (let key in feedback){
                        clearInvalidField('#'+key); // clear old feedback first before adding new feedback
                        setInvalidField('#'+key, feedback[key]);
                    }
                }else{
                    // statusCode 500
                    $('#feedback').append(`
                    <div class='alert alert-danger alert-dismissible fade show mb-2' role='alert'>
                        <p class='mb-0'><i class="bi bi-exclamation-triangle-fill"></i> ${message}</p>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    `);
                    $('#feedback').focus();
                    window.location.href = '#feedback';
                }
            }
        });
    });
});


// for Create Form Feedback Rendering and Clearing 
function setInvalidField(field, message){
    $(field).closest('.form-group').find('.invalid-feedback').html(message);
    $(field).addClass('is-invalid');
}

function clearInvalidField(field){
    $(field).closest('.form-group').find('.invalid-feedback').html('');
    $(field).removeClass('is-invalid');
}
</script>
