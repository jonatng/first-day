#!/bin/bash

echo "Script to install all dependencies"

#Install Homebrew (package manager)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#brew doctor - 'Warning: <path> was not tapped properly! run...

#Install Python3
brew install python3

#Install powerline via pip (package manager)
pip3 install powerline-status

#Update pip, if new version is found
/usr/local/opt/python@3.9/bin/python3.9 -m pip install --upgrade pip

#Install pip for git
pip3 install powerline-gitstatus

#Find the pip3 location
pip3 show powerline-status

#Install Node JS
brew install node

#Install Git
brew install git

#Install GitHub CLI
brew install gh

#Install Maven
brew install maven

#Install Salesforce CLI
npm install sfdx-cli --global

#Verify the Salesforce CLI plug-in version
sfdx plugins --core

echo "Status Check"

#Verify Salesforce CLI version
sfdx --version

#Verify Python version
python3 --version

#Verify GitHub CLI version
git --version

#Verify Maven version
mvn --version

