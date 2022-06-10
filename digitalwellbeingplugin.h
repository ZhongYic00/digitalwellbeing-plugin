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
    const QString pluginName() const override{return  "datetime";}
    const QString pluginDisplayName() const override{return  QStringLiteral("Digital Wellbeing");}
    bool pluginIsAllowDisable() override { return true; }
    bool pluginIsDisable() override {
//        qWarning()<<">>>pluginIsDisable"<<m_proxyInter->getValue(this, "disabled", false).toBool();
        return m_proxyInter->getValue(this, "disabled", false).toBool();
    }
    void pluginStateSwitched() override;
    PluginSizePolicy pluginSizePolicy() const override {
        qDebug()<<">>>pluginSizePolicy()";
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
