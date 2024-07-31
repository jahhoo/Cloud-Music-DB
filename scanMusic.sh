#!/bin/bash
#NAS Music DB
#This script creates a json database 
#Author Jan Holomek (jahhoo@gmail.com)

bpmAnalyze=true
setChmode=true
renameFiles=true
musicdir='music'
dbFile='db.json'

#sudo apt-get install exiftool
#if $bpmAnalyze ; then sudo apt-get install bpm-tools ; fi

first=true
SOURCE=`pwd`
dbFile=$SOURCE"/"$dbFile
rm -f $dbFile

analyze() {
	for f in *; do 
	  filetype=`file -b --mime-type "$f" `
	  if [ "$filetype" == "audio/mpeg" ] || [ "$filetype" == "audio/x-m4a" ]; then
	  	newName="$f"
	  	if $renameFiles; then newName="${f/'  '/' '}"; fi
	  	if [ "$f" != "$newName" ]; then sudo mv "$f" "$newName"; fi
	  	if $setChmode ; then sudo chmod 777 "$newName"; fi
		if $bpmAnalyze ; then bpm-tag "$newName" ; fi
		metadata=`exiftool -Title -Artist -Genre -BeatsPerMinute -Duration -DateTimeOriginal -ContentCreateDate -FileModifyDate -json "$newName"`
		json="${metadata/$musicdir/''}"
		thisFolder=`pwd`
		thisFolder="${thisFolder/$SOURCE/''}"
		thisFolder="${thisFolder/'/'$musicdir'/'/''}"
		thisFolder="${thisFolder/'/'$musicdir/''}"
		if [ ! -z "$thisFolder" ]; then
			json="${json/'"SourceFile'/'"Folder":"'$thisFolder'","SourceFile'}"
		fi
		json="${json/'}]'/'}'}"
		json="${json/'[{'/'{'}"
		if $first; then
		  first=false
		elif [ ${#json} -gt 10 ]; then
		  echo "," >> $dbFile
		fi
		echo "$json" >> $dbFile	
	  fi
	done
}

listFolder() {
	for f in */ ; do
		filetype=`file -b --mime-type "$f" `
		if [ "$filetype" == "inode/directory" ]; then
			cd "$f"
			listFolder
			cd ..
		else
			analyze
		fi
	done
}

cd $musicdir
echo "[" >> $dbFile
analyze
listFolder
echo "]" >> $dbFile
compress=`tr --delete '\n' < $dbFile`
echo $compress > $dbFile
compress=""
