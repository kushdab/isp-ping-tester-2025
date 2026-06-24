#!/bin/bash

# ISP Ping Tester 2025
# A utility to benchmark latency and packet loss for gaming and streaming.

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
COUNT=10
INTERVAL=0.2
LOG_FILE="ping_results_$(date +%Y%m%d).csv"

# Target Servers
declare -A TARGETS=(
    ["Cloudflare (General)"]="1.1.1.1"
    ["Google DNS (General)"]="8.8.8.8"
    ["Riot Games (NA-West)"]="162.249.72.1"
    ["Valve/Steam (US-East)"]="eat.valve.net"
    ["Blizzard (US)"]="24.105.30.129"
    ["Netflix (Streaming)"]="www.netflix.com"
    ["Twitch (Streaming)"]="twitch.tv"
    ["YouTube (Streaming)"]="googlevideo.com"
)

# Initialize Log File if not exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Timestamp,Target,IP,PacketLoss,Min,Avg,Max,Mdev" > "$LOG_FILE"
fi

print_header() {
    echo -e "${BLUE}======================================================================${NC}"
    echo -e "${YELLOW}ISP Ping Tester 2025 - Benchmark Started at $(date)${NC}"
    echo -e "${BLUE}======================================================================${NC}"
    printf "%-25s | %-10s | %-10s | %-10s\n" "Target" "Loss%" "Avg Lat" "Jitter"
    echo "----------------------------------------------------------------------"
}

run_benchmark() {
    for NAME in "${!TARGETS[@]}"; do
        HOST="${TARGETS[$NAME]}"
        
        # Execute ping and capture output
        RESULT=$(ping -c "$COUNT" -i "$INTERVAL" -n "$HOST" 2>/dev/null)
        
        if [ $? -ne 0 ]; then
            printf "%-25s | ${RED}%-10s${NC} | %-10s | %-10s\n" "$NAME" "FAILED" "N/A" "N/A"
            continue
        fi

        # Parse values
        LOSS=$(echo "$RESULT" | grep -oP '\d+(?=% packet loss)')
        STATS=$(echo "$RESULT" | tail -1 | awk '{print $4}' | sed 's/\// /g')
        read -r MIN AVG MAX MDEV <<< "$STATS"

        # Color coding for latency
        if (( $(echo "$AVG < 50" | bc -l) )); then COLOR=$GREEN
        elif (( $(echo "$AVG < 100" | bc -l) )); then COLOR=$YELLOW
        else COLOR=$RED; fi

        # Print to Console
        printf "%-25s | %-10s | ${COLOR}%-7s ms${NC} | %-10s\n" "$NAME" "$LOSS%" "$AVG" "$MDEV"

        # Save to CSV
        echo "$(date +%H:%M:%S),$NAME,$HOST,$LOSS,$MIN,$AVG,$MAX,$MDEV" >> "$LOG_FILE"
    done
}

main() {
    print_header
    run_benchmark
    echo "----------------------------------------------------------------------"
    echo -e "Results saved to: ${GREEN}$LOG_FILE${NC}"
    echo -e "${BLUE}Benchmark Complete.${NC}"
}

main