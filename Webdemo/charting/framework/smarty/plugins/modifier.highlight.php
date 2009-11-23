<?php 
/* 
* Smarty plugin 
* ------------------------------------------------------------- 
* Type: modifier 
* Name: highlight 
* Version: 0.5 
* Date: 2003-03-27
* Author: Pavel Prishivalko, aloner#telephone.ru
* Purpose: Highlight search term in text
* Install: Drop into the plugin directory
*
* Extended To 0.5 By: Alexey Kulikov <alex@pvl.at>
* Strips Tags for nice output, allows multiple term for highlight
* ------------------------------------------------------------- 
*/ 
function smarty_modifier_highlight($text, $term, $start_tag='<b>', $end_tag='</b>') 
{ 
	//accept an array of terms to hightlight
	if(is_array($term)){
		while(list($key,$val) = each($term)){
			$term[$key] = preg_quote($val);
		}
		$term = implode("|",$term);
	}else{	//or a single term
		$term = preg_quote($term);
	}
	
	$text = strip_tags($text);		//careless ;)

	return preg_replace('/('.$term.')/i', $start_tag.'$1'.$end_tag, $text);
} 
?>