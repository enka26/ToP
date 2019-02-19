#!/bin/bash

#list of args
# 1. to
# 2. name of archive
# 3 - ... what kind of files

To=$1
DirName=$2

#for correct input

if [ -d $1/$2 ]
	then
	echo "This directory exists. Do you want to change the name of directory? (y/n)"
	read answ
	while [[ $answ != "y"  &&  $answ != "n" ]]; do
		read answ 
	done
		
		if [ $answ == "y" ]; then
			read DirName
			 
		elif [ $answ == "n" ]; then
			echo "Copy to this directory or make new dir with same name? (1/2)"
			read answ2
			while [[ $answ2 != "1" && $answ2 != "2" ]]; do
				read answ2
			done
			if [ $answ2 == "2" ]
			then
				tmp=1
				while [ -d $To/$DirName ]; do

				DirName="$DirName($tmp)"
				tmp=$(( $tmp+1 ))
				done
				
			fi 
		fi
		
	
fi

mkdir  -p $To/$DirName

loc=$To/$DirName




cd $HOME

#finding files, changing same names

count=1
for param in "$@"
do 
   if [ $count -gt 2 ]
   then
       #print names into file and reading name without way
        find  -not -iwholename '$DirName' -iname "*.$param" -print0 |
	
        	while read -d $'\0' file
			do
			name=${file##*/}
			flag="true"
			i="1"
			
			while [ $flag == "true" ]
			do
				if [[ -f $loc/$name ]] 
				then
					name="${name%.${param}}(${i}).$param"
					let "i = i + 1"
				else
					flag="false"
				fi
			done
			if [ $i == "1" ]
				then
					cp "$file" $loc
				else
					cp "$file" $loc/"$name"
			fi
			
		 done


   fi 
count=$(( $count+1 ))
done
cd $To
tar -cf $DirName.tar $DirName
echo "done"
