<script>
//NAS Music DB
//Author Jan Holomek (jahhoo@gmail.com)
  import { onMount } from "svelte";
  import { writable } from 'svelte/store'
  import Table, { Pagination, Row, Search, Sort } from "./Table.svelte";
  import Limit from "./Limit.svelte";
  import RangeSlider from "./RangeSlider.svelte";
  import FolderBrowser from "./FolderBrowser.svelte";
  import Player from "./Player.svelte";
  import { getData } from "./server.js";
  import { sortNumber, sortString, sortBPM } from "./sorting.js";
  import IoIosPlayCircle from 'svelte-icons/io/IoIosPlayCircle.svelte'
  import IoMdDownload from 'svelte-icons/io/IoMdDownload.svelte'
  import IoMdPause from 'svelte-icons/io/IoMdPause.svelte'
  import AddToFavorites from './AddToFavorites.svelte';
  import DownloadFavorites from './DownloadFavorites.svelte';
  import IoIosHeart from 'svelte-icons/io/IoIosHeart.svelte'
  import IoIosHeartEmpty from 'svelte-icons/io/IoIosHeartEmpty.svelte'

  let rows = [];
  let page = 0;
  let pageIndex = 0;
  let pageSize = 25; 
  export let enableFolders=[];
  export let allFolders=false;

  let loading = true;
  let rowsCount = 0;
  let text;
  let sorting;
  export let bpmFrom=false;
  export let bpmTo=false;
  export let yearMin;
  export let yearMax;
  export let yearFrom=false;
  export let yearTo=false;
  export let filteredFavorites=false;
  
  export let musicFolder="music";
  export let musicDb="db.json";
  
  export let Title="";
  export let Artist="";
  export let File="";
  export let IndexPlayed=-1;
  export let paused=false;
  let loadData; 
  export let favorites=[];
  if(localStorage.favorites) { favorites=Object.values(JSON.parse(localStorage.favorites)); }
  export let needUpdate=false;
 
  async function init() {
  	let loadFetch = await fetch(musicDb);
    	loadData=await loadFetch.json()
  }
 
   async function load(_page) {
    loading = true;
    if(loadData) {
	    const data = await getData(loadData, _page, pageSize, text, sorting, bpmFrom, bpmTo, yearFrom, yearTo, enableFolders, favorites, filteredFavorites, musicFolder);
	    rows = data.rows;
	    allFolders = data.allFolders;
	    rowsCount = data.rowsCount;
	    yearMin = data.yearMin;
	    yearMax = data.yearMax;
	    loading = false;
    }
    needUpdate=false;
  }

  function onCellClick(row) {
    alert(JSON.stringify(row));
  }
  
  function getLink(f,fol) {
  	if(fol && typeof fol!=="undefined" && fol!="NaN") { fol+="/"; }
  	else { fol=""; }
  	return musicFolder+"/"+fol+f;
  }
  
  function play(f, fol, t, a, i) {
  	if(!paused && File==getLink(f,fol)) { stop(); }
  	else {
	  	File=getLink(f,fol);
	  	Title=getTitle(t,f);
	  	Artist=a;
	  	IndexPlayed=i;
	  	paused=false;
	}
  }
  
  function stop() {
  	paused=true;
  	File="";
  	Title="";
  	Artist="";
  }
  
   function stopIfPlayed(f,fol) {
  	if(!paused && File==getLink(f,fol)) { stop(); }
  }


  function onPageChange(event) {
    load(event.detail.page);
		page = event.detail.page;
  }

  async function onSearch(event) {
    text = event.detail.text;
    await load(page);
		page = 0;
  }

  async function onSort(event) {
    sorting = { dir: event.detail.dir, key: event.detail.key };
    await load(page);
  }
  
  function date(d) {
  	if(d) {
	  	let d2=d.split(" ");
	  	let d3=d2[0].split(":");
	  	return d3[2]+"."+d3[1]+"."+d3[0];
	}
	return "";
  }
 
 function getTitle(t,f) {
 	if(!t) { 
 		let f2=f.split("/");
 		return f2[(f2.length-1)].replace(".mp3","");
 	}
 	return t; 
 }
 
 function getBPM(bpm) {
 	if(typeof bpm==="undefined" || !bpm || bpm=="NaN" || bpm==199) { return ""; }
	else {
		let b=Math.round(parseInt(bpm));
		if(typeof b==="undefined" || !b || b=="NaN") { return ""; }
		return b;
	}
 }
 
 function getYear(y, CreateDate) {
 	if(typeof y==="undefined" || !y || y=="NaN") { 
 		if(CreateDate && typeof CreateDate!=="undefined" && CreateDate!="NaN") { 
 			if(Number.isInteger(CreateDate)) {
 				return CreateDate;
 			} else if(CreateDate.includes(":")) {
	 			let cd=CreateDate.split(":");
	 			return cd[0];
	 		} else if(CreateDate.includes("/")) {
	 			let cd=CreateDate.split("/");
	 			return cd[0];
	 		} else if(CreateDate.includes(".")) {
	 			let cd=CreateDate.split(".");
	 			if(cd.count>=3) { return cd[2]; }
	 			return cd[0];
	 		}
	 		return CreateDate;
 		}
 		return ""; 
 	}
 	return parseInt(y);
 }
   
onMount(() => {
	init();
});

