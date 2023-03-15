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
            text: qsTr("HomePage")
            icon: "homeWhiteIcon"
        }

        ListElement {
            text: qsTr("FAQ")
            icon: "faqIcon"
        }

        ListElement {
            text: qsTr("Credits")
            icon: "creditsIcon"
        }
    }

    ColumnLayout {
        width: parent.width - appThemes.doubleMargin
        height: parent.height - appThemes.doubleMargin
        anchors.centerIn: parent

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                width: parent.width
                height: parent.height
                model: settingsListModel
                spacing: appThemes.margin
                delegate: DIconText {
                    width: parent.width
                    height: dp(48)

                    icon: model.icon
                    text: model.text

                    onClicked: {
                        navStack.push(settingsPages[index])
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.preferredHeight: parent.height * 0.25

            ColumnLayout {
                width: parent.width
                height: dp(32)
                anchors.bottom: parent.bottom

                DText {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: qsTr("Made By Shrinidhi Upadhyaya")
                    font.pixelSize: dp(12)
                    horizontalAlignment: Text.AlignHCenter
                }

                DText {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: qsTr("V1.0")
                    font.pixelSize: dp(12)
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }

    function initPages() {
        page.settingsPages[0] = Qt.createComponent("CitiesSettingsPage.qml");
        page.settingsPages[1] = Qt.createComponent("FAQSettingsPage.qml");
        page.settingsPages[2] = Qt.createComponent("CreditsSettingsPage.qml");
    }

    Component.onCompleted: {
        page.initPages();
    }
}
