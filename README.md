# Virtual Machine Health Check Script

## Overview

This repository contains a Bash script designed to analyze the health of an AWS Ubuntu virtual machine. The script evaluates system health based on CPU, memory, and disk space utilization. If any of these resources exceed 60% usage, the system is considered **"Not Healthy"**; otherwise, it is deemed **"Healthy"**.

## Features

- Checks CPU utilization using the `top` command.
- Monitors memory usage with the `free` command.
- Examines disk space using the `df` command.
- Supports an `explain` argument to provide a detailed summary of system health.
- Logs system health data (**Advanced version only**).

## Installation

Clone this repository to your local machine:

```bash
git clone https://github.com/your-username/vm-health-check.git
cd vm-health-check
chmod +x health_check.sh
```

## Usage
Run the basic health check:
```bash
./health_check.sh
```
Run with the explain argument to get a detailed breakdown:
```bash
./health_check.sh explain
```

## Output
### Healthy System Example:
```yaml
System Health: Healthy
CPU Usage: 45%
Memory Usage: 50%
Disk Usage: 40%
```

### Not Healthy System Example:
```yaml
System Health: Not Healthy
CPU Usage: 75%
Memory Usage: 65%
Disk Usage: 50%
```

### Explain Mode Example:
```pgsql
System Health: Not Healthy
CPU Usage: 75% (Exceeded 60% threshold)
Memory Usage: 65% (Exceeded 60% threshold)
Disk Usage: 50% (Within limits)
```
