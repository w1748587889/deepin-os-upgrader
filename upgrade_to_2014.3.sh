#!/bin/bash
function remove_cache(){
    rm -rf /home/*/.config/deepin_monitors.json
    rm -rf /usr/share/icons/*/icon-theme.cache
}

function fix_postinst(){
    # Fix postinst errors while upgrading deepin-default-settings.
    FILE="/var/lib/dpkg/info/deepin-default-settings.postinst"
    if [ -f $FILE ];then
        sed -i 's/exit 1/exit 0/' $FILE
    fi
}

function install_remove_packages(){
    # remove packages which are not in 2014.3
    dpkg -p tlp >&/dev/null && apt-get purge tlp -y
    dpkg -p kingsoft-office &>/dev/null && apt-get purge -y kingsoft-office && apt-get install wps-office -y
    dpkg -l | grep wps-office- >/dev/null && apt-get purge -y wps-office-* && apt-get install wps-office -y
}

function upgrade(){
	if ! apt-get dist-upgrade -y ;then
		apt-get update -y
		apt-get dist-upgrade -y
	fi
	/usr/lib/deepin-daemon/grub2 --setup
	update-grub
}

if [ ! $UID == 0 ];then
    sudo bash $0
    exit
fi

apt-get update -y
remove_cache
fix_postinst
install_remove_packages
upgrade