


echo "=========== create and deploy ordering service ============="

# START CONTAINERS
# use e.g.: docker-compose -f pc1.yaml up -d
# or start containers individually with duócker run, e.g. for debugging

cd ~/fabric/B*
docker-compose -f pc1.yaml up -d

cd ~/fabric/B*
docker-compose -f pc2.yaml up -d






echo "=========== create channel and join host 1 ============="

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











echo "=========== join host 2 ============="


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










echo "=========== install chaincode etc etc ============="


# CLI:

# basic command:
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

echo "=========== commit chaincode ============="

# base command:
# peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "$ORDERER_CA_TLS_CERT" --channelID "$CHANNEL_NAME" --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE}


export PEER0_ORG1_CA=./crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export PEER0_ORG2_CA=./crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt

docker exec -e CORE_PEER_TLS_ENABLED=true -e CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH} -e CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS} -e CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID} \
-e CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE} cli peer lifecycle chaincode commit -o orderer.example.com:7050 --ordererTLSHostnameOverride orderer.example.com --tls \
--cafile "$ORDERER_CA_TLS_CERT" --channelID "$CHANNEL_NAME" --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE} \
--peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles "$PEER0_ORG1_CA" --peerAddresses peer0.org2.example.com:9051 --tlsRootCertFiles "$PEER0_ORG2_CA"


sleep 3


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









#########################
# Caliper
#########################

cd ../c*

# Set configurations correctly!!!!!!!
sudo rm be*/benchmark-config-batch.yaml
sudo nano be*/benchmark-config-batch.yaml

docker run \
    -v /home/MsUser/fabric/caliper-workspace:/hyperledger/caliper/workspace \
    -v /home/MsUser/fabric/BasicNetwork-my-version/crypto-config/:/hyperledger/caliper/crypto-config \
    --name new_caliper --network="basic-network" -p 7090:7090 --rm -it runelb/ubuntu_caliper

# on container:
cd hy*/ca*/wo*

npx caliper launch manager --caliper-workspace ./ --caliper-networkconfig networks/network-config.yaml \
--caliper-benchconfig benchmarks/benchmark-config-batch.yaml --caliper-flow-only-test --caliper-fabric-gateway-enabled > log.txt


# ctrl + d to close the container

# on VM:

# PROCESS OUTPUT TX
# find switchover to next round, identify the dividing line:
grep -n 'finished Round#0' log.txt
# result is: 398, before belongs to round#0, reading and after belongs to round#1, writing
grep -n 'finished Round#1' log.txt

# result is: 398, before belongs to round#0, reading and after belongs to round#1, writing
grep -n 'finished Round#2' log.txt
# result is: 398, before belongs to round#0, reading and after belongs to round#1, writing
grep -n 'finished Round#3' log.txt
# result is: 398, before belongs to round#0, reading and after belongs to round#1, writing
grep -n 'finished Round#4' log.txt
# result is: 398, before belongs to round#0, reading and after belongs to round#1, writing

# put all transactions into separate files, divided at the correct dividing line
grep -n 'TX' log.txt | awk -F ":" '$1 < 30273' > round0_TX.txt

grep -n 'TX' log.txt | awk -F ":" '$1 > 30273' | awk -F ":" '70526 > $1' > round1_TX.txt

grep -n 'TX' log.txt | awk -F ":" '$1 > 70526' | awk -F ":" '120848 > $1' > round2_TX.txt

grep -n 'TX' log.txt | awk -F ":" '$1 > 120848' | awk -F ":" '204255 > $1' > round3_TX.txt

grep -n 'TX' log.txt | awk -F ":" '$1 > 204255' > round4_TX.txt



# redo rounds 3 and 4!
# i.e. redo 30 and 35 tps

#####
grep -n 'TX' log.txt > round3_TX.txt

#####
grep -n 'TX' log.txt > round4_TX.txt


# remove superfluous text, save only transaction times/latency
sed -e "s/.*took //g" -i.backup round0_TX.txt
sed -e "s/ms.*//g" -i round0_TX.txt
sed -e "s/.*took //g" -i.backup round1_TX.txt
sed -e "s/ms.*//g" -i round1_TX.txt
sed -e "s/.*took //g" -i.backup round2_TX.txt
sed -e "s/ms.*//g" -i round2_TX.txt

sed -e "s/.*took //g" -i.backup round3_TX.txt
sed -e "s/ms.*//g" -i round3_TX.txt

sed -e "s/.*took //g" -i.backup round4_TX.txt
sed -e "s/ms.*//g" -i round4_TX.txt


# REPEAT THE SAME FOR INPUTS

# grep -n 'INPUTGEN' log.txt > round_INPUT.txt

# remove superfluous text
# sed -e "s/.*INPUTGEN //g" -i.backup round_INPUT.txt




# on local:
IP_ADDR=52.169.85.165

scp -i ~/.ssh/MsVM7_key.pem MsUser@$IP_ADDR:~/fabric/caliper-workspace/round0_TX.txt ~/caliper_outputs/exp_throughput_15.txt

scp -i ~/.ssh/MsVM7_key.pem MsUser@$IP_ADDR:~/fabric/caliper-workspace/round1_TX.txt ~/caliper_outputs/exp_throughput_20.txt

scp -i ~/.ssh/MsVM7_key.pem MsUser@$IP_ADDR:~/fabric/caliper-workspace/round2_TX.txt ~/caliper_outputs/exp_throughput_25.txt



scp -i ~/.ssh/MsVM7_key.pem MsUser@$IP_ADDR:~/fabric/caliper-workspace/round3_TX.txt ~/caliper_outputs/exp_throughput_30.txt



scp -i ~/.ssh/MsVM7_key.pem MsUser@$IP_ADDR:~/fabric/caliper-workspace/round4_TX.txt ~/caliper_outputs/exp_throughput_35.txt

scp -i ~/.ssh/MsVM7_key.pem MsUser@$IP_ADDR:~/fabric/caliper-workspace/log.txt ~/caliper_outputs/exp2_throughput_full_log.txt

# scp -i ~/.ssh/MsVM7_key.pem MsUser@$IP_ADDR:~/fabric/caliper-workspace/round_INPUT.txt ~/caliper_outputs/exp_batch_new_inputs_m100_s0_write.txt

cp -r caliper_outputs /mnt/c/Users/rune/Documents/BTH/thesis/hyperledger/BasicNetwork-my-version/results/



# close down to restart
cd ../B*
docker-compose -f pc1.yaml down


docker-compose -f pc2.yaml down

# regularly run this to make space!
# docker system prune --all --force --volumes



# början, strax innan kl 17, 20/7/21
# 100, klar 17:18
# fixed rate, 17:26 start, klar 17:44, 18 min
# 1, 17:52 till 18:10?
# 0, 18:17 till 18:34
# 50, klar 21:05
# 10, start 21:12 end 21:32
# fixed-load, 21:38 till 21:56?
# 5, 22:


# gör en ordning:
# 1,      2,  3,  4, 5, 6,    7,          8
# 100,    50, 10, 5, 1, 0     fixed rate, fixed load

# rng: 1,   7,             5, 6,        2,    3,  8,          4
# dvs: 100, fixed rate,    1, 0,        50,   10, fixed load, 5



# 1,    100,    fixed rate,     0

# effect from network
# consistency/stability, look at previous research
# try overloading a VM while testing

