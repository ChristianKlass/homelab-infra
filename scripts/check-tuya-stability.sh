#!/bin/bash
# Check Tuya device stability over last 24 hours
# Usage: ./check-tuya-stability.sh

# Source environment for HA token using absolute path
source /home/mark/homelab/.env

# List of Tuya devices to monitor
DEVICES="fan.study_mark_fan,light.study_mark_fan,switch.switch_study_undertable_fan,light.main_door_usb_l1,light.main_door_usb_l3,light.switch_mbr_toilet_left,light.switch_mbr_toilet_right,light.switch_kitchen_ambient_left,light.switch_kitchen_ambient_center,light.switch_kitchen_ambient_right,light.switch_kitchen_redcounter_left,light.switch_kitchen_redcounter_right,light.hotel_california_socket_1,light.switch_storeroom_light,fan.switch_study_undertable_fan"

echo "Checking Tuya device stability (last 24 hours)..."
echo "=================================================="
echo ""

START_TIME=$(date -u -d "1 day ago" +%Y-%m-%dT%H:%M:%S)

# Debug: save response to file
TMPFILE=$(mktemp)
curl -s -H "Authorization: Bearer ${HOMEASSISTANT_TOKEN}" \
  "http://10.0.0.2:8123/api/history/period/${START_TIME}?filter_entity_id=${DEVICES}" \
  > "$TMPFILE"

# Debug: check if file has content
if [ ! -s "$TMPFILE" ]; then
    echo "ERROR: Got empty response from Home Assistant API"
    echo "Token present: $([ -n "$HOMEASSISTANT_TOKEN" ] && echo "YES" || echo "NO")"
    echo "URL: http://10.0.0.2:8123/api/history/period/${START_TIME}?filter_entity_id=${DEVICES}"
    rm -f "$TMPFILE"
    exit 1
fi

python3 <<PYTHON
import json
from collections import defaultdict

try:
    with open("$TMPFILE", "r") as f:
        data = json.load(f)
except json.JSONDecodeError as e:
    print(f"ERROR: Failed to parse JSON from Home Assistant API")
    print(f"Details: {e}")
    import sys
    sys.exit(1)

unavailable_counts = defaultdict(int)

for entity_history in data:
    if not entity_history:
        continue
    entity_id = entity_history[0]['entity_id'] if entity_history else 'unknown'
    count = sum(1 for state in entity_history if state.get('state') in ['unavailable', 'unknown'])
    unavailable_counts[entity_id] = count

# Separate problem devices from stable ones
problems = [(e, c) for e, c in unavailable_counts.items() if c > 0]
stable = [(e, c) for e, c in unavailable_counts.items() if c == 0]

if problems:
    print("🔴 PROBLEM DEVICES:")
    print("-" * 60)
    for entity, count in sorted(problems, key=lambda x: x[1], reverse=True):
        print(f"  {entity}: {count} disconnections")
    print()

if stable:
    print(f"✅ STABLE DEVICES: {len(stable)} devices with 0 disconnections")
    print()

total_disconnections = sum(c for _, c in problems)
print(f"TOTAL DISCONNECTIONS: {total_disconnections}")
print(f"AFFECTED DEVICES: {len(problems)}/{len(unavailable_counts)}")
PYTHON

# Cleanup
rm -f "$TMPFILE"
