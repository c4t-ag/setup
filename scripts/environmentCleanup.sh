#!/bin/bash

#####
# This script can be used in an existing environment where the genesis block shall be recreated after changes to the software has been made.
# Assumption is that the config is named config_test.toml and the script is executed in the directory where the config and the genesis
# block is located (named: testnet.g)
#####

# Currently the validator public key is not needed for the env cleanup
#PUBLICKEY=`cat validator-public.key`
CONFIGFILE=config_test.toml

if [ ! -f "$CONFIGFILE" ] ; then
	echo "The configuration file $CONFIGFILE has not been found. No cleanup possible - We need to setup from scratch here!"
	exit 1
fi

echo "#### Removing testnet data from filesystem"
rm -rf ~/.opera/testnet/chaindata
rm -rf ~/.opera/testnet/go-opera
rm -rf ~/.opera/testnet/history

echo "#### Cleanup of GraphQL server + db"
killall apiserver
mongo chain4travel --eval "printjson(db.dropDatabase())"

echo "#### Creating new genesis block"
opera --config "$CONFIGFILE" creategenesis testnet.g

echo "#### All done"
