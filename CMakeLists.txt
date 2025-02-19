# SPDX-FileCopyrightText: 2023 UnionTech Software Technology Co., Ltd.
#
# SPDX-License-Identifier: GPL-3.0-or-later

cmake_minimum_required(VERSION 3.10)


# 使用 set 命令设置一个变量
set(PLUGIN_NAME "digitalwellbeing-plugin")

# 设置项目名称
project(${PLUGIN_NAME} VERSION 0.2.0)

option(CMAKE_EXPORT_COMPILE_COMMANDS "clangd support" ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(QT_NS Qt6)
set(DTK_NS Dtk6)

find_package(QT NAMES ${QT_NS} REQUIRED COMPONENTS Core)
find_package(${QT_NS} REQUIRED COMPONENTS Core Gui Concurrent Qml Svg Quick QuickControls2 LinguistTools)
find_package(${DTK_NS} REQUIRED COMPONENTS Core Gui)

find_package(DDEShell REQUIRED)

message(cmake install prefix = ${CMAKE_INSTALL_PREFIX}, datadir=${CMAKE_INSTALL_DATADIR}, packagedir=${DDE_SHELL_PACKAGE_INSTALL_DIR})

add_library(dock-digitalwellbeing SHARED
    digitalwellbeing.cpp
    digitalwellbeing.h
)

target_link_libraries(dock-digitalwellbeing PRIVATE
    Dde::Shell
    ${DTK_NS}::Gui
)

set(package_name org.deepin.ds.dock.digitalwellbeing)
set(package_dirs ${PROJECT_BINARY_DIR}/packages/${package_name}/)
set(chartjsdir ${PROJECT_SOURCE_DIR}/ChartJs2QML)

file(COPY ${chartjsdir}/Chart.js DESTINATION ${package_dirs})
file(COPY ${chartjsdir}/Chart.qml DESTINATION ${package_dirs})

ds_install_package(PACKAGE ${package_name} TARGET dock-digitalwellbeing)

# ds_handle_package_translation(
# PACKAGE org.deepin.ds.dock.digitalwellbeing
# QML_FILES
#     ${QML_FILES_NEED_TRANSLATION}
# )