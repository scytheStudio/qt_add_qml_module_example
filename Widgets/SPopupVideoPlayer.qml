// <copyright company="Scythe Studio Sp. z o.o.">
//     This file contains proprietary code. Copyright (c) 2021. All rights reserved.
// </copyright>

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import SGUILib.Utilities 1.0
import SGUILib.Basic 1.0

/*!
 * \brief SPopupVideoPlayer provides a popup with a video player.

    SPopupVideoPlayer can detect device rotation.
    It also has properties of maximizing/minimazing the player
    and expanding/shrinking of the popup.
    Video stops after closing the popup.

  Item supports following customization:
   - setting video source.
   - setting video name.
   - setting background color.

  Example of using SPopupVideoPlayer:
   \code
      SPopupVideoPlayer {
        id: popupPlayer

        width: parent.width
        height: parent.height
        backgroundColor: Theme.sBlack

        onClosed: {
          rotateButton.enabled = false
          popupPlayer.videoPlayer.stop()
        }
      }

   \endcode
 */

Popup {
  id: root

  property url    videoSource    : "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
  property string videoName      : "BigBuckBunny.mp4"
  property alias  videoPlayer    : player
  property alias  backgroundColor: back.color

  QtObject {
    id: _
    property bool isHorizontal          : false
    readonly property int  angleHorizont: 90
    readonly property real basicWidth   : root.width
    readonly property real basicHeight  : root.width  * player.heightWidthRatio
    readonly property real horizonWidth : root.height
    readonly property real horizonHeight: root.height * player.heightWidthRatio

    function rotate( horizont ) {
      player.width    = (horizont)? _.horizonWidth  : _.basicWidth
      player.height   = (horizont)? _.horizonHeight : _.basicHeight
      player.rotation = (horizont)? _.angleHorizont : 0
    }
  }

  modal: true
  focus: true
  enter: Transition {
    NumberAnimation {
      property: "opacity";
      from    : 0.0;
      to      : 1.0
    }
  }
  exit: Transition {
    NumberAnimation {
      property: "opacity";
      from    : 1.0;
      to      : 0.0
    }
  }
  background: Rectangle{
    id: back
    anchors.fill:parent
    color    : Theme.sBlack
    opacity  : 0.7
  }

  closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

  contentItem: SVideoPlayer{
    id: player
    anchors.centerIn: parent
    width : _.basicWidth
    height: _.basicHeight
    video.source: root.videoSource
    title.text  : root.videoName
    rotation    : 0
    closeButton.visible: true
    toolBarCustomization.backgroundColor: Theme.sTransparent

    onScreenRotated: function ( horizon) {
      _.isHorizontal = horizon
      _.rotate( _.isHorizontal)
    }

    onPressedCloseButton: function() {
      _.isHorizontal = false
      player.stop()
      _.rotate( _.isHorizontal)
      root.close()
    }

    Behavior on rotation {
      PropertyAnimation {
        duration: Constants.sDefaultAnimationDuration
      }
    }
  }
}
