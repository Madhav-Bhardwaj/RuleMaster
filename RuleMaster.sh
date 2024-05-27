#!/bin/bash

# Log file for firewall changes
LOG_FILE="/var/log/firewall_config.log"

# Function to log changes
log_change() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a $LOG_FILE
}

# Function to check current firewall status
check_status() {
    echo "Checking firewall status..."
    sudo ufw status verbose
    log_change "Checked firewall status."
}

# Function to enable the firewall
enable_firewall() {
    echo "Enabling firewall..."
    sudo ufw enable
    log_change "Enabled firewall."
}

# Function to disable the firewall
disable_firewall() {
    echo "Disabling firewall..."
    sudo ufw disable
    log_change "Disabled firewall."
}

# Function to add a firewall rule
add_rule() {
    echo "Enter rule to add (e.g., 'allow 80/tcp' or 'deny from 192.168.1.100'):"
    read rule
    sudo ufw $rule
    log_change "Added rule: $rule"
}

# Function to remove a firewall rule
remove_rule() {
    echo "Current rules:"
    sudo ufw status numbered
    echo "Enter rule number to remove (e.g., '3' for rule #3):"
    read rule_number
    sudo ufw delete $rule_number
    log_change "Removed rule number: $rule_number"
}

# Function to list all firewall rules
list_rules() {
    sudo ufw status verbose
    log_change "Listed firewall rules."
}

# Function to save the current firewall configuration
save_config() {
    echo "Saving current configuration to /etc/ufw/rules.conf"
    sudo ufw status numbered > /etc/ufw/rules.conf
    log_change "Saved configuration to /etc/ufw/rules.conf"
}

# Function to restore firewall configuration from a file
restore_config() {
    echo "Restoring configuration from /etc/ufw/rules.conf"
    sudo ufw reset
    sudo ufw reload < /etc/ufw/rules.conf
    log_change "Restored configuration from /etc/ufw/rules.conf"
}

# Function to show the main menu
show_menu() {
    echo "Advanced Firewall Configuration Script"
    echo "1. Check Firewall Status"
    echo "2. Enable Firewall"
    echo "3. Disable Firewall"
    echo "4. Add Rule"
    echo "5. Remove Rule"
    echo "6. List Rules"
    echo "7. Save Configuration"
    echo "8. Restore Configuration"
    echo "9. Quit"
}

# Main script loop
while true; do
    echo ""
    list_rules  # Display current rules on start
    show_menu
    read -p "Please enter your choice: " choice
    case $choice in
        1) check_status ;;
        2) enable_firewall ;;
        3) disable_firewall ;;
        4) add_rule ;;
        5) remove_rule ;;
        6) list_rules ;;
        7) save_config ;;
        8) restore_config ;;
        9) echo "Exiting."; log_change "Exited the script."; exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
    echo ""
done

