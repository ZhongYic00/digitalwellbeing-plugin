#include "appletwidget.h"
#include "fromthemeprovider.h"
#include "qtquick-dtk-style/src/include/qtquickdtk.h"
#include <QVBoxLayout>
#include <QLabel>
#include <QQmlEngine>
#include <QtQml>

appletWidget::appletWidget()
{
    auto layout=new QVBoxLayout(this);
    quickwidget=new QQuickWidget;
    qDebug()<<">>>appletWidget status:"<<quickwidget->status();
    quickwidget->setClearColor(Qt::transparent);
    quickwidget->setAttribute(Qt::WA_TranslucentBackground);
    quickwidget->engine()->addImageProvider("fromtheme",new FromThemeProvider);
    enableQtQuickDTKStyle(quickwidget->engine());
    setProperty("EventsDaily","[]");
    setProperty("PerAppStatDaily","[]");
    quickwidget->setSource(QUrl("qrc:/qml/Applet.qml"));
    layout->addWidget(quickwidget);
    layout->setMargin(0);
    setLayout(layout);
}
void appletWidget::setProperty(QString property, QString json){
    quickwidget->engine()->rootContext()->setContextProperty(property,json);
}
