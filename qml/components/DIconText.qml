import QtQuick 2.15
import QtQuick.Layouts 1.15

RowLayout {
    id: root

    spacing: appThemes.doubleMargin

    property string icon: ""
    property alias text: text.text

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


            font.pixelSize: dp(20)
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
    }
}
