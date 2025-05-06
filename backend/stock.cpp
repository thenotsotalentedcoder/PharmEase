#include "stock.h"
#include "databasemanager.h"
#include <QDebug>
#include <QList>


// Constructor - Initializes the database pointer
Stock::Stock(DatabaseManager* dbManager) : db(dbManager) {}

// Calls the function to add stock
bool Stock::addStock(int medID, int qty) {
    return db->addStock(medID, qty);
}

// Calls the function to remove expired medicines
bool Stock::removeExpiredMeds() {
    return db->removeExpiredMeds();
}

// Calls the function to check stock
bool Stock::checkStock(int medID) {
    return db->checkStock(medID);
}

// Calls the function to check stock by medicine ID
int Stock::checkStockByMedicineID(int medID) {
    return db->checkStockByMedicineID(medID);
}

// Calls the function to check stock by stock ID
int Stock::checkStockByStockID(int stockID) {
    return db->checkStockByStockID(stockID);
}

// Calls the function to get medicines with low stock
QList<int> Stock::getLowStockMedicines(int quantity) {
    return db->getLowStockMedicines(quantity);
}
