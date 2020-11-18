#!/bin/bash
function check_schedule {
	#check to see if script exists in hourly cron directory
	if [ ! -s "/etc/cron.hourly/make_backup" ]
	then 
		#copy script to cron.hourly dir
		cp make_backup.sh /etc/cron.hourly/make_backup  
		echo "The backup schedule has been set to run hourly"
		echo "The exact run time is in the /etc/crontab file."
		exit 0
	else
		echo "This script is already set to  run hourly"

	fi 
}
check_schedule
