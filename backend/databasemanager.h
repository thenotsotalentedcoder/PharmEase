#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include <QVariant>
#include <QVariantList>
#include <QVariantMap>
#include <QCoreApplication>
#include <QFile>
#include <QDir>

#include "customer.h"
#include "supplier.h"
#include "stock.h"
#include <QList>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QVariant>
#include <QDebug>
#include <vector>
#include <QString>

class DatabaseManager : public QObject {
    Q_OBJECT
private:
    QSqlDatabase db;
    bool initializeDatabase();
    QString getDatabasePath();

public:
    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager();

    // Customer Operations
    Q_INVOKABLE int addCustomer(QString name, QString contact);
    Q_INVOKABLE bool removeCustomer(int customer_id);
    Q_INVOKABLE QString getCustomerName(int customer_id);

    // Medicine Operations
    Q_INVOKABLE bool addMedicine(const QString &name, const QString &supplier, double price, int stock, const QString &expiry_date);
    Q_INVOKABLE QString getMedicineName(int medicineID);
    Q_INVOKABLE QVariantList getMedicineList();

    // Stock Operations
    Q_INVOKABLE bool addStock(int medicine_id, int quantity);
    Q_INVOKABLE bool checkStock(int medicine_id);
    Q_INVOKABLE QList<int> getLowStockMedicines(int threshold);
    Q_INVOKABLE bool removeOrderedMeds(int medID, int quantity);

    // Order & Order_Details Operations
    Q_INVOKABLE int createOrder(QString customer_name);
    Q_INVOKABLE bool addOrderDetails(int order_id, int medicine_id, int quantity, double price);
    Q_INVOKABLE bool finalizeOrder(int order_id);
    Q_INVOKABLE bool placeOrder(QString medicineName, int requiredQuantity);
    Q_INVOKABLE int startOrder(QString customerName);
    Q_INVOKABLE bool confirmOrder(int order_id);
    Q_INVOKABLE QVariantList getOrdersList();

    // Additional order operations
    Q_INVOKABLE bool addOrder(int orderID, const QString& customerName, const QString& orderDate, const QString& status);
    Q_INVOKABLE bool addMedicineToOrder(int orderID, int medID, int quantity, double price);
    Q_INVOKABLE bool removeOrderedItem(int orderID);
    Q_INVOKABLE void displayOrderInfo(int orderID);
    Q_INVOKABLE bool updateOrderStatus(int orderID, const QString& status);
    Q_INVOKABLE int getAvailableStock(int medicineID);
    Q_INVOKABLE double getPriceOfMedicine(int medicineID);

    // Discount Operations
    Q_INVOKABLE bool addDiscount(const QString &applicable_medicine, double discount_percentage);
    Q_INVOKABLE bool removeDiscount(int discountID);
    Q_INVOKABLE double getDiscount(const QString& medName);

    // Customer and Supplier Operations
    Q_INVOKABLE bool addCustomer(Customer* customer);
    Q_INVOKABLE bool updateCustomer(Customer* customer);
    Q_INVOKABLE bool addSupplier(Supplier* supplier);
    Q_INVOKABLE bool updateSupplier(Supplier* supplier);
    Q_INVOKABLE bool removeSupplier(int supplierID);

    // Medicine-related functions
    Q_INVOKABLE int insertMedicine(const QString& name, const QString& supplier, double price, const QString& expiry_date);
    Q_INVOKABLE bool removeMeds(int medicineID);
    Q_INVOKABLE bool checkStockByMedicineID(int medicineID);
    Q_INVOKABLE bool checkStockByStockID(int stockID);
    Q_INVOKABLE bool isStockAvailable(int medicineID, int requiredQty);
    Q_INVOKABLE bool checkMedicineByStockID(int stockID);
    Q_INVOKABLE bool checkMedicineByMedicineID(int medicineID);
    Q_INVOKABLE void displayMedicineInfo();
    Q_INVOKABLE int getMedicineIDByName(QString medName);

    // Stock-related functions
    Q_INVOKABLE bool removeExpiredMeds();
    Q_INVOKABLE void displayStockInfo();
    Q_INVOKABLE bool addMeds(int orderID, int medID, int quantity, double price);

    // Billing and invoice generation
    Q_INVOKABLE double calculateSubtotal(int orderID);
    Q_INVOKABLE double applyDiscount(double subtotal, double discountPercentage);
    Q_INVOKABLE int displayReceipt(int orderID, double discountPercent);
    Q_INVOKABLE bool finalizeSale(int orderID, const QString& paymentMethod, double totalAmount);

    // Sales report functions
    Q_INVOKABLE double getTotalSales();
    Q_INVOKABLE QString getMUPM();
    Q_INVOKABLE QPair<QString, double> getBestSellingItem();
    Q_INVOKABLE QVariantMap getBestSellingItemAsMap();
    Q_INVOKABLE double getHighestSale();
    Q_INVOKABLE int getTotalTransactions();
    Q_INVOKABLE double getAverageSale();
    Q_INVOKABLE QVector<QPair<QString,double>> getDailySales();
    Q_INVOKABLE QVariantList getDailySalesData();

    // Authentication
    Q_INVOKABLE bool verifyEmployeeLogin(const QString& username, const QString& password);
    Q_INVOKABLE bool verifyAdminLogin(const QString& password);

    // Employee management
    Q_INVOKABLE QVariantList getAllEmployeesList();
    Q_INVOKABLE bool addEmployee(const QString &name, const QString &role, const QString &salary, const QString &contact);
    Q_INVOKABLE bool updateEmployee(const int employeeId, const QString &name, const QString &role, const QString &salary, const QString &contact);
    Q_INVOKABLE bool deleteEmployee(const int employeeId);

    // Stock management UI functions
    Q_INVOKABLE void getStockInfo();
    Q_INVOKABLE void searchMedicine(const QString &searchText);
    Q_INVOKABLE void searchSupplier(const QString &searchText);
    Q_INVOKABLE bool addStockInfo(int medicineId, const QString &name, const QString &supplier,
                     double price, const QString &expiryDate, int quantity);
    Q_INVOKABLE bool updateStock(int medicineId, const QString &name, const QString &supplier,
                     double price, const QString &expiryDate, int quantity);
    Q_INVOKABLE bool deleteStock(int medicineId);

    // Get inventory data
    Q_INVOKABLE QVariantList getInventoryData();
    
    // New utility methods
    Q_INVOKABLE bool isDatabaseConnected();
    Q_INVOKABLE QString getLastError();

signals:
    void stockDataLoaded(QVariantList stockData);
    void medicineListLoaded(QVariantList medicineList);
    void orderDataLoaded(QVariantList orderData);
    void inventoryDataLoaded(QVariantList inventoryData);
    void stockAdded(bool success);
    void stockUpdated(bool success);
    void stockDeleted(bool success);
    void orderPlaced(bool success, int orderId);
    void databaseError(QString errorMessage);
};

#endif // DATABASEMANAGER_H