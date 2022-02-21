#!/bin/bash

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
