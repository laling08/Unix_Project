#!/bin/bash
#-----------------------------------------------------
## Section Main Menu
# Force the terminal to show only one column
export COLUMNS=1
# Create a function so i can manipulate whatever color in the 256 palette
color_Text(){
	echo -e "\e[38;5;$1$2\e[0m"
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
	lis_Sys
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
	read -p "Enter the network interface to enable(eth0, wlan, lo): " netId
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
	read -p "Enter the network interface to disable(eth0, wlan, lo): " dinet
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
# Define menu items with colored text
menu_items=(
    "$(color_Text 216m 'User Management')"
    "$(color_Text 200m 'Process Management')"
    "$(color_Text 155m 'Service Management')"
    "$(color_Text 166m 'Backup')"
    "$(color_Text 196m 'Network Management')"
    "$(color_Text 25m 'File Management')"
    "$(color_Text 8m 'Exit')"
)
printf "%150s %s\n" "$(color_Text 196m '---------------------------------')"
printf "%145s %s\n" "$(color_Text 196m 'Ishilia-Jonathan-Nicholas')"
printf "%136s %s\n" "$(color_Text 196m 'Main Menu')"
printf "%150s %s\n" "$(color_Text 196m '---------------------------------')"
export COLUMNS=1
	for i in "${!menu_items[@]}"; do
		printf "%110s) %s\n" "$((i + 1))" "${menu_items[$i]}"
	done
	echo
	read -p "Enter your choice: " choice
      case $choice in
            1)
		clear
                userManMenu
		;;
            2)
		clear
        	sys_Sta_Menu
                ;;
            3)
                clear
		servManMenu
		;;
            4)
                clear
		BackUpMenu
		;;
            5)
		clear
             	netManMenu
                ;;
            6)
                clear
		fileManMenu
		;;
            7)
                echo "You Are Exiting Now..."
                exit 0
                ;;
            *)
                echo "Invalid Option"
		sleep 1
		clear
                mainMenu
                ;;
        esac
}
#----------------------------------------------------
# Important, Make sure in the case it matches the select including the color if not won't work
## System Status Menu
sys_Sta_Menu(){
export COLUMNS=1
System_items=(
		"$(color_Text 200m 'Check Memory Status')"
		"$(color_Text 200m 'Check CPU Temperature')"
		"$(color_Text 200m 'List Active Processes')"
		"$(color_Text 200m 'Stop A Process')"
		"$(color_Text 200m 'Exit')"
		"$(color_Text 200m 'Back')"
)
printf "%150s %s\n" "$(color_Text 200m '---------------------------------')"
printf "%144s %s\n" "$(color_Text 200m 'System Management')"
printf "%150s %s\n" "$(color_Text 200m '---------------------------------')"

	for i in "${!System_items[@]}"; do
                printf "%110s) %s\n" "$((i + 1))" "${System_items[$i]}"
        done
        echo
        read -p "Enter your choice: " choiceOf

        case $choiceOf in
		1)
                mem_Show
		echo
		sys_Sta_Menu
                ;;
                2)
                check_Temp
		echo
		sys_Sta_Menu
                ;;
                3)
                lis_Sys
		echo
		sys_Sta_Menu
                ;;
                4)
                clo_Pro
		echo
		sys_Sta_Menu
                ;;
                5)
                echo "You Are Exiting..."
                exit 0
                ;;
                6)
		clear
                mainMenu
                ;;
                *)
                echo "Invalid Option"
		sleep 1
		clear
		sys_Sta_Menu
                ;;
	esac
}

