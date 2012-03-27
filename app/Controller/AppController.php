<?php

App::uses('ImageExtensionException', 'Error');
App::uses('UploadFileException', 'Error');

App::import('Vendor', 'OfferStates');
App::import('Vendor', 'Flash');

class AppController extends Controller{

    public $components = array(
        'Session',
        'Auth' => array(
            'authenticate' => array(
                'Ldap',
                'Form'
            )
        )
    );

    public $helpers = array('Session', 'Form', 'Js' => array('Jquery'), 'Html');

    function beforeFilter() {
        //clear authError default message
        $this->Auth->authError = " ";
    }
}
