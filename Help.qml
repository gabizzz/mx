import QtQuick 2.0

Rectangle {
    id:root
    width: 400
    height: 350
    color: "#000000"
    radius: 2
    border.color: "#262626"
    border.width: 1

    BotonCerrar{
        anchors.top: parent.top
        anchors.topMargin: 3
        anchors.left: parent.left
        anchors.leftMargin: 4
        onClicked: {
            root.visible=false
            root.z=0
        }
    }

    Text {
        id: text1
        x: 124
        y: 30
        width: 259
        height: 149
        color: "white"
        text: qsTr("AutoDj: Permite reproducir de forma automata todos los tracks que se encuentran en la lista. Realizando mezclas suaves entre cancion y cancion.\nTambien respeta el factor de busqueda como prioridad a la hora de elegir una nueva cancionMientras tanto podemos elegir otra pista,  agregarla y dejar a la funcion Autodj que realice su trabajo.")
        wrapMode: Text.WordWrap
        font.pixelSize: 12
    }

    Image {
        id: image2
        x: 18
        y: 196
        width: 100
        height: 61
        source: "images/agregarpista.png"
    }

    Text {
        id: text2
        x: 124
        y: 196
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
        y: 269
        width: 100
        height: 34
        color: "#1d1d26"
        radius: 3

        Text {
            id: text3
            color: "#e84f43"
            text: qsTr("Carpeta")
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            font.pixelSize: 12
        }
    }

    Text {
        id: text4
        x: 124
        y: 269
        width: 259
        height: 68
        color: "white"
        text: qsTr("Seccion Carpeta: Veremos que la lista se divide por secciones, estas son las carpetas, al tocarlas nos mostrara el resto de las carpetas.Si seleccionamos una nos llevara a la escogida")
        font.pixelSize: 12
        wrapMode: Text.WordWrap
    }

    Switcher {
        id: switcher1
        x: 50
        y: 30
    }

}

