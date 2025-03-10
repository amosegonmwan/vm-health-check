#!/bin/bash

# Get CPU utilization percentage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')  # 100 - idle%

# Get Memory usage percentage
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_USAGE=$(echo "scale=2; ($MEM_USED/$MEM_TOTAL)*100" | bc)

# Get Disk usage percentage
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

# Check if any parameter exceeds 60%
HEALTHY=true
if (( $(echo "$CPU_USAGE > 60" | bc -l) )) || (( $(echo "$MEM_USAGE > 60" | bc -l) )) || (( $DISK_USAGE > 60 )); then
    HEALTHY=false
fi

# Print health status
if [ "$1" == "explain" ]; then
    echo "System Health Check:"
    echo "--------------------"
    echo "CPU Usage: $CPU_USAGE% (Threshold: 60%)"
    echo "Memory Usage: $MEM_USAGE% (Threshold: 60%)"
    echo "Disk Usage: $DISK_USAGE% (Threshold: 60%)"
    echo ""

    if [ "$HEALTHY" == "true" ]; then
        echo "✅ System is HEALTHY - All resource usage is below 60%."
    else
        echo "❌ System is NOT HEALTHY - One or more resources exceed 60% utilization."
    fi
else
    if [ "$HEALTHY" == "true" ]; then
        echo "✅ HEALTHY"
    else
        echo "❌ NOT HEALTHY"
    fi
fi
