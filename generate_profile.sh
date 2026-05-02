#!/bin/bash
echo "# Device Profile"
echo "- **Model**: $(getprop ro.product.model)"
echo "- **Android Version**: $(getprop ro.build.version.release)"
echo "- **Architecture**: $(uname -m)"
echo "- **Timestamp**: $(date)"
