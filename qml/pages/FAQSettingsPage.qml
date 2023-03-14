import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Felgo

import "../components"

DAppPage {
    title: "FAQ"

    navigationBarHidden: false

    ColumnLayout {
        anchors.fill: parent

        DText {
            text: ""
            font.pixelSize: appThemes.primaryFontSize
        }

        DText {
            text: ""
            font.pixelSize: appThemes.primaryFontSize
        }

        DText {
            text: "How to s"
            font.pixelSize: appThemes.primaryFontSize
        }
    }
}
