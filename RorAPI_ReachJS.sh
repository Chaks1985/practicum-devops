#!/bin/bash
###################################################################
#Script Name    : RorAPI_ReachJS.sh
#Description    : This script is used to pull apps from GIT and
#                 execute terraform script followed by Ansible
#Args           : NA
#Author         : Chakravarthi Thangavelu
#Email          : chakratechgeek@outlook.com
###################################################################


##########################################
# Global variable declaration
##########################################
ANSI_HOST="/etc/ansible/hosts"
ANSI_HOME="/root/aws_resource_terraform/Terrafrom-ELB-ASG/Ansible_RoRAPI_ReachJS"
TERR_HOME="/root/aws_resource_terraform/Terrafrom-ELB-ASG/Project_reach_RoRAPI"
BASE_DIR=$(pwd)
LOG_DIR=/tmp/Logs
GIT_CLONE_LOC="/etc/ansible/roles/RoRAPI_Reactjs/templates"
##########################################
# Check and create logfile
##########################################

if test ! -f "${LOG_DIR}"; then
   mkdir -p /tmp/Logs
fi
##########################################
# Set ansible conf file for execution
##########################################

ANS_FILE=/etc/ansible/ansible.cfg
if test -f "${ANS_FILE}"; then
   export ANSIBLE_CONFIG=/etc/ansible/ansible.cfg
else
   echo "File not found: ${ANS_FILE}"
   exit 1
fi

##########################################
# App file GIT clone into Ansible file
##########################################

cd ${GIT_CLONE_LOC}
git clone https://github.com/CareerFoundry-Engineering/practicum-devops.git

##########################################
# Spin up AWS resouces for this app
##########################################

cd ${TERR_HOME}
terraform init
terraform apply -auto-approve
##########################################
# Install and configure for app using Ansible
##########################################

cd ${ANSI_HOME}
ansible-playbook main.yml

