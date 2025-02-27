// SPDX-FileCopyrightText: 2025 Yicheng Zhong <rubbishzyc@outlook.com>.
// SPDX-License-Identifier: MIT

#pragma once

#include "applet.h"
#include "dsglobal.h"
#include <QTimer>

namespace dock
{

class DWItem : public DS_NAMESPACE::DApplet
{
    Q_OBJECT
    Q_PROPERTY(QString basicStat READ basicStat NOTIFY basicStatChanged FINAL)
    Q_PROPERTY(QString perAppStatDaily READ perAppStatDaily FINAL)
    Q_PROPERTY(QString eventsDaily READ eventsDaily FINAL)
public:
    explicit DWItem(QObject *parent = nullptr);
    virtual bool init() override;

    QString basicStat() const;
    QString perAppStatDaily() const;
    QString eventsDaily() const;

Q_SIGNALS:
    void basicStatChanged();

private:
    QString m_basicStat;
    QTimer m_refreshTimer;
};

}
