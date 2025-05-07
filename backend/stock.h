#ifndef STOCK_H
#define STOCK_H

#include <QString>
#include "databasemanager.h"

class Stock {
private:
    DatabaseManager* db;  // Pointer to interact with the database

public:
    // Constructor
    Stock(DatabaseManager* dbManager);

    // Stock Management
    bool addStock(int medID, int quantity);
    bool removeOrderedMeds(int medID, int quantity);
    bool removeExpiredMeds();

    // Stock Queries
    bool checkStock();
    int checkStockByMedicineID(int medID);
    int checkStockByStockID(int stockID);

    bool checkStock(int medID);
    QList<int> getLowStockMedicines(int threshold);
};

#endif // STOCK_H
