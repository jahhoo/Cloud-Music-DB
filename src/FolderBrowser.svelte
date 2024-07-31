<script>
   import { Button, Dialog } from 'svelte-mui/src';
   
   let visible=false;
   export let allFolders=[];
   export let enableFolders=[];
   
   function checkFolder(fl) {
   	  if(fl) {}
	  return false;
   }

   function getFolders() {
   	let folders=[];
   	for(let i=0; i<allFolders.length; i++) {
   		let fl=allFolders[i];
   		if(fl=="") { fl="/"; }
   		folders.push(fl);
   	}
   	return folders;
   }
   
   function close() {
   	if(enableFolders.length>0) { enableFolders=[]; }
   	visible=false;
   }
   
    export let labels = {
	    folders: "Folders",
	    selectFolders: "Select folders",
	    confirm: "Confirm",
	    cancel: "Cancel"
  };
  if(document.documentElement.lang=="cs") {
	  labels = {
	    folders: "Složky",
	    selectFolders: "Vyberte složky k zobrazení",
	    confirm: "Potvrdit",
	    cancel: "Zrušit"
	  };
  }
</script>

<div class="buttonBrowser"><Button color="primary" raised on:click={() => (visible=true)}>{labels.folders}</Button></div>

<Dialog width="600" bind:visible  style="max-height:95%;">
    <div slot="title">{labels.selectFolders}</div>
	{#if Array.isArray(allFolders)}
		{#each getFolders() as fol}
			<label><input type="checkbox" bind:group={enableFolders} value={fol} /> {fol}</label>
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
