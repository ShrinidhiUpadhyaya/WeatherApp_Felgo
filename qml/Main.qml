import Felgo
import QtQuick
import "model"
import "logic"
import "pages"
import "components"

App {

    Navigation {
        width: Screen.width
        height: dp(56)
        anchors.bottom: parent.bottom

        NavigationItem {
            id: navItem1

            iconComponent: DNavIcon {
                anchors.fill: parent
                selected: navItem1.isSelected
                selectedIcon: setIcon("homeEnabled")
                unselectedIcon: setIcon("homeDisabled")
            }

            onSelected: {
                console.log("Selected",placesPageData.placesDataStack.length)
                console.log(placesPageData.placesDataStack[homePageData.homePageCityIndex])
                if(!(placesPageData.placesDataStack.length < 1)) {
                    console.log(placesPageData.placesDataStack[homePageData.homePageCityIndex])
                    var data = placesPageData.placesDataStack[homePageData.homePageCityIndex];
                    var latitude = data[1]
                    var longitude = data[2]
                    var timezone = data[3]

                    homePageData.requestHourlyWeather(latitude,longitude,timezone)
                }
            }

            NavigationStack {
                initialPage: HomePage { }
            }
        }

        NavigationItem {
            id: navItem2

            iconComponent: DNavIcon {
                anchors.fill: parent
                selected: navItem2.isSelected
                selectedIcon: setIcon("cityEnabled")
                unselectedIcon: setIcon("cityDisabled")
            }

            NavigationStack {
                PlacesPage { }
            }
        }

        NavigationItem {
            id: navItem4

            iconComponent: DNavIcon {
                anchors.fill: parent
                selected: navItem4.isSelected
                selectedIcon: setIcon("settingsEnabled")
                unselectedIcon: setIcon("settingsDisabled")
            }
            NavigationStack {
                id: navStack

                SettingsPage {
                }
            }
        }
    }

    AppData {
        id: appData
    }

    HomePageLogic {
        id: homePageData
    }

    PlacesPageLogic {
        id: placesPageData
    }

    AppThemes {
        id: appThemes
    }
}
