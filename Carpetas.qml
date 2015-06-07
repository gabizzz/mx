import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Rectangle {
    id:root
    width: 400
    height: 450
    color: "#00000000"
    border.color: "#00000000"

    property int indiceCarpetas: 0


    function buscarCarpeta()
    {
        for(var i = indiceCarpetas; i < carpetaslistView.count;i++)
        {
            var cadena=myModelCarpetas.get(i).nombre;
            cadena=cadena.toUpperCase();
            if(cadena.indexOf(textInputBuscar.text.toUpperCase()) > -1)
            {
                carpetaslistView.currentIndex=i;
                indiceCarpetas=i+1;
                return;
            }
        }
    }

    GridView {
        id: carpetaslistView
        anchors.bottomMargin: 8
        anchors.topMargin: 16
        anchors.fill: parent
        snapMode: GridView.SnapToRow
        flickableDirection: Flickable.VerticalFlick
        cellHeight: 100
        cellWidth: 100
        clip: true
        highlightMoveDuration: 0

        highlight: Rectangle {
            anchors.fill: carpeta
            radius: 6
            color: "#C2185B"
        }

        model: myModelCarpetas
        delegate: Item {
            id:itemCarpeta
            width: 100
            height: 100
            Rectangle {
                id:carpeta
                anchors.fill: parent
                radius: 6
                border.color: "#C2185B"
                border.width: 1
                color: "#b3000000"
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

        Text {
            id: text1
            color: "#ededed"
            text: qsTr("Carpetas")
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent
            font.pixelSize: 15
        }
    }

    Rectangle {
        id: rectanglefooter
        y: 371
        height: 29
        color: "#b3000000"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        TextField {
            id: textInputBuscar
            y: 5
            z:4
            height: 20
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 4
            anchors.right: parent.right
            anchors.rightMargin: 150
            anchors.left: parent.left
            anchors.leftMargin: 150
            placeholderText: qsTr("Buscar...")
            focus: true
            activeFocusOnPress: true
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12
            onTextChanged: {
                indiceCarpetas=0;
            }

            onAccepted: {
                buscarCarpeta()()
            }

            style: TextFieldStyle {
                            textColor: "black"
                            background: Rectangle {
                                radius: 3
                                color: "orange"
                                implicitWidth: 100
                                implicitHeight: 24
                                border.color: "#333"
                                border.width: 1
                            }
            }

        }
    }

}

