#!/usr/bin/env bash

usage() { echo "Usage: $0 [-n (OPTIONAL) <string:container_base_image>]" 1>&2; exit 1; }

function toggle_new() {

    while true; do
        echo "Do you wish to create the ${CONTAINER_OS}:${CONTAINER_VER} image? This will remove any existing images that were previously used with remote whale."
        read -p "[y/n]" yn
        case $yn in
            [Yy]* ) new; break;;
            [Nn]* ) echo "Process terminated."; exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done

}

function new() {

    rewrite_conf_file

    collect_vars

    echo "###############################"
    echo "#       Recrating Image       #"
    echo "###############################"


    # /usr/bin/expect << EOF
    sudo tee > $TMP_FILE_NEW << EOF
#!/usr/bin/expect

spawn ssh ${SSH_USERNAME}@${DKR_HOST}
expect "*assword:"
send "${SSH_PASSWORD}\r"

expect "* ~ % "
send "sudo docker rm ${PRJ_USER}_${CONTAINER_OS}_container\r"
expect "*assword:"
send "${SSH_PASSWORD}\r"

expect "* ~ % "
send "sudo docker volume create -d vieux/sshfs -o sshcmd=${PRJ_USER}@${PRJ_IP}:${PRJ_PATH} -o password=${PRJ_PASSWORD} ${PRJ_USER}_${PRJ_NAME}_vol\r"

expect "* ~ % "
send "sudo docker run -it -v ${PRJ_USER}_${PRJ_NAME}_vol:/usr/src --name ${PRJ_USER}_${CONTAINER_OS}_container ${CONTAINER_OS}:${CONTAINER_VER} bash\r"
# expect "*assword:"
# send "${SSH_PASSWORD}\r"

expect "*# "
# Navigates into the ~/usr/{PRJ_NAME} folder (same dir as volume is attached)
send "cd /usr/src\r"

send "clear\r"
send "###############################\r"
send "#   Initialization Complete   #\r"
send "###############################\r"
interact
EOF
    sudo chmod +x $TMP_FILE_NEW
    $TMP_FILE_NEW
}

function recurrent() {

    read_conf_file

    collect_vars

    echo "###############################"
    echo "#     Starting Connection     #"
    echo "###############################"

    tee > $TMP_FILE_REC << EOF
#!/usr/bin/expect

spawn ssh ${SSH_USERNAME}@${DKR_HOST}
expect "*assword:"
send "${SSH_PASSWORD}\r"

# Creates a docker volume using the vieux/sshfs plugin
expect "* ~ % "
send "sudo docker volume create -d vieux/sshfs -o sshcmd=${PRJ_USER}@${PRJ_IP}:${PRJ_PATH} -o password=${PRJ_PASSWORD} ${PRJ_USER}_${PRJ_NAME}_vol\r"
expect "*assword:"
send "${SSH_PASSWORD}\r"

# Commits the previously created container into an image (to be able to re-use it later)
expect "* ~ % "
send "sudo docker commit ${PRJ_USER}_${CONTAINER_OS}_container user/${PRJ_USER}_${CONTAINER_OS}_img_lst\r"

# Removes the previous container
expect "* ~ % "
send "sudo docker rm ${PRJ_USER}_${CONTAINER_OS}_container\r"

# Runs a new container in bash
expect "* ~ % "
send "sudo docker run -it -v ${PRJ_USER}_${PRJ_NAME}_vol:/usr/src --name ${PRJ_USER}_${CONTAINER_OS}_container user/${PRJ_USER}_${CONTAINER_OS}_img_lst bash\r"

# Navigates into the ~/usr/{PRJ_NAME} folder (same dir as volume is attached)
send "cd /usr/src\r"

# Prints a warning, saying that the initialization has been completed
send "clear\r"
send "###############################\r"
send "#   Initialization Complete   #\r"
send "###############################\r"
interact
EOF

    sudo chmod +x $TMP_FILE_REC
    $TMP_FILE_REC

}

