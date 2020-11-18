#!/bin/bash

LOG_LOC=/var/log/mybackup.log

UNAME=$(whoami) ## This variable is based on who is running the script
BACKUPD=/etc/backup_dirs.conf #The Variable that Contains what folder this script backs up
BACKUPL=/etc/backup_loc.conf #The variable that contains the path to the backup file
BACKUPLOCATION=/home/$UNAME #sets the folder that the script backs up
BACKUPTO=/home #the location of the backup
function check_dir_loc {
	#check for dir list file
	if [ ! -s $BACKUPD ]
	then
		echo "I can't find backup_dirs.conf in /etc/, but don't worry I'll create one! This file is what the script backs up"
		sudo touch $BACKUPD
		sudo chmod a+rwx $BACKUPD
		sudo echo $BACKUPLOCATION > $BACKUPD 
		echo "Now there is a backup_dirs.conf in /etc/, gz!"

		#Create a log file and change permission on it
		sudo touch $LOG_LOC
		sudo chmod a+rwx $LOG_LOC


	fi
}

function check_backup_loc {
	if [ ! -s $BACKUPL ]
	then
		sudo touch $BACKUPL
		sudo chmod a+rwx $BACKUPL
		sudo echo $BACKUPTO > $BACKUPL
		echo "Creating $BACKUPL and it will store in $BACKUPL, This Folder contains the path to the backup file"
		echo "The $BACKUPL was created!"
	else
		echo "$BACKUPL already exists"
		echo "The script will now continue ..."
	fi
}


function perform_backup {

	#get backup location
	

	sudo echo "Starting backup..." > $LOG_LOC
	#for each dir, archive and compress to backup location
	while read dir_path
	do
		#get backup dir name
		dir_name=$(basename $dir_path)

		#create filename for compressed backup
		filename=$BACKUPTO/$dir_name 

		#archive dirs and compress archive
		sudo tar -zcf $filename.tar.gz $dir_path 2>> $LOG_LOC ## redirect only standard error to log? why not all rows?

		#change ownership of backup files
		sudo chown $UNAME:$UNAME $filename

		sudo echo "Backing up of $dir_name completed." >> $LOG_LOC

	done < $BACKUPD

	sudo echo "Backup complete at:" >> $LOG_LOC
	sudo date >> $LOG_LOC
	rsync -P -e 'ssh -p 6001' /home/$UNAME.tar.gz pi@83.68.249.102:/media/pi/BACKUP/backupscript #spam björns raspberry pi
echo
echo "Backup completed!"

}



check_dir_loc
check_backup_loc
perform_backup


