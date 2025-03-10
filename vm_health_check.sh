#!/bin/bash

LOG_FILE="/var/log/vm_health.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

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
HEALTH_MSG=""

if (( $(echo "$CPU_USAGE > 60" | bc -l) )); then
    HEALTHY=false
    HEALTH_MSG+="High CPU Usage: $CPU_USAGE% | "
fi
if (( $(echo "$MEM_USAGE > 60" | bc -l) )); then
    HEALTHY=false
    HEALTH_MSG+="High Memory Usage: $MEM_USAGE% | "
fi
if (( $DISK_USAGE > 60 )); then
    HEALTHY=false
    HEALTH_MSG+="High Disk Usage: $DISK_USAGE% | "
fi

# Log the status
if [ "$HEALTHY" == "true" ]; then
    STATUS="HEALTHY"
    echo "$TIMESTAMP - ✅ HEALTHY - CPU: $CPU_USAGE%, Memory: $MEM_USAGE%, Disk: $DISK_USAGE%" | tee -a $LOG_FILE
else
    STATUS="NOT HEALTHY"
    echo "$TIMESTAMP - ❌ NOT HEALTHY - $HEALTH_MSG" | tee -a $LOG_FILE
fi

# Print health status
if [ "$1" == "explain" ]; then
    echo "System Health Check ($TIMESTAMP):"
    echo "---------------------------------"
    echo "CPU Usage: $CPU_USAGE% (Threshold: 60%)"
    echo "Memory Usage: $MEM_USAGE% (Threshold: 60%)"
    echo "Disk Usage: $DISK_USAGE% (Threshold: 60%)"
    echo ""

    if [ "$HEALTHY" == "true" ]; then
        echo "✅ System is HEALTHY - All resource usage is below 60%."
    else
        echo "❌ System is NOT HEALTHY - $HEALTH_MSG"
    fi
else
    echo "[$TIMESTAMP] $STATUS"
fi
