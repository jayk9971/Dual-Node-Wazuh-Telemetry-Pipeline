# Executive Summary

## Overview

One endpoint (`10.1.17.215`) was compromised by a fake Microsoft Teams update that created a backdoor that could be remotely controlled and that had at least two distinct command and control channels set up. The following is a summary of the findings based on a replay of the 53 minute capture of the incident using the detection pipeline outlined in `pipeline/`.

## Breakdown

1. The infected machine received a VBScript/HTA, masquerading as an update for Microsoft Teams, which invoked an obfuscated PowerShell command.
2. The second script, executed via the PowerShell command, used fingerprinting and opened a polling loop to the originating server staying open for the entirety of the capture.
3. Via that channel, the attacker established remote access via TeamViewer and a suspicious DLL in the same folder, creating a Startup folder shortcut for persistence.
4. Another malicious channel, which existed separately from the first one, was also discovered, using self-signed TLS certificates generated on the same date.



## Key Findings

- **Active PowerShell C2 beacon**: persistent remote code execution, confirmed for the entire 53-minute session.
- **Second C2 channel:** to separate infrastructure, timing-correlated with payload deliveries.
- **RMM tool deployment with DLL side-loading:** likely an addition layered on top of the main backdoor.

More detail on each finding, in `alert-triage.md`.