$: {
	load(page, loadData, pageSize, bpmFrom, bpmTo, yearFrom, yearTo, enableFolders, filteredFavorites);
	if(needUpdate) { needUpdate=false; }
}

 let tableHeader=[];
 tableHeader['action']="Action"; tableHeader['title']="Title"; tableHeader['artist']="Artist"; tableHeader['genre']="Genre"; tableHeader['duration']="Duration"; tableHeader['year']="Year"; tableHeader['date']="Downloaded";
 export let labels = {
	    year: "year"
  };
  if(document.documentElement.lang=="cs") {
	  labels = {
	    year: "Rok"
	  };
	  tableHeader['action']="Akce"; tableHeader['title']="Název"; tableHeader['artist']="Interpret"; tableHeader['genre']="Žánr"; tableHeader['duration']="Délka"; tableHeader['year']="Rok"; tableHeader['date']="Nahráno";
  }
</script>

<Table {loading} {rows} {pageIndex} {pageSize} let:rows={rows2}>
  <div slot="top">
    <Limit bind:limit={pageSize} />
    <FolderBrowser bind:allFolders bind:enableFolders />
    {#if filteredFavorites}
	<span class="icon iconHeart" on:click={() => filteredFavorites=false}><IoIosHeart /></span>
    {:else}
	<span class="icon iconHeart" on:click={() => filteredFavorites=true}><IoIosHeartEmpty /></span>
    {/if}
    {#if yearMin && yearMin!=yearMax}
    	<RangeSlider min={yearMin} bind:max={yearMax} bind:valueFrom={yearFrom} bind:valueTo={yearTo} title={labels.year} />
    {/if}
    <RangeSlider min=70 max=180 bind:valueFrom={bpmFrom} bind:valueTo={bpmTo} title="BPM" />
    <Search on:search={onSearch} />
  </div>
  <thead slot="head">
    <tr>
      <th class="actionTh">&nbsp;</th>
      <th>
        {tableHeader['title']}
        <Sort key="Title" on:sort={onSort} />
      </th>
      <th>
        {tableHeader['artist']}
        <Sort key="Artist" on:sort={onSort} />
      </th>
      <th>
        BPM
        <Sort key="BeatsPerMinute" on:sort={onSort} />
      </th>
      <th>
        {tableHeader['genre']}
        <Sort key="Genre" on:sort={onSort} />
      </th>
      <th>
        {tableHeader['duration']}
        <Sort key="Duration" on:sort={onSort} />
      </th>
       <th>
        {tableHeader['year']}
        <Sort key="DateTimeOriginal" on:sort={onSort} />
      </th>
      <th>
        {tableHeader['date']}
        <Sort key="FileModifyDate" on:sort={onSort} />
      </th>
    </tr>
  </thead>
  <tbody>
    {#each rows2 as row, index (row)}
      <Row {index}>
      	<td data-label="{tableHeader['action']}" class="action">
      		<div style="float:right">
      		{#if File==getLink(row.SourceFile, row.Folder)}
      			<div class="icon" on:click={() => stop()}><IoMdPause /></div>
      		{:else}
      			<div class="icon" on:click={() => play(row.SourceFile, row.Folder, row.Title, row.Artist, index)}><IoIosPlayCircle /></div>
      		{/if}
      		<div class="icon"><a href="{getLink(row.SourceFile, row.Folder)}" download><IoMdDownload /></a></div>
      		<div class="icon"><AddToFavorites url={getLink(row.SourceFile, row.Folder)} bind:favorites /></div>
      		</div>
      		<br />
      	</td>
	<td data-label="{tableHeader['title']}" on:click={() => play(row.SourceFile, row.Folder, row.Title, row.Artist, index)} style="cursor:pointer;">{getTitle(row.Title, row.SourceFile)}</td>
	<td data-label="{tableHeader['artist']}">&nbsp;
		{#if row.Artist && typeof row.Artist!=="undefined"}
			{row.Artist}
		{/if}
	</td>
	<td data-label="BPM">&nbsp;{getBPM(row.BeatsPerMinute)}</td>
	<td data-label="{tableHeader['genre']}">&nbsp;
		{#if typeof row.Genre !=="undefined" && row.Genre && row.Genre!="None"} 
			{row.Genre}
		{/if}
	</td>
	<td data-label="{tableHeader['duration']}">&nbsp;
		{#if typeof row.Duration !=="undefined" && row.Duration} 
			{row.Duration.replace(" (approx)", "")}
		{/if}
	</td>
	<td data-label="{tableHeader['year']}">&nbsp;{getYear(row.DateTimeOriginal, row.ContentCreateDate)}</td>
	<td data-label="{tableHeader['date']}">&nbsp;{date(row.FileModifyDate)}</td>
      </Row>
    {/each}
  </tbody>
  <div slot="bottom">
    <Pagination bind:page {pageSize} count={rowsCount} serverSide={true} on:pageChange={onPageChange} />
    {#if favorites}
    	<DownloadFavorites bind:favorites bind:needUpdate bind:filteredFavorites />
    {/if}
  </div>
</Table>
<Player bind:Title bind:Artist bind:File bind:paused bind:IndexPlayed bind:rows {musicFolder} bind:favorites bind:needUpdate />

<style>
.icon { width:30px; float:left; padding-right:10px; }
.iconHeart { color:#bb4551; float:right; position:relative; right:12px; }
th { min-width:48px; }
.actionTh { width:120px; }

@media screen and (max-width: 767px) {
    .action {
      min-height:35px;
    }
    .iconHeart { right:0px; }
    .actionTh { width:auto; }
 }
</style>
