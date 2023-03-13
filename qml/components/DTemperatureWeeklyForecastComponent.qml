import QtQuick 2.12
import QtQuick.Layouts 1.15

Item {
    id: root

    property string icon;
    property alias time: timeValueText.text
    property alias maxTemperature: highestTemperatureText.text
    property alias minTemperature: lowestTemperatureText.text
    property alias backgroundColor: frame.color

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
                    source: appThemes.setIcon(root.icon)
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Image {
                        id: highestTemperatureIcon

                        width: dp(18)
                        height: dp(18)
                        anchors {
                            left: parent.left
                            leftMargin: dp(2)
                            verticalCenter: parent.verticalCenter
                        }
                        source: appThemes.setIcon("arrowIcon")
                        rotation: 180
                    }

                    DText {
                        id: highestTemperatureText

                        anchors {
                            left: highestTemperatureIcon.right
                            verticalCenter: parent.verticalCenter
                        }
                        color: appThemes.primaryTextColor
                        font.pixelSize: appThemes.primaryFontSize
                        font.bold: true
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Image {
                        id: lowestTemperatureIcon

                        width: dp(18)
                        height: dp(18)
                        anchors {
                            right: parent.right
                            rightMargin: dp(2)
                            verticalCenter: parent.verticalCenter
                        }
                        source: appThemes.setIcon("arrowIcon")
                    }

                    DText {
                        id: lowestTemperatureText

                        anchors {
                            right: lowestTemperatureIcon.left
                            verticalCenter: parent.verticalCenter
                        }
                        color: appThemes.primaryTextColor
                        font.pixelSize: appThemes.primaryFontSize
                        font.bold: true
                    }
                }
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
