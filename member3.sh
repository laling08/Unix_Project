#!/bin/bash
#!/bin/bash

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

# 5. List groups a user is a member of and change a user’s group
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

# File Management Section

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

# Main Menu to Call Functions

echo -e "${YELLOW}Select the task you want to perform:${RESET}"
echo -e "${CYAN}1. User Management${RESET}"
echo -e "${CYAN}2. File Management${RESET}"
read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        echo -e "${YELLOW}Select User Management Task:${RESET}"
        echo -e "${CYAN}1. Add a user${RESET}"
        echo -e "${CYAN}2. Grant root permission${RESET}"
        echo -e "${CYAN}3. Delete a user${RESET}"
        echo -e "${CYAN}4. Display connected users${RESET}"
        echo -e "${CYAN}5. Disconnect a user${RESET}"
        echo -e "${CYAN}6. List user groups${RESET}"
        echo -e "${CYAN}7. Change user group${RESET}"
        read -p "Enter your choice: " user_choice
        
        case $user_choice in
            1) add_user ;;
            2) grant_root_permission ;;
            3) delete_user ;;
            4) display_connected_users ;;
            5) disconnect_user ;;
            6) list_user_groups ;;
            7) change_user_group ;;
            *) echo -e "${RED}Invalid choice${RESET}";;
        esac
        ;;
    2)
        echo -e "${YELLOW}Select File Management Task:${RESET}"
        echo -e "${CYAN}1. Search for a file${RESET}"
        echo -e "${CYAN}2. List 10 largest files${RESET}"
        echo -e "${CYAN}3. List 10 oldest files${RESET}"
        echo -e "${CYAN}4. Email a file${RESET}"
        read -p "Enter your choice: " file_choice
        
        case $file_choice in
            1) search_file ;;
            2) largest_files ;;
            3) oldest_files ;;
            4) email_file ;;
            *) echo -e "${RED}Invalid choice${RESET}";;
        esac
        ;;
    *)
        echo -e "${RED}Invalid choice${RESET}"
        ;;
esac
