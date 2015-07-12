import QtQuick 2.0

Item{
    id:botonFuncion
    signal clicked
    signal pressandhold
    property alias textoBoton: textCenter.text

Rectangle {    
    id: rect
    color: "#3b3a3a"
    height: 48
    width: 48
    radius: 10
    border.width: 3
    border.color: "#696969"


    MouseArea {
        anchors.fill: parent
        onClicked: {
            botonFuncion.clicked()
            animaborde.running=true
        }
        onPressAndHold: {
            botonFuncion.pressandhold()
        }
    }

    SequentialAnimation {
        id: animaborde
        ColorAnimation {target: rect;properties: "border.color"; to: "red"; duration: 200 }
        ColorAnimation {target: rect;properties: "border.color"; to: "#696969"; duration: 0 }
    }

    Text {
        id: textCenter
        text: qsTr("C")
        font.bold: true
        verticalAlignment: Text.AlignVCenter
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 18
    }
}
}

