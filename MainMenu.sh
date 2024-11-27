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
    echo -e "${CYAN}Enter the username for the new user:${RESET}"
    read username
    if [ -z "$username" ]; then
        echo -e "${RED}Username cannot be empty.${RESET}"
        return 1
    fi

    echo -e "${CYAN}Enter the password for the new user:${RESET}"
    read -s password
    if [ -z "$password" ]; then
        echo -e "${RED}Password cannot be empty.${RESET}"
        return 1
    fi

    sudo useradd -m -p $(openssl passwd -1 "$password") "$username" && \
    echo -e "${GREEN}User $username added successfully.${RESET}" || \
    echo -e "${RED}Failed to add user $username.${RESET}"
}

# 2. Give Root Permissions to a User
give_root_permission() {
    echo -e "${CYAN}Enter the username to give root permissions:${RESET}"
    read username
    if [ -z "$username" ]; then
        echo -e "${RED}Username cannot be empty.${RESET}"
        return 1
    fi

    if ! id "$username" &>/dev/null; then
        echo -e "${RED}User $username does not exist.${RESET}"
        return 1
    fi

    sudo usermod -aG sudo "$username" && \
    echo -e "${GREEN}User $username is now a sudoer.${RESET}" || \
    echo -e "${RED}Failed to grant sudo permissions to $username.${RESET}"
}

# 3. Delete a User
delete_user() {
    echo -e "${CYAN}Enter the username to delete:${RESET}"
    read username
    if [ -z "$username" ]; then
        echo -e "${RED}Username cannot be empty.${RESET}"
        return 1
    fi

    if ! id "$username" &>/dev/null; then
        echo -e "${RED}User $username does not exist.${RESET}"
        return 1
    fi

    sudo userdel -r "$username" && \
    echo -e "${GREEN}User $username deleted successfully.${RESET}" || \
    echo -e "${RED}Failed to delete user $username.${RESET}"
}

# 4. Show a  List of Currently Connected Users
show_connected_users() {
    echo -e "${CYAN}Currently connected users:${RESET}"
    who || echo -e "${RED}Failed to list connected users.${RESET}"
}

# 5. Disconnect a Specific Remote User
disconnect_user() {
    echo -e "${CYAN}Enter the username to disconnect:${RESET}"
    read username
    if [ -z "$username" ]; then
        echo -e "${RED}Username cannot be empty.${RESET}"
        return 1
    fi

    if ! who | grep -q "$username"; then
        echo -e "${RED}User $username is not connected.${RESET}"
        return 1
    fi

    sudo pkill -KILL -u "$username" && \
    echo -e "${GREEN}User $username disconnected successfully.${RESET}" || \
    echo -e "${RED}Failed to disconnect user $username.${RESET}"
}

# 6. Show the List of All Groups That a User Is a Member Of
show_user_groups() {
    echo -e "${CYAN}Enter the username to show groups for:${RESET}"
    read username
    if [ -z "$username" ]; then
        echo -e "${RED}Username cannot be empty.${RESET}"
        return 1
    fi

    if ! id "$username" &>/dev/null; then
        echo -e "${RED}User $username does not exist.${RESET}"
        return 1
    fi

    groups "$username" || echo -e "${RED}Failed to show groups for $username.${RESET}"
}

# 7. Change the User Group
change_user_group() {
    echo -e "${CYAN}Enter the username to change the group for:${RESET}"
    read username
    if [ -z "$username" ]; then
        echo -e "${RED}Username cannot be empty.${RESET}"
        return 1
    fi

    if ! id "$username" &>/dev/null; then
        echo -e "${RED}User $username does not exist.${RESET}"
        return 1
    fi

    echo -e "${CYAN}Enter the new group for $username:${RESET}"
    read group
    if [ -z "$group" ]; then
        echo -e "${RED}Group name cannot be empty.${RESET}"
        return 1
    fi

    if ! getent group "$group" &>/dev/null; then
        echo -e "${RED}Group $group does not exist.${RESET}"
        return 1
    fi

    sudo usermod -g "$group" "$username" && \
    echo -e "${GREEN}User $username group changed to $group.${RESET}" || \
    echo -e "${RED}Failed to change user $username group.${RESET}"
}


# User Management Menu Function
userManagementMenu() {
    export COLUMNS=1
    PS3="$(echo -e "${CYAN}Please select a user management option: ${RESET}")"

    options=("Add a new user"
             "Give root permissions to a user"
             "Delete an existing user"
             "Show a list of currently connected users"
             "Disconnect a specific remote user"
             "Show user groups"
             "Change user group"
             "Back to Main Menu"
             "Exit")

    select choice in "${options[@]}"; do
        case $REPLY in
        1) add_user ;;
        2) give_root_permission ;;
        3) delete_user ;;
        4) show_connected_users ;;
        5) disconnect_user ;;
        6) show_user_groups ;;
        7) change_user_group ;;
        8) echo -e "${CYAN}Returning to Main Menu...${RESET}" && break ;;
        9) echo -e "${RED}Exiting...${RESET}" && exit 0 ;;
        *) echo -e "${RED}Invalid Option, please try again.${RESET}" ;;
        esac
    done
}


