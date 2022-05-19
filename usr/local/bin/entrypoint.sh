#!/usr/bin/bash
if [ "$1" == "shuttle" ]; then
    source /etc/estuary-shuttle/log.env
    /usr/local/bin/estuary-shuttle --config=/etc/estuary-shuttle/config.json
else
    source /etc/estuary/log.env
    /usr/local/bin/estuary --config=/etc/estuary/config.json
fi