import QtQuick 2.0
import Sailfish.Silica 1.0
import net.thecust.sysmon 1.0

Page {
    id: page

    property bool active: Qt.application.active
    onActiveChanged: {
        updateGraph()
    }
    property bool needUpdate: true

    function deepViewChanged() {
        for (var i = 0; i < depthModel.count; i++) {
            if (depthModel.get(i).interval == settings.deepView) {
                comboBoxDepthView.currentIndex = i
                break
            }
        }
        needUpdate = true
        updateGraph()
    }

    onOrientationTransitionRunningChanged: {
        if (!orientationTransitionRunning) {
            needUpdate = true
            updateGraph()
        }
    }

    onStatusChanged: {
        if (status == PageStatus.Activating) {
            if (isRotated) {
                needUpdate = true
                updateGraph()
                isRotated = false
            }
        }
    }

    function updateGraph() {
        if (page.active && needUpdate) {
            graphBattery.updateGraph()
            graphCpu.updateGraph()
            graphRam.updateGraph()
            graphCpuSleep.updateGraph()
            graphWlanTotal.updateGraph()
            graphCellTotal.updateGraph()
            graphTemperature.updateGraph()
            graphCellSignal1.updateGraph()
            graphCellSignal2.updateGraph()
            graphInternet.updateGraph()
            needUpdate = false
        }
    }

    Component.onCompleted: {
        deepViewChanged()
    }

    Connections {
        target: settings
        onDeepViewChanged: deepViewChanged()
    }

    Connections {
        target: sysmon
        onDataUpdated: {
            needUpdate = true
            updateGraph()
        }
    }

    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: column.height

        VerticalScrollDecorator {
            flickable: flickable
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }
        }

        Column {
            id: column

            width: page.width
            //spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("System monitor")
            }

            ComboBox {
                id: comboBoxDepthView
                label: qsTr("Show data for")
                menu: ContextMenu {
                    Repeater {
                        model: depthModel
                        delegate: MenuItem {
                            text: model.label
                            onClicked: {
                                settings.deepView = model.interval
                            }
                        }
                    }
                }
            }

            SysMonGraph {
                id: graphBattery
                graphTitle: qsTr("Battery charge")
                graphHeight: gHeight
                dataType: [DataSource.BatteryPercentage]
                dataAvg: true
                minY: 0
                maxY: 100
                valueConverter: function (value) {
                    return value.toFixed(0)
                }

                onClicked: pageStack.push(Qt.resolvedUrl("BatteryPage.qml"), {
                                              "deepView": settings.deepView
                                          })
            }

            SysMonGraph {
                id: graphCpu
                graphTitle: qsTr("CPU usage")
                graphHeight: gHeight
                dataType: [DataSource.CpuTotal]
                dataAvg: true
                minY: 0
                maxY: 100
                valueConverter: function (value) {
                    return value.toFixed(0)
                }

                onClicked: pageStack.push(Qt.resolvedUrl("CpuPage.qml"), {
                                              "deepView": settings.deepView
                                          })
            }

            SysMonGraph {
                id: graphRam
                graphTitle: qsTr("RAM usage")
                graphHeight: gHeight
                dataType: [DataSource.RAMUsed]
                dataAvg: true
                scale: true
                axisY.units: qsTr(" MiB")
                valueConverter: function (value) {
                    return (value / 1024).toFixed(0)
                }

                onClicked: pageStack.push(Qt.resolvedUrl("RamPage.qml"), {
                                              "deepView": settings.deepView
                                          })
            }

            SysMonGraph {
                id: graphCpuSleep
                graphTitle: qsTr("CPU sleep")
                graphHeight: gHeight
                dataType: [DataSource.CpuSleep]
                dataAvg: true
                minY: 0
                maxY: 100
                valueConverter: function (value) {
                    return value.toFixed(0)
                }

                onClicked: pageStack.push(Qt.resolvedUrl("CpuSleepPage.qml"), {
                                              "deepView": settings.deepView
                                          })
            }

            SysMonGraph {
                id: graphWlanTotal
                graphTitle: qsTr("Wlan traffic")
                graphHeight: gHeight
                dataType: [DataSource.NetworkWlanRx, DataSource.NetworkWlanTx]
                scale: true
                axisY.units: qsTr(" KiB/s")
                //valueTotal: false
                dataAvg: true
                valueConverter: function (value) {
                    return (value / 1024).toFixed(0)
                }

                onClicked: pageStack.push(Qt.resolvedUrl("WlanPage.qml"), {
                                              "deepView": settings.deepView
                                          })
            }

            SysMonGraph {
                id: graphCellTotal
                graphTitle: qsTr("Cell traffic")
                graphHeight: gHeight
                dataType: [DataSource.NetworkCellRx, DataSource.NetworkCellTx]
                scale: true
                axisY.units: qsTr(" KiB/s")
                //valueTotal: false
                dataAvg: true
                valueConverter: function (value) {
                    return (value / 1024).toFixed(0)
                }

                onClicked: pageStack.push(Qt.resolvedUrl("CellPage.qml"), {
                                              "deepView": settings.deepView
                                          })
            }

            SysMonGraph {
                id: graphCellSignal1
                graphTitle: qsTr("Cell signal (SIM 1)")
                graphHeight: gHeight
                dataType: [DataSource.SignalPerc1]
                minY: 0
                maxY: 100
                axisY.units: " %"
                dataAvg: true
                clickEnabled: false
                valueConverter: function (value) {
                    return (value).toFixed(0)
                }
            }

            SysMonGraph {
                id: graphCellSignal2
                graphTitle: qsTr("Cell signal (SIM 2)")
                graphHeight: gHeight
                dataType: [DataSource.SignalPerc2]
                minY: 0
                maxY: 100
                axisY.units: " %"
                dataAvg: true
                clickEnabled: false
                valueConverter: function (value) {
                    return (value).toFixed(0)
                }
            }

            SysMonGraph {
                id: graphInternet
                graphTitle: qsTr("Wlan signal")
                graphHeight: gHeight
                dataType: [DataSource.InternetPerc]
                minY: 0
                maxY: 100
                axisY.units: " %"
                dataAvg: true
                clickEnabled: false
                valueConverter: function (value) {
                    return (value).toFixed(0)
                }
            }

            SysMonGraph {
                id: graphTemperature
                graphTitle: qsTr("CPU temperature")
                graphHeight: gHeight
                dataType: [DataSource.TemperatureDeg]
                scale: true
                axisY.units: " °C"
                dataAvg: true
                clickEnabled: false
                valueConverter: function (value) {
                    return (value).toFixed(0)
                }
            }
        }
    }
}
