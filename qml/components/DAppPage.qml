import QtQuick 2.15
import Felgo

AppPage {
    id: page

    navigationBarHidden: true

    Image {
        anchors.fill: parent
        source: "../../assets/appBackground"
    }

    onAppeared: {
        console.log("The page has appeared")
    }
}
