#ifndef MEDICINE_H
#define MEDICINE_H

#include <QString>
#include "stock.h"

class Medicine {
private:
    int medicine_id;
    QString medicine_name;
    double price;
    QString supplier;
    QString expiryDate;
    Stock stock; // Composition: Each Medicine has a Stock object
    DatabaseManager* db;

public:
    // Constructor
    Medicine(DatabaseManager* dbManager,int id, const QString &name, const QString &supplier, double price, const QString &expiryDate);

    // Getters
    int getId();
    QString getName();
    double getPrice();
    QString getSupplier();
    QString getExpiryDate();
    int getStockQuantity();  // Fetch stock from Stock object
    bool addMedicine();

    // Setters
    void setPrice(double price);
    void setSupplier( QString &supplier);
    void setExpiryDate( QString &expiryDate);

    // Stock Management
    bool addStock(int quantity);
    bool removeStock(int quantity);
    bool isExpired();
};

#endif // MEDICINE_H
