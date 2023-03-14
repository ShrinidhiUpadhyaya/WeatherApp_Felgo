import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root

    property alias running: control.running

    BusyIndicator {
        id: control

        contentItem: Item {
            implicitWidth: dp(64)
            implicitHeight: dp(64)

            Item {
                id: item
                x: parent.width / 2 - dp(32)
                y: parent.height / 2 - dp(32)
                width: dp(64)
                height: dp(64)
                opacity: control.running ? 1 : 0

                Behavior on opacity {
                    OpacityAnimator {
                        duration: 250
                    }
                }

                RotationAnimator {
                    target: item
                    running: control.visible && control.running
                    from: 0
                    to: 360
                    loops: Animation.Infinite
                    duration: 1250
                }

                Repeater {
                    id: repeater
                    model: 6

                    Rectangle {
                        id: delegate
                        x: item.width / 2 - width / 2
                        y: item.height / 2 - height / 2
                        implicitWidth: dp(8)
                        implicitHeight: dp(8)
                        radius: 5
                        color: "white"

                        required property int index

                        transform: [
                            Translate {
                                y: -Math.min(item.width, item.height) * 0.5 + 5
                            },
                            Rotation {
                                angle: delegate.index / repeater.count * 360
                                origin.x: 5
                                origin.y: 5
                            }
                        ]
                    }
                }
            }
        }
    }
}
