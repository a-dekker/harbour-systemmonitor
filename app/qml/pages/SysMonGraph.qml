import QtQuick 2.0
import "."

GraphData {
    property QtObject dataSource: sysmon
    property var dataType: []
    property int dataDepth: settings.deepView
    property bool dataAvg: false
    property bool dataDerivative: false
    property double dataDerivativeTimeUnit: 1.0
    property double dataDerivativeMinDt: 60.0
    property double dataDerivativeMinChange: 0.0

    onDataDepthChanged: {
        if (dataSource) {
            updateGraph()
        }
    }

    //TODO: really such a thing?
    onDataAvgChanged: {
        valueTotal = !dataAvg
    }

    function updateGraph() {
        var dataPoints = dataSource.getSystemGraph(dataType, dataDepth,
                                                   graphWidth, dataAvg)
        if (dataDerivative)
            dataPoints = dataSource.calculateDerivative(dataPoints,
                                                        dataDerivativeTimeUnit,
                                                        dataDerivativeMinDt,
                                                        dataDerivativeMinChange)
        setPoints(dataPoints)
    }
}
