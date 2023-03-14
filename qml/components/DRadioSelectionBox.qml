import QtQuick 2.15
import QtQuick.Layouts 1.15
import Felgo

Rectangle {
    id: root

    property alias text: text.text
    property bool selected: false
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
        spacing: appThemes.margin

        Item {
            Layout.fillHeight: false
            Layout.fillWidth: false
            Layout.preferredHeight: dp(16)
            Layout.preferredWidth: dp(16)

            Rectangle {
                height: dp(16)
                width: dp(16)
                radius: dp(16)
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    width: parent.width / 2
                    height: parent.height / 2
                    radius: width / 2
                    anchors.centerIn: parent
                    color: "#06A67C"
                    visible: root.selected
                }
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            DText {
                id: text

                text:"Hello"
                font.pixelSize: dp(16)
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter

            }
        }
    }
}
