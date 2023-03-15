import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Felgo

import "../components"

DAppPage {
    id: page

    title: qsTr("Cities")

    navigationBarHidden: false

    Item {
        width: parent.width - appThemes.doubleMargin
        height: parent.height - appThemes.doubleMargin
        anchors.centerIn: parent

        Column {
            anchors.fill: parent
            spacing: appThemes.margin

            RowLayout {
                width: parent.width
                height: dp(32)
                spacing: appThemes.doubleMargin

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    DText {
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("City")
                        font.bold: true
                        font.pixelSize: dp(16)
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                DSelectionBox {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: placesPageData.cityListModel.get(homePageData.homePageCityIndex).place

                    onClicked: {
                        popup.open()
                    }
                }
            }
        }
    }

    Popup {
        id: popup

        width: parent.width / 1.2
        height: parent.height / 2
        anchors.centerIn: parent

        background: Rectangle {
            radius: dp(16)
            color: appThemes.cardColor
        }

        AppListView  {
            id: placesSearchListView

            anchors.fill: parent
            model: placesPageData.cityListModel
            backgroundColor: appThemes.transparentColor

            delegate: DRadioSelectionBox {
                width: parent.width
                height: dp(32)
                text: model.place
                selected: homePageData.homePageCityIndex === index

                onClicked: {
                    page.setCity(index)
                    popup.close()
                }
            }
        }

        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    }

    function setCity(index) {
        homePageData.homePageCityIndex = index;
    }
}
