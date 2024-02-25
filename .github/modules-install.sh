#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This install script must run as root." 1>&2
    exit 1
else
    echo ""
    echo ""
    echo " WSL2 Kernel modules package installer "
    echo " Made by Nevuly "
    echo ""
    echo ""
    echo " Start to install kernel modules package. "

    echo ""
    echo ""
    echo " Checking kernel version... "

    if [[ ! -e "kernel_version.txt" ]]; then
        echo ""
        echo ""
        echo " !!-- Kernel version not found! --!! "
        echo " !!-- Abort install kernel modules package --!! "
        echo ""
        echo ""
        exit 1
    else
        version=$(<kernel_version.txt)
        echo ""
        echo ""
        echo " Kernel version found. "
        echo " Kernel version: $version "
    fi

    echo ""
    echo ""
    echo " Checking kernel modules package folder and files... "
    if [[ ! -d "lib/modules/$version-WSL2-STABLE+" ]]; then
        if [[ ! -d "lib/modules/$version-WSL2-LTS+" ]]; then
            echo ""
            echo ""
            echo " !!-- Kernel modules package folder not found! --!! "
            echo " !!-- Abort install kernel modules package --!! "
            echo ""
            echo ""
            exit 1
        else
            echo ""
            echo ""
            echo " LTS kernel detected. "
            channel=lts
        fi
    else
        echo ""
        echo ""
        echo " Stable kernel detected. "
        channel=stable
    fi

    if [[ $channel == "stable" ]]; then
        if [[ ! -e "lib/modules/$version-WSL2-STABLE+/modules.alias" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-STABLE+/modules.alias.bin" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-STABLE+/modules.builtin" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-STABLE+/modules.builtin.alias.bin" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-STABLE+/modules.builtin.bin" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-STABLE+/modules.builtin.modinfo" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-STABLE+/modules.dep" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-STABLE+/modules.dep.bin" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-STABLE+/modules.devname" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-STABLE+/modules.order" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-STABLE+/modules.softdep" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-STABLE+/modules.symbols" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-STABLE+/modules.symbols.bin" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ $file_checker == "1" ]]; then
            echo ""
            echo ""
            echo " Kernel modules package files found. "
        else
            echo ""
            echo ""
            echo " !!-- Some kernel modules package files not found! --!! "
            echo " !!-- Abort install kernel modules package --!! "
            echo ""
            echo ""
            exit 1
        fi
    else
        if [[ ! -e "lib/modules/$version-WSL2-LTS+/modules.alias" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-LTS+/modules.alias.bin" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-LTS+/modules.builtin" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-LTS+/modules.builtin.alias.bin" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-LTS+/modules.builtin.bin" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-LTS+/modules.builtin.modinfo" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-LTS+/modules.dep" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-LTS+/modules.dep.bin" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-LTS+/modules.devname" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-LTS+/modules.order" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-LTS+/modules.softdep" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-LTS+/modules.symbols" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ ! -e "lib/modules/$version-WSL2-LTS+/modules.symbols.bin" ]]; then
            file_checker=0
        else
            file_checker=1
        fi

        if [[ $file_checker == "1" ]]; then
            echo ""
            echo ""
            echo " Kernel modules package files found. "
        else
            echo ""
            echo ""
            echo " !!-- Some kernel modules package files not found! --!! "
            echo " !!-- Abort install kernel modules package --!! "
            echo ""
            echo ""
            exit 1
        fi
    fi

    echo ""
    echo ""
    echo " Check kernel modules package directory... "

    if [[ ! -d "/lib/modules" ]]; then
        modules_loc_1=0
    else
        modules_loc_1=1
    fi

    if [[ ! -d "/usr/lib/modules" ]]; then
        modules_loc_2=0
    else
        modules_loc_2=1
    fi

    if [[ $modules_loc_1 == "1" && $modules_loc_2 == "1" ]]; then
        echo ""
        echo ""
        echo " Kernel modules package directory found. "
    else
        if [[ $modules_loc_1 == "0" && $modules_loc_2 == "1" ]]; then
            echo ""
            echo ""
            echo " /lib/modules directory not exists. Make new one "
            sudo mkdir -p /lib/modules
            sudo chown root:root /lib/modules
            sudo chmod 755 /lib/modules
        else
            if [[ $modules_loc_1 == "1" && $modules_loc_2 == "0" ]]; then
                echo ""
                echo ""
                echo " /usr/lib/modules directory not exists. Make new one "
                sudo mkdir -p /usr/lib/modules
                sudo chown root:root /usr/lib/modules
                sudo chmod 755 /usr/lib/modules
            else
                echo ""
                echo ""
                echo " /lib/modules and /usr/lib/modules directory not exists. Make new one "
                sudo mkdir -p /usr/lib/modules
                sudo chown root:root /usr/lib/modules
                sudo chmod 755 /usr/lib/modules
                sudo mkdir -p /usr/lib/modules
                sudo chown root:root /usr/lib/modules
                sudo chmod 755 /usr/lib/modules
            fi
        fi
    fi

    echo ""
    echo ""
    echo " /lib/modules directory files: "
    echo ""
    echo ""
    ls -la /lib/modules

    echo ""
    echo ""
    echo " /usr/lib/modules directory files: "
    echo ""
    echo ""
    ls -la /usr/lib/modules

    echo ""
    echo ""
    echo " Remove old kernel modules packages... "
    sudo rm -rf /lib/modules/*-WSL2-STABLE+
    sudo rm -rf /lib/modules/*-WSL2-LTS+
    sudo rm -rf /usr/lib/modules/*-WSL2-STABLE+
    sudo rm -rf /usr/lib/modules/*-WSL2-LTS+
    
    echo ""
    echo ""
    echo " /lib/modules directory files: "
    echo ""
    echo ""
    ls -la /lib/modules

    echo ""
    echo ""
    echo " /usr/lib/modules directory files: "
    echo ""
    echo ""
    ls -la /usr/lib/modules

    echo ""
    echo ""
    echo " Copy new kernel modules package... "
    if [[ $channel == "stable" ]]; then
        sudo cp -r lib/modules/$version-WSL2-STABLE+ /lib/modules/
        sudo cp -r lib/modules/$version-WSL2-STABLE+ /usr/lib/modules/
        sudo chown -R root:root /lib/modules/$version-WSL2-STABLE+
        sudo chown -R root:root /usr/lib/modules/$version-WSL2-STABLE+
    else
        sudo cp -r lib/modules/$version-WSL2-LTS+ /lib/modules/
        sudo cp -r lib/modules/$version-WSL2-LTS+ /usr/lib/modules/
        sudo chown -R root:root /lib/modules/$version-WSL2-LTS+
        sudo chown -R root:root /usr/lib/modules/$version-WSL2-LTS+
    fi

    echo ""
    echo ""
    echo " /lib/modules directory files: "
    echo ""
    echo ""
    ls -la /lib/modules

    echo ""
    echo ""
    echo " /usr/lib/modules directory files: "
    echo ""
    echo ""
    ls -la /usr/lib/modules

    echo ""
    echo ""
    echo " New kernel modules package in /lib/modules: "
    echo ""
    echo ""
    if [[ $channel == "stable" ]]; then
        ls -la /lib/modules/$version-WSL2-STABLE+
    else
        ls -la /lib/modules/$version-WSL2-LTS+
    fi

    echo ""
    echo ""
    echo " New kernel modules package in /usr/lib/modules: "
    echo ""
    echo ""
    if [[ $channel == "stable" ]]; then
        ls -la /usr/lib/modules/$version-WSL2-STABLE+
    else
        ls -la /usr/lib/modules/$version-WSL2-LTS+
    fi

    echo ""
    echo ""
    echo " Done. You must reboot your WSL2 system. "
    echo ""
    echo ""
    exit 0
fi
