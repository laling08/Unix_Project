#!/bin/bash
echo -e "\e[38;5;160mIshilia-Jonathan-Nicholas\e[0m"
echo -e "   \e[48;5;0;38;5;196m Main Menu\e[0m"
#This changes the selection style
PS3='Select your choice: '
# Force the terminal to show only one column
export COLUMNS=1
# Create a function so i can manipulate whatever color in the 256 palette
color_Text(){
	echo -e "\e[38;5;$1m$2\e[0m"
}
#Important, Make sure in the case it matches the select including the color if not won't work
select taskOf in "$(color_Text 216 'User Management')" "$(color_Text 200 'Process Management')" "$(color_Text 155 'Service Management')" "$(color_Text 166 'Backup')" "$(color_Text 52 'Network Management')" "$(color_Text 27 'File Management')" "$(color_Text 8 'Exit')"
do
	case $taskOf in "$(color_Text 216 'User Management')")
	echo "User Management"
	;;
	"$(color_Text 200 'Process Management')")
	echo "Process Management"
	;;
	"$(color_Text 155 'Service Management')")
	echo "Service Management"
	;;
	"$(color_Text 166 'Backup')")
	echo "Backup"
	;;
	"$(color_Text 52 'Network Management')")
	echo "Network Management"
	;;
	"$(color_Text 27 'File Management')")
	echo "File Management"
	;;
	"$(color_Text 8 'Exit')")
	echo "You Are Exiting Now..."
	break
	;;
	*)
	echo "Invalid Option"
	;;
	esac
done
