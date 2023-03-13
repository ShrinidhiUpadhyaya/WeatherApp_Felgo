import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Felgo

import "../components"

DAppPage {
    id: page

    property var allCityNames: ["Bamberg","Berlin","Mumbai","Stuttgart"]

    property var citiesSelectedIndex: [0,1,2]

    property int currentCityIndex: 0

    ListModel {
        id: settingsListModel

        ListElement {
            text: "Cities"
            icon: "cityWhiteIcon"
        }

        ListElement {
            text: "FAQ"
            icon: "faqIcon"
        }
    }

    Popup {
        id: popup

        width: parent.width / 1.2
        height: parent.height / 2
        anchors.centerIn: parent

        background: Rectangle {
            radius: dp(16)
            color: "#124951"
        }


        AppListView  {
            id: placesSearchListView

            model: allCityNames
            backgroundColor: appThemes.transparentColor
            Layout.fillWidth: true
            Layout.fillHeight: true


            delegate: DRadioSelectionBox {
                width: parent.width
                height: dp(32)
                text: modelData
                selected: citiesSelectedIndex[currentCityIndex] === index

                onClicked: {
                    setCity(index)
                    popup.close()
                }
            }
        }

        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    }


    ColumnLayout {
        width: parent.width - appThemes.doubleMargin
        height: parent.height - appThemes.doubleMargin
        anchors.centerIn: parent

        ListView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: settingsListModel
            spacing: appThemes.margin
            delegate: DIconText {
                width: parent.width
                height: dp(48)
                icon: model.icon
                text: model.text
            }
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            color:"transparent"
            border.color: "red"

            Column {
                anchors.fill: parent
                spacing: appThemes.margin

                Repeater {
                    model: ["City 1", "City 2", "City 3"]

                    RowLayout {
                        width: parent.width
                        height: dp(32)
                        spacing: appThemes.doubleMargin

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            Rectangle {
                                anchors.fill: parent
                                color:"transparent"
                                border.color: "red"
                            }

                            DText {
                                text: modelData
                                font.bold: true
                                font.pixelSize: dp(16)
                                verticalAlignment: Text.AlignVCenter
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        DSelectionBox {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            text: allCityNames[citiesSelectedIndex[index]]

                            onClicked: {
                                currentCityIndex = index
                                console.log(currentCityIndex)
                                popup.open()
                            }
                        }
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



//            Rectangle {
//                anchors.fill: parent
//                color: "transparent"
//                border.color: "red"
//            }
        }
    }

    function setCity(index) {
        var temp = citiesSelectedIndex
        temp[currentCityIndex]= index
        citiesSelectedIndex = temp;

    }
}
