import QtQuick 2.0

Rectangle {
    id: rectangleBuscar
    color: "#2865b3"
    radius: 3

    signal clicked
    width: 70
    height: 20


    Text {
        id: textBuscar
        color: "#ffffff"
        text: qsTr("Buscar")
        verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
        anchors.fill: parent
        font.pixelSize: 12
    }

    MouseArea {
        id: mouseAreaBuscar
        anchors.fill: parent
        onClicked: {rectangleBuscar.clicked()}
    }
}
