import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Felgo

import "../components"

DAppPage {
    id: page

    property var settingsPages: []

    ListModel {
        id: settingsListModel

        ListElement {
            text: "HomePage"
            icon: "homeWhiteIcon"
        }

        ListElement {
            text: "FAQ"
            icon: "faqIcon"
        }

        ListElement {
            text: "Credits"
            icon: "creditsIcon"
        }
    }

    ColumnLayout {
        width: parent.width - appThemes.doubleMargin
        height: parent.height - appThemes.doubleMargin
        anchors.centerIn: parent

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            ListView {
                width: parent.width
                height: parent.height
                model: settingsListModel
                spacing: appThemes.margin
                delegate: DIconText {
                    width: parent.width
                    height: dp(48)

                    Rectangle {
                        anchors.fill: parent
                        color:"transparent"
                        border.color: "red"
                    }

                    icon: model.icon
                    text: model.text

                    onClicked: {
                        navStack.push(settingsPages[index])
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: false
            Layout.preferredHeight: parent.height * 0.25
            Layout.fillWidth: true

            ColumnLayout {
                width: parent.width
                height: dp(32)
                anchors.bottom: parent.bottom
                DText {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    text: "Made By Shrinidhi Upadhyaya"
                    font.pixelSize: dp(12)
                    horizontalAlignment: Text.AlignHCenter
                }

                DText {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    text: "V1.0"
                    font.pixelSize: dp(12)
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }



    function initPages() {
        settingsPages[0] = Qt.createComponent("CitiesSettingsPage.qml");
        settingsPages[1] = Qt.createComponent("FAQSettingsPage.qml");
        settingsPages[2] = Qt.createComponent("CreditsSettingsPage.qml");
    }

    Component.onCompleted: {
        page.initPages();
    }
}
