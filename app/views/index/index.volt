<div class='container p-5'>
    <div class="page-header">
        <h4 class='text-danger'>Exploring as {{username}}</h1>
        <h1>Welcome to the Dashboard!</h1>
    </div>
    <br>
    <p>To use the website, navigate using the nav links in the navigation bar above.</p>
    <p>Explore each CRUD <code>(Create, Read, Update, Delete)</code> operations to modify the backend database.</p>
    <p>Normal users can only perform Create, Read, Update but not Delete. </p>
    <p>You will need an Administrator account to perform Delete operations.</p>
    <br>
    <div class='card'>
        <div class='container p-3'>
            <div class='card-header bg-white'>
                <i class='fw-bold h3'>Inventory Statistics</i>
            </div>
            <div class='row py-3'>
                {% if stats %}
                    <div class='col col-4'>
                        <div class='card alert alert-success'>
                            <div class='container'>
                                <p class='text-center fw-bold p-0 m-0'>Total Items Quantity:</p>
                                <p class='text-center fw-bold p-0 m-0'>{{ totalItemsCount }}</p>
                            </div> 
                        </div>
                    </div>
                    <div class='col col-4'>
                        <div class='card alert alert-danger'>
                            <div class='container'>
                                <p class='text-center fw-bold p-0 m-0'>Total Unique Types:</p>
                                <p class='text-center fw-bold p-0 m-0'>{{ totalUniqueItemTypesCount }}</p>
                            </div> 
                        </div>
                    </div>
                    <div class='col col-4'>
                        <div class='card alert alert-warning'>
                            <div class='container'>
                                <p class='text-center fw-bold p-0 m-0'>Total Unique Items:</p>
                                <p class='text-center fw-bold p-0 m-0'>{{ totalUniqueItemsCounts }}</p>
                            </div> 
                        </div>
                    </div>
                {% endif %}
            </div>
        </div>
    </div>
</div>
{{  content() }}