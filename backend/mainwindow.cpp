#include "mainwindow.h"
#include "supplier.h"
#include "ui_mainwindow.h"
#include <QtSql/QSqlDatabase>
#include <QDebug>
#include <QDateTime>
#include "databasemanager.h"
#include "Medicine.h"
#include "order.h"
#include "stock.h"
#include <QFile>
#include <QTextStream>
#include <QIODevice>


MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent) , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    DatabaseManager dbManager;

    // Step 1: Create a customer and order
    QString customerName = "Hiba Abrar";
    int customerID = dbManager.addCustomer(customerName, "038877775556");
    int currentOrderID = dbManager.startOrder(customerName);

    // Step 2: Add multiple medicines
    QStringList meds = {"Amoxicillin"};
    QList<int> quantities = {1};

    for (int i = 0; i < meds.size(); ++i) {
        if (!dbManager.placeOrder(meds[i], quantities[i])) {
            qDebug() << "Failed to add" << meds[i];
        }
    }

    // Step 3: Confirm the order
    if (!dbManager.confirmOrder(currentOrderID)) {
        qDebug() << "Order confirmation failed.";
        return;
    }

    // Step 4: Apply discount and display receipt
    double discountPercent = 5.0;
    double totalPayable = dbManager.displayReceipt(currentOrderID, discountPercent);
    if (totalPayable <= 0) {
        qDebug() << "Receipt generation failed.";
        return;
    }

    // Step 5: Finalize sale with payment method
    QString paymentMethod = "Online";
    if (!dbManager.finalizeSale(currentOrderID, paymentMethod, totalPayable)) {
        qDebug() << "Sale finalization failed.";
    } else {
        qDebug() << "Sale completed successfully!";
    }
}

MainWindow::~MainWindow()
{
    delete ui;
}

