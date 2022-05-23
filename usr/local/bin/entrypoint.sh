#!/usr/bin/bash
if [ "$1" == "shuttle" ]; then
    source /etc/estuary-shuttle/service.env
    /usr/local/bin/estuary-shuttle --config=/etc/estuary-shuttle/config.json
elif [ "$1" == "init" ]; then
    source /etc/estuary/service.env
    # Get the location of the peer key file (which we consider to be the 'node identity')
    PEER_KEY=`jq -r '.NodeConfig.Libp2pKeyFile' /etc/estuary/config.json`
    # Only proceed with intialization if the peer key file does not exist
    if [ ! -f "$PEER_KEY" ]; then
        /usr/local/bin/estuary --config=/etc/estuary/config.json \
            --hostname=${ESTUARY_HOSTNAME} \
            --announce=${ESTUARY_ANNOUNCE} \
            configure
        /usr/local/bin/estuary --config=/etc/estuary/config.json setup | tee /tmp/init.log  
        TOKEN=`sed -n '/Auth Token:/ s/.*\: *//p' /tmp/init.log`
        # Store the admin token for the purpose of initializing a shuttle
        echo "TOKEN=\"$TOKEN\"" >> /etc/estuary-shuttle/service.env
    else
        echo "Skipped initialization because ${PEER_KEY} exists"
    fi
elif [ "$1" == "register" ]; then
    source /etc/estuary-shuttle/service.env
    # Get the shuttle handle (which we consider to be the 'node identity')
    SHUTTLE_HANDLE=`jq -r '.EstuaryConfig.Handle' /etc/estuary-shuttle/config.json`
    # Only proceed with initialization if we don't already have a shuttle handle
    if [ -z "$SHUTTLE_HANDLE" ]; then
        echo token: [$TOKEN]
        curl -o /tmp/reg.json -H "Authorization: Bearer $TOKEN" -X POST estuary:3004/admin/shuttle/init 
        SHUTTLE_HANDLE=`jq -r '.handle' /tmp/reg.json`
        SHUTTLE_TOKEN=`jq -r '.token' /tmp/reg.json`
        # Update the config with the registration details
        /usr/local/bin/estuary-shuttle --config=/etc/estuary-shuttle/config.json \
            --host="$SHUTTLE_HOSTNAME" \
            --handle="$SHUTTLE_HANDLE" \
            --auth-token="$SHUTTLE_TOKEN" \
            --announce-addr="$SHUTTLE_ANNOUNCE" \
            --estuary-api="$ESTUARY_HOSTNAME" \
            $SHUTTLE_OPTS \
            configure
        # Strip the admin token from the service.env file - we don't need it any more
        sed -i '/TOKEN=/d' /etc/estuary-shuttle/service.env
    else
        echo "Skipped shuttle registration - there is already a handle ${SHUTTLE_HANDLE} in the config file"
    fi
else
    source /etc/estuary/service.env
    /usr/local/bin/estuary --config=/etc/estuary/config.json
fi