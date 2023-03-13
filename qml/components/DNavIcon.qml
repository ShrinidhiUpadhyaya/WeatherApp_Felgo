import QtQuick 2.12

Item {
    id: root

    anchors.fill: parent

    property bool selected: true

    property string selectedIcon;
    property string unselectedIcon;

    Image {
        anchors.centerIn: parent
        source: root.selected ? root.selectedIcon : root.unselectedIcon
    }

    function setIcon(iconPath) {
        return "../../assets/icons/" + iconPath
    }

}
