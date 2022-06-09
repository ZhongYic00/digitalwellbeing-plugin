#include "pluginwidget.h"
#include <QVBoxLayout>
#include <QLabel>
#include <QtQuickWidgets/QQuickWidget>
#include <QTimer>
#include <QQmlEngine>
#include <QtQml>
#include "dtk/include/qtquickdtk.h"

pluginWidget::pluginWidget()
{
    auto layout=this->layout();
    if(!layout)layout=new QHBoxLayout(this);

    setMinimumSize(90,40);

    m_quickwidget=new QQuickWidget(this);
    m_quickwidget->setAutoFillBackground(false);
    m_quickwidget->setAttribute(Qt::WA_TranslucentBackground);
    m_quickwidget->setAttribute(Qt::WA_AlwaysStackOnTop);
    m_quickwidget->setAttribute(Qt::WA_TransparentForMouseEvents);
    m_quickwidget->setClearColor(Qt::transparent);
    enableQtQuickDTKStyle(m_quickwidget->engine());
    setProperty("BasicStat","{}");
    m_quickwidget->setSource(QUrl("qrc:/qml/PluginItem.qml"));
    layout->addWidget(m_quickwidget);
    layout->setMargin(0);
    setLayout(layout);
    qWarning()<<">>>>>>>>>>>>>>>>>>>>widget status:"<<m_quickwidget->status()<<this->sizeHint();
}
void pluginWidget::setProperty(QString property, QString value){
    m_quickwidget->engine()->rootContext()->setContextProperty(property,value);
}
void pluginWidget::resizeEvent(QResizeEvent *event){
    qWarning()<<">>>resizeEvent"<<event->size();
    if(isVisible()){
        emit requestUpdateGeometry();
    }
    QWidget::resizeEvent(event);
}
