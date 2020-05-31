#!/bin/bash
# Author: Dominik Fuchss (develop@fuchss.org)
# Entry point for the simple docker file. 

# Checl for config. Iff none exist copy sample and stop container.
if [ ! -f /config/server.conf ]; then
	echo "Please config server! Therfore, create a server.conf in the config folder. A sample is supplied."
	cp /src/nextcloud-hpb/server.conf.in /config/server.conf.in
	exit 1
fi

# Kill procs of old instances (should never become necessary)
if pgrep nats-server; then pkill nats-server; fi
nats-server&

if pgrep signaling; then pkill signalingr; fi

# Start the signaling server
/src/nextcloud-hpb/bin/signaling -config /config/server.conf
