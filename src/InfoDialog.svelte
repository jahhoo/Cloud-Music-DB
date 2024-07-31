<script>
   import { Button, Dialog } from 'svelte-mui/src';
   
   export let visible=false;
   export let data=[];

   function close() {
   	visible=false;
   }
   
    export let labels = {
	    title: "Information about the song",
	    info: {
	    	Title: "Title",
	    	Artist: "Artist",
	    	Genre: "Genre",
	 	DateTimeOriginal: "Year",
	    	Duration: "Duration",
		BeatsPerMinute:"BPM",
	    	FileModifyDate: "Date",
	    	Folder: "Folder"
	    },
	    cancel: "Close"
  };
  if(document.documentElement.lang=="cs") {
	  labels = {
	    title: "Informace o skladbě",
	    info: {
	    	Title: "Název",
	    	Artist: "Umělec",
	    	Genre: "Žánr",
	    	DateTimeOriginal: "Rok",
	    	Duration: "Trvání",
	    	BeatsPerMinute:"Tempo (BPM)",
	    	FileModifyDate: "Nahráno",
	    	Folder: "Složka"	
	    },
	    cancel: "Zavřít"
	  };
  }
  
  export let rows=["Title", "Artist", "Genre", "BeatsPerMinute", "DateTimeOriginal",  "Duration", "FileModifyDate", "Folder"];

</script>

{#if data}
<Dialog width="600" bind:visible>
    <div slot="title">{labels.title}</div>
	<table>
	{#each rows as t}
		{#if data[t]}
			<tr><td><b>{labels.info[t]}:</b></td><td>{data[t]}</td></tr>
		{/if}
	{/each}
	</table>
    <div slot="actions" class="actions center">	
        <Button color="silver" raised on:click={() => (close())}>{labels.cancel}</Button>
    </div>
</Dialog>
{/if}
