import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Felgo

import "../components"

DAppPage {
    id: page

    property int currentTimeIndex: 0
    property int currentForecastIndex: 0

    Connections {
        target: homePageData

        onError: {
            toastMessage.visible = true
            toastTimer.start()
        }
    }

    Item {
        width: parent.width - appThemes.doubleMargin
        height: parent.height - appThemes.doubleMargin
        anchors.centerIn: parent

        ScrollView {
            width: parent.width

            anchors {
                top: parent.top
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }

            Loader {
                id: mainLoader

                anchors.fill: parent
                sourceComponent: mainComponent
            }

            Component {
                id: mainComponent

                Column {
                    anchors.fill: parent
                    spacing: appThemes.margin

                    Item {
                        width: parent.width
                        height: Screen.height * 0.25

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: dp(4)

                            DText {
                                id: cityNameText

                                Layout.fillWidth: true
                                Layout.fillHeight: false
                                Layout.preferredHeight: appThemes.bannerFontSize + 2
                                text: placesPageData.placesDataStack[homePageData.homePageCityIndex][0]
                                font.pixelSize: appThemes.bannerFontSize
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            DText {
                                id: temperatureValueText

                                Layout.fillWidth: true
                                Layout.fillHeight: false
                                Layout.preferredHeight: appThemes.bigBannerFontSize + 2
                                text: homePageData.uiDisplayData.hourlyTemperatureData[0] + qsTr("°")
                                font.pixelSize: appThemes.bigBannerFontSize
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                RowLayout {
                                    width: parent.width / 2
                                    height: parent.height
                                    anchors.centerIn: parent
                                    spacing: appThemes.margin

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        Image {
                                            width: dp(20)
                                            height: dp(20)
                                            anchors {
                                                right: highestTemperatureText.left
                                                rightMargin: dp(4)
                                                verticalCenter: parent.verticalCenter
                                            }
                                            source: appThemes.setIcon("arrowIcon")
                                            rotation: 180
                                        }

                                        DText {
                                            id: highestTemperatureText

                                            anchors {
                                                right: parent.right
                                                verticalCenter: parent.verticalCenter
                                            }
                                            text: homePageData.uiDisplayData.dailyMaxTemperatureData[0] + qsTr("°C")
                                            color: appThemes.secondaryTextColor
                                            font.pixelSize: appThemes.primaryFontSize
                                            font.bold: true
                                        }
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        Image {
                                            width: dp(20)
                                            height: dp(20)
                                            anchors {
                                                left: lowestTemperatureText.right
                                                leftMargin: dp(4)
                                                verticalCenter: parent.verticalCenter
                                            }
                                            source: appThemes.setIcon("arrowIcon")
                                        }

                                        DText {
                                            id: lowestTemperatureText

                                            anchors {
                                                left: parent.left
                                                verticalCenter: parent.verticalCenter
                                            }
                                            text: homePageData.uiDisplayData.dailyMinTemperatureData[0] + qsTr("°C")
                                            color: appThemes.secondaryTextColor
                                            font.pixelSize: appThemes.primaryFontSize
                                            font.bold: true

                                        }
                                    }
                                }
                            }

                            DText {
                                id: weatherDescriptionText

                                Layout.fillWidth: true
                                Layout.fillHeight: false
                                Layout.preferredHeight: dp(24)
                                text: homePageData.uiDisplayData.currentWeatherDescription
                                color: appThemes.secondaryTextColor
                                font.pixelSize: dp(24)
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            Image {
                                Layout.fillWidth: false
                                Layout.preferredWidth: dp(120)
                                Layout.fillHeight: false
                                Layout.preferredHeight: dp(120)
                                Layout.alignment: Qt.AlignHCenter
                                source: appThemes.setIcon("/bigIcons/" + homePageData.uiDisplayData.hourlyIconCodeData[0])
                            }
                        }
                    }

                    DCard {
                        width: parent.width * 0.95
                        height: 88
                        anchors.horizontalCenter: parent.horizontalCenter

                        Image {
                            id: sunriseIcon

                            width: appThemes.iconSize
                            height: appThemes.iconSize
                            anchors {
                                bottom: curve.top
                                bottomMargin: dp(4)
                                left: parent.left
                                leftMargin: dp(8)
                            }
                            source: appThemes.setIcon("sunrise")
                        }

                        DText {
                            anchors {
                                left: sunriseIcon.right
                                leftMargin: dp(8)
                                verticalCenter: sunriseIcon.verticalCenter
                            }
                            text: homePageData.uiDisplayData.dailySunriseData[0]
                            color: appThemes.secondaryTextColor
                            font.pixelSize: appThemes.primaryFontSize
                            font.bold: true
                        }

                        Image {
                            id: curve

                            width: parent.width
                            height: 48
                            anchors {
                                bottom: parent.bottom
                                bottomMargin: dp(4)
                            }
                            source: appThemes.setIcon("sunriseSunsetCurve")
                        }

                        DText {
                            anchors {
                                right: sunsetIcon.left
                                rightMargin: dp(8)
                                verticalCenter: sunsetIcon.verticalCenter
                            }
                            text: homePageData.uiDisplayData.dailySunsetData[0]
                            color: appThemes.secondaryTextColor
                            font.pixelSize: appThemes.primaryFontSize
                            font.bold: true
                        }

                        Image {
                            id: sunsetIcon

                            width: appThemes.iconSize
                            height: appThemes.iconSize
                            anchors {
                                bottom: curve.bottom
                                bottomMargin: dp(8)
                                right: parent.right
                                rightMargin: dp(8)
                            }
                            source: appThemes.setIcon("sunset")
                        }
                    }

                    DCard {
                        width: parent.width * 0.95
                        height: 200
                        anchors.horizontalCenter: parent.horizontalCenter

                        ColumnLayout {
                            anchors.fill: parent
                            clip: true

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: false
                                Layout.preferredHeight: parent.height * 0.2

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 0

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        DText {
                                            anchors.centerIn: parent
                                            text: qsTr("Hourly Forecast")
                                            font.pixelSize: appThemes.primaryFontSize
                                            font.bold: page.currentForecastIndex == 0
                                            color: page.currentForecastIndex === 0 ? appThemes.primaryTextColor : appThemes.secondaryTextColor
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                page.currentForecastIndex = 0
                                            }
                                        }
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        DText {
                                            anchors.centerIn: parent
                                            text: qsTr("Weekly Forecast")
                                            font.pixelSize: appThemes.primaryFontSize
                                            font.bold: page.currentForecastIndex == 1
                                            color: page.currentForecastIndex === 1 ? appThemes.primaryTextColor : appThemes.secondaryTextColor
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                page.currentForecastIndex = 1
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    width: parent.width * 0.9
                                    height: appThemes.dividerHeight
                                    anchors {
                                        bottom: parent.bottom
                                        horizontalCenter: parent.horizontalCenter
                                    }
                                    radius: appThemes.borderRadius
                                    color: appThemes.dividerLineColor

                                }

                                Rectangle {
                                    width: parent.width * 0.2
                                    height: appThemes.dividerHeight
                                    anchors.bottom: parent.bottom
                                    x: page.currentForecastIndex === 0 ? (parent.width * 0.25) - (width/2) : (parent.width * 0.75) -(width/2)
                                    radius: appThemes.borderRadius
                                    color: appThemes.highlightColor

                                    Behavior on x {
                                        SpringAnimation { spring: 2; damping: 0.2;}
                                    }
                                }
                            }

                            Item {
                                id: temperatureListContainer

                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                ListView {
                                    anchors.fill: parent
                                    spacing: 0
                                    orientation: ListView.Horizontal
                                    model: homePageData.uiDisplayData.hourlyTimeData.length
                                    visible: page.currentForecastIndex === 0
                                    delegate: DTemperatureForecastComponent {
                                        width: temperatureListContainer.width / 4.5
                                        height: temperatureListContainer.height / 1.2
                                        time: homePageData.uiDisplayData.hourlyTimeData[index]
                                        temperature: homePageData.uiDisplayData.hourlyTemperatureData[index] + qsTr("°")
                                        icon: homePageData.uiDisplayData.hourlyIconCodeData[index]
                                        backgroundColor: page.currentTimeIndex === index ? appThemes.selectedColor : appThemes.unselectedColor

                                        onClicked: {
                                            page.currentTimeIndex = index
                                        }
                                    }
                                }

                                ListView {
                                    anchors.fill: parent
                                    spacing: 0
                                    orientation: ListView.Horizontal
                                    model: homePageData.uiDisplayData.dailyDate.length
                                    visible: page.currentForecastIndex === 1

                                    delegate: DTemperatureWeeklyForecastComponent {
                                        width: temperatureListContainer.width / 3.5
                                        height: temperatureListContainer.height / 1.2
                                        time: homePageData.uiDisplayData.dailyDate[index]
                                        maxTemperature: homePageData.uiDisplayData.dailyMaxTemperatureData[index] + qsTr("°")
                                        minTemperature: homePageData.uiDisplayData.dailyMinTemperatureData[index] + qsTr("°")
                                        icon: homePageData.uiDisplayData.dailyWeatherIcon[index]
                                        backgroundColor: appThemes.unselectedColor
                                    }
                                }
                            }
                        }
                    }

                    DCard {
                        width: parent.width * 0.95
                        height: 200
                        anchors.horizontalCenter: parent.horizontalCenter

                        Item {
                            id: header

                            width: parent.width
                            height: parent.height * 0.15

                            DText {
                                text: qsTr("Details")
                                font.pixelSize: appThemes.primaryFontSize
                                anchors.verticalCenter: parent.verticalCenter
                                x: appThemes.margin
                                color: appThemes.secondaryTextColor
                            }
                        }

                        Item {
                            width: parent.width - appThemes.doubleMargin
                            anchors {
                                top: header.bottom
                                bottom: parent.bottom
                                horizontalCenter: parent.horizontalCenter
                            }

                            GridLayout {
                                anchors.fill: parent
                                columns: 2
                                rows: 2

                                Repeater {
                                    model: homePageData.uiDisplayData.detailsLabels.length

                                    delegate: DLabelValueText {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        label: homePageData.uiDisplayData.detailsLabels[index]
                                        value: homePageData.uiDisplayData.detailsValues[index][currentTimeIndex] + " " + homePageData.uiDisplayData.detailsValuesUnits[index]
                                    }
                                }
                            }
                        }
                    }
                }
            }
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

    Component.onCompleted: {
        console.log("Components completed")
        homePageData.requestHourlyWeather("49.90","10.90","Europe/Berlin")
        placesPageData.searchSelectedIndex = 1
        placesPageData.initialDefaultRequestPlaces("Bamberg")
    }
}
