#Backups

read -p " Enter the file name you would like to backup: " filename
read -p " Enter the date for the backup (yyyymmdd): " date
read -p " Enter the time for the backup(hhmmss): " Time

datetime=${date}${Time}
backup_file="${filename}_backup_${datetime}.bak"

	 # Check if file exists
    if [ ! -f $filename ]; then
	echo " File $filename doesn't exist. "
	rm ${filename}_backup_${datetime}.bak
    else
	
   	cp "$filename" "$backup_file"
    fi

    # Check if backup folder exists, if not, create it
    if [ -e BackupFiles ]; then
    	mv $backup_file BackupFiles
    else
        mkdir BackupFiles
	mv $backup_file BackupFiles
    fi


    #When user wants to see the last time the backup process was used
    LatestBackupDate=$datetime




#Service management
if [ ! -f services.txt ]; then
touch services.txt
fi
echo " Would you like to list all the services? "

select option in "Yes" "No"
do
	case $option in
	"Yes")
		systemctl --type=service >> services.txt
                cat services.txt
                read -p " Which service would you like to start or stop?: " service
                echo " Would you like to stop or start the service? "

                select StartStop in "Stop" "Start"
                do
                        case $StartStop in
                        "Stop")
                                echo " Stopping service ${service}... "
                                sudo systemctl stop $service
                                echo " Service $Service stopped. "
				break
                                ;;
                        "Start")
                                echo " Starting service ${service}... "
                                sudo systemctl start $service
                                echo " Service $service started. "
				break
                                ;;
                        *)
                                echo " Invalid input. (1 or 2) "
                                ;;
                        esac
                done
		;;
        "No")
                read -p " Which service would you like to start or stop?: " service
                echo " Would you like to stop or start the service? "

                select StartStop in Stop Start
                do
                        case $StartStop in
                        "Stop")
                                echo " Stopping service ${service}... "
                                sudo systemctl stop $service
                                echo " Service $Service stopped. "
				break
                                ;;
                        "Start")
                                echo " Starting service ${service}... "
                                sudo systemctl start $service
                                echo " Service $service started. "
				break
                                ;;
                        *)
                                echo " Invalid input. (1 or 2) "
                                ;;
                        esac
                done
		;;
        *)
                echo " Invalid input. (1 or 2) "
		;;
	esac
done
