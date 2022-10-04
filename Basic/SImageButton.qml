// <copyright company="Scythe Studio Sp. z o.o.">
//     This file contains proprietary code. Copyright (c) 2021. All rights reserved.
// </copyright>
import QtQuick 2.15
import QtQuick.Controls 2.15
import Utilities


/*!
 * \brief Custom QML button allowing setting any image as background.

   Implementation is based on standard QML Button.
   Rectangle and Image are used as background elements.

   SImageButton button supports following customization:
   - setting source image.
   - setting background rectangle.
   - setting content image.

   SImageButton can be used as any QML Button.
   Example of using SImageButton:

   \code
      SImageButton {
        id: button
        anchors.centerIn: parent
        width: SUtilities.dp(200)
        height: SUtilities.dp(200)

        source: "qrc:/Assets/ssLogoWhite.png"
      }
   \endcode
 */
AbstractButton {
    id: root

    property var source

    property alias backroundRectangle: background
    property alias contentImage: contentImage

    hoverEnabled: true

    opacity: enabled ? 1.0 : 0.7

    background: Rectangle {
        id: background
        radius: SUtilities.dp(SConstants.sStandardRadiusSize)
        color: STheme.sGreen
        opacity: root.hovered ? 1 : SConstants.sHoveredOpacity

        Behavior on opacity {
            PropertyAnimation {
                duration: SConstants.sDefaultAnimationDuration
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: false
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
    }

    contentItem: Image {
        id: contentImage

        source: root.source
        fillMode: Image.PreserveAspectFit
        mipmap: true
        sourceSize {
            width: SUtilities.dp(320)
            height: SUtilities.dp(320)
        }

        Behavior on opacity {
            PropertyAnimation {
                duration: SConstants.sDefaultAnimationDuration
            }
        }
    }
}
