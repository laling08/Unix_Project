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
        userManagementMenu
        ;;
        "$(color_Text 200 'Process Management')")
        sys_Sta_Menu
        ;;
        "$(color_Text 155 'Service Management')")
        ManageServices
        ;;
        "$(color_Text 166 'Backup')")
        Backups
        ;;
        "$(color_Text 52 'Network Management')")
        netManMenu
        ;;
        "$(color_Text 27 'File Management')")
        fileManagementMenu
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

echo "Please write back if you would like to go back to the main menu. "

read -p " Enter the file name you would like to backup: " filename

if [[ $filename == "back" || $filename == "Back" ]] ; then
        mainMenu
fi

read -p " Enter the date for the backup (format: yyyy-mm-dd weekday): " date


if [[ $date == "back" || $date == "Back" ]] ; then
        mainMenu
fi

read -p " Enter the time for the backup (format: hh:mm): " Time

if [[ $date == "back" || $date == "Back" ]] ; then
        mainMenu
fi


today=`date +"%Y-%m-%d %H:%M"`



#get the month
backup_Month=`echo $date | cut -c 6,7`
#get the day
backup_Day=`echo $date | cut -c 9,10`
#get the hours
backup_Hours=`echo $Time | cut -c 1,2`
#get the minutes
backup_Minutes=`echo $Time | cut -c 4,5`
#get the weekday
backup_Weekday=`echo $date | cut -c 12-`
#get year
getyear=`echo $date | cut -c 1,4`

#checks if the month is a valid number and also checks if the day is valid
case $backup_Month in
        01)
                if [ $(($backup_Day + 0)) -gt 31 ] ; then
                echo "Invalid day [ 1-31 ]. "
                Backups
                fi
        ;;
        02)
                if [[ $(($(($getyear + 0)) % 4)) -eq 0 && $(($(($getyear + 0)) % 100)) -eq 0 ]] ; then

                                if [ $(($(($getyear + 0)) % 400)) -eq 0 ] ; then

                                        if [ $(($backup_Day + 0)) -gt 29 ] ; then
                                        echo "Invalid day [ Leap year: 1-29 ]. "
                                        Backups
                                        fi

                        elif [[ $(($(($getyear + 0)) % 100)) -eq 0 && $(($(($getyear + 0)) % 400)) -ne 0 ]] ; then

                                if [ $(($backup_Day + 0)) -gt 28 ] ; then
                                echo "Invalid day [ Not a leap year: 1-28 ]. "
                                Backups
                                fi
                        fi
                else
                        if [ $(($backup_Day + 0)) -gt 28 ] ; then
                        echo "Invalid day [ Not a leap year: 1-28 ]. "
                        Backups
                        fi
                fi
        ;;
       03)
                if [ $(($backup_Day + 0)) -gt 31 ] ; then
                echo "Invalid day [ 1-31 ]. "
                Backups
                fi
        ;;
        04)
                if [ $(($backup_Day + 0)) -gt 30 ] ; then
                echo "Invalid day [ 1-30 ]. "
                Backups
                fi
        ;;
        05)
                if [ $(($backup_Day + 0)) -gt 31 ] ; then
                echo "Invalid day [ 1-31 ]. "
                Backups
                fi
        ;;
        06)
                if [ $(($backup_Day + 0)) -gt 30 ] ; then
                echo "Invalid day [ 1-30 ]. "
		fi
        ;;
        07)
                if [ $(($backup_Day + 0)) -gt 31 ] ; then
                echo "Invalid day [ 1-31 ]. "
                Backups
                fi
        ;;
        08)
                if [ $(($backup_Day + 0)) -gt 31 ] ; then
                echo "Invalid day [ 1-31 ]. "
                Backups
                fi
        ;;
        09)
                if [ $(($backup_Day + 0)) -gt 30 ] ; then
                echo "Invalid day [ 1-30 ]. "
                Backups
                fi
        ;;
        10)
                if [ $(($backup_Day + 0)) -gt 31 ] ; then
                echo "Invalid day [ 1-31 ]. "
                Backups
                fi
        ;;
        11)
                if [ $(($backup_Day + 0)) -gt 30 ] ; then
                echo "Invalid day [ 1-30 ]. "
                Backups
                fi
        ;;
        12)
                if [ $(($backup_Day + 0)) -gt 31 ] ; then
                echo "Invalid day [ 1-31 ]. "
                Backups
                fi
        ;;
        *)
                echo "invalid month [ 01-12 ]. "
                Backups
        ;;
esac

