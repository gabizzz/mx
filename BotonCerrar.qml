import QtQuick 2.0

Rectangle {
    id: rectangleCerrar
    width: 27
    height: 27
    color: "#b3000000"
    radius: 14
    border.color: "#a4a4a4"
    signal clicked

    Text {
        id: textX
        color: "#ffffff"
        text: qsTr("X")
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 12
    }

    MouseArea {
        id: mouseAreaCerrar
        anchors.fill: parent
        onClicked: {rectangleCerrar.clicked()}
    }
}
