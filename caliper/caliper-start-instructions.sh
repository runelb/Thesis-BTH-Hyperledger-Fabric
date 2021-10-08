
# ON the host where you want to run caliper:

# create caliper-workspace next to the other directories
# put configuration files in sub-directories
caliper-workspace
/networks/network-config.yaml    /networks/caliper-org1-connection-profile.yml    /benchmarks/benchmark-config.yaml    /workload/readAsset.js   /workload/writeAsset.js  /caliper.yaml

# if not working install hyperledger caliper in that network according to official instructions
# installation should not be needed because of docker image


# adjust the following command to point to the right volume directories
docker run \
    -v /home/MsUser/fabric/caliper-workspace:/hyperledger/caliper/workspace \
    -v /home/MsUser/fabric/BasicNetwork-my-version/crypto-config/:/hyperledger/caliper/crypto-config \
    --name new_caliper --network="basic-network" -p 7090:7090 --rm -it runelb/ubuntu_caliper

cd hy*/ca*/wo*

npx caliper launch manager --caliper-workspace ./ --caliper-networkconfig networks/network-config.yaml \
--caliper-benchconfig benchmarks/benchmark-config.yaml --caliper-flow-only-test --caliper-fabric-gateway-enabled
