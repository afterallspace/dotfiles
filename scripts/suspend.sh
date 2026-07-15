#!/bin/bash

NET_THRESHOLD_KB=1000
DISK_THRESHOLD_KB=5000
CPU_THRESHOLD_PERCENT=35
GPU_THRESHOLD_PERCENT=15

while true; do
    if playerctl status 2>/dev/null | grep -q "Playing"; then
        sleep 60
        continue
    fi

    net_start=$(cat /sys/class/net/[ew]*/statistics/*x_bytes 2>/dev/null | awk '{s+=$1} END {print s}')
    disk_start=$(awk '$3 ~ /^(sd[a-z]+|nvme[0-9]+n[0-9]+)$/ {s+=$6+$10} END {print s}' /proc/diskstats 2>/dev/null)

    read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
    cpu_total_start=$((user+nice+system+idle+iowait+irq+softirq+steal))
    cpu_idle_start=$idle

    net_start=${net_start:-0}
    disk_start=${disk_start:-0}

    sleep 5

    net_end=$(cat /sys/class/net/[ew]*/statistics/*x_bytes 2>/dev/null | awk '{s+=$1} END {print s}')
    disk_end=$(awk '$3 ~ /^(sd[a-z]+|nvme[0-9]+n[0-9]+)$/ {s+=$6+$10} END {print s}' /proc/diskstats 2>/dev/null)

    read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
    cpu_total_end=$((user+nice+system+idle+iowait+irq+softirq+steal))
    cpu_idle_end=$idle

    net_end=${net_end:-0}
    disk_end=${disk_end:-0}

    net_speed=$(( (net_end - net_start) / 5120 ))
    disk_speed=$(( (disk_end - disk_start) / 10 ))

    cpu_total_diff=$((cpu_total_end - cpu_total_start))
    cpu_idle_diff=$((cpu_idle_end - cpu_idle_start))

    if [ "$cpu_total_diff" -gt 0 ]; then
        cpu_usage=$(( 100 * (cpu_total_diff - cpu_idle_diff) / cpu_total_diff ))
    else
        cpu_usage=0
    fi

    gpu_usage=0
    if command -v nvidia-smi &> /dev/null; then
        gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | awk '{s+=$1} END {print s}')
        gpu_usage=${gpu_usage:-0}
    fi

    if [ "$net_speed" -gt "$NET_THRESHOLD_KB" ] || \
       [ "$disk_speed" -gt "$DISK_THRESHOLD_KB" ] || \
       [ "$cpu_usage" -gt "$CPU_THRESHOLD_PERCENT" ] || \
       [ "$gpu_usage" -gt "$GPU_THRESHOLD_PERCENT" ]; then
        sleep 60
    else
        systemctl suspend
        exit 0
    fi
done
