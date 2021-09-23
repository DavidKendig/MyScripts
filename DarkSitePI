#!/bin/bash
PS3='Select Command: '
cmd=("UpdateArch" "InstallTOR" "StartTOR" "StopTOR" "StatusTOR" "TORaddress" "InstallNginx" "StartNginx" "StopNginx" "StatusNginx" "Quit")
select opt in "${cmd[@]}"; do
    case $opt in
        "UpdateArch")
            sudo apt update
            ;;
        "InstallTOR")
            sudo apt install tor
            ;;
        "StartTOR")
            sudo service tor start
            ;;
         "StopTOR")
            sudo service tor stop
            ;;
         "StatusTOR")
            sudo service tor status
            ;;
        "TORaddress")
            sudo cat /var/lib/tor/hidden_service/hostname
            ;;
        "InstallNginx")
            sudo apt install nginx
            ;;
        "StartNginx")
            sudo service nginx start
            ;; 
        "StopNginx")
            sudo service nginx stop
            ;;
        "StatusNginx")
            sudo service nginx status
            break
            ;;    
	      "Quit")
	          echo "User requested exit"
	    exit
	    ;;
        *) echo "invalid option $REPLY";;
    esac
done
