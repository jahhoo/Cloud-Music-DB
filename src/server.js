import { sortNumber, sortString, sortBPM } from "./sorting.js";

export function getData(data, page, pageSize, text, sorting, bpmFrom=false, bpmTo=false, yearFrom=false, yearTo=false, enableFolders=[], enableGenres=[], favorites, filteredFavorites=false, musicFolder="music") {
  let originalData = data;

  if (sorting) {
    if (sorting.key === "BeatsPerMinute") {
      originalData = sortBPM(data, sorting.dir, sorting.key);
    } else if (sorting.key === "Year") {
      originalData = sortNumber(data, sorting.dir, sorting.key);
    } else {
      originalData = sortString(data, sorting.dir, sorting.key);
    }
  }

  function getLink(f,fol) {
  	if(fol && typeof fol!=="undefined" && fol!="NaN") { fol+="/"; }
  	else { fol=""; }
  	return musicFolder+"/"+fol+f;
  }

  return new Promise((resolve, reject) => {
    setTimeout(function() {
      let rowsCount = originalData.length;
      const originalRows = originalData;
      let rows = [];
      let allFolders=[];
      let allGenres=[];
      let yearMin=2099;
      let yearMax=1920;

	for (let i in originalRows) {
		let year=parseInt(originalRows[i]['DateTimeOriginal']);
		//years
		if(year>yearMax && year<2100) { yearMax=year; }
		if(year<yearMin && year>1920) { yearMin=year; }
		//allFolders
		let fl=originalRows[i]['Folder'];
   		if(fl=="") { fl="/"; }
		if(!allFolders.includes(fl)) {
			allFolders.push(fl);
		}
    if(!allGenres.includes(originalRows[i]['Genre'])) {
			allGenres.push(originalRows[i]['Genre']);
		}
		//text search
		let ok=true;
		if (text && text.length > 0) { ok=false; }
	  	for (let j in originalRows[i]) {
	   		if (originalRows[i][j].toString().toLowerCase().indexOf(text) > -1) {
	   			ok=true;
	   			break;
	   		}
	 	}
	 	//bpm filter
	  	let bpm=parseInt(originalRows[i]['BeatsPerMinute']);
	   	if(bpmFrom && bpmFrom>70 || bpmTo && bpmTo<180){
	   		if (!bpm || bpm && !(bpm>=bpmFrom && bpm<=bpmTo)) { ok=false; }
	   	}

	   	//year filter
	   	if(yearFrom && yearFrom>1940 || yearTo && yearTo<2050){
	   		if (year && !(year>=yearFrom && year<=yearTo)) { ok=false; }
	   	}
	   	//folders filter
	   	if(Array.isArray(enableFolders) && enableFolders.length>0) {
	   		let fl=originalRows[i]['Folder'];
  			if(fl=="") { fl="/"; }
  			if(!enableFolders.includes(fl)) { ok=false; }
	   	}
      //genres filter
      if(Array.isArray(enableGenres) && enableGenres.length>0) {
        if(!enableGenres.includes(originalRows[i]['Genre'])) { ok=false; }
      }
	   	//filterFavories
	   	if(filteredFavorites) {
	   		if(!favorites.includes(getLink(originalRows[i]['SourceFile'], originalRows[i]['Folder']))) { ok=false; }
	   	}

	   	if(ok) {rows.push(originalRows[i]);}
	}
	rowsCount = rows.length;

      let from=(pageSize*page);
      if(from!=0) { from+=1; }
      let to=(from+pageSize);
      if(to>rowsCount) { to=rowsCount; }

      resolve({ rows: rows.slice(from, to), allFolders: allFolders, allGenres: allGenres, rowsCount: rowsCount - 1, yearMin, yearMax });
    }, 500);
  });
}
