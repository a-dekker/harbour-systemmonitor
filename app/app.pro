TARGET = harbour-systemmonitor

CONFIG += sailfishapp
PKGCONFIG += mlite5

DEPLOYMENT_PATH = /usr/share/$${TARGET}

QT += dbus sql
QMAKE_CXXFLAGS += -std=c++0x

DEFINES += APP_VERSION=\\\"$$VERSION\\\"

SOURCES += \
    app.cpp \
    ..\daemon\storage.cpp \
    ..\daemon\datasource.cpp \
    ..\daemon\systemsnapshot.cpp \
    systemmonitor.cpp

HEADERS += \
    ..\daemon\settings.h \
    ..\daemon\storage.h \
    ..\daemon\datasource.h \
    ..\daemon\systemsnapshot.h \
    systemmonitor.h

OTHER_FILES += \
    qml/pages/CoverPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/CpuPage.qml \
    qml/pages/RamPage.qml \
    qml/pages/WlanPage.qml \
    qml/pages/CellPage.qml \
    qml/pages/BatteryPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/AboutPage.qml \
    qml/pages/Axis.qml \
    qml/pages/GraphData.qml \
    qml/pages/SysMonGraph.qml \
    translations/*.ts \
    qml/sysmon.qml \
    qml/images/* \
    harbour-systemmonitor.desktop \
    harbour-systemmonitor.png

INSTALLS += translations

TRANSLATIONS = translations/harbour-systemmonitor-ru.ts \
               translations/harbour-systemmonitor-sv.ts \
               translations/harbour-systemmonitor-pl.ts \
               translations/harbour-systemmonitor-zh_CN.ts

# only include these files for translation:
lupdate_only {
    SOURCES = qml/*.qml \
              qml/pages/*.qml
}

translations.files = translations
translations.path = $${DEPLOYMENT_PATH}


DISTFILES += \
    qml/pages/DerivativeSettings.qml \
    qml/pages/CpuSleepPage.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
