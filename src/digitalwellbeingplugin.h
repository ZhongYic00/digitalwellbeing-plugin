#ifndef HELLOWORLDPLUGIN_H
#define HELLOWORLDPLUGIN_H

#include <dde-dock/pluginsiteminterface_v2.h>
#include <QObject>
#include <QTimer>
#include "pluginwidget.h"
#include "appletwidget.h"

class DigitalWellbeingPlugin : public QObject, PluginsItemInterfaceV2
{
    Q_OBJECT
    // 声明实现了的接口
    Q_INTERFACES(PluginsItemInterfaceV2)
    // 插件元数据
    Q_PLUGIN_METADATA(IID ModuleInterface_iid_V2 FILE "digitalwellbeing.json")

public:
    explicit DigitalWellbeingPlugin(QObject *parent = nullptr);

    // 返回插件的名称，必须是唯一值，不可以和其它插件冲突
    const QString pluginName() const override{return  "digitalwellbeing";}
    const QString pluginDisplayName() const override{return  QStringLiteral("Digital Wellbeing");}
    bool pluginIsAllowDisable() override { return true; }
    bool pluginIsDisable() override {
//        qWarning()<<">>>pluginIsDisable"<<m_proxyInter->getValue(this, "disabled", false).toBool();
        return m_proxyInter->getValue(this, "disabled", false).toBool();
    }
    void pluginStateSwitched() override;
    inline PluginSizePolicy pluginSizePolicy() const override {
        qDebug()<<">>>pluginSizePolicy()";
        return Custom;
    }

    // 插件初始化函数
    void init(PluginProxyInterface *proxyInter) override;

    int itemSortKey(const QString &itemKey) override;
    void setSortKey(const QString &itemKey, const int order) override;

    // 返回插件的 widget
    QWidget *itemWidget(const QString &itemKey) override;
    QWidget *itemPopupApplet(const QString &itemKey) override;
    QWidget *itemTipsWidget(const QString &itemKey) override;

    const QString itemContextMenu(const QString &itemKey) override;

    virtual Dock::PluginFlags flags() const override;

    virtual QString message(const QString &) override;
    virtual void positionChanged(const Dock::Position position) override;
private:
    QTimer *m_refreshTimer = nullptr;
    pluginWidget *m_pluginWidget = nullptr;
    appletWidget *m_appletWidget = nullptr;
    QWidget *m_tooltipWidget = nullptr;

    void initPluginWidget();
};

#endif // HELLOWORLDPLUGIN_H
