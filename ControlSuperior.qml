import QtQuick 2.2
import QtQuick.Controls 1.2

Rectangle{
    id:contenedor
    height: 25
    color: "black"
    //signal switchClicked(var checked)
    width: 400

    property alias switchADj: switchADj

    function nowPlayingA(pista)
    {
        labelNowplayingA.text=pista       
    }
    function nowPlayingB(pista)
    {
        labelNowplayingB.text=pista
    }

    function opacidadNowPlaying(opacidad)
    {
        labelNowplayingA.opacity=1.0-opacidad
        labelNowplayingB.opacity=opacidad

        if((labelNowplayingA.text.indexOf("Playing:") > -1 || labelNowplayingB.text.indexOf("Playing:") > -1) && (opacidad<0.5 || opacidad>1.5))
        {
            imageplaying.source="/images/media-play.png"
        }else if((labelNowplayingA.text.indexOf("Playing:") > -1 && labelNowplayingB.text.indexOf("Playing:") > -1) && (opacidad>0.5 || opacidad<1.5))
        {
            imageplaying.source="/images/media-shuffle.png"
        }

    }

    Image {
        id: imageplaying
        width: 30
        height: 25
        anchors.left: parent.left
        anchors.leftMargin: 0
        source: ""
        antialiasing: true
    }

    Label {
        id: labelNowplayingA
        y: 0
        height: 25
        color: "#448AFF"
        text: qsTr("")
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: imageplaying.right
        anchors.leftMargin: 6
        anchors.right: labelInfo.left
        anchors.rightMargin: 6
        font.bold: true
        verticalAlignment: Text.AlignVCenter
    }
    Label {
        id: labelNowplayingB
        y: 0
        height: 25
        color: "#E91E63"
        text: qsTr("")
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: imageplaying.right
        anchors.leftMargin: 5
        anchors.right: labelInfo.left
        anchors.rightMargin: 6
        font.bold: true
        verticalAlignment: Text.AlignVCenter
    }


    Switch{
        id: switchADj
        x: 341
        y: 0
        height: 25
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: parent.verticalCenter
    }

    Label {
        id: labelInfo
        x: 288
        y: 0
        width: 47
        height: 25
        font.pointSize: 12
        font.bold: true
        color: "#C5CAE9"
        text: qsTr("AutoDj")
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: switchADj.left
        anchors.rightMargin: 14
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}


