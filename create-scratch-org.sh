create-scratch-org


#!/bin/bash

# Set your Salesforce username and password
SF_USERNAME="your_username"
SF_PASSWORD="your_password"

# Set the name of your scratch org, the duration of its lifespan (in days), and the custom settings
SCRATCH_ORG_NAME="my_scratch_org"
SCRATCH_ORG_DURATION=7
CUSTOM_SETTINGS="MyCustomSetting__c=true,AnotherCustomSetting__c=value"

# Set the default Dev Hub username and the alias for your Dev Hub org
DEV_HUB_USERNAME="your_dev_hub_username"
DEV_HUB_ALIAS="dev_hub_alias"

# Set the edition and the default scratch org definition file
EDITION="Developer"
SCRATCH_ORG_DEF_FILE="config/project-scratch-def.json"

# Authenticate with Salesforce using your username and password
sfdx force:auth:jwt:grant --clientid "${CONSUMER_KEY}" --jwtkeyfile assets/server.key --username "${SF_USERNAME}" --setdefaultdevhubusername --setalias "${DEV_HUB_ALIAS}"

# Create the scratch org
sfdx force:org:create --definitionfile "${SCRATCH_ORG_DEF_FILE}" --durationdays "${SCRATCH_ORG_DURATION}" --setalias "${SCRATCH_ORG_NAME}" --targetdevhubusername "${DEV_HUB_ALIAS}" --edition "${EDITION}" --setdefaultusername

# Set the custom settings for the scratch org
sfdx force:config:set --settings "${CUSTOM_SETTINGS}"

# Populate the scratch org with mock data
sfdx force:data:tree:import --plan data/sample-data-plan.json

# Open the scratch org
sfdx force:org:open