#------------------------------------------------------
## Network Management Menu
netManMenu(){
export COLUMNS=1
Network_items=(
		"$(color_Text 196m 'List Network Cards')"
		"$(color_Text 196m 'Enable A Network Card')"
		"$(color_Text 196m 'Disable A Network Card')"
		"$(color_Text 196m 'Set IP Address To A Network Card')"
		"$(color_Text 196m 'List Of Wifi Nearby')"
		"$(color_Text 196m 'Exit')"
		"$(color_Text 196m 'Back')"
)
printf "%150s %s\n" "$(color_Text 196m '---------------------------------')"
printf "%145s %s\n" "$(color_Text 196m 'Network Management')"
printf "%150s %s\n" "$(color_Text 196m '---------------------------------')"

        for i in "${!Network_items[@]}"; do
                printf "%110s) %s\n" "$((i + 1))" "${Network_items[$i]}"
        done
        echo
	read -p "Enter your choice: " choiceNet
	case $choiceNet in
	1)
	lis_Card
	echo
	netManMenu
	;;
	2)
	ena_Card
	echo
	netManMenu
	;;
	3)
	dis_Card
	echo
	netManMenu
	;;
	4)
	recset_Card
	echo
	netManMenu
	;;
	5)
	check_Wifi
	echo
	netManMenu
	;;
	6)
	echo "You Are Exiting..."
	exit 0
	;;
	7)
	clear
	mainMenu
	;;
	*)
	echo "Invalid Option"
	sleep 1
	clear
	netManMenu
	;;
	esac
}
#---------------------------------------------------

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'


# User Management Section


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


# 5. List groups a user is a member of and change a user's group
list_user_groups() {
    echo -e "${CYAN}Enter the username to list groups:${RESET}"
    read username
    groups "$username"
}


change_user_group() {
    echo -e "${CYAN}Enter the username to change group:${RESET}"
    read username
    echo -e "${CYAN}Enter the new group for $username:${RESET}"
    read group
    sudo usermod -g "$group" "$username"
    echo -e "${GREEN}User $username's group has been changed to $group.${RESET}"
}
## ------------------------------------------------------------------------------

# File Management Section
printf "%145s %s\n" $(echo -e "${YELLOW}Select User Management Task:${RESET}")


# 1. Search for a file in a specified user's home directory and display its path
search_file() {
    echo -e "${CYAN}Enter the username to search their home directory:${RESET}"
    read username
    echo -e "${CYAN}Enter the file name to search:${RESET}"
    read filename
    find /home/"$username" -name "$filename" 2>/dev/null
}


# 2. Display the 10 largest files in a user's home directory
largest_files() {
    echo -e "${CYAN}Enter the username to list largest files:${RESET}"
    read username
    find /home/"$username" -type f -exec du -h {} + | sort -rh | head -n 10
}


# 3. Display the 10 oldest files in a user's home directory
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
## --------------------------------------------------------------------------------

# Main Menu to Call Functions
## UserManagement
userManMenu(){
export COLUMNS=1
printf "%160s %s\n" "$(color_Text ${CYAN} '----------------------------------'${RESET})"
printf "%153s %s\n" "$(color_Text ${CYAN} 'User Management'${RESET})"
printf "%160s %s\n" "$(color_Text ${CYAN} '----------------------------------'${RESET})"
printf "%155s %s\n" "$(color_Text ${YELLOW}'Select User Management Task: '${RESET})"
printf "%148s %s\n" "$(color_Text ${CYAN}'1) Add a user' ${RESET})"
printf "%159s %s\n" "$(color_Text ${CYAN}'2) Grant root permission'${RESET})"
printf "%151s %s\n" "$(color_Text ${CYAN}'3) Delete a user'${RESET})"
printf "%161s %s\n" "$(color_Text ${CYAN}'4) Display connected users'${RESET})"
printf "%155s %s\n" "$(color_Text ${CYAN}'5) Disconnect a user'${RESET})"
printf "%154s %s\n" "$(color_Text ${CYAN}'6) List user groups'${RESET})"
printf "%155s %s\n" "$(color_Text ${CYAN}'7) Change user group'${RESET})"
printf "%142s %s\n" "$(color_Text ${CYAN}'8) Exit'${RESET})"
printf "%142s %s\n" "$(color_Text ${CYAN}'9) Back'${RESET})"
        read -p "Enter your choice: " user_choice

        case $user_choice in
            1) add_user; echo; userManMenu ;;
            2) grant_root_permission; echo; userManMenu ;;
            3) delete_user ;;
            4) display_connected_users; echo; userManMenu ;;
            5) disconnect_user; echo; userManMenu ;;
            6) list_user_groups; echo; userManMenu ;;
            7) change_user_group; echo; userManMenu ;;
	    8) echo "You are exiting..."; exit 0 ;;
	    9) clear; mainMenu ;;
            *) echo -e "${RED}Invalid choice${RESET}"; sleep 1; clear; userManMenu ;;
        esac
}
## --------------------------------------------------------------------------------------

