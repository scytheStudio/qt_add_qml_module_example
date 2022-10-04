// <copyright company="Scythe Studio Sp. z o.o.">
//     This file contains proprietary code. Copyright (c) 2021. All rights reserved.
// </copyright>
import QtMultimedia
import QtQuick.Controls 2.15
import QtQuick 2.15
import Utilities
import Basic
import Widgets


/*!
 * \brief SVideoPlayer is a video player widget.

  Player supports play/pause functions, open/close full screen,
  double-tap to rewind or forward the video (can be disabled).

  SVideoPlayer supports following customization:
   - customizing toolbar.
   - customizing play button in the center of the screen.
   - setting title (as the text customization).
   - setting forward/rewind image source.

  The user can also set:
   - the color of the background.
   - ratio between height and width of the screen (for example 9:16).
   - time adjustment interval (in miliseconds).

  Example of using SVideoPlayer:
   \code

      SVideoPlayer {
        id: player
        anchors {
          top: parent.top
          horizontalCenter: parent.horizontalCenter
          topMargin: SUtilities.dp(100)
        }
        width : SUtilities.dp(400)
        height: SUtilities.dp(225)
        backgroundColor: STheme.sBlack
        title.text : qsTr("BigBuckBunny.mp4")
        sourceVideo: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        timingAdjustmentMode: true
        timingAdjustmentInterval: 1000
        toolBarCustomization.nextButton.visible: true
        toolBarCustomization.previousButton.visible: true
        toolBarCustomization.backgroundColor: STheme.sTransparent

        toolBarCustomization.onFullScreenEntered: {
          player.width  = (horizon)? SUtilities.dp(500): SUtilities.dp(400)
          player.height = (horizon)? player.width * player.heightWidthRatio : SUtilities.dp(225)
        }
      }

   \endcode

   WARNING: On Windows the QML Video item is lacking the MP4 codec. You need to install codec like KLiteKodec.\n
   You can get it here: https://codecguide.com/download_kl.htm

 */
