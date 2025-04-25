#!/bin/bash

# Desired settings
DESIRED_WIDTH=1600
DESIRED_HEIGHT=1300
DESIRED_FORMAT="Y16 "    # Could also be "GREY", "MJPG", etc.

echo "Scanning /dev/video* for $DESIRED_WIDTH x $DESIRED_HEIGHT [$DESIRED_FORMAT]..."

for DEV in /dev/video*; do
    echo ""
    echo "🔍 Checking $DEV..."

    # Dump extended format info
    FORMATS=$(v4l2-ctl --device="$DEV" --list-formats-ext 2>/dev/null)

    if [[ -z "$FORMATS" ]]; then
        echo "❌ No response from $DEV"
        continue
    fi

    if echo "$FORMATS" | grep -q "$DESIRED_FORMAT"; then
        if echo "$FORMATS" | grep -q "${DESIRED_WIDTH}x${DESIRED_HEIGHT}"; then
            echo "✅ Found matching device: $DEV"
            echo "$FORMATS" | grep -A4 "$DESIRED_FORMAT" | grep "${DESIRED_WIDTH}x${DESIRED_HEIGHT}"
            exit 0
        fi
    fi

    echo "❌ $DEV does not support ${DESIRED_WIDTH}x${DESIRED_HEIGHT} in $DESIRED_FORMAT"
done

echo ""
echo "⚠️ No matching /dev/video* device found."
exit 1

