import QtQuick 2.0
import Qt.labs.folderlistmodel 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import PluginSqlite 1.0

Rectangle {
    id:root
    width: 400
    height: 350
    color: "#000000"
    radius: 2
    border.color: "#262626"
    border.width: 1

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
            if (sqlSetting.get(1).Desc!==""){
                textInputCrossfade.text=sqlSetting.get(1).Desc
            }
    }

    onVisibleChanged: {
        if (visible===true)
            textInputCrossfade.focus=true
        else
            textInputCrossfade.focus=false
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
        y: 65
        width: 366
        height: 196
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


    Text {
        id: textExiste
        x: 95
        y: 303
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
        x: 37
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
    BotonBuscar{
        id:botonSave
        x: 165
        y: 324
        textBuscar: "Guardar"
        onClicked: {
            sqlSetting.setDatabase("/QML/OfflineStorage/Databases/mx.sqlite")
            sqlSetting.setQuery("DELETE FROM SETTING")
            sqlSetting.setQuery('INSERT INTO SETTING ("id","Desc") VALUES ("1","'+ultimodir+'")')
            sqlSetting.setQuery('INSERT INTO SETTING ("id","Desc") VALUES ("2","'+textInputCrossfade.text+'")')

            actualizaColeccion.start();
            root.visible=false;
        }
    }

    Text {
        id: text2
        x: 15
        y: 41
        color: "#ffffff"
        text: qsTr("CrossFade")
        font.pixelSize: 12
    }

    TextField {
        id: textInputCrossfade
        x: 84
        y:39
        width: 67
        z:4
        height: 20
        placeholderText: qsTr("Duration")
        activeFocusOnPress: true
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 12
        focus:true

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

    Text {
        id: text3
        x: 157
        y: 41
        color: "#ffffff"
        text: qsTr("ms")
        font.pixelSize: 12
    }

}

