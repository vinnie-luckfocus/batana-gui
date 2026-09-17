# src/devices/ — 外设连接管理

外设连接模块：BLE 连接 batana-cap（配对、状态、OTA 触发，消费 ble-protocol 契约）。本仓运行于 batana-pi 本机，无需局域网发现 pi（远程访问 pi 是 batana-app 的职责）。基于 Qt Bluetooth 实现。
