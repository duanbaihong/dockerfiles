#!/usr/bin/dumb-init /bin/bash

/bin/peer-finder -on-start=/bin/on-start.sh -on-change=/bin/on-change.sh -service=${SERVICE_NAME}