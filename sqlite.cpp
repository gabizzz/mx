#include "sqlite.h"
#include <QDebug>
#include <QStandardPaths>


sqlite::sqlite(QObject *parent) : QObject(parent)
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(QStandardPaths::standardLocations(QStandardPaths::DataLocation).at(0)+"/QML/OfflineStorage/Databases/mx.sqlite");
    db.open();

    QSqlQuery q;
    q.exec("CREATE TABLE IF NOT EXISTS SETTING(Id INTEGER PRIMARY KEY, Desc TEXT)");
}

sqlite::~sqlite()
{

}

QString sqlite::select() const
{
    QSqlQuery q;
    q.exec("SELECT * FROM SETTING");
    q.next();

    return q.value(1).toString();
}

void sqlite::insertValues(QString arg){
    QSqlQuery q;
    q.exec(arg);
}

void sqlite::deleteValues(){
    QSqlQuery q;
    q.exec("DELETE FROM SETTING");
}
