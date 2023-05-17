import QtQuick 2.0
import Sailfish.Silica 1.0
import net.thecust.sysmon 1.0

Page {
    id: page

    property int deepView: 12
    onDeepViewChanged: {
        for (var i = 0; i < depthModel.count; i++) {
            if (depthModel.get(i).interval == deepView) {
                comboBoxDepthView.currentIndex = i
                break
            }
        }
    }

    onOrientationTransitionRunningChanged: {
        if (!orientationTransitionRunning) {
            updateGraph()
            isRotated = true
        }
    }
    function updateGraph() {
        graphCpuSleep.updateGraph()
        graphSuspendSuccess.updateGraph()
        graphSuspendFail.updateGraph()
    }

    Connections {
        target: sysmon
        onDataUpdated: {
            updateGraph()
        }
    }

    Component.onCompleted: {
        updateGraph()
    }

    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: column.height

        VerticalScrollDecorator {
            flickable: flickable
        }

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("CPU sleep")
            }

            ComboBox {
                id: comboBoxDepthView
                label: qsTr("Show data for")
                // Why does 12 hour identify as index 0 ?
                currentIndex: page.deepView === 12 ? 4 : comboBoxDepthView.currentIndex
                menu: ContextMenu {
                    Repeater {
                        model: depthModel
                        delegate: MenuItem {
                            text: model.label
                            onClicked: {
                                page.deepView = model.interval
                            }
                        }
                    }
                }
            }

            SysMonGraph {
                id: graphCpuSleep
                graphTitle: qsTr("CPU sleep")
                graphHeight: gHeight
                dataType: [DataSource.CpuSleep]
                dataAvg: true
                dataDepth: deepView
                axisY.units: "%"
                minY: 0
                maxY: 100
                valueConverter: function (value) {
                    return value.toFixed(0)
                }

                clickEnabled: false
            }

            SysMonGraph {
                id: graphSuspendSuccess
                graphTitle: qsTr("Suspend: success")
                graphHeight: gHeight
                dataType: [DataSource.SuspendSuccess]
                dataAvg: true
                dataDepth: deepView
                axisY.units: qsTr(" [1/h]")
                scale: true
                valueConverter: function (value) {
                    return (value * 3600).toFixed(0)
                }

                clickEnabled: false
            }

            SysMonGraph {
                id: graphSuspendFail
                graphTitle: qsTr("Suspend: failed")
                graphHeight: gHeight
                dataType: [DataSource.SuspendFail]
                dataAvg: true
                dataDepth: deepView
                axisY.units: qsTr(" [1/h]")
                scale: true
                valueConverter: function (value) {
                    return (value * 3600).toFixed(0)
                }

                clickEnabled: false
            }
        }
    }
}
