import QtQuick 2.12
import QtQuick.Layouts 1.15

Item {
    id: root

    property alias backgroundColor: frame.color
    property alias temperature: temperatureValueText.text
    property alias time: timeValueText.text

    property string icon;

    signal clicked();

    Rectangle {
        id: frame

        width: parent.width * 0.8
        height: parent.height / 1.2
        anchors.centerIn: parent
        radius: appThemes.borderRadius
        border.color: appThemes.frameBorderColor

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            DText {
                id: timeValueText

                Layout.fillWidth: true
                Layout.fillHeight: false
                Layout.preferredHeight: parent.height * 0.3
                font.pixelSize: appThemes.primaryFontSize
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: false
                Layout.preferredHeight: parent.height * 0.3

                Image {
                    width: dp(32)
                    height: dp(32)
                    anchors.centerIn: parent
                    source: "../../assets/icons/" + root.icon
                }
            }

            DText {
                id: temperatureValueText

                Layout.fillWidth: true
                Layout.fillHeight: true
                font.pixelSize: dp(24)
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }


    MouseArea {
        anchors.fill: parent

        onClicked: {
            root.clicked();
        }
    }
}
