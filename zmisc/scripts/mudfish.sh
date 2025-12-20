#!/bin/bash

# Place this file at ~/.local/bin/
# Make it executable with:
# chmod +x ~/.local/bin/mudfish.sh
# Run it with mudfish.sh from anywhere

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

MUDFISH_PATH="/opt/mudfish/6.1.3/bin/mudrun-headless"

echo -e "${BLUE}Mudfish VPN Launcher v1.0${NC}"
echo -e "Initializing connection manager..."
echo -n "Checking Mudfish installation... "
if [ ! -f "$MUDFISH_PATH" ]; then
    echo -e "${RED}FAILED${NC}"
    echo -e "${RED}Error: Mudfish binary not found at $MUDFISH_PATH${NC}"
    echo -e "Please verify installation path and try again"
    exit 1
fi
echo -e "${GREEN}OK${NC}"
echo "Loading Mudfish configuration..."
echo -n "Preparing VPN service"
for i in {1..3}; do
    sleep 0.2
    echo -n "."
done
echo -e " ${GREEN}done${NC}"
echo "Establishing secure connection parameters..."
echo -e "${YELLOW}Note: Web interface available at http://127.0.0.1:8282/${NC}"
echo "Requesting elevated privileges..."
echo -e "${YELLOW}Starting Mudfish daemon...${NC}"
sudo "$MUDFISH_PATH" | zen-browser --new-window "http://127.0.0.1:8282/"
