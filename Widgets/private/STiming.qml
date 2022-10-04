// <copyright company="Scythe Studio Sp. z o.o.">
//     This file contains proprietary code. Copyright (c) 2021. All rights reserved.
// </copyright>
import QtQuick 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import Utilities


/*!
 * \brief STiming is the private item for reflecting of time duration in the string format.

   The object contains two properties:
      - durationNominal reflects the total duration of the vidio/audio/animation or other
        objects in milliseconds. The value should be positive integer or equal 0.
      - durationCurrent reflects the playback current position of the playing vidio/audio
       /animation or other objects in milliseconds. The value should be positive integer
       or equal 0.
   "Duration" properties are parsed to string via internal functions ( hours( duration )
   minutes( duration ), seconds( duration ) and setTiming( duration ).

   Item has extended text customization.\n
   Example of STiming usage:

   \code

      STiming {
        id: timing
        anchors.centerIn: parent

        width : SUtilities.dp(100)
        height: SUtilities.dp(20)

        durationNominal: 1000
        durationCurrent: 0
        textCustomization.color: STheme.sWhite
     }

   \endcode
 */
Item {
  id: root
  property int durationNominal: 1000
  property int durationCurrent: 0
  property alias textCustomization: txt

  QtObject {
    id: _
    property string durationHrs: hours(root.durationNominal / 1000)
    property string durationMin: minutes(root.durationNominal / 1000)
    property string durationSec: seconds(root.durationNominal / 1000)

    function hours(length) {
      return Math.floor(length / 3600)
    }

    function minutes(length) {
      var min = Math.floor(length / 60) % 60
      return (min < 10) ? "0" + min : min
    }

    function seconds(length) {
      var sec = Math.floor(length % 60)
      return (sec < 10) ? "0" + sec : sec
    }

    function setTiming(drtn) {
      var inSec = drtn / 1000
      if (root.durationNominal === 0) {
        return qsTr("00:00 / 00:00")
      }
      if (durationHrs === "0") {
        return qsTr(minutes(inSec) + ":" + seconds(
                      inSec) + " / " + _.durationMin + ":" + _.durationSec)
      }
      if (_.durationHrs !== "0") {
        return qsTr(hours(inSec) + ":" + minutes(
                      inSec) + ":" + seconds(inSec) + " / " + _.durationHrs
                    + ":" + _.durationMin + ":" + _.durationSec)
      }
    }
  }

  Text {
    id: txt
    anchors.fill: parent
    text: _.setTiming(root.durationCurrent)
    wrapMode: Text.NoWrap
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter
    fontSizeMode: Text.Fit
    color: STheme.sWhite
    minimumPointSize: SConstants.sStandardTextPointSize
  }

  Component.onCompleted: function () {
    root.durationCurrent = 0
  }
}
