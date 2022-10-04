// <copyright company="Scythe Studio Sp. z o.o.">
//     This file contains proprietary code. Copyright (c) 2021. All rights reserved.
// </copyright>
import QtQuick 2.15
import QtQuick.Controls 2.15
import Utilities


/*!
 * \brief A custom Button with features non-available in standard QML button.

   A custom Button based on standard QML Button.
   Implementation allows setting arbitrary rectangle as background for the button.
   A default background rectangle provides hover effect.
   Button has an extended text customization.

   SButton supports following customization:
   - setting background rectangle for the button.
   - setting text for the button.

   SButton can be used as any QML Button.\n
   Example of SButton incrementing its counter text:

   \code

      SButton {
        id: button
        property var counter: 0

        anchors.centerIn: parent
        width: SUtilities.dp(200)
        height: SUtilities.dp(100)
        text: counter

        onClicked: {
          counter++
        }
      }

   \endcode
 */
AbstractButton {
    id: root

    property int fontPointSize: SConstants.sBigTextPointSize

    property alias backgroundRectangle: background
    property alias contentText: contentText

    hoverEnabled: true

    opacity: enabled ? 1.0 : 0.85
    text: "Button"

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

    contentItem: Text {
        id: contentText

        text: root.text

        elide: Text.ElideMiddle
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        color: STheme.sWhite
        font {
            pointSize: root.fontPointSize
        }

        Behavior on opacity {
            PropertyAnimation {
                duration: SConstants.sDefaultAnimationDuration
            }
        }
    }
}
