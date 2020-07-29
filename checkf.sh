#!/bin/bash
init_dir=$(pwd)
size=$1
run=1
while [[ run -eq 1 ]] ; do
	echo "You'll check files bigger than $size bytes , sure ? (Y/N)"
	read input1
	if [ $input1 == "y" -o $input1 == "Y" ]; then
		echo "The process will look for files bigger than $size bytes"
		run=0
	else
		echo "Enter the new file size to check (bytes)"
		read input2
		size=$input2
	fi
done
if [ -z "$2" ]; then
	echo "You didn't entered any target directory, do you want to search into your whole computer ? (Y/N)"
	read input3
	if [ $input3 == "y" -o $input3 == "Y" ]; then
		echo "The process will store the files location into $init_dir/bigf.txt , it may take a while"
	else
		exit 1
	fi	
else
	init_dir="$2"
	echo "The process will store the files location into $init_dir/bigf.txt"
fi
function store_data(){
	working_dir="$1"
	cd "$init_dir"
	echo "FILE SIZE : $3 | LOCATION : $1/$2" >> bigf.txt
	cd "$working_dir"
}
function rep_recur(){
	current_dir="$(pwd)"
	for file in .* *; do
		if [ ! -d "${file}" -a "${file}" != "*" ]; then
			weight=$(stat -c%s "$file")
		        if [[ weight -gt size ]]; then
				store_data "$current_dir" "${file}" "$weight"	
			fi
		elif [ -d "${file}" -a "${file}" != "." -a "${file}" != ".." ]; then
			cd "$file"
			rep_recur
			cd ..
			current_dir="$(pwd)"
		fi
	done
}
cd "$init_dir"
echo "List of files of a size above $size bytes found" > bigf.txt
rep_recur
exit 1
