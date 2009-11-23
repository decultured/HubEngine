<?php

// setup our environment
ini_set('include_path', ini_get('include_path').';framework/;data_access/');
ini_set('display_errors', 'On');
ini_set('magic_quotes_runtime', false);

require_once('framework/util.inc.php');
require_once('framework/mysql.inc.php');
require_once('framework/smarty/Smarty.class.php');

// Framework Class
class Framework {

  var $sqlDb;
  var $tplEngine;
  var $tplCaching = false;

  var $activity_log;
  
  var $page_wrapper = "default";
  var $current_page;
  var $theme;

  var $_CONFIG;
  var $_APP;

  function Framework() {
    // set the timezone
    date_default_timezone_set('America/Chicago');
    // tell the system we're a module.
    define('IN_MODULE', true);
    
    $this->_CONFIG = array();
    $this->_APP = array();
    $this->_FRAMEWORK = array();
  }

  function LoadConfiguration() {
  	// Load the configuration
  	$_GLOBAL_CONFIG = parse_ini_file("config/global.ini", true);
  	$_LOCAL_CONFIG = parse_ini_file("config/{$_GLOBAL_CONFIG['local_config']}", true);
  	$this->_CONFIG = array_merge($_GLOBAL_CONFIG, $_LOCAL_CONFIG);
  }
  
  function LoadMySQL() {
    // Init The MySQL Connection
    $this->sqlDb = new ezMySql($this->_CONFIG['database']['host'], $this->_CONFIG['database']['username'], $this->_CONFIG['database']['password'], $this->_CONFIG['database']['database']);
  }
  
  function LoadTemplateEngine() {
    // Init the template engine
    $this->tplEngine = new Smarty();
    $this->tplEngine->template_dir = './';
    $this->tplEngine->compile_dir  = 'templates_c/';
    $this->tplEngine->cache_dir    = 'cache/';
    $this->tplEngine->force_compile = true;
    
    $this->tplEngine->plugins_dir[] = realpath('smarty_plugins/');
    
    $this->tplEngine->assign_by_ref('_CONFIG', $this->_CONFIG);
    $this->tplEngine->assign_by_ref('_GET', $_GET);
    $this->tplEngine->assign_by_ref('_REQUEST', $_REQUEST);
    $this->tplEngine->assign_by_ref('framework', $this);
    $this->tplEngine->register_function('RunModule', array(&$this, 'RunModule_Smarty'));
    $this->tplEngine->register_function('RunPagelet', array(&$this, 'RunPagelet_Smarty'));
    
    $tplEngine->caching = $this->tplCaching;
  }
  
  function LoadTheme($theme = null) {
    if ($theme != null && $theme) {
     	$this->theme = $theme;
    } else if ($this->_CONFIG["theme"] != null) {
     	$this->theme = $this->_CONFIG["theme"];
    }

    if (!file_exists("themes/{$this->theme}/")) {
      $this->theme = "default";
    }
  }
  
  // Note: Module names may only contain alpha numeric characters
  // and underscores, all other characters are stripped from the 
  // input for security purposes.  The '.php' extension
  // should be left out of the request.
  function RunModule($requested_module) {
    $requested_module = preg_replace("/[^a-zA-Z0-9_\-\/]/","",$requested_module);
		$requested_module .= '.php';

  	// see if our module exists
  	if(file_exists("modules/{$requested_module}") == false) {
      return "Module [{$module}] cannot be found.";
  	}

  	// run and buffer the requested module
  	ob_start();
  	require_once("modules/{$requested_module}");
  	return ob_get_clean();
  }
  
  function RunModule_Smarty($params, &$smarty) {
  	extract($params);
  	
  	if($module == null)
  		return "Module path is null.";

    $module = preg_replace("/[^a-zA-Z0-9_\-\/]/","", $module);
		$module .= '.php';

  	if(file_exists("modules/{$module}") == false) {
  		return "Module [{$module}] cannot be found.";
  	}
  	
  	ob_start();
  	include("modules/{$module}");
  	return ob_get_clean();
  }
  
  // Note: Pagelet names may only contain alpha numeric characters 
  // and underscores, all other characters are stripped from the 
  // input for security purposes.  The '.php' extension
  // should be left out of the request.
  function RunPagelet($requested_pagelet) {
    $requested_pagelet = preg_replace("/[^a-zA-Z0-9_\-\/]/","",$requested_pagelet);

  	// run and buffer the requested pagelet
  	ob_start();

  	// see if our module exists
  	if (file_exists("themes/{$this->theme}/pagelets/{$requested_pagelet}.tpl")) {
      $this->tplEngine->display("themes/{$this->theme}/pagelets/{$requested_pagelet}.tpl");  	
    } else if (file_exists("themes/default/pagelets/{$requested_pagelet}.tpl")) {
      $this->tplEngine->display("themes/default/pagelets/{$requested_pagelet}.tpl");  	
    } else {
  	  echo ("<p style='color:#ff0000;'> Pagelet \"{$requested_pagelet}\" in theme \"{$this->theme}\" Does Not Exist! </p>"); 
  	}

  	// grab the buffer contents
  	return ob_get_clean();
  }
  
