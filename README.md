<div align="center">
  <img src="https://raw.githubusercontent.com/vinnie-luckfocus/batana/main/assets/logo.png" alt="Batana Logo" width="150">

  <h3>batana-gui</h3>
  <p>Batana 生态 · 嵌入式 GUI（Qt6 / QML · 嵌入式 Linux）</p>
</div>

## 定位

本仓是 **Batana 生态**的嵌入式 GUI 子仓库：**batana-pi 显示屏的本地界面**，采用 **Qt6（C++20 / QML）**，运行于 **嵌入式 Linux（RK3588）**。负责 batana-pi 设备上的采集编排界面、外设连接状态展示、结果可视化与联网云同步。

> 移动端 / 桌面端（iOS / Android / macOS / Windows）不由本仓承担——统一移交新仓 **batana-app（Flutter）**（2026-09-17 决策）。本仓不再面向通用跨平台目标。

## 边界

- ✅ 做：batana-pi 显示屏 UI/UX、采集编排、BLE 外设连接（batana-cap）、结果可视化、pi 联网云同步
- ❌ 不做：
  - 移动端 / 桌面端应用 —— 归 **batana-app（Flutter）**
  - 评分 / 姿态算法 —— 一律走 **batana-runtime（C API 直接链接，无 FFI 边界）**
  - 服务端逻辑、batana-cap 固件

## 与 batana-app 的分工

| | batana-gui（本仓） | batana-app |
|---|---|---|
| 形态 | batana-pi 显示屏本地界面 | 移动 / 桌面应用（iOS / Android / macOS / Windows） |
| 技术栈 | Qt6 / QML · 嵌入式 Linux（RK3588） | Flutter |
| 运行位置 | batana-pi 设备上（直接链接 batana-runtime） | 用户手机 / 电脑（经网络访问 pi 与云端） |
| 职责 | 设备侧本地交互与实时可视化 | 远程查看、账号与云端功能入口 |

两者通过生态契约（session-schema / capabilities / sync-api 等）保持数据与行为对齐。

## 生态

- 司令塔仓库（生态总览与多仓协调）：[vinnie-luckfocus/batana](https://github.com/vinnie-luckfocus/batana)
- 生态架构：[docs/architecture.md](https://github.com/vinnie-luckfocus/batana/blob/main/docs/architecture.md)
- 生态路线图：[docs/roadmap.md](https://github.com/vinnie-luckfocus/batana/blob/main/docs/roadmap.md)
- 本仓模块规格：[docs/modules/batana-gui.md](https://github.com/vinnie-luckfocus/batana/blob/main/docs/modules/batana-gui.md)

## 技术栈

Qt 6.8+（C++20 / QML）· CMake · Qt Bluetooth（BLE）· Qt SQL（SQLite）· Yocto / Qt6 embedded（RK3588）

```
batana-gui/
├── app/              # 嵌入式 Linux 平台装配（Yocto / Qt6 embedded）
├── qml/              # QML 界面（batana-pi 显示屏：页面、组件、主题）
├── src/
│   ├── session/      # 会话编排：采集→runtime→结果
│   ├── devices/      # BLE(cap) 连接管理
│   ├── runtime/      # batana-runtime 链接封装与能力注册表读取
│   └── sync/         # 云同步客户端（pi 联网，sync-api）
├── docs/contracts/   # 消费契约的适配说明
└── tests/
```

## 里程碑映射

- **P1**：v0.1 骨架 + 接入 runtime（standard-vision）
- **P2**：v0.2 BLE + 融合分析
- **P3**：嵌入式构建部署到 batana-pi（Yocto 集成）
- **P4**：云同步

## 许可证

MIT — 见 [LICENSE](LICENSE)。
