import QtQuick 2.2
import QtQuick.Window 2.0
import Qt.labs.folderlistmodel 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtMultimedia 5.0
import QtQuick.Controls.Styles 1.2
import "logic.js" as Logic
import PluginSqlite 1.0


Window {
    id: window1
    visible: true
    height: Screen.height
    width: Screen.width
    color: "#000000"
    title: "MX"

    property int solouno: 0 //registra cuando encuentra el primero de la busqueda
    property int ultimoindice: 0
    property string pistaSeleccionada: ""
    property bool switchAutoDJ: true
    property int indexA: 0 //indice de pista cargada
    property int indexB: 0 //indice de pista cargada
    property int intervalo: 2000 //intervalo de mezcla, tiempo en fundir una pista con otra
    property string ab: ""
    property bool unicaA: false //verifica que en fade out no ejecute mas de una vez la misma pista
    property bool unicaB: false



    SQLiteModel{id:consulta}

   Component.onCompleted: //termino de cargar la app, cargo seteo y pongo indice en el primer lugar
   {
       seteo()
       folderListView.currentIndex=0
   }

   Audio{id:pistaA }
   Audio{id:pistaB }

   Setting{ //ventana preferencias
       id:setting
       anchors.verticalCenter: parent.verticalCenter
       anchors.horizontalCenter: parent.horizontalCenter
       visible: false
       onVisibleChanged: {
           if(visible===true)
           {
               textInputBuscar.focus=false
           }else{
               textInputBuscar.focus=true
               seteo()
           }
       }
   }


   Carpetas{ //ventana carpetas
       id:carpetas
       anchors.verticalCenter: parent.verticalCenter
       anchors.horizontalCenter: parent.horizontalCenter
       visible: false
       onVisibleChanged: {
           if(visible===true)
           {
               textInputBuscar.focus=false
           }else{
               textInputBuscar.focus=true
           }
       }
   }

   Help{ //ventana ayuda
       id:ayuda
       anchors.verticalCenter: parent.verticalCenter
       anchors.horizontalCenter: parent.horizontalCenter
       visible: false
   }

   Timer { //trigger de carga de musica
       id: cargaColeccion
       running: true
       triggeredOnStart: true
       onTriggered: {
           myModelMusica.cargarModelo(myDirectorio);
           folderListView.model=myModelMusica
       }
    }


ControlSuperior { //panel superior
    id: controlSuperior
    z:1
    height: 30
    opacity: 0.8
    anchors.top: parent.top
    anchors.topMargin: 0
    anchors.right: parent.right
    anchors.rightMargin: 0
    anchors.left: parent.left
    anchors.leftMargin: 0
}


ListView { //lista de temas
    id: folderListView
    height: 500
    anchors.left: parent.left
    anchors.leftMargin: 0
    anchors.right: parent.right
    anchors.rightMargin: 0
    clip: true
    anchors.top: controlSuperior.bottom
    anchors.bottom: rectangleControles.top
    anchors.bottomMargin: 4
    flickableDirection: Flickable.VerticalFlick
    delegate: eligeItemDelegate
    highlightMoveDuration: 0
    highlight: Rectangle {
        anchors.fill: itemLista;
        color: "#404040"
    }

    onCountChanged: {textcantidadtracks.text=folderListView.count.toString()+" tracks"}

    section {
        property:"abc"
        criteria: ViewSection.FullString
        delegate: Rectangle{
            width: window1.width; height: textoSection.height+10
            color:"#1d1d26"
            Text {
                id:textoSection
                minimumPixelSize: 10; font.pixelSize: 16;
                font.bold: true
                color: "#e84f43"
                text: section.toUpperCase()
                width: parent.width
                wrapMode: Text.WordWrap
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    carpetas.visible=true
                    carpetas.z=6;
                }
            }
        }
    }
}


    Component { //item de la lista
        id: eligeItemDelegate
        Item {
            id: itemLista
            height: 30
            width: folderListView.width

            Image {
                id: fileIcon
                width: 26
                height: 20
                anchors { left: parent.left; verticalCenter: parent.verticalCenter }
                source: "images/audio.png"
                antialiasing: true
            }
            Text {
                id:elementoLista
                anchors {
                    left: parent.left
                    leftMargin: 35
                    verticalCenter: parent.verticalCenter
                }
                elide: Text.ElideRight
                minimumPixelSize: 10; font.pixelSize: 14;
                font.letterSpacing: -1
                color: "#ffcd8b"
                text: archivo.toUpperCase()
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    folderListView.currentIndex=index
                    ultimoindice=index
                    pistaSeleccionada="file://"+myModelMusica.get(index).ubicacion;
                }
                onDoubleClicked: {
                    folderListView.currentIndex=index
                    ultimoindice=index+1
                    pistaSeleccionada="file://"+myModelMusica.get(index).ubicacion;
                    cargoManual()
                }

            }
        }
    }