# File Management Menu
fileManMenu(){
printf "%160s %s\n" "$(color_Text ${CYAN} '----------------------------------'${RESET})"
printf "%153s %s\n" "$(color_Text ${CYAN} 'File Management'${RESET})"
printf "%160s %s\n" "$(color_Text ${CYAN} '----------------------------------'${RESET})"
printf "%155s %s\n" "$(color_Text ${YELLOW}'Select File Management Task: '${RESET})"
printf "%155s %s\n" "$(color_Text ${CYAN}'1) Search for a file'${RESET})"
printf "%159s %s\n" "$(color_Text ${CYAN}'2) List 10 largest files'${RESET})"
printf "%158s %s\n" "$(color_Text ${CYAN}'3) List 10 oldest files'${RESET})"
printf "%150s %s\n" "$(color_Text ${CYAN}'4) Email a file'${RESET})"
printf "%142s %s\n" "$(color_Text ${CYAN}'5) Exit'${RESET})"
printf "%142s %s\n" "$(color_Text ${CYAN}'6) Back'${RESET})"
	read -p "Enter your choice: " file_choice

        case $file_choice in
            1) search_file; echo ;;
            2) largest_files; echo ;;
            3) oldest_files; echo ;;
            4) email_file; echo ;;
            5) echo "You are exiting..."; exit 0 ;;
	    6) clear; mainMenu ;;
	    *) echo -e "${RED}Invalid choice${RESET}"; sleep 1; clear; fileManMenu ;;
	esac
}
## ------------------------------------------------------------

# Backups Section


#Backup now
BackupNow(){
Date=`date +"%Y-%m-%d_%H:%M"`
filename=$1

backupFile="${Date}_${filename}.bak"


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

backup_file="${Date}_${filename}_backup.bak"

echo "Backup in progress..."
sleep 1
cp $file_path $backup_file
mv $backup_file $Backupfolder_path
clear
}

# ------------------------------------------------------------

#Checks if the date is valid and then make the backup script and cronjob creating the backup
validateAndMake(){
today=`date +"%Y.%-m.%-e %H:%M"`

#checks if the month is a valid number and also checks if the day is valid
case $2 in
        01)
                if [ $(($3 + 0)) -gt 31 ] ; then
                clear
                echo "Invalid day [ 1-31 ]. "
                BackupDate
                fi
        ;;
        02)
                if [[ $(($(($1 + 0)) % 4)) -eq 0 && $(($(($1 + 0)) % 100)) -eq 0 ]] ; then

                                if [ $(($(($1 + 0)) % 400)) -eq 0 ] ; then

                                        if [ $(($3 + 0)) -gt 29 ] ; then
                                        clear
                                        echo "Invalid day [ Leap year: 1-29 ]. "
                                        BackupDate
                                        fi

                        elif [[ $(($(($1 + 0)) % 100)) -eq 0 && $(($(($1 + 0)) % 400)) -ne 0 ]] ; then

                                if [ $(($3 + 0)) -gt 28 ] ; then
                                clear
                                echo "Invalid day [ Not a leap year: 1-28 ]. "
                                BackupDate
                                fi
                        fi
                else
                        if [ $(($3 + 0)) -gt 28 ] ; then
                        clear
                        echo "Invalid day [ Not a leap year: 1-28 ]. "
                        BackupDate
                        fi
                fi
        ;;
       03)
                if [ $(($3 + 0)) -gt 31 ] ; then
                clear
                echo "Invalid day [ 1-31 ]. "
                BackupDate
                fi
        ;;
        04)
                if [ $(($3 + 0)) -gt 30 ] ; then
                clear
                echo "Invalid day [ 1-30 ]. "
                BackupDate
                fi
        ;;
        05)
                if [ $(($3 + 0)) -gt 31 ] ; then
                clear
                echo "Invalid day [ 1-31 ]. "
                BackupDate
                fi
        ;;
        06)
                if [ $(($3 + 0)) -gt 30 ] ; then
                clear
                echo "Invalid day [ 1-30 ]. "
                backupDate
		fi
        ;;
        07)
                if [ $(($3 + 0)) -gt 31 ] ; then
                clear
                echo "Invalid day [ 1-31 ]. "
                BackupDate
                fi
        ;;
        08)
                if [ $(($3 + 0)) -gt 31 ] ; then
                clear
                echo "Invalid day [ 1-31 ]. "
                BackupDate
                fi
        ;;
        09)
                if [ $(($3 + 0)) -gt 30 ] ; then
                clear
                echo "Invalid day [ 1-30 ]. "
                BackupDate
                fi
        ;;
        10)
                if [ $(($3 + 0)) -gt 31 ] ; then
                clear
                echo "Invalid day [ 1-31 ]. "
                BackupDate
                fi
        ;;
        11)
                if [ $(($3 + 0)) -gt 30 ] ; then
                clear
                echo "Invalid day [ 1-30 ]. "
                BackupDate
                fi
        ;;
        12)     
                if [ $(($3 + 0)) -gt 31 ] ; then
                clear
                echo "Invalid day [ 1-31 ]. "
                BackupDate
                fi
        ;;
        *)      
                clear
                echo "invalid month [ 1-12 ]. "
                BackupDate
        ;;
