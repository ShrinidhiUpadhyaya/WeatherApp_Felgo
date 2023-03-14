import QtQuick 2.15

Rectangle {
    id: root

    radius: appThemes.borderRadius
    color: "#636363"

    DText {
        text: "Request Could Not Be Completed."
        font.pixelSize: dp(12)
        anchors.centerIn: parent
    }
}
