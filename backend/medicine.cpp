#include "medicine.h"

// Constructor with Stock initialization
Medicine::Medicine(DatabaseManager* dbManager, int id, const QString &name, const QString &supplier,double price, const QString &expiryDate)
    : medicine_id(id), medicine_name(name), price(price), supplier(supplier), expiryDate(expiryDate), stock(dbManager) , db(dbManager){}

// Getters
int Medicine::getId() { return medicine_id; }
QString Medicine::getName() { return medicine_name; }
double Medicine::getPrice() { return price; }
QString Medicine::getSupplier() { return supplier; }
QString Medicine::getExpiryDate() { return expiryDate; }
int Medicine::getStockQuantity() { return stock.checkStockByMedicineID(medicine_id); } // Fetch stock from Stock object

// Setters
void Medicine::setPrice(double newPrice) { price = newPrice; }
void Medicine::setSupplier( QString &newSupplier) { supplier = newSupplier; }
void Medicine::setExpiryDate( QString &newExpiryDate) { expiryDate = newExpiryDate; }

// Stock Management
bool Medicine::addStock(int quantity) {
    return stock.addStock(medicine_id, quantity);
}

bool Medicine::removeStock(int quantity) {
    return db->removeOrderedMeds(medicine_id, quantity);
}

// Check if the medicine is expired
bool Medicine::isExpired() {
    return stock.removeExpiredMeds(); // Handles removal of expired meds if needed
}


bool Medicine::addMedicine() {
    if (!db) {
        qDebug() << "DatabaseManager not initialized in Medicine.";
        return false;
    }

    int inserted = db->insertMedicine(medicine_name, supplier, price, expiryDate);
    if (inserted== -1) return false;

    // Initialize stock to 0 on creation
    return stock.addStock(inserted, 0);
}
