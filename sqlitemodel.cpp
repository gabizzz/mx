#include "sqlitemodel.h"
#include <QDebug>
#include <QSqlRecord>
#include <QSqlQuery>
#include <QtQml>
#include <QFileInfo>

SQLiteModel::SQLiteModel(QObject *parent)
: QSqlQueryModel(parent) {
_db = QSqlDatabase::addDatabase("QSQLITE", _connection());
}

SQLiteModel::~SQLiteModel() {
    if (_db.isOpen()) _db.close();
}

bool SQLiteModel::setDatabase(const QString &database)
{   
    if (!QFileInfo(QStandardPaths::standardLocations(QStandardPaths::DataLocation).at(0)+database).exists())
    {
        qDebug() << "set data bases";
//        QSqlQuery q;
//        q.exec("CREATE TABLE IF NOT EXISTS SETTING(Id INTEGER PRIMARY KEY, Desc TEXT)");
//        q.exec("CREATE TABLE IF NOT EXISTS LOG (id INTEGER PRIMARY KEY AUTOINCREMENT,archivo CHAR NOT NULL  UNIQUE , reprod INTEGER DEFAULT 0)");

        return false;
    }

    if (_db.isOpen())
    {
        _db.close();
        this->clear();
    }

    _db.setDatabaseName(QStandardPaths::standardLocations(QStandardPaths::DataLocation).at(0)+database);

    if (!_db.open())
    {
        qDebug() << "error";
        return false;
    }
    return true;
}

bool SQLiteModel::setQuery(const QString &query)
{
    //qDebug() << query;
    QSqlQueryModel::setQuery(query, _db);
    if (this->query().record().isEmpty()) {
        qDebug() << "SQLiteModel::setQuery()";
        return false;
    }
    return true;
}

QHash<int, QByteArray> SQLiteModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    for ( int i = 0; i < this->record().count(); i++)
    {
        roles[Qt::UserRole + i + 1] = this->record().fieldName(i).toLocal8Bit();
    }
    return roles;
}

QVariantMap SQLiteModel::get(int row) const
{
    QVariantMap map;
    foreach(int k, roleNames().keys())
    {
        map[roleNames().value(k)] = data(index(row, 0), k);
    }
    return map;
}

QVariant SQLiteModel::data(const QModelIndex &index, int role) const
{
    QVariant value = QSqlQueryModel::data(index, role);

    if (role < Qt::UserRole)
        value = QSqlQueryModel::data(index, role);
    else {
        int row = index.row();
        int col = role - Qt::UserRole - 1;

        QModelIndex modelIndex = this->index(row, col);

        value = QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
    }
    return value;
}

void SQLiteModel::declareQML()
{
    qmlRegisterType<SQLiteModel>("PluginSqlite", 1, 0, "SQLiteModel");
}

QString SQLiteModel::_connection()
{
    static int ID = 0; ID++;
    return "SQLiteModelConnection" + QString::number(ID);
}
