<?php /* Smarty version 2.6.14, created on 2009-06-29 18:01:50
         compiled from themes/default/pages/test_data.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'RunModule', 'themes/default/pages/test_data.tpl', 1, false),)), $this); ?>
<?php echo $this->_plugins['function']['RunModule'][0][0]->RunModule_Smarty(array('module' => 'heatmap_generator'), $this); echo '<?xml'; ?>
 version="1.0"<?php echo '?>'; ?>

<visualization>
  <dataset>
    <dataType id="influence" title="Influence" type="decimal" binding="intensity" transformType="linear"/>
    <dataType id="sentiment" title="Sentiment" type="integer" binding="yaxis" transformType="linear"/>
    <dataType id="growth" title="Growth" type="integer" binding="xaxis" transformType="linear" />
    <dataType id="date" title="Date" type="date" transformType="linear"  minValue="3" maxValue="333" />
<?php $_from = $this->_tpl_vars['data_array']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['id'] => $this->_tpl_vars['data_point']):
?>
    <dataPoint id="<?php echo $this->_tpl_vars['id']; ?>
">
      <dataValue id="influence" value="<?php echo $this->_tpl_vars['data_point']->intensity; ?>
" />
      <dataValue id="sentiment" value="<?php echo $this->_tpl_vars['data_point']->xaxis; ?>
" />
      <dataValue id="growth" value="<?php echo $this->_tpl_vars['data_point']->yaxis; ?>
" />
    </dataPoint>
<?php endforeach; endif; unset($_from); ?>
  </dataset>
</visualization>