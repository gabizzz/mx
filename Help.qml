import QtQuick 2.0

Rectangle {
    id:root
    width: 400
    height: 350
    color: "#000000"
    radius: 2
    border.color: "#262626"
    border.width: 6
    property alias mouseAreaSalir: mouseAreaSalir

    Rectangle {
        id: rectangleCerrar
        x: 164
        y: 305
        width: 72
        height: 37
        color: "#0f0b0b"
        radius: 18
        border.width: 2
        border.color: "#2865b3"

        MouseArea{
            anchors.fill: parent
            id:mouseAreaSalir
            onClicked: {
                root.visible=false;
                root.z=0;
            }

            Text {
                id: textCerrar
                color: "#e2e2e2"
                text: qsTr("Cerrar")
                z: 3
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 12
            }

        }
    }

    Image {
        id: image1
        x: 18
        y: 18
        width: 100
        height: 26
        source: "images/autodj.png"
    }

    Text {
        id: text1
        x: 124
        y: 18
        width: 259
        height: 110
        color: "white"
        text: qsTr("AutoDj: Permite reproducir de forma automata todos los tracks que se encuentran en la lista. Realizando mezclas suaves entre cancion y cancion.\nMientras tanto podemos elegir otra pista,  agregarla y dejar a la funcion Autodj que realice su trabajo.")
        wrapMode: Text.WordWrap
        font.pixelSize: 12
    }

    Image {
        id: image2
        x: 18
        y: 141
        width: 100
        height: 61
        source: "images/agregarpista.png"
    }

    Text {
        id: text2
        x: 124
        y: 141
        width: 259
        height: 61
        color: "white"
        text: qsTr("Agregar Pista: Antes de agregar una pista, debo seleccionarla desde la lista, no debe estar en reproduccion ninguna cancion en la bandeja escogida.")
        wrapMode: Text.WordWrap
        font.pixelSize: 12
    }

    Rectangle {
        id: rectangle1
        x: 18
        y: 224
        width: 100
        height: 34
        color: "#b3c31860"
        radius: 3
        border.color: "#8f033a"
        opacity: 0.7

        Text {
            id: text3
            color: "#ffffff"
            text: qsTr("Carpeta")
            verticalAlignment: Text.AlignVCenter
            anchors.fill: parent
            font.bold: true
            font.pixelSize: 12
        }
    }

    Text {
        id: text4
        x: 124
        y: 224
        width: 259
        height: 61
        color: "white"
        text: qsTr("Seccion Carpeta: Veremos que la lista se divide por secciones, estas son las carpetas, al tocarlas nos mostrara el resto de las carpetas.Si seleccionamos una nos llevara a la escogida")
        font.pixelSize: 12
        wrapMode: Text.WordWrap
    }

}

