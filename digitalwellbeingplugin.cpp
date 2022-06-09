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

    qWarning()<<"itemWidget"<<itemKey<<m_pluginWidget;
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
        qWarning()<<">>>>>>itemRemoved";
        m_proxyInter->itemRemoved(this, pluginName());
        m_proxyInter->itemUpdate(this,pluginName());
        m_refreshTimer->stop();
    } else {
        initPluginWidget();
        qWarning()<<">>>>>>itemAdded";
        m_proxyInter->itemAdded(this, pluginName());
//        m_refreshTimer->start(60000);
    }

}

//#include "digitalwellbeingplugin.h"
////#include "../../widgets/tipswidget.h"
////#include "../../frame/util/utils.h"

//#include <DDBusSender>

//#include <QDebug>
//#include <QDBusConnectionInterface>

//#include <unistd.h>

//#define PLUGIN_STATE_KEY "enable"
//#define TIME_FORMAT_KEY "Use24HourFormat"
////using namespace Dock;
//DatetimePlugin::DatetimePlugin(QObject *parent)
//    : QObject(parent)
//    , m_centralWidget(nullptr)
////    , m_dateTipsLabel(nullptr)
//    , m_refershTimer(nullptr)
//    , m_interface(nullptr)
//    , m_pluginLoaded(false)
//{
//    QDBusConnection sessionBus = QDBusConnection::sessionBus();
//    sessionBus.connect("com.deepin.daemon.Timedate", "/com/deepin/daemon/Timedate", "org.freedesktop.DBus.Properties",  "PropertiesChanged", this, SLOT(propertiesChanged()));
//}

//PluginsItemInterface::PluginSizePolicy DatetimePlugin::pluginSizePolicy() const
//{
//    return PluginsItemInterface::Custom;
//}

//const QString DatetimePlugin::pluginName() const
//{
//    return "digitalwellbeing";
//}

//const QString DatetimePlugin::pluginDisplayName() const
//{
//    return tr("Digital Wellbeing");
//}

//void DatetimePlugin::init(PluginProxyInterface *proxyInter)
//{
//    m_proxyInter = proxyInter;

//    // transfer config
////    QSettings settings("deepin", "dde-dock-datetime");
////    if (QFile::exists(settings.fileName())) {
////        Dock::DisplayMode mode = displayMode();
////        const QString key = QString("pos_%1_%2").arg(pluginName()).arg(mode);
////        proxyInter->saveValue(this, key, settings.value(key, mode == Dock::DisplayMode::Fashion ? 6 : -1));
////        QFile::remove(settings.fileName());
////    }

//    if (pluginIsDisable()) {
//        return;
//    }

//    loadPlugin();
//}

//void DatetimePlugin::loadPlugin()
//{
//    if (m_pluginLoaded)
//        return;

//    m_pluginLoaded = true;
////    m_dateTipsLabel.reset(new TipsWidget);
//    m_refershTimer = new QTimer(this);
////    m_dateTipsLabel->setObjectName("datetime");

//    m_refershTimer->setInterval(1000);
//    m_refershTimer->start();

//    m_centralWidget.reset(new DatetimeWidget);

//    connect(m_centralWidget.data(), &DatetimeWidget::requestUpdateGeometry, [this] { m_proxyInter->itemUpdate(this, pluginName()); });
//    connect(m_refershTimer, &QTimer::timeout, this, &DatetimePlugin::updateCurrentTimeString);

//    m_proxyInter->itemAdded(this, pluginName());

//    pluginSettingsChanged();
//}

//void DatetimePlugin::pluginStateSwitched()
//{
//    m_proxyInter->saveValue(this, PLUGIN_STATE_KEY, pluginIsDisable());

//    refreshPluginItemsVisible();
//}

//bool DatetimePlugin::pluginIsDisable()
//{
//    return !(m_proxyInter->getValue(this, PLUGIN_STATE_KEY, true).toBool());
//}

//int DatetimePlugin::itemSortKey(const QString &itemKey)
//{
//    Q_UNUSED(itemKey);

//    const QString key = QString("pos_%1_%2").arg(itemKey).arg(Dock::Efficient);
//    return m_proxyInter->getValue(this, key, 6).toInt();
//}

//void DatetimePlugin::setSortKey(const QString &itemKey, const int order)
//{
//    Q_UNUSED(itemKey);

//    const QString key = QString("pos_%1_%2").arg(itemKey).arg(Dock::Efficient);
//    m_proxyInter->saveValue(this, key, order);
//}

//QWidget *DatetimePlugin::itemWidget(const QString &itemKey)
//{
//    Q_UNUSED(itemKey);

//    return m_centralWidget.data();
//}

//QWidget *DatetimePlugin::itemTipsWidget(const QString &itemKey)
//{
//    Q_UNUSED(itemKey);

