#!/bin/bash
# SFDX Menu
# 

function run {
    echo
    echo $1
    eval "$1"
    echo
}

function select-username {
    options=$(cat ~/.dxorgs | tr -s ' ' | cut -f3 -d ' ' | grep @ )
    select choice in $options ; do 
        username=$choice;
        break
    done;
    
}

function login {
    read -p " Which alias? : " alias
    read -p " Which sandbox (y/n)? : " issandbox
    sandboxstr=""
    if [[ "$issandbox" =~ ^(yes|y)$ ]] ; then
        sandboxstr=" -r https://login.salesforce.com/"
    else 
        sandboxstr=
    fi
    run "sfdx force:auth:web:login -a $alias $sandboxstr"       
}

function new-project {
    read -p " Which name? : " project
    run "sfdx force:project:create -x -n $project"       
}

function retrieve {
    read -p " Which alias? : " alias
    read -p " Which metadata? ApexClass, AuraDefinitionBundle... : " metadata
    run "sfdx force:source:retrieve -m $metadata -u $alias"       
}

function deploy {
    read -p " Which alias? : " alias
    read -p " Which metadata? ApexClass, AuraDefinitionBundle... : " metadata
    run "sfdx force:source:deploy -m $metadata -u $alias"       
}

function open {
    select-username
    run "sfdx force:org:open -p $1 -u $username"
}

function list-orgs {
    if [ -e ~/.dxorgs ] 
    then 
        run "cat ~/.dxorgs"
    else 
        run "sfdx force:org:list --clean > ~/.dxorgs; cat ~/.dxorgs" 
    fi
}

RED='\033[0;35m'
NC='\033[0m' # No Color
echo -e "\n ${RED} DX Commands: ${NC} \n"
PS3=" Enter your choice :"
while true; do
    options=("list-orgs" "refresh-orgs-list" "login-to-new-org" "new-project" "retrieve" "deploy" "query" "describe-object" "open-home" "open-setup" "open-dev" "search-for-errors" "tail-logs" "which-user-am-i" "switch-user" "remove-org" "lint-current" "generate-csv" "exit")
    echo -e " ${RED} Choose an option: ${NC} "
    select opt in "${options[@]}"; do
        case $opt in
            "list-orgs") list-orgs; break ;;
            "login-to-new-org") login; break ;;
            "new-project") new-project; break ;;
            "retrieve") retrieve; break;;
            "deploy") deploy; break;;
            "query") read -p "SOQL : " soql; run 'sfdx force:data:soql:query -q "$soql"' -u="jonatng@summerdale.com"; break;;
            "describe-object") read -p "Object : " object; run 'sfdx force:schema:sobject:describe -s $object --json | jq'; break;;
            "refresh-orgs-list") run "sfdx force:org:list --clean > ~/.dxorgs; cat ~/.dxorgs"; break ;;
            "search-for-errors") run "sfdx force:apex:log:get -n 15 -c | grep -iE 'FATAL|ERROR|EXCEPTION' -C 10 --color=always"; break ;;
            "tail-logs") run "sfdx force:apex:log:tail --color"; break ;;
            "which-user-am-i") run "sfdx force:org:display | grep Username | tr -s ' ' | cut -f2 -d ' '"; break ;;
            "switch-user") read -p " Which username? : " username; run "sfdx force:config:set defaultusername=$username"; break ;;
            "open-home") open "/"; break ;;
            "open-dev") open "/_ui/common/apex/debug/ApexCSIPage"; break ;;
            "open-setup") open "/lightning/setup/SetupOneHome/home"; break ;;
            "remove-org")  select-username; run "sfdx force:org:delete -u $username"; run "sfdx force:org:list --clean > ~/.dxorgs; cat ~/.dxorgs"; break ;;
            "lint-current") run "sfdx force:lightning:lint force-app/main/default/aura"; break ;;
            "generate-csv") "sfdx force:data:soql:query -q "SELECT Id, Name FROM Account LIMIT 10" -u="user@sfdc.com" -r=csv > results.csv"; break ;;
            "exit") break 2 ;;
            *) echo "What's that?" >&2
        esac
    done
done

exit 0