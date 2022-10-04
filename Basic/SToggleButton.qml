// <copyright company="Scythe Studio Sp. z o.o.">
//     This file contains proprietary code. Copyright (c) 2021. All rights reserved.
// </copyright>
import QtQuick 2.15
import QtQuick.Controls 2.15

import Utilities


/*!
 * \brief Custom Abstract Button allowing setting any image as contentItem
   and changing it depenending on checked state.

   Implementation is based on standard QML Abstract Button.
   Rectangle is used as background element, Image is used as a content element.

   SToggleButton supports following customization :
    - setting visibility state and color of the background.
    - setting background rectangle.
    - setting content image of the toggle button.
    - setting source images for both states of the button (checked, unchecked).
    - setting border color.
    - setting radius of the button.
    - setting content image.

   Example of using SToggleButton:

   \code

      SToggleButton {
        id: button

        anchors.centerIn: parent
        width : SUtilities.dp(200)
        height: SUtilities.dp(200)
        source: "qrc:/SGUILib/Assets/darthVaderIcon.png"
        sourceToggled: "qrc:/SGUILib/Assets/lukeSkywalkerIcon.png"
        backgroundColor: STheme.sGreen
        frameBorderColor: STheme.sWhite
      }

   \endcode
 */
AbstractButton {
    id: root

    property bool backgroundVisible: true
    property color backgroundColor: STheme.sBlack
    property color frameBorderColor: STheme.sTransparent
    property alias contentImage: container
    property alias radius: backgroundFill.radius
    property var source
    property var sourceToggled
    property alias backroundRectangle: backgroundFill

    implicitWidth: SUtilities.dp(50)
    implicitHeight: SUtilities.dp(50)

    hoverEnabled: true
    opacity: enabled ? 1.0 : 0.7
    checkable: true
    checked: false

    background: Rectangle {
        id: backgroundFill
        color: root.backgroundVisible ? root.backgroundColor : STheme.sTransparent
        opacity: root.hovered ? 1 : SConstants.sHoveredOpacity
        radius: SUtilities.dp(20)
        border {
            width: SConstants.sSmallBorderSize
            color: root.frameBorderColor
        }

        Behavior on opacity {
            PropertyAnimation {
                duration: SConstants.sDefaultAnimationDuration
            }
        }

        MouseArea {
            id: mArea
            anchors.fill: parent
            enabled: false
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
    }

    contentItem: Image {
        id: container
        source: root.checked ? root.sourceToggled : root.source

        fillMode: Image.PreserveAspectFit
        mipmap: true
        sourceSize {
            width: SUtilities.dp(320)
            height: SUtilities.dp(320)
        }

        Behavior on opacity {
            PropertyAnimation {
                duration: STheme.stdAnimationDuration
            }
        }
    }

    onPressed: function () {
        root.toggle()
        root.checked = !root.checked
    }


    /*!
   * \brief Sets opacity to 1.0.
   */
    function show() {
        root.opacity = 1.0
    }


    /*!
   * \brief Sets opacity to 0.0.
   */
    function hide() {
        root.opacity = 0.0
    }
}
