// <copyright company="Scythe Studio Sp. z o.o.">
//     This file contains proprietary code. Copyright (c) 2021. All rights reserved.
// </copyright>
pragma Singleton

import QtQuick


/*!
 * \brief SConstants is used as a single/unique storage for all constants related to sizes, duration etc.

   Settings and registering:\n
   main.cpp
   \code
      //Registering objects in QML engine
      qmlRegisterSingletonType(QUrl("qrc:/Utilities/SConstants.qml"), "ConstantsList", 1,0, "Constants" );
   \endcode

   qmldir
   \code
      singleton Constants 1.0 SConstants.qml
   \endcode

    Example of using SConstants:
   \code
      import ConstantsList 1.0

      SButton {
        id: button
        property var counter: 0

        anchors.centerIn: parent
        width: SUtilities.dp(200)
        height: SUtilities.dp(100)
        text: counter
        fontPointSize: Constants.sBigTextPointSize

        onClicked: function() {
          counter++
        }
      }

   \endcode
 */
QtObject {
  id: root

  readonly property int sDefaultAnimationDuration: 200
  readonly property int sLongAnimationDuration: 400

  readonly property int sSmallTextPointSize: 8
  readonly property int sStandardTextPointSize: 12
  readonly property int sBigTextPointSize: 16
  readonly property int sSmallBorderSize: 1
  readonly property int sStandardBorderSize: 2
  readonly property int sBigBorderSize: 3
  readonly property real sPressedOpacity: 0.5
  readonly property real sHoveredOpacity: 0.85
  readonly property int sStandardRadiusSize: 10
  readonly property real sDisabledOpacity: 0.5
}
