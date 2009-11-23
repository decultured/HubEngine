{RunModule module="heatmap_generator"}<?xml version="1.0"?>
<visualization>
  <dataset>
    <dataType id="influence" title="Influence" type="decimal" binding="intensity" transformType="linear"/>
    <dataType id="sentiment" title="Sentiment" type="integer" binding="yaxis" transformType="linear"/>
    <dataType id="growth" title="Growth" type="integer" binding="xaxis" transformType="linear" />
    <dataType id="date" title="Date" type="date" transformType="linear"  minValue="3" maxValue="333" />
{foreach from=$data_array item=data_point key=id}
    <dataPoint id="{$id}">
      <dataValue id="influence" value="{$data_point->intensity}" />
      <dataValue id="sentiment" value="{$data_point->xaxis}" />
      <dataValue id="growth" value="{$data_point->yaxis}" />
    </dataPoint>
{/foreach}
  </dataset>
</visualization>
