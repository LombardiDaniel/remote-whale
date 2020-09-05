#!/usr/bin/env bash

function install() {

    if [ "$(uname)" == "Darwin" ]; then
        # Do something under Mac OS X platform
        sudo mkdir -p "/Users/${USER}/.remote-whale/"
        sudo cp "./src/remote-whale.sh" "/usr/local/bin/remote-whale"
        chmod +x "/usr/local/bin/remote-whale"

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

    echo "Installation completed."

}

while true; do
    cat << "EOF"
                         &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                        &&///////////////////////////////////////&%
                        &&///@ @#//%@ @//////////////////////////&%
                        &&////////////////////////////%##((((%*#((((((,
    Remote-Whale         &&&&&&&&&&&&&&&&&&&&&&&&&&&&&#%((((((((((((#,
    Installation            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%(((/
                           %./..#..,((((((((((((((((((((((((((#
                           %(       .(((((((((((((((((((((((((*
                           **#     (  %((((((((((((((((((((((%
                             %/  *  *   %(((((((((((((((((##
                               *%(%        %#((((((((#%%,
                         .&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                        &&///////////////////////////////////////&#
                        &&//////////////////////////@@%///@@@////&%
                        &&//////////////////////////%&/////&(////&%
                         &%/////////////////////////////////////%&,
EOF
    echo "You are about to install remote-whale. Continue?"
    read -p "[y/n]" yn
    case $yn in
        [Yy]* ) install; break;;
        [Nn]* ) echo "Process terminated."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
