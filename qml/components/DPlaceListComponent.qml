import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root

    color:"#124951"
    radius: appThemes.borderRadius

    property alias description: descriptionText.text
    property alias iconText1: iconText1.text
    property alias iconText2: iconText2.text
    property alias text: cityText.text
    property alias value: valueText.text

    property alias deleteModeOn: checkBox.visible

    signal clicked();
    signal longPress();


    DCheckBox {
        id: checkBox

        width: dp(24)
        height: dp(24)
        anchors.right: parent.right
        anchors.rightMargin: appThemes.margin
        anchors.top: parent.top
        anchors.topMargin: dp(8)
        visible: false
    }

    MouseArea {
        anchors.fill: parent

        onPressAndHold: {
            root.longPress();
        }

        onClicked: {
           root.clicked();
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: appThemes.margin

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.preferredHeight: parent.height * 0.4
            radius: appThemes.borderRadius
            color: appThemes.transparentColor

            DText {
                id: cityText

                anchors {
                    left: parent.left
                    leftMargin: dp(8)
                    verticalCenter: parent.verticalCenter
                }
                font.pixelSize: dp(24)
                font.bold: true
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: appThemes.transparentColor

            DText {
                id: valueText

                anchors {
                    top: parent.top
                    left: parent.left
                    leftMargin: dp(8)
                }
                font.pixelSize: appThemes.primaryFontSize
                font.bold: true
            }

            DText {
                id: descriptionText

                anchors {
                    bottom: parent.bottom
                    bottomMargin: appThemes.margin
                    left: parent.left
                    leftMargin: dp(8)
                }
                font.pixelSize: dp(12)
                font.bold: true
            }

            Image {
                width: dp(84)
                height: dp(84)
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    leftMargin: dp(114)
                }
                source: "../../assets/icons/bigpartlyCloudy"
            }


            Rectangle {
                id: sunriseItem

                width: dp(120)
                height: dp(32)
                anchors {
                    bottom: sunsetItem.top
                    right: parent.right
                    rightMargin: appThemes.margin
                }

                color: appThemes.transparentColor

                Image {
                    id: sunriseIcon

                    width: dp(24)
                    height: dp(24)
                    anchors {
                        bottom: parent.bottom
                        right: iconText1.left
                        rightMargin: dp(8)
                    }
                    source: "../../assets/icons/sunrise"
                }

                DText {
                    id: iconText1

                    anchors {
                        right: parent.right
                        bottom: parent.bottom
                    }
                    color: "#E2DFD2"
                    font.pixelSize: dp(12)
                    font.bold: true
                }
            }

            Rectangle {
                id: sunsetItem

                width: dp(120)
                height: dp(32)
                anchors {
                    bottom: parent.bottom
                    bottomMargin: appThemes.margin
                    right: parent.right
                    rightMargin: appThemes.margin
                }

                color: appThemes.transparentColor

                Image {
                    id: sunsetIcon

                    width: dp(24)
                    height: dp(24)
                    anchors {
                        bottom: parent.bottom
                        right: iconText2.left
                        rightMargin: dp(8)
                    }

                    source: "../../assets/icons/sunset"
                }

                DText {
                    id: iconText2

                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                    }
                    color: "#E2DFD2"
                    font.pixelSize: dp(12)
                    font.bold: true
                }
            }
        }
    }


}
