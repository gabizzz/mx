import QtQuick 2.0

Item{

    property alias xSlider: miSliderHandle.x

Rectangle {
        id: miSlider
        x:0

        width: 230
        height: 10
        radius: 5
        smooth: true
        color: "#908e8e"

        Rectangle {
            id: miSliderHandle
            x: 100; y: 0; width: 30; height: 30
            radius: 15
            border.color: "#cbcbcb"
            anchors.verticalCenter: parent.verticalCenter
            smooth: true
            color: "#212123"
            onXChanged: {
                if(x>105)
                {
                    etiqueta.text="B"
                }else if(x<95){
                    etiqueta.text="A"
                }else if(x>95 && x<105){
                    etiqueta.text="X"
                }
            }

            MouseArea {
                anchors.fill: parent
                drag.target: parent
                drag.axis: Drag.XAxis
                drag.minimumX: 0
                drag.maximumX: parent.parent.width - 30
            }

            Text {
                id:etiqueta
                color: "#ffffff"
                anchors.centerIn: parent
                font.bold: true
                font.pointSize: 9
                horizontalAlignment: Text.AlignHCenter
                z: 1
            }
        }
}
}

