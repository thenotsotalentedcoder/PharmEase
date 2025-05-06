#include "customer.h"
#include "databasemanager.h"

Customer::Customer(DatabaseManager* dbManager, int id, const QString &name, const QString &contact)
    : db(dbManager), customer_id(id), name(name), contact_no(contact){}

Customer::Customer(DatabaseManager* dbManager) : db(dbManager), customer_id(0), name(""), contact_no("") {}

bool Customer::addCustomer() {
    return db->addCustomer(this);  // Pass the current instance to DatabaseManager
}

bool Customer::updateCustomer() {
    return db->updateCustomer(this);  // Pass the current instance to DatabaseManager
}

bool Customer::removeCustomer() {
    return db->removeCustomer(customer_id);  // Pass customer_id to DatabaseManager
}

int Customer::getId() const {
    return customer_id;
}

QString Customer::getName() const {
    return name;
}

QString Customer::getContactNo() const {
    return contact_no;
}
