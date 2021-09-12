



echo "=========== create certificaters, keys, etcetera ============="

export PATH=${PWD}/../fabric-samples/bin:${PWD}:$PATH

# Delete existing artifacts
# First recursively give write permission before delete
chmod -R 0755 ./crypto-config
# Recursively delete the directories, ignoring non-existant
rm -rf ./crypto-config
rm -rf ./channel-artifacts/*

# Generate key material for organizations
#  --output="crypto-config"  The output directory in which to place artifacts
#  --config=CONFIG           The configuration template to use
# using the path added above, to fabric-samples/bin/cryptogen
cryptogen generate --config=./crypto-config.yaml --output=./crypto-config/
# copy crypto-config to all hosts!
# all relevant certificates with public keys must be distributed out of band

# COPY crypto-config TO OTHER HOST

echo "=========== create channel genesis block ============="

# first remove old block
rm -rf ./channel-artifacts/${CHANNEL_NAME}.block

# Location of configtx.yaml containing configtx.yaml
FABRIC_CFG_PATH=${PWD}

export CHANNEL_NAME=mychannel

# create new block using configtxgen
configtxgen -profile TwoOrgsApplicationGenesis -outputBlock ./channel-artifacts/${CHANNEL_NAME}.block -channelID $CHANNEL_NAME

# COPY THE CREATED GENESIS BLOCK TO OTHER HOST
# Orderer container needs the mychannel.block file to start up.
# With changes made to pc2.yaml, mychannel.block could be transferred after start instead, as long as it's there before osnadmin channel join

echo "=========== create and deploy ordering service ============="

# START CONTAINERS
# use e.g.: docker-compose -f pc1.yaml up -d
# or start containers individually with duócker run, e.g. for debugging

echo "=========== create channel ============="

# activate the channel by joining orderers

export FABRIC_CFG_PATH=${PWD}/../fabric-samples/config/
export PATH=${PWD}/../fabric-samples/bin:${PWD}:$PATH
export CORE_PEER_TLS_ENABLED=true
export CHANNEL_NAME=mychannel

export CHANNEL_CONFIG_BLOCK=./channel-artifacts/mychannel.block
export ORDERER_CA_TLS_CERT=./crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export ORDERER_ADMIN_TLS_SIGN_CERT=./crypto/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=./crypto/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

export ORDERER_ADMIN_LISTENADDRESS=orderer.example.com:7443

# list status
# docker exec cli osnadmin channel list -o $ORDERER_ADMIN_LISTENADDRESS --ca-file $ORDERER_CA_TLS_CERT --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY

# sleep 3

# activate the blockchain by joining orderers
docker exec cli osnadmin channel join --channelID $CHANNEL_NAME --config-block $CHANNEL_CONFIG_BLOCK -o $ORDERER_ADMIN_LISTENADDRESS --ca-file $ORDERER_CA_TLS_CERT --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY

sleep 3

export ORDERER_ADMIN_LISTENADDRESS=orderer2.example.com:8444

docker exec cli osnadmin channel join --channelID $CHANNEL_NAME --config-block $CHANNEL_CONFIG_BLOCK -o $ORDERER_ADMIN_LISTENADDRESS --ca-file $ORDERER_CA_TLS_CERT --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY

sleep 3

export ORDERER_ADMIN_LISTENADDRESS=orderer3.example.com:9443

docker exec cli osnadmin channel join --channelID $CHANNEL_NAME --config-block $CHANNEL_CONFIG_BLOCK -o $ORDERER_ADMIN_LISTENADDRESS --ca-file $ORDERER_CA_TLS_CERT --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY

sleep 3

# Confirm by listing status again
docker exec cli osnadmin channel list -o $ORDERER_ADMIN_LISTENADDRESS --ca-file $ORDERER_CA_TLS_CERT --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY

echo "=========== join peers to channel ============="

# Check not yet joined any channel
# docker exec peer0.org1.example.com peer channel list

# JOIN COMMANDS ARE RUN ON on hosts/peer nodes, not via CLI!
# Therefore, it must be run on the correct host, not all from host 1
# To run on the peer container, the mychannel.block file must be in their volume storage

# HOST 1
export PEER0_ORG1_CA=${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt

# select peer0org1
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

# Test not yet joined any channels
peer channel list
sleep 3

# Join p0o1 to mychannel
peer channel join -b $CHANNEL_CONFIG_BLOCK
sleep 3

# select peer1org1
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:8051

peer channel join -b $CHANNEL_CONFIG_BLOCK

# HOST 2
# Repeat these environment variables if not already added on host 2
export PATH=${PWD}/../fabric-samples/bin:${PWD}:$PATH
export CORE_PEER_TLS_ENABLED=true
export FABRIC_CFG_PATH=${PWD}/../fabric-samples/config/
export PEER0_ORG1_CA=${PWD}/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CHANNEL_NAME=mychannel
export CHANNEL_CONFIG_BLOCK=./channel-artifacts/mychannel.block


# Select peer0org2
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051

peer channel join -b $CHANNEL_CONFIG_BLOCK
sleep 3

# Select peer1org2
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:10051

peer channel join -b $CHANNEL_CONFIG_BLOCK

# test connection on each host
# confirm joined channel on each host
# CORE_PEER_ADDRESS=localhost:7051 peer channel getinfo -c mychannel
# CORE_PEER_ADDRESS=localhost:8051 peer channel getinfo -c mychannel
# CORE_PEER_ADDRESS=localhost:9051 peer channel getinfo -c mychannel
# CORE_PEER_ADDRESS=localhost:10051 peer channel getinfo -c mychannel
# OR
# docker exec peer0.org1.example.com peer channel getinfo -c mychannel
# docker exec peer1.org1.example.com peer channel getinfo -c mychannel
# docker exec peer0.org2.example.com peer channel getinfo -c mychannel
# docker exec peer1.org2.example.com peer channel getinfo -c mychannel


# docker exec peer1.org3.example.com peer channel getinfo -c testchannel


echo "=========== package chaincode for deployment on channel ============="

# DEPLOYMENT IS DONE VIA CLI ON HOST 1??

# check chaincode not installed, this should return an error, "chaincode mycc not found"
# CORE_PEER_ADDRESS=localhost:8051 peer chaincode query -C mychannel -n mycc -c '{"Args":["get","name"]}'

# IF RUNNING ON HOST:
# environment variables, assuming the sample chaincode asset transfer basic
# using language: javascript node. Maybe try using Java instead?
export CC_NAME=basic
export CC_SRC_PATH=../fabric-samples/asset-transfer-basic/chaincode-javascript
# export CC_SRC_LANGUAGE=node
export CC_RUNTIME_LANGUAGE=node
export CC_VERSION=1.0
# any more env vars missing? especially if starting from here in a new terminal!

# npm install is possibly needed?

# create packaged chaincode on the host
# creates the basic.tar.gz compressed file to deploy
# peer lifecycle chaincode package ${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CC_NAME}_${CC_VERSION}

# IF RUNNING VIA CLI:
# USE THIS CLI INSTEAD
docker exec cli peer lifecycle chaincode package basic.tar.gz --path ./ --lang node --label basic_1.0

echo "=========== install chaincode package ============="


# CLI:

# baic command:
# peer lifecycle chaincode install basic.tar.gz

# with added environment variables:

# peer0.org1.example.com
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051

docker exec -e CORE_PEER_TLS_ENABLED=true -e CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH} -e CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS} -e CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID} \
-e CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE} cli peer lifecycle chaincode install basic.tar.gz

sleep 3

# peer1.org1.example.com
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer1.org1.example.com:8051

docker exec -e CORE_PEER_TLS_ENABLED=true -e CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH} -e CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS} -e CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID} \
-e CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE} cli peer lifecycle chaincode install basic.tar.gz

sleep 3

# peer0.org2.example.com
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051

docker exec -e CORE_PEER_TLS_ENABLED=true -e CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH} -e CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS} -e CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID} \
-e CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE} cli peer lifecycle chaincode install basic.tar.gz

sleep 3

# peer1.org2.example.com
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=peer1.org2.example.com:10051

docker exec -e CORE_PEER_TLS_ENABLED=true -e CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH} -e CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS} -e CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID} \
-e CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE} cli peer lifecycle chaincode install basic.tar.gz

sleep 3



echo "=========== query installed chaincode ============="

# set globals for each peer
# then run to query:
# peer lifecycle chaincode queryinstalled

export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051

docker exec -e CORE_PEER_TLS_ENABLED=true -e CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH} -e CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS} -e CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID} \
-e CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE} cli peer lifecycle chaincode queryinstalled

sleep 3

export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=peer1.org2.example.com:10051

docker exec -e CORE_PEER_TLS_ENABLED=true -e CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH} -e CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS} -e CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID} \
-e CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE} cli peer lifecycle chaincode queryinstalled

sleep 3

# GET THE CORRECT PACKAGE ID'S FROM HERE
# e.g. Installed chaincodes on peer:
# Package ID: basic_1.0:742f05ca14811bc3c46ca3b72bedee60e0621164ff9d962d5212bde2294320ac, Label: basic_1.0


echo "=========== approve chaincode for each organization ============="

# APPROVE FOR each ORG at their respective anchor node (Peer0 of each org)

# base command: peer lifecycle chaincode approveformyorg

# 
export CC_NAME=basic
export CC_SRC_PATH=../fabric-samples/asset-transfer-basic/chaincode-javascript
export CC_RUNTIME_LANGUAGE=node
export CC_VERSION=1.0
export CC_SEQUENCE=1
export CHANNEL_NAME=mychannel

# USE CORRECT PACKAGE ID
# DOUBLE CHECK WITH QUERY COMMAND, OR GET DIRECTLY FROM INSTALLATION
export PACKAGE_ID=basic_1.0:2fdd6d3ae51ddf887111461634ccc5fd026b3377630f729d4efaaa26cf81656a

# peer lifecycle chaincode approveformyorg -o localhost:8050 --ordererTLSHostnameOverride orderer2.example.com --tls --cafile "$ORDERER_2_CA_TLS_CERT" --channelID "$CHANNEL_NAME" --name "$CC_NAME" --version "$CC_VERSION" --sequence "$CC_SEQUENCE"

# orderer.example.com
export ORDERER_CA_TLS_CERT=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# peer0.org1
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051

# approve for org 1
docker exec -e CORE_PEER_TLS_ENABLED=true -e CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH} -e CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS} -e CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID} \
-e CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE} cli peer lifecycle chaincode approveformyorg -o orderer2.example.com:8050 --ordererTLSHostnameOverride orderer2.example.com --tls \
--cafile "$ORDERER_CA_TLS_CERT" --channelID "$CHANNEL_NAME" --name "$CC_NAME" --version "$CC_VERSION" --sequence "$CC_SEQUENCE" --package-id ${PACKAGE_ID}

sleep 3

# orderer.example.com
export ORDERER_CA_TLS_CERT=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# peer0.org2
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051

# approve for org 2
docker exec -e CORE_PEER_TLS_ENABLED=true -e CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH} -e CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS} -e CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID} \
-e CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE} cli peer lifecycle chaincode approveformyorg -o orderer3.example.com:9050 --ordererTLSHostnameOverride orderer3.example.com --tls \
--cafile "$ORDERER_CA_TLS_CERT" --channelID "$CHANNEL_NAME" --name "$CC_NAME" --version "$CC_VERSION" --sequence "$CC_SEQUENCE" --package-id ${PACKAGE_ID}

sleep 3


# VALID at each org


echo "=========== check commit readiness ============="

# keep updating sequence with each new version if new are needed
# export CC_SEQUENCE=2

# base command:
# peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE}

export CC_NAME=basic
export CC_SRC_PATH=../fabric-samples/asset-transfer-basic/chaincode-javascript
export CC_RUNTIME_LANGUAGE=node
export CC_VERSION=1.0
export CC_SEQUENCE=1
export CHANNEL_NAME=mychannel

# peer0.org1
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051

# approve for org 1
docker exec -e CORE_PEER_TLS_ENABLED=true -e CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH} -e CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS} -e CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID} \
-e CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE} cli peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE}

# CONFIRMATION RETURN TRUE from both orgs
# These two steps may be done non-concurrently for more interesting results...


echo "=========== commit chaincode ============="

# base command:
# peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "$ORDERER_CA_TLS_CERT" --channelID "$CHANNEL_NAME" --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE}


export PEER0_ORG1_CA=./crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export PEER0_ORG2_CA=./crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt

docker exec -e CORE_PEER_TLS_ENABLED=true -e CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH} -e CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS} -e CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID} \
-e CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE} cli peer lifecycle chaincode commit -o orderer.example.com:7050 --ordererTLSHostnameOverride orderer.example.com --tls \
--cafile "$ORDERER_CA_TLS_CERT" --channelID "$CHANNEL_NAME" --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE} \
--peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles "$PEER0_ORG1_CA" --peerAddresses peer0.org2.example.com:9051 --tlsRootCertFiles "$PEER0_ORG2_CA"




echo "=========== check the commited chaincode ============="

# check via peer0 org 1
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
docker exec -e CORE_PEER_TLS_ENABLED=true -e CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH} -e CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS} -e CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID} \
-e CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE} cli peer lifecycle chaincode querycommitted --channelID mychannel --name basic

# check via peer0 org 2
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051

docker exec -e CORE_PEER_TLS_ENABLED=true -e CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH} -e CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS} -e CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID} \
-e CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE} cli peer lifecycle chaincode querycommitted --channelID mychannel --name basic




echo "=========== invoke chaincode ============="

# base command:
# peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "$ORDERER_CA" -C $CHANNEL_NAME -n ${CC_NAME} "${PEER_CONN_PARMS[@]}" --isInit -c ${fcn_call}

# the initial invoke, the function InitLedger
export CONSTRUCTOR_STRING='{"function":"InitLedger","Args":[]}'

# check via peer0 org 1
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051

# docker exec cli peer chaincode invoke -o orderer3.example.com:9050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n fabcar --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses peer0.org2.example.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"Args":["initLedger"]}'
docker exec -e CORE_PEER_TLS_ENABLED=true -e CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH} -e CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS} -e CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID} \
-e CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE} cli peer chaincode invoke -o orderer3.example.com:9050 --tls \
--cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n basic \
--peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
--peerAddresses peer0.org2.example.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
-c ${CONSTRUCTOR_STRING}

sleep 3

echo "=========== query chaincode ============="

# base command:
# peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'

export CC_NAME=basic
export CC_SRC_PATH=../fabric-samples/asset-transfer-basic/chaincode-javascript
export CC_RUNTIME_LANGUAGE=node
export CC_VERSION=1.0
export CC_SEQUENCE=1
export CHANNEL_NAME=mychannel

export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051


docker exec -e CORE_PEER_TLS_ENABLED=true -e CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH} -e CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS} \
-e CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID} -e CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE} \
cli peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"Args":["GetAllAssets"]}'


echo "=========== invoke other chaincode commands ============="


# Functions to invoke, from basic-asset-transfer:
# 1. InitLedger
#  -c '{"function":"InitLedger","Args":[]}'
# 2. CreateAsset
#  -c '{"function":"CreateAsset","Args":["asset8","color","size","owner-name","750"]}'
# 3. ReadAsset
#  -c '{"function":"ReadAsset","Args":["asset5"]}'
# 4. UpdateAsset
#  -c '{"function":"UpdateAsset","Args":["asset3","color","size","owner-name","750"]}'
# 5. DeleteAsset
#  -c '{"function":"DeleteAsset","Args":["asset5"]}'
# 6. AssetExists
#  -c '{"function":"AssetExists","Args":["asset5"]}'
# 7. TransferAsset
#  -c '{"function":"TransferAsset","Args":["asset8","new-owner-name"]}'
# 8. GetAllAssets, query instead of invoke?
#  -c '{"Args":["GetAllAssets"]}'



# https://hyperledger-fabric.readthedocs.io/en/latest/write_first_app.html






