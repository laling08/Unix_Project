# UNIX Shell Script for Computer Management

## Project Overview

This project is a **UNIX Shell Script for Computer Management**, designed to help system administrators efficiently manage and monitor a Linux-based system (using Raspberry Pi and Ubuntu). The script provides several management tools, such as system status checks, backup scheduling, network configuration, user and file management, and more. The script is interactive, with a user-friendly menu allowing administrators to easily perform tasks and return to the main menu after each operation.

## Project Requirements and Deliverables

- **System status**: Monitor system health, including memory and CPU usage, active processes, and process management.
- **Backup management**: Automate file backups based on user-specified schedules.
- **Network management**: Display network information and manage network interfaces.
- **Service management**: Control system services by starting or stopping them.
- **User management**: Manage users, including adding, deleting, and modifying users' permissions and groups.
- **File management**: Search for and manage files within users' home directories.
- **Documentation**: A comprehensive document describing the project, requirements, components, and each team member’s contributions.

## Task Assignment

| **Team Member**  | **Responsibilities**                                                      |
|------------------|---------------------------------------------------------------------------|
| **Member 1**     | **System Status**: Check system memory, CPU temperature, active processes, and process management. |
| **Member 2**     | **Backup & Network Management**: Schedule backups, display network info, manage network interfaces, and connect to Wi-Fi. |
| **Member 3**     | **User & File Management**: Add/delete users, manage groups, search for files, and handle file operations (largest/oldest files, email attachments). |

## Project Components and Solutions

Each team member is responsible for implementing a specific section of the shell script:

### **Member 1: System Status**
- **Functionality**:
    - Check memory status and display used/available memory.
    - Check the CPU temperature and trigger an alarm if it exceeds 70°C.
    - List active processes and allow the user to stop or close any process.
- **Tools/Commands**:
    - `free`, `top`, `ps`, `kill`, `sensors`
    - Use conditionals to trigger warnings if CPU temperature is high.

### **Member 2: Backup & Network Management**
- **Backup Tasks**:
    - Receive date, time, and file details to schedule backups.
    - Display the last backup date/time.
- **Network Tasks**:
    - Show network card info and IP addresses.
    - Disable/enable network interfaces and set IP addresses.
    - List available Wi-Fi networks and allow user to connect.
- **Tools/Commands**:
    - `crontab`, `rsync`, `ifconfig`, `iwlist`, `nmcli`
    - Use `cron` for scheduling backups.
    - Network management commands for configuring network interfaces.

### **Member 3: User & File Management**
- **User Management Tasks**:
    - Add a user with a specified username and password.
    - Grant root permissions to a user.
    - Delete a user and show connected users.
    - Disconnect specific remote users.
    - Modify user group membership.
- **File Management Tasks**:
    - Search for a file in the user's home directory and display its path.
    - Display the 10 largest and 10 oldest files in the home directory.
    - Email a file as an attachment to a specified email address.
- **Tools/Commands**:
    - `useradd`, `passwd`, `usermod`, `deluser`, `groups`, `find`, `du`, `tar`, `mail`
    - Use `find` to search and list files.
    - `du` and `ls` for identifying the largest/oldest files.
    - Use `mail` to send email attachments.

## Documentation
Each member is responsible for documenting their specific section of the project:

- **Member 1**: Document the system status checks, commands used, and how to interpret the results.
- **Member 2**: Describe the backup scheduling functionality, network management, and associated commands.
- **Member 3**: Provide detailed documentation for user and file management tasks, including file searching, file size/age listing, and emailing files.

## GitHub Repository

The entire script will be hosted in a GitHub repository at: [Unix_Project](https://github.com/laling08/Unix_Project.git)

- Each member will commit their changes and contribute to the repository.
- Regular updates and testing will be done to ensure all functionalities work as expected.

## Project Evaluation

The project will be evaluated based on:
- **Functionality**: Ensuring that each task performs correctly.
- **User-Friendliness**: The menu interface should be simple, clear, and intuitive for system administrators.
- **Documentation**: Detailed explanations of each feature, including usage instructions and command references.

---

