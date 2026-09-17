<div align="center">
  <img src="https://raw.githubusercontent.com/vinnie-luckfocus/batana/main/assets/logo.png" alt="Batana Logo" width="150">

  <h3>batana-gui</h3>
  <p>Batana 生态 · 跨平台 GUI（Qt6 / C++ / QML）</p>
</div>

## 定位

本仓是 **Batana 生态**的跨平台 GUI 子仓库，采用 **Qt6（C++20 / QML）** 全新重写，覆盖 **Android / iOS / macOS / 嵌入式 Linux**。负责采集编排、外设连接管理、结果可视化与云端同步触达。

> 旧 Flutter MVP 方案已彻底放弃（2026-09-17 决策），不再迁移、不再维护；历史代码留存于主仓 `batana` 的 `archive/flutter-mvp` tag。

## 边界

- ✅ 做：UI/UX、采集编排、BLE/网络客户端、本地缓存（SQLite）、runtime 编排
- ❌ 不做：评分/姿态算法——一律走 **batana-core runtime**（同为 C++，**直接链接调用**，无 FFI 边界）；服务端逻辑；cap/pi 的设备端代码

## 生态

- 司令塔仓库（生态总览与多仓协调）：[vinnie-luckfocus/batana](https://github.com/vinnie-luckfocus/batana)
- 生态架构：[docs/architecture.md](https://github.com/vinnie-luckfocus/batana/blob/main/docs/architecture.md)
- 生态路线图：[docs/roadmap.md](https://github.com/vinnie-luckfocus/batana/blob/main/docs/roadmap.md)
- 本仓模块规格：[docs/modules/batana-gui.md](https://github.com/vinnie-luckfocus/batana/blob/main/docs/modules/batana-gui.md)

## 技术栈

Qt 6.8+（C++20 / QML）· CMake · Qt Bluetooth（BLE）· Qt Multimedia（相机）· Qt SQL（SQLite）

```
batana-gui/
├── app/              # 应用入口与平台装配（android/ios/macos/embedded）
├── qml/              # QML 界面（页面、组件、主题）
├── src/
│   ├── session/      # 会话编排：采集→runtime→结果
│   ├── devices/      # BLE(cap) 与局域网(pi) 连接管理
│   ├── runtime/      # batana-runtime 链接封装与能力注册表读取
│   └── sync/         # 云同步客户端（sync-api）
├── docs/contracts/   # 消费契约的适配说明
└── tests/
```

## 里程碑映射

- **P1**：v0.1 骨架 + 接入 runtime（standard-vision）
- **P2**：v0.2 BLE + 融合分析
- **P3**：嵌入式构建部署到 batana-pi
- **P4**：云同步

## 许可证

MIT — 见 [LICENSE](LICENSE)。
