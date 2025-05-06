#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

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
public:
    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager();

    // Customer Operations
    Q_INVOKABLE int addCustomer(QString name, QString contact);
    Q_INVOKABLE bool removeCustomer(int customer_id);
    // Q_INVOKABLE bool updateCustomer(int customer_id, const QString &name, const QString &contact);
    QString getCustomerName(int customer_id);

    // Medicine Operations
    Q_INVOKABLE bool addMedicine(const QString &name, const QString &supplier, double price, int stock, const QString &expiry_date);
    // Q_INVOKABLE bool removeMedicine(int medicine_id);
    // Q_INVOKABLE bool updateMedicine(int medicine_id, double price, int stock, const QString &expiry_date);
    QString getMedicineName(int medicineID);

    // Stock Operations
    bool addStock(int medicine_id, int quantity);
    bool updateStock(int medicine_id, int quantity);
    bool checkStock(int medicine_id);
    QList<int> getLowStockMedicines(int threshold);

    // Order & Order_Details Operations
    int createOrder( QString customer_name);
    bool addOrderDetails(int order_id, int medicine_id, int quantity, double price);
    bool removeOrderDetails(int ordered_item_id);
    bool finalizeOrder(int order_id);
    QSqlQuery getOrder(int order_id);

    // Sales Operations
    // Q_INVOKABLE bool addSale(int order_id, const QString &med_name, const QString &payment_method, double total_amount, const QString &date);
    QSqlQuery getSalesReport(const QString &start_date, const QString &end_date);

    // Prescription Operations
    bool addPrescription(const QString &doctor_name, const QString &customer_name, const QString &medicine_name, int dosage);
    QSqlQuery getPrescription(int prescription_id);

    // Staff Operations
    bool addStaff(const QString &name, const QString &role, double salary, const QString &contact_no);
    bool removeStaff(int employee_id);
    QSqlQuery getStaff(int employee_id);


    // Discount Operations
    bool addDiscount(const QString &applicable_medicine, double discount_percentage);
    QSqlQuery getDiscount(int discount_id);
    bool removeDiscount(int discountID);
    double getDiscount(const QString& medName);
    bool addCustomer(Customer* customer);
    bool updateCustomer(Customer* customer);
    bool addSupplier(Supplier* supplier);
    bool updateSupplier(Supplier* supplier);
    bool removeSupplier(int supplierID);

    // Medicine-related functions
    int insertMedicine(const QString& name, const QString& supplier, double price, const QString& expiry_date);
    bool removeMeds(int medicineID);
    bool checkStockByMedicineID(int medicineID);
    bool checkStockByStockID(int stockID);
    bool removeStock(int medID, int quantity);
    bool isStockAvailable(int medicineID, int requiredQty);


    bool checkMedicineByStockID(int stockID);  // Declare function
    bool checkMedicineByMedicineID(int medicineID);

    bool removeOrderedMeds(int medID, int quantity);
    void displayMedicineInfo();
    int startOrder(QString customerName);
    bool placeOrder(QString medicineName, int requiredQuantity);
    bool confirmOrder(int order_id); //  order confirmation

    // Stock-related functions
    bool removeExpiredMeds();
    void displayStockInfo();
    bool addMeds(int orderID, int medID, int quantity, double price);

    // Order-related functions
    int getMedicineIDByName(QString medName);
    bool addOrder(int orderID, const QString& customerName, const QString& orderDate, const QString& status);
    bool addMedicineToOrder(int orderID, int medID, int quantity, double price);
    bool removeOrderedItem(int orderID);
    void displayOrderInfo(int orderID);
    bool updateOrderStatus(int orderID, const QString& status);
    int getAvailableStock(int medicineID);
    double getPriceOfMedicine(int medicineID);

    //billing and invoice generation
    double calculateSubtotal(int orderID);
    double applyDiscount(double subtotal, double discountPercentage);
    int displayReceipt(int orderID, double discountPercent);
    bool finalizeSale(int orderID, const QString& paymentMethod, double totalAmount);

    //sales report functions
    Q_INVOKABLE double getTotalSales();
    QString getMUPM();
    QPair<QString, double> getBestSellingItem();
    double getHighestSale();
    int getTotalTransactions();
    double getAverageSale();
    QVector<QPair<QString,double>> getDailySales();

    Q_INVOKABLE bool verifyEmployeeLogin(const QString& username, const QString& password);
    Q_INVOKABLE bool verifyAdminLogin(const QString& password);

    Q_INVOKABLE QVariantList getAllEmployeesList();
    Q_INVOKABLE bool addEmployee(const QString &name, const QString &role, const QString &salary, const QString &contact);
    Q_INVOKABLE bool updateEmployee(const int employeeId, const QString &name, const QString &role, const QString &salary, const QString &contact);
    Q_INVOKABLE bool deleteEmployee(const int employeeId);


    void getStockInfo();
    void searchMedicine(const QString &searchText);
    void searchSupplier(const QString &searchText);
    bool addStockInfo(int medicineId, const QString &name, const QString &supplier,
                      double price, const QString &expiryDate, int quantity);
    bool updateStock(int medicineId, const QString &name, const QString &supplier,
                     double price, const QString &expiryDate, int quantity);
    bool deleteStock(int medicineId);

    // Add in signals:
    signals:
    void stockDataLoaded(QVariantList stockData);
    void stockAdded(bool success);
    void stockUpdated(bool success);
    void stockDeleted(bool success);
};


#endif // DATABASEMANAGER_H

