// <copyright company="Scythe Studio Sp. z o.o.">
//     This file contains proprietary code. Copyright (c) 2021. All rights reserved.
// </copyright>
import QtQuick
import QtQuick.Controls

import Utilities
import Basic


/*!
 * \brief SVideoToolBar is private item for SVideoPlayer widget.

   Item contains control buttons for video player, sliders for navigation and volume setting,
   and timing string.
   SVideoToolBar supports customization of all control elements.

   Example of using SVideoToolBar:

   \code
      SVideoToolBar {
        id: toolBar
        anchors.centerIn: parent
        width: SUtilities.dp(200)
        height: SUtilities.dp(200)

        timingString.durationNominal: videoFile.duration
        timingString.durationCurrent: videoFile.position
        mobileModeOn: false

        playPauseButton.enabled: true

        source: "qrc:/scythestudio.com/imports/Widgets/assets/ssLogoWhite.png"
      }
   \endcode
 */
Item {
  id: root

  property alias playPauseButton: buttonPlay
  property alias nextButton: buttonNext
  property alias previousButton: buttonPrevious
  property alias muteButton: buttonVolume
  property alias fullScreenButton: buttonFullScreen
  property alias timingString: timing
  property alias volumeSlider: sliderVolume
  property alias videoSlider: sliderVideo
  property alias animation: opacityAnimation
  property bool playOn: false
  property bool mobileModeOn: false
  property alias horizonOn: _.isHorizon
  property alias muteOn: _.isMuted
  property real buttonSize: SUtilities.dp(40)
  property int buttonTopMargin: SUtilities.dp(5)
  property int buttonSideMargin: SUtilities.dp(15)
  property alias backgroundColor: background.color
  property bool toolBarHovered: false

  signal playPausePressed
  signal nextPressed
  signal previousPressed
  signal volumeMuted(var mute)
  signal fullScreenEntered(var horizon)
  signal volumeSliderMoved(var volume)
  signal videoSliderMoved(var position)
  signal activityDetected

  QtObject {
    id: _
    property url currentVolumeImage: "qrc:/scythestudio.com/imports/Widgets/assets/icon-volume-up.svg"
    property real currentVolumeValue: 0.0
    property bool isPlay: root.playOn
    property bool isHorizon: false
    property bool isMuted: false

    function updateVolumeImage(value) {
      if (value === 0) {
        buttonVolume.source = "qrc:/scythestudio.com/imports/Widgets/assets/icon-mute.svg"
      }
      if (value > 0 && value < 50) {
        buttonVolume.source = "qrc:/scythestudio.com/imports/Widgets/assets/icon-volume-down.svg"
      }
      if (value >= 50) {
        buttonVolume.source = "qrc:/scythestudio.com/imports/Widgets/assets/icon-volume-up.svg"
      }
    }

    onIsHorizonChanged: function () {
      buttonFullScreen.checked = _.isHorizon
      root.fullScreenEntered(_.isHorizon)
    }
  }

  height: sliderVideo.height + buttonPlay.height + buttonPlay.anchors.topMargin
  visible: root.opacity != 0.0

  Rectangle {
    id: background
    anchors.fill: parent
    color: STheme.sBlack
  }

  Behavior on opacity {
    PropertyAnimation {
      id: opacityAnimation
      duration: SConstants.sDefaultAnimationDuration
      easing.type: Easing.InQuad
    }
  }

  SSlider {
    id: sliderVideo
    anchors {
      top: parent.top
      left: parent.left
      right: parent.right
    }
    height: SUtilities.dp(10)
    from: 0
    to: timing.durationNominal
    value: timing.durationCurrent
    heightHandler: SUtilities.dp(20)
    heightBackground: SUtilities.dp(10)

    onValueChanged: function (value) {
      root.videoSliderMoved(value)
      timing.durationCurrent = value
      root.activityDetected()
    }

    onHoveredChanged: function () {
      toolBarHovered = sliderVideo.hovered
    }
  }

  SImageButton {
    id: buttonPrevious
    anchors {
      top: sliderVideo.bottom
      topMargin: buttonTopMargin
      left: parent.left
      leftMargin: visible ? buttonSideMargin : 0
    }
    width: visible ? buttonSize : 0
    height: buttonSize
    visible: false
    source: "qrc:/scythestudio.com/imports/Widgets/assets/icon-back.svg"
    backroundRectangle.color: background.color
    verticalPadding: SUtilities.dp(5)
    horizontalPadding: SUtilities.dp(5)

    onClicked: function () {
      root.previousPressed()
      root.activityDetected()
    }

    onHoveredChanged: function () {
      toolBarHovered = buttonPrevious.hovered
    }
  }

  SToggleButton {
    id: buttonPlay
    anchors {
      top: sliderVideo.bottom
      topMargin: buttonTopMargin
      left: buttonPrevious.right
      leftMargin: buttonSideMargin
      bottom: parent.bottom
    }
    width: buttonSize
    height: buttonSize
    source: "qrc:/scythestudio.com/imports/Widgets/assets/icon-play.svg"
    sourceToggled: "qrc:/scythestudio.com/imports/Widgets/assets/icon-pause.svg"
    backgroundColor: background.color
    verticalPadding: SUtilities.dp(5)
    horizontalPadding: SUtilities.dp(5)

    onToggled: function () {
      root.playPausePressed()
      root.activityDetected()
    }

    onHoveredChanged: function () {
      toolBarHovered = buttonPlay.hovered
    }
  }

  SImageButton {
    id: buttonNext
    anchors {
      top: sliderVideo.bottom
      topMargin: buttonTopMargin
      left: buttonPlay.right
      leftMargin: visible ? buttonSideMargin : 0
    }
    width: visible ? buttonSize : 0
    height: buttonSize
    visible: false
    source: "qrc:/scythestudio.com/imports/Widgets/assets/icon-next.svg"
    backroundRectangle.color: background.color
    verticalPadding: SUtilities.dp(5)
    horizontalPadding: SUtilities.dp(5)

    onClicked: function () {
      root.nextPressed()
      root.activityDetected()
    }

    onHoveredChanged: function () {
      toolBarHovered = buttonNext.hovered
    }
  }

  SImageButton {
    id: buttonVolume
    anchors {
      top: sliderVideo.bottom
      topMargin: buttonTopMargin
      left: buttonNext.right
      leftMargin: buttonSideMargin
    }
    width: buttonSize
    height: buttonSize
    source: "qrc:/scythestudio.com/imports/Widgets/assets/icon-volume-up.svg"
    backroundRectangle.color: background.color
    verticalPadding: SUtilities.dp(5)
    horizontalPadding: SUtilities.dp(5)

    onClicked: function () {
      _.isMuted = !_.isMuted

      if (!_.isMuted) {
        buttonVolume.source = _.currentVolumeImage
        sliderVolume.value = _.currentVolumeValue
        _.updateVolumeImage(sliderVolume.value)
      } else {
        _.currentVolumeImage = buttonVolume.source
        _.currentVolumeValue = sliderVolume.value
        sliderVolume.value = 0.0
        _.updateVolumeImage(sliderVolume.value)
      }
      root.volumeMuted(_.isMuted)
      root.activityDetected()
    }

    onHoveredChanged: function () {
      toolBarHovered = buttonVolume.hovered
    }
  }

  SSlider {
    id: sliderVolume
    anchors {
      verticalCenter: buttonVolume.verticalCenter
      left: buttonVolume.right
      leftMargin: buttonSideMargin
    }
    width: SUtilities.dp(100)
    height: SUtilities.dp(10)
    from: 0
    to: 100
    heightHandler: SUtilities.dp(20)
    heightBackground: SUtilities.dp(10)

    onValueChanged: function (value) {
      _.updateVolumeImage(value)
      root.volumeSliderMoved(value / to)
      root.activityDetected()
    }

    onHoveredChanged: function () {
      toolBarHovered = sliderVolume.hovered
    }
  }

  STiming {
    id: timing
    anchors {
      bottom: sliderVideo.top
      bottomMargin: SUtilities.dp(15)
      right: parent.right
      rightMargin: SUtilities.dp(10)
      left: parent.left
    }
    durationNominal: 1000
    durationCurrent: 0
  }

  SToggleButton {
    id: buttonFullScreen

    anchors {
      top: sliderVideo.bottom
      topMargin: buttonTopMargin
      right: root.right
      rightMargin: buttonSideMargin
    }
    width: buttonSize
    height: buttonSize
    verticalPadding: SUtilities.dp(5)
    horizontalPadding: SUtilities.dp(5)
    source: "qrc:/scythestudio.com/imports/Widgets/assets/icon-full-screen-open.svg"
    sourceToggled: "qrc:/scythestudio.com/imports/Widgets/assets/icon-full-screen-close.svg"
    backgroundColor: background.color

    onToggled: function () {
      _.isHorizon = !_.isHorizon
      root.activityDetected()
    }

    onHoveredChanged: function () {
      toolBarHovered = buttonFullScreen.hovered
    }
  }

  //    OrientationSensor {
  //        id: rotationSensor
  //        active: false
  //        onReadingChanged: function () {
  //            if (reading.orientation === OrientationReading.TopUp
  //                    || reading.orientation === OrientationReading.FaceUp) {
  //                _.isHorizon = false
  //            } else {
  //                _.isHorizon = true
  //            }
  //            buttonFullScreen.checked = _.isHorizon
  //            root.fullScreenEntered(_.isHorizon)
  //        }

  //        Component.onCompleted: function () {
  //            if (mobileModeOn) {
  //                rotationSensor.start()
  //            }
  //        }
  //    }
  onPlayOnChanged: function () {
    _.isPlay = !_.isPlay
    buttonPlay.checked = _.isPlay
  }

  function show() {
    if (!visible) {
      root.opacity = 1.0
    }
  }

  function hide() {
    root.opacity = 0.0
  }
}
