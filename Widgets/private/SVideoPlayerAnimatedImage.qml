// <copyright company="Scythe Studio Sp. z o.o.">
//     This file contains proprietary code. Copyright (c) 2021. All rights reserved.
// </copyright>
import QtQuick

import Utilities


/*!
 * \brief Item that is used to display image with show/hide animation.
    The implementation of the animation is based on changes of the opacity
    property.

   SVideoPlayerAnimatedImage can be used as QML Image.\n
   Example of SVideoPlayerAnimatedImage usage:

   \code

      SVideoPlayerAnimatedImage {
        id: img
        anchors.centerIn: parent
        width : SUtilities.dp(100)
        height: width
        source: "qrc:/scythestudio.com/imports/Widgets/assets/icon-forward.png"
        animationDuration: 400
      }

   \endcode
 */
Image {
  id: root

  property alias animationDuration: opacityAnimation.duration

  source: ""
  visible: opacity != 0.0
  fillMode: Image.PreserveAspectFit
  mipmap: true
  opacity: 0.0

  sourceSize {
    width: SUtilities.dp(256)
    height: SUtilities.dp(256)
  }

  Behavior on opacity {
    PropertyAnimation {
      id: opacityAnimation
      duration: SConstants.sLongAnimationDuration
      easing.type: Easing.InQuad
    }
  }

  function show() {
    if (!visible) {
      root.opacity = 1.0
    }
  }

  function hide() {
    opacity = 0.0
  }
}
