#!/bin/bash
PS3='Select Command: '
cmd=("UpdateArch" "InstallTOR" "StartTOR" "StopTOR" "StatusTOR" "TORaddress" "InstallNginx" "StartNginx" "StopNginx" "StatusNginx" "Quit")
select opt in "${cmd[@]}"; do
    case $opt in
        "UpdateArch")
            sudo pacman -Syu
            ;;
        "InstallTOR")
            sudo pacman -S tor
            ;;
        "StartTOR")
            sudo systemctl start tor
            ;;
         "StopTOR")
            sudo systemctl stop tor
            ;;
         "StatusTOR")
            sudo systemctl status tor
            ;;
        "TORaddress")
            sudo cat /var/lib/tor/hidden_service/hostname
            ;;
        "InstallNginx")
            sudo pacman -Syu nginx
            ;;
        "StartNginx")
            sudo systemctl start nginx
            ;; 
        "StopNginx")
            sudo systemctl stop nginx
            ;;
        "StatusNginx")
            sudo systemctl status nginx
            break
            ;;    
	      "Quit")
	          echo "User requested exit"
	    exit
	    ;;
        *) echo "invalid option $REPLY";;
    esac
done
