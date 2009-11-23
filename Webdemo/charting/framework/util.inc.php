<?php

if(function_exists('array_safe_value') == false) {
	/*	array_safe_value
			- this function should be used everytime an array is accessed.

			- returns the value from the array, or the value in $default if the key is not found.
	*/
	function array_safe_value($array, $key, $default = null, $case_insensitive = false) {
		if($case_insensitive == true) {
			foreach($array as $the_key => $value) {
				if(strtolower($key) == strtolower($the_key)) {
					return $value;
				}
			}
		}

		if(is_array($array) == false || array_key_exists($key, $array) == false) {
			return $default;
		}

		if($array[$key] == 'true') {
			return true;
		} else if($array[$key] == 'false') {
			return false;
		}

		return $array[$key];
	}
}

function file_exists_incpath ($file) {
	$paths = explode(PATH_SEPARATOR, get_include_path());
 
	foreach($paths as $path) {
		// Formulate the absolute path
		$fullpath = $path . DIRECTORY_SEPARATOR . $file;
 
		// Check it
		if(file_exists($fullpath)) {
			return $fullpath;
		}
	}
 
	return false;
}

function set_page_title($title) {
	global $tplEngine;
	
	$tplEngine->assign('page_title', $title);
}

/*
	add_to_sidebar
		- accepts either a string or file to include
*/
function add_to_sidebar($data = null, $type = 'string') {
	global $global_sidebar_items;
	
	$global_sidebar_items[] = array('type' => $type, 'data' => $data);
}

/*
	display_user_errors
		- accepts an error message to prepend to pages
*/
function display_user_errors($error_messages) {
	global $global_user_errors;

	if(is_string($error_messages) == true) {
		$error_messages = array($error_messages);
	}
	
	$global_user_errors = array_merge($global_user_errors, $error_messages);
}

/* display_user_warnings
		- accepts a warning messsage to prepend to pages
*/
function display_user_warnings($warnings) {
	global $global_user_warnings;
	
	if(is_string($warnings) == true) {
		$warnings = array($warnings);
	}
	
	$global_user_warnings = array_merge($global_user_warnings, $warnings);
}

/* index_add_javascript_file
		- accepts a filename to include in the index wrapper template
*/
function index_add_javascript_file($file) {
	global $_CONFIG;
	
	$_CONFIG['javascript_files'][] = $file;
}

/* index_add_css_stylesheet
		- accepts a filename to include in the index wrapper template
*/
function index_add_css_stylesheet($file) {
	global $_CONFIG;
	
	$_CONFIG['css_stylesheets'][] = $file;
}

/**
 * Generates a pseudo-random UUID according to RFC 4122
 * http://us3.php.net/manual/en/function.uniqid.php#69164
 *
 * @return string
 */
function uuid() {
   return sprintf( '%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
       mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff ),
       mt_rand( 0, 0x0fff ) | 0x4000,
       mt_rand( 0, 0x3fff ) | 0x8000,
       mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff ), mt_rand( 0, 0xffff ) );
}

?>