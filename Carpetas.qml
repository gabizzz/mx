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

    onVisibleChanged: {
        if (visible===true)
            textInputBuscar.focus=true
        else
            textInputBuscar.focus=false
    }

    GridView {
        id: carpetaslistView
        anchors.bottomMargin: 8
        anchors.topMargin: 35
        anchors.fill: parent
        snapMode: GridView.SnapToRow
        flickableDirection: Flickable.VerticalFlick
        cellHeight: 100
        cellWidth: 100
        clip: true


        model: myModelCarpetas
        delegate: Item {
            id:itemCarpeta
            width: 100
            height: 100

            states: [
                        State {
                            name: "current"
                            when: GridView.isCurrentItem
                        },
                        State {
                            name: "not"
                            when: !GridView.isCurrentItem
                        }]
                    state: "not"


            Rectangle {
                id:carpeta
                anchors.fill: parent
                radius: 6
                border.color: "black"
                border.width: 1
                color: "#1d1d26"
                Text {
                    id:itemText
                    text: nombre.toUpperCase()
                    fontSizeMode: Text.Fit; minimumPixelSize: 9; font.pixelSize: 12;font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                    x:2
                    y:5
                    //color: "#FFFFFF"
                    color: itemCarpeta.GridView.isCurrentItem ? "orange" : "#e84f43"
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
        color: "#e6000000"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        BotonCerrar{
            width: 27
            height: 27
            anchors.top: parent.top
            anchors.topMargin: 1
            anchors.left: parent.left
            anchors.leftMargin: 0
            onClicked: {
                root.visible=false
                root.z=0;
            }
        }

        TextField {
            id: textInputBuscar
            x: 42
            y: 5
            width: 219
            z:4
            height: 20
            placeholderText: qsTr("Buscar...")
            focus: false
            activeFocusOnPress: true
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12
            onTextChanged: {
                indiceCarpetas=0;
                botonBuscar1.textBuscar="Buscar"
            }

            onAccepted: {
                buscarCarpeta()
                botonBuscar1.textBuscar="Otra"
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

        BotonBuscar {
            id: botonBuscar1
            x: 286
            y: 5
            width: 70
            height: 20
            onClicked: {buscarCarpeta()}
        }
    }
}

