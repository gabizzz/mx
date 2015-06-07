import QtQuick 2.2
import QtQuick.Window 2.0
import Qt.labs.folderlistmodel 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtMultimedia 5.0
import QtQuick.Controls.Styles 1.2
import "logic.js" as Logic

Window {
    id: window1
    visible: true
    height: Screen.height

    color: "#000000"
    title: "MX"

    Component.onCompleted: {textcantidadtracks.text=folderListView.count.toString()+" tracks"} //muestra cantidad de tracks cargados

    property int indice: 0
    property int ultimoindice: 0
    property bool playingA: false
    property bool playingB: false
    property bool loadA: false
    property bool loadB: false
    property string pistaSeleccionada: ""
    property int tiempoMezcla: 5000
    property double sliderValue: 1.0
    property bool switchAutoDJ: true
    property int indexA: 0
    property int indexB: 0

    width: Screen.width

//    Splash {
//         onTimeout: window1.visible = true
//    }

    function updatePos(value,maxval,minval,xMax,swidth,hwidth) {
        var pos;
        if (maxval > minval) {
            pos = (value - minval) * xMax / (maxval - minval);
            pos = Math.min(pos, swidth - hwidth);
            pos = Math.max(pos, 0);
            controlMedio.updateHandle(pos);
        } else {
            pos = (value - maxval) * xMax / (minval - maxval);
            pos = Math.min(pos, swidth - hwidth);
            pos = Math.max(pos, 0);
            controlMedio.updateHandle(swidth - (hwidth - pos));
        }

        sliderValue=value
        controlSuperior.opacidadNowPlaying(value)

        fadeManual(value)
        //fade entre pistas
    }

    function fadeManual(valorSlider){
        if (valorSlider<1.0)
        {
            pistaB.volume=valorSlider;
            pistaA.volume=1.0;
        }
        if (valorSlider>1.0)
        {
            pistaA.volume=2.0-valorSlider;
            pistaB.volume=1.0;
        }
    }

    function autoDj()
    {
                if(playingA===false)        //si la pista A no esta reproduciendose
                {
                    if (loadA===true)       //si la pista A esta cargada
                    {
                        playPausa("A")
                    }else{                  //si la pista A no esta cargada
                        getNextSong()
                        cargoPista("A",ultimoindice)
                        playPausa("A")
                    }
                }else if(playingB===false){ //si la pista B no esta reproduciendose
                    if (loadB===true)       //si la pista B esta cargada
                    {
                        playPausa("B")
                    }else{                  //si la pista B no esta cargada
                        getNextSong()
                        cargoPista("B",ultimoindice)
                        playPausa("B")
                    }
                }
    }

    function controlFinPista(pista){
        if (pista==="B")
        {
            if(pistaB.status===7)
            {
                limpiarPista("B")
            }
        }
        if (pista==="A")
        {
            if(pistaA.status===7)
            {
                limpiarPista("A")
            }
        }

    }

    function getNextSong()
    {      
        folderListView.incrementCurrentIndex();
        ultimoindice=folderListView.currentIndex;
        pistaSeleccionada="file://"+myModelMusica.get(folderListView.currentIndex).ubicacion;
    }

    function cargoPista(pista,argIndex)
    {
        console.log(argIndex)
        if (pistaSeleccionada.length!==0)//si la pista seleccionada no esta vacia
        {

        if (pista==="A")
        {
            indexA=argIndex
            if (playingA===false)
            {
                pistaA.source=pistaSeleccionada
                controlMedio.addA()
                etiquetaA.textoEtiqueta="Loaded"
                labeltiempopistaA.text=""
                botonPlayA.source="/images/loaded_play_button.png"
                loadA=true
            }
        }
        if (pista==="B")
        {
            indexB=argIndex
            if (playingB===false)
            {
                controlMedio.addB()
                pistaB.source=pistaSeleccionada
                etiquetaB.textoEtiqueta="Loaded"
                labeltiempopistaB.text=""
                botonPlayB.source="/images/loaded_play_button.png"
                loadB=true
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
            if (playingA===false)
            {
                limpiarPista("A")
            }
        }
        if(pista==="B")
        {
            if(playingB===false)
            {
                limpiarPista("B")
            }
        }
    }


    function playPausa(pista)
    {
        if(pista==="A")
        {
            if (playingA===false)
            {
                if (etiquetaA.textoEtiqueta!=="No Track")
                {
                    botonPlayA.source="qrc:/images/play_button.png"
                    pistaA.play()
                    playingA=true
                    timerPistaA.running=true
                    if (switchAutoDJ)
                    {
                        fadepistaATimer.interval=tiempoMezcla/(sliderValue*100)
                        fadepistaATimer.start()
                    }
                }
            }else{
                //si la pista esta reproduciendose
                //pregunto si el volumen esta de su lado
                if (sliderValue>1.0){
                    pistaA.pause()
                    controlSuperior.nowPlayingA("Pause: "+pistaA.metaData.albumArtist+" ("+pistaA.metaData.title+") "+(pistaA.metaData.audioBitRate/1000)+" bitrate") // show track meta data
                    botonPlayA.source="qrc:/images/play_button_pause.png"
                    playingA=false
                    timerPistaA.stop()
                }
            }
        }
        if(pista==="B")
        {
            if (playingB===false)
            {
                if (etiquetaB.textoEtiqueta!=="No Track")
                {
                    pistaB.play()
                    timerPistaB.running=true
                    botonPlayB.source="qrc:/images/play_button.png"
                    playingB=true
                    if (switchAutoDJ)
                    {
                        fadepistaBTimer.interval=tiempoMezcla/((2.0-sliderValue)*100)//el valor max menos la pos del slider
                        fadepistaBTimer.start()
                    }
                }
            }else{
                 if (sliderValue<1.0){
                        pistaB.pause()
                        controlSuperior.nowPlayingB("Pause: "+pistaB.metaData.albumArtist+" ("+pistaB.metaData.title+") "+(pistaB.metaData.audioBitRate/1000)+" bitrate") // show track meta data
                        botonPlayB.source="qrc:/images/play_button_pause.png"
                        playingB=false
                        timerPistaB.stop()
                 }
            }
        }
    }

    function limpiarPista(pista)
    {
        if (pista==="A"){
            controlMedio.quitoA()
            botonPlayA.source="/images/disable_play_button.png"
            etiquetaA.textoEtiqueta="No Track"
            labeltiempopistaA.text=""
            controlSuperior.nowPlayingA("")
            pistaA.source=""
            loadA=false
            playingA=false
        }
        if (pista==="B"){
            controlMedio.quitoB()
            botonPlayB.source="/images/disable_play_button.png"
            etiquetaB.textoEtiqueta="No Track"
            labeltiempopistaB.text=""
            controlSuperior.nowPlayingB("")
            pistaB.source=""
            loadB=false
            playingB=false
        }
    }

    function buscar()
    {
        for(var i = indice; i < folderListView.count;i++)
        {
            var cadena=myModelMusica.get(i).ubicacion;
            cadena=cadena.toUpperCase();
            if(cadena.indexOf(textInputBuscar.text.toUpperCase()) > -1)
            {
                pistaSeleccionada="file://"+myModelMusica.get(i).ubicacion
                folderListView.currentIndex=i;
                console.log(pistaSeleccionada)
                indice=i+1;
                return;
            }
        }
    }

ControlSuperior {
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
    switchADj.checked: true

    switchADj.onCheckedChanged: {
        switchAutoDJ=switchADj.checked
    }
}
//ver si la pista esta en pausa y corro el fade para su lado en auto dj, la finaliza y reproduce la otra (corregir)
    Timer {
        id:fadepistaATimer
        repeat: true;
        onTriggered: {
            if(sliderValue > 0.00) {
                sliderValue -= 0.01;
            }else if(sliderValue <0.10){
                timerPistaB.stop()
                fadepistaATimer.stop()
                sliderValue=0.1
                limpiarPista("B")
            }
            controlMedio.updateSliderValue(sliderValue)
        }
    }

    Timer {
        id:fadepistaBTimer
        repeat: true;
        onTriggered: {
            if(sliderValue < 1.90)
            {
                sliderValue += 0.01;
            }else if(sliderValue >1.90){
                timerPistaA.stop()
                fadepistaBTimer.stop()
                sliderValue=2.00
                limpiarPista("A")
            }
            controlMedio.updateSliderValue(sliderValue)
        }
    }   

    Audio{
        id:pistaA
        source: ""
    }
    Audio{
        id:pistaB
        source: ""
    }
    Component {
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
                font.pixelSize: 20
                font.letterSpacing: -1
                color: "#c5cae9"
                text: archivo
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    folderListView.currentIndex=index
                    ultimoindice=index
                    pistaSeleccionada="file://"+myModelMusica.get(index).ubicacion;
                }
                onDoubleClicked: {
                    if (fadepistaBTimer.running)
                        fadepistaBTimer.stop()
                    else if (fadepistaATimer.running)
                        fadepistaATimer.stop()

                    if(loadA===false)
                    {
                        cargoPista("A",ultimoindice)
                    }
                    else if (loadB===false)
                    {
                        cargoPista("B",ultimoindice)
                    }
                    if(loadA===true && playingA===false)
                    {
                        playPausa("A")
                    }
                    else if (loadB===true && playingB===false)
                    {
                        playPausa("B")
                    }
                }
            }
        }
    }

