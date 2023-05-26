import QtQuick 2.0
import Sailfish.Silica 1.0
import net.thecust.sysmon 1.0

CoverBackground {
    id: cover

    property int coverGraphHeight: cover.height * 0.5

    property bool needUpdate: true
    property bool active: status == Cover.Active
    onActiveChanged: {
        updateGraph()
    }

    function nextGraph() {
        needUpdate = true
        settings.coverGraphNum = (settings.coverGraphNum + 1) % 9
    }

    function updateGraph() {
        if (active && needUpdate) {
            currentGraph.item.updateGraph()
            needUpdate = false
        }
    }

    Connections {
        target: sysmon
        onDataUpdated: {
            needUpdate = true
            updateGraph()
        }
    }

    Column {
        width: parent.width
        anchors {
            top: parent.top
            topMargin: Theme.paddingMedium
        }
        spacing: Theme.paddingMedium

        Loader {
            id: currentGraph
            anchors {
                left: parent.left
                right: parent.right
            }
            sourceComponent: {
                switch (settings.coverGraphNum) {
                case 0:
                    return cpuGraph
                case 1:
                    return networkGraph
                case 2:
                    return ramGraph
                case 3:
                    return batteryGraph
                case 4:
                    return cpuSleepGraph
                case 5:
                    return temperatureGraph
                case 6:
                    return cellSignalGraph1
                case 7:
                    return cellSignalGraph2
                case 8:
                    return internetGraph
                }
            }
            onStatusChanged: {
                if (status == Loader.Ready) {
                    updateGraph()
                }
            }
        }
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-m-levels"
            onTriggered: {
                nextGraph()
            }
        }
    }

    Component {
        id: cpuGraph

        SysMonGraph {
            graphTitle: qsTr("CPU")
            graphHeight: coverGraphHeight
            dataType: [DataSource.CpuTotal]
            dataDepth: 1
            dataAvg: true
            axisX.grid: 1
            minY: 0
            maxY: 100
            valueConverter: function (value) {
                return value.toFixed(1)
            }
            clickEnabled: false
        }
    }

    Component {
        id: networkGraph

        SysMonGraph {
            graphTitle: qsTr("NET")
            graphHeight: coverGraphHeight
            dataType: [DataSource.NetworkCellRx, DataSource.NetworkCellTx, DataSource.NetworkWlanRx, DataSource.NetworkWlanTx]
            dataDepth: 1
            scale: true
            axisX.grid: 1
            axisY.units: qsTr("KiB/s")
            valueConverter: function (value) {
                return (value / 1024).toFixed(0)
            }
            clickEnabled: false
        }
    }

    Component {
        id: ramGraph

        SysMonGraph {
            graphTitle: qsTr("RAM")
            graphHeight: coverGraphHeight
            dataType: [DataSource.RAMUsed]
            dataDepth: 1
            dataAvg: true
            scale: true
            axisX.grid: 1
            axisY.units: qsTr("MiB")
            valueConverter: function (value) {
                return (value / 1024).toFixed(0)
            }
            clickEnabled: false
        }
    }

    Component {
        id: batteryGraph

        SysMonGraph {
            graphTitle: qsTr("BAT")
            graphHeight: coverGraphHeight
            dataType: [DataSource.BatteryPercentage]
            dataDepth: 1
            dataAvg: true
            axisX.grid: 1
            minY: 0
            maxY: 100
            valueConverter: function (value) {
                return value.toFixed(0)
            }

            clickEnabled: false
        }
    }

    Component {
        id: cpuSleepGraph

        SysMonGraph {
            graphTitle: qsTr("SLP")
            graphHeight: coverGraphHeight
            dataType: [DataSource.CpuSleep]
            dataDepth: 1
            dataAvg: true
            axisX.grid: 1
            minY: 0
            maxY: 100
            valueConverter: function (value) {
                return value.toFixed(0)
            }

            clickEnabled: false
        }
    }

    Component {
        id: temperatureGraph

        SysMonGraph {
            graphTitle: qsTr("TEMP")
            graphHeight: coverGraphHeight
            dataType: [DataSource.TemperatureDeg]
            dataDepth: 1
            dataAvg: true
            axisX.grid: 1
            minY: 0
            maxY: 100
            axisY.units: "°C"
            valueConverter: function (value) {
                return value.toFixed(0)
            }

            clickEnabled: false
        }
    }

    Component {
        id: cellSignalGraph1

        SysMonGraph {
            graphTitle: qsTr("CELL1")
            graphHeight: coverGraphHeight
            dataType: [DataSource.SignalPerc1]
            dataDepth: 1
            dataAvg: true
            axisX.grid: 1
            minY: 0
            maxY: 100
            axisY.units: "%"
            valueConverter: function (value) {
                return value.toFixed(0)
            }

            clickEnabled: false
        }
    }

    Component {
        id: cellSignalGraph2

        SysMonGraph {
            graphTitle: qsTr("CELL2")
            graphHeight: coverGraphHeight
            dataType: [DataSource.SignalPerc2]
            dataDepth: 1
            dataAvg: true
            axisX.grid: 1
            minY: 0
            maxY: 100
            axisY.units: "%"
            valueConverter: function (value) {
                return value.toFixed(0)
            }

            clickEnabled: false
        }
    }

    Component {
        id: internetGraph

        SysMonGraph {
            graphTitle: qsTr("INTERNET")
            graphHeight: coverGraphHeight
            dataType: [DataSource.InternetPerc]
            dataDepth: 1
            dataAvg: true
            axisX.grid: 1
            minY: 0
            maxY: 100
            axisY.units: "%"
            valueConverter: function (value) {
                return value.toFixed(0)
            }

            clickEnabled: false
        }
    }
}
