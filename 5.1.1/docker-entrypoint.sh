#!/bin/bash

set -e

CONFIG=""
COMMAND="$@"

while [[ $# > 1 ]]
do
key="$1"

case $key in
    -c)
    	CONFIG="$2"
    	shift # past argument
    ;;
    *)
	# other or unknown option
    ;;
esac
shift # past argument or value
done

if [ "$CONFIG" = '' ]; then
	CONFIG=/filebeat.yml
fi

# Add filebeat as command if needed
if [ "${COMMAND:0:1}" = '-' ]; then
	COMMAND="filebeat $COMMAND"
fi
echo "$COMMAND"
eval "$COMMAND"
