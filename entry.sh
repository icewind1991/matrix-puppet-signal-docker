#!/bin/sh

cd /matrix-puppet-signal

CMD=$1
shift

if [ "$CMD" = "link" ]; then
    npm run link
    exit
fi

if [ "$CMD" = "clean" ]; then
    npm run link
    exit
fi

if [ "$CMD" = "registration" ]; then
    echo "reg $@"
    node /matrix-puppet-signal/index.js -r -u $@
    cat signal-registration.yaml
    exit
fi

node /matrix-puppet-signal/index.js
