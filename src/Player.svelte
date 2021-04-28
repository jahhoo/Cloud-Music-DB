<script>
	import Slider from './Slider.svelte';
	import keyboard from './keyboard';
	import format from './format';
	import IoMdDownload from 'svelte-icons/io/IoMdDownload.svelte'
	
	let duration;
	let muted = false;
	let currentTime = 0;
	export let paused = false;
	let volume = 0.75;
	
	export let Title="";
	export let Artist="";
	export let File="";
	export let IndexPlayed=-1;
	export let rows=false;
	export let musicFolder="";
	
	let labelPlay="Play";
	let labelStop="Stop";
	let labelNext="Next";
	
	if(document.documentElement.lang=="cs") {
	 	labelPlay="Přehrát";
		labelStop="Pozastavit";
		labelNext="Další";
	 }
	
	const shortcut = {
		'NumpadAdd': () => volume += 0.05,
		'NumpadSubtract': () => volume -= 0.05,
		'ArrowLeft': e => currentTime -= 5,
		'ArrowRight': e => currentTime += 5,
		'Space': () => pauseOrPlay(),
		'KeyO': () => paused = false,
		'KeyP': () => paused = true,
		'KeyM': () => muted = !muted,
		'KeyN': () => nextSong(),
	};
	
	function plusMinute() {
		currentTime+=60;
		paused = false;
	}
	
	function nextSong() {
		IndexPlayed+=1;
		let fol=rows[IndexPlayed]['Folder'];
		if(fol) { fol+="/"; }
		File=musicFolder+"/"+fol+rows[IndexPlayed]['SourceFile'];
		Title=rows[IndexPlayed]['Title'];
		Artist=rows[IndexPlayed]['Artist'];
	}
	
	function pauseOrPlay() {
		if(paused) {
			paused=false;
		}
		else { pause() }
	}
	
	function pause() {
		paused=true;
		paused=false;
		setTimeout(function(){ paused=true; }, 50);
	}
$: {
	if(duration && duration>1 && currentTime>=duration && IndexPlayed!=-1 && rows) {
		nextSong();
	}
}
</script>

<audio
  src={File}
  	title={Title}
  	type="audio/mpeg"
	bind:duration		 
	bind:currentTime
  	bind:muted
	bind:paused
  	bind:volume
  	autoplay="autoplay"
  	on:play={()=>(paused=false)}
/>

<div use:keyboard={{shortcut}} class="player-container" tabindex={0}>
	<div class="song-info">
		<img src="player.png" alt="{Title}" class="logo" />
		<div>
			<h4>{Title}</h4>
			<p>{Artist}</p>	
		</div>
	</div>
	{#if File}
		<div class="buttons">
			{#if paused}
				<button type="button" on:click={() => (paused=false)}>
					{labelPlay}
				</button>
			{:else}
				<button type="button" on:click={pause}>
					{labelStop}
				</button>
			{/if}
			<button type="button" on:click={plusMinute} class="plusMinute">
				+ 1 min
			</button>
			<button type="button" on:click={nextSong}>
				{labelNext}
			</button>
		</div>
	{/if}
	{#if duration}
		<div class="song-slider">
			<Slider max={duration} min={0} step={duration / 200} current={currentTime} on:change={e => currentTime = e.detail.value} />
			<span>{format(currentTime)} / {format(duration)}</span>
		</div>
	{/if}
	<div class="icon">
		{#if File}
			<a href="{File}" download><IoMdDownload /></a>
		{/if}
	</div>
	<div class="volume">
		<Slider max={1} min={0} step={0.01} current={volume} on:change={e => volume = e.detail.value}  />
	</div>
</div>


<style>
	* {
		box-sizing: border-box;
	}
	.player-container {
		position: fixed;
		bottom: 0;
		left: 0;
		right: 0;
		width: 100%;
		height: 75px;
		padding: 5px;
		display: flex;
		justify-content: space-between;
		align-items: center;
		border-top: 1px solid #111;
		background-color: #fff;
	}
	
	img {
		width: 50px;
		margin-right: 8px;
	}
	
	.song-info {
		display: flex;
		justify-content: space-between;
		width:500px;
		min-width:300px;
	}
	
	.song-slider {
		min-width:200px;
		max-width:350px;
	}
	
	h4, p {
		margin: 0;
		color: #444;
		font-weight: normal;
	}
	
	p {
		color: #aaa; margin-top: 5px;
		font-size: 14px;
	}
	
	.volume {
		width: 100px;
	}
	
	audio {
		visibility: hidden;
		opacity: 0;
	}
	
	.icon { width:40px; float:left; padding-right:10px; }
	
	@media screen and (max-width: 767px) {
		.logo, .plusMinute, .song-slider, .volume { display:none; }
		.player-container { height: 100px; }
	}
</style>
