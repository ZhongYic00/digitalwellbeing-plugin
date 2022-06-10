#include "digitalwellbeingplugin.h"
#include "dbushelper.h"

DigitalWellbeingPlugin::DigitalWellbeingPlugin(QObject *parent)
    : QObject(parent)
{
}

void DigitalWellbeingPlugin::init(PluginProxyInterface *proxyInter)
{
    m_proxyInter = proxyInter;
    m_refreshTimer=new QTimer;
    m_pluginWidget=new pluginWidget;
    m_appletWidget=new appletWidget;
    connect(m_refreshTimer, &QTimer::timeout,[this](){
        m_pluginWidget->setProperty("BasicStat",dcall(QDBusMessage::createMethodCall("org.deepin.dde.digitalWellbeing","/org/deepin/dde/digitalWellbeing","org.deepin.dde.digitalWellbeing","getBasicStatJson")).first().toString());
    });
    connect(m_pluginWidget,&pluginWidget::requestUpdateGeometry,[proxyInter,this](){
        proxyInter->itemUpdate(this,pluginName());
    });
    if(!pluginIsDisable()) {
        initPluginWidget();
    }
}

void DigitalWellbeingPlugin::initPluginWidget(){
    qWarning()<<">>>initPluginWidget";
    m_pluginWidget->setProperty("BasicStat",dcall(QDBusMessage::createMethodCall("org.deepin.dde.digitalWellbeing","/org/deepin/dde/digitalWellbeing","org.deepin.dde.digitalWellbeing","getBasicStatJson")).first().toString());
//    if(!m_refreshTimer->isActive())
        m_refreshTimer->start(60000);
    m_proxyInter->itemAdded(this,pluginName());
}

QWidget *DigitalWellbeingPlugin::itemWidget(const QString &itemKey)
{
    Q_UNUSED(itemKey);

    qDebug()<<"itemWidget"<<itemKey<<m_pluginWidget;
    return m_pluginWidget;
}
QWidget *DigitalWellbeingPlugin::itemPopupApplet(const QString &itemKey)
{
    Q_UNUSED(itemKey);

    m_appletWidget->setProperty("PerAppStatDaily",dcall(QDBusMessage::createMethodCall("org.deepin.dde.digitalWellbeing","/org/deepin/dde/digitalWellbeing","org.deepin.dde.digitalWellbeing","getPerAppStatJson")).takeFirst().toString());
    m_appletWidget->setProperty("EventsDaily",dcall(QDBusMessage::createMethodCall("org.deepin.dde.digitalWellbeing","/org/deepin/dde/digitalWellbeing","org.deepin.dde.digitalWellbeing","getDailyStatJson")).first().toString());
    return m_appletWidget;
}
void DigitalWellbeingPlugin::pluginStateSwitched(){
    qWarning()<<">>>pluginStateSwitched()";
    const bool disabledNew = !pluginIsDisable();
    m_proxyInter->saveValue(this, "disabled", disabledNew);

    if (disabledNew) {
//        qDebug()<<">>>itemRemoved";
        m_proxyInter->itemRemoved(this, pluginName());
        m_proxyInter->itemUpdate(this,pluginName());
        m_refreshTimer->stop();
    } else {
        initPluginWidget();
//        qDebug()<<">>>itemAdded";
        m_proxyInter->itemAdded(this, pluginName());
    }
}
