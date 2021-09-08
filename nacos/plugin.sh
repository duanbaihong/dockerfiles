#!/bin/bash
PEER_FINDER_DIR="${NACOS_PREFIX}/nacos/plugins/peer-finder"

cd ${PEER_FINDER_DIR} && ./peer-finder -on-start=${PEER_FINDER_DIR}/on-start.sh -on-change=${PEER_FINDER_DIR}/on-change.sh -service=${SERVICE_NAME} || exit &