#include "datasourcememory.h"

#include <QFile>
#include <QString>
#include <QStringList>
#include <QDebug>

DataSourceMemory::DataSourceMemory(SystemSnapshot *parent) :
    DataSource(parent)
{
    m_memInfo = registerSystemSource("/proc/meminfo");
    connect(parent, SIGNAL(processSystemSnapshot()), SLOT(processSystemSnapshot()));
}

void DataSourceMemory::processSystemSnapshot()
{
    /*
    /proc/meminfo
    0) MemTotal:         830728 kB
    1) MemFree:           52036 kB
    2) Buffers:            6244 kB
    3) Cached:           326472 kB
    4) SwapCached:         4308 kB
    5) Active:           269764 kB
    6) Inactive:         280028 kB
    7) Active(anon):     128288 kB
    8) Inactive(anon):   201556 kB
    9) Active(file):     141476 kB
    10) Inactive(file):    78472 kB
    11) Unevictable:       72304 kB
    12) Mlocked:           72304 kB
    13) HighTotal:        157696 kB
    14) HighFree:           1268 kB
    15) LowTotal:         673032 kB
    16) LowFree:           50768 kB
    17) SwapTotal:        520180 kB
    18) SwapFree:         509560 kB
    */

    QTextStream memdata(getSystemData(m_memInfo));

    QString line;
    int memTotal = 0;
    int memFree = 0;
    int buffers = 0;
    int cached = 0;
    int swapTotal = 0;
    int swapCached = 0;
    int swapFree = 0;
    for (int i=0;i<19 && !memdata.atEnd();i++) {
        line = memdata.readLine();
        QStringList values = line.split(" ", QString::SkipEmptyParts);
        if (values.size() < 2) {
            qDebug() << "Failed to fetch memory info";
            return;
        }
        QString memKey = values.at(0);
        int value = values.at(1).toInt();

        if (memKey == "MemTotal:") memTotal = value;
        if (memKey == "MemFree:") memFree = value;
        if (memKey == "Cached:") cached = value;
        if (memKey == "Buffers:") buffers = value;
        if (memKey == "SwapCached:") swapCached = value;
        if (memKey == "SwapTotal:") swapTotal = value;
        if (memKey == "SwapFree:") swapFree = value;
    }

    emit systemDataGathered(DataSource::RAMUsed, float(memTotal - memFree - buffers - cached));
    emit systemDataGathered(DataSource::SwapUsed, float(swapTotal - swapFree - swapCached));
}
