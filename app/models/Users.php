<?php
namespace App\Models;
use Phalcon\Mvc\Model;

class Users extends Model 
{
    public function initialize(){
        $this->setSource('users');
    }
}
?>