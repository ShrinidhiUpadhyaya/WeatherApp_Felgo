import QtQuick 2.15

Rectangle {
    color:"#F34542"
    radius: dp(2)

    Image {
        width: parent.width / 1.5
        height: parent.height / 1.5
        anchors.centerIn: parent
        source:"../../assets/icons/selectedIcon"
    }
}