esac

# puts the weekday in a number format
case $4 in
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
                PS3="*$(color_Text 9m 'Disclaimer, if you restart, you will have to insert all of the date again') [$(color_Text 9 'restart')/$(color_Text 11 'back')]:"
                echo "$(color_Text 166m 'Would you like to restart or go back to the main menu?: ')"
                select backNrestart in "$(color_Text 166m 'Restart')" "$(color_Text 166m 'Go back to the main menu')"
                do
                case $backNrestart in

                "$(color_Text 166m 'Restart')")
                    clear
                    backupDate
                    ;;
                "$(color_Text 166m 'Go back to the main menu')")
                        clear
                        mainMenu
                    ;;
                esac
                done


esac

backup_Date="$1.$2.$3 $5:$6"



dateNtime="${1}-${2}-${3}_${5}:${6}"


        if [[ "$today" > "$backup_Date" ]] ; then
                echo "$(color_Text 9 'Inserted date is in the past.')"
                echo "$(color_Text 166 ' Do you want to continue anyways? ')"
                PS3="$(color_Text 9 '*Disclaimer, the backup will be made immediately if yes. You will need to re-enter the date if no.') [$(color_Text 10 'Yes')/$(color_Text 9 'No')/$(color_Text 11 'Exit')] : "
                select choice in "$(color_Text 10 'Yes')" "$(color_Text 9 'No')" "$(color_Text 11 'Exit')"
                do
                    case $choice in
                        "$(color_Text 10 'Yes')")
                        makeBackupNow $filename $weekdayToNumber
                        mainMenu
			break
                        ;;
                        "$(color_Text 9 'No')")
                        clear
                        backupDate
			break
                        ;;
                        "$(color_Text 11 'Exit')")
                        mainMenu
			break
                        ;;
                        *)
                        echo "$(color_Text 9 'Invalid input [1-3]')"
                        ;;
                    esac
                done
	fi
            #When user wants to see the last time the backup process was used
	if [ ! -e "latestBackup.txt" ] ; then

    echo "The latest backup was or will be made in $backup_Date" > latestBackup.txt
	fi

    backupFile="${dateNtime}_${filename}.bak"

    minute=$6
    hour=$5
    day=$3
    month=$2

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




second=`date +"%S"`

echo "Creating backup script..."

echo "#!/bin/bash" > Backup${hour}:${minute}:${second}.sh
echo "cp $file_path $Backupfolder_path" >> Backup${hour}:${minute}:${second}.sh
echo "cd $Backupfolder_path" >> Backup${hour}:${minute}:${second}.sh
echo "mv $filename $backupFile" >> Backup${hour}:${minute}:${second}.sh

BackupScript_Path=`find / -name "Backup${hour}:${minute}:${second}.sh" -print 2>/dev/null`

echo "rm $BackupScript_Path" >> Backup${hour}:${minute}:${second}.sh

sudo chmod 777 Backup${hour}:${minute}:${second}.sh

