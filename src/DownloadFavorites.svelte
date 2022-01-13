<script>
     import { writable } from 'svelte/store'
     import Notification from './Notification.svelte';
     import { Button, Dialog } from 'svelte-mui/src';
     
     export let favorites;
     export let needUpdate;
     export let filteredFavorites;
     export let notification="";
     export let visible=false;
     
     export const fileGenerator = (data) => {
	  if (data == null || !data.length) {
	    return null;
	  }
	  var blob = new Blob([data]);
	  if (navigator.msSaveBlob) {
	    // IE 10+
	    navigator.msSaveBlob(blob, exportedFilenmae);
	  } else if (navigator.userAgent.match(/iPhone|iPad|iPod/i)) {
	    var hiddenElement = window.document.createElement("a");
	    hiddenElement.href = "data:text/csv;charset=utf-8," + encodeURI(data);
	    hiddenElement.target = "_blank";
	    hiddenElement.download = "favorites.txt";
	    hiddenElement.click();
	  } else {
	    let link = document.createElement("a");
	    if (link.download !== undefined) {
	      var url = URL.createObjectURL(blob);
	      link.setAttribute("href", url);
	      link.setAttribute("download", "favorites.txt");
	      link.style.visibility = "hidden";
	      document.body.appendChild(link);
	      link.click();
	      document.body.removeChild(link);
	    }
	  }
	};
	
	function downloadHandler() {
		let data="";
		if(localStorage.favorites) { 
	     		let fv=Object.values(JSON.parse(localStorage.favorites));
	     		for(let i=0; i<fv.length; i++) {
		     		data+=fv[i]+"\n";
		     	}
		     	fileGenerator(data);
	     	} 
	     	if(data=="" && document.documentElement.lang=="cs") {
			notification="Nejsou vybrané žádné oblíbené skladby!";
		} else if(data=="") {
			notification="No favorite songs selected!";
		}
		return false;
	}
	
	function reallyRemove() {
		visible=true;
	}
	
	function removeFavorites() {
		localStorage.setItem('favorites', false);
		favorites=false;
		filteredFavorites=false;
		needUpdate=true;
		visible=false;
	}
	
   export let labels = {
   	    downloadFavorites: "Download favorite songs in file (.txt)",
	    removeFavorites: "Delete Favorites",
	    reallyRemoveFavorites: "Are you sure you want to delete your favorite playlist?",
	    confirm: "Confirm",
	    cancel: "Cancel"
  };
  if(document.documentElement.lang=="cs") {
	  labels = {
	  	downloadFavorites: "Stáhnout soubor oblíbených skladeb (.txt)",
	  	removeFavorites: "Odstranit oblíbené",
	  	reallyRemoveFavorites: "Opravdu chcete odstranit seznam oblíbených skladeb?",
	  	confirm: "Potvrdit",
	    	cancel: "Zrušit"
	  };
  }
</script>
	<br /><br />
	<span class="link" on:click={() => downloadHandler()}>{labels.downloadFavorites}</span>
	&nbsp;&nbsp;|&nbsp;&nbsp;
	<span class="link" on:click={() => reallyRemove()}>{labels.removeFavorites}</span>
	
	
<Dialog width="420" bind:visible>
    <div slot="title">{labels.removeFavorites}</div>
	{labels.reallyRemoveFavorites}
    <div slot="actions" class="actions center">
        <Button color="primary" raised on:click={() => removeFavorites()}>{labels.confirm}</Button>&nbsp;&nbsp;
        <Button color="silver" raised on:click={() => (visible=false)}>{labels.cancel}</Button>
    </div>
</Dialog>
	
<Notification bind:notification />

<style>
.link { color: rgb(0,80,160); text-decoration:underline; cursor:pointer; }
.link:hover { text-decoration:none; }
</style>
