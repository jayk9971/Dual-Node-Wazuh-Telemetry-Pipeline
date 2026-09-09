#!/usr/bin/env bash
set -euo pipefail


# Replays the evidence PCAP through this detection pipeline
# (Suricata + Zeek) and writes output into
# investigation/proof-of-execution/
#
# Obtain PCAP from the source listed and verify its hash before it runs.
#
# Usage:
#   ./replay.sh /path/to/capture.pcap


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if [ $# -lt 1 ] || [ ! -f "$1" ]; then
    echo "ERROR: PCAP not found. Usage: ./replay.sh /path/to/capture.pcap"
    exit 1
fi

PCAP="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"




EXPECTED_SHA256="e59db1c07c6fdefafa0abdbca03248c341cdc36c09c34753204d3162802a3586"
OUT_DIR="$REPO_ROOT/investigation/proof-of-execution"
HOME_NET="[10.1.17.0/24]"

if command -v sha256sum >/dev/null; then
    ACTUAL_SHA256="$(sha256sum "$PCAP" | awk '{print $1}')"
elif command -v shasum >/dev/null; then
    ACTUAL_SHA256="$(shasum -a 256 "$PCAP" | awk '{print $1}')"
else
    echo "ERROR: neither sha256sum nor shasum found on PATH"
    exit 1
fi
if [ "$ACTUAL_SHA256" != "$EXPECTED_SHA256" ]; then
    echo "ERROR: SHA-256 mismatch."
    echo "  expected: $EXPECTED_SHA256"
    echo "  actual:   $ACTUAL_SHA256"
    echo "This is not the correct PCAP file"
    echo "See evidence-manifest.md for the correct source."
    exit 1
fi
echo "Hash matches evidence-manifest.md"


mkdir -p "$OUT_DIR/suricata" "$OUT_DIR/zeek" "$OUT_DIR/wazuh"

echo "Replaying PCAP through Suricata"
command -v suricata >/dev/null || { echo "ERROR: suricata not found on PATH"; exit 1; }



suricata \
    -c "$SCRIPT_DIR/config/suricata/suricata.yaml" \
    -r "$PCAP" \
    -S "$SCRIPT_DIR/detection-rules/custom_suricata.rules" \
    --set vars.address-groups.HOME_NET="$HOME_NET" \
    --set default-rule-path="$SCRIPT_DIR/detection-rules" \
    -l "$OUT_DIR/suricata" \
    -k none



echo "eve.json / fast.log written to $OUT_DIR/suricata/"

echo "Replaying PCAP through Zeek"
command -v zeek >/dev/null || { echo "ERROR: zeek not found on PATH"; exit 1; }


ZEEK_WORKDIR="$(mktemp -d)"
trap 'rm -rf "$ZEEK_WORKDIR"' EXIT
( cd "$ZEEK_WORKDIR" && zeek -C -r "$PCAP" \
    LogAscii::use_json=T \
    Site::local_nets+=10.1.17.0/24 \
    "$SCRIPT_DIR/config/zeek/local.zeek" )
for log in conn.log http.log dns.log weird.log; do
    if [ -f "$ZEEK_WORKDIR/$log" ]; then
        cp "$ZEEK_WORKDIR/$log" "$OUT_DIR/zeek/"
    else
        echo "WARNING: Zeek did not produce $log"
    fi
done
echo "conn.log / http.log / dns.log / weird.log written to $OUT_DIR/zeek/"


cat <<'EOF'

Wazuh ingestion

  1. Point the Wazuh agent config (pipeline/config/wazuh-agent/ossec.conf)
  at the eve.json and Zeek JSON logs as done in pipeline/config/wazuh-agent/ossec.conf of this repo.
  2. Restart the agent: sudo systemctl restart wazuh-agent
  3. Copy pipeline/detection-rules/local_rules.xml to
     /var/ossec/etc/rules/local_rules.xml on the manager, then:
       sudo systemctl restart wazuh-manager
  4. Search the Wazuh dashboard for rule.groups:local_trap to confirm the
     custom-rule alerts are now visible.

EOF

echo "Done. Execution completed in $OUT_DIR"