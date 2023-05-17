import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import net.thecust.sysmon 1.0
import Nemo.Configuration 1.0

ApplicationWindow {
    initialPage: Component {
        MainPage {}
    }
    cover: Qt.resolvedUrl("pages/CoverPage.qml")

    allowedOrientations: defaultAllowedOrientations
    _defaultPageOrientations: defaultAllowedOrientations
    property bool isRotated: false
    property int gHeight: Screen.width >= 1080 ? 350 : 200

    //TODO: combine all dconf settings here
    ConfigurationGroup {
        id: settings
        path: "/net/thecust/systemmonitor"

        property int deepView: 12
        property int coverGraphNum: 0
        property int updateInterval: 120
        property int archiveLength: 7

        // settings used by battery discharge rate plot
        property double batteryDischargeRateMinDt: 900.0
        property double batteryDischargeRateMinChange: 1.0
        property double batteryDischargeRateMaxY: 10.0
        property bool batteryDischargeRateAutoScale: false
    }

    Component.onCompleted: {

        //console.log("Test", DataSource.CpuTotal);
    }

    SystemMonitor {
        id: sysmon

        onDataUpdated: {
            console.log("SystemMonitor dataUpdated")
        }
    }

    ListModel {
        id: timeModel
        ListElement {
            label: qsTr("30 seconds")
            interval: 30
        }
        ListElement {
            label: qsTr("1 minute")
            interval: 60
        }
        ListElement {
            label: qsTr("2 minutes")
            interval: 120
        }
        ListElement {
            label: qsTr("3 minutes")
            interval: 180
        }
        ListElement {
            label: qsTr("5 minutes")
            interval: 300
        }
        ListElement {
            label: qsTr("10 minutes")
            interval: 600
        }
    }

    ListModel {
        id: archiveModel
        ListElement {
            label: qsTr("7 days")
            interval: 7
        }
        ListElement {
            label: qsTr("10 days")
            interval: 10
        }
        ListElement {
            label: qsTr("14 days")
            interval: 14
        }
    }

    ListModel {
        id: depthModel
        ListElement {
            label: qsTr("1 hour")
            interval: 1
        }
        ListElement {
            label: qsTr("4 hours")
            interval: 4
        }
        ListElement {
            label: qsTr("6 hours")
            interval: 6
        }
        ListElement {
            label: qsTr("8 hours")
            interval: 8
        }
        ListElement {
            label: qsTr("12 hours")
            interval: 12
        }
        ListElement {
            label: qsTr("24 hours")
            interval: 24
        }
        ListElement {
            label: qsTr("2 days")
            interval: 48
        }
        ListElement {
            label: qsTr("3 days")
            interval: 72
        }
        ListElement {
            label: qsTr("4 days")
            interval: 96
        }
        ListElement {
            label: qsTr("1 week")
            interval: 168
        }
        ListElement {
            label: qsTr("whole period")
            interval: 999
        }
    }
}