# puts the weekday in a number format
case $backup_Weekday in
                Monday)
                weekdayToNumber=1

                ;;
                monday)
                weekdayToNumber=1
                ;;
                Tuesday)
                weekdayToNumber=2

                ;;
                tuesday)
                weekdayToNumber=2

                ;;
                Wednesday)
                weekdayToNumber=3

                ;;
                wednesday)
                weekdayToNumber=3

                ;;
                Thursday)
                weekdayToNumber=4

                ;;
                thursday)
                weekdayToNumber=4

                ;;
                Friday)
                weekdayToNumber=5

                ;;
                friday)
                weekdayToNumber=5

                ;;
                Saturday)
                weekdayToNumber=6

                ;;
                saturday)
                weekdayToNumber=6

                ;;
                Sunday)
                weekdayToNumber=7

                ;;
		sunday)
		weekdayToNumber=7
		;;
		*)
                echo " Invalid weekday. "
                read -p " Would you like to restart or go back to the main menu? [restart/back] " backNrestart
                if [[ $backNrestart == "Back" || $backNrestart == "back" ]] ; then
                        mainMenu
                elif [[ $backNrestart == "restart" || $backNrestart == "Restard" ]] ; then
                        Backups
                else
                        echo " Invalid input. Returning to main menu... "
                        mainMenu
                fi
esac

backup_date=`echo "$date" | cut -c -10`

dateNtime="${backup_date}_${Time}"
dateNtime2="$backup_date $Time"

backup_file="${dateNtime}_${filename}_backup.bak"


# Check if backup folder exists, if not, create it
        if [ ! find / -name "BackupFolder" 2>/dev/null ] ; then
        mkdir BackupFolder
        fi

Backupfolder_path=`find / -name "BackupFolder" 2>/dev/null`

        # Check if file exists
        if [ ! find . -name "$filename" 2>/dev/null ] ; then
        echo " File $filename doesn't exist. "
        Backups
        else
        file_path=`find / -name "$filename" -print 2>/dev/null`
        fi

        if [[ "$today" > "$dateNtime2" ]] ; then
                echo "Inserted date is in the past. "
                echo "Do you want to continue anyways? *Disclaimer: the backup will be made immediately if yes. You will return to the start if no. [y/n]"

                read choice
                if [[ $choice == 'y' || $choice == 'Y' ]] ; then
                        backup_file="${today}_${filename}_backup.bak"
                        echo "#!/bin/bash" > Backup.sh
                        echo "cp $file_path $Backupfolder_path" >> Backup.sh
                        echo "cd $Backupfolder_path" >> Backup.sh
                        echo "mv ${Backupfolder_path}/$filename ${Backupfolder_path}/$backup_file" >> Backup.sh
                elif [[ $choice == 'n' || $choice == 'N' ]] ; then
                        Backups
                fi
        else
                echo "#!/bin/bash" > Backup.sh
                echo "cp $file_path $Backupfolder_path" >> Backup.sh
                echo "cd $Backupfolder_path" >> Backup.sh
                echo "mv ${Backupfolder_path}/$filename ${Backupfolder_path}/$backup_file" >> Backup.sh
        fi
BackupScript_path=`find / -name "Backup.sh" 2>/dev/null`

echo "$backup_Minutes $backup_Hours $backup_Day $backup_Month $weekdayToNumber $BackupScript_path" > crontab.txt
crontab crontab.txt

    #When user wants to see the last time the backup process was used
    echo "The latest backup was made in $backup_date at $Time" > latestBackup.txt

}
#---------------------------------------------------
# Member 3: Ishilia
#---------------------------------------------------

# Color Variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'

#  << User Management Section>>

# 1. Add a user with a specified username and password
add_user() {
    echo -e "${CYAN}Enter username to add:${RESET}"
    read username
    echo -e "${CYAN}Enter password for $username:${RESET}"
    read -s password
    sudo useradd -m "$username" && echo "$username:$password" | sudo chpasswd
    echo -e "${GREEN}User $username has been added.${RESET}"
}

# 2. Grant root permission to a user
grant_root_permission() {
    echo -e "${CYAN}Enter the username to grant root permissions:${RESET}"
    read username
    sudo usermod -aG sudo "$username"
    echo -e "${GREEN}$username has been granted root permissions.${RESET}"
}

# 3. Delete a user
delete_user() {
    echo -e "${CYAN}Enter the username to delete:${RESET}"
    read username
    sudo userdel -r "$username"
    echo -e "${GREEN}User $username has been deleted.${RESET}"
}

# 4. Display connected users and disconnect a selected remote user
display_connected_users() {
    echo -e "${CYAN}Currently connected users:${RESET}"
    who
}

disconnect_user() {
    echo -e "${CYAN}Enter the username of the user to disconnect:${RESET}"
    read username
    sudo pkill -KILL -u "$username"
    echo -e "${GREEN}User $username has been disconnected.${RESET}"
}

