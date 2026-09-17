# app/ — 应用入口与平台装配

应用入口（main）与各目标平台（android / ios / macos / embedded）的装配层。相机与 BLE 的平台能力差异收敛在本层做适配，业务模块不感知平台差异。