ListView {
    id: folderListView
    width: 1346
    height: 500
    clip: true
    anchors.top: controlSuperior.bottom
    anchors.bottom: rectangleControles.top
    anchors.bottomMargin: 4
    flickableDirection: Flickable.VerticalFlick
    model: myModelMusica
    delegate: eligeItemDelegate
    highlightMoveDuration: 0
    highlight: Rectangle {
        anchors.fill: itemLista;
        color: "#303F9F"
    }
    section {
        property:"abc"
        criteria: ViewSection.FullString
        delegate: Rectangle{
            width: window1.width; height: textoSection.height+10
            color:"#C2185B"
            Text {
                id:textoSection
                font.pointSize: 10
                font.bold: true
                color: "#FFFFFF"
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

Setting{
    id:setting
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    visible: false
}

Carpetas{
    id:carpetas
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    visible: false
}

Help{
    id:ayuda
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    visible: false
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
        anchors.verticalCenterOffset: 9
        anchors.left: botonPlayB.right
        anchors.leftMargin: 20
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
        x: 362
        y: 100
        width: 35
        height: 34
        anchors.verticalCenterOffset: 6
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


        //MouseArea{
        MultiPointTouchArea{
            anchors.fill: parent
            maximumTouchPoints: 2
            onPressed: {
                playPausa("A")
            }
            Timer {
                id:timerPistaA
                interval: 1000; repeat: true;
                onTriggered: {
                    labeltiempopistaA.text="-"+Logic.getTimeFromMSec(pistaA.duration-pistaA.position)
                    etiquetaA.textoEtiqueta=pistaA.metaData.albumArtist+"\n("+pistaA.metaData.title+")" // show track meta data
                    controlSuperior.nowPlayingA("Playing: "+pistaA.metaData.albumArtist+" ("+pistaA.metaData.title+") "+(pistaA.metaData.audioBitRate/1000)+" bitrate") // show track meta data

                    if(Logic.getTimeFromMSec(pistaA.position)===Logic.getTimeFromMSec(pistaA.duration-tiempoMezcla))
                    {
                        if (switchAutoDJ===true)
                        {
                            autoDj()
                        }
                    }
                    controlFinPista("A")
                }
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
                playPausa("B")
            }
            Timer {
                id:timerPistaB
                interval: 1000; repeat: true;
                onTriggered: {
                    labeltiempopistaB.text="-"+Logic.getTimeFromMSec(pistaB.duration-pistaB.position)
                    etiquetaB.textoEtiqueta=pistaB.metaData.albumArtist+"\n("+pistaB.metaData.title+")" // show track meta data
                    controlSuperior.nowPlayingB("Playing: "+pistaB.metaData.albumArtist+" ("+pistaB.metaData.title+") "+(pistaB.metaData.audioBitRate/1000)+" bitrate") // show track meta data


                    if(Logic.getTimeFromMSec(pistaB.position)===Logic.getTimeFromMSec(pistaB.duration-tiempoMezcla))
                    {
                        if (switchAutoDJ===true)
                        {
                            autoDj()
                        }
                    }                    
                    controlFinPista("B")
                }
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
        onAgregaAPressed: {
            if (playingA===false)
            cargoPista("A",ultimoindice);
        }
        onAgregaAPressAndHold: {
            quitoPista("A");
        }
        onAgregaBPressed: {
            if (playingB===false)
            cargoPista("B",ultimoindice);
        }
        onAgregaBPressAndHold: {
            quitoPista("B");
        }
        onSliderUpdatePos: {
            updatePos(value,maxval,minval,xMax,swidth,hwidth);
        }
    }


    TextField {
        id: textInputBuscar
        y: 2
        z:4
        height: 20
        anchors.right: rectangleBuscar.left
        anchors.rightMargin: 6
        anchors.left: etiquetaA.right
        anchors.leftMargin: 6
        placeholderText: qsTr("Buscar...")
        focus: true
        activeFocusOnPress: true
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 12
        onTextChanged: {
            indice=0;
        }

        onAccepted: {
            buscar()
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

    Rectangle {
        id: rectangleBuscar
        x: 739
        y: 2
        width: 74
        height: 20
        color: "#2865b3"
        radius: 3
        anchors.right: etiquetaB.left
        anchors.rightMargin: 6

        Text {
            id: textBuscar
            color: "#ffffff"
            text: qsTr("Buscar")
            verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent
            font.pixelSize: 12
        }

        MouseArea {
            id: mouseAreaBuscar
            anchors.fill: parent
            onClicked: buscar()
        }
    }

    Text {
        id: textcantidadtracks
        x: 671
        y: 157
        color: "#a6a6a6"
        text: qsTr("Tracks")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 12
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
}
}

