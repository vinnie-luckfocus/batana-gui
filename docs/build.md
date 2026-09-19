# 构建与运行说明（batana-gui）

Qt6 / QML 嵌入式 HelloWorld 骨架，目标是 batana-pi（RK3588，8" 800×1280 竖屏，eglfs 无窗口系统）。

> **本机构建状态：未本机构建验证。** 开发机（macOS）当前只有 Homebrew qt@5，未安装 Qt6，
> 本骨架经人工静态核对，首次实际编译在 Qt6 环境（本机安装 Qt6 或 Yocto SDK）中进行。

## 依赖

- CMake ≥ 3.21
- Qt ≥ 6.5（仅需 Core / Gui / Quick / Qml，无第三方依赖）
- C++17 编译器

## macOS 本机预览（开发调试用）

```bash
brew install qt@6   # 首次安装

cmake -B build -DCMAKE_PREFIX_PATH="$(brew --prefix qt@6)"
cmake --build build
./build/batana-gui                 # 默认 800×1280 窗口
./build/batana-gui --width 480 --height 800   # 自定义窗口尺寸
```

也可使用 Qt 官方安装器装的 Qt6：`cmake -B build -DCMAKE_PREFIX_PATH=~/Qt/6.x/macos`。

本机预览使用 cocoa 平台插件；eglfs 仅在嵌入式 Linux 上可用。

## Yocto / meta-qt6 集成（batana-pi 目标）

构建链在 batana-pi 仓 `firmware/yocto/meta-batana` 层中维护，本仓只提供标准
`cmake + qt_add_qml_module` 工程，不硬编码任何主机路径；Qt6 位置由 Yocto SDK
toolchain 文件（`CMAKE_FIND_ROOT_PATH` / `Qt6_DIR`）注入。

### layer 依赖

`meta-batana/conf/layer.conf` 需依赖：

```
LAYERDEPENDS_meta-batana = "core qt6-layer"
```

即 `openembedded-core` + `meta-qt6`（分支与所用 Yocto 版本对齐，如 `styhead`/`scarthgap`）。

### 配方示例（meta-batana/recipes-apps/batana-gui/batana-gui_0.1.0.bb）

```bitbake
SUMMARY = "batana-pi 嵌入式 GUI"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=<填入 LICENSE 校验>"

SRC_URI = "git://github.com/vinnie-luckfocus/batana-gui.git;protocol=https;branch=main"
SRCREV = "${AUTOREV}"
S = "${WORKDIR}/git"

inherit qt6-cmake

DEPENDS = "qtbase qtdeclarative"

FILES:${PN} += "${bindir}/batana-gui"
```

镜像侧（`batana-image`）加入：

```
IMAGE_INSTALL:append = " batana-gui qtbase-plugins qtdeclarative-qmlplugins"
```

Qt Quick 场景图在 RK3588 上走 GPU（Mali-G610，Panfrost / libmali 取决于 BSP），
确保镜像包含 KMS/DRM 驱动与 EGL/GLES2 用户态库。

## 板端运行（eglfs）

eglfs 是 Qt 面向嵌入式 Linux 的全屏单窗口平台插件，不经窗口系统，直接经
EGL + KMS/DRM 输出到显示屏。

### 环境变量

```sh
export QT_QPA_PLATFORM=eglfs
# 触控 / 键鼠输入（libinput，通常默认即可）
export QT_QPA_EGLFS_INTEGRATION=eglfs_kms     # 明确走 KMS/DRM 后端
# 多屏或需要固定模式时，用 KMS 配置文件指定分辨率：
# export QT_QPA_EGLFS_KMS_CONFIG=/etc/batana/eglfs-kms.json
# 竖屏面板若时序非默认，可在 kms json 中指定 mode
export QT_QPA_EGLFS_ALWAYS_SET_MODE=1
# 触摸设备节点异常时排查：
# export QT_QPA_EVDEV_TOUCHSCREEN_PARAMETERS=/dev/input/eventX
export QT_LOGGING_RULES="qt.qpa.*=true"       # 调试期打印 QPA 插件信息
```

### 运行步骤

```sh
# 板端（串口或 SSH 登录，无桌面会话）
systemctl stop weston 2>/dev/null || true   # 确保没有占用 DRM master 的合成器
export QT_QPA_PLATFORM=eglfs
/usr/bin/batana-gui            # 或带参 batana-gui --width 800 --height 1280
```

启动日志应出现 `QPA 平台: eglfs 窗口: 800x1280`。

### 肉眼验收（M0 V2）

1. 屏幕点亮，深色底 + 居中 "batana" 字样；
2. 右上角绿点持续脉动、FPS 计数稳定在面板刷新率附近（心跳累加）——渲染管线正常；
3. 点按底部触控区变色并显示"触控正常 ✓"——触摸输入正常。

## 目录约定

- `app/main.cpp`：入口（QGuiApplication + QQmlApplicationEngine，`--width/--height` 参数）
- `qml/Main.qml`：竖屏 HelloWorld 界面（QML 模块 `Batana`）
- 根 `CMakeLists.txt`：`qt_add_executable` + `qt_add_qml_module`
