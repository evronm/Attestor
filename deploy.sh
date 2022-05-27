#!/bin/bash
export RPC_URL=http://127.0.0.1:8545
export KEY=5ee56d995e0f821a360bc0e09aeab8c0593a2e96e037e080c6f70154cf1858d5

export LIB_FILE='./src/Lib.sol'
export UTILS_ADDR=`forge create --legacy --rpc-url $RPC_URL --private-key $KEY $LIB_FILE:Utils|grep "Deployed to:"|sed "s/Deployed to: //"`
export UTILS_LIB="$LIB_FILE:Utils:${UTILS_ADDR}"
export ATTESTATIONS_ADDR=`forge create --legacy --rpc-url $RPC_URL --private-key $KEY $LIB_FILE:Attestations|grep "Deployed to:"|sed "s/Deployed to: //"`
export ATTESTATIONS_LIB="$LIB_FILE:Utils:${ATTESTATIONS_ADDR}"
export CONTRACT_ADDR=`forge create --legacy --rpc-url $RPC_URL --private-key $KEY ./src/Repository.sol:Repository --libraries $UTILS_LIB --libraries $KVS_LIB --libraries $STR_ADDRS_LIB --libraries $TAGS_LIB |grep "Deployed to:"|sed "s/Deployed to: //"`
