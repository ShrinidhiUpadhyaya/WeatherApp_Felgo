import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Felgo

import "../components"

DAppPage {
    title: qsTr("FAQ")

    navigationBarHidden: false

    ColumnLayout {
        width: parent.width - appThemes.doubleMargin
        height: parent.height - appThemes.doubleMargin
        anchors.centerIn: parent

        Column {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: dp(2)
            DText {
                width: parent.width
                text: "How to add a place?"
                font.pixelSize: appThemes.primaryFontSize
            }

            DText {
                width: parent.width
                text: "Go to Cities Screen, Click on '+' button, a popup will appear, search for a city you need. Then click on the city you want. It will be added to your list."
                font.pixelSize: dp(12)
                wrapMode: Text.WordWrap
                leftPadding: dp(8)
            }
        }

        Column {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: dp(2)
            DText {
                width: parent.width
                text: "How to delete a place?"
                font.pixelSize: appThemes.primaryFontSize
            }

            DText {
                width: parent.width
                text: "Long press on place/city you want. You can select multiple places/cities. Click on 'Delete' icon at the bottom. Once clicked it will delete the places/cities selected."
                font.pixelSize: dp(12)
                wrapMode: Text.WordWrap
                leftPadding: dp(8)
            }
        }

        Column {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: dp(2)
            DText {
                width: parent.width
                text: "How to change the city in Home Page?"
                font.pixelSize: appThemes.primaryFontSize
            }

            DText {
                width: parent.width
                text: "Go to Settings -> Home Page. Click on the selection box which is displaying the current place/city name, select the city which you want on your home page in the popup that appears and it will be saved. Now you can navigate to the 'Home' page, it will reflect the city which you selected."
                font.pixelSize: dp(12)
                wrapMode: Text.WordWrap
                leftPadding: dp(8)
            }
        }
    }
}
