<?php /* Smarty version 2.6.14, created on 2009-06-29 18:01:48
         compiled from themes/default/wrappers/default.tpl */ ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en" dir="ltr">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<base href="<?php echo $this->_tpl_vars['framework']->_CONFIG['deployment_url']; ?>
" />
	<title><?php if ($this->_tpl_vars['page_title'] != null):  echo $this->_tpl_vars['page_title'];  else:  echo $this->_tpl_vars['framework']->_CONFIG['project_name'];  endif; ?></title>
	<link rel="stylesheet" href="<?php echo $this->_tpl_vars['framework']->_CONFIG['deployment_url']; ?>
themes/<?php echo $this->_tpl_vars['framework']->theme; ?>
/static/css/generic.css" type="text/css" />
	<link rel="stylesheet" href="<?php echo $this->_tpl_vars['framework']->_CONFIG['deployment_url']; ?>
themes/<?php echo $this->_tpl_vars['framework']->theme; ?>
/static/css/main.css" type="text/css" />
	<script type="text/javascript" src="<?php echo $this->_tpl_vars['framework']->_CONFIG['deployment_url']; ?>
static/jscript/swfobject.js"></script>
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
      <?php echo $this->_tpl_vars['page_contents']; ?>

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