import QtQuick 2.2
import QtQuick.Controls 1.2

Rectangle {
    id: controlMedio
    width: 260
    height: 120
    color: "#000000"
    radius: 10

    signal agregaAPressed()
    signal agregaAPressAndHold()
    signal agregaBPressed()
    signal agregaBPressAndHold()
    signal sliderUpdatePos(var value,var maxval,var minval,var xMax,var swidth,var hwidth)

    function updateHandle(x){
            handle.x=x;
    }
    function updateSliderValue(valorSlider){
            slider.value=valorSlider;
    }
    function quitoA(){
            imagenAgregaA.border.color="#696969"
    }
    function quitoB(){
            imagenAgregaB.border.color="#696969"
    }
    function addA(){
            imagenAgregaA.border.color="#2865b3"
    }
    function addB(){
            imagenAgregaB.border.color="#e41b69"
    }


    Rectangle {
        id: imagenAgregaA
        y: 4
        anchors.left: parent.left
        anchors.leftMargin: 5
        transformOrigin: Item.Center
        color: "#3b3a3a"
        height: 48
        width: 48
        radius: 10
        border.width: 2
        border.color: "#696969"

        Text {
            id: textA
            text: qsTr("+")
            font.bold: true
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 26
        }

        SequentialAnimation {
            id: animBotonAgregaA
            ColorAnimation {target: imagenAgregaA;properties: "color"; to: "#2865b3"; duration: 50 }
            ColorAnimation {target: imagenAgregaA;properties: "color"; to: "#3b3a3a"; duration: 0 }
        }



        MouseArea {
            anchors.fill: parent
            onPressAndHold: {
                controlMedio.agregaAPressAndHold()
            }
            onPressed: {
                animBotonAgregaA.running=true
                controlMedio.agregaAPressed()
            }
        }

    }

    Rectangle {
        id: imagenAgregaB
        x: 204
        y: 4
        transformOrigin: Item.Center
        color: "#3b3a3a"
        height: 48
        width: 48
        radius: 10
        border.width: 2
        border.color: "#696969"

        SequentialAnimation {
            id: animBotonAgregaB
            ColorAnimation {target: imagenAgregaB;properties: "color"; to: "#e41b69"; duration: 50 }
            ColorAnimation {target: imagenAgregaB;properties: "color"; to: "#3b3a3a"; duration: 0 }
        }


        Text {
            id: textB
            text: qsTr("+")
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent
            font.pixelSize: 26
        }

        MouseArea {
            anchors.fill: parent
            onPressAndHold: {
                controlMedio.agregaBPressAndHold()
            }
            onPressed: {
                animBotonAgregaB.running=true
                controlMedio.agregaBPressed()
            }
        }

    }

    Image {
        id: slider
        smooth: true
        height: 39
        anchors.horizontalCenterOffset: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter
        sourceSize.width: 250
        source: "images/volume_line.png"
        fillMode: Image.PreserveAspectFit
        property real value: 1.0
        property real minval: 0.1
        property real maxval: 2.0
        property string label: "no name"
        property int xMax: width - (handle.width/2)
        y: 66
        //para que quede centrado el slide
        onValueChanged: controlMedio.sliderUpdatePos(value,maxval,minval,xMax,width,handle.width);
        onXMaxChanged: controlMedio.sliderUpdatePos(value,maxval,minval,xMax,width,handle.width);
        onMinvalChanged: controlMedio.sliderUpdatePos(value,maxval,minval,xMax,width,handle.width);

        Image {
            id: handle;
            y: 10
            width: 30
            source: "images/slider.png"
            smooth: true
            height: 32
            sourceSize.width: 30
            fillMode: Image.Stretch

            MouseArea {
                id: mouse
                anchors.fill: parent
                drag.target: parent
                drag.axis: Drag.XAxis
                drag.minimumX: 0
                drag.maximumX: slider.xMax - (width/2) //para que no se pase la mitad de la imagen del slide

                onPositionChanged: {
                    slider.value = (slider.maxval - slider.minval) * handle.x /
                            slider.xMax + slider.minval;
                }
            }
        }
    }
    Rectangle {
        id: imageCrossfaCenter
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#3b3a3a"
        height: 48
        width: 48
        radius: 10
        border.width: 2
        border.color: "#696969"

        MouseArea {
            id: mouseArea1
            anchors.fill: parent
            onPressed: {
                slider.value=1.0
                animBotonCenter.running=true
            }
        }

        SequentialAnimation {
            id: animBotonCenter
            ColorAnimation {target: imageCrossfaCenter;properties: "color"; to: "white"; duration: 50 }
            ColorAnimation {target: imageCrossfaCenter;properties: "color"; to: "#3b3a3a"; duration: 0 }
        }

        Text {
            id: textCenter
            text: qsTr("C")
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 18
        }
    }
}

