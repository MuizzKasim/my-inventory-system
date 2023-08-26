<?php
namespace App\Validation;

use Phalcon\Forms\Form;

use Phalcon\Forms\Element\Text;
use Phalcon\Forms\Element\Email;
use Phalcon\Forms\Element\Numeric;
use Phalcon\Forms\Element\TextArea;
use Phalcon\Forms\Element\Hidden;

use Phalcon\Validation\Validator\PresenceOf;
use Phalcon\Validation\Validator\StringLength;
use Phalcon\Validation\Validator\Digit;
use Phalcon\Validation\Validator\Numericality;
use Phalcon\Validation\Validator\Regex;
use Phalcon\Validation\Validator\Alnum;

class ItemsUpdateValidation extends Form
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

        // Handle name validation
        $name = new Text('name',[
            'placeholder' => ''
        ]);

        $name->addValidators([
            new PresenceOf([
                'message' => 'Name is required'
            ]),
            new StringLength([
                'max' => 255,
                'messageMaximum' => 'Name is too long'
            ]),
            new Regex([
                'pattern' => '/^[A-Za-z0-9\s]+$/',
                'message' => 'Name contains invalid characters (symbols)'
            ])
        ]);


        // Handle type validation
        $type = new Text('type',[
            'placeholder' => ''
        ]);

        $type->addValidators([
            new PresenceOf([
                'message' => 'Type is required'
            ]),
            new StringLength([
                'max' => 255,
                'messageMaximum' => 'Type is too long'
            ]),
            new Alnum([
                'message' => 'Type contains invalid characters (whitespaces and/or symbols)'
            ])
        ]);


        // Handle description validation
        $description = new TextArea('description',[
            'placeholder' => ''
        ]);

        $description->addValidators([
            new Regex([
                'pattern' => '/^[A-Za-z0-9\s]+$/',
                'message' => 'Description contains invalid characters (symbols)'
            ])
        ]);


        // Handle quantity validation
        $quantity = new Numeric('quantity',[
            'placeholder' => '' 
        ]);

        $quantity->addValidators([
            new PresenceOf([
                'message' => 'Quantity is required'
            ]),
            new Numericality([
                'message' => 'Quantity must be a valid number',
                'allowFloat' => false,
                'min' => 0,
                'messageMinimum' => 'Quantity cannot be negative'                
            ])
        ]);


        // Handle price validation
        $price = new Numeric('price',[
            'placeholder' => ''
        ]);

        $price->addValidators([
            new PresenceOf([
                'message' => 'Price is required'
            ]),
            new Numericality([
                'message' => 'Price must be a valid floating point number',
                'allowFloat' => true,
                'min' => 0,
                'messageMinimum' => 'Price cannot be negative'                
            ])
        ]);


        // Add fields to form
        $this->add($id);
        $this->add($name);
        $this->add($type);
        $this->add($description);
        $this->add($quantity);
        $this->add($price);
    }
}

?>