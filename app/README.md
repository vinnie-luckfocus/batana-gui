# app/ — 嵌入式 Linux 平台装配

应用入口（main）与 batana-pi 目标平台的装配层：**嵌入式 Linux（RK3588）**，构建体系为 Yocto / Qt6 embedded（eglfs 等显示后端）。相机与 BLE 的平台能力差异收敛在本层做适配，业务模块不感知平台差异。