Item {
  id: root

  property alias video: videoFile
  property alias title: title
  property alias toolBarCustomization: tool
  property alias backgroundColor: playerBackground.color
  property alias playButton: buttonPlay
  property real heightWidthRatio: 9 / 16
  property alias titleAnimation: titleOpacityAnimation
  property alias playButtonAnimation: playButtonOpacityAnimation
  property real playButtonExpandWidth: SUtilities.dp(60)
  property real playButtonNominalWidth: SUtilities.dp(50)
  property bool timingAdjustmentMode: false
  property int timingAdjustmentInterval: 1000
  property alias rewindSource: imgRewind.source
  property alias forwardSource: imgForward.source
  property alias closeButton: buttonClose
  property alias rewindCustomization: imgRewind
  property alias forwardCustomization: imgForward

  signal screenRotated(var horizon)
  signal screenExpanded(var horizon)
  signal pressedCloseButton

  QtObject {
    id: _
    property bool isFullScreen: false
    property bool isPlayed: false
    property real timeAdjustmentMarginRatio: 0.1

    function playPause() {
      _.isPlayed = !_.isPlayed
      if (_.isPlayed) {
        videoFile.play()
        buttonPlay.hide()
      } else {
        videoFile.pause()
        buttonPlay.show()
      }
      tool.playOn = _.isPlayed
      buttonPlay.checked = tool.playPauseButton.checked
    }

    function switchToHorizon(horizon) {
      root.screenRotated(horizon)
    }

    function expandScreen(expand) {
      root.screenExpanded(expand)
    }

    function isBlindSpot(coordX, coordY) {
      if (coordX < msAreaScreen.width && coordY < msAreaScreen.height
          && !msAreaScreen.containsMouse) {
        return true
      }
      return false
    }

    function setVisibleToolBar(coordX, coordY) {
      tool.show()
      title.show()
      buttonPlay.show()
      buttonClose.show()
      if (coordY > (msAreaScreen.height - tool.height)) {
        timerInvisible.stop()
        return
      }
      timerInvisible.restart()
    }
  }

  Rectangle {
    id: playerBackground
    anchors.fill: videoFile
    color: STheme.sBlack
  }

  Video {
    id: videoFile

    signal changedPosition(var position)

    anchors {
      left: root.left
      right: root.right
      verticalCenter: parent.verticalCenter
    }
    width: parent.width
    height: width * heightWidthRatio
    source: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    fillMode: VideoOutput.PreserveAspectFit

    // not supported in Qt 6.2 yet.
    //    flushMode: VideoOutput.FirstFrame
    //    autoLoad : true
    //    autoPlay : false
    onPositionChanged: function () {
      changedPosition(position)
    }
  }

  BusyIndicator {
    id: busyInd
    anchors.fill: buttonPlay
    visible: videoFile.duration === 0
    running: visible
  }

  Text {
    id: title
    anchors {
      top: videoFile.top
      topMargin: SUtilities.dp(10)
      left: root.left
      leftMargin: SUtilities.dp(10)
    }
    text: qsTr("Video Title")
    wrapMode: Text.WordWrap
    fontSizeMode: Text.Fit
    visible: title.opacity != 0.0
    color: STheme.sWhite
    minimumPixelSize: SConstants.sBigTextPointSize
    font.bold: true

    Behavior on opacity {
      PropertyAnimation {
        id: titleOpacityAnimation
        duration: SConstants.sDefaultAnimationDuration
        easing.type: Easing.InQuad
      }
    }

    function show() {
      title.opacity = 1.0
    }

    function hide() {
      title.opacity = 0.0
    }
  }

  SVideoPlayerAnimatedImage {
    id: imgRewind
    anchors {
      verticalCenter: buttonPlay.verticalCenter
      right: buttonPlay.left
      rightMargin: root.width * _.timeAdjustmentMarginRatio
    }
    width: root.playButtonNominalWidth
    height: width
    source: "qrc:/scythestudio.com/imports/Widgets/assets/icon-rewind.svg"
  }

  SVideoPlayerAnimatedImage {
    id: imgForward
    anchors {
      verticalCenter: buttonPlay.verticalCenter
      left: buttonPlay.right
      leftMargin: root.width * _.timeAdjustmentMarginRatio
    }
    width: root.playButtonNominalWidth
    height: width
    source: "qrc:/scythestudio.com/imports/Widgets/assets/icon-forward.svg"
  }

  MouseArea {
    id: msAreaScreen

    anchors {
      left: videoFile.left
      right: videoFile.right
      top: videoFile.top
      bottom: videoFile.bottom
    }
    hoverEnabled: true

    onEntered: function () {
      _.setVisibleToolBar(mouseX, mouseY)
    }

    onExited: function () {
      if (tool.toolBarHovered) {
        timerInvisible.stop()
      } else {
        timerInvisible.restart()
      }
    }

    onPositionChanged: function (mouse) {
      _.setVisibleToolBar(mouseX, mouseY)
    }

    onClicked: function (mouse) {
      if (!timingAdjustmentMode) {
        _.playPause()
      }
    }

    onPressAndHold: function (mouse) {
      videoFile.stop()
    }

    onPressed: function (mouse) {
      tool.show()
      title.show()
      buttonClose.show()
      timerInvisible.restart()
    }

    onDoubleClicked: function (mouse) {
      var currentPosition = videoFile.position
      if (timingAdjustmentMode) {
        if (mouseX > root.width / 2) {
          imgForward.show()
          toPosition(
                (currentPosition + root.timingAdjustmentInterval
                 < videoFile.duration) ? currentPosition
                                         + root.timingAdjustmentInterval : videoFile.duration)
        } else {
          imgRewind.show()
          toPosition(currentPosition - root.timingAdjustmentInterval)
        }
        timerRewindForward.start()
      }
    }
  }

  SToggleButton {
    id: buttonPlay
    anchors.centerIn: root
    visible: !busyInd.visible
    width: root.playButtonNominalWidth
    height: width
    source: "qrc:/scythestudio.com/imports/Widgets/assets/icon-play.svg"
    backroundRectangle.color: STheme.sTransparent

    padding: tool.playPauseButton.padding
    hoverEnabled: true
    sourceToggled: "qrc:/scythestudio.com/imports/Widgets/assets/icon-pause.svg"
    backgroundColor: STheme.sTransparent

    Behavior on width {
      PropertyAnimation {
        id: playButtonWidthAnimation
        duration: SConstants.sDefaultAnimationDuration
      }
    }

    Behavior on opacity {
      PropertyAnimation {
        id: playButtonOpacityAnimation
        duration: SConstants.sDefaultAnimationDuration
      }
    }

    onToggled: function () {
      _.playPause()
    }

    onHoveredChanged: function () {
      width = (hovered) ? root.playButtonExpandWidth : root.playButtonNominalWidth
    }
  }

  SImageButton {
    id: buttonClose
    anchors {
      verticalCenter: title.verticalCenter
      right: videoFile.right
      rightMargin: SUtilities.dp(10)
    }
    visible: false
    enabled: visible
    width: SUtilities.dp(30)
    height: width
    source: "qrc:/scythestudio.com/imports/Widgets/assets/icon-close.svg"
    backroundRectangle.color: STheme.sTransparent

    Behavior on opacity {
      PropertyAnimation {
        id: playCloseOpacityAnimation
        duration: SConstants.sDefaultAnimationDuration
      }
    }

    onClicked: function () {
      root.pressedCloseButton()
    }

    function show() {
      opacity = 1.0
    }

    function hide() {
      opacity = 0.0
    }
  }

  SVideoToolBar {
    id: tool
    anchors {
      left: parent.left
      right: parent.right
      bottom: videoFile.bottom
    }

    opacity: 1.0
    timingString.durationNominal: videoFile.duration
    timingString.durationCurrent: videoFile.position
    timingString.textCustomization.font.pointSize: (timingString.implicitWidth > tool.implicitWidth / 2) ? SConstants.sSmallTextPointSize : SConstants.sStandardTextPointSize

    playPauseButton.enabled: !busyInd.visible
    playPauseButton.opacity: 1.0
    playPauseButton.padding: SUtilities.dp(7)
    fullScreenButton.padding: SUtilities.dp(7)
    backgroundColor: playerBackground.color
    volumeSlider.value: videoFile.volume * volumeSlider.to
    videoSlider.enabled: !busyInd.visible

    onToolBarHoveredChanged: function () {
      if (tool.toolBarHovered) {
        timerInvisible.stop()
      } else {
        timerInvisible.restart()
      }
    }
  }

  Timer {
    id: timerInvisible
    interval: 3000
    running: false
    onTriggered: function () {
      tool.hide()
      title.hide()
      buttonPlay.hide()
      buttonClose.hide()
    }
  }

  Timer {
    id: timerRewindForward
    interval: 500
    running: false
    onTriggered: function () {
      imgRewind.hide()
      imgForward.hide()
    }
  }

  Connections {
    target: tool
    function onPlayPausePressed() {
      _.playPause()
    }

    function onVolumeMuted(mute) {
      videoFile.muted = mute
    }

    function onFullScreenEntered(horizon) {
      _.switchToHorizon(horizon)
    }

    function onVolumeSliderMoved(volume) {
      videoFile.volume = volume
      videoFile.muted = false
      tool.muteOn = false
    }

    function onVideoSliderMoved(position) {
      toPosition(position)
    }

    function onActivityDetected() {
      tool.show()
      timerInvisible.restart()
    }
  }

  Connections {
    target: videoFile
    function onChangedPosition(position) {
      tool.timingString.durationCurrent = position
      tool.videoSlider.value = position
      if (position == videoFile.duration) {
        buttonPlay.checked = false
        tool.playPauseButton.checked = false
        tool.show()
        buttonPlay.show()
        buttonClose.show()
      }
    }
  }


  /*!
   * \brief Stops the video.
   */
  function stop() {
    videoFile.stop()
    tool.playPauseButton.checked = false
    tool.fullScreenButton.checked = false
    tool.playOn = false
    buttonPlay.checked = false
  }


  /*!
   * \brief Sets playback position of the video.
   */
  function toPosition(position) {
    videoFile.position = position
  }
}
