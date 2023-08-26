{{content()}}
<div id='feedback'>

</div>
<div class='container p-5'>
    <div class='d-flex justify-content-center '>
        <div class='card mt-0 p-3 bg-light' style='max-width:450px;'>
            <div class=' py-3'>
                <h4 class='fw-bold '><i>Login Form</i></h4>
            </div>
            <div class='container p-3'>
                <div class='py-5 text-center'>
                    <img class='img-fluid pb-3' style='max-width:160px;' src='{{ url('img/seeklogo-icon.png') }}' alt='image not available'>
                    <label class='form-label fw-bold h2'>My Inventory System</label>
                </div>
                <form id='loginForm' method='post' action='api/login' autocomplete='off' >
                    <div class='form-group mb-4'>
                        <label for='email' class='visually-hidden'>Email</label>
                        <input type='email' class='form-control rounded-5' id='email' name='email' placeholder='Email' required>
                        <div  class='invalid-feedback'>
                        </div>
                    </div>
                    <div class='form-group mb-4'>
                        <label for='password' class='visually-hidden'>Password</label>
                        <input type='password' class='form-control rounded-5' id='password' name='password' placeholder='Password' required>
                        <div  class='invalid-feedback'>
                        </div>
                    </div>
                    <div class='text-center'>
                        <button type='submit' class='btn btn-block btn-success w-75'> Login </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <br>
    <br>
    <div class='row'>
        <div class='col col-2'></div>
        <div class='col col-8'>
            <p class='fw-bold text-start'>Testing Accounts - Login Details</p>
            <p class='text-start'>Use the following accounts to test this project</p>
        </div>
        <div class='col col-2'></div>
    </div>
    <br>
    <br>
    <div class='row'>
        <div class='col col-2'></div>
        <div class='col-4'>
            <p class='fw-bold'>Regular user</p>
            <p>Username: John</p>
            <p>Email: john@example.com</p>
            <p>Password: UserJohn</p>
        </div>
        <div class='col col-4'>
            <p class='fw-bold'>Administrator</p>            
            <p>Username: Admin</p>
            <p>Email: admin@example.com</p>
            <p>Password: AdminPower100!</p>
        </div>
        <div class='col col-2'></div>
    </div>
</div>
<script>
// Login form logic
$(document).ready(function() {
    $('#loginForm').submit(function(e) {
        e.preventDefault();
        var formData = $(this).serialize();
        
        $.ajax({
            type: 'POST',
            url: $(this).attr('action'),
            data: formData,
            success: function(response) {
                $('.is-invalid').removeClass('is-invalid');
                message = response.message;

                console.log(response);
                if(response.success){
                    window.location.reload();
                }

            },
            error: function(xhr, status, error) {
                statusCode = xhr.status;
                message = xhr.responseJSON.message;
                
                if(statusCode == 400){
                    feedback = xhr.responseJSON.feedback;
                    for (let key in feedback){
                        clearInvalidField('#'+key); // clear old feedback first before adding new feedback
                        setInvalidField('#'+key, feedback[key]);
                    }
                }
                else if(statusCode == 404){
                    $('#feedback').append(`
                    <div class='alert alert-warning alert-dismissible fade show mb-2' role='alert'>
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

// for Login Feedback Rendering and Clearing 
function setInvalidField(field, message){
    $(field).closest('.form-group').find('.invalid-feedback').html(message);
    $(field).addClass('is-invalid');
}

function clearInvalidField(field){
    $(field).closest('.form-group').find('.invalid-feedback').html('');
    $(field).removeClass('is-invalid');
}
</script>
