import QtQuick
import Qt5Compat.GraphicalEffects
import Cutie

Item {
    width: parent.width * 0.9
    height: 30
    y: -parent.y
    anchors.horizontalCenter: parent.horizontalCenter

    Rectangle
    {
        id: maskRect2
        width: 10
        height: 10
        visible: false
        color: Atmosphere.textColor
        transitions: Transition {
            ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
        }
    }

    Image {
        id: image1
        anchors.right: image2.left
        anchors.rightMargin: 4
        anchors.verticalCenter: parent.verticalCenter
        width: 13
        height: 13
        source: settingSheet.wifiIcon
        sourceSize.height: 400
        sourceSize.width: 400
        fillMode: Image.PreserveAspectFit
        visible: false
    }

    OpacityMask {
        anchors.fill: image1
        source: maskRect2
        maskSource: image1
    }

    Image {
        id: image2
        anchors.right: image3.left
        anchors.rightMargin: 4
        anchors.verticalCenter: parent.verticalCenter
        width: 13
        height: 13
        source: settingSheet.primaryModemIcon
        sourceSize.height: 128
        sourceSize.width: 128
        fillMode: Image.PreserveAspectFit
        visible: false
    }

    OpacityMask {
        anchors.fill: image2
        source: maskRect2
        maskSource: image2
    }

    Image {
        id: image3
        anchors.right: text14.left
        anchors.rightMargin: 4
        anchors.verticalCenter: parent.verticalCenter
        width: 13
        height: 13
        source: ((batteryStatus.Percentage == 100) ? "icons/battery-100-charged.svg" : 
            ((batteryStatus.State === 1) ? ((batteryStatus.Percentage > 70) ? "icons/battery-070-charging.svg" : 
            ((batteryStatus.Percentage > 50) ? "icons/battery-050-charging.svg": "icons/battery-010-charging.svg")) : 
            ((batteryStatus.Percentage > 90) ? "icons/battery-090.svg" : ((batteryStatus.Percentage > 70) ? "icons/battery-070.svg" : 
            ((batteryStatus.Percentage > 50) ? "icons/battery-050.svg" : ((batteryStatus.Percentage > 30) ? "icons/battery-030.svg" :
            "icons/battery-010.svg"))))))
        sourceSize.height: 128
        sourceSize.width: 128
        fillMode: Image.PreserveAspectFit
        visible: false
    }

    OpacityMask {
        anchors.fill: image3
        source: maskRect2
        maskSource: image3
    }

    Text {
        id: text14
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        text: Math.floor(batteryStatus.Percentage).toString() + " %"
        font.pixelSize: 12
        font.bold: false
        color: Atmosphere.textColor
        transitions: Transition {
            ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
        }
        font.family: "Lato"
    }

    Text {
        id: clockText
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        width: 25
        text: Qt.formatDateTime(new Date(), "HH:mm")
        font.pixelSize: 12
        font.bold: false
        color: Atmosphere.textColor
        transitions: Transition {
            ColorAnimation { properties: "color"; duration: 500; easing.type: Easing.InOutQuad }
        }
        font.family: "Lato"
    }

    function timeChanged() {
        clockText.text = Qt.formatDateTime(new Date(), "HH:mm");
    }

    Timer {
        interval: 100; running: true; repeat: true;
        onTriggered: timeChanged()
    }

    Item {
        x: 0
        y: 0
        height: parent.height
        width: parent.width

        MouseArea { 
            enabled: (settingsState.state != "opened")
            drag.target: parent; drag.axis: Drag.YAxis; drag.minimumY: 0; drag.maximumY: Screen.height
            anchors.fill: parent

            onReleased: {
                if (parent.y > parent.height) { 
                    settingsState.state = "opened"
                }
                else { 
                    settingsState.state = "closed"
                }
                parent.y = 0
            }
            
            onPositionChanged: {
                if (drag.active) {
                    settingSheet.containerOpacity = parent.y / Screen.height;
                    settingSheet.setSettingContainerY(parent.y - Screen.height);
                }
            }

            onPressed: {
                settingsState.state = "opening";
                settingSheet.setSettingContainerY(-Screen.height);
                settingSheet.containerOpacity = 0;
                settingSheet.y = 0;
            }
        }
    }
}