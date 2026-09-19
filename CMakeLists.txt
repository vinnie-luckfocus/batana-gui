cmake_minimum_required(VERSION 3.21)

project(batana-gui VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

# Qt6 位置不硬编码：主机开发用 -DCMAKE_PREFIX_PATH=<Qt 安装前缀>，
# Yocto 交叉编译由 toolchain 文件注入 Qt6_DIR / CMAKE_FIND_ROOT_PATH。
find_package(Qt6 6.5 REQUIRED COMPONENTS Core Gui Quick Qml)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(batana-gui
    app/main.cpp
)

qt_add_qml_module(batana-gui
    URI Batana
    VERSION 1.0
    QML_FILES
        qml/Main.qml
)

target_link_libraries(batana-gui PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::Qml
)

install(TARGETS batana-gui
    RUNTIME DESTINATION bin
)
