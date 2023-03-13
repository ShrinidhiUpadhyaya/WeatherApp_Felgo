#include "appdata.h"

AppData::AppData(QObject *parent)
    : QObject{parent}
{

}

void AppData::request() {
    qDebug() << "Request all states vaccine data";

        QString searchString = QString("https://api.open-meteo.com/v1/forecast?latitude=49.90&longitude=10.90&hourly=temperature_2m");
        QNetworkRequest request(searchString);
        QSslConfiguration conf = request.sslConfiguration();
        conf.setPeerVerifyMode(QSslSocket::VerifyNone);
        request.setSslConfiguration(conf);
        auto networkReply = m_netAccessMgr->get(request);

        connect(networkReply, &QNetworkReply::finished, [=] {
            if (!networkReply->error()) {
                qDebug() << "(requestAllStatesVaccineData) Successfull Response";
                auto data = networkReply->readAll();
//                sortAllStatesVaccineData(data);
//                setConfigError("");
            }
        });

//        connect(networkReply,
//                static_cast<void (QNetworkReply::*)(QNetworkReply::NetworkError)>(&QNetworkReply::error),
//                [=](QNetworkReply::NetworkError code) {
//            qDebug() << "(requestAllStatesVaccineData) Error connecting to the api:" << networkReply->errorString() << endl
//                     << "Error code:" << code;
//            qDebug() << networkReply->readAll();
////            setConfigError(networkReply->errorString());
////            readAllStatesVaccineData();
//        });
}

void AppData::sortData(QJsonObject data) {
    qDebug() << data;
}
