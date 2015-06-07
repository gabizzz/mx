#ifndef SQLITE_H
#define SQLITE_H

#include <QObject>
#include <QSqlQuery>
#include <QtSql/QSqlDatabase>

class sqlite : public QObject
{
    Q_OBJECT
public:
    explicit sqlite(QObject *parent = 0);
    ~sqlite();
    Q_INVOKABLE QString select() const;

signals:

public slots:
    Q_INVOKABLE void insertValues(QString arg);
    Q_INVOKABLE void deleteValues();
};

#endif // SQLITE_H
