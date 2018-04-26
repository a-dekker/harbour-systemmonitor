import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    property int databaseSize: 0
    property int databaseUnits: 0

    Component.onCompleted: {
        updateDatabaseInfo();
        updateIntervaChanged();
        archiveLengthChanged();
    }

    function updateDatabaseInfo() {
        databaseUnits = sysmon.getUnitsCollected();
        databaseSize = sysmon.getDatabaseSize();
    }

    function updateIntervaChanged() {
        for (var i=0;i<timeModel.count;i++) {
            if (timeModel.get(i).interval == settings.updateInterval) {
                comboBoxUpdateInterval.currentIndex = i;
                break;
            }
        }
    }

    function archiveLengthChanged() {
        for (var i=0;i<archiveModel.count;i++) {
            if (archiveModel.get(i).interval == settings.archiveLength) {
                comboBoxArchiveLength.currentIndex = i;
                break;
            }
        }
    }

    Connections {
        target: settings
        onUpdateIntervalChanged: updateIntervaChanged()
        onArchiveLengthChanged: archiveLengthChanged()
    }

    RemorsePopup { id: remorse }

    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: column.height

        VerticalScrollDecorator { flickable: flickable }

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingMedium
            PageHeader {
                title: qsTr("Settings")
            }

            TextSwitch {
                checked: sysmon.enabled
                text: qsTr("Enable service")
                description: sysmon.enabled ? qsTr("Service is running now") : qsTr("Service is stopped")
                onClicked: sysmon.setEnabled(checked)
            }

            TextSwitch {
                checked: sysmon.autorun
                text: qsTr("Autorun on system boot")
                description: sysmon.autorun ? qsTr("Service will autorun on system boot") : qsTr("Service should be launched manually")
                onClicked: sysmon.setAutorun(checked)
            }

            ComboBox {
                id: comboBoxUpdateInterval
                label: qsTr("Update interval")
                currentIndex: 2
                menu: ContextMenu {
                    Repeater {
                        model: timeModel
                        delegate: MenuItem {
                            text: model.label
                            onClicked: {
                                settings.updateInterval = model.interval
                            }
                        }
                    }
                }
            }

            ComboBox {
                id: comboBoxArchiveLength
                label: qsTr("Data archive length")
                currentIndex: 0
                menu: ContextMenu {
                    Repeater {
                        model: archiveModel
                        delegate: MenuItem {
                            text: model.label
                            onClicked: {
                                settings.archiveLength = model.interval
                            }
                        }
                    }
                }
            }

            //Spacer
            Item {
                height: 1
                width: parent.width
            }
            Row {
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                spacing: Theme.paddingMedium
                Label {
                    text: qsTr("Data archive size")
                    color: Theme.highlightColor
                }
                Label {
                    text: qsTr("%1 KiB").arg(databaseSize/1024);
                    color: Theme.primaryColor
                }
            }
            //Spacer
            Item {
                height: 1
                width: parent.width
            }
            Row {
                anchors {
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }
                spacing: Theme.paddingMedium
                Label {
                    text: qsTr("Units collected")
                    color: Theme.highlightColor
                }
                Label {
                    text: qsTr("%1").arg(databaseUnits);
                    color: Theme.primaryColor
                }
            }
            //Spacer
            Item {
                height: 1
                width: parent.width
            }
            Text {
                width: parent.width
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeMedium
                text: qsTr("Cleaning data will erase currenly collected units, but will not reduce data archive size.\nShrink option will be added in future releases.")
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Clear all data")
                onClicked: {
                    remorse.execute("Clearing archive data", function() {
                        sysmon.clearData();
                        updateDatabaseInfo();
                    });
                }
            }
        }
    }
}
