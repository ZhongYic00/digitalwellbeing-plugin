
#ifndef DATETIMEWIDGET_H
#define DATETIMEWIDGET_H

//#include <com_deepin_daemon_timedate.h>

#include <QWidget>

//using Timedate = com::deepin::daemon::Timedate;
class Timedate{

};

class DatetimeWidget : public QWidget
{
    Q_OBJECT

public:
    explicit DatetimeWidget(QWidget *parent = 0);

    bool is24HourFormat() const { return m_24HourFormat; }
    QSize sizeHint() const;

protected:
    void resizeEvent(QResizeEvent *event);
    void paintEvent(QPaintEvent *e);

signals:
    void requestUpdateGeometry() const;

public slots:
    void set24HourFormat(const bool value);

private Q_SLOTS:
    void setShortDateFormat(int type);
    void setShortTimeFormat(int type);

private:
    QSize curTimeSize() const;

private:
    bool m_24HourFormat;
    mutable QFont m_timeFont;
    mutable QFont m_dateFont;
    mutable int m_timeOffset;
    Timedate *m_timedateInter;
    QString m_shortDateFormat;
    QString m_shortTimeFormat;
};

#endif // DATETIMEWIDGET_H