# << File Management Section >>

# 1. Search for a File in the User's Home Directory
search_file_in_home() {
    echo -e "${CYAN}Enter the username to search for a file:${RESET}"
    read username
    if [ -z "$username" ]; then
        echo -e "${RED}Username cannot be empty.${RESET}"
        return 1
    fi

    if ! id "$username" &>/dev/null; then
        echo -e "${RED}User $username does not exist.${RESET}"
        return 1
    fi

    echo -e "${CYAN}Enter the file name to search for:${RESET}"
    read filename
    if [ -z "$filename" ]; then
        echo -e "${RED}File name cannot be empty.${RESET}"
        return 1
    fi

    user_home=$(eval echo ~$username)
    file_path=$(find "$user_home" -type f -name "$filename" 2>/dev/null)

    if [ -z "$file_path" ]; then
        echo -e "${RED}File $filename not found in $user_home.${RESET}"
    else
        echo -e "${GREEN}File found: $file_path${RESET}"
    fi
}

# 2. Display the 10 Largest Files in the User's Home Directory
display_largest_files() {
    echo -e "${CYAN}Enter the username to display the largest files:${RESET}"
    read username
    if [ -z "$username" ]; then
        echo -e "${RED}Username cannot be empty.${RESET}"
        return 1
    fi

    if ! id "$username" &>/dev/null; then
        echo -e "${RED}User $username does not exist.${RESET}"
        return 1
    fi

    user_home=$(eval echo ~$username)

    echo -e "${CYAN}Displaying the 10 largest files in $user_home:${RESET}"
    find "$user_home" -type f -exec du -h {} + | sort -rh | head -n 10 || echo -e "${RED}Failed to list largest files.${RESET}"
}

# 3. Display the 10 oldesr Files in the User's Home Directory
display_oldest_files() {
    echo -e "${CYAN}Enter the username to display the oldest files:${RESET}"
    read username
    if [ -z "$username" ]; then
        echo -e "${RED}Username cannot be empty.${RESET}"
        return 1
    fi

    if ! id "$username" &>/dev/null; then
        echo -e "${RED}User $username does not exist.${RESET}"
        return 1
    fi

    user_home=$(eval echo ~$username)

    echo -e "${CYAN}Displaying the 10 oldest files in $user_home:${RESET}"
    find "$user_home" -type f -exec stat --format '%Y %n' {} + | sort -n | head -n 10 | cut -d' ' -f2- || echo -e "${RED}Failed to list oldest files.${RESET}"
}

# 4. Send a file as an Email Attachment
send_file_email_attachment() {
    echo -e "${CYAN}Enter the email address to send the file to:${RESET}"
    read email
    if [ -z "$email" ]; then
        echo -e "${RED}Email address cannot be empty.${RESET}"
        return 1
    fi

    echo -e "${CYAN}Enter the file name to attach:${RESET}"
    read filename
    if [ -z "$filename" ]; then
        echo -e "${RED}File name cannot be empty.${RESET}"
        return 1
    fi

    echo -e "${CYAN}Enter the username whose home directory the file is located in:${RESET}"
    read username
    if [ -z "$username" ]; then
        echo -e "${RED}Username cannot be empty.${RESET}"
        return 1
    fi

    if ! id "$username" &>/dev/null; then
        echo -e "${RED}User $username does not exist.${RESET}"
        return 1
    fi

    user_home=$(eval echo ~$username)
    file_path=$(find "$user_home" -type f -name "$filename" 2>/dev/null)

    if [ -z "$file_path" ]; then
        echo -e "${RED}File $filename not found in $user_home.${RESET}"
        return 1
    fi

    echo -e "${CYAN}Sending email with file $filename as an attachment to $email...${RESET}"
    echo "Please find the attached file." | mail -s "File Attachment: $filename" -a "$file_path" "$email" && \
    echo -e "${GREEN}Email sent successfully to $email.${RESET}" || \
    echo -e "${RED}Failed to send email.${RESET}"
}

# File Management Menu Function
fileManagementMenu() {
    export COLUMNS=1
    PS3="$(echo -e "${CYAN}Please select a file management option: ${RESET}")"

    options=("Search for a file in user's home directory"
             "Display the 10 largest files in user's home directory"
             "Display the 10 oldest files in user's home directory"
             "Send a file as an email attachment"
             "Back to Main Menu"
             "Exit")

    select choice in "${options[@]}"; do
        case $REPLY in
        1) search_file_in_home ;;
        2) display_largest_files ;;
        3) display_oldest_files ;;
        4) send_file_email_attachment ;;
        5) echo -e "${CYAN}Returning to Main Menu...${RESET}" && break ;;
        6) echo -e "${RED}Exiting...${RESET}" && exit 0 ;;
        *) echo -e "${RED}Invalid Option, please try again.${RESET}" ;;
        esac
    done
}

## place to print stuff (start the script)
mainMenu
