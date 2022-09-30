#!/bin/bash


# usage : populate files to backup in list.txt file
# Script will backup all the folders into a tar and store in the Location below

BACKUP_DIR="$HOME/Backups"
FILE_SUFFIX="$(date +'%d-%m-%y')"
FILE_NAME="backup_$FILE_SUFFIX"
FOLDER_LIST="${BACKUP_DIR}/list.txt"

# get List from txt file
function debug(){
	echo "Debug Information"
	echo BACKUP_DIR $BACKUP_DIR
	echo FILE_SUFFIX $FILE_SUFFIX
	echo FILE_NAME $FILE_NAME
	echo FOLDER_LIST $FOLDER_LIST
}
if [[ $1 == *".txt" ]]; then
	BACKUP_DIR=$PWD
	FOLDER_LIST="${BACKUP_DIR}/$1"
fi

debug

[[ -e $BACKUP_DIR ]] || mkdir -p $BACKUP_DIR

function error(){
	echo "Something went wrong, pls check usage"
	exit 1
}

function validate_dirs(){
	isvalid=1
	for dir in `cat $FOLDER_LIST`; do
		[[ -e $dir ]] || isvalid=0
	done

	[[ isvalid -eq 0 ]] && error
}


function take_backup(){
	echo "Backing up files to: $BACKUP_DIR"
	echo "File will be saved as: $FILE_NAME"
	tar czf ${FILE_NAME}.tar.gz -T $FOLDER_LIST
	echo "Completed"
}

function print_folders(){
	echo "Following Folders will be stored in: $FILE_NAME"
	for dir in `cat $FOLDER_LIST`;do
		echo $dir
	done
	echo "End of Folder List"
	echo "list used: $FOLDER_LIST for foler/file list"
}

validate_dirs
print_folders
read -p "continue?{y/N}: " yes && [[ $yes == "y" ]] && take_backup
