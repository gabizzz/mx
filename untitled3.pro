TEMPLATE = app

QT += qml quick sql

SOURCES += main.cpp \
    model.cpp \
    sqlite.cpp

RESOURCES += qml.qrc
TARGET = MX

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    model.h \
    sqlite.h

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

DISTFILES += \
    android/AndroidManifest.xml \
    android/res/values/libs.xml \
    android/build.gradle
