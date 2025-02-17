// SPDX-FileCopyrightText: 2023 UnionTech Software Technology Co., Ltd.
//
// SPDX-License-Identifier: GPL-3.0-or-later

#include "digitalwellbeing.h"
#include "applet.h"
#include "pluginfactory.h"

#include <DDBusSender>

namespace dock
{

static DDBusSender dwDbus()
{
    return DDBusSender().service("org.deepin.dde.digitalWellbeing").path("/org/deepin/dde/digitalWellbeing").interface("org.deepin.dde.digitalWellbeing");
}

const auto dcall = [](QDBusMessage msg) {
    auto resp = QDBusConnection::sessionBus().call(msg);
    qDebug() << "dcall::(" << msg << ")" << resp;
    return resp.type() == QDBusMessage::ReplyMessage ? resp.arguments() : QList<QVariant>({QVariant()});
};

DWItem::DWItem(QObject *parent)
    : m_iconName("deepin-launcher")
    , m_basicStat(dcall(QDBusMessage::createMethodCall("org.deepin.dde.digitalWellbeing",
                                                       "/org/deepin/dde/digitalWellbeing",
                                                       "org.deepin.dde.digitalWellbeing",
                                                       "getBasicStatJson"))
                      .first()
                      .toString())
    , DApplet(parent)
{
    connect(&m_refreshTimer, &QTimer::timeout, [this]() {
        m_basicStat = dcall(QDBusMessage::createMethodCall("org.deepin.dde.digitalWellbeing",
                                                           "/org/deepin/dde/digitalWellbeing",
                                                           "org.deepin.dde.digitalWellbeing",
                                                           "getBasicStatJson"))
                          .first()
                          .toString();
        emit basicStatChanged();
    });
    m_refreshTimer.start(60000);
}

bool DWItem::init()
{
    DApplet::init();
    return true;
}

QString DWItem::iconName() const
{
    return m_iconName;
}

void DWItem::setIconName(const QString &iconName)
{
    if (iconName != m_iconName) {
        m_iconName = iconName;
        Q_EMIT iconNameChanged();
    }
}

QString DWItem::basicStat() const
{
    return m_basicStat;
}

QString DWItem::perAppStatDaily() const
{
    return dcall(QDBusMessage::createMethodCall("org.deepin.dde.digitalWellbeing",
                                                "/org/deepin/dde/digitalWellbeing",
                                                "org.deepin.dde.digitalWellbeing",
                                                "getPerAppStatJson"))
        .takeFirst()
        .toString();
}
QString DWItem::eventsDaily() const
{
    return dcall(QDBusMessage::createMethodCall("org.deepin.dde.digitalWellbeing",
                                                "/org/deepin/dde/digitalWellbeing",
                                                "org.deepin.dde.digitalWellbeing",
                                                "getDailyStatJson"))
        .first()
        .toString();
}

D_APPLET_CLASS(DWItem)
}

#include "digitalwellbeing.moc"
