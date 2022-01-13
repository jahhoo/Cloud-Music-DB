<script>
  import { Button, Snackbar } from 'svelte-mui/src';

  export let notification="";
  export let text="";
  export let visible = false;
  export let alert=false;
  export let bg="#215dce";
  
 $: {
 	if(notification) { text=notification; notification=""; visible=true; }
 	if(!visible) { text=""; }
 }
</script>

<Snackbar bind:visible {bg} top timeout=4>
    <slot />{text}
    <span slot="action">
        <Button color="white" on:click={() => (visible = false)}>x</Button>
    </span>
</Snackbar>