# 5. List groups a user is a member of and change a user’s group
list_user_groups() {
    echo -e "${CYAN}Enter the username to list groups:${RESET}"
    read "$username"
}

change_user_group() {
    echo -e "${CYAN}Enter the username to change group:${RESET}"
    read username
    echo -e "${CYAN}Enter the new group for $username:${RESET}"
    read group
    sudo usermod -g "$group" "$username"
    echo -e "${GREEN}User $username's group has been changed to $group.${RESET}"
}

# User Management Menu Function
userManagementMenu() {
    export COLUMNS=1
    PS3="$(echo -e "${CYAN}Please select a user management option: ${RESET}")"

    options=("Add a user"
             "Grant root permissions"
             "Delete a user"
             "Display connected users"
             "Disconnect users"
             "List user groups"
             "Change user groups"
             "Back to Main Menu"
             "Exit")

    select choice in "${options[@]}"; do
        case $REPLY in
        1) echo -e "${GREEN}Add a user selected.${RESET}" && add_user ;;
        2) echo -e "${YELLOW}Grant root permissions selected.${RESET}" && grant_root_permission ;;
        3) echo -e "${RED}Delete a user selected.${RESET}" && delete_user ;;
        4) echo -e "${CYAN}Display connected users selected.${RESET}" && display_connected_users ;;
        5) echo -e "${BLUE}Disconnect users selected.${RESET}" && disconnect_user ;;
        6) echo -e "${GREEN}List user groups selected.${RESET}" && list_user_groups ;;
        7) echo -e "${YELLOW}Change user groups selected.${RESET}" && change_user_group ;;
        8) echo -e "${CYAN}Returning to Main Menu...${RESET}" && mainMenu ;;
        9) echo -e "${RED}Exiting...${RESET}" && exit 0 ;;
        *) echo -e "${RED}Invalid Option, please try again.${RESET}" ;;
        esac
    done
}




# << File Management Section >>

# 1. Search for a file in a specified user’s home directory and display its path
search_file() {
    echo -e "${CYAN}Enter the username to search their home directory:${RESET}"
    read username
    echo -e "${CYAN}Enter the file name to search:${RESET}"
    read filename
    find /home/"$username" -name "$filename" 2>/dev/null
}

# 2. Display the 10 largest files in a user’s home directory
largest_files() {
    echo -e "${CYAN}Enter the username to list largest files:${RESET}"
    read username
    find /home/"$username" -type f -exec du -h {} + | sort -rh | head -n 10
}

# 3. Display the 10 oldest files in a user’s home directory
oldest_files() {
    echo -e "${CYAN}Enter the username to list oldest files:${RESET}"
    read username
    find /home/"$username" -type f -exec ls -lt {} + | tail -n 10
}

# 4. Email a file as an attachment based on user-provided email and file name
email_file() {
    echo -e "${CYAN}Enter the email address to send the file to:${RESET}"
    read email
    echo -e "${CYAN}Enter the username whose file you want to send:${RESET}"
    read username
    echo -e "${CYAN}Enter the file name to send:${RESET}"
    read filename
    echo -e "${CYAN}Enter the subject of the email:${RESET}"
    read subject
    echo -e "${CYAN}Enter the body of the email:${RESET}"
    read body

    # Send the email using mail command (ensure mailutils is installed)
    echo "$body" | mail -s "$subject" -A /home/"$username"/"$filename" "$email"
    echo -e "${GREEN}File $filename has been sent to $email.${RESET}"
}

# File Management Menu
fileManagementMenu() {
    export COLUMNS=1
    PS3="$(echo -e "${CYAN}Please select a file management option: ${RESET}")" # Properly format PS3 prompt

    options=("Search for a file"
             "Display the 10 largest files"
             "Display the 10 oldest files"
             "Email a file as an attachment"
             "Back to Main Menu"
             "Exit")

    select choice in "${options[@]}"; do
        case $REPLY in
        1) echo -e "${GREEN}Search for a file selected.${RESET}" && search_file ;;
        2) echo -e "${YELLOW}Display the 10 largest files selected.${RESET}" && largest_files ;;
        3) echo -e "${BLUE}Display the 10 oldest files selected.${RESET}" && oldest_files ;;
        4) echo -e "${RED}Email a file as an attachment selected.${RESET}" && email_file ;;
        5) echo -e "${CYAN}Returning to Main Menu...${RESET}" && mainMenu ;;
        6) echo -e "${RED}Exiting...${RESET}" && exit 0 ;;
        *) echo -e "${RED}Invalid Option, please try again.${RESET}" ;;
        esac
    done
}

## place to print stuff (start the script)
mainMenu
