<?php
/**
 * Routes configuration
 *
 * In this file, you set up routes to your controllers and their actions.
 * Routes are very important mechanism that allows you to freely connect
 * different urls to chosen controllers and their actions (functions).
 *
 * PHP 5
 *
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright 2005-2011, Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright 2005-2011, Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://cakephp.org CakePHP(tm) Project
 * @package       app.Config
 * @since         CakePHP(tm) v 0.2.9
 * @license       MIT License (http://www.opensource.org/licenses/mit-license.php)
 */
/**
 * Here, we are connecting '/' (base path) to controller called 'Pages',
 * its action called 'display', and we pass a param to select the view file
 * to use (in this case, /app/View/Pages/home.ctp)...
 */
    Router::connect('/', array('controller' => 'Offers', 'action' => 'index'));
    Router::connect('/faq', array('controller'=>'Users', 'action' => 'faq') );
    Router::connect('/termsofuse', array('controller'=>'Users', 'action' => 'terms') );
/**
 * ...and connect the rest of 'Pages' controller's urls.
 */
	Router::connect('/pages/*', array('controller' => 'pages', 'action' => 'display'));

/**
 * Load all plugin routes.  See the CakePlugin documentation on
 * how to customize the loading of plugin routes.
 */
	CakePlugin::routes();

    Router::parseExtensions('rss', 'xml', 'json');

    Router::connect('/webservice/offer/activate/*',
        array(  'controller' => 'offers',
                'action' => 'activate_from_offer',
                '[method]' => 'GET'));

    Router::connect('/webservice/offer/terminate/*',
        array(  'controller' => 'offers',
                'action' => 'terminate_from_offer',
                '[method]' => 'GET'));

    Router::connect('/webservice/offer/*',
        array(  'controller' => 'offers',
                'action' => 'view',
                '[method]' => 'GET'));

    Router::connect('/webservice/offers/*',
        array(  'controller' => 'offers',
                'action' => 'index',
                '[method]' => 'GET'));

    Router::connect('/webservice/offer/*',
        array(  'controller' => 'offers',
                'action' => 'edit',
                '[method]' => 'PUT'));

    Router::connect('/webservice/offer',
        array(  'controller' => 'offers',
                'action' => 'webservice_add',
                '[method]' => 'POST'));

/**
 * Load the CakePHP default routes. Remove this if you do not want to use
 * the built-in default routes.
 */
	require CAKE . 'Config' . DS . 'routes.php';
