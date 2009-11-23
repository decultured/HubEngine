<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en" dir="ltr">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<base href="{$framework->_CONFIG.deployment_url}" />
	<title>{if $page_title != null}{$page_title}{else}{$framework->_CONFIG.project_name}{/if}</title>
	<link rel="stylesheet" href="{$framework->_CONFIG.deployment_url}themes/{$framework->theme}/static/css/generic.css" type="text/css" />
	<link rel="stylesheet" href="{$framework->_CONFIG.deployment_url}themes/{$framework->theme}/static/css/main.css" type="text/css" />
	<script type="text/javascript" src="{$framework->_CONFIG.deployment_url}static/jscript/swfobject.js"></script>
</head>
<body>
  <div class="wrapper">
  <div class="header">
    HubEngine Charting Demo
  </div>
  <div class="main">
    <div class="block">
      <div class="block_header">
        Heatmap Demo
      </div>
      {$page_contents}
    </div>
    <div class="block">
      <div class="block_header">
        Heatmap Demo
      </div>
    </div>
    <div class="clear"></div>
  </div>
  <div class="footer">
    All contents copyright &copy; 2009 Jeff Graves
  </div>
  </div>
</body>
</html>
