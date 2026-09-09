# Evidence Manifest

This project analyzes a real, malware-traffic-analysis.net PCAP capture. The capture itself is not committed to this repository as redistributing live malware samples goes against platform policy. Every other artifact this project produced (detection rules, logs, alerts, screenshots) is committed, so the pipeline's behavior is fully visible even without the raw sample.

## Source

The capture should be obtained directly from its original distribution source (a malware-traffic-analysis.net  write-up/archive) under whatever terms that source publishes it.

## Integrity Verification

Once the file is obtained, verify it matches the exact pcap this project analyzed before replaying it through the pipeline:

```
sha256sum capture.pcap
expected: e59db1c07c6fdefafa0abdbca03248c341cdc36c09c34753204d3162802a3586
```



## File Characteristics


| Property         | Value                                                              |
| ---------------- | ------------------------------------------------------------------ |
| File size        | 26 MB                                                              |
| Packet count     | 39,427                                                             |
| Capture start    | 2025-01-22 19:44:56.530137 UTC                                     |
| Capture end      | 2025-01-22 20:38:18.918250 UTC                                     |
| Capture duration | 53.4 minutes                                                       |
| SHA-256          | `e59db1c07c6fdefafa0abdbca03248c341cdc36c09c34753204d3162802a3586` |




## Important:

- The capture was analyzed entirely offline and had no exposure to the live internet.
- No payload extracted from the capture should be executed, every payload must be statically decoded.
- Don't connect to any IP addresses observed in this capture, the safe way to checkout IP addresses is via passive RDAP/WHOIS lookups only.
- IOCs published in `investigation/ioc-list.csv` are not live-clickable for safety (e.g. `5[.]252[.]153[.]241`).

