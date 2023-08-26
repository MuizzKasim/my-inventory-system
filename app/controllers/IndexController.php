<?php

use App\Models\Users;
use App\Models\Items;

// Validators
use App\Validation\LoginValidation as Login;
use App\Validation\ItemsCreateValidation as Create;
use App\Validation\ItemsDeleteValidation as Delete;
use App\Validation\ItemsUpdateValidation as Update;

class IndexController extends ControllerBase
{
    // Initializations
    public function initialize(){
        $this->view->setTemplateBefore('main');
        
        // Set view variables
        $this->view->setVar('user_login', $this->session->get('user_login'));
        $this->view->setVar('roleId', $this->session->get('roleId'));
        if($this->session->get('username') == null){
            $this->view->setVar('username', 'Guest');
        }else{
            $this->view->setVar('username', $this->session->get('username'));
        }
    }

    public function indexAction()
    {   
        if(!$this->session->get('user_login')){
            $this->view->pick('index/login');
        }else{
            $this->assignStats();
            $this->view->pick('index/index');       
        }
    }

    // Page Renders
    public function aboutPageAction(){
        $this->view->pick('index/about');
    }

    public function loginPageAction(){
        $this->view->pick('index/login');
    }
    
    public function createPageAction(){
        $this->view->pick('index/create');
    }

    public function readPageAction(){
        $this->view->pick('index/read');
    }

    public function updatePageAction(){
        $this->view->data = $this->assignProps();
        $this->view->pick('index/update');
    }

    public function deletePageAction(){
        $this->view->data = $this->assignProps();
        $this->view->pick('index/delete');
    }

    // Assign Properties for View Rendering
    public function assignProps(){
        $items = Items::find([
            'conditions' => 'deleted=0'
        ]);

        $result = [];
        foreach ($items as $item){
            $result[$item->id] = $item->name;
        }

        $this->view->setVar('items', $result);
    }

    public function assignStats(){

        $uniqueItemTypes = Items::find([
            'columns' => 'DISTINCT type',
            'conditions' => 'deleted = 0'
        ]);
        $totalUniqueItemTypesCount = $uniqueItemTypes->count();
        
        $totalUniqueItemsCount = Items::count([
            'conditions' => 'deleted = 0'
        ]);
        $totalItemsCount = Items::sum([
            'column' => 'quantity',
            'conditions' => 'deleted = 0'
        ]);

        if($uniqueItemTypes){
            $this->view-> setVar('stats', true);

            //send count stats
            $this->view->setVar('totalUniqueItemTypesCount', $totalUniqueItemTypesCount);
            $this->view->setVar('totalUniqueItemsCounts', $totalUniqueItemsCount);
            $this->view->setVar('totalItemsCount', $totalItemsCount);
        }else{
            $this->view->setVar('stats', false);
        }
        
    }

    // Login/Logout Logic
    public function loginAction(){
        $this->view->disable();
        
        // Data Validation 
        $data = $this->request->getPost();
        $login = new Login();

        if(!$login->isValid($data)){
            $array = [];
            foreach ($login->getMessages() as $message) {
                $array[$message->getField()] = $message->getMessage();   
            }
            return $this->response->setStatusCode(400)->setJsonContent([
                'success' => false,
                'feedback' => $array
            ]);
        }

        // Perform Db Query
        $email = $this->request->getPost('email', 'striptags');
        $password = $this->request->getPost('password', 'striptags');

        $user = Users::findFirst([
            'conditions' => 'email=?1 AND deleted=0',
            'bind' => [
                1 => $email
            ]
        ]);

        $passCheck = $this->security->checkHash($password, $user->password);

        if($user && $passCheck){
            // Account exists
            // Status Code 200: success
            $this->session->set('user_login', true);
            $this->session->set('roleId', $user->roleId );
            $this->session->set('username', $user->username);

            return $this->response->setStatusCode(200)->setJsonContent([
                'success' => true,
                'message' => 'Login Success'
            ]);
        }
        else
        {
            // Account does not exist
            // Status Code 404: not found
            return $this->response->setStatusCode(404)->setJsonContent([
                'success' => false,
                'message' => 'Invalid login credentials'
            ]);
        }
    }

    public function logoutAction(){
        // clear session login info
        $this->session->set('user_login', false);
        $this->session->remove('roleId');
        $this->session->remove('username');

        return $this->response->redirect('');
    }

    // CRUD logic
    // Create
    public function createAction(){

        // Data Validation 
        $data = $this->request->getPost();
        $create = new Create();

        if(!$create->isValid($data)){
            $array = [];
            foreach ($create->getMessages() as $message) {
                $array[$message->getField()] = $message->getMessage();   
            }
            return $this->response->setStatusCode(400)->setJsonContent([
                'success' => false,
                'feedback' => $array
            ]);
        }

        // Perform Db Query
        $new = new Items([
            'name'          => $this->request->getPost('name','striptags'),
            'type'          => $this->request->getPost('type','striptags'),
            'description'   => $this->request->getPost('description','striptags'),
            'quantity'      => $this->request->getPost('quantity','striptags'),
            'price'         => $this->request->getPost('price','striptags'),
        ]);

        if($new->create())
        {
            //code 200: success
            // $this->flash->success('New item created successfully!');
            return $this->response->setStatusCode(200)->setJsonContent([ 
                'success' => true,
                'message' => 'New item created successfully!',
            ]);
        }   
        else
        {
            //code 500: internal server error
            // $this->flash->error('Internal server error occured! Please try again');
            return $this->response->setStatusCode(500)->setJsonContent([ 
                'success' => false,
                'message' => 'Internal server error occured! Please try again'
            ]);
        }
        
    }
    
