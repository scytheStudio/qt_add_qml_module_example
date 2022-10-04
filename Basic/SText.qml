// <copyright company="Scythe Studio Sp. z o.o.">
//     This file contains proprietary code. Copyright (c) 2021. All rights reserved.
// </copyright>
import QtQuick 2.15

import Utilities


/*!
 * \brief Custom Text.

   A custom text based on standard QML Text.
   Implementation specifies wrap mode and elide property.
   SText can be used as any QML Text.

   Example of using SText:

   \code
      SText {
        id: txt
        anchors.centerIn: parent
        text: "Example SText :)"
      }
   \endcode
 */
Text {
    id: root

    font {
        pointSize: SConstants.sStandardTextPointSize
    }

    wrapMode: Text.WordWrap
    color: STheme.sWhite
    elide: Text.ElideRight
}
