
import QtQuick
import Utilities
import Basic
import Widgets

Rectangle {
  id: root

  color: STheme.sBackgroundGreen

  Column {
    anchors.centerIn: parent

    spacing: SUtilities.dp(20)

    SText {
      id: text

      anchors.horizontalCenter: parent.horizontalCenter

      text: "Factorial(4) = " + Helper.factorial(4)
    }

    SButton {
      id: button

      anchors.horizontalCenter: parent.horizontalCenter

      width: 100
      height: 40
    }

    SVideoPlayer {
      id: videoPlayer

      anchors.horizontalCenter: parent.horizontalCenter

      width: height * (16 / 9)
      height: 200
    }

    SignPad {
      id: signPad

      anchors.horizontalCenter: parent.horizontalCenter

      width: 300
      height: 100

      penColor: STheme.sGreen
      penWidth: 5
    }
  }


}
