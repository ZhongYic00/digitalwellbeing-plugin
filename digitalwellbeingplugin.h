#ifndef HELLOWORLDPLUGIN_H
#define HELLOWORLDPLUGIN_H

#include <dde-dock/pluginsiteminterface.h>
#include <QObject>
#include <QTimer>
#include "pluginwidget.h"
#include "appletwidget.h"

class DigitalWellbeingPlugin : public QObject, PluginsItemInterface
{
    Q_OBJECT
    // 声明实现了的接口
    Q_INTERFACES(PluginsItemInterface)
    // 插件元数据
    Q_PLUGIN_METADATA(IID "com.deepin.dock.PluginsItemInterface" FILE "digitalwellbeing.json")

public:
    explicit DigitalWellbeingPlugin(QObject *parent = nullptr);

    // 返回插件的名称，必须是唯一值，不可以和其它插件冲突
    const QString pluginName() const override{return  "digitalwellbeing";}
    const QString pluginDisplayName() const override{return  QStringLiteral("Digital Wellbeing");}
    bool pluginIsAllowDisable() override { return true; }
    bool pluginIsDisable() override {
        qWarning()<<">>>>>>pluginIsDisable"<<m_proxyInter->getValue(this, "disabled", false).toBool();
        return m_proxyInter->getValue(this, "disabled", false).toBool();
    }
    void pluginStateSwitched() override;
    PluginSizePolicy pluginSizePolicy() const override {
        qWarning()<<">>>pluginSizePolicy()";
        return Custom;
    }

    // 插件初始化函数
    void init(PluginProxyInterface *proxyInter) override;

    // 返回插件的 widget
    QWidget *itemWidget(const QString &itemKey) override;
    QWidget *itemPopupApplet(const QString &itemKey) override;
private:
    QTimer *m_refreshTimer;
    pluginWidget *m_pluginWidget;
    appletWidget *m_appletWidget;

    void initPluginWidget();
};

#endif // HELLOWORLDPLUGIN_H

//#ifndef DATETIMEPLUGIN_H
//#define DATETIMEPLUGIN_H

//#include "pluginsiteminterface.h"
//#include "datetimewidget.h"

//#include <QTimer>
//#include <QLabel>
//#include <QSettings>

//namespace Dock{
//class TipsWidget;
//}
//class QDBusInterface;
//class DatetimePlugin : public QObject, PluginsItemInterface
//{
//    Q_OBJECT
//    Q_INTERFACES(PluginsItemInterface)
//    Q_PLUGIN_METADATA(IID "com.deepin.dock.PluginsItemInterface" FILE "digitalwellbeing.json")

//public:
//    explicit DatetimePlugin(QObject *parent = nullptr);

//    PluginSizePolicy pluginSizePolicy() const override;

//    const QString pluginName() const override;
//    const QString pluginDisplayName() const override;
//    void init(PluginProxyInterface *proxyInter) override;

//    void pluginStateSwitched() override;
//    bool pluginIsAllowDisable() override { return true; }
//    bool pluginIsDisable() override;

//    int itemSortKey(const QString &itemKey) override;
//    void setSortKey(const QString &itemKey, const int order) override;

//    QWidget *itemWidget(const QString &itemKey) override;
//    QWidget *itemTipsWidget(const QString &itemKey) override;

//    const QString itemCommand(const QString &itemKey) override;
//    const QString itemContextMenu(const QString &itemKey) override;

//    void invokedMenuItem(const QString &itemKey, const QString &menuId, const bool checked) override;

//    void pluginSettingsChanged() override;

//private slots:
//    void updateCurrentTimeString();
//    void refreshPluginItemsVisible();
//    void propertiesChanged();

//private:
//    void loadPlugin();
//    QDBusInterface *timedateInterface();

//private:
//    QScopedPointer<DatetimeWidget> m_centralWidget;
////    QScopedPointer<Dock::TipsWidget> m_dateTipsLabel;
//    QTimer *m_refershTimer;
//    QString m_currentTimeString;
//    QDBusInterface *m_interface;
//    bool m_pluginLoaded;
//};

//#endif // DATETIMEPLUGIN_H
