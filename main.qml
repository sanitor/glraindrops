import QtQuick 2.11
import QtQuick.Window 2.11
import QtMultimedia 5.9

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    color: "black"

    MediaPlayer {
        id: player
        source: "file:///C:/Users/Shiny/Videos/Captures/Sekiro 2019_5_17 22_34_58.mp4"
        //"file:///D:/Projects/glraindrops/resources/carcorder.mp4"
        autoPlay: true
        loops: MediaPlayer.Infinite
    }

    VideoOutput {
        id: videoOutput
        source: player
        anchors {
            top: parent.top
            bottom: controlBar.top
            left: parent.left
            right: parent.right
        }
    }

//    ZebraEffect {
//        property variant src: ShaderEffectSource { sourceItem: videoOutput; hideSource: true }
//        property vector2d dimensions: Qt.vector2d(videoOutput.width, videoOutput.height)
//        property vector2d dutyRatio: Qt.vector2d(2.0, 2.0)
//        property real threshold: 0.7
//        anchors.fill: videoOutput
//    }

    FocusPeakEffect {
        property variant src: ShaderEffectSource { sourceItem: videoOutput; hideSource: true }
        property real threshold: 0.8
        property vector2d dimensions: Qt.vector2d(videoOutput.width, videoOutput.height)
        lineColor: Qt.rgba(1.0, 0.4, 0.0, 1.0)
        anchors.fill: videoOutput
    }

    VideoControlBar {
        id: controlBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 60

        player: player

        visible: true
    }
}