BackupScript_path=`find / -name "Backup${hour}:${minute}:${second}.sh" 2>/dev/null`

echo "Creating cron job..."

echo "$minute $hour $day $month $weekdayToNumber $BackupScript_path" > crontab.txt
crontab -l > crontabTemp.txt
cat crontab.txt crontabTemp.txt > crontab2.txt
crontab crontab2.txt

echo "Cron job created."
sleep 1
clear
BackUpMenu
}

#---------------------------------------------------

#Asks the user to input the date
BackupDate(){
filename=$1
echo "$(color_Text 166m "Backuping ${filename}.")"
echo "$(color_Text 11m 'Please write back at any time to go back to the backup menu')"

read -p "$(color_Text 166m 'Enter the year of the backup date (Year must not be in the past): ')" year


if [[ $year == "back" || $year == "Back" ]] ; then
        mainMenu
fi

read -p "$(color_Text 166m 'Enter the month of the backup date (Month must not be in the past): ')" month


if [[ $month == "back" || $month == "Back" ]] ; then
        mainMenu
fi


read -p "$(color_Text 166m 'Enter the day of the backup date (Day must not be in the past): ')" day


if [[ $day == "back" || $day == "Back" ]] ; then
        mainMenu
fi

read -p "$(color_Text 166m 'Enter the day of the week the day is in: ')" weekday


if [[ $weekday == "back" || $weekday == "Back" ]] ; then
        mainMenu
fi

read -p "$(color_Text 166m 'Enter the hour of the backup [00-24]: ')" hour

if [[ $hour == "back" || $hour == "Back" ]] ; then
        mainMenu
fi

read -p "$(color_Text 166m' Enter the minute of the backup [00-59]: ')" minute


if [[ $minute == "back" || $minute == "Back" ]] ; then
        mainMenu
fi

clear
validateAndMake $year $month $day $weekday $hour $minute $filename
}

# ------------------------------------------------------

# asks for the filename you want to backup and then immediately backups

backFol_BackNow(){
read -p "$(color_Text 166m 'Enter the file name you would like to backup: ')" filename
BackupNow $filename

}

# ------------------------------------------------------

# asks for the filename you want to backup and redirects you to inserting date and time for backup
backFol(){
read -p "$(color_Text 166m 'Enter the file name you would like to backup: ')" filename
BackupDate $filename

}

ShoSta(){
    #When user wants to see the last time the backup process was used
    if [ ! find / -name "latestBackup.txt" -print 2>/dev/null ] ; then
        echo "$(color_Text 166m 'No backups have been made yet.')"
        else
    path=`find / -name "latestBackup.txt" -print 2>/dev/null`
        cat "$path"
        fi
echo "$(color_Text 166m 'Go back? or Exit')"
select backExit in "$(color_Text 11m 'Go back')" "Exit"
do
	case $backExit in
	"$(color_Text 11m 'Go back')")
		clear
		BackUpMenu
	break
	;;
	"Exit")
	echo "You are exiting..."
	exit 0
	;;
	*)
	echo "$(color_Text 9m 'Invalid option.')"
	;;
	esac
done
}


# ------------------------------------------------------

## Service management

ListServices(){
systemctl --type=service --all | awk '{printf "%-65s %-10s\n", $1, $3}' | head -n -5
echo "$(color_Text 155m 'Go back? or Exit')"

select BackExit in "$(color_Text 14m 'Go back')" "Exit"
do
	case $BackExit in
	"$(color_Text 14m 'Go back')")
	clear
	servManMenu
	break
	;;
	"Exit")
	echo "You are exiting..."
	exit 0
	;;
	*)
	echo "$(color_Text 9m 'Invalid option.')"
	;;
	esac
done
}

ListServices_NoClear(){
systemctl --type=service --all | awk '{printf "%-65s %-10s\n", $1, $3}' | head -n -5
}


ManageServices(){
echo "$(color_Text 155m 'List services?')"
select YesNo in "$(color_Text 10m 'Yes')" "$(color_Text 9m 'No')" "$(color_Text 14m 'Back')" "Exit"
do
	case $YesNo in
	"$(color_Text 10m 'Yes')")
		ListServices_NoClear
	break
	;;
	"$(color_Text 9m 'No')")
	break
	;;
	"$(color_Text 14m 'Back')")
	servManMenu
	break
	;;
	"Exit")
	echo "You are exiting..."
	exit 0
	;;
	*)
	echo "$color_Text 9m 'Invalid option.')"
	;;
	esac
