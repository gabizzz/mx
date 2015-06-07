import QtQuick 2.0

Rectangle {
    id:root
    width: 400
    height: 400
    color: "#00000000"
    border.color: "#00000000"

    GridView {
        id: carpetaslistView
        anchors.topMargin: 16
        anchors.fill: parent
        snapMode: GridView.SnapToRow
        flickableDirection: Flickable.VerticalFlick
        cellHeight: 100
        cellWidth: 100
        clip: true

        model: myModelCarpetas
        delegate: Item {            
            x: 5
            width: 80
            height: 80
            Rectangle {
                id:carpeta
                width: 100
                height: 100
                radius: 6
                border.color: "black"
                border.width: 2
                color: "#C2185B"
                Text {
                    id:itemText
                    text: nombre.toUpperCase()
                    fontSizeMode: Text.Fit; minimumPixelSize: 9; font.pixelSize: 12
                    font.bold: true; anchors.verticalCenter: parent.verticalCenter
                    x:2
                    y:5
                    color: "#FFFFFF"
                    width: 80
                    height: 80
                    wrapMode: Text.WordWrap
                }
                MouseArea{
                    id:mouseAreaCarpeta
                    anchors.fill: parent
                    onClicked: {
                        root.visible=false
                        root.z=0;
                        for(var i = 0; i < folderListView.count;i++)
                        {
                            var cadena=myModelMusica.get(i).ubicacion.toUpperCase()
                            if(cadena.indexOf("/"+itemText.text) > -1)
                            {
                                pistaSeleccionada="file://"+myModelMusica.get(i).ubicacion
                                folderListView.currentIndex=i;
                                return;
                            }
                        }
                    }
                }

            }
        }
    }

    Rectangle {
        id: rectangleheader
        height: 29
        color: "#b3000000"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        Rectangle {
            id: rectangleCerrar
            width: 27
            height: 27
            color: "#b3000000"
            radius: 14
            anchors.top: parent.top
            anchors.topMargin: 1
            anchors.left: parent.left
            anchors.leftMargin: 0
            border.color: "#a4a4a4"

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
                onClicked: {root.visible=false; root.z=0;}
            }
        }
    }

}

