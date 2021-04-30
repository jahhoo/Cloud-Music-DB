#/bin/sh
#NAS Music DB
#This script creates a json database 
#Author Jan Holomek (jahhoo@gmail.com)

bpmAnalyze=false
setChmode=false
musicdir='music'
dbFile='db.json'

#sudo apt-get install exiftool
#if $bpmAnalyze ; then sudo apt-get install bpm-tools ; fi

first=true
SOURCE=`pwd`
dbFile=$SOURCE"/"$dbFile
cd $musicdir
rm -f $dbFile

analyze() {
	for f in *; do 
	  filetype=`file -b --mime-type "$f" `
	  if [ "$filetype" == "audio/mpeg" ] || [ "$filetype" == "audio/x-m4a" ]; then
	  	if $setChmode ; chmod 775 "$f" ; fi
		if $bpmAnalyze ; then bpm-tag "$f" ; fi
		metadata=`exiftool -Title -Artist -Genre -BeatsPerMinute -Duration -DateTimeOriginal -ContentCreateDate -FileModifyDate -json "$f"`
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


echo "[" >> $dbFile
analyze
listFolder
echo "]" >> $dbFile
compress=`tr --delete '\n' < $dbFile`
echo $compress > $dbFile
compress=""
