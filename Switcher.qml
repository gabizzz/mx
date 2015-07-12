import QtQuick 2.0

Item {
    id: toggleswitch
    width: background.width; height: background.height
    Component.onCompleted: {toggleswitch.state="on"}

    /*!
       Indicates the state of the switch. If \c false, then the switch is in
       the \c off state.

       \omit
            The \qmlproperty <type> <propertyname> is not necessary as QDoc
            will associate this property to the ToggleSwitch

           QDoc will not publish the documentation within omit and endomit.
       \endomit
    */
    property bool on: true

    /*!
        A method to toggle the switch. If the switch is \c on, the toggling it
        will turn it \c off. Toggling a switch in the \c off position will
        turn it \c on.
    */
    function toggle() {
        if (toggleswitch.state == "on")
        {
            toggleswitch.state = "off";
        }
        else
        {
            toggleswitch.state = "on";
        }
    }

    /*!
        \internal

        An internal function to synchronize the switch's internals. This
        function is not for public access. The \internal command will
        prevent QDoc from publishing this comment in the public API.
    */
    function releaseSwitch() {
        if (knob.x == 1) {
            if (toggleswitch.state == "off")
            {
                return;
            }
        }
        if (knob.x == (background.width-knob.width)) {
            if (toggleswitch.state == "on")
            {
                return;
            }

        }
        toggle();
    }

    Rectangle {
        id: background
        width: 62; height: 25
        radius: 12
        color: "#DF382C"
        MouseArea { anchors.fill: parent; onClicked: toggle() }
    }

    Rectangle {
        id: knob
        width: background.height; height: background.height
        radius: width
        color: "#ffffff"
        border.color: "grey"
        border.width: 1

        MouseArea {
            anchors.fill: parent
            drag.target: knob; drag.axis: Drag.XAxis; drag.minimumX: 1; drag.maximumX: (background.width-knob.width)
            onClicked: toggle()
            onReleased: releaseSwitch()
        }
    }

    Text {
        id: textEstado
        x: 8
        y: 7
        width: 54
        height: 15
        text: qsTr("Text")
        verticalAlignment: Text.AlignVCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        opacity: 0
        font.pixelSize: 11
        font.bold: true
        color: "#ffffff"
    }

    states: [
        State {
            name: "on"
            PropertyChanges { target: knob; x: (background.width-knob.width) }
            PropertyChanges { target: toggleswitch; on: true }
            PropertyChanges { target: textEstado; text: "ON"; verticalAlignment: Text.AlignVCenter; opacity: 1; horizontalAlignment: Text.AlignLeft}
            PropertyChanges { target: background;  color:"#38B44A"}
        },
        State {
            name: "off"
            PropertyChanges { target: knob; x: 0 }
            PropertyChanges { target: toggleswitch; on: false }
            PropertyChanges { target: textEstado; width: 46; height: 15;text: "OFF"; verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignRight;opacity: 1}
            PropertyChanges { target: background;  color:"#DF382C"}

        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad; duration: 100 }
    }
}
