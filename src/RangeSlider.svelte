<script>
  import DoubleRangeSlider from './DoubleRangeSlider.svelte';
  
  export let title="";
  export let min=1;
  export let max=10;
  export let valueFrom=0;
  export let valueTo=0;

  let start;
  let end;
  
  function getBpmValue(d) {
  	if (!d && d !== 0) return '0';
  	let coef=(max-min);
	let value=parseInt(min)+(d*coef);
	return Math.round(value);
  }
  
  $: {
  	valueFrom=getBpmValue(start);
  	valueTo=getBpmValue(end);
  }

</script>

<div class="slider">
	<DoubleRangeSlider bind:start bind:end/>
	<div class="labels">
		{title}
		<div class="label">{valueFrom}</div>
		<div class="label">{valueTo}</div>
	</div>
</div>


<style>
	.slider {
		float:right;
		text-align: center;
		padding: 0 3em 1em 1em;
		width: 270px;
		margin: -2px auto 10px auto;
	}
	.label:first-child {
		float: left;
	}
	.label:last-child {
		float: right;
	}
</style>
