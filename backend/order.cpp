#include "order.h"
#include <iostream>

// Constructor Implementations
Order::Order(DatabaseManager* dbManager, int orderID, const QString& customerName, const QString& orderDate, const QString& status)
    : order_id(orderID), customer_name(customerName), order_date(orderDate), order_status(status), db(dbManager) {}

Order::Order(DatabaseManager* dbManager) : db(dbManager), order_id(-1), order_status("Pending") {}


// Getters
int Order::getOrderID() const { return order_id; }
QString Order::getCustomerName() const { return customer_name; }
QString Order::getOrderDate() const { return order_date; }
QString Order::getOrderStatus() const { return order_status; }
std::map<int, std::pair<int, double>> Order::getOrderDetails() const { return order_details; }


// Create a new order
int Order::createOrder( QString customer_name) {
    return db ? db->createOrder(customer_name) : -1;
}


bool Order::addMedicine(int orderID, int medID, int quantity) {
    if (!db) return false;  // Ensure DatabaseManager exists

    double price = db->getPriceOfMedicine(medID);  // Fetch price from database
    if (price > 0) {
        return db->addMeds(orderID, medID, quantity, price);  // Call db function
    }

    return false;  // Medicine not found or has invalid price
}

// Remove medicine from the order
bool Order::removeMedicine(int order_id, int medID) {
    if (order_details.find(medID) != order_details.end()) {
        order_details.erase(medID);
        return db->removeMeds(medID);
    }
    return false;
}


// Calculate total cost
double Order::calculateTotal(int order_id) {
    double total = 0.0;
    for (const auto& item : order_details) {
        total += item.second.first * item.second.second;
    }
    return total;
}



//defintions of wrapper functions
bool Order:: addOrder(){
    return db->addOrder(order_id, customer_name, order_date, order_status);
}
void Order:: displayOrderInfo(int orderID){
    db->displayOrderInfo(orderID);
}


bool Order:: placeOrder(int orderID){
    if (order_details.empty()) {
        qDebug() << "No medicines added to the order!";
        return false;
    }
    //update the order status marking it as 'Placed')
    if (db->updateOrderStatus(orderID, "Placed")) {
        qDebug() << "Order status updated to 'Placed'.";
    } else {
        qDebug() << "Failed to update order status.";
        return false;
    }
    // Insert all medicines in the order into the order_details table
    for (const auto& orderItem : order_details) {
        int medID = orderItem.first;
        int quantity = orderItem.second.first;
        double price = orderItem.second.second;

        // Insert this order details into the database
        if (!db->addMedicineToOrder(orderID, medID, quantity, price)) {
            qDebug() << "Failed to add medicine to order.";
            return false;
        }
    }
    //Update the stock quantities after placing the order
    for (const auto& orderItem : order_details) {
        int medID = orderItem.first;
        int quantity = orderItem.second.first;

        // Decrease stock quantity in the database
        if (!db->removeOrderedMeds(medID, quantity)) {
            qDebug() << "Failed to update stock for medicine ID" << medID;
            return false;
        }
    }

    qDebug() << "Order placed successfully!";
    return true;
}
