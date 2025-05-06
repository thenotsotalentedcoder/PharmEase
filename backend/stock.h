#ifndef STOCK_H
#define STOCK_H

#include <QString>
#include <QList>

// Forward declaration
class DatabaseManager;

class Stock {
private:
    DatabaseManager* db;  // Pointer to interact with the database

public:
    // Constructor
    Stock(DatabaseManager* dbManager);

    // Stock Management
    bool addStock(int medID, int quantity);
    bool removeExpiredMeds();

    // Stock Queries
    bool checkStock(int medID);
    int checkStockByMedicineID(int medID);
    int checkStockByStockID(int stockID);
    QList<int> getLowStockMedicines(int threshold);
};

#endif // STOCK_H