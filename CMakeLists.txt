cmake_minimum_required(VERSION 3.16)

project(superapp VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Gui Quick Multimedia REQUIRED)

qt_add_executable(appsuperapp
    main.cpp
)

qt_add_qml_module(appsuperapp
    URI Superapp
    VERSION 1.0
    RESOURCE_PREFIX /scythestudio.com/imports
    QML_FILES main.qml Pages/Page.qml
)

add_subdirectory(Utilities)
add_subdirectory(Basic)
add_subdirectory(Widgets)

set_target_properties(appsuperapp PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appsuperapp
    PRIVATE Qt6::Gui Qt6::Quick Qt6::Multimedia UtilitiesLibplugin BasicLibplugin WidgetsLibplugin)

install(TARGETS appsuperapp
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
