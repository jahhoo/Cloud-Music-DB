<script>
  let items = [10, 20, 25, 30, 50, 100, 300, 500, 1000];
  
  export let limit=50;
  
  const isMobile = {
	    Android: function() {
		return navigator.userAgent.match(/Android/i);
	    },
	    BlackBerry: function() {
		return navigator.userAgent.match(/BlackBerry/i);
	    },
	    iOS: function() {
		return navigator.userAgent.match(/iPhone|iPad|iPod/i);
	    },
	    Opera: function() {
		return navigator.userAgent.match(/Opera Mini/i);
	    },
	    Windows: function() {
		return navigator.userAgent.match(/IEMobile/i) || navigator.userAgent.match(/WPDesktop/i);
	    },
	    any: function() {
		return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
	    }
	};
  
  let label="items on page";
  if(document.documentElement.lang=="cs") {
 	label="položek na stránce";
 	if(isMobile.any()) { label="položek"; }
 	
  } else if(isMobile.any()) { label="items"; }
    

</script>
<br>
<select bind:value={limit}>
	{#each items as i}
		<option value={i}>{i} {label}</option>
	{/each}
</select>

<style>

</style>
