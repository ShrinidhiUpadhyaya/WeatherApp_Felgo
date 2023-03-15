import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Felgo

import "../components"

DAppPage {
    title: qsTr("Credits")

    navigationBarHidden: false

    Item {
        width: parent.width - appThemes.doubleMargin
        height: parent.height - appThemes.doubleMargin
        anchors.centerIn: parent

        DText {
            text: qsTr("API Used: ") + '<html><style type="text/css"></style><a href="https://open-meteo.com/">OpenMateo</a></html>'
            font.pixelSize: appThemes.primaryFontSize

            onLinkActivated: Qt.openUrlExternally(link)
        }
    }


}
