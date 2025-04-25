#!/usr/bin/env bash

main_batch_folder="/home/stardusk/Scripts"

threads="12"
threads_max="32"

for param in "$@"; do
	if [[ $param == *"="* ]]; then
		IFS='=' read -ra ADDR <<< "$param"
		param_name="${ADDR[0]}"
		param_value="${ADDR[1]}"
		
		case $param_name in
			--threads)
				re='^[0-9]+$'
				if [[ $param_value =~ $re ]]; then
					threads="$param_value"
				fi
			;;
		esac
	fi
done

if [[ $threads -lt 1 ]]; then threads=1; fi
if [[ $threads -gt $threads_max ]]; then threads=$threads_max; fi

$main_batch_folder/compile.sh --compile_path="$PWD" --threads=$threads --program=true --export_path="/home/stardusk/Desktop/GodotLinux"
