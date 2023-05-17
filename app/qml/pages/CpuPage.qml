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
        cpuTotal.updateGraph()
        cpuUser.updateGraph()
        cpuSystem.updateGraph()
        cpuIO.updateGraph()
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
                title: qsTr("CPU statistics")
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
                id: cpuTotal
                graphTitle: qsTr("Total")
                graphHeight: gHeight
                dataType: [DataSource.CpuTotal]
                dataAvg: true
                dataDepth: deepView
                minY: 0
                maxY: 100
                valueConverter: function (value) {
                    return value.toFixed(0)
                }

                clickEnabled: false
            }

            SysMonGraph {
                id: cpuUser
                graphTitle: qsTr("User processes")
                graphHeight: gHeight
                dataType: [DataSource.CpuUser]
                dataAvg: true
                dataDepth: deepView
                minY: 0
                maxY: 100
                valueConverter: function (value) {
                    return value.toFixed(0)
                }

                clickEnabled: false
            }

            SysMonGraph {
                id: cpuSystem
                graphTitle: qsTr("System processes")
                graphHeight: gHeight
                dataType: [DataSource.CpuSystem]
                dataAvg: true
                dataDepth: deepView
                minY: 0
                maxY: 100
                valueConverter: function (value) {
                    return value.toFixed(0)
                }

                clickEnabled: false
            }

            SysMonGraph {
                id: cpuIO
                graphTitle: qsTr("IO wait")
                graphHeight: gHeight
                dataType: [DataSource.CpuIO]
                dataAvg: true
                dataDepth: deepView
                minY: 0
                maxY: 100
                valueConverter: function (value) {
                    return value.toFixed(0)
                }

                clickEnabled: false
            }
        }
    }
}
