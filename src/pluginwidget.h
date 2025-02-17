#ifndef PLUGINWIDGET_H
#define PLUGINWIDGET_H

#include <QWidget>
#include <QQuickWidget>
#include <QLabel>

class pluginWidget: public QWidget
{
    Q_OBJECT
public:
    explicit pluginWidget();
    void setProperty(QString property,QString value);
    // void init();
//     QSize sizeHint() const override{
//        qWarning()<<">>>>>>>pluginWidget::sizeHint"<<m_quickwidget->sizeHint();
// //        if(!isVisible())return QSize(0,0);
//         return m_quickwidget->sizeHint();
//     }

protected:
    void resizeEvent(QResizeEvent *event) override;

signals:
    void requestUpdateGeometry() const;

private:
    QQuickWidget *m_quickwidget;
//    void refreshInfo();
};

#endif // PLUGINWIDGET_H
