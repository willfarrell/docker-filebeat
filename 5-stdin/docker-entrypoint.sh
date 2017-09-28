#!/usr/bin/env sh
set -e

DOCKER_SOCK=/tmp/docker.sock

if [ "$1" = 'filebeat' ] && [ -e ${DOCKER_SOCK} ]; then

  CONTAINERS_DIR=/tmp/containers
  PIPE_DIR=/tmp/pipe

  # https://docs.docker.com/engine/api/v1.25/
  processLogs() {
    local CONTAINER=$1
    touch "$CONTAINERS_DIR/$CONTAINER"
    CONTAINER_NAME=$(curl --no-buffer -s -XGET --unix-socket ${DOCKER_SOCK} http://localhost/containers/$CONTAINER/json | jq -r .Name | sed 's@/@@')
    echo "Processing $CONTAINER_NAME ..."
    # cut -c1-8 --complement
    curl --no-buffer -s -XGET --unix-socket ${DOCKER_SOCK} "http://localhost/containers/$CONTAINER/logs?stderr=1&stdout=1&tail=1&follow=1" | tr -d '\000' | sed "s;^[^[:print:]];[$CONTAINER_NAME] ;" > $PIPE_DIR
    echo "Disconnected from $CONTAINER_NAME."
    rm "$CONTAINERS_DIR/$CONTAINER"
  }

  rm -rf "$CONTAINERS_DIR"
  rm -rf "$PIPE_DIR"
  mkdir -p "$CONTAINERS_DIR"
  mkfifo -m a=rw "$PIPE_DIR"

  echo "Initializing Filebeat ..."
  tail -f $PIPE_DIR | exec "$@" &

  echo "Monitor Containers ..."

  # Set container selector
  if [ "$STDIN_CONTAINER_LABEL" == "all" ]; then
    selector() {
      jq -r .[].Id
    }
  else
    selector() {
      jq -r '.[] | select(.Labels["'${STDIN_CONTAINER_LABEL:=filebeat.stdin}'"] == "true") | .Id'
    }
  fi

  while true; do
    CONTAINERS=$(curl --no-buffer -s -XGET --unix-socket ${DOCKER_SOCK} http://localhost/containers/json | selector)
    for CONTAINER in $CONTAINERS; do
      if ! ls $CONTAINERS_DIR | grep -q $CONTAINER; then
        processLogs $CONTAINER &
      fi
    done
    sleep 5
  done

else
  exec "$@"
fi
