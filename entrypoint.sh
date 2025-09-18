#!/bin/bash

export MULLVAD_SETTINGS_DIR=/config

# Start the daemon
mullvad-daemon &
sleep 5

# Configure and Login to Mullvad
mullvad dns set default
mullvad auto-connect set on
mullvad account login $MULLVAD_ACCOUNT_TOKEN

# Connect to VPN
mullvad connect

# Keep the container running
tail -f /dev/null