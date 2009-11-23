<?php

global $framework;

class dataPoint {
  var $id;
  var $intensity;
  var $xaxis;
  var $yaxis;
}

$data_array = array();
$max_iter = rand(25, 300);
for ($i = 0; $i < $max_iter; $i++)
{
  $newDataPoint = new dataPoint;
  $newDataPoint->id = i;
  $newDataPoint->intensity = rand(0, 10000);
  $newDataPoint->xaxis = rand(0, 10000);
  $newDataPoint->yaxis = rand(0, 10000);

  $data_array[] = $newDataPoint;
}

$framework->tplEngine->assign('data_array', $data_array);

?>
