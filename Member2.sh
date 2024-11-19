#!/bin/bash

#backups
if [ -e latestBackup.txt ];
then
        cat latestBackup.txt
fi

read -p " Enter the file name you would like to backup: " filename
read -p " Enter the date for the backup (format: yyyy-mm-dd weekday): " date
read -p " Enter the time for the backup (format: hh:mm): " Time

backup_month=$date | cut -c 6,7 
backup_day=$date | cut -c 9,10
backup_hour=$Time | cut -c 1,2
backup_minute=$Time | cut -c 4,5
backup_weekDay= $date | cut -c 12-

yyyy_mm_dd=$date | cut -c 1-10

datetime="$yyyy_mm_dd"_"$Time"

backup_file="${filename}_backup_${datetime}.bak"


# Check if backup folder exists, if not, create it
    if [ -e BackupFiles ]; then
    	mv $backup_file BackupFiles
    else
        mkdir BackupFiles
	mv $backup_file BackupFiles
    fi

     # Check if file exists
    if [ ! -f $filename ]; then
	echo " File $filename doesn't exist. "
	rm $backup_file
    else
	
   	cp "$filename" "$backup_file"
    fi


echo "cp $filename $backup_file 
        mv $backup_file /BackupFiles" > Backup.sh


        echo "$backup_minute $backup_hour $backup_day $backup_month $backup_weekDay Backup.sh" > crontab.txt
        crontab crontab.txt

    #When user wants to see the last time the backup process was used
    echo "The latest backup was made in $datetime" > latestBackup.txt




#Service management


ListServices(){
if [ ! -f services.txt ]; then
touch services.txt
fi

echo " Would you like to list all the services? "

select option in "Yes" "No"
do
	case $option in
	"Yes")
		systemctl --type=service > services.txt
                cat services.txt
                break
		;;
        "No")
                break
		;;
        *)
                echo " Invalid input. [1-2] "
		;;
	esac
done
}

ManageServices(){
                ListServices
                read -p " Which service would you like to manage?: " service
                echo " Would you like to stop or start the service? "

                select Manage in "Stop" "Start"
                do
                        case $Manage in
                        "Stop")
                                echo " Stopping service ${service}... "
                                sudo systemctl stop "$service"
                                echo " Service $service stopped. "
				ServiceManage
                                ;;
                        "Start")
                                echo " Starting service ${service}... "
                                sudo systemctl start "$service"
                                echo " Service $service started. "
				ServiceManage
                                ;;
                        "Restart")
                                echo " Restarting service ${service}... "
                                sudo systemctl restart "$service"
                                echo " Service $service restarted. "
                                ServiceManage
                                ;;
                        *)
                                echo " Invalid input. [1-3] "
                                ;;
                        esac
                done
}