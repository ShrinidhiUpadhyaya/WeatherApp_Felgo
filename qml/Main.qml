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
