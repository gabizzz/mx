import QtQuick 2.0
import Qt.labs.folderlistmodel 2.1
import QtQuick.Controls 1.2

Rectangle {
    id:root
    width: 400
    height: 350
    color: "#000000"
    radius: 2
    border.color: "#262626"
    border.width: 6

    property alias mouseAreaSalir: mouseAreaSalir
    property string ultimodir: ""

    onVisibleChanged: {
        if (visible===true)
        {
            textSettingGuardado.text=myQuery.select();
            //Base.printValues();
        }
    }

    function carpetaFinal(argumento)
    {
        var str = argumento;
        var res = str.split("/");
        return res[res.length-1]
    }

    function verificaExistencia(argumento)
    {
        if (argumento!==".." && argumento!==".") //busca la carpeta que quiero agregar por las dudas ya exista
        {
        for(var i = 0; i < folderListView.count;i++)
        {
            var cadena=myModelMusica.get(i).ubicacion;
            if(cadena.indexOf(argumento) > -1)
            {
                textExiste.text="Ya es parte de su lista!"
                textAgregar.color="grey"
                return;
            }else{
                textExiste.text=""
                textAgregar.color="white"
            }
        }
        }
    }

    ListView {
        id: listaCarpetasView
        x: 15
        y: 38
        width: 366
        height: 223


        FolderListModel {
            id: folderModel
            showFiles: false
            showDotAndDotDot: true
            folder: "file:"+myDirectorio+"/"
        }

        Component {
            id: fileDelegate

            Item {
                height: 38
                width: listaCarpetasView.width

                Image {
                    id: folderIcon
                    width: 32
                    height: 32
                    anchors { left: parent.left; verticalCenter: parent.verticalCenter }
                    source: "/images/folder.png"
                    visible: folderModel.isFolder(index)
                }
                Text {
                    id:elementoLista
                    anchors {
                        left: folderIcon.right
                        right: parent.right
                        leftMargin: 5
                        verticalCenter: parent.verticalCenter
                    }
                    elide: Text.ElideRight
                    font.pixelSize: 20
                    font.letterSpacing: -1
                    color: "white"
                    text: fileName
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        listaCarpetasView.currentIndex = index
                        folderModel.folder += "/" + fileName
                        ultimodir=filePath                        
                        verificaExistencia(fileName)
                    }
                }
            }
        }

        model: folderModel
        delegate: fileDelegate
    }

    Rectangle {
        id: rectangleCerrar
        x: 309
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

    Rectangle {
        id: rectangleAgregar
        x: 15
        y: 305
        width: 72
        height: 37
        color: "#0f0b0b"
        radius: 18
        border.width: 2
        border.color: "#2865b3"

        MouseArea{
            id:mouseAreaAgregar
            anchors.fill: parent
            onClicked: {
                //Base.deleteValues();
                //Base.insertValues(ultimodir)
                myQuery.deleteValues();
                myQuery.insertValues('INSERT INTO SETTING ("Desc") VALUES ("'+ultimodir+'")');
                myModelMusica.cargarModelo(ultimodir)
                root.visible=false;
            }

            Text {
                id: textAgregar
                color: "#e2e2e2"
                text: qsTr("Guardar")
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 12
            }

        }
    }

    Text {
        id: textExiste
        x: 93
        y: 316
        width: 210
        height: 15
        color: "#2865b3"
        text: qsTr("")
        z: 0
        font.bold: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 12
    }

    Rectangle {
        id: rectangleTitulo
        x: 8
        y: 8
        width: 384
        height: 24
        color: "#0c0a0a"
        z: 3

        Text {
            id: text1
            x: 8
            y: 5
            width: 368
            height: 15
            color: "#ffffff"
            text: qsTr("Elija Musica desde otra Ubicacion")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12
        }
    }

    Rectangle {
        id: rectangleAviso
        x: 8
        y: 267
        width: 384
        height: 32
        color: "#0c0a0a"
        z: 4

        Text {
            id: textSettingGuardado
            x: 7
            y: 0
            width: 366
            height: 32
            color: "#e41b69"
            text: qsTr("")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
            z: 1
            wrapMode: Text.WordWrap
            font.pixelSize: 12
        }
    }

}

