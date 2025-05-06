#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQml>
#include "backend/databasemanager.h"
#include <QDir>
#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    // Create data directory if it doesn't exist
    QDir dataDir(QCoreApplication::applicationDirPath() + "/data");
    if (!dataDir.exists()) {
        dataDir.mkpath(".");
        qDebug() << "Created data directory at:" << dataDir.absolutePath();
    }

    // Set up database connection before anything else
    DatabaseManager dbManager;
    
    // Handle database connection failure
    if (!dbManager.isDatabaseConnected()) {
        qDebug() << "Warning: Database not connected initially. Will attempt reconnection.";
    }

    QQmlApplicationEngine engine;

    // Expose DatabaseManager to QML
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