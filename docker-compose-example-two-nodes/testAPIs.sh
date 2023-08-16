#!/bin/bash

# Node 1 metadata
echo "Getting Node 1 metadata..."
curl_result=$(curl --location 'http://localhost:3050/api/v2/nodes/node1/_metadata' \
--header 'Accept: application/json')
echo "Node 1 metadata response: $curl_result"
echo ""

# Node 2 metadata
echo "Getting Node 2 metadata..."
curl_result=$(curl --location 'http://localhost:3051/api/v2/nodes/node2/_metadata' \
--header 'Accept: application/json')
echo "Node 2 metadata response: $curl_result"
echo ""

# Create channels
echo "Creating channels..."
channel_data1='{
    "channelId": "channel1",
    "description": "Channel1 of Node 1 - Remote",
    "type": "TEST_CHANNEL",
    "notaries": [
        {
            "id": "ahgsduih",
            "type": "SIGNED",
            "config": {}
        }
    ]
}'
curl_result=$(curl --location 'http://localhost:3050/api/v2/nodes/node1.test.com/channels' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data "$channel_data1")
echo "Channel creation response for Node 1: $curl_result"
echo ""

channel_data2='{
    "channelId": "channel1",
    "description": "Channel1 of Node 2 - Remote",
    "type": "TEST_CHANNEL",
    "notaries": [
        {
            "id": "ahgsduih",
            "type": "SIGNED",
            "config": {}
        }
    ]
}'
curl_result=$(curl --location 'http://localhost:3051/api/v2/nodes/node2.test.com/channels' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data "$channel_data2")
echo "Channel creation response for Node 2: $curl_result"
echo ""

channel_data3='{
    "channelId": "channel2",
    "description": "Channel2 of Node 2 - Remote",
    "type": "TEST_CHANNEL",
    "notaries": [
        {
            "id": "ahgsduih",
            "type": "SIGNED",
            "config": {}
        }
    ]
}'
curl_result=$(curl --location 'http://localhost:3051/api/v2/nodes/node2.test.com/channels' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data "$channel_data3")
echo "Channel creation response for Node 2 (Channel 2): $curl_result"
echo ""

# Adding assets
echo "Adding assets..."
asset_data1='{
    "standardVersion": 1,
    "schemaUrl": "https://raw.githubusercontent.com/spdx/spdx-spec/development/v2.3.1/schemas/spdx-schema.json",
    "createdAt": "2023-05-15T12:34:56Z",
    "modifiedAt": "2023-05-15T12:34:56Z",
    "notarizations": [
        {
            "notaryId": "not1",
            "notaryMeta": {}
        }
    ],
    "links": [
        {
            "assetUri": "string",
            "type": "asset",
            "comment": "example2",
            "id": "link1"
        }
    ],
    "signatures": [
        {
            "hashType": "SHA256",
            "signType": "type1",
            "signMeta": {
                "authority": "user1",
                "keyId": "12345",
                "sign": "asdfbiuvagebvbayerfasdfbsjasdfdliufgalsi"
            }
        }
    ],
    "body": {}
}'
curl_result=$(curl --location 'http://localhost:3050/api/v2/nodes/node1.test.com/channels/channel1/assets/asset1' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data "$asset_data1")
echo "Asset addition response for Node 1 (Channel 1, Asset 1): $curl_result"
echo ""

asset_data2='{
    "standardVersion": 1,
    "schemaUrl": "https://raw.githubusercontent.com/spdx/spdx-spec/development/v2.3.1/schemas/spdx-schema.json",
    "createdAt": "2023-05-15T12:34:56Z",
    "modifiedAt": "2023-05-15T12:34:56Z",
    "notarizations": [
        {
            "notaryId": "not1",
            "notaryMeta": {}
        }
    ],
    "links": [
        {
            "assetUri": "string",
            "type": "asset",
            "comment": "example2",
            "id": "link1"
        }
    ],
    "signatures": [
        {
            "hashType": "SHA256",
            "signType": "type1",
            "signMeta": {
                "authority": "user1",
                "keyId": "12345",
                "sign": "asdfbiuvagebvbayerfasdfbsjasdfdliufgalsi"
            }
        }
    ],
    "body": {}
}'
curl_result=$(curl --location 'http://localhost:3051/api/v2/nodes/node2.test.com/channels/channel1/assets/asset1' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data "$asset_data2")
echo "Asset addition response for Node 2 (Channel 1, Asset 1): $curl_result"
echo ""

asset_data3='{
    "standardVersion": 1,
    "schemaUrl": "https://raw.githubusercontent.com/spdx/spdx-spec/development/v2.3.1/schemas/spdx-schema.json",
    "createdAt": "2023-05-15T12:34:56Z",
    "modifiedAt": "2023-05-15T12:34:56Z",
    "notarizations": [
        {
            "notaryId": "not1",
            "notaryMeta": {}
        }
    ],
    "links": [
        {
            "assetUri": "string",
            "type": "asset",
            "comment": "example2",
            "id": "link1"
        }
    ],
    "signatures": [
        {
            "hashType": "SHA256",
            "signType": "type1",
            "signMeta": {
                "authority": "user1",
                "keyId": "12345",
                "sign": "asdfbiuvagebvbayerfasdfbsjasdfdliufgalsi"
            }
        }
    ],
    "body": {}
}'
curl_result=$(curl --location 'http://localhost:3051/api/v2/nodes/node2.test.com/channels/channel2/assets/asset1' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data "$asset_data3")
echo "Asset addition response for Node 2 (Channel 2, Asset 1): $curl_result"
