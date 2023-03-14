import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: root

    property string icon: ""
    property alias text: text.text

    signal clicked();

    MouseArea {
        anchors.fill: parent

        onClicked: {
            root.clicked();
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: appThemes.doubleMargin

        Image {
            id: icon

            Layout.fillHeight: false
            Layout.fillWidth: false
            Layout.preferredWidth: dp(24)
            Layout.preferredHeight: dp(24)
            source: appThemes.setIcon(root.icon)
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            DText {
                id: text


                font.pixelSize: dp(16)
                text: "Cities"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Image {
            Layout.fillHeight: false
            Layout.fillWidth: false
            Layout.preferredWidth: dp(32)
            Layout.preferredHeight: dp(32)
            Layout.alignment: Qt.AlignRight
            source: appThemes.setIcon("dropDownIcon")
            rotation: -90
        }
    }
}

