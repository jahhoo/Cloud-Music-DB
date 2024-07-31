<script>
   import { Button, Dialog } from 'svelte-mui/src';
   
   let visible=false;
   export let allGenres=[];
   export let enableGenres=[];
   
   function getGenres() {
   	let genres=[];
   	for(let i=0; i<allGenres.length; i++) {
   		let fl=allGenres[i];
   		if(fl!="") { genres.push(fl); }
   	} 
   	return genres.sort();
   }
   
   function close() {
   	if(enableGenres.length>0) { enableGenres=[]; }
   	visible=false;
   }
   
    export let labels = {
	    genres: "Genres",
	    selectGenres: "Select genres",
	    confirm: "Confirm",
	    cancel: "Cancel"
  };
  if(document.documentElement.lang=="cs") {
	  labels = {
	    genres: "Žánry",
	    selectGenres: "Vyberte žánry k zobrazení",
	    confirm: "Potvrdit",
	    cancel: "Zrušit"
	  };
  }
</script>

<div class="buttonBrowser"><Button color="primary" raised on:click={() => (visible=true)}>{labels.genres}</Button></div>

<Dialog width="600" bind:visible style="max-height:95%;">
    <div slot="title">{labels.selectGenres}</div>
	{#if Array.isArray(allGenres)}
		{#each getGenres() as g}
			<label><input type="checkbox" bind:group={enableGenres} value={g} /> {g}</label>
		{/each}
	{/if}
    <div slot="actions" class="actions center">
        <Button color="primary" raised on:click={() => (visible=false)}>{labels.confirm}</Button>&nbsp;&nbsp;
        <Button color="silver" raised on:click={() => (close())}>{labels.cancel}</Button>
    </div>
</Dialog>


<style>
.buttonBrowser { float:right; margin-right:20px; position:relative; bottom:1px; }
</style>
