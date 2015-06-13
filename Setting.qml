import QtQuick 2.0
import Qt.labs.folderlistmodel 2.1
import QtQuick.Controls 1.2
import PluginSqlite 1.0

Rectangle {
    id:root
    width: 400
    height: 350
    color: "#000000"
    radius: 2
    border.color: "#262626"
    border.width: 3

    property string ultimodir: ""

    SQLiteModel{id:sqlSetting}

    Component.onCompleted:
    {
            sqlSetting.setDatabase("/QML/OfflineStorage/Databases/mx.sqlite")
            sqlSetting.setQuery("Select * from setting")
            if (sqlSetting.get(0).Desc!==""){
                textSettingGuardado.text=sqlSetting.get(0).Desc
                ultimodir=sqlSetting.get(0).Desc
                actualizaColeccion.start();
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
                rectangleAgregar.enabled=false
                return;
            }else{
                textExiste.text="No es parte de tu lista"
                textAgregar.color="white"
                rectangleAgregar.enabled=true
            }
        }
        }
    }

    BotonCerrar{
        width: 27
        height: 27
        z: 5
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.left: parent.left
        anchors.leftMargin: 4
        onClicked: {
            root.visible=false
            root.z=0;
        }
    }

    ListView {
        id: listaCarpetasView
        x: 15
        y: 37
        width: 366
        height: 224
        clip: true


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

    Timer {
        id: actualizaColeccion
        interval: 100; repeat: false
        running: true
        triggeredOnStart: true

        onTriggered: {
            myModelMusica.cargarModelo(ultimodir);
        }
     }

    Rectangle {
        id: rectangleAgregar
        x: 162
        y: 317
        width: 72
        height: 25
        color: "#0f0b0b"
        radius: 18
        border.width: 2
        border.color: "#2865b3"

        MouseArea{
            id:mouseAreaAgregar
            anchors.fill: parent
            onClicked: {
                sqlSetting.setDatabase("/QML/OfflineStorage/Databases/mx.sqlite")
                sqlSetting.setQuery("DELETE FROM SETTING")
                sqlSetting.setQuery('INSERT INTO SETTING ("Desc") VALUES ("'+ultimodir+'")')
                actualizaColeccion.start();
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
        y: 300
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

    Text {
        id: textSettingGuardado
        x: 15
        y: 265
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

    BotonHome {
        id: botonHome1
        x: 367
        y: 4
        width: 27
        height: 27
        onClicked: {
            folderModel.folder= "file:"+myDirectorio+"/"
            textSettingGuardado.text=""
        }
    }

    Text {
        id: text1
        color: "#ffffff"
        text: qsTr("Elija Musica desde otra Ubicacion")
        anchors.top: parent.top
        anchors.topMargin: 7
        anchors.right: parent.right
        anchors.rightMargin: 111
        anchors.left: parent.left
        anchors.leftMargin: 110
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 12
    }


}

