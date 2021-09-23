#!/bin/bash
PS3='Select Command: '
cmd=("UpdateArch" "StartMongo" "DumpMongo" "RestoreMongo" "Quit")
select opt in "${cmd[@]}"; do
    case $opt in
        "UpdateArch")
            sudo pacman -Syu
            ;;
        "StartMongo")
            systemctl start mongodb
            ;;
        "DumpMongo")
            echo "$opt not yet implimented"
            ;;
        "RestoreMongo")
            echo "$opt not yet implimented"
	    break
            ;;
	      "Quit")
	          echo "User requested exit"
	    exit
	    ;;
        *) echo "invalid option $REPLY";;
    esac
done
