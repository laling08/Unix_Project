# Unix: Final Term Project
### By:  
- Ishilia Gilcedes V. Labrador  
- Jonathan Morin  
- Nicholas Marijon  

---

## Project Description
This project is a UNIX Shell Script for Computer Management, designed to help system administrators efficiently manage and monitor a Linux-based system (using Raspberry Pi and Ubuntu). The script provides several management tools, such as system status checks, backup scheduling, network configuration, user and file management, and more. The script is interactive, with a user-friendly menu allowing administrators to easily perform tasks and return to the main menu after each operation.

---

## Member Contributions

### Member 1: Nicholas
#### My Role
My role in this project consisted of coding the **System Status (Process Management)**, **Network Management**, and **Main Menu** of the project, which included about 13 functions in total. Functions make it easier to handle and manipulate code, especially for implementing a back button option and reprinting options for the user after each selection.

#### Challenges
1. Finding an alarm tune that felt appropriate for the project.
2. Ensuring text colors were correctly set, as small errors could prevent colors from displaying.

#### Menus Created
- **Main Menu:** Displays the task divisions for user selection.  
- **Process Management Menu:** Provides tasks related to system status, allowing users to select tasks repeatedly or return to the main menu.  
- **Network Management Menu:** Lists tasks for network management with similar navigation options.  

#### Functions Developed
- **color_Text:** Changes text color using a 256-palette.  
- **mem_Show:** Displays memory status in human-readable form.  
- **check_Temp:** Monitors system temperature and triggers an alarm if it exceeds 70°C (specific to Raspberry Pi).  
- **lis_Sys:** Lists all processes on the system.  
- **clo_Pro:** Stops a process by PID.  
- **lis_Card, ena_Card, dis_Card, recset_Card:** Manage network cards (list, enable, disable, assign IP).  
- **check_Wifi:** Scans for nearby Wi-Fi networks and enables connections.  
- **mainMenu, sys_Sta_Menu, netManMenu:** Display respective menus for user interaction.

---

### Member 2: Jonathan
#### Service Management
**Purpose:** Enables listing and managing system services (start, stop, restart).  

**Functions Developed:**
- **ListServices:** Lists all system services and provides menu options.  
- **ListServices_NoClear:** Similar to `ListServices` but used with `ManageServices`.  
- **ManageServices:** Allows users to start, stop, or restart a service.  
- **servManMenu:** Main menu for service management tasks.

**Challenges:**
- Filtering unnecessary text for better readability.  
- Aligning status fields regardless of service name length.

#### Backup Management
**Purpose:** Allows scheduling and immediate creation of file backups.  

**Functions Developed:**
- **BackUpMenu:** Displays the backup menu.  
- **ShoSta:** Shows the latest backup details.  
- **backFol:** Prompts the user to select a file to back up.  
- **BackupDate:** Schedules backups based on user-inputted date and time.  
- **validateAndMake:** Validates date input and creates backup scripts.  
- **BackupNow:** Creates an immediate backup.  

**Challenges:**
- Validating leap years and dates.  
- Ensuring multiple cron jobs run concurrently without conflicts.  
- Resolving file permission issues for backup scripts.

---

### Member 3: Ishilia
#### File Management
**Purpose:** Implements file management functionalities for user directories. Tasks include searching files, displaying largest/oldest files, and sending files via email.  

**Functions Developed:**
- **Search for a file:** Searches for a specific file in a user’s home directory.  
- **Display the largest files:** Lists the 10 largest files in the directory.  
- **Display the oldest files:** Lists the 10 oldest files in the directory.  
- **Send file as an email attachment:** Sends a file to a specified email address.

**Challenges:**
- Handling edge cases for invalid input or nonexistent files.  
- Formatting output for readability.  
- Configuring email functionality and ensuring dependencies are installed.

---

### User Management
**Description:**  
Provides tools for validating user existence and managing files based on the user’s home directory.  

**Purpose:**
- Ensures valid user access to home directories.  
- Facilitates secure file management with user-friendly navigation.

**Challenges:**
- Validating usernames securely and handling errors gracefully.  
- Managing file permissions to prevent unauthorized actions.  

---

**Note:** This project integrates multiple functionalities into a cohesive script for enhanced system management. Each section is designed for efficiency, reliability, and user-friendliness.
