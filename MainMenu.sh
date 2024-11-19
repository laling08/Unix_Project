#!/bin/bash
#-----------------------------------------------------
## Section Main Menu
echo -e "\e[38;5;160mIshilia-Jonathan-Nicholas\e[0m"
echo -e "   \e[48;5;0;38;5;196m Main Menu\e[0m"
# This changes the selection style
PS3='Select your choice: '
# Force the terminal to show only one column
export COLUMNS=1
# Create a function so i can manipulate whatever color in the 256 palette
color_Text(){
	echo -e "\e[38;5;$1m$2\e[0m"
}

#-----------------------------------------------------

#-----------------------------------------------------
## Section System Status
# Checks Memory status of system
mem_Show(){
	free -h
}

# Checks CPU Teperature
check_Temp(){
	echo "Checking CPU temperature..."
	sleep 2
	result=$(vcgencmd measure_temp)
	temp=$(echo $result | cut -d '=' -f2 | cut -d "'" -f1) # splits output by = char and selects second field and then split the single quote char to get only temp number
	echo "The current temperature of the CPU is $temp"
	temp_int=${temp%.*} # pattern match removes . followed by anything else (cuts decimal)
	if [ "$temp_int" -gt 70 ]
	then
		echo -e "\e[5;31mWARNING!!! CPU TEMPERATURE IS ABOVE 70 DEGREES CELSIUS\e[0m"
		for i in {1..10}; do
			play -nq -t alsa synth 0.2 sine 880
			sleep 0.2
		done
	fi
}

# List of processes in system
lis_Sys(){
	echo "Loading Active Processes"
	sleep 1
	echo "Remeber you can press q to exit the active process list anytime"
	sleep 3
	top
}

# To stop and close a process
clo_Pro(){
	read -p "Enter the PID of the process you wish to stop and end: " pid_code
	if (kill $pid_code); then
		echo "Process $pid_code has been terminated"
	else
		echo "Failed to terminate process $pid_code"
	fi
}

#-----------------------------------------------------

#-----------------------------------------------------
## Section Network Management
# Show list of network cards, IP Address, Default Gateway of each card
lis_Card(){
	echo "Network Cards and their IP Address"
	ip -br address show
	echo
	echo "Default GateWay"
	ip route show default
}

# Enable a card
ena_Card(){
	read -p "Enter the network interface to enable: " netId
	sudo ip link set $netId up
	if [ $? -eq 0 ]
	then
		echo "Network Interface $netId Was Enabled"
	else
		echo "Network Interface $netId Failed To Be Enabled"
	fi
}

# Disable network card
dis_Card(){
	read -p "Enter the network interface to disable: " dinet
	sudo ip link set $dinet down
	if [ $? -eq 0 ]
	then
		echo "Network Interface $dinet Was Disabled"
	else
		echo "Network Interface $dinet Failed To Be Disabled"
	fi
}

# Recieve IP Address and set it to a card
recset_Card(){
	read -p "Enter The Network Interface: " netInt
	read -p "Enter The IP Address To Set To The Network Inerface: " intIPA
	sudo ip addr add $intIPA dev $netInt
	if [ $? -eq 0 ]
	then
		echo "IP Address $intIPA Was Set On The Network Interface $netInt"
	else
		echo "IP Address $intIPA Was Not Able To Be Set On The Network Interface $netInt"
	fi
}

# Show lis of Wifi nearby and allow to connect to a selected network
check_Wifi(){
	echo "Scanning For Wifi Networks..."
	sleep 2
	nmcli dev wifi list
	read -p "Enter The SSID Of The Wifi Netowk To Connect To: " wifiCon
	read -s -p "Enter The Wifi Password: " passWi # -s for not showing password typed
	echo
	sudo nmcli dev wifi connect "$wifiCon" password "$passWi"
	if [ $? -eq 0 ]
	then
		echo "Connected To Wifi Network $wifiCon Successfully"
	else
		echo "Failed To Connect To Wifi Network $wifiCon"
	fi
}

