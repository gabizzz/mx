import QtQuick 2.0

Rectangle {
    id: rectangleHome
    width: 27
    height: 27
    color: "#b3000000"
    radius: 14
    border.color: "#dd4814"
    border.width: 2
    signal clicked

    Text {
        id: textH
        color: "#a4a4a4"
        text: qsTr("H")
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 12
    }

    MouseArea {
        id: mouseAreaCerrar
        anchors.fill: parent
        onClicked: {rectangleHome.clicked()}
    }
}

