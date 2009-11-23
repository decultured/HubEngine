<?php
 	ob_start();

  require_once("framework/framework.php");

  $framework = new Framework();
  $framework->LoadConfiguration();
  $framework->LoadMySQL();
  $framework->LoadTemplateEngine();
  $framework->LoadTheme(array_safe_value($_POST, 'theme', false));
  $framework->SetWrapper("plain");

  echo $framework->RunPage(array_safe_value($_GET, 'p', null));
?>
