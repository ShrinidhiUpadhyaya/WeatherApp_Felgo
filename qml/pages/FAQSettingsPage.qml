import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Felgo

import "../components"

DAppPage {
    title: qsTr("FAQ")

    navigationBarHidden: false

    ListModel {
        id: answerText

        ListElement {
            questionText: "How to add a place?"
            answerText: "Go to Cities Screen, Click on '+' button, a popup will appear, search for a city you need. Then click on the city you want. It will be added to your list."
        }

        ListElement {
            questionText: "How to add a place?"
            answerText: "Go to Cities Screen, Click on '+' button, a popup will appear, search for a city you need. Then click on the city you want. It will be added to your list."

        }

        ListElement {
            questionText: "How to change the city in Home Page?"
            answerText: "Go to Settings -> Home Page. Click on the selection box which is displaying the current place/city name, select the city which you want on your home page in the popup that appears and it will be saved. Now you can navigate to the 'Home' page, it will reflect the city which you selected."
        }
    }

    ListView {
        width: parent.width - appThemes.doubleMargin
        height: parent.height - appThemes.doubleMargin
        anchors.centerIn: parent
        model: answerText
        delegate: Column {
            width: parent.width
            height: dp(120)
            spacing: dp(2)
            DText {
                width: parent.width
                text: "How to add a place?"
                font.pixelSize: appThemes.primaryFontSize
            }

            DText {
                width: parent.width
                text: "Go to Cities Screen, Click on '+' button, a popup will appear, search for a city you need. Then click on the city you want. It will be added to your list."
                font.pixelSize: appThemes.secondaryFontSize
                wrapMode: Text.WordWrap
                leftPadding: appThemes.halfMargin
            }
        }
    }
}

