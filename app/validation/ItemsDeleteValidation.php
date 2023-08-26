<?php
namespace App\Validation;

use Phalcon\Forms\Form;

use Phalcon\Forms\Element\Text;

use Phalcon\Validation\Validator\PresenceOf;
use Phalcon\Validation\Validator\Digit;

class ItemsDeleteValidation extends Form
{
    public function initialize()
    {
        // Handle id validation
        $id = new Text('id',[
            'placeholder' => ''
        ]);

        $id->addValidators([
            new PresenceOf([
                'message' => 'Id is required',
            ]),
            new Digit([
                'message' => 'Id must only contain digits',
            ])
        ]);

        // Add fields to form
        $this->add($id);
    }
}

?>