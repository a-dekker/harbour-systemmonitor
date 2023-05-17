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
        graphBattery.updateGraph()
        //        graphCpuSleep.updateGraph();
        graphBatteryDischarge.updateGraph()
        graphBatteryCharge.updateGraph()
    }

    Connections {
        target: sysmon
        onDataUpdated: {
            updateGraph()
        }
    }

    Component.onCompleted: {
        //        page.deepViewChanged.connect(function() {
        //            updateGraph();
        //        });
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
                title: qsTr("Battery")
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
                id: graphBattery
                graphTitle: qsTr("Battery charge")
                graphHeight: gHeight
                dataType: [DataSource.BatteryPercentage]
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
                id: graphBatteryDischarge

                graphTitle: qsTr("Battery discharging rate")
                graphHeight: gHeight
                dataType: [DataSource.BatteryPercentage]
                dataAvg: true
                dataDerivative: true
                dataDerivativeTimeUnit: -3600.0
                dataDerivativeMinDt: 900.0
                dataDerivativeMinChange: 1.0
                dataDepth: deepView
                axisY.units: qsTr(" [%/h]")
                scale: false
                maxY: 10
                valueConverter: function (value) {
                    return value.toFixed(2)
                }

                Component.onCompleted: {
                    dataDerivativeMinDt = settings.batteryDischargeRateMinDt
                    dataDerivativeMinChange = settings.batteryDischargeRateMinChange
                    scale = settings.batteryDischargeRateAutoScale
                    maxY = settings.batteryDischargeRateMaxY
                }

                Component.onDestruction: {
                    settings.batteryDischargeRateMinDt = dataDerivativeMinDt
                    settings.batteryDischargeRateMinChange = dataDerivativeMinChange
                    settings.batteryDischargeRateAutoScale = scale
                    settings.batteryDischargeRateMaxY = scale ? 10.0 : maxY
                }

                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl(
                                                    "DerivativeSettings.qml"), {
                                                    "dialogTitle": "Battery discharging rate",
                                                    "minDt": dataDerivativeMinDt,
                                                    "minChange": dataDerivativeMinChange,
                                                    "autoScale": scale,
                                                    "maxY": maxY
                                                })
                    dialog.accepted.connect(function () {
                        dataDerivativeMinDt = dialog.minDt
                        dataDerivativeMinChange = dialog.minChange
                        maxY = dialog.maxY
                        scale = dialog.autoScale
                        graphBatteryDischarge.updateGraph()
                    })
                }
            }

            SysMonGraph {
                id: graphBatteryCharge
                graphTitle: qsTr("Battery charging rate")
                graphHeight: gHeight
                dataType: [DataSource.BatteryPercentage]
                dataAvg: true
                dataDerivative: true
                dataDerivativeTimeUnit: 3600.0
                dataDerivativeMinDt: 900.0
                dataDerivativeMinChange: 1.0
                dataDepth: deepView
                axisY.units: qsTr(" [%/h]")
                scale: true
                valueConverter: function (value) {
                    return value.toFixed(2)
                }

                clickEnabled: false
            }
        }
    }
}
