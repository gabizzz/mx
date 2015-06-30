#include <QGuiApplication>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QStringListModel>
#include "model.h"

#include <QDebug>
#include <QStandardPaths>
#include "sqlitemodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/images/iconapp.png"));   

    SQLiteModel::declareQML();

    SQLiteModel seteoMiLibreria;

    MusicaModel modeloMusica;

    CarpetaModel modeloCarpetas;

    QObject::connect(&modeloMusica,SIGNAL(enviaOrden(QString)),&modeloCarpetas,SLOT(recibeOrden(QString)));

    QString directorioDCIM=QStandardPaths::standardLocations(QStandardPaths::MusicLocation).at(0);

    seteoMiLibreria.setDatabase("/QML/OfflineStorage/Databases/mx.sqlite");
    seteoMiLibreria.setQuery("SELECT * FROM SETTING");

    //modeloMusica.cargarModelo(seteoMiLibreria.get(0).first().toString());
    //modeloMusica.cargarModelo(QStandardPaths::standardLocations(QStandardPaths::MusicLocation).at(0));

    //qDebug()<<QStandardPaths::standardLocations(QStandardPaths::MusicLocation).at(0);

    QQmlApplicationEngine engine;

    //los declaro antes de iniciar el main
    engine.rootContext()->setContextProperty("myModelMusica", &modeloMusica);
    engine.rootContext()->setContextProperty("myDirectorio", directorioDCIM);
    engine.rootContext()->setContextProperty("myModelCarpetas",&modeloCarpetas);
    //engine.rootContext()->setContextProperty("myQuery",&consulta);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));


    return app.exec();
}
