import QtQuick 2.15
import QtQuick.Controls 2.15

RoundButton {
    id: root

    property string iconSource:""

    property string backgroundColor: appThemes.buttonColor
    property string pressedColor: appThemes.primaryPressedColor


    width: appThemes.circularButtonSize
    height: appThemes.circularButtonSize

    background: Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: root.pressed ? root.pressedColor: root.backgroundColor
        border.color: appThemes.frameBorderColor
    }
    icon.source: appThemes.setIcon(root.iconSource)
    icon.color: appThemes.primaryIconColor
}
