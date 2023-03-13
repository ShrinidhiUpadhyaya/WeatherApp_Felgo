import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Felgo

import "../components"

DAppPage {
    id: page


    property bool temperatureNeeded: true
    property bool weatherCodeNeeded: true

    property string temperatureCode: temperatureNeeded ? "temperature_2m," : ""
    property string weatherCode: weatherCodeNeeded ? "weathercode" : ""
    property string timezone:  "&timezone="

    property string temperatureUnit: ""

    property string subURL: ""

    property int searchSelectedIndex: -1

    property bool enableDeletion: false
    property var deleteItems: []

    Item {
        width: parent.width - appThemes.doubleMargin
        height: parent.height - appThemes.doubleMargin
        anchors.centerIn: parent

        ListView  {
            id: placesListView

            width: parent.width
            anchors.top: parent.top
            anchors.bottom: button.top
            anchors.bottomMargin: appThemes.margin
            model: placesPageData.cityListModel
            spacing: dp(8)
            clip: true
            delegate: DPlaceListComponent {
                width: parent.width
                height: dp(128)
                text: model.place
                value: model.temperature
                description: "Thunderstorms" //model.weatherDescription
                iconText1: model.sunriseTime
                iconText2: model.sunsetTime
                deleteModeOn: page.deleteItems[index]

                onClicked: {
                    if(enableDeletion) {
                        console.log("Selected for deletion",index)
                        page.selectedForDeletion(index)
                    }
                }

                onLongPress: {
                    if(!page.enableDeletion) {
                        console.log("Deletion Enabled")
                        page.enableDeletion = true
                        page.enableDeleteItems(index)
                        console.log(page.deleteItems)
                    }
                }
            }
        }

        RoundButton {
            id: button

            width: appThemes.circularButtonSize
            height: appThemes.circularButtonSize
            anchors {
                bottom: parent.bottom
                bottomMargin: appThemes.margin
                right: parent.right
                rightMargin: appThemes.margin
            }
            background: Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: button.pressed ? appThemes.primaryPressedColor : appThemes.buttonColor
                border.color: appThemes.frameBorderColor
            }
            icon.source: appThemes.setIcon("add")
            icon.color: appThemes.primaryIconColor

            onClicked: {
                popup.open()
            }
        }

        RoundButton {
            id: deleteButton

            width: page.enableDeletion ? appThemes.circularButtonSize : 0
            height: page.enableDeletion ? appThemes.circularButtonSize : 0
            visible: page.enableDeletion
            anchors {
                bottom: parent.bottom
                bottomMargin: appThemes.margin
                left: parent.left
                leftMargin: appThemes.margin
            }
            background: Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: deleteButton.pressed ? "#ED5E68" : "#F34542"
                border.color: appThemes.frameBorderColor
            }
            icon.source: appThemes.setIcon("deleteIcon")
            icon.color: appThemes.primaryIconColor

            Behavior on width {
                SpringAnimation { spring: 2; damping: 0.2; duration: 100}
            }

            Behavior on height {
                SpringAnimation { spring: 2; damping: 0.2; duration: 100}
            }

            onClicked: {
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

                    model: placesPageData.countryList
                    backgroundColor: appThemes.transparentColor
                    Layout.fillWidth: true
                    Layout.fillHeight: true


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
                            page.searchSelectedIndex = index
                            placesPageData.requestHourlyWeather(placesPageData.placeList[index],placesPageData.latitudeList[index],placesPageData.longitudeList[index],placesPageData.timezoneList[index])
                            placesPageData.requestDailyWeatherData(placesPageData.latitudeList[index],placesPageData.longitudeList[index],placesPageData.timezoneList[index])

                            popup.close()
                        }
                    }
                }
            }

            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        }

    }

    function enableDeleteItems(index) {
        console.log("Enabled Delete Items:",index)
        var tempDeleteItems = []
        for(var i=0;i<placesPageData.cityListModel.count;i++) {
            tempDeleteItems[i] = i === index ? true : false
        }
        page.deleteItems = tempDeleteItems

        console.log(page.deleteItems)
    }

    function selectedForDeletion(index) {
        var tempDeleteItems = page.deleteItems
        tempDeleteItems[index] = !tempDeleteItems[index]
        disableDeletion(tempDeleteItems)
        page.deleteItems = tempDeleteItems
        console.log(page.deleteItems)
    }

    function disableDeletion(data) {
        console.log("Disable Deletion",data)
        var count = 0;
        for(var i=0;i<data.length;i++) {
            if(data[i] === false) {
                count++;
            }
        }

        if(count === data.length) {
            page.enableDeletion = false
        }
    }
}
