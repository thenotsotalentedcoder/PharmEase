#ifndef SUPPLIER_H
#define SUPPLIER_H
#include <QString>

class DatabaseManager;  // Forward declaration

class Supplier
{
private:
    int supplier_id;               // Unique supplier ID
    QString name;                  // Supplier's name
    QString contact_no;            // Supplier's contact number
    QString medicine_supplied;     // Medicine supplied by the supplier

    DatabaseManager* db;           // Pointer to interact with the database

public:
    Supplier(DatabaseManager* dbManager, int id, const QString& name, const QString& contact, const QString& medicine);
    Supplier(DatabaseManager* dbManager); // Default constructor

    bool addSupplier();  // Add supplier to the database
    bool updateSupplier();  // Update supplier details
    bool removeSupplier();  // Remove supplier from the database
    int getSupplierID() const;
    QString getName() const;
    QString getContactNo() const;
    QString getMedicineSupplied() const;
    void displaySupplierInfo();  // Display supplier information
};

#endif // SUPPLIER_H
