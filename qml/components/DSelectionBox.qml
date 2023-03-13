import QtQuick 2.15
import QtQuick.Layouts 1.15
import Felgo

Rectangle {
    id: root

    property alias text: text.text
    signal clicked();

    color: appThemes.cardColor
    radius: dp(4)

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.clicked()
        }
    }

    RowLayout {
        height: parent.height
        width: parent.width - dp(16)
        anchors.centerIn: parent

        DText {
            id: text

            Layout.fillHeight: true
            Layout.fillWidth: true
            font.pixelSize: dp(16)
            verticalAlignment: Text.AlignVCenter
        }

        Image {
            Layout.fillHeight: false
            Layout.fillWidth: false
            Layout.preferredHeight: dp(24)
            Layout.preferredWidth: dp(24)
            Layout.alignment: Qt.AlignRight
            source: appThemes.setIcon("dropDownIcon")
        }
    }
}
