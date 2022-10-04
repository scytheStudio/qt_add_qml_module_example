// <copyright company="Scythe Studio Sp. z o.o.">
//     This file contains proprietary code. Copyright (c) 2021. All rights reserved.
// </copyright>
pragma Singleton

import QtQuick


/*!
 * \brief STheme is used as a single/unique storage for all constants related to colors

   Settings and registering:\n
   main.cpp
   \code
      //Registering objects in QML engine
      qmlRegisterSingletonType(QUrl("qrc:/Utilities/STheme.qml"), "ThemeStyles"  , 1,0, "Theme" );
   \endcode

   qmldir
   \code
      singleton Theme 1.0 STheme.qml
   \endcode

    Example of usage:
   \code
      import ThemeStyles 1.0

      SText {
        id: txt
        anchors.centerIn: parent
        text: "Example SText :)"
        color: Theme.sWhite
      }

   \endcode
 */
QtObject {

  readonly property color sBackgroundBlack: "#070d0c"
  readonly property color sBackgroundGreen: "#1a3330"
  readonly property color sBackgroundGray: "#4a4a4a"
  readonly property color sWhite: "#ffffff"
  readonly property color sBlack: "#000000"
  readonly property color sGreen: "#218165"
  readonly property color sTransparent: "transparent"
  readonly property color sRed: "#ff0000"
  readonly property color sPressedGreen: "#114f3c"
  readonly property color sMagenta: "#ff00ff"
  readonly property color sBlue: "#0000ff"
  readonly property color sLightGreen: "#32cd32"
}
