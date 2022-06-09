#ifndef FROMTHEMEPROVIDER_H
#define FROMTHEMEPROVIDER_H

#include <QQuickImageProvider>
#include <QIcon>

class FromThemeProvider:public QQuickImageProvider{
public:
    FromThemeProvider():QQuickImageProvider(QQuickImageProvider::Pixmap){
        qWarning()<<"FromThemeProvider::()";
    }
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize){
        qWarning()<<"requestPixmap"<<id<<size<<requestedSize;
       int width = 50;
       int height = 50;
       if (size)
          *size = QSize(width, height);
       auto icon=QIcon::fromTheme(id);
       if(icon.isNull())icon=QIcon::fromTheme("application-x-executable");
       qWarning()<<icon;
       return icon.pixmap(*size);
    }
};
#endif // FROMTHEMEPROVIDER_H
