#!/bin/bash
PS3='Select Command: '
cmd=("InstallCmatrixDebian" "InstallCmatrixArch" "RunCmatrix" "InstallTimeDateDebian" "InstallTimeDateArch" "TimeDate" "Quit")
select opt in "${cmd[@]}"; do
    case $opt in
        "InstallCmatrixDebian")
            sudo apt install cmatrix
            ;;
        "InstallCmatrixArch")
            sudo pacman -S cmatrix
            ;;
        "RunCmatrix")
            sudo cmatrix
            ;;
         "InstallTimeDateDebian")
            sudo apt install toilet
            ;;
         "InstallTimeDateArch")
            sudo pacman -S toilet
            ;;
        "TimeDate")
            while true; do echo "$(date '+%D %T' | toilet -f term -F border --gay)"; sleep 1; done
            break
            ;;
	      "Quit")
	          echo "User requested exit"
	    exit
	    ;;
        *) echo "invalid option $REPLY";;
    esac
done
#root@tecmint:~# apt-get install libcurses-perl
#root@tecmint:~# cd /tmp
#root@tecmint:~# wget http://search.cpan.org/CPAN/authors/id/K/KB/KBAUCOM/Term-Animation-2.4.tar.gz
#root@tecmint:~# tar -zxvf Term-Animation-2.4.tar.gz
#root@tecmint:~# cd Term-Animation-2.4/
#root@tecmint:~# perl Makefile.PL &&  make &&   make test
#root@tecmint:~# make install

#root@tecmint:~# cd /tmp
#root@tecmint:~# wget http://www.robobunny.com/projects/asciiquarium/asciiquarium.tar.gz
#root@tecmint:~# tar -zxvf asciiquarium.tar.gz
#root@tecmint:~# cd asciiquarium_1.1/
#root@tecmint:~# cp asciiquarium /usr/local/bin
#root@tecmint:~# chmod 0755 /usr/local/bin/asciiquarium
