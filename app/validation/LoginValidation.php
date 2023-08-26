<?php
namespace App\Validation;

use Phalcon\Forms\Form;
use Phalcon\Forms\Element\Text;
use Phalcon\Forms\Element\Email;
use Phalcon\Forms\Element\Password;
use Phalcon\Validation\Validator\PresenceOf;
use Phalcon\Validation\Validator\StringLength;
use Phalcon\Validation\Validator\Email as EmailValidator;

class LoginValidation extends Form
{
    public function initialize()
    {
        // Handle email validation
        $email = new Email('email', [
            'placeholder' => 'Email'
        ]);

        $email->addValidators([
            new PresenceOf([
                'message' => 'Email is required'
            ]),
            new EmailValidator([
                'message' => 'Email entered is invalid'
            ])
        ]);

        // Handle password validation
        $password = new Password('password', [
            'placeholder' => 'Password'
        ]);

        $password->addValidators([
            new PresenceOf([
                'message' => 'Password is required'
            ]),
            new StringLength([
                'min' => 8,
                'messageMinimum' => 'Password must be at least 8 characters long'
            ])
        ]);

        // Add fields to form
        $this->add($email);
        $this->add($password);
    }
}

?>