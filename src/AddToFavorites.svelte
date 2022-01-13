<script>
     import { writable } from 'svelte/store'
     import IoIosHeart from 'svelte-icons/io/IoIosHeart.svelte'
     import IoIosHeartEmpty from 'svelte-icons/io/IoIosHeartEmpty.svelte'
     
     export let url="test";
     let added=false;
     let removed=false;
     export let favorites;
     export let needUpdate;
     
     function isFavorite(u) {
     	if(favorites) { 
     		if(favorites.includes(u)) { return true; }
     	}
     	return false;
     }
     
     function addToFavorite() {
     	if(!favorites) { favorites=[]; }
     	favorites.push(url);
     	localStorage.setItem('favorites', JSON.stringify(favorites));
     	removed=false;
     	added=true;
     	needUpdate=true;
     }
     
     function removeFromFavorite() {
     	for(let i=0; i<favorites.length; i++) {
     		if(favorites[i]==url) { favorites.splice(i, 1); }
     	}
     	localStorage.setItem('favorites', JSON.stringify(favorites));
     	added=false;
     	removed=true;
     	needUpdate=true;
     }
     
$: if(url) { added=false; removed=false; }
</script>

{#if isFavorite(url) && !removed || added}
	<span class="iconHeart" on:click={() => removeFromFavorite()}><IoIosHeart /></span>
{:else}
	<span class="iconHeart" on:click={() => addToFavorite()}><IoIosHeartEmpty /></span>
{/if}


<style>
.iconHeart { color:#bb4551; }
</style>
