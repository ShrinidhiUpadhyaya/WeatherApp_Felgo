#ifndef APPDATA_H
#define APPDATA_H

#include <QObject>
#include <QJsonObject>
#include <QJsonDocument>
#include <QNetworkReply>
#include <QFile>
#include <QJsonArray>
#include <QIODevice>

class AppData : public QObject
{
    Q_OBJECT

    QNetworkAccessManager* m_netAccessMgr;

    void sortData(QJsonObject);

public:
    explicit AppData(QObject *parent = nullptr);

public slots:
    void request();

signals:

};

#endif // APPDATA_H
