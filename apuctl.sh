#!/bin/bash
echo "apuctl v1.01 2022 (c) MonkeyCat (code.monkeycat.nl)"
echo
# possible expansion: sim status/options not show up for apu2 apu4c2 apu4d2"
# probably check if there is an actual wifi card in the mPCIe slots"

if [[ "$#" == "1" ]]; then

    if [ "$EUID" -ne 0 ]; then
        echo "not root"
        exit 1
    fi

    model=$(dmidecode -t baseboard | grep Product | cut -d' ' -f 3)
    serial=$(dmidecode -t baseboard | grep "Serial" | cut -d' ' -f 3)

    if [[ $(echo $model | sed 's/.$//') != "apu" ]]; then
        echo "not an apu"
        exit 2
    fi


#    echo 386 > /sys/class/gpio/export 2>/dev/null

#    if [ $? -ne 0 ]; then
#        echo "no access to gpio"
#        exit 3
#    fi

    echo 387 > /sys/class/gpio/export
    echo 391 > /sys/class/gpio/export
    echo 392 > /sys/class/gpio/export
    echo 410 > /sys/class/gpio/export
    echo out > /sys/class/gpio/gpio386/direction
    echo out > /sys/class/gpio/gpio387/direction
    echo out > /sys/class/gpio/gpio391/direction
    echo out > /sys/class/gpio/gpio392/direction
    echo out > /sys/class/gpio/gpio410/direction
    echo 1 > /sys/class/gpio/gpio386/active_low
    echo 1 > /sys/class/gpio/gpio387/active_low
    echo 1 > /sys/class/gpio/gpio391/active_low
    echo 1 > /sys/class/gpio/gpio392/active_low
    echo 1 > /sys/class/gpio/gpio410/active_low

    sim=$(cat /sys/class/gpio/gpio410/value)
    wifi1=$(cat /sys/class/gpio/gpio391/value)
    wifi2=$(cat /sys/class/gpio/gpio392/value)

    if [[ "$1" == "status" ]]; then
        if [[ "$sim" == "0" ]]; then
            echo "simcard slot one is selected"
        else
            echo "simcard slot two is selected"
        fi
        if [[ "$wifi1" == "1" ]]; then
            echo "wifi mPCIe2 on"
        else
            echo "wifi mPCIe2 off"
        fi
        if [[ "$wifi2" == "1" ]]; then
            echo "wifi mPCIe3 on"
        else
            echo "wifi mPCIe3 off"
        fi
        exit
    fi

    if [[ "$1" == "on" ]]; then
        echo 1 > /sys/class/gpio/gpio391/value
        echo 1 > /sys/class/gpio/gpio392/value
    elif [[ "$1" == "off" ]]; then
        echo 0 > /sys/class/gpio/gpio391/value
        echo 0 > /sys/class/gpio/gpio392/value
    elif [[ "$1" == "one-on" ]]; then
        echo 1 > /sys/class/gpio/gpio391/value
    elif [[ "$1" == "one-off" ]]; then
        echo 0 > /sys/class/gpio/gpio391/value
    elif [[ "$1" == "two-on" ]]; then
        echo 1 > /sys/class/gpio/gpio392/value
    elif [[ "$1" == "two-off" ]]; then
        echo 0 > /sys/class/gpio/gpio392/value
    elif [[ "$1" == "sim-one" ]]; then
        echo 0 > /sys/class/gpio/gpio410/value
    elif [[ "$1" == "sim-two" ]]; then
        echo 1 > /sys/class/gpio/gpio410/value
    elif [[ "$1" == "one-reset" ]]; then
        echo 1 > /sys/class/gpio/gpio386/value
        sleep 1
        echo 0 > /sys/class/gpio/gpio386/value
    elif [[ "$1" == "two-reset" ]]; then
        echo 1 > /sys/class/gpio/gpio387/value
        sleep 1
        echo 0 > /sys/class/gpio/gpio387/value
    elif [[ "$1" == "coldboot" ]]; then
        for i in s u; do echo $i | sudo tee /proc/sysrq-trigger > /dev/null 2>&1; sleep 15; done
        echo -ne "\xe" | dd of=/dev/port bs=1 count=1 seek=$((0xcf9))
    fi

else
    echo "usage: apuctl command"
    echo
    echo " status         show status of the wifi and the simcards slot"
    echo " on             enable  mPCIe wifi transmission"
    echo " off            disable mPCIe wifi transmission"
    echo " one-on         enable  mPCIe2 wifi transmission"
    echo " one-off        disable mPCIe2 wifi transmission"
    echo " two-on         enable  mPCIe3 wifi transmission"
    echo " two-off        disable mPCIe3 wifi transmission"
    echo " sim-one        select simcard one"
    echo " sim-two        select simcard two"
    echo " one-reset      reset mPCIe2"
    echo " two-reset      reset mPCIe3"
    echo " coldboot       cold reboot"
    echo
fi
