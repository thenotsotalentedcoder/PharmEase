#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "backend/databasemanager.h"
#include <QDir>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Create DatabaseManager instance and expose to QML
    DatabaseManager dbManager;
    engine.rootContext()->setContextProperty("dbManager", &dbManager);

    // Connect to signal for error handling
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { 
            qDebug() << "QML object creation failed!";
            QCoreApplication::exit(-1); 
        },
        Qt::QueuedConnection);
        
    // Load main QML file
    engine.load(QUrl(QStringLiteral("qrc:/qml/App.qml")));

    // Check if loading was successful
    if (engine.rootObjects().isEmpty()) {
        qDebug() << "Failed to load QML file!";
        return -1;
    }

    return app.exec();
}