  // Note: Pagelet names may only contain alpha numeric characters 
  // and underscores, all other characters are stripped from the 
  // input for security purposes.  The '.php' extension
  // should be left out of the request.
  function RunPagelet_Smarty($params, &$smarty) {
  	extract($params);
  	
  	if($pagelet == null)
  		return "Pagelet path is null.";

    $pagelet = preg_replace("/[^a-zA-Z0-9_\-\/]/","",$pagelet);

  	// run and buffer the requested pagelet
  	ob_start();

  	// see if our module exists
  	if (file_exists("themes/{$this->theme}/pagelets/{$pagelet}.tpl")) {
      $this->tplEngine->display("themes/{$this->theme}/pagelets/{$pagelet}.tpl");  	
    } else if (file_exists("themes/default/pagelets/{$pagelet}.tpl")) {
      $this->tplEngine->display("themes/default/pagelets/{$pagelet}.tpl");  	
    } else {
  	  echo ("<p style='color:#ff0000;'> Pagelet \"{$pagelet}\" in theme \"{$this->theme}\" Does Not Exist! </p>"); 
  	}

  	// grab the buffer contents
  	return ob_get_clean();
  }
  
  // Note: Page names may only contain alpha numeric characters 
  // and underscores, all other characters are stripped from the 
  // input for security purposes.  The '.tpl' extension
  // should be left out of the request.
  function RunPage($page_request = null) {

    if ($page_request == null) {  
      $page_request = "default";
    } else {
      $page_request = preg_replace("/[^a-zA-Z0-9\/_\-]/","",$page_request);
    }
    
    $this->current_page = $page_request;

  	// see if our page exists
  	if(file_exists("themes/{$this->theme}/pages/{$page_request}.tpl")) {
      $page_path = "themes/{$this->theme}/pages/{$page_request}.tpl";
    } else if(file_exists("themes/default/pages/{$page_request}.tpl")) {
      $page_path = "themes/default/pages/{$page_request}.tpl";
  	} else {
    	ob_start();
  	  echo ("<p style='color:#ff0000;'> Page \"{$page_request}\" in theme \"{$this->theme}\" Does Not Exist! </p>"); 
  		//redirect_user("404.php", false);
      $contents = ob_get_clean();
      
      return $this->RunWrapper($contents);
  	}
  	
    // start the page buffer, and enable GZIP output
    //ob_start("ob_gzhandler");
    //header( "Expires: Mon, 26 Jul 1997 05:00:00 GMT" );  // disable IE caching
    // header( "Last-Modified: " . gmdate( "D, d M Y H:i:s" ) . " GMT" ); 
    //header( "Cache-Control: no-cache, must-revalidate" ); 
    //header( "Pragma: no-cache" );

  	// run and buffer the requested module
  	ob_start();
  	$this->tplEngine->display($page_path);
  	// grab the buffer contents
    $contents = ob_get_clean();
    
    return $this->RunWrapper($contents);    
  }
   
  function SetWrapper($wrapper)
  {
    $this->page_wrapper = $wrapper;
  } 
  
  function RunWrapper($contents)
  {
    $this->tplEngine->assign_by_ref('page_contents', $contents);
    
  	ob_start();

  	if(file_exists("themes/{$this->theme}/wrappers/{$this->page_wrapper}.tpl")) {
     	$this->tplEngine->display("themes/{$this->theme}/wrappers/{$this->page_wrapper}.tpl");
  	} else if(file_exists("themes/default/wrappers/{$this->page_wrapper}.tpl")) {
     	$this->tplEngine->display("themes/default/wrappers/{$this->page_wrapper}.tpl");
  	} else {
  	  echo ("<p style='color:#ff0000;'> Wrapper \"{$this->page_wrapper}\" in theme \"{$this->theme}\" Does Not Exist! </p>"); 
  	}
    
    return ob_get_clean();
  }

  function RedirectUser($url, $is_relative = true) {
  	// found an odd behavior with ajax if this function is allowed to process under an ajax request.
  	// it is not needed in ajax, so we will just return out of here.
//  	if(array_safe_value(apache_request_headers(), 'X-Requested-With', false, true) == true) {
//  		return;
//  	}
  	
  	$new_url = "";
  	// is the url relative?
  	if($is_relative == true || stristr($url, "http://") == false) {
  		$new_url .= $this->_CONFIG["deployment_url"];
  	}

  	$new_url .= $url;
  
  	// send user to new page, and exit.
  	header("Location: {$new_url}");
  	exit();
  }
}

?>
