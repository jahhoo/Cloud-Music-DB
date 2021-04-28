<script>
  let items = [10, 20, 30, 50, 100, 300, 500, 1000];
  
  export let limit=50;
  
  let label="items on page";
  if(document.documentElement.lang=="cs") {
 	label="položek na stránce";
 }

</script>
<br>
<select bind:value={limit}>
	{#each items as i}
		<option value={i}>{i} {label}</option>
	{/each}
</select>

<style>

</style>
