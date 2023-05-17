import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    onOrientationChanged: {
        if (visible) {
            isRotated = true
        }
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: column.height

        VerticalScrollDecorator {}

        Column {
            id: column

            anchors {
                left: parent.left
                right: parent.right
                margins: Theme.paddingLarge
            }

            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("About")
            }
            Label {
                x: Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("System Monitor")
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: "image://theme/icon-l-diagnostic?" + Theme.primaryColor
            }
            Label {
                x: Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                text: APP_VERSION + " / Unofficial"
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeSmall
            }
            Text {
                width: parent.width
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                text: qsTr("System Monitor records and shows your phone usage detail stats.")
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
            Text {
                width: parent.width
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                text: qsTr("You are able to see CPU, Memory, Battery, Temperature, Signal and Traffic stats.")
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                text: "<a href='#'>" + qsTr(
                          "Web-site (OpenRepos) of this version") + "</a>"
                linkColor: Theme.highlightColor
                onLinkActivated: Qt.openUrlExternally(
                                     "https://openrepos.net/content/ade/system-monitor-fork")
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                text: "<a href='#'>" + qsTr(
                          "Support forum (TMO) of official version") + "</a>"
                linkColor: Theme.highlightColor
                onLinkActivated: Qt.openUrlExternally(
                                     "http://talk.maemo.org/showthread.php?t=93824")
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                text: "<a href='#'>" + qsTr(
                          "Source code (GitHub) of official version") + "</a>"
                linkColor: Theme.highlightColor
                onLinkActivated: Qt.openUrlExternally(
                                     "https://github.com/custodian/harbour-systemmonitor")
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                text: "<a href='#'>" + qsTr(
                          "Source code (GitHub) of this version") + "</a>"
                linkColor: Theme.highlightColor
                onLinkActivated: Qt.openUrlExternally(
                                     "https://github.com/a-dekker/harbour-systemmonitor")
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                text: "© Basil Semuonov/Rinigus/Arno Dekker"
            }
        }
    }
}
