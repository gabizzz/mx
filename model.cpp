#include "model.h"
#include <QDebug>
#include <QDirIterator>
#include <QFile>

QStringList carpetitas;
Musica::Musica(const QString &archivo, const QString &ubicacion, const QString &abc)
: m_archivo(archivo), m_ubicacion(ubicacion), m_abc(abc)
{

}

Carpeta::Carpeta(const QString &nombre)
: c_nombre(nombre)
{

}

QString Carpeta::nombre() const
{
    return c_nombre;
}

QString Musica::archivo() const
{
    return m_archivo;
}

QString Musica::ubicacion() const
{
    return m_ubicacion;
}

QString Musica::abc() const
{
    return m_abc;
}

MusicaModel::MusicaModel(QObject *parent)
: QAbstractListModel(parent)
{

}

CarpetaModel::CarpetaModel(QObject *parent)
: QAbstractListModel(parent)
{

}

void MusicaModel::addMusica(const Musica &musica)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
        m_musicas.insert(rowCount(),musica);
    endInsertRows();
}

void CarpetaModel::addCarpetas(const Carpeta &carpeta)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
        c_carpetas.insert(rowCount(),carpeta);
    endInsertRows();
}

int MusicaModel::rowCount(const QModelIndex & parent) const
{
    return m_musicas.count();
}

int CarpetaModel::rowCount(const QModelIndex & parent) const
{
    return c_carpetas.count();
}

QVariant CarpetaModel::data(const QModelIndex & index, int role) const
{

    if (index.row() < 0 || index.row() >= c_carpetas.count())
        return QVariant();
        const Carpeta &carpeta = c_carpetas[index.row()];
    if (role == NombreRole)
        return carpeta.nombre();
    return QVariant();
}

QVariant MusicaModel::data(const QModelIndex & index, int role) const
{

    if (index.row() < 0 || index.row() >= m_musicas.count())
        return QVariant();
        const Musica &musica = m_musicas[index.row()];
    if (role == ArchivoRole)
        return musica.archivo();
    else if (role == UbicacionRole)
        return musica.ubicacion();
    else if (role == AbcRole)
    {
        return musica.abc();
    }
    return QVariant();
}
//![0]
//!
//!
QHash<int, QByteArray> CarpetaModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NombreRole] = "nombre";
    return roles;
}


QHash<int, QByteArray> MusicaModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[ArchivoRole] = "archivo";
    roles[UbicacionRole] = "ubicacion";
    roles[AbcRole] = "abc";
    return roles;
}
//![0]
QVariantMap MusicaModel::get(int row) const
{
    QVariantMap map;
    foreach(int k, roleNames().keys())
    {
        map[roleNames().value(k)] = data(index(row, 0), k);
    }
        return map;
}

QVariantMap CarpetaModel::get(int row) const
{
    QVariantMap map;
    foreach(int k, roleNames().keys())
    {
        map[roleNames().value(k)] = data(index(row, 0), k);
    }
    return map;
}

void MusicaModel::limpiarModelo()
{
    beginResetModel();
    m_musicas.clear();
    endResetModel();
}

void CarpetaModel::limpiarModelo()
{
    beginResetModel();
    c_carpetas.clear();
    endResetModel();
}

void CarpetaModel::cargarModelo()
{
    carpetitas.removeDuplicates();

    for(int x =0;x<carpetitas.count();x++)
    {
        addCarpetas(Carpeta(carpetitas.at(x)));
    }
}

void CarpetaModel::recibeOrden(const QString &orden)
{
    if (orden=="cargar")
    {
        cargarModelo();
    }
}

void MusicaModel::cargarModelo(QString path)
{
    carpetitas.clear();

    QDirIterator it(path, QStringList() << "*.mp3" << "*.MP3", QDir::Files, QDirIterator::Subdirectories);

    QString ultimoDir;
    while (it.hasNext())
    {
        it.next();
        QStringList dirpath=it.filePath().split("/");
        dirpath.removeLast();
        addMusica(Musica(it.fileName(), it.filePath(),dirpath.last()));
        if (ultimoDir != dirpath.last())
        {
            ultimoDir=dirpath.last();
            carpetitas<<ultimoDir.toUpper();
        }
    }

    emit enviaOrden("cargar");

// esto era para ordenar el contenido alfabeticamente
//    int n;
//    int i;
//    for (n=0; n < m_musicas.count(); n++)
//    {
//        for (i=n+1; i < m_musicas.count(); i++)
//        {
//            QString valorN=m_musicas.at(n).archivo();
//            QString valorI=m_musicas.at(i).archivo();
//            if (valorN.toUpper() > valorI.toUpper())
//            {
//                m_musicas.move(i, n);
//                n=0;
//            }
//        }
//    }

}
