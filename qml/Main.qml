import QtQuick

Window {
    id: root

    // 由 main.cpp 通过 setInitialProperties 注入（--width/--height，默认 800×1280）
    property int windowWidth: 800
    property int windowHeight: 1280

    width: windowWidth
    height: windowHeight
    visible: true
    // eglfs 平台下单窗口恒为全屏，无需显式 FullScreen；桌面预览保持窗口化便于调试
    title: "batana-gui"

    color: "#101418" // 深色底

    // ---- 渲染管线心跳：FrameAnimation 跟随场景图动画驱动（eglfs 下与 vsync 对齐）----
    FrameAnimation {
        id: frameClock
        running: true
        property real fps: smoothFrameTime > 0 ? (1.0 / smoothFrameTime) : 0
        property int beats: 0
        onTriggered: beats += 1
    }

    // 心跳指示点：每拍缩放一次，肉眼可确认渲染循环在跑
    Rectangle {
        id: heartbeat
        width: 18
        height: 18
        radius: 9
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 24
        color: "#35d07f"

        SequentialAnimation on scale {
            loops: Animation.Infinite
            NumberAnimation { to: 1.5; duration: 350; easing.type: Easing.InOutQuad }
            NumberAnimation { to: 1.0; duration: 350; easing.type: Easing.InOutQuad }
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 24

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "batana"
            color: "#f2f4f6"
            font.pixelSize: 96
            font.weight: Font.Bold
            font.letterSpacing: 4
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "batana-pi 嵌入式 GUI 骨架 · eglfs 渲染验证"
            color: "#8a94a0"
            font.pixelSize: 26
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "FPS: %1 · 心跳: %2".arg(frameClock.fps.toFixed(1)).arg(frameClock.beats)
            color: "#35d07f"
            font.pixelSize: 24
        }
    }

    // ---- 触控测试区：点按在两种颜色间切换 ----
    Rectangle {
        id: touchPad
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 40
        anchors.bottomMargin: 60
        height: 220
        radius: 16
        color: tapArea.pressed ? "#35d07f" : (touchPad.tapped ? "#2a6f4d" : "#1d2630")
        border.color: "#3a4552"
        border.width: 2

        property bool tapped: false

        Text {
            anchors.centerIn: parent
            text: touchPad.tapped ? "触控正常 ✓" : "触控测试：点按此处"
            color: "#f2f4f6"
            font.pixelSize: 28
        }

        TapHandler {
            id: tapArea
            onTapped: touchPad.tapped = !touchPad.tapped
        }
    }
}
