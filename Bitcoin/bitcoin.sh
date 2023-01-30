#!/bin/bash
LATEST_RELEASE=${(curl https://api.github.com/repos/bitcoin/bitcoin/releases/latest |  python3 -c "import sys, json; print(json.load(sys.stdin)['tag_name'].replace('v', ''))")}