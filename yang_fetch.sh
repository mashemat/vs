#!/bin/bash

# This is the yang repository from standards organizations such as the IETF, The IEEE,
# The Metro Ethernet Forum, open source such as Open Daylight or vendor specific modules

VSWITCH_REPO="https://raw.githubusercontent.com/icn-team/vSwitch/master/yang-models/"

YANG_LIST=()
mkdir -p ${PWD}/yang
NYANG=0
EXIT_CODE=0
PREFIX="${PWD}/yang"

message() {
    [ "${2}" = OK ] && color=2 || color=1
    printf "%s\n" "$(tput setaf "$color")" "${1}"
    printf "%s" "$(tput sgr0)" " "
}

read_yang_list() {
    while IFS='' read -r line || [[ -n "${line}" ]]; do
        echo " ${line} added to the list"
        YANG_LIST[${NYANG}]=${line}
        ((NYANG++))
    done < "${1}"
    
    message "Yang model added successfully" "OK"    
    ((NYANG--))
}

download() {
    ret=0
    pushd ${PREFIX}
    for i in $(seq 0 ${NYANG}); do
        echo "Downloading ${YANG_LIST[$i]}"
        URL="${VSWITCH_REPO}${YANG_LIST[$i]}"
        curl -OL ${URL}
        ((ret=ret+${?}))
    done
    popd

    if [ ${ret} = 0 ]; then
        message "Successfully Downloaded" "OK"
    else
        message "Error downloading" "ERR"
        exit ${EXIT_CODE}
    fi
#    name="${LOGDATE}@$1"
}

install() {
    command -v sysrepoctl > /dev/null
    if [ ${?} != 0 ]; then
        echo "Could not find command \"sysrepoctl\"."
        exit ${EXIT_CODE}
    else
        pushd ${PREFIX}
        echo "Changing directory to ${PWD}"
        for i in $(seq 0 ${NYANG}); do
          sysrepoctl --install --yang=${YANG_LIST[$i]} --search-installed
        done
        popd
    fi

    sysrepoctl --list
}


#****Main****

# Adding the yang model
echo "Adding the yang list"
read_yang_list yang_list.txt

# Downloading the yang models from repositpory
echo "Downloading the yang list "
download

# Installing the yang models from repositpory
echo "Installing the yang list "
install