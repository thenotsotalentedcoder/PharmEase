#ifndef CUSTOMER_H
#define CUSTOMER_H
#include <QString>

class DatabaseManager;  // Forward declaration

class Customer {
private:
    DatabaseManager* db; // Pointer to interact with the database
    int customer_id;  // Unique customer ID
    QString name;  // Customer's name
    QString contact_no;  // Customer's contact number

public:
    Customer(DatabaseManager* dbManager, int id, const QString &name, const QString &contact);
    Customer(DatabaseManager* dbManager); // Default constructor

    bool addCustomer();  // Add customer to the database
    bool updateCustomer();  // Update customer details in the database
    bool removeCustomer();  // Remove customer from the database
    int getId() const;
    QString getName() const;
    QString getContactNo() const;
};

#endif // CUSTOMER_H
