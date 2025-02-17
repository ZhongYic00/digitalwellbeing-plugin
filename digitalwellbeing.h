// SPDX-FileCopyrightText: 2023 UnionTech Software Technology Co., Ltd.
//
// SPDX-License-Identifier: GPL-3.0-or-later

#pragma once

#include "applet.h"
#include "dsglobal.h"
#include <QTimer>

namespace dock
{

class DWItem : public DS_NAMESPACE::DApplet
{
    Q_OBJECT
    Q_PROPERTY(QString iconName READ iconName WRITE setIconName NOTIFY iconNameChanged FINAL)
    Q_PROPERTY(QString basicStat READ basicStat NOTIFY basicStatChanged FINAL)
    Q_PROPERTY(QString perAppStatDaily READ perAppStatDaily FINAL)
    Q_PROPERTY(QString eventsDaily READ eventsDaily FINAL)
public:
    explicit DWItem(QObject *parent = nullptr);
    virtual bool init() override;

    QString iconName() const;
    void setIconName(const QString &iconName);
    QString basicStat() const;
    QString perAppStatDaily() const;
    QString eventsDaily() const;

Q_SIGNALS:
    void iconNameChanged();
    void basicStatChanged();

private:
    QString m_iconName;
    QString m_basicStat;
    QTimer m_refreshTimer;
};

}
