import QtQuick 2.11
import QtQuick.Controls 2.4
import QtMultimedia 5.9

Item {
    id: root
    property MediaPlayer player: null

    Rectangle {
        id: bar
        color: Qt.rgba(0, 0, 0, 0.7)
        anchors.fill: parent
        visible: true
        Slider {
            id: slider

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.verticalCenter
            anchors.bottom: parent.bottom

            property bool sync: false

            from: 0
            to: player.duration
            value: player.position

            Component.onCompleted: {
                value = player.position
            }

            onValueChanged: {
                if (!sync) {
                    console.log("value changed", value)
                    player.seek(value)
                }
            }

            Connections {
                target: player
                onPositionChanged: {
                    console.log("position changed", player.position)
                    slider.sync = true
                    slider.value = player.position
                    slider.sync = false
                }
            }
        }
    }

    Timer {
        id: timer
        running: false
        interval: 5000
        onTriggered: {
            bar.visible = false
            mouseArea.enabled = true
        }
    }

//    MouseArea {
//        id: mouseArea
//        anchors.fill: parent
//        enabled: true
//        hoverEnabled: true
//        onContainsMouseChanged: {
//            if (containsMouse) {
//                bar.visible = true
//                enabled = false
//            }
//            else {
//                timer.restart()
//            }
//        }
//    }
}
