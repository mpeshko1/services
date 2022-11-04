#!/bin/bash

function update {
    sudo apt -y update
    sudo apt -y upgrade
}

function install_packages {
    sudo apt install -y  gcc openssl-devel bzip2-devel libffi-devel wget
    sudo apt install -y software-properties-common
}

function add_repo {
    sudo add-apt-repository ppa:deadsnakes/ppa
}

function install_python {
    sudo apt -y install python3.9
}

function install_pip {
    sudo apt -y install python3-pip
}

function main {
    update
    install_packages
    #add_repo
    #install_python
    #update
    #install_pip
}

main
