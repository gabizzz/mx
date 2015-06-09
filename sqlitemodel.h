#ifndef SQLITEMODEL_H
#define SQLITEMODEL_H

#include <QObject>
#include <QSqlQueryModel>

class SQLiteModel : public QSqlQueryModel {
Q_OBJECT

public:
    explicit SQLiteModel(QObject *parent = NULL);
    ~SQLiteModel();

    Q_INVOKABLE bool setDatabase(const QString &database);
    Q_INVOKABLE bool setQuery(const QString &query);

    Q_INVOKABLE QVariantMap get(int row) const;

    QHash<int, QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &index, int role=Qt::DisplayRole) const override;

    static void declareQML();

private:
    QSqlDatabase _db;

    static QString _connection();

};

#endif // SQLITEMODEL_H
