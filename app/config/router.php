<?php

$router = new Phalcon\Mvc\Router();

// Define your routes here

//-------------Index Routing--------------
$router->add('/', 
    [
        'controller' => 'index',
        'action' => 'index'
    ]   
);

$router->add('/about', 
    [
        'controller' => 'index',
        'action' => 'aboutpage'
    ]   
);

$router->add('/login', 
    [
        'controller' => 'index',
        'action' => 'loginpage'
    ]   
);

$router->add('/logout',[
    'controller' => 'index',
    'action' => 'logout'
]);

$router->add('/create', 
    [
        'controller' => 'index',
        'action' => 'createpage'
    ]   
);

$router->add('/read', 
    [
        'controller' => 'index',
        'action' => 'readpage'
    ]   
);

$router->add('/update', 
    [
        'controller' => 'index',
        'action' => 'updatepage'
    ]   
);

$router->add('/delete', 
    [
        'controller' => 'index',
        'action' => 'deletepage'
    ]   
);

//-------------CRUD Routing--------------
$router->add('/api/create',
    [
        'controller' => 'index',
        'action' => 'create',
    ]
);

$router->add('/api/get',
    [
        'controller' => 'index',
        'action' => 'getitems',
    ]
);

$router->add('/api/get/{id}',
    [
        'controller' => 'index',
        'action' => 'getitem',
    ]
);

$router->add('/api/update',
    [
        'controller' => 'index',
        'action' => 'update',
    ]
);

$router->add('/api/delete',
    [
        'controller' => 'index',
        'action' => 'delete',
    ]
);

//-------------Login Routing--------------
$router->add('/api/login',[
    'controller' => 'index',
    'action' => 'login'
]);


return $router;
?>