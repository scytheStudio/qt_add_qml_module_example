// <copyright company="Scythe Studio Sp. z o.o.">
//     This file contains proprietary code. Copyright (c) 2021. All rights reserved.
// </copyright>
import QtQuick 2.15
import QtQuick.Controls 2.15

import Utilities


/*!
 * \brief Custom Slider with features non-available in standard QML Slider.

   Implementation is based on standard QML Slider.
   Item provides hover effect.

   SSlider supports following customization :
    - setting colors and size of background and value bar;
    - setting color and size of the handle;

   SSlider can be used as QML Slider.\n
   Example of using SSlider:

   \code
      SSlider {
        id: slider
        anchors {
          left : parent.left
          right: parent.right
        }
        height          : SUtilities.dp(10)
        from            : 0
        to              : 100
        stepSize        : 10
        heightHandler   : SUtilities.dp(20)
        heightBackground: SUtilities.dp(10)
        colorHandler    : STheme.sWhite
        colorValueBar   : STheme.sWhite
        colorBackground : STheme.sBlack
      }
   \endcode
 */
Slider {
    id: root

    property alias heightHandler: handler.implicitHeight
    property alias heightBackground: rctglBackground.implicitHeight
    property alias colorHandler: handler.color
    property alias colorValueBar: rctngValueBar.color
    property alias colorBackground: rctglBackground.color

    signal valueChanged(var val)

    implicitWidth: SUtilities.dp(300)
    implicitHeight: SUtilities.dp(20)

    from: 0
    to: 100
    value: 50
    hoverEnabled: true

    background: Rectangle {
        id: rctglBackground

        z: 1
        implicitWidth: root.width
        implicitHeight: root.height
        width: root.availableWidth
        height: rctglBackground.implicitHeight
        anchors {
            left: parent.left
            leftMargin: root.leftPadding
            top: parent.top
        }

        radius: rctglBackground.height
        color: STheme.sBackgroundGray
        opacity: root.enabled ? 1.0 : SConstants.sDisabledOpacity
    }

    Rectangle {
        id: rctngValueBar

        z: 2
        height: parent.height
        anchors {
            left: rctglBackground.left
            right: handler.right
        }

        color: STheme.sWhite
        radius: parent.height
        opacity: root.enabled ? 1.0 : SConstants.sDisabledOpacity
    }

    handle: Rectangle {
        id: handler

        z: 3
        x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
        implicitWidth: implicitHeight
        implicitHeight: 2 * root.height
        anchors.verticalCenter: parent.verticalCenter

        radius: implicitHeight
        color: STheme.sWhite
    }

    onMoved: function (value) {
        value = valueAt(position)
        root.valueChanged(value)
    }
}
