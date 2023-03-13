import Felgo
import QtQuick 2.15

Item {
    id: root

    property alias label: label.text
    property alias value: value.text

    Column {
        anchors.fill: parent

        DText {
            id: label

            font.pixelSize: appThemes.primaryFontSize
            color: appThemes.secondaryTextColor
        }

        DText {
            id: value

            font.pixelSize: appThemes.primaryFontSize
            font.bold: true
            color: appThemes.primaryTextColor
        }
    }
}
