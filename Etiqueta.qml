import QtQuick 2.0

Rectangle {
    id:rect
    width: 120
    height: 100
    color: "#80000000"

    property alias textoEtiqueta: textoEtiqueta.text
    signal clicked

    Text {
        id: textoEtiqueta
        color: "#b2a9a4"
        text: qsTr("No Track")
        anchors.fill: parent
        wrapMode: Text.WordWrap
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.Fit; minimumPixelSize: 8; font.pixelSize: 10;font.bold: true
        horizontalAlignment: Text.AlignHCenter
    }
    MouseArea{
        anchors.fill:parent
        onClicked: {rect.clicked()}
    }
}

