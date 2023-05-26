import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    property string dialogTitle: "Not Specified"
    property var minDt: 900.0
    property var minChange: 0.0
    property var autoScale: true
    property var maxY: 100.0

    SilicaFlickable {
        anchors.fill: parent

        contentHeight: mainColumn.height

        VerticalScrollDecorator {}

        Column {
            id: mainColumn
            width: parent.width

            DialogHeader {
                title: dialogTitle
            }

            TextField {
                id: valueMinDt
                width: parent.width
                label: qsTr("Minimal time interval in seconds")
                text: minDt
                validator: DoubleValidator {}
                inputMethodHints: Qt.ImhFormattedNumbersOnly
            }

            TextField {
                id: valueMinChange
                width: parent.width
                label: qsTr("Minimal change in value")
                text: minChange
                validator: DoubleValidator {}
                inputMethodHints: Qt.ImhFormattedNumbersOnly
            }

            TextSwitch {
                checked: autoScale
                text: qsTr("Automatic scale for Y on graph")
                description: autoScale ? qsTr("Scaled automatically") : qsTr(
                                             "Scaled manually")
                onClicked: autoScale = checked
            }

            TextField {
                id: valueMaxY
                width: parent.width
                label: qsTr("Maximal Y on graph")
                text: maxY
                validator: DoubleValidator {}
                inputMethodHints: Qt.ImhFormattedNumbersOnly
            }
        }
    }

    onDone: {
        if (valueMinDt.acceptableInput)
            minDt = parseFloat(valueMinDt.text)
        if (valueMinChange.acceptableInput)
            minChange = parseFloat(valueMinChange.text)
        if (valueMaxY.acceptableInput)
            maxY = parseFloat(valueMaxY.text)
    }
}