done

                read -p "$(color_Text 155m 'Which service would you like to manage?: ')" service
                echo "$(color_Text 155m 'Would you like to') $(color_Text 9m 'stop'), $(color_Text 10m 'start') or $(color_Text 11m 'restart') the service?"


                select Manage in "$(color_Text 9m 'Stop')" "$(color_Text 10m 'Start')" "$(color_Text 11m 'Restart')" "Back" "Exit"
                do
                        case $Manage in
                        "$(color_Text 9m 'Stop')")
                                echo "$(color_Text 9m 'Stopping service ${service}...')"
                                sudo systemctl stop "$service"
                                echo "$(color_Text 9m 'Service $service stopped.')"
				sleep 1
				clear
				break
                                ;;
                        "$(color_Text 10m 'Start')")
                                echo "$(color_Text 10m 'Starting service ${service}...')"
                                sudo systemctl start "$service"
                                echo "$(color_Text 10m 'Service $service started.')"
				sleep 1
				clear
				break
                                ;;
                        "$(color_Text 11m 'Restart')")
                                echo "$(color_Text 11m 'Restarting service ${service}...')"
                                sudo systemctl restart "$service"
                                echo "$(color_Text 11m 'Service $service restarted.')"
				sleep 1
				clear
                                break
                                ;;
			"$(color_Text 14m 'Back')")
				clear
				servManMenu
				break
				;;
			"Exit")
				echo "You are exiting..."
				exit 0
				;;
                        *)
                                echo "$(color_Text 9m 'Invalid option.')"
                                ;;
                        esac
                done
}
## ------------------------------------------------------------------------

# Service Management Menu
servManMenu(){
Service_items=(
                "$(color_Text 155m 'Show list of services')"
                "$(color_Text 155m 'Stop or start a service')"
                "$(color_Text 155m 'Exit')"
                "$(color_Text 155m 'Back')"
)
printf "%150s %s\n" "$(color_Text 155m '---------------------------------')"
printf "%145s %s\n" "$(color_Text 155m'Service Management')"
printf "%150s %s\n" "$(color_Text 155m '---------------------------------')"

        for i in "${!Service_items[@]}"; do
                printf "%110s) %s\n" "$((i + 1))" "${Service_items[$i]}"
        done
        echo
        read -p "Enter your choice: " choiceSer
	case $choiceSer in
		1) ListServices; echo; servManMenu  ;;
		2) ManageServices; echo; servManMenu ;;
		3) echo "You are exiting..."; exit 0 ;;
		4) clear; mainMenu ;;
		*) echo "Invalid Option"; sleep 1; clear; servManMenu ;;
	esac
}

# ------------------------------------------------------------------------


## Backups Menu
BackUpMenu(){
Backup_items=(
                "$(color_Text 166m 'Recieve Date & Time for a backup')"
                "$(color_Text 166m 'Make a backup now')"
                "$(color_Text 166m 'Show Time & Date of last backup process')"
               	"$(color_Text 166m 'Exit')"
                "$(color_Text 166m 'Back')"
)
printf "%150s %s\n" "$(color_Text 166m '---------------------------------')"
printf "%133s %s\n" "$(color_Text 166m 'Backup')"
printf "%150s %s\n" "$(color_Text 166m '---------------------------------')"

        for i in "${!Backup_items[@]}"; do
                printf "%110s) %s\n" "$((i + 1))" "${Backup_items[$i]}"
        done
        echo
        read -p "Enter your choice: " choiceBackUp
        case $choiceBackUp in
                1) backFol; echo; BackUpMenu  ;;
		2) backFol_BackNow; echo; BackUpMenu ;;
                3) ShoSta; echo; BackUpMenu ;;
		4) echo "You are exiting..."; exit 0 ;;
                5) clear; mainMenu ;;
                *) echo "Invalid Option"; sleep 1; clear; BackUpMenu ;;
        esac
}


## Place to print stuff
clear
mainMenu
