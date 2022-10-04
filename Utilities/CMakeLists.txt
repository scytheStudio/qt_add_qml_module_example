qt_add_library(UtilitiesLib STATIC)

set_target_properties(UtilitiesLib PROPERTIES AUTOMOC ON)
target_link_libraries(UtilitiesLib PRIVATE Qt6::Quick)

list(APPEND MODULE_QML_FILES SConstants.qml STheme.qml SUtilities.qml)
list(APPEND MODULE_JS_FILES Helper.js)

set_source_files_properties(${MODULE_QML_FILES} PROPERTIES
    QT_QML_SINGLETON_TYPE  TRUE
)

qt_add_qml_module(UtilitiesLib
    URI Utilities
    VERSION 1.0
    RESOURCE_PREFIX /scythestudio.com/imports
    QML_FILES
        ${MODULE_QML_FILES} ${MODULE_JS_FILES}
)


