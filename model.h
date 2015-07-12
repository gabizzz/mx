#include <QAbstractListModel>
#include <QStringList>
//![0]
class Musica
{
public:
    Musica(const QString &archivo, const QString &ubicacion, const QString &abc);
//![0]
    QString archivo() const;
    QString ubicacion() const;
    QString abc() const;
private:
    QString m_archivo;
    QString m_ubicacion;
    QString m_abc;
//![1]
};

class Carpeta
{
public:
    Carpeta(const QString &nombre);
//![0]
    QString nombre() const;
private:
    QString c_nombre;
//![1]
};

class CarpetaModel : public QAbstractListModel
{
Q_OBJECT
public:
    Q_INVOKABLE QVariantMap get(int row) const;
    Q_INVOKABLE void cargarModelo();
    Q_INVOKABLE void limpiarModelo();


    enum CarpetaRoles {NombreRole};
    CarpetaModel(QObject *parent = 0);
//![1]

    void addCarpetas(const Carpeta &carpeta);

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
protected:
    QHash<int, QByteArray> roleNames() const;
private:
    QList<Carpeta> c_carpetas;

public slots:
    void recibeOrden(const QString &orden);
//![2]
};

class MusicaModel : public QAbstractListModel
{
Q_OBJECT
public:
    Q_INVOKABLE QVariantMap get(int row) const;
    Q_INVOKABLE void cargarModelo(QString path);
    Q_INVOKABLE void limpiarModelo();
    enum MusicaRoles {ArchivoRole,UbicacionRole,AbcRole};
    MusicaModel(QObject *parent = 0);
//![1]

    void addMusica(const Musica &musica);

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
protected:
    QHash<int, QByteArray> roleNames() const;
private:
    QList<Musica> m_musicas;
signals:
    void enviaOrden(const QString &orden);


//![2]
};
