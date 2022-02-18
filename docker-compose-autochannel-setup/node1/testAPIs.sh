#!/bin/bash
starttime=$(date +%s) 
# We need cURL
if [ ! -x "$(which curl)"  ]; then
    echo "Couldn't find cURL. Please install cURL to run this script"
    exit 1
fi

bold=$(tput bold)
normal=$(tput sgr0)

calledByName=$0
APIAddress="http://localhost:3000"
currentAPI="init"
currentOperation="none"
delay=2

startAssetID=$RANDOM

assetIDOne="Asset-$startAssetID"
startAssetID=$(($startAssetID + 1))
assetIDTwo="Asset-$startAssetID"


# Some utility functions for formatting the output and handling state
border () {
    local str=$1  
    local len=${#str}
    local i
    for (( i = 0; i < len + 4; ++i )); do
        printf '-'
    done
    printf "\n| $bold%s$normal |\n" "$str"
    for (( i = 0; i < len + 4; ++i )); do
        printf '-'
    done
    echo
}

printSep () {
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "+"
}

APIStart () {
    currentAPI=$1
    border "$1"
}

APIComplete () {
    echo ""
    echo "[Completed $currentAPI requests successfully]"
    echo ""
    printSep
}

operationStart () {
    currentOperation=$1
    echo ""
    #printSep
    echo "$bold$1$normal"
    #printSep
}
operationEnd () {
    if [ $? -ne 0 ]; then
        echo ""
        echo "Error trying to execute operation [$currentOperation] - $currentAPI"
        exit 1
    fi
       sleep $delay
}
# END utility functions


function usage {
    echo "A shell script that runs through the DBoM APIs."
    echo ""
    echo "usage: $calledByName [-hd] [-u gw-url]"
    echo "  -h          get help"
    echo "  -d delay    delay between steps in seconds [2s]"
    echo "  -u gw-url   specify url to gateway [http://localhost:3000]"
    printSep
}


while getopts ":hd:u:" opt; do
    case ${opt} in
        h ) usage
            exit 0
        ;;
        d )
            delay=${OPTARG}
        ;;
        u )
            APIAddress=${OPTARG}
        ;;
        \? ) echo "Invalid option: -$OPTARG" >&2
             echo ""
             usage
             exit 1
        ;;
    esac
done

echo "Using random asset IDs $assetIDOne and $assetIDTwo."

## START CREATE API TEST

APIStart "Create API"
operationStart "Create $assetIDOne on Channel C1"
curl -f --location --request POST "$APIAddress/api/v1/repo/DB1/chan/C1/asset/$assetIDOne" \
--header 'Content-Type: application/json' \
--data-raw '{
    "standardVersion": 1.0,
    "documentName": "Test Asset 01",
    "documentCreator": "DBoM Organisation",
    "documentCreatedDate": "2020-10-01T10:06:47+0000",
    "assetType": "HardwareComponent",
    "assetSubType": "SubType1",
    "assetManufacturer": "DBoM Organisation",
    "assetModelNumber": "ABCXYZ",
    "assetDescription": "A DBoM Asset",
    "assetMetadata": {  
        "aKey": "aValue"
    },
    "manufactureSignature": "UNSIGNED(TEST)"
}'
operationEnd

operationStart "Create  $assetIDTwo on Channel C1"
curl -f --location --request POST "$APIAddress/api/v1/repo/DB1/chan/C1/asset/$assetIDTwo" \
--header 'Content-Type: application/json' \
--data-raw '{
    "standardVersion": 1.0,
    "documentName": "Test Asset 02",
    "documentCreator": "DBoM Organisation",
    "documentCreatedDate": "2020-10-01T10:06:47+0000",
    "assetType": "HardwareComponent",
    "assetSubType": "SubType1",
    "assetManufacturer": "DBoM Organisation",
    "assetModelNumber": "ABCXYZ",
    "assetDescription": "A DBoM Asset",
    "assetMetadata": {  
        "aKey": "aValue"
    },
    "manufactureSignature": "UNSIGNED(TEST)"
}'
operationEnd
APIComplete

## END CREATE API TEST

## START RETRIEVE API TEST

APIStart "Retrieve API"
operationStart "Retrieve $assetIDOne from Channel C1"
curl -f --location --request GET "$APIAddress/api/v1/repo/DB1/chan/C1/asset/$assetIDOne" 
operationEnd

