# Incident Timeline


| Timestamp (UTC)         | Source                | Host / IP                                     | Protocol / Event                                                             | Confidence |
| ----------------------- | --------------------- | --------------------------------------------- | ---------------------------------------------------------------------------- | ---------- |
| 19:44:56.530            | Wireshark/pcap        | 10.1.17.215                                   | DHCP / DNS update / CLDAP                                                    | Confirmed  |
| 19:45:56.83-.99         | Wireshark + Suricata  | 5.252.153.241 → 10.1.17.215                   | HTTP GET /api/file/get-file/264872                                           | Confirmed  |
| 19:45:58.68-.90         | Wireshark + Suricata  | 5.252.153.241 → 10.1.17.215                   | HTTP GET /api/file/get-file/29842.ps1                                        | Confirmed  |
| 19:45:58.90 onward      | Wireshark             | 10.1.17.215 ↔ 5.252.153.241                   | HTTP GET /<volume-serial> (repeating)                                      | Confirmed  |
| 19:47:01.49             | Wireshark             | 5.252.153.241 → 10.1.17.215                   | HTTP 200, 2,761 bytes (pushed task)                                          | Confirmed  |
| 19:47:01.53-19:47:05.68 | Wireshark + Suricata  | 5.252.153.241 → 10.1.17.215                   | HTTP GET TeamViewer / Teamviewer_Resource_fr / TV / pas.ps1                  | Confirmed  |
| 19:47:05.74             | Wireshark             | 10.1.17.215 → 5.252.153.241                   | HTTP GET /<serial>?k=message = startup shortcut created; status = success; | Confirmed  |
| 19:55:07.53-.77         | Wireshark + Suricata  | 10.1.17.215 ↔ 185.188.32.26                   | DNS master16.teamviewer.com + HTTP din.aspx/dout.aspx                        | Confirmed  |
| 19:59:38.14             | Wireshark             | 5.252.153.241 → 10.1.17.215                   | HTTP 200, ~354KB (pushed task)                                               | Confirmed  |
| 19:59:46.09             | Zeek + Suricata (tls) | 10.1.17.215 → 45.125.66.32:2917               | TCP/TLS 1.2 beacon burst #1                                                  | Confirmed  |
| 20:25:09.76             | Wireshark             | 5.252.153.241 → 10.1.17.215                   | HTTP 200, ~354KB (pushed task)                                               | Confirmed  |
| 20:25:16.93             | Zeek + Suricata (tls) | 10.1.17.215 → 45.125.66.32:2917               | TCP/TLS 1.2 beacon burst #2                                                  | Confirmed  |
| 20:25:42.76 onward      | Zeek + Suricata (tls) | 10.1.17.215 ↔ 45.125.66.252:443               | TCP/TLS 1.2                                                                  | Confirmed  |
| 20:27:54.07             | Wireshark             | 5.252.153.241 → 10.1.17.215                   | HTTP 200, ~354KB (pushed task)                                               | Confirmed  |
| 20:28:01.31             | Zeek + Suricata (tls) | 10.1.17.215 → 45.125.66.32:2917               | TCP/TLS 1.2 beacon burst #3                                                  | Confirmed  |
| 20:38:18.66-.92         | Wireshark             | 10.1.17.215 ↔ 5.252.153.241 and 45.125.66.252 | HTTP GET /<serial> (404) + TLS Application Data                            | Confirmed  |


