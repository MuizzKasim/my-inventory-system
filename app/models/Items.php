<?php
namespace App\Models;
use Phalcon\Mvc\Model;

class Items extends Model 
{    
    public function initialize(){
        $this->setSource('items');
    }
}
?>