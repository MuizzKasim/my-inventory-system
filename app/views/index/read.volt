
<div class='container p-5'>
    {{content()}}
    <div class="mb-4">
        <h4 class='text-danger'>Exploring as {{username}}</h4>
        <h1>Read</h1>
    </div>

    <p>Explore the <code>Read</code> operation in this page.</p>

    <div class='card'>
        <div class='container p-3'>
            <form method='get'>
                <div class='form-group mb-4'>
                    <label for='id' class='form-label fw-bold'>Find item by ID:</label>
                    <input type='number' step='1' min='1' class='form-control' name='id' id='id' placeholder='Enter item id' required>
                </div>
                {% if user_login %}
                    {% if roleId == 1 or roleId == 0  or roleId == '1' or roleId =='0' %}
                    <div class='input-group d-flex justify-content-center'>
                        <button id='getByIdBtn' type='button' class='btn btn-success'>Get record by ID</button>
                        <button id='getAllBtn' type='button' class='btn btn-outline-success'>Get all record</button>
                    </div>
                    {% endif %}
                {% else %}
                    <div class='d-flex justify-content-end'>
                        <p>You must first <a type='button' id='signinBtn' class='btn btn-warning' href='{{url('login')}}'>Sign in</a></p>
                    </div>
                {% endif %}
            </form>
            
        </div>
    </div>

    <div class='container mt-5'>
        <div class='table-responsive'>
            <table class='table table-hover ' id='read-table'>
                <thead>
                    <tr>
                        <th scope='col'>Id</th>
                        <th scope='col'>Name</th>
                        <th scope='col'>Type</th>
                        <th scope='col'>Description</th>
                        <th scope='col'>Quantity</th>
                        <th scope='col'>Price</th>
                        <th scope='col'>Created</th>
                        <th scope='col'>Updated</th>
                        <th scope='col'>Deleted</th>
                    </tr>
                </thead>
            </table>
        </div>
    </div>
</div>

<script>
// public variables
var allData;
var readTable = new DataTable('#read-table', { // initialize Data Table without any data
    columns:[
    {data: 'id'}, {data: 'name'}, {data: 'type'}, {data: 'description'}, {data: 'quantity'}, {data: 'price'}, {data: 'created'}, {data:'updated'}, {data:'deleted'}
]});

// Functions for Data Tables
function clearTable(){
    readTable.clear();
    readTable.draw();
}

function renderTable(data){
    readTable.clear();
    readTable.rows.add(data);
    readTable.draw();
}

// Ajax calls
$.ajax({
         url: "{{url('api/get')}}",
        dataSrc: 'data',
        success: function(response){
            allData = JSON.parse(response);
        },
        error: function(xhr, status, error) {
            alert(error);
        } 
})


// Button click logic
$(document).ready(function(){

    $('#getByIdBtn').on('click', function(e){
        e.preventDefault();
        let id = $('#id').val();
        if(id == ''){
            clearTable();
        }else{
            let ajaxURL = window.location.protocol + '//' + window.location.hostname + '/my-inventory-system/api/get/' + id;
            $.ajax({
                url: ajaxURL,
                dataSrc: 'data',
                success: function(response){
                    data = JSON.parse(response);
                    renderTable(data.data);
                },
                error: function(xhr, status, error){
                    parse = JSON.parse(xhr.responseText);
                    alert(parse['message']);
                }
            })
        }
        
    });

    $('#getAllBtn').on('click', function(e){
        e.preventDefault();
        renderTable(allData.data);
    });
});
</script>
