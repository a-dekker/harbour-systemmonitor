#include "datasourcezram.h"
#include <QString>
#include <QDir>
#include <QDebug>
#include <QVector>

DataSourceZram::DataSourceZram(SystemSnapshot *parent) :
    DataSource(parent)
{
    QDir zram("/sys/block/");
    QStringList filters;
    filters << "zram*";
    zram.setNameFilters(filters);

    const QStringList zram_blockdevices = zram.entryList();
    QStringList zram_blockdevices_fullpath;
    qDebug() << "zram devices: " << zram_blockdevices;
    for(int i = 0; i < zram_blockdevices.count(); i++) {
        zram_blockdevices_fullpath << zram.absoluteFilePath(zram_blockdevices.at(i)) + "/compr_data_size";
        zram_devices.push_back(registerSystemSource(zram_blockdevices_fullpath.at(i)));
    }
    connect(parent, SIGNAL(processSystemSnapshot()), SLOT(processSystemSnapshot()));
}

void DataSourceZram::processSystemSnapshot()
{
    QByteArray zramVal;
    int zramsize = 0;
    for(int i = 0; i < zram_devices.size(); ++i) {
        zramVal = getSystemData(zram_devices.at(i));
        zramsize = zramsize + QString(zramVal).toInt();
    }

    emit systemDataGathered(DataSource::ZRAMUsed, zramsize);
}