Image {
    id: rectangleControles
    x: 581
    y: 624
    width: window1.width
    height: 180
    fillMode: Image.Tile
    source: "images/Fondox.net_textura-de-metal_1280x720.jpg"
    z: 2
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 0
    anchors.horizontalCenter: parent.horizontalCenter

    Image {
        id: imageAyuda
        y: 100
        width: 35
        height: 34
        anchors.verticalCenterOffset: 42
        anchors.left: botonPlayB.right
        anchors.leftMargin: 21
        anchors.verticalCenter: controlMedio.verticalCenter
        source: "images/help.png"
        MouseArea{
            anchors.fill: parent
            onClicked: {
                ayuda.z=6;
                ayuda.visible=true;
            }
        }
    }

    Image {
        id: imageSetting
        x: 392
        y: 100
        width: 35
        height: 34
        anchors.verticalCenterOffset: 38
        anchors.right: botonPlayA.left
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        source: "images/setting.png"
        MouseArea{
            anchors.fill: parent
            onClicked: {                
                setting.z=6;
                setting.visible=true
            }
        }
    }

    Image {
        id: botonPlayA
        x: 447
        y: 47
        anchors.right: controlMedio.left
        anchors.rightMargin: 6
        fillMode: Image.PreserveAspectFit
        sourceSize.height: 100
        sourceSize.width: 100
        source: "images/disable_play_button.png"

        MultiPointTouchArea{
            anchors.fill: parent
            maximumTouchPoints: 2
            onPressed: {
                playPistaA()
            }
       }

        Label {
            id: labeltiempopistaA
            color: "#ffffff"
            text: qsTr("")
            verticalAlignment: Text.AlignVCenter
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
        }
        }

    Image {
        id: botonPlayB
        x: 813
        y: 17
        anchors.verticalCenterOffset: 5
        anchors.left: controlMedio.right
        anchors.leftMargin: 6
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        sourceSize.width: 100
        sourceSize.height: 100
        source: "images/disable_play_button.png"
        MultiPointTouchArea{
            maximumTouchPoints: 2
            anchors.fill: parent
            onPressed: {
               playPistaB()
            }
        }

        Label {
            id: labeltiempopistaB
            color: "#ffffff"
            text: qsTr("")
            verticalAlignment: Text.AlignVCenter
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
        }
    }

    ControlMedio{
        id:controlMedio
        x: 553
        y: 26
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter

        BotonFuncion {
            id: botonFuncionCenter
            x: 106
            width: 48
            height: 48
            anchors.top: parent.top
            anchors.topMargin: 9
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {miSlider1.xSlider=100}
        }

        MiSlider {
            id: miSlider1
            y: 78
            height: 10
            anchors.right: parent.right
            anchors.rightMargin: 13
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 32
            anchors.left: parent.left
            anchors.leftMargin: 17
            onXSliderChanged: {volumenPistas()}
        }

        BotonFuncion {
            id: botonAgregaA
            width: 47
            height: 47
            anchors.top: parent.top
            anchors.topMargin: 9
            anchors.left: parent.left
            anchors.leftMargin: 17
            textoBoton: "+"
            onClicked: {
                if (pistaA.playbackState===0)
                    cargoPista("A");
            }
            onPressandhold: {
                quitoPista("A");
            }
        }

        BotonFuncion {
            id: botonAgregaB
            x: 197
            width: 47
            height: 47
            anchors.top: parent.top
            anchors.topMargin: 9
            anchors.right: parent.right
            anchors.rightMargin: 16
            textoBoton: "+"
            onClicked: {
                if (pistaB.playbackState===0)
                    cargoPista("B");
            }
            onPressandhold: {
                quitoPista("B");
            }
        }

        Text {
            id: textcantidadtracks
            x: 113
            y: 105
            color: "#666666"
            text: qsTr("Tracks")
            anchors.horizontalCenterOffset: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 12
        }
    }


    TextField {
        id: textInputBuscar
        y:2
        z:4
        height: 20
        anchors.right: botonBuscar.left
        anchors.rightMargin: 6
        anchors.left: etiquetaA.right
        anchors.leftMargin: 6
        placeholderText: qsTr("Buscar...")
        activeFocusOnPress: true
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 12
        focus:true

        onTextChanged: {
            solouno=0;
            botonBuscar.textBuscar="Buscar"
        }
        onAccepted: {
            buscar()
            botonBuscar.textBuscar="Otro"
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
        id: botonBuscar
        x: 739
        y: 2
        width: 70
        height: 20
        anchors.right: etiquetaB.left
        anchors.rightMargin: 6
        onClicked: {buscar()}

    }

    Etiqueta {
        id: etiquetaA
        x: 447
        y: 0
        width: 100
        height: 47
        anchors.right: controlMedio.left
        anchors.rightMargin: 6
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 133
        onClicked: {folderListView.currentIndex=indexA}
    }
    Etiqueta {
        id: etiquetaB
        y: 0
        width: 100
        height: 47
        anchors.left: controlMedio.right
        anchors.leftMargin: 6
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 133
        onClicked: {folderListView.currentIndex=indexB}
    }

    Image {
        id: imageRanking
        x: 392
        y: 12
        width: 35
        height: 35
        anchors.right: etiquetaA.left
        anchors.rightMargin: 20
        source: "images/top.png"

        MouseArea {
            id: mouseArea1
            anchors.fill: parent
            onClicked: {ranking.visible=true}
        }
    }
}

Ranking{  //ventana ranking
    id:ranking
    z: 4
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    visible: false
}

Switcher{ //switch de autodj
    id:theSwitch
    x: 1292
    anchors.top: parent.top
    anchors.topMargin: 2
    anchors.right: parent.right
    anchors.rightMargin: 6
    z: 3
}

Timer{  //timer de fade automatico
    id:faderautomatico
    running: false; repeat: true
    onTriggered:
    {
        if (ab==="A"){
            if(miSlider1.xSlider > 0) //0.00
            {
                miSlider1.xSlider -= 1;//0.01
            }else{
                pistaB.stop()
                unicaB=false
                limpiarPistas("B")
                detieneTimer()

                getNextSong()
                cargoPista("B")
            }
        }else if (ab==="B"){
            if(miSlider1.xSlider < 200)//1.90
            {
                miSlider1.xSlider += 1;//0.01
            }else {
                pistaA.stop()
                unicaA=false
                limpiarPistas("A")
                detieneTimer()

                getNextSong()
                cargoPista("A")
            }
        }
        volumenPistas()
    }
}

Timer{ //timer de control de fin de pista
    id:finPista
    running: false;repeat: true
    onTriggered: {
        if (pistaA.playbackState===1){
            labeltiempopistaA.text="-"+Logic.getTimeFromMSec(pistaA.duration-pistaA.position)
            etiquetaA.textoEtiqueta=pistaA.metaData.albumArtist+"\n("+pistaA.metaData.title+")" // show track meta data
            controlSuperior.nowPlayingA("Playing: "+pistaA.metaData.albumArtist+" ("+pistaA.metaData.title+") "+(pistaA.metaData.audioBitRate/1000)+" bitrate") // show track meta data

            if((pistaA.duration-pistaA.position)<intervalo && unicaB===false){//Esto lo tiene que hacer una sola vez
                    unicaB=true
                    playPistaB()
            }
        }
        if(pistaB.playbackState===1){
            labeltiempopistaB.text="-"+Logic.getTimeFromMSec(pistaB.duration-pistaB.position)
            etiquetaB.textoEtiqueta=pistaB.metaData.albumArtist+"\n("+pistaB.metaData.title+")" // show track meta data
            controlSuperior.nowPlayingB("Playing: "+pistaB.metaData.albumArtist+" ("+pistaB.metaData.title+") "+(pistaB.metaData.audioBitRate/1000)+" bitrate") // show track meta data

            if((pistaB.duration-pistaB.position)<intervalo && unicaA===false){//Esto lo tiene que hacer una sola vez
                    unicaA=true
                    playPistaA()
            }
        }

    }
}


function playPistaA()
{
    ab="A";
    pistaA.play()
    estadisPista(pistaA.source)
    finPista.running=true
    intervaloMezcla(intervalo/miSlider1.xSlider)
    if(theSwitch.on===true)
        iniciaTimer()
    else
        detieneTimer()
}

function playPistaB()
{
    ab="B";
    pistaB.play()
    estadisPista(pistaB.source)
    finPista.running=true
    intervaloMezcla((intervalo/(200-miSlider1.xSlider)))
    if(theSwitch.on===true)
        iniciaTimer()
    else
        detieneTimer()
}

function intervaloMezcla(arg)
{
    faderautomatico.interval=arg
}

function iniciaTimer()
{
    faderautomatico.running=true
}

function detieneTimer()
{
    faderautomatico.running=false
}

function limpiarPistas(pista)
{
    if (pista==="A"){
        botonPlayA.source="/images/disable_play_button.png"
        etiquetaA.textoEtiqueta="No Track"
        labeltiempopistaA.text=""
        controlSuperior.nowPlayingA("")
        pistaA.source=""      
    }
    if (pista==="B"){
        botonPlayB.source="/images/disable_play_button.png"
        etiquetaB.textoEtiqueta="No Track"
        labeltiempopistaB.text=""
        controlSuperior.nowPlayingB("")
        pistaB.source=""
    }
}

function intToFloat(num,decplaces)
{
    return num.toFixed(decplaces);
}

function volumenPistas()
{
    var valA=(200-miSlider1.xSlider)/100;
    var valB=miSlider1.xSlider/100;

    pistaA.volume=intToFloat(valA,1)
    pistaB.volume=intToFloat(valB,1)

    controlSuperior.opacidadNowPlaying(miSlider1.xSlider/100) //cambia la opacidad entre nombre de una pista y la otra
}

function seteo()
{
    consulta.setDatabase("/QML/OfflineStorage/Databases/mx.sqlite")
    consulta.setQuery("Select * from setting where id='2'")
    if (consulta.get(0).Desc!=="")
    {
        intervalo=consulta.get(0).Desc
    }
}

function buscar()
{
    for(var i = ultimoindice; i < folderListView.count;i++)
    {
        var cadena=myModelMusica.get(i).ubicacion;
        cadena=cadena.toUpperCase();
        if(cadena.indexOf(textInputBuscar.text.toUpperCase()) > -1)
        {
            if (solouno===0) //el primero que encuentra
                solouno=i
            pistaSeleccionada="file://"+myModelMusica.get(i).ubicacion
            folderListView.currentIndex=i;
            ultimoindice=i+1;
            return;
        }
    }
    folderListView.currentIndex=solouno
    pistaSeleccionada="file://"+myModelMusica.get(solouno).ubicacion
    ultimoindice=solouno+1
}

function estadisPista(argPista)
{
    consulta.setDatabase("/QML/OfflineStorage/Databases/mx.sqlite")
    consulta.setQuery("insert or replace into log (id, archivo, reprod) values ((select id from log where archivo = '"+argPista+"'),'"+argPista+"',(select ifnull(reprod,0) from log where archivo = '"+argPista+"')+1)")
}

function cargoManual()
{
    if((pistaA.status===1 || pistaA.status===3) && pistaA.playbackState===0)
    {
        cargoPista("A",ultimoindice)
    }
    else if ((pistaB.status===1 || pistaB.status===3) && pistaB.playbackState===0)
    {
        cargoPista("B",ultimoindice)
    }

    //1 no media,2 Loading, 6 buffered, 3 Loaded

    if((pistaA.status===3 || pistaA.status===2) && pistaA.playbackState===0)
    {
        playPistaA()
    }
    else if ((pistaB.status===3 || pistaB.status===2) && pistaB.playbackState===0)
    {
        playPistaB()
    }
}

function getNextSong()
{
    if (textInputBuscar.text==="")
    {
        //folderListView.currentIndex=ultimoindice;
        folderListView.incrementCurrentIndex();
        ultimoindice=folderListView.currentIndex;
        pistaSeleccionada="file://"+myModelMusica.get(folderListView.currentIndex).ubicacion;
    }else{
        buscar()
    }
}

function cargoPista(pista)
{
    if (pistaSeleccionada.length!==0)//si la pista seleccionada no esta vacia
    {

    if (pista==="A")
    {
        indexA=folderListView.currentIndex
        if (pistaA.playbackState===0)
        {
            pistaA.source=pistaSeleccionada
            etiquetaA.textoEtiqueta="Loaded"
            labeltiempopistaA.text=""
            botonPlayA.source="/images/loaded_play_button.png"
        }
    }
    if (pista==="B")
    {
        indexB=folderListView.currentIndex
        if (pistaB.playbackState===0)
        {
            pistaB.source=pistaSeleccionada
            etiquetaB.textoEtiqueta="Loaded"
            labeltiempopistaB.text=""
            botonPlayB.source="/images/loaded_play_button.png"
        }
    }

    }else{
        getNextSong() ////si la pista seleccionada esta vacia elige la primera despues del indice actual
    }
}

function quitoPista(pista)
{
    if(pista==="A")
    {
        if (pistaA.playbackState===0)
        {
            limpiarPistas("A")
        }
    }
    if(pista==="B")
    {
        if(pistaB.playbackState===0)
        {
            limpiarPistas("B")
        }
    }
}


}

