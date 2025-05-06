#ifndef ORDER_H
#define ORDER_H

#include <vector>
#include <map>
#include <QString>
#include "databasemanager.h"
#include "customer.h"

class Order {
private:
    int order_id;
    QString customer_name;
    QString order_date;
    QString order_status;
    DatabaseManager* db;
    std::map<int, std::pair<int, double>> order_details; // medicine_id -> (quantity, price)

public:
    // Constructor
    Order(DatabaseManager* dbManager, int orderID, const QString& customerName, const QString& orderDate, const QString& status);
    Order(DatabaseManager* dbManager);

    // Order Management
    int createOrder(QString customer_name);
    bool addMedicine(int orderID, int medID, int quantity);
    bool removeMedicine(int order_id, int medID);
    double calculateTotal(int order_id);
    bool generateReceipt(int order_id);

    // Getters
    int getOrderID() const;
    QString getCustomerName() const;
    QString getOrderDate() const;
    QString getOrderStatus() const;
    std::map<int, std::pair<int, double>> getOrderDetails() const;

    //wrapper functions for database operations
    bool addOrder();
    void displayOrderInfo(int orderID);
    bool placeOrder(int OrderID);
};

#endif // ORDER_H