////    return m_dateTipsLabel.data();
//    return nullptr;
//}

//const QString DatetimePlugin::itemCommand(const QString &itemKey)
//{
//    Q_UNUSED(itemKey);

//    return "dbus-send --print-reply --dest=com.deepin.Calendar /com/deepin/Calendar com.deepin.Calendar.RaiseWindow";
//}

//const QString DatetimePlugin::itemContextMenu(const QString &itemKey)
//{
//    Q_UNUSED(itemKey);

//    QList<QVariant> items;
//    items.reserve(1);

//    QMap<QString, QVariant> settings;
//    settings["itemId"] = "settings";
//    if (m_centralWidget->is24HourFormat())
//        settings["itemText"] = tr("12-hour time");
//    else
//        settings["itemText"] = tr("24-hour time");
//    settings["isActive"] = true;
//    items.push_back(settings);

//    if (!QFile::exists("ICBC_CONF_FILE")) {
//        QMap<QString, QVariant> open;
//        open["itemId"] = "open";
//        open["itemText"] = tr("Time settings");
//        open["isActive"] = true;
//        items.push_back(open);
//    }

//    QMap<QString, QVariant> menu;
//    menu["items"] = items;
//    menu["checkableMenu"] = false;
//    menu["singleCheck"] = false;

//    return QJsonDocument::fromVariant(menu).toJson();
//}

//void DatetimePlugin::invokedMenuItem(const QString &itemKey, const QString &menuId, const bool checked)
//{
//    Q_UNUSED(itemKey)
//    Q_UNUSED(checked)

//    if (menuId == "open") {
//        DDBusSender()
//                .service("com.deepin.dde.ControlCenter")
//                .interface("com.deepin.dde.ControlCenter")
//                .path("/com/deepin/dde/ControlCenter")
//                .method(QString("ShowModule"))
//                .arg(QString("datetime"))
//                .call();
//    } else {
//        const bool value = timedateInterface()->property(TIME_FORMAT_KEY).toBool();
//        timedateInterface()->setProperty(TIME_FORMAT_KEY, !value);
//        m_centralWidget->set24HourFormat(!value);
//    }
//}

//void DatetimePlugin::pluginSettingsChanged()
//{
//    if (!m_pluginLoaded)
//        return;

//    const bool value = timedateInterface()->property(TIME_FORMAT_KEY).toBool();

//    m_proxyInter->saveValue(this, TIME_FORMAT_KEY, value);
//    m_centralWidget->set24HourFormat(value);

//    refreshPluginItemsVisible();
//}

//void DatetimePlugin::updateCurrentTimeString()
//{
//    const QDateTime currentDateTime = QDateTime::currentDateTime();

////    if (m_centralWidget->is24HourFormat())
////        m_dateTipsLabel->setText(currentDateTime.date().toString(Qt::SystemLocaleLongDate) + currentDateTime.toString(" HH:mm:ss"));
////    else
////        m_dateTipsLabel->setText(currentDateTime.date().toString(Qt::SystemLocaleLongDate) + currentDateTime.toString(" hh:mm:ss A"));

//    const QString currentString = currentDateTime.toString("yyyy/MM/dd hh:mm");

//    if (currentString == m_currentTimeString)
//        return;

//    m_currentTimeString = currentString;
//    //当时间显示格式为12小时制且格式为0:00时，当从9:59变到10:00时，插件宽度需要变化
//    m_centralWidget->requestUpdateGeometry();
//}

//void DatetimePlugin::refreshPluginItemsVisible()
//{
//    if (!pluginIsDisable()) {

//        if (!m_pluginLoaded) {
//            loadPlugin();
//            return;
//        }
//        m_proxyInter->itemAdded(this, pluginName());
//    } else {
//        m_proxyInter->itemRemoved(this, pluginName());
//    }
//}

//void DatetimePlugin::propertiesChanged()
//{
//    pluginSettingsChanged();
//}

//QDBusInterface* DatetimePlugin::timedateInterface()
//{
//    if (!m_interface) {
//        if (QDBusConnection::sessionBus().interface()->isServiceRegistered("com.deepin.daemon.Timedate")) {
//            m_interface = new QDBusInterface("com.deepin.daemon.Timedate", "/com/deepin/daemon/Timedate", "com.deepin.daemon.Timedate", QDBusConnection::sessionBus(), this);
//        } else {
//            const QString path = QString("/com/deepin/daemon/Accounts/User%1").arg(QString::number(getuid()));
//            QDBusInterface * systemInterface = new QDBusInterface("com.deepin.daemon.Accounts", path, "com.deepin.daemon.Accounts.User",
//                                                                  QDBusConnection::systemBus(), this);
//            return systemInterface;
//        }
//    }

//    return m_interface;
//}