qt_add_library(WidgetsLib STATIC)

set_target_properties(WidgetsLib PROPERTIES AUTOMOC ON)
target_link_libraries(WidgetsLib PRIVATE Qt6::Gui Qt6::Quick Qt6::Multimedia)

list(APPEND MODULE_QML_PRIVATE_FILES
    private/STiming.qml private/SVideoPlayerAnimatedImage.qml private/SVideoToolBar.qml)
list(APPEND MODULE_QML_FILES SVideoPlayer.qml ${MODULE_QML_PRIVATE_FILES})
list(APPEND MODULE_ASSETS
    assets/icon-back.svg
    assets/icon-close.svg
    assets/icon-forward.svg
    assets/icon-full-screen-close.svg
    assets/icon-full-screen-open.svg
    assets/icon-mute.svg
    assets/icon-next.svg
    assets/icon-pause.svg
    assets/icon-play.svg
    assets/icon-rewind.svg
    assets/icon-volume-down.svg
    assets/icon-volume-up.svg
)

set_source_files_properties(${MODULE_QML_PRIVATE_FILES} PROPERTIES
    QT_QML_INTERNAL_TYPE  TRUE
)

qt_add_qml_module(WidgetsLib
    URI Widgets
    VERSION 1.0
    RESOURCE_PREFIX /scythestudio.com/imports
    QML_FILES
        ${MODULE_QML_FILES}
    RESOURCES
        ${MODULE_ASSETS}
    SOURCES
        SignPad.h SignPad.cpp
)


