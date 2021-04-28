export function sortString(rows, dir, key) {
  return rows.sort((a, b) =>
    dir === "asc"
      ? ("" + a[key]).localeCompare(b[key])
      : ("" + b[key]).localeCompare(a[key])
  );
}

export function sortNumber(rows, dir, key) {
  return rows.sort((a, b) => 
    dir === "asc" ? a[key] - b[key] : b[key] - a[key]
  );
}

export function sortBPM(rows, dir, key) {

  return rows.sort((a, b) => {
    a[key]=parseInt(a[key]);
    b[key]=parseInt(b[key]);
    if(typeof a[key]!=="number" || typeof a[key]==="undefined" || !a[key] || a[key]=="NaN") { a[key]=199; }
    if(typeof b[key]!=="number" || typeof b[key]==="undefined" || !b[key] || b[key]=="NaN") { b[key]=199; }
       
    if(dir === "asc" && a[key]>b[key] || dir !== "asc" && a[key]<b[key]) {
	    return -1;
    }
    if (dir !== "asc" && a[key]>b[key] || dir === "asc" && a[key]<b[key]) {
	    return 1;
    }
    return 0;
  });
}
