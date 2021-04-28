import { sortNumber, sortString, sortBPM } from "./sorting.js";

export function getData(data, page, pageSize, text, sorting, bpmFrom=false, bpmTo=false) {
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

  return new Promise((resolve, reject) => {
    setTimeout(function() {
      let rowsCount = originalData.length;
      const originalRows = originalData;
      let rows = [];

      if (text && text.length > 0) {
        for (let i in originalRows) {
          for (let j in originalRows[i]) {
            if (
              originalRows[i][j]
                .toString()
                .toLowerCase()
                .indexOf(text) > -1
            ) {
              rows.push(originalRows[i]);
              break;
            }
          }
        }
        rowsCount = rows.length;
      } else if (bpmFrom && bpmFrom>70 || bpmTo && bpmTo<180) {
        for (let i in originalRows) {
          for (let j in originalRows[i]) {
            let bpm=parseInt(originalRows[i]['BeatsPerMinute'])
            if (bpm>=bpmFrom && bpm<=bpmTo) {
              rows.push(originalRows[i]);
              break;
            }
          }
        }
        rowsCount = rows.length;
      } else {
        rows = originalRows;
      }
      
      let from=(pageSize*page);
      if(from!=0) { from+=1; }
      let to=(from+pageSize);
      if(to>rowsCount) { to=rowsCount; }

      resolve({ rows: rows.slice(from, to), rowsCount: rowsCount - 1 });
    }, 500);
  });
}
