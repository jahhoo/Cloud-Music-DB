<script>
//NAS Music DB
//Author Jan Holomek (jahhoo@gmail.com)
  import Table, { Pagination, Row, Search, Sort } from "./Table.svelte";
  import Limit from "./Limit.svelte";
  import RangeSlider from "./RangeSlider.svelte";
  import Player from "./Player.svelte";
  import { getData } from "./server.js";
  import { sortNumber, sortString, sortBPM } from "./sorting.js";
  import IoIosPlayCircle from 'svelte-icons/io/IoIosPlayCircle.svelte'
  import IoMdDownload from 'svelte-icons/io/IoMdDownload.svelte'
  import IoMdPause from 'svelte-icons/io/IoMdPause.svelte'

  let rows = [];
  let page = 0;
  let pageIndex = 0;
  let pageSize = 20; 

  let loading = true;
  let rowsCount = 0;
  let text;
  let sorting;
  export let bpmFrom=false;
  export let bpmTo=false;
  
  export let musicFolder="music";
  export let musicDb="db.json";
  
  export let Title="";
  export let Artist="";
  export let File="";
  export let IndexPlayed=-1;
  export let paused=false;

  async function load(_page) {
    loading = true;
    const load = await fetch(musicDb);
    const data = await getData(await load.json(), _page, pageSize, text, sorting, bpmFrom, bpmTo);
    rows = data.rows;
    rowsCount = data.rowsCount;
    loading = false;
  }

  function onCellClick(row) {
    alert(JSON.stringify(row));
  }
  
  function getLink(f,fol) {
  	if(fol) { fol+="/"; }
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
  	let d2=d.split(" ");
  	let d3=d2[0].split(":");
  	return d3[2]+"."+d3[1]+"."+d3[0];
  }
 
 function getTitle(t,f) {
 	if(!t) { 
 		let f2=f.split("/");
 		return f2[(f2.length-1)].replace(".mp3","");
 	}
 	return t; 
 }
 
 function getBPM(bpm) {
 	if(typeof bpm==="undefined" || !bpm || bpm=="NaN" || bpm==199) { return "?"; }
	else {
		let b=Math.round(parseInt(bpm));
		if(typeof b==="undefined" || !b || b=="NaN") { return "?"; }
		return b;
	}
 }
 
 function getYear(y, CreateDate) {
 	if(typeof y==="undefined" || !y || y=="NaN") { 
 		if(CreateDate) { 
 			let cd=CreateDate.split(":");
 			return cd[0];
 		}
 		return "?"; 
 	}
 	return parseInt(y);
 }
  
$: {
	load(page, pageSize, bpmFrom, bpmTo);
}

let tableHeader=[];
tableHeader['action']="Action"; tableHeader['title']="Title"; tableHeader['artist']="Artist"; tableHeader['genre']="Genre"; tableHeader['duration']="Duration"; tableHeader['year']="Year"; tableHeader['date']="Downloaded";
if(document.documentElement.lang=="cs") {
	tableHeader['action']="Akce"; tableHeader['title']="Název"; tableHeader['artist']="Interpret"; tableHeader['genre']="Žánr"; tableHeader['duration']="Délka"; tableHeader['year']="Rok"; tableHeader['date']="Nahráno";
}
</script>

<Table {loading} {rows} {pageIndex} {pageSize} let:rows={rows2}>
  <div slot="top">
    <Limit bind:limit={pageSize} />
    <Search on:search={onSearch} />
    <RangeSlider min=70 max=180 bind:valueFrom={bpmFrom} bind:valueTo={bpmTo} title="BPM" />
  </div>
  <thead slot="head">
    <tr>
      <th>&nbsp;</th>
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
      		</div>
      		<br>
      	</td>
	<td data-label="{tableHeader['title']}" on:click={() => play(row.SourceFile, row.Folder, row.Title, row.Artist)} style="cursor:pointer;">{getTitle(row.Title, row.SourceFile)}</td>
	<td data-label="{tableHeader['artist']}">
		{#if row.Artist && typeof row.Artist!=="undefined"}
			{row.Artist}
		{/if}
	</td>
	<td data-label="BPM">{getBPM(row.BeatsPerMinute)}</td>
	<td data-label="{tableHeader['genre']}">{row.Genre}</td>
	<td data-label="{tableHeader['duration']}">
		{#if typeof row.Duration !=="undefined" && row.Duration} 
			{row.Duration.replace(" (approx)", "")}
		{/if}
	</td>
	<td data-label="{tableHeader['year']}">{getYear(row.DateTimeOriginal, row.ContentCreateDate)}</td>
	<td data-label="{tableHeader['date']}">{date(row.FileModifyDate)}</td>
      </Row>
    {/each}
  </tbody>
  <div slot="bottom">
    <Pagination {page} {pageSize} count={rowsCount} serverSide={true} on:pageChange={onPageChange} />
  </div>
</Table>
<Player bind:Title bind:Artist bind:File bind:paused bind:IndexPlayed bind:rows {musicFolder} />

<style>
.icon { width:30px; float:left; padding-right:10px; }
th { min-width:48px; }

  @media screen and (max-width: 767px) {
    .action {
      min-height:30px;
    }
 }
</style>
