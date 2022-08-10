echo "Script to install all dependencies"

#Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#brew doctor - 'Warning: <path> was not tapped properly! run...

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

#Verify Salesforce CLI Version
sfdx --version

#Verify the Salesforce CLI plug-in version
sfdx plugins --core

echo "Installation is complete"