    // Read - all
    public function getItemsAction(){
        $this->view->disable();

        // Perform Db Query
        $items = Items::find([
            'conditions' => 'deleted=0',
        ]);

        $result= [];
        $counter = 0;

        foreach($items as $item){
            $result[$counter]               = new \StdClass();
            $result[$counter]->id           = $item->id;
            $result[$counter]->name         = $item->name;
            $result[$counter]->type         = $item->type;
            $result[$counter]->description  = $item->description;
            $result[$counter]->quantity     = $item->quantity;
            $result[$counter]->price        = $item->price;
            $result[$counter]->created      = $item->created;
            $result[$counter]->updated      = $item->updated;
            $result[$counter]->deleted      = $item->deleted;

            $counter++;
        }

       return $this->response->setStatusCode(200)->setJsonContent([ 
            json_encode(array('data' => $result))
        ]);
    }

    // Read - by ID
    public function getItemAction($id){
        $this->view->disable();

        $item = Items::findFirst([
            'conditions' => 'id=?0 AND deleted=?1',
            'bind' => [
                0 => $id,
                1 => 0
            ]
        ]);

        if($item){
            $result = [];

            $result[0]               = new \StdClass();
            $result[0]->id           = $item->id;
            $result[0]->name         = $item->name;
            $result[0]->type         = $item->type;
            $result[0]->description  = $item->description;
            $result[0]->quantity     = $item->quantity;
            $result[0]->price        = $item->price;
            $result[0]->created      = $item->created;
            $result[0]->updated      = $item->updated;
            $result[0]->deleted      = $item->deleted;

            return $this->response->setStatusCode(200)->setJsonContent([ 
                json_encode(array('data' => $result))
            ]);
        }
        else
        {
            return $this->response->setStatusCode(400)->setJsonContent([
                'success' => false,
                'message' => 'Data unavailable'
            ]);
        }
    }

    // Update
    public function updateAction(){
        $this->view->disable();
        
        // Data Validation 
        $data = $this->request->getPost();
        $update = new Update();

        if(!$update->isValid($data)){
            $array = [];
            foreach ($update->getMessages() as $message) {
                $array[$message->getField()] = $message->getMessage();   
            }
            return $this->response->setStatusCode(400)->setJsonContent([
                'success' => false,
                'feedback' => $array
            ]);
        }

        // Perform Db Query
        $item = Items::findFirst([
            'conditions' => 'id=?0 AND deleted=?1',
            'bind' => [
                0 => $this->request->getPost('id', 'striptags'),
                1 => 0
            ],
        ]);

        if($item)
        {
            //item found, proceed to update
            $item->assign([
                'name'          => $this->request->getPost('name','striptags'),
                'type'          => $this->request->getPost('type','striptags'),
                'description'   => $this->request->getPost('description','striptags'),
                'quantity'      => $this->request->getPost('quantity','striptags'),
                'price'         => $this->request->getPost('price','striptags'),
                'updated'       => date('Y-m-d H:i:s')
            ]);

            if($item->save())
            {
                //code 200: success
                return $this->response->setStatusCode(200)->setJsonContent([
                    'success' => true,
                    'message' => 'Item updated successfully!'
                ]);
            }
            else
            {
                //code 500: internal server error
                return $this->response->setStatusCode(500)->setJsonContent([
                    'success' => false,
                    'message' => 'Internal server error occured! Please try again'
                ]);
            }
        }
        else
        {
            //code 404: item not found
            return $this->response->setStatusCode(404)->setJsonContent([
                'success' => false,
                'message' => 'Item you were looking for is not available'
            ]);
        }
    }

    // Delete
    public function deleteAction(){
        $this->view->disable();
        
        // Data Validation 
        $data = $this->request->getPost();
        $delete = new Delete();

        if(!$delete->isValid($data)){
            $array = [];
            foreach ($delete->getMessages() as $message) {
                $array[$message->getField()] = $message->getMessage();   
            }
            return $this->response->setStatusCode(400)->setJsonContent([
                'success' => false,
                'feedback' => $array
            ]);
        }

        // Perform Db Query
        $item = Items::findFirst([
            'conditions' => 'id=?0 AND deleted=?1',
            'bind' => [
                0 => $this->request->getPost('id'),
                1 => 0
            ],
        ]);

        if($item)
        {
            //item found, proceed to update
            $item->assign([
                'deleted' => 1,
                'updated' => date('Y-m-d H:i:s')
            ]);

            if($item->save())
            {
                //code 200: success
                return $this->response->setStatusCode(200)->setJsonContent([
                    'success' => true,
                    'message' => 'Item deleted successfully!'
                ]);
            }
            else
            {
                //code 500: internal server error
                return $this->response->setStatusCode(500)->setJsonContent([
                    'success' => false,
                    'message' => 'Internal server error occured! Please try again'
                ]);
            }
        }
        else
        {
            //code 404: item not found
            return $this->response->setStatusCode(404)->setJsonContent([
                'success' => false,
                'message' => 'Item you were looking for is not available'
            ]);
        }
    }
}


