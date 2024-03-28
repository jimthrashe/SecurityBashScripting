#!/bin/bash




########################################################################
#                                                                      #    
#  James Thrasher                                                      #       
#                                                                      #   
#   This script sets up linux operating systems with the tools I like. #
#                                                                      #              
#                                                                      #
########################################################################



#Dependents

format(){
  echo "#############################################################################################################"
  echo "#############################################################################################################"
  echo "#############################################################################################################"
  echo "#############################################################################################################"
  echo "#############################################################################################################"
}
checkos() {
    # Check if /etc/os-release exists
    if [ -f /etc/os-release ]; then
        # Use sed to extract the NAME field from /etc/os-release
        os=$(sed -n 's/^NAME="\?\([^"]*\)"\?$/\1/p' /etc/os-release)
        # Convert to lowercase for comparison
        os=$(echo "$os" | tr '[:upper:]' '[:lower:]')
    else
        # If /etc/os-release does not exist, set os to "Unknown"
        os="Unknown"
    fi
}
if_Archinstall() {
    # Update package list and upgrade packages
    sudo pacman -Syu
    
    # Remove unused packages (orphans)
    sudo pacman -Rns $(pacman -Qtdq)
    
    # Install required packages
    sudo pacman -S --noconfirm gnome python code macchanger wireshark git binwalk neovim npm go make unzip gcc ripgrep 
}
if_DebianInstall() {
    # Update package list and upgrade packages
    sudo apt update
    sudo apt upgrade -y
    
    # Remove unused packages (orphans)
    sudo apt autoremove -y
    
    # Install required packages
    sudo apt install -y gnome python3 code macchanger wireshark git binwalk neovim npm golang make unzip gcc ripgrep
}


# Function to perform installation if the OS is Ubuntu
if_UbuntuInstall() {
    # Update package list and upgrade packages
    sudo apt update
    sudo apt upgrade -y
    
    # Remove unused packages (orphans)
    sudo apt autoremove -y
    
    # Install required packages
    sudo apt install -y gnome python3 code macchanger wireshark git binwalk neovim npm golang make unzip gcc ripgrep
}


# Function to perform installation if the OS is Fedora
if_FedoraInstall() {
    # Update package list and upgrade packages
    sudo dnf update -y
    
    # Remove unused packages (orphans)
    sudo dnf autoremove -y
    
    # Install required packages
    sudo dnf install -y gnome-shell python3 code macchanger wireshark git binwalk neovim npm golang make unzip gcc ripgrep
}


# Function to check the OS distribution
check_distribution() {
    case "$os" in
        arch)
            echo "This is Arch Linux."
                if_Archinstall
            ;;
        debian)
            echo "This is Debian."
                if_Debianinstall
            ;;
        ubuntu)
            echo "This is Ubuntu."
                if_Ubuntuinstall
            ;;
        fedora)
            echo "This is Fedora."
                if_Fedorainstall
            ;;
        *)
            echo "Unknown distribution."
            ;;
    esac
}








main(){

    checkos
    check_distribution





}

