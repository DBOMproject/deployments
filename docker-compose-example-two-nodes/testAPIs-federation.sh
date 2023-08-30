#!/bin/bash

# Function to pretty print JSON using jq
pretty_print_json() {
    echo "$1" | perl -MJSON -e 'print JSON->new->pretty->encode(decode_json(join "", <>))'
}

# Function to display a separator in logs
log_separator() {
    echo "------------------------------------------------------------------------------------------------------"
}

# Node 1 metadata
echo "Getting Node 1 metadata..."
curl_result=$(curl --location 'http://localhost:3050/api/v2/nodes/node1/_metadata' \
--header 'Accept: application/json')
echo ""
echo "Node 1 metadata response:"
pretty_print_json "$curl_result"
echo ""
log_separator
echo ""

# Node 2 metadata
echo "Getting Node 2 metadata..."
curl_result=$(curl --location 'http://localhost:3051/api/v2/nodes/node2/_metadata' \
--header 'Accept: application/json')
echo ""
echo "Node 2 metadata response:"
pretty_print_json "$curl_result"
echo ""
log_separator
echo ""


# Access the specified channel
echo "Accessing the channel1 - before federation"
channel_data=$(curl --location 'http://localhost:3050/api/v2/nodes/node2.test.com/channels/channel1' \
--header 'Accept: application/json')
echo ""
echo "Channel data response:" 
pretty_print_json "$channel_data"
echo ""
log_separator
echo ""

# Get all federation requests
echo "Getting all federation requests..."
federation_requests=$(curl --location 'http://localhost:3051/api/v2/federation/requests/all')
echo ""
echo "Federation requests response:"
pretty_print_json "$federation_requests"
echo ""
log_separator
echo ""

# Ask for user input (stop here to enter the request ID)
echo "Please enter the federation request ID to proceed:"
read request_id

# Accept the specified federation request
echo "Accepting the specified federation request..."
accept_request_data='{
    "type": "ACCEPT"
}'
curl_result=$(curl --location "http://localhost:3051/api/v2/federation/requests/$request_id/accept" \
--header 'Content-Type: application/json' \
--data "$accept_request_data")
echo ""
echo "Federation request acceptance response:" 
pretty_print_json "$curl_result"
echo ""
log_separator
echo ""


# Access the specified channel
echo "Accessing the channel1 after federation"
channel_data=$(curl --location 'http://localhost:3050/api/v2/nodes/node2.test.com/channels/channel1' \
--header 'Accept: application/json')
echo ""
echo "Channel data response:" 
pretty_print_json "$channel_data"
echo ""
log_separator
echo ""
