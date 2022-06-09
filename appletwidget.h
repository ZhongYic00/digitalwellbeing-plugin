#ifndef APPLETWIDGET_H
#define APPLETWIDGET_H

#include <QWidget>
#include <QtQuickWidgets/QQuickWidget>

class appletWidget:public QWidget
{
    Q_OBJECT
public:
    appletWidget();
    void setProperty(QString property,QString json);
//    QSize sizeHint() const override{return QSize(80,50);}
private:
    QQuickWidget *quickwidget;
};

#endif // APPLETWIDGET_H