function collect_vars() {

    PRJ_PATH=${PWD}
    PRJ_USER=${USER}
    PRJ_IP=$(ipconfig getifaddr en0)
    PRJ_NAME=${PWD##*/}
    read -s -p "$PRJ_USER password: " PRJ_PASSWORD
    echo ""
    read -s -p "$SSH_USERNAME@$DKR_HOST password: " SSH_PASSWORD
    echo ""

}

function rewrite_conf_file() {

    sudo tee > $CONF_FILE << EOF
################################
#      Remote Whale .conf      #
################################
# This .conf file stores info about the last connection made to the server.
# Changing this may result in re-creation of a container, and consequently
# loss of container data
#
DKR_HOST ${DKR_HOST}
SSH_USERNAME ${SSH_USERNAME}
LAST_CONTAINER_BASE_IMAGE ${CONTAINER_OS}
EOF
}

function create_conf_file() {
    read -p "Docker-Host IP: " DKR_HOST
    read -p "Docker-Host USER: " SSH_USERNAME

    sudo touch $CONF_FILE
    sudo chmod 777 $CONF_FILE

    sudo tee > $CONF_FILE << EOF
################################
#      Remote Whale .conf      #
################################
# This .conf file stores info about the last connection made to the server.
# Changing this may result in re-creation of a container, and consequently
# loss of container data
#
DKR_HOST ${DKR_HOST}
SSH_USERNAME ${SSH_USERNAME}
LAST_CONTAINER_BASE_IMAGE ${CONTAINER_OS}
EOF


}

function read_conf_file() {

    while IFS=$'= ' read -r Key Value; do
        # echo "Key: $Key; Value: $Value"
        if [ $Key = "DKR_HOST" ]; then
            DKR_HOST=$Value
        fi
        if [ $Key = "SSH_USERNAME" ]; then
            SSH_USERNAME=$Value
        fi
        if [ $Key = "LAST_CONTAINER_BASE_IMAGE" ]; then
            CONTAINER_OS=$Value
        fi
    done < $CONF_FILE
}

function read_defaults() {
    while IFS=$'= ' read -r Key Value; do
        # echo "Key: $Key; Value: $Value"
        if [ $Key = "DKR_HOST" ]; then
            DKR_HOST=$Value
        fi
        if [ $Key = "SSH_USERNAME" ]; then
            SSH_USERNAME=$Value
        fi
    done < $CONF_FILE
}

function find_paths() {
    if [ "$(uname)" == "Darwin" ]; then
        # Do something under Mac OS X platform
        mkdir -p "${TMPDIR}.remote-whale/tmp/"
        TMP_FILE_REC="${TMPDIR}.remote-whale/tmp/.remote-whale-expect-rec"
        TMP_FILE_NEW="${TMPDIR}.remote-whale/tmp/.remote-whale-expect-new"
        CONF_FILE="/Users/${USER}/.remote-whale/.remote-whale.conf"
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        # Do something under GNU/Linux platform
        :
    elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
        # Do something under 32 bits Windows NT platform
        :
    elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
        # Do something under 64 bits Windows NT platform
        :
    fi
}

function wipe() {
    sudo rm -r "${TMPDIR}.remote-whale/tmp/"
    sudo rm $CONF_FILE
}

###################
#### - MAIN: - ####
###################

find_paths

# -n <string:CONTAINER_IMAGE> -w
while getopts n:w: options; do
    case $options in
        n) CONTAINER_INPUT=$OPTARG;;
        w) wipe; exit;;
    esac
done

read_conf_file

if [ -f "$CONF_FILE" ]; then
    read_defaults
else
    echo "No config file found."
    echo "Creating config file..."
    create_conf_file
fi

if [ $CONTAINER_INPUT ]
then
    CONTAINER_OS="${CONTAINER_INPUT%%:*}"
    CONTAINER_VER="${CONTAINER_INPUT#*':'}"
    if [ $CONTAINER_VER=$CONTAINER_OS ]
    then
        CONTAINER_VER="latest"
    fi
    toggle_new
else
    read_conf_file
    recurrent
fi
