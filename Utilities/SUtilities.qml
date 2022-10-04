// <copyright company="Scythe Studio Sp. z o.o.">
//     This file contains proprietary code. Copyright (c) 2021. All rights reserved.
// </copyright>
pragma Singleton

import QtQuick
import QtQuick.Window


/*!
 * \brief SUtilities is used as a single/unique storage for calculating dpi
    or other commonly-used functions.

   Settings and registering:\n
   main.cpp
   \code
      //Registering objects in QML engine
      qmlRegisterSingletonType(QUrl("qrc:/Utilities/SUtilities.qml"), "UtilitiesList", 1,0, "Utilities" );
   \endcode

   qmldir
   \code
      singleton Utilities 1.0 SUtilities.qml
   \endcode

    Example of usage:
   \code
      import UtilitiesList 1.0

      SButton {
        id: button
        property var counter: 0

        anchors.centerIn: parent
        width: SUtilities.dp(200)
        height: SUtilities.dp(100)
        text: counter

        onClicked: function() {
          counter++
        }
      }

   \endcode
 */

//Qtobject for all helping functions
QtObject {
  id: root
  readonly property real milimitersToInchRatio: 25.4
  readonly property real dpi: Screen.pixelDensity * root.milimitersToInchRatio
  readonly property real standardDensity: 160
  readonly property real activeToStandardDpiRatio: root.dpi / root.standardDensity


  /**
    \brief Function for calulating density independet pixels.
    Desired logical size is passed as parameter, then it is multiplied by pixel density of the screen.
    Due to pixel desity unit (dots per milimeter) value needs to be multiplied by 25.4 to get
    number of dots per inch. After that value needs to be devided by 160 which is standard screen desity.
    @param pixels Pixel size to calculate for density pixels.
  */
  function dp(pixels) {
    return pixels * root.activeToStandardDpiRatio
  }
}
