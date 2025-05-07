#include "supplier.h"
#include "databasemanager.h"

Supplier::Supplier(DatabaseManager* dbManager, int id, const QString& name, const QString& contact, const QString& medicine)
    : db(dbManager), supplier_id(id), name(name), contact_no(contact), medicine_supplied(medicine) {}

Supplier::Supplier(DatabaseManager* dbManager) : db(dbManager), supplier_id(0), name(""), contact_no(""), medicine_supplied("") {}

bool Supplier::addSupplier() {
    return db->addSupplier(this);  // Pass the current instance to DatabaseManager
}

bool Supplier::updateSupplier() {
    return db->updateSupplier(this);  // Pass the current instance to DatabaseManager
}

bool Supplier::removeSupplier() {
    return db->removeSupplier(supplier_id);  // Pass supplier_id to DatabaseManager
}

int Supplier::getSupplierID() const {
    return supplier_id;
}

QString Supplier::getName() const {
    return name;
}

QString Supplier::getContactNo() const {
    return contact_no;
}

QString Supplier::getMedicineSupplied() const {
    return medicine_supplied;
}

void Supplier::displaySupplierInfo() {
    // You can implement this function to display supplier information as needed
    qDebug() << "Supplier ID:" << supplier_id;
    qDebug() << "Name:" << name;
    qDebug() << "Contact No:" << contact_no;
    qDebug() << "Medicine Supplied:" << medicine_supplied;
}
