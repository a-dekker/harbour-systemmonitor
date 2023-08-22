#ifndef DATASOURCEZRAM_H
#define DATASOURCEZRAM_H

#include "datasource.h"
#include "systemsnapshot.h"

class DataSourceZram : public DataSource
{
    Q_OBJECT

public:
    explicit DataSourceZram(SystemSnapshot *parent = 0);

signals:

public slots:
    void processSystemSnapshot();

private:
    QVector<int> zram_devices;
};

#endif // DATASOURCEZRAM_H
