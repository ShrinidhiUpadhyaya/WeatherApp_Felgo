import QtQuick 2.15
import Felgo

Item {
    id: root

    readonly property string buttonColor: "#0E5D5A"
    readonly property string deleteButtonColor: "#F34542"
    readonly property string deleteButtonPressedColor: "#ED5E68"
    readonly property string cardColor: "#124951"
    readonly property string dividerLineColor: "#1B8B96"
    readonly property string frameBorderColor: "#408F8D"
    readonly property string highlightColor: "#32FFFF"
    readonly property string primaryTextColor: "white"
    readonly property string primaryIconColor: "white"
    readonly property string primaryPressedColor: "#06A67C"
    readonly property string selectedColor: "#06A67C"
    readonly property string secondaryTextColor: "#E2DFD2"
    readonly property string transparentColor: "transparent"
    readonly property string unselectedColor: "#0D5C5A"

    readonly property real bannerFontSize: dp(40)
    readonly property real bigBannerFontSize: dp(48)
    readonly property real borderRadius: dp(8)
    readonly property real circularButtonSize: dp(56)
    readonly property real dividerHeight: dp(2)
    readonly property real doubleMargin: dp(32)
    readonly property real iconSize: dp(32)
    readonly property real margin: dp(16)
    readonly property real primaryFontSize: dp(16)
    readonly property real secondaryFontSize: dp(12)
    readonly property real halfMargin: dp(8)
    readonly property real bigFontSize: dp(24)

    function setIcon(path) {
        return "../../assets/icons/" + path
    }
}
