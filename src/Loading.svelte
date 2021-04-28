<script>
  import { Firework } from 'svelte-loading-spinners'

  export let visible=true;
</script>

{#if visible}
  <br>
  <center><div class="loading"><Firework size="50" color="rgb(33, 97, 206)" unit="px" duration="0.5s"></Firework></div></center>
{/if}

