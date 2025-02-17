#include "digitalwellbeingplugin.h"
#include "dbushelper.h"

// Q_LOGGING_CATEGORY(DOCK_DigitalWellbeing, "org.deepin.dde.dock.digitalwellbeing")
Q_DECLARE_METATYPE(QMargins)

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
        qDebug()<<"digitalWellbeingPlugin isDisabled="<<pluginIsDisable();
        m_pluginWidget->setProperty("BasicStat",dcall(QDBusMessage::createMethodCall("org.deepin.dde.digitalWellbeing","/org/deepin/dde/digitalWellbeing","org.deepin.dde.digitalWellbeing","getBasicStatJson")).first().toString());
        m_pluginWidget->update();
        m_proxyInter->itemUpdate(this,pluginName());
    });
    connect(m_pluginWidget,&pluginWidget::requestUpdateGeometry,[this](){
        qDebug()<<m_pluginWidget<<" size="<<m_pluginWidget->size()<<" hint="<<m_pluginWidget->sizeHint();
        m_pluginWidget->update();
        m_proxyInter->itemUpdate(this,pluginName());
    });
    qWarning()<<"digitalWellbeingPlugin isDisabled="<<pluginIsDisable();
    if(!pluginIsDisable()) {
        initPluginWidget();
    }
}

void DigitalWellbeingPlugin::initPluginWidget(){
    qWarning()<<">>>initPluginWidget";
    // m_pluginWidget->init();
    m_pluginWidget->setProperty("BasicStat",dcall(QDBusMessage::createMethodCall("org.deepin.dde.digitalWellbeing","/org/deepin/dde/digitalWellbeing","org.deepin.dde.digitalWellbeing","getBasicStatJson")).first().toString());
//    if(!m_refreshTimer->isActive())
        m_refreshTimer->start(60000);
    m_proxyInter->itemAdded(this,pluginName());
}

QWidget *DigitalWellbeingPlugin::itemWidget(const QString &itemKey)
{
    Q_UNUSED(itemKey);

    qDebug()<<"itemWidget"<<itemKey<<m_pluginWidget;
    if (itemKey == "quick_item_key")
        return nullptr;
    return m_pluginWidget;
}
QWidget *DigitalWellbeingPlugin::itemPopupApplet(const QString &itemKey)
{
    Q_UNUSED(itemKey);
    return new QLabel("applet");

    m_appletWidget->setProperty("PerAppStatDaily",dcall(QDBusMessage::createMethodCall("org.deepin.dde.digitalWellbeing","/org/deepin/dde/digitalWellbeing","org.deepin.dde.digitalWellbeing","getPerAppStatJson")).takeFirst().toString());
    m_appletWidget->setProperty("EventsDaily",dcall(QDBusMessage::createMethodCall("org.deepin.dde.digitalWellbeing","/org/deepin/dde/digitalWellbeing","org.deepin.dde.digitalWellbeing","getDailyStatJson")).first().toString());
    return m_appletWidget;
}
QWidget *DigitalWellbeingPlugin::itemTipsWidget(const QString &itemKey)
{
    if (m_tooltipWidget == nullptr) {
        m_tooltipWidget = new QLabel("digital wellbeing plugin");
    }
    qDebug()<<"itemTipsWidget="<<m_tooltipWidget;
    return m_tooltipWidget;
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


const QString DigitalWellbeingPlugin::itemContextMenu(const QString &itemKey)
{
    QList<QVariant> items;
    items.reserve(2);

    QMap<QString, QVariant> shift;
    shift["itemId"] = "SHIFT";
    shift["itemText"] = tr("Enable");
    shift["isActive"] = true;
    items.push_back(shift);

    QMap<QString, QVariant> menu;
    menu["items"] = items;
    menu["checkableMenu"] = false;
    menu["singleCheck"] = false;

    return QJsonDocument::fromVariant(menu).toJson();
}

int DigitalWellbeingPlugin::itemSortKey(const QString &itemKey)
{
    Q_UNUSED(itemKey);

    const QString key = QString("pos_%1_%2").arg(itemKey).arg(Dock::Efficient);
    return m_proxyInter->getValue(this, key, 3).toInt();
}

void DigitalWellbeingPlugin::setSortKey(const QString &itemKey, const int order)
{
    Q_UNUSED(itemKey);

    const QString key = QString("pos_%1_%2").arg(itemKey).arg(Dock::Efficient);
    m_proxyInter->saveValue(this, key, order);
}

Dock::PluginFlags DigitalWellbeingPlugin::flags() const
{
    return Dock::Type_Tool | Dock::Attribute_Normal;
}

QString DigitalWellbeingPlugin::message(const QString &message)
{
    QJsonObject msgObj = QJsonDocument::fromJson(message.toLocal8Bit()).object();
    if (msgObj.isEmpty()) {
        return "{}";
    }

    QJsonObject retObj;
    const QString &cmdType = msgObj.value(Dock::MSG_TYPE).toString();
    if (cmdType == Dock::MSG_DOCK_PANEL_SIZE_CHANGED) {
        const QJsonObject sizeObj = msgObj.value(Dock::MSG_DATA).toObject();
        int width = sizeObj["width"].toInt();
        int height = sizeObj["height"].toInt();
        if (m_pluginWidget) {
            qDebug()<<"resize"<<width<<", "<<height;
            if (float(width) / height < 90.0/50.0) {
                m_pluginWidget->setFixedSize(width, width/90.0*50.0);
            } else {
                m_pluginWidget->setFixedSize(height/50.0*90.0, height);
            }
            m_proxyInter->itemUpdate(this, pluginName());
            // m_pluginWidget->setFixedSize(QSize(width,height));
        }
    } else if (cmdType == Dock::MSG_PLUGIN_PROPERTY) {
        QMap<QString, QVariant> map;
        map[Dock::PLUGIN_PROP_NEED_CHAMELEON] = true;
        map[Dock::PLUGIN_PROP_CHAMELEON_MARGIN] = QVariant::fromValue(QMargins(0, 0, 0, 0));
        retObj[Dock::MSG_DATA] = QJsonValue::fromVariant(map);
    }
    QJsonDocument doc;
    doc.setObject(retObj);
    return doc.toJson();
}

void DigitalWellbeingPlugin::positionChanged(const Dock::Position position)
{
    Q_UNUSED(position);
    qDebug()<<"positionChanged";
    if (m_pluginWidget) {
        // 任务栏位置发生改变的时候需要重新设置窗口大小
        m_pluginWidget->setFixedSize(m_pluginWidget->sizeHint());
        // m_proxyInter->itemUpdate(this, pluginName());
        // m_pluginWidget->dockPositionChanged();
    }
}