operationStart "Retrieve $assetIDTwo from Channel C1"
curl -f --location --request GET "$APIAddress/api/v1/repo/DB1/chan/C1/asset/$assetIDTwo" 
operationEnd
APIComplete

## END RETRIEVE API TEST

## START UPDATE API TEST

APIStart "Update API"
operationStart "Update $assetIDOne on Channel C1"
curl -f --location --request PUT "$APIAddress/api/v1/repo/DB1/chan/C1/asset/$assetIDOne" \
--header 'Content-Type: application/json' \
--data-raw '{
    "standardVersion": 1.0,
    "documentName": "Test Asset 01 Updated",
    "documentCreator": "DBoM Organisation",
    "documentCreatedDate": "2020-10-01T10:06:47+0000",
    "assetType": "HardwareComponent",
    "assetSubType": "SubType1",
    "assetManufacturer": "DBoM Organisation",
    "assetModelNumber": "ABCXYZ",
    "assetDescription": "A DBoM Asset",
    "assetMetadata": {  
        "aKey": "aValue"
    },
    "manufactureSignature": "UNSIGNED(TEST)"
}'
operationEnd
APIComplete

## END UPDATE API TEST


## START ATTACH AND DETACH API TESTS

APIStart "Attach and Detach APIs"
operationStart "Attaching $assetIDTwo [Parent] to $assetIDOne [Child]"
curl -f --location --request POST "$APIAddress/api/v1/repo/DB1/chan/C1/asset/$assetIDTwo/attach" \
--header 'Content-Type: application/json' \
--data-raw "{
   \"role\": \"SomeRole\",
   \"subRole\": \"SomeSubRole\",
   \"repoID\": \"DB1\",
   \"channelID\": \"C1\",
   \"assetID\": \"$assetIDOne\"
}"

operationEnd

operationStart "Detaching $assetIDTwo [Parent] from $assetIDOne [Child]"
curl -f --location --request POST "$APIAddress/api/v1/repo/DB1/chan/C1/asset/$assetIDTwo/detach" \
--header 'Content-Type: application/json' \
--data-raw "{
   \"repoID\": \"DB1\",
   \"channelID\": \"C1\",
   \"assetID\": \"$assetIDOne\"
}"

operationEnd

operationStart "Attaching $assetIDOne [Parent] to $assetIDTwo [Child]"
curl -f --location --request POST "$APIAddress/api/v1/repo/DB1/chan/C1/asset/$assetIDOne/attach" \
--header 'Content-Type: application/json' \
--data-raw "{
   \"role\": \"SomeRole\",
   \"subRole\": \"SomeSubRole\",
   \"repoID\": \"DB1\",
   \"channelID\": \"C1\",
   \"assetID\": \"$assetIDTwo\"
}"
operationEnd
APIComplete

## END ATTACH AND DETACH API TESTS

## START TRANSFER API TEST

APIStart "Transfer API"
operationStart "Transfer Asset $assetIDOne from Channel C1 to Channel C2"
curl --location --request POST "$APIAddress/api/v1/repo/DB1/chan/C1/asset/$assetIDOne/transfer" \
--header 'Content-Type: application/json' \
--data-raw "{
   \"transferDescription\": \"transferred\",
   \"repoID\": \"DB1\",
   \"channelID\": \"C2\",
   \"assetID\": \"$assetIDOne\"
}"
operationEnd
APIComplete

## END TRANSFER API TEST

## START AUDIT API TEST

APIStart "Audit API"
operationStart "Retrieve audit trail of $assetIDOne from Channel C1 (pre transfer)"
curl -f --location --request GET "$APIAddress/api/v1/repo/DB1/chan/C1/asset/$assetIDOne/trail" 
operationEnd
APIComplete

## END AUDIT API TEST

## START EXPORT API TEST

APIStart "Export API"
operationStart "Export asset graph from $assetIDOne, now transferred to C2"
curl -f --location --request GET "$APIAddress/api/v1/repo/DB1/chan/C2/asset/$assetIDOne/export" 
operationEnd
APIComplete

## END EXPORT API TEST

echo "All requests completed successfully!"

echo "Total execution time : $(($(date +%s)-starttime)) secs."