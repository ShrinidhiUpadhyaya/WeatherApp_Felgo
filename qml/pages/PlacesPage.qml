import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Felgo

import "../components"

DAppPage {
    id: page

    Connections {
        target: placesPageData

        onError: {
            console.log("Error")
            toastMessage.visible = true
            toastTimer.start()
        }
    }

    Item {
        width: parent.width - appThemes.doubleMargin
        height: parent.height - appThemes.doubleMargin
        anchors.centerIn: parent

        ListView  {
            id: placesListView

            width: parent.width
            anchors {
                top: parent.top
                bottom: addButton.top
                bottomMargin: appThemes.margin
            }

            model: placesPageData.cityListModel
            spacing: appThemes.halfMargin
            clip: true
            delegate: DPlaceListComponent {
                width: parent.width
                height: dp(128)
                text: model.place
                value: model.temperature
                description: model.weatherDescription
                iconText1: model.sunriseTime
                iconText2: model.sunsetTime
                icon: "/bigIcons/" + model.weatherIcon
                deleteModeOn: index>0 ? placesPageData.deleteItems[index] : false

                onClicked: {
                    if(placesPageData.enableDeletion && index > 0) {
                        console.log("Selected for deletion",index)
                        placesPageData.deletion.selectedForDeletion(index)
                    }
                }

                onLongPress: {
                    if(!placesPageData.enableDeletion) {
                        console.log("Deletion Enabled")
                        placesPageData.enableDeletion = true
                        placesPageData.deletion.enableDeleteItems(index)
                        console.log(placesPageData.deleteItems)
                    }
                }
            }
        }

        DRoundButton {
            id: addButton

            width: appThemes.circularButtonSize
            height: appThemes.circularButtonSize
            anchors {
                bottom: parent.bottom
                bottomMargin: appThemes.margin
                right: parent.right
                rightMargin: appThemes.margin
            }

            iconSource: appThemes.setIcon("add")

            onClicked: {
                console.log("Clicked")
                popup.open()
            }
        }

        DRoundButton {
            id: deleteButton

            width: placesPageData.enableDeletion ? appThemes.circularButtonSize : 0
            height: placesPageData.enableDeletion ? appThemes.circularButtonSize : 0
            anchors {
                bottom: parent.bottom
                bottomMargin: appThemes.margin
                left: parent.left
                leftMargin: appThemes.margin
            }
            visible: placesPageData.enableDeletion
            backgroundColor: appThemes.deleteButtonColor
            pressedColor: appThemes.deleteButtonPressedColor
            iconSource: appThemes.setIcon("deleteIcon")

            Behavior on width {
                SpringAnimation { spring: 2; damping: 0.2; duration: 100}
            }

            Behavior on height {
                SpringAnimation { spring: 2; damping: 0.2; duration: 100}
            }

            onClicked: {
                placesPageData.enableDeletion = false
                placesPageData.deletion.deleteItems()
            }
        }

        Popup {
            id: popup

            width: parent.width / 1.2
            height: parent.height / 2
            anchors.centerIn: parent

            background: Rectangle {
                radius: appThemes.borderRadius
                color: "#124951"
            }

            ColumnLayout {
                anchors.fill: parent

                SearchBar {
                    id: searchBar

                    Layout.fillWidth: true
                    Layout.fillHeight: false
                    Layout.preferredHeight: parent.height * 0.15
                    barBackgroundColor: appThemes.transparentColor

                    onTextChanged: {
                        if(text.length > 1) {
                            placesPageData.requestPlaces(text)
                        }
                    }

                    onAccepted: {
                        console.log("Search Accepted: ")
                        if(text.length > 1) {
                            placesPageData.requestPlaces(text)
                        }
                    }
                }

                AppListView  {
                    id: placesSearchListView

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: placesPageData.countryList
                    backgroundColor: appThemes.transparentColor

                    delegate: SimpleRow {
                        text: placesPageData.placeList[index]
                        detailText: placesPageData.countryList[index]

                        style: StyleSimpleRow {
                            backgroundColor: appThemes.transparentColor
                            textColor: appThemes.primaryTextColor
                            detailTextColor: "#E2DFD2"
                            showDisclosure: false
                            fontSizeText: dp(18)
                            fontSizeDetailText: dp(14)
                            showDivider: false
                        }

                        onSelected: {
                            console.log("Index Selected:",index)
                            searchBar.text = ""
                            placesPageData.searchSelectedIndex = index
                            placesPageData.loadSearchRequest()
                            popup.close()
                        }
                    }
                }
            }

            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        }

        Timer {
            id: toastTimer

            running: false
            interval: 3000
            onTriggered: {
                toastMessage.visible = false
            }
        }

        DToast {
            id: toastMessage

            width: parent.width / 2
            height: dp(24)
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }

            visible: false
        }
    }

//    Component.onCompleted: {
//        console.log("Places Component Completed@@@@@@@@@@@@@@@@@@@@@@@@@")
//        placesPageData.searchSelectedIndex = 1
//        placesPageData.initialDefaultRequestPlaces("Bamberg")
//    }
}