#-----------------------------------------------------

#-----------------------------------------------------
# Important, Make sure in the case it matches the select including the color if not won't work
## Main Menu
mainMenu(){
select taskOf in "$(color_Text 216 'User Management')" "$(color_Text 200 'Process Management')" "$(color_Text 155 'Service Management')" "$(color_Text 166 'Backup')" "$(color_Text 52 'Network Management')" "$(color_Text 27 'File Management')" "$(color_Text 8 'Exit')"
do
        case $taskOf in "$(color_Text 216 'User Management')")
        echo "User Management"
        ;;
        "$(color_Text 200 'Process Management')")
        sys_Sta_Menu
        ;;
        "$(color_Text 155 'Service Management')")
        ManageServices
        ;;
        "$(color_Text 166 'Backup')")
        echo "Backup"
        ;;
        "$(color_Text 52 'Network Management')")
        netManMenu
        ;;
        "$(color_Text 27 'File Management')")
        echo "File Management"
        ;;
        "$(color_Text 8 'Exit')")
        echo "You Are Exiting Now..."
        exit 0
        ;;
        *)
        echo "Invalid Option"
        ;;
        esac
done
}

#----------------------------------------------------
# Important, Make sure in the case it matches the select including the color if not won't work
## System Status Menu
sys_Sta_Menu(){
export COLUMNS=1

select statusSys in "$(color_Text 200 'Check Memory Status')" "$(color_Text 200 'Check CPU Temperature')" "$(color_Text 200 'List Active Processes')" "$(color_Text 200 'Stop A Process')" "$(color_Text 200 'Exit')" "$(color_Text 200 'Back')"
                do
                case $statusSys in "$(color_Text 200 'Check Memory Status')")
                mem_Show
		echo
		sys_Sta_Menu
                ;;
                "$(color_Text 200 'Check CPU Temperature')")
                check_Temp
		echo
		sys_Sta_Menu
                ;;
                "$(color_Text 200 'List Active Processes')")
                lis_Sys
		echo
		sys_Sta_Menu
                ;;
                "$(color_Text 200 'Stop A Process')")
                clo_Pro
		echo
		sys_Sta_Menu
                ;;
                "$(color_Text 200 'Exit')")
                echo "You Are Exiting..."
                exit 0
                ;;
                "$(color_Text 200 'Back')")
                mainMenu
                ;;
                *)
                echo "Invalid Option"
                ;;
             	esac
           	done
}

#------------------------------------------------------
## Network Management Menu
netManMenu(){
export COLUMNS=1

select netMan in "$(color_Text 52 'List Network Cards')" "$(color_Text 52 'Enable A Network Card')" "$(color_Text 52 'Disable A Network Card')" "$(color_Text 52 'Set IP Address To A Network Card')" "$(color_Text 52 'List Of Wifi Nearby')" "$(color_Text 52 'Exit')" "$(color_Text 52 'Back')"
do
	case $netMan in "$(color_Text 52 'List Network Cards')")
	lis_Card
	echo
	netManMenu
	;;
	"$(color_Text 52 'Enable A Network Card')")
	ena_Card
	echo
	netManMenu
	;;
	"$(color_Text 52 'Disable A Network Card')")
	dis_Card
	echo
	netManMenu
	;;
	"$(color_Text 52 'Set IP Address To A Network Card')")
	recset_Card
	echo
	netManMenu
	;;
	"$(color_Text 52 'List Of Wifi Nearby')")
	check_Wifi
	echo
	netManMenu
	;;
	"$(color_Text 52 'Exit')")
	echo "You Are Exiting..."
	exit 0
	;;
	"$(color_Text 52 'Back')")
	mainMenu
	;;
	*)
	echo "Invalid Option"
	;;
	esac
done
}
#---------------------------------------------------
## Listing services

List_Services(){
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
                :>services.txt
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
#---------------------------------------------------
## Service management

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
#---------------------------------------------------
## Backups

Backups(){
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
}
#---------------------------------------------------
## Place to print stuff
mainMenu
