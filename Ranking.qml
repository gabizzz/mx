import QtQuick 2.0
import PluginSqlite 1.0
import QtQuick.Controls 1.2


Rectangle {
    id: rectangle2
    width: 400
    height: 350
    color: "#000000"
    radius: 2
    border.color: "#262626"
    border.width: 1

    function cortar(argArchivo)
    {
       var x = argArchivo;
       var c = x.lastIndexOf('/') ;
       var L = x.lastIndexOf('.') ;

       var strfinal = x.slice (c+1,L) ;
       return strfinal ;
    }

    function consultar()
    {
        textheader.text="Top "+sliderHorizontal1.value.toString()
        sqlRanking.setDatabase("/QML/OfflineStorage/Databases/mx.sqlite")
        sqlRanking.setQuery("select archivo, reprod from log  order by reprod desc limit '"+sliderHorizontal1.value+"'")
    }

    SQLiteModel{
        id:sqlRanking
    }

    onVisibleChanged:{
        consultar()
    }

BotonCerrar {
    id: botonCerrar1
    x: 0
    y: 0
    onClicked: {parent.visible=false}
}

ListView {
    id: listViewRanking
    x: 8
    y: 20
    anchors.bottomMargin: 42
    clip: true
    anchors.topMargin: 25
        anchors.fill: parent
        model: sqlRanking
        delegate: Item {
            width: parent.width
            height: 20
                Rectangle{
                    width: listViewRanking.width
                    height: 1
                    color: "#dd4814"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    Row{
                        spacing: 2
                        Text {
                            width: listViewRanking.width-contador.width
                            fontSizeMode: Text.Fit; minimumPixelSize: 8; font.pixelSize: 10;
                            wrapMode: Text.WordWrap
                            color: "#ffcd8b"
                            text: cortar(archivo.toUpperCase())
                        }
                        Text {
                            id:contador
                            width: 40
                            fontSizeMode: Text.Fit; minimumPixelSize: 8; font.pixelSize: 10;
                            wrapMode: Text.WordWrap
                            color: "#ffcd8b"
                            text: reprod
                        }
                    }
                }

        }
}

Text {
    id: textheader
    x: 0
    y: 4
    height: 23
    color: "#a6a6a6"
    text: qsTr("Top")
    anchors.top: parent.top
    anchors.topMargin: 4
    anchors.right: parent.right
    anchors.rightMargin: 0
    anchors.left: parent.left
    anchors.leftMargin: 0
    font.bold: true
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    font.pixelSize: 12
}

Slider {
    id: sliderHorizontal1
        y: 314
        height: 28
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 55
        anchors.left: parent.left
        anchors.leftMargin: 55
        tickmarksEnabled: true
        stepSize: 10
        minimumValue: 10
        maximumValue: 100
        value: 10
        onValueChanged: {
            consultar()
        }
    }



}

