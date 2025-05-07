#include "DatabaseManager.h"
#include "qdebug.h"
#include "qlogging.h"
#include "supplier.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QVariant>
#include <QDate>

#include <QFile>          // For file operations
#include <QTextStream>    // For writing to files
#include <QIODevice>      // For file open modes
#include <QDebug>         // For debug output
#include <QVariant>


DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent) {
    QString connectionName = "pharmacy_connection";

    if (QSqlDatabase::contains(connectionName)) {
        db = QSqlDatabase::database(connectionName);
    } else {
        db = QSqlDatabase::addDatabase("QSQLITE", connectionName);
        db.setDatabaseName("C:\\Users\\Admin\\OneDrive\\Documents\\Pharmease_app\\data\\PHARMACY.db");
    }

    if (!db.open()) {
        qDebug() << "Database Connection Failed:" << db.lastError().text();
    } else {
        qDebug() << "Database Connected Successfully!";
    }
}

DatabaseManager::~DatabaseManager() {
    if (db.isOpen()) {
        db.close();
    }
}

// =============== SALES REPORT FUNCTIONS ======================

// Function definition for getting total sales revenue
double DatabaseManager::getTotalSales(){
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");

    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return 0.0;
        }
    }
    QSqlQuery query(db);
    query.prepare("SELECT SUM(total_amount) FROM Sales");
    if (query.exec() && query.next()) {
        return query.value(0).toDouble();
    }
    return 0.0;
}

//Function to get most used payment method
QString DatabaseManager::getMUPM(){
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");

    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return "database error!!";
        }
    }
    QSqlQuery MUPM(db);
    MUPM.prepare("SELECT payment_method, COUNT(payment_method) as count FROM Sales "
                 "GROUP BY payment_method ORDER BY count DESC LIMIT 1");
    if(MUPM.exec() && MUPM.next()){
        return MUPM.value(0).toString();
    }
    else
        return "UNKNOWN";
}

QPair<QString, double> DatabaseManager::getBestSellingItem(){
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");

    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return (QPair<QString, double> ("Database error", 0.0));
        }
    }
    QSqlQuery bestSelling(db);
    bestSelling.prepare("SELECT med_name , COUNT(med_name) as count FROM Sales "
                        "GROUP BY med_name ORDER BY count DESC LIMIT 1");
    if(bestSelling.exec() && bestSelling.next()){
        return QPair <QString,double> (bestSelling.value(0).toString(), bestSelling.value(1).toDouble());
    }
    else
        return QPair<QString,double>("UNKNOWN",0.0);
}

double DatabaseManager::getHighestSale(){
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");

    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return 0.0;
        }
    }
    QSqlQuery HighestSale(db);
    HighestSale.prepare("SELECT MAX(total_amount) FROM Sales");
    if(HighestSale.exec() && HighestSale.next()){
        return HighestSale.value(0).toDouble();
    }
    else
        return 0.0;
}

int DatabaseManager::getTotalTransactions(){
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");

    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return 0;
        }
    }
    QSqlQuery totalTransactions(db);
    totalTransactions.prepare("SELECT COUNT(order_id) FROM Sales");
    if (totalTransactions.exec() && totalTransactions.next()){
        return totalTransactions.value(0).toInt();
    }
    else
        return 0;

}

double DatabaseManager::getAverageSale(){
    int total_sales = getTotalSales();
    int total_transactions = getTotalTransactions();
    return (total_transactions>0)? total_sales/total_transactions: 0.0;
}

QVector<QPair<QString,double>> DatabaseManager::getDailySales(){
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");

    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            QVector<QPair<QString, double>> errorData;
            errorData.append(qMakePair(QString("Database error"), 0.0));
            return errorData;
        }
    }
    QVector<QPair<QString,double>> SalesData;
    QSqlQuery data;
    data.prepare("SELECT date, SUM(total_amount) FROM Sales GROUP BY date ORDER BY date");

    if(data.exec()){
        while(data.next()){
            QString date = data.value(0).toString();
            double sales = data.value(1).toDouble();
            SalesData.append(qMakePair(date,sales));
        }
    }
    return SalesData;
}

// Customer Operations
int DatabaseManager::addCustomer( QString name, QString contact) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return 0;
        }
    }
    QSqlQuery query(db);
    query.prepare("INSERT INTO Customers (name, contact_no) VALUES (?, ?)");
    query.addBindValue(name);
    query.addBindValue(contact);
    if(!query.exec()){
        qDebug() << "Failed to add customer:" << query.lastError().text();
        return -1;
    }
    int inserted_id = query.lastInsertId().toInt();
    return inserted_id;
}


// Order Operations
int DatabaseManager::createOrder(QString customer_name) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return 0;
        }
    }
    QSqlQuery query(db);
    query.prepare("INSERT INTO Orders (customer_name, order_date, order_status) VALUES (?, DATE('now'), 'Pending')");
    query.addBindValue(customer_name);
    if (query.exec()) {
        return query.lastInsertId().toInt();
    }
    else
        return -3;
}

bool DatabaseManager::addOrderDetails(int order_id, int medicine_id, int quantity, double price) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("INSERT INTO order_details (order_id, medicine_id, quantity, price) VALUES (?, ?, ?, ?)");
    query.addBindValue(order_id);
    query.addBindValue(medicine_id);
    query.addBindValue(quantity);
    query.addBindValue(price);
    return query.exec();
}

bool DatabaseManager::finalizeOrder(int order_id) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("UPDATE Orders SET order_status = 'Completed' WHERE order_id = ?");
    query.addBindValue(order_id);
    return query.exec();
}


// For Discount
bool DatabaseManager::addDiscount(const QString& medName, double percentage) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("INSERT INTO discount (applicable_medicine, discount_percentage) VALUES (?, ?)");
    query.addBindValue(medName);
    query.addBindValue(percentage);
    return query.exec();
}

bool DatabaseManager::removeDiscount(int discountID) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("DELETE FROM discount WHERE discount_id = ?");
    query.addBindValue(discountID);
    return query.exec();
}

double DatabaseManager::getDiscount(const QString& medName) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return 0.0;
        }
    }
    QSqlQuery query(db);
    query.prepare("SELECT discount_percentage FROM discount WHERE applicable_medicine = ?");
    query.addBindValue(medName);
    if (query.exec() && query.next()) {
        return query.value(0).toDouble();
    }
    return 0.0;  // Return 0 if no discount found
}


// For Customer
bool DatabaseManager::addCustomer(Customer* customer) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("INSERT INTO Customers (name, contact_no) VALUES (?, ?)");
    query.addBindValue(customer->getName());
    query.addBindValue(customer->getContactNo());

    return query.exec();
}

bool DatabaseManager::updateCustomer(Customer* customer) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("UPDATE customer SET name = ?, contact_no = ? WHERE customer_id = ?");
    query.addBindValue(customer->getName());
    query.addBindValue(customer->getContactNo());
    query.addBindValue(customer->getId());
    return query.exec();
}

bool DatabaseManager::removeCustomer(int customerID) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("DELETE FROM customer WHERE customer_id = ?");
    query.addBindValue(customerID);
    return query.exec();
}

// For Supplier
bool DatabaseManager::addSupplier(Supplier* supplier) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("INSERT INTO supplier (name, contact_no, medicine_supplied) VALUES (?, ?, ?)");
    query.addBindValue(supplier->getName());
    query.addBindValue(supplier->getContactNo());
    query.addBindValue(supplier->getMedicineSupplied());
    return query.exec();
}

bool DatabaseManager::updateSupplier(Supplier* supplier) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("UPDATE supplier SET name = ?, contact_no = ?, medicine_supplied = ? WHERE supplier_id = ?");
    query.addBindValue(supplier->getName());
    query.addBindValue(supplier->getContactNo());
    query.addBindValue(supplier->getMedicineSupplied());
    query.addBindValue(supplier->getSupplierID());
    return query.exec();
}

bool DatabaseManager::removeSupplier(int supplierID) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("DELETE FROM supplier WHERE supplier_id = ?");
    query.addBindValue(supplierID);
    return query.exec();
}


//Add a new medicine to the database
bool DatabaseManager::addMedicine(const QString &name, const QString &supplier, double price, int stock, const QString &expiry_date) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("INSERT INTO medicine (name, supplier, price, stock, expiry_date) VALUES (?, ?, ?, ?, ?)");
    query.addBindValue(name);
    query.addBindValue(supplier);
    query.addBindValue(price);
    query.addBindValue(stock);
    query.addBindValue(expiry_date);

    if (query.exec()) {
        qDebug() << "Medicine added successfully!";
        return true;
    } else {
        qDebug() << "Error adding medicine:" << query.lastError().text();
        return false;
    }
}

// Remove a medicine by its ID
bool DatabaseManager::removeMeds(int medicineID) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("DELETE FROM medicine WHERE medicine_id = ?");
    query.addBindValue(medicineID);

    if (query.exec()) {
        qDebug() << "Medicine removed successfully!";
        return true;
    } else {
        qDebug() << "Error removing medicine:" << query.lastError().text();
        return false;
    }
}

// Check if a medicine exists by stock ID
bool DatabaseManager::checkMedicineByStockID(int stockID) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("SELECT * FROM stock WHERE stock_id = ?");
    query.addBindValue(stockID);
    query.exec();

    return query.next(); // Returns true if medicine exists
}

// Check if a medicine exists by medicine ID
bool DatabaseManager::checkMedicineByMedicineID(int medicineID) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("SELECT * FROM medicine WHERE medicine_id = ?");
    query.addBindValue(medicineID);
    query.exec();

    return query.next(); // Returns true if medicine exists
}


// ==================== STOCK FUNCTIONS ====================

// Add stock to an existing medicine
bool DatabaseManager::addStock(int medicineID, int quantity) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("INSERT INTO Stock (medicine_id, quantity, last_updation_date) VALUES (?, ?, ?)");
    query.addBindValue(medicineID);
    query.addBindValue(quantity);
    query.addBindValue(QDate::currentDate().toString("yyyy-MM-dd"));

    if (!query.exec()) {
        qDebug() << "Failed to add stock:" << query.lastError().text();
        return false;
    }
    return true;
}

// Remove expired medicines
bool DatabaseManager::removeExpiredMeds() {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("DELETE FROM medicine WHERE expiry_date < DATE('now')");

    if (query.exec()) {
        qDebug() << "Expired medicines removed!";
        return true;
    } else {
        qDebug() << "Error removing expired medicines:" << query.lastError().text();
        return false;
    }
}

// Display stock information
void DatabaseManager::displayStockInfo() {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return;
        }
    }
    QSqlQuery query(db);
    query.prepare("SELECT * FROM stock");

    while (query.next()) {
        qDebug() << "Stock ID:" << query.value(0).toInt()
        << "Medicine ID:" << query.value(1).toInt()
        << "Quantity:" << query.value(2).toInt()
        << "Last Updated:" << query.value(3).toString();
    }
}

// Check if a medicine is in stock
bool DatabaseManager::checkStock(int medicineID) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("SELECT quantity FROM stock WHERE medicine_id = ?");
    query.addBindValue(medicineID);
    query.exec();

    if (query.next() && query.value(0).toInt() > 0) {
        return true;
    } else {
        return false;
    }
}

// ==================== ORDER FUNCTIONS ====================

// Add an ordered medicine to order_details
bool DatabaseManager::addOrder(int orderID, const QString& customerName, const QString& orderDate, const QString& status) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("INSERT INTO Orders (order_id, customer_name, order_date, order_status) VALUES (?, ?, ?, ?)");
    query.addBindValue(orderID);
    query.addBindValue(customerName);
    query.addBindValue(orderDate);
    query.addBindValue(status);
    return query.exec();
}

bool DatabaseManager::addMedicineToOrder(int orderID, int medID, int quantity, double price) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("INSERT INTO OrderDetails (order_id, medicine_id, quantity, price) VALUES (?, ?, ?, ?)");
    query.addBindValue(orderID);
    query.addBindValue(medID);
    query.addBindValue(quantity);
    query.addBindValue(price);
    return query.exec();
}
// Remove ordered medicines by order ID
bool DatabaseManager::removeOrderedItem(int orderID) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("DELETE FROM OrderDetails WHERE order_id = ?");
    query.addBindValue(orderID);

    return query.exec();
}


void DatabaseManager::displayOrderInfo(int orderID) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return;
        }
    }
    QSqlQuery query(db);
    query.prepare("SELECT o.order_id, o.customer_name, o.order_date, o.order_status, "
                  "od.medicine_id, od.quantity, od.price "
                  "FROM Orders o "
                  "JOIN OrderDetails od ON o.order_id = od.order_id "
                  "WHERE o.order_id = ?");
    query.addBindValue(orderID);
    query.exec();
    if (!query.exec()) {
        qDebug() << "Failed to fetch order info:" << query.lastError().text();
        return;
    }
    if (query.next()) {
        qDebug() << "Order ID:" << query.value(0).toInt();
        qDebug() << "Customer Name:" << query.value(1).toString();
        qDebug() << "Order Date:" << query.value(2).toString();
        qDebug() << "Order Status:" << query.value(3).toString();

        do {
            int medID = query.value(4).toInt();
            int quantity = query.value(5).toInt();
            double price = query.value(6).toDouble();

            QString medName = getMedicineName(medID);
            qDebug() << "Medicine Name:" << medName
                     << ", Quantity:" << quantity
                     << ", Price per Unit:" << price
                     << ", Total Price:" << quantity * price;
        } while (query.next());
    } else {
        qDebug() << "Order not found!";
    }
}


// Get stock information using medicine ID
bool DatabaseManager::checkStockByMedicineID(int medicineID) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("SELECT * FROM stock WHERE medicine_id = ?");
    query.addBindValue(medicineID);
    query.exec();

    return query.next(); // Returns true if stock exists
}

// Get stock information using stock ID
bool DatabaseManager::checkStockByStockID(int stockID) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("SELECT * FROM stock WHERE stock_id = ?");
    query.addBindValue(stockID);
    query.exec();

    return query.next(); // Returns true if stock exists
}

// Get a list of medicines with low stock (below the given threshold)
QList<int> DatabaseManager::getLowStockMedicines(int threshold) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return QList<int>();
        }
    }
    QList<int> lowStockList;
    QSqlQuery query(db);
    query.prepare("SELECT medicine_id FROM stock WHERE quantity < ?");
    query.addBindValue(threshold);
    query.exec();

    while (query.next()) {
        lowStockList.append(query.value(0).toInt());
    }
    return lowStockList;
}

// Adds medicine to the order_details table
bool DatabaseManager::addMeds(int orderID, int medID, int quantity, double price) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("INSERT INTO order_details (order_id, medicine_id, quantity, price) VALUES (:orderID, :medID, :quantity, :price)");
    query.bindValue(":orderID", orderID);
    query.bindValue(":medID", medID);
    query.bindValue(":quantity", quantity);
    query.bindValue(":price", price);

    if (query.exec()) {
        qDebug() << "Medicine added to order successfully!";
        return true;
    } else {
        qDebug() << "Failed to add medicine to order: " << query.lastError().text();
        return false;
    }
}


QString DatabaseManager::getMedicineName(int medicineID) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return "DATABASE ERROR";
        }
    }
    QSqlQuery query(db);
    query.prepare("SELECT name FROM medicine WHERE medicine_id = ?");
    query.addBindValue(medicineID);
    query.exec();

    if (query.next()) {
        return query.value(0).toString();  // Return the medicine name
    }

    return "";  // If no medicine is found, return an empty string
}


bool DatabaseManager:: updateOrderStatus(int orderID, const QString& status){
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("UPDATE Orders SET order_status = ? WHERE order_id = ?");
    query.addBindValue(status);
    query.addBindValue(orderID);

    if (query.exec()) {
        return true;
    } else {
        qDebug() << "Error updating order status:" << query.lastError().text();
        return false;
    }
}

// Update stock quantity after the order is placed
bool DatabaseManager::removeOrderedMeds(int medID, int quantity){
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("UPDATE stock SET quantity = quantity - ? WHERE medicine_id = ?");
    query.addBindValue(quantity);
    query.addBindValue(medID);

    if (query.exec()) {
        return true;
    } else {
        qDebug() << "Error updating stock:" << query.lastError().text();
        return false;
    }
}

int DatabaseManager::insertMedicine(const QString& name, const QString& supplier, double price, const QString& expiry_date) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("INSERT INTO Medicine (name, supplier, price, expiry_date) VALUES (?, ?, ?, ?)");
    query.addBindValue(name);
    query.addBindValue(supplier);
    query.addBindValue(price);
    query.addBindValue(expiry_date);

    if (!query.exec()) {
        qDebug() << "Failed to insert medicine:" << query.lastError().text();
        return -1;
    }

    int inserted_id = query.lastInsertId().toInt();  // get the generated medicine_id
    return inserted_id;
}

int DatabaseManager::getMedicineIDByName(QString medName) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return 0;
        }
    }
    QSqlQuery query(db);
    query.prepare("SELECT medicine_id FROM Medicine WHERE name = ?");
    query.addBindValue(medName);
    if (query.exec() && query.next()) {
        return query.value(0).toInt();
    }
    return -1; // not found
}

int DatabaseManager::getAvailableStock(int medicineID) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return 0;
        }
    }
    QSqlQuery query(db);
    query.prepare("SELECT quantity FROM Stock WHERE medicine_id = ?");
    query.addBindValue(medicineID);
    if (query.exec() && query.next()) {
        return query.value(0).toInt();
    }
    return 0;
}

double DatabaseManager::getPriceOfMedicine(int medicineID) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return 0.0;
        }
    }
    QSqlQuery query(db);
    query.prepare("SELECT price FROM medicine WHERE medicine_id = ?");
    query.addBindValue(medicineID);
    if (query.exec() && query.next()) {
        return query.value(0).toDouble();
    }
    return 0.0;
}


QString DatabaseManager:: getCustomerName(int customer_id){
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return "DATABASE ERROR";
        }
    }
    QSqlQuery name(db);
    name.prepare("SELECT name FROM Customer WHERE customer_id = ?");
    name.addBindValue(customer_id);
    if(name.exec() && name.next()){
        return name.value(0).toString();
    }
    return "NOT FOUND";
}


int DatabaseManager::startOrder(QString customerName) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return 0;
        }
    }
    QSqlQuery query(db);

    query.prepare("INSERT INTO Orders (customer_name, order_date, order_status) VALUES (?, ?, ?)");
    query.addBindValue(customerName);
    query.addBindValue(QDate::currentDate().toString("yyyy-MM-dd"));
    query.addBindValue("Pending");

    if (!query.exec()) {
        qDebug() << "Failed to start order becuase:" << query.lastError().text();
        return -1;
    }
    return query.lastInsertId().toInt();
}

bool DatabaseManager::isStockAvailable(int medicineID, int requiredQty) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("SELECT quantity FROM Stock WHERE medicine_id = ?");
    query.addBindValue(medicineID);
    if (query.exec() && query.next()) {
        int available = query.value(0).toInt();
        return available >= requiredQty;
    }
    return false;
}


bool DatabaseManager::placeOrder(QString medicineName, int requiredQuantity) {
    int medicineID = getMedicineIDByName(medicineName);

    if (medicineID == -1) {
        qDebug() << "Medicine not found:" << medicineName;
        return false;
    }

    if (!isStockAvailable(medicineID, requiredQuantity)) {
        qDebug() << "Not enough stock for medicine:" << medicineName << ". Available:" << getAvailableStock(medicineID);
        return false;
    }

    double pricePerUnit = getPriceOfMedicine(medicineID);
    if (pricePerUnit <= 0) {
        qDebug() << "Invalid price for medicine:" << medicineName;
        return false;
    }

    // Get the most recent order_id
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery orderQuery(db);
    orderQuery.prepare("SELECT MAX(order_id) FROM Orders");
    if (!orderQuery.exec() || !orderQuery.next()) {
        qDebug() << "Failed to retrieve latest order ID.";
        return false;
    }

    int orderID = orderQuery.value(0).toInt();
    if (orderID <= 0) {
        qDebug() << "No order found. Create an order before taking medicines.";
        return false;
    }

    // Insert medicine directly into OrderDetails table
    QSqlQuery insertQuery(db);
    insertQuery.prepare("INSERT INTO OrderDetails (order_id, medicine_id, quantity, price) VALUES (?, ?, ?, ?)");

    insertQuery.addBindValue(orderID);
    insertQuery.addBindValue(medicineID);
    insertQuery.addBindValue(requiredQuantity);
    insertQuery.addBindValue(pricePerUnit);

    if (!insertQuery.exec()) {
        qDebug() << "Failed to add medicine to OrderDetails for order ID:" << orderID;
        return false;
    }

    // Optionally update the stock
    removeOrderedMeds(medicineID, requiredQuantity);

    qDebug() << "Medicine" << medicineName << "added to Order ID" << orderID << "successfully.";
    return true;
    // Add medicine to order

    qDebug() << "Medicine" << medicineName << "added to Order ID" << orderID << "successfully.";
    return true;
}

bool DatabaseManager::confirmOrder(int orderID) {
    // Check if the order exists and is valid
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery checkOrderQuery(db);
    checkOrderQuery.prepare("SELECT COUNT(*) FROM OrderDetails WHERE order_id = ?");
    checkOrderQuery.addBindValue(orderID);

    if (!checkOrderQuery.exec() || !checkOrderQuery.next()) {
        qDebug() << "Failed to check order details for order ID:" << orderID;
        return false;
    }

    int itemCount = checkOrderQuery.value(0).toInt();
    if (itemCount == 0) {
        qDebug() << "No items in the order. Please add medicines before confirming the order.";
        return false;
    }

    qDebug() << "Order ID" << orderID << "contains" << itemCount << "item(s). Order successfully confirmed. You can now proceed to billing.";
    return true;
}


int DatabaseManager::displayReceipt(int orderID, double discountPercent) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("SELECT od.medicine_id, od.quantity, od.price, o.customer_name, o.order_date "
                  "FROM OrderDetails od "
                  "JOIN Orders o ON od.order_id = o.order_id "
                  "WHERE od.order_id = ?");
    query.addBindValue(orderID);

    if (!query.exec()) {
        qDebug() << "Failed to retrieve order details.";
        return false;
    }

    QString customerName, orderDate;
    double subtotal = 0.0;
    bool headerPrinted = false;

    while (query.next()) {
        int medicineID = query.value(0).toInt();
        int quantity = query.value(1).toInt();
        double price = query.value(2).toDouble();
        QString medicineName = getMedicineName(medicineID);
        double total = price * quantity;

        if (!headerPrinted) {
            customerName = query.value(3).toString();
            orderDate = query.value(4).toString();
            qDebug() << "Customer:" << customerName;
            qDebug() << "Date:" << orderDate;
            qDebug() << "--------------------------";
            headerPrinted = true;
        }

        subtotal += total;
        qDebug() << medicineName << "\tRs." << price << "x" << quantity << "\t= Rs." << total;
    }

    if (subtotal == 0.0) {
        qDebug() << "No items in the order.";
        return false;
    }

    double discountAmount = (discountPercent / 100.0) * subtotal;
    double totalPayable = subtotal - discountAmount;

    qDebug() << "--------------------------";
    qDebug() << "Subtotal:\tRs." << subtotal;
    qDebug() << "Discount (" << discountPercent << "%):\t- Rs." << discountAmount;
    qDebug() << "Total Payable:\tRs." << totalPayable;
    qDebug() << "--------------------------";

    return totalPayable;
}


double DatabaseManager::calculateSubtotal(int orderID) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return 0.0;
        }
    }
    QSqlQuery query(db);
    query.prepare("SELECT quantity, price FROM OrderDetails WHERE order_id = ?");
    query.addBindValue(orderID);

    double subtotal = 0;
    if (query.exec()) {
        while (query.next()) {
            int quantity = query.value(0).toInt();
            double price = query.value(1).toDouble();
            subtotal += quantity * price;
        }
    }
    return subtotal;
}

double DatabaseManager::applyDiscount(double subtotal, double discountPercentage) {
    return subtotal - ((discountPercentage / 100.0) * subtotal);
}


bool DatabaseManager::finalizeSale(int orderID, const QString& paymentMethod, double totalAmount) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery insert(db);
    insert.prepare("INSERT INTO Sales (order_id, med_name, payment_method, total_amount, date) "
                   "VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)");

    QStringList medNames;
    QSqlQuery medQuery(db);
    medQuery.prepare("SELECT medicine_id FROM OrderDetails WHERE order_id = ?");
    medQuery.addBindValue(orderID);

    if (medQuery.exec()) {
        while (medQuery.next()) {
            int medicineID = medQuery.value(0).toInt();
            QString medName = getMedicineName(medicineID);  // Use your function to fetch the name
            if (!medName.isEmpty()) {
                medNames << medName;  // Add to list if a valid name is returned
            }
        }
    }

    QString combinedMedNames = medNames.join(", ");

    insert.addBindValue(orderID);
    insert.addBindValue(combinedMedNames);
    insert.addBindValue(paymentMethod);
    insert.addBindValue(totalAmount);

    if (!insert.exec()) {
        qDebug() << "Failed to insert into Sales:" << insert.lastError();
        return false;
    }

    //Update the Orders table to mark the order as Completed
    QSqlQuery updateOrder(db);
    updateOrder.prepare("UPDATE Orders SET order_status = 'Completed' WHERE order_id = ?");
    updateOrder.addBindValue(orderID);
    if (!updateOrder.exec()) {
        qDebug() << "Failed to update order status:" << updateOrder.lastError();
        return false;
    }

    qDebug() << "Order ID" << orderID << "Successfully finalized in Sales and status updated to Completed!";
    return true;
}


bool DatabaseManager::verifyEmployeeLogin(const QString& username, const QString& password) {
    // Use the named connection to be consistent with your working functions
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");

    // Ensure the DB is open
    if (!db.isOpen()) {
        qDebug() << "Database is not open! Trying to reopen...";
        if (!db.open()) {
            qDebug() << "Failed to open database:" << db.lastError().text();
            return false;
        }
    }

    QSqlQuery query(db);
    query.prepare("SELECT COUNT(*) FROM employee WHERE username = ? AND password = ?");
    query.addBindValue(username);
    query.addBindValue(password);

    if (query.exec()) {
        if (query.next()) {
            int count = query.value(0).toInt();
            qDebug() << "Login attempt for user:" << username << "| Success:" << (count > 0);
            return count > 0;  // true = login success
        }
    } else {
        qDebug() << "Login query failed:" << query.lastError().text();
    }

    return false;  // login failed or query failed
}


bool DatabaseManager::verifyAdminLogin(const QString& password) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");

    if (!db.isOpen()) {
        qDebug() << "Admin login: Database not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Admin login failed to reopen database:" << db.lastError().text();
            return false;
        }
    }

    QSqlQuery query(db);
    query.prepare("SELECT COUNT(*) FROM Admin WHERE password = ?");
    query.addBindValue(password);

    if (query.exec() && query.next()) {
        int count = query.value(0).toInt();
        qDebug() << "Admin login attempt | Success:" << (count > 0);
        return count > 0;
    } else {
        qDebug() << "Admin login query failed:" << query.lastError().text();
    }

    return false;
}



QVariantList DatabaseManager::getAllEmployeesList() {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    QVariantList employeeList;
    if (!db.isOpen()) {
        qDebug() << "getAllEmployeesList: Database not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "getAllEmployeesList: Failed to reopen database:" << db.lastError().text();
            return employeeList;
        }
    }
    QSqlQuery query(db);
    query.prepare("SELECT employee_id, name, role, salary, contact_no FROM Staff");
    if (query.exec()) {
        while (query.next()) {
            QVariantMap employee;
            employee["employee_id"] = query.value("employee_id");
            employee["name"] = query.value("name");
            employee["role"] = query.value("role");
            employee["salary"] = query.value("salary");
            employee["contact_no"] = query.value("contact_no");
            employeeList.append(employee);
        }
        qDebug() << "getAllEmployeesList: Retrieved" << employeeList.size() << "records.";
    } else {
        qDebug() << "getAllEmployeesList: Query failed:" << query.lastError().text();
    }
    return employeeList;
}

bool DatabaseManager::addEmployee(const QString &name, const QString &role,
                                  const QString &salary, const QString &contact) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "addEmployee: Database not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "addEmployee: Failed to reopen database:" << db.lastError().text();
            return false;
        }
    }

    QSqlQuery query(db);
    query.prepare("INSERT INTO Staff (name, role, salary, contact_no) VALUES (?, ?, ?, ?)");
    query.addBindValue(name);
    query.addBindValue(role);
    query.addBindValue(salary);
    query.addBindValue(contact);

    if (query.exec()) {
        qDebug() << "addEmployee: Successfully added new employee.";
        return true;
    } else {
        qDebug() << "addEmployee: Failed to add employee:" << query.lastError().text();
        return false;
    }
}

bool DatabaseManager::updateEmployee(const int employeeId, const QString &name,
                                     const QString &role, const QString &salary,
                                     const QString &contact) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "updateEmployee: Database not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "updateEmployee: Failed to reopen database:" << db.lastError().text();
            return false;
        }
    }

    QSqlQuery query(db);
    query.prepare("UPDATE Staff SET name = ?, role = ?, salary = ?, contact_no = ? WHERE employee_id = ?");
    query.addBindValue(name);
    query.addBindValue(role);
    query.addBindValue(salary);
    query.addBindValue(contact);
    query.addBindValue(employeeId);

    if (query.exec()) {
        qDebug() << "updateEmployee: Successfully updated employee with ID" << employeeId;
        return true;
    } else {
        qDebug() << "updateEmployee: Failed to update employee:" << query.lastError().text();
        return false;
    }
}

bool DatabaseManager::deleteEmployee(const int employeeId) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "deleteEmployee: Database not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "deleteEmployee: Failed to reopen database:" << db.lastError().text();
            return false;
        }
    }

    QSqlQuery query(db);
    query.prepare("DELETE FROM Staff WHERE employee_id = ?");
    query.addBindValue(employeeId);

    if (query.exec()) {
        qDebug() << "deleteEmployee: Successfully deleted employee with ID" << employeeId;
        return true;
    } else {
        qDebug() << "deleteEmployee: Failed to delete employee:" << query.lastError().text();
        return false;
    }
}


QVariantList DatabaseManager::getStockInfo()
{
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    QVariantList stockList;
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return stockList;
        }
    }

    QSqlQuery query(db);
    query.prepare("SELECT medicine_id, name, supplier, price, expiry_date, quantity FROM Stock_info");

    if (query.exec()) {
        while (query.next()) {
            QVariantMap stockItem;
            stockItem["medicine_id"] = query.value(0).toInt();
            stockItem["name"] = query.value(1).toString();
            stockItem["supplier"] = query.value(2).toString();
            stockItem["price"] = query.value(3).toDouble();
            stockItem["expiry_date"] = query.value(4).toString();
            stockItem["quantity"] = query.value(5).toInt();
            stockItem["isEditable"] = false;  // default not editable
            stockList.append(stockItem);
        }
        qDebug() << "getStockInfoList: Retrieved" << stockList.size() << "records.";
    } else {
        qDebug() << "getStockinfoList: Query failed:" << query.lastError().text();
    }
    return stockList;

}


QVariantList DatabaseManager::searchMedicine(const QString &searchText)
{
    QVariantList stockList;
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return stockList;
        }
    }

    QSqlQuery query(db);
    // Using LIKE for partial matching
    query.prepare("SELECT medicine_id, name, supplier, price, expiry_date, quantity FROM Stock_info "
                  "WHERE name LIKE ?");
    query.addBindValue("%" + searchText + "%");

    if (!query.exec()) {
        qDebug() << "Error searching medicines:" << query.lastError().text();
        return stockList;
    }

    while (query.next()) {
        QVariantMap stockItem;
        stockItem["medicine_id"] = query.value(0).toInt();
        stockItem["name"] = query.value(1).toString();
        stockItem["supplier"] = query.value(2).toString();
        stockItem["price"] = query.value(3).toDouble();
        stockItem["expiry_date"] = query.value(4).toString();
        stockItem["quantity"] = query.value(5).toInt();
        stockItem["isEditable"] = false;
        stockList.append(stockItem);
    }

    return stockList;
}

QVariantList DatabaseManager::searchSupplier(const QString &searchText)
{
    QVariantList stockList;
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return stockList;
        }
    }

    QSqlQuery query(db);
    query.prepare("SELECT medicine_id, name, supplier, price, expiry_date, quantity FROM Stock_info "
                  "WHERE supplier LIKE ?");
    query.addBindValue("%" + searchText + "%");

    if (!query.exec()) {
        qDebug() << "Error searching suppliers:" << query.lastError().text();
        return stockList;
    }

    while (query.next()) {
        QVariantMap stockItem;
        stockItem["medicine_id"] = query.value(0).toInt();
        stockItem["name"] = query.value(1).toString();
        stockItem["supplier"] = query.value(2).toString();
        stockItem["price"] = query.value(3).toDouble();
        stockItem["expiry_date"] = query.value(4).toString();
        stockItem["quantity"] = query.value(5).toInt();
        stockItem["isEditable"] = false;
        stockList.append(stockItem);
    }

    return stockList;
}

bool DatabaseManager::addStockInfo( const QString &name, const QString &supplier, double price, const QString &expiry_date, int quantity)
{
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }

    QSqlQuery query(db);
    // If medicine_id is 0 or not provided, let the database auto-increment it
        query.prepare("INSERT INTO Stock_info (name, supplier, price, expiry_date, quantity) "
                      "VALUES (?, ?, ?, ?, ?)");
        query.addBindValue(name);
        query.addBindValue(supplier);
        query.addBindValue(price);
        query.addBindValue(expiry_date);
        query.addBindValue(quantity);

    bool success = query.exec();
    if (!success) {
        qDebug() << "Error adding stock:" << query.lastError().text();
        return false;
    } else {
        qDebug() << "addstockinfo: Successfully added new stock.";
        return true;
    }
}

bool DatabaseManager::updateStock(int medicineId, const QString &name, const QString &supplier, double price, const QString &expiryDate, int quantity)
{
     QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }

    QSqlQuery query(db);
    query.prepare("UPDATE Stock_info SET name = ?, supplier = ?, price = ?, "
                  "expiry_date = ?, quantity = ? WHERE medicine_id = ?");
    query.addBindValue(name);
    query.addBindValue(supplier);
    query.addBindValue(price);
    query.addBindValue(expiryDate);
    query.addBindValue(quantity);
    query.addBindValue(medicineId);

    bool success = query.exec();
    if (!success) {
        qDebug() << "Error updating stock:" << query.lastError().text();
        return false;
    } else {
        qDebug() << "updatestock: Successfully updated " << name;
        return true;
    }
}

bool DatabaseManager::deleteStock(int medicineId)
{
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }

    QSqlQuery query(db);
    query.prepare("DELETE FROM Stock_info WHERE medicine_id = ?");
    query.addBindValue(medicineId);

    bool success = query.exec();
    if (!success) {
        qDebug() << "Error deleting stock:" << query.lastError().text();
        return false;
    } else {
        qDebug() << "deletestock: Successfully deleted medicine with ID" << medicineId;
        return true;
    }

    return success;
}

// // Add these functions to your DatabaseManager class

// QVariantList DatabaseManager::getOrderSummary()
// {
//     QVariantList ordersSummary;

//     // Join Orders, OrderDetails, and Stock_info tables to get order summary
//     QSqlQuery query;
//     query.prepare(
//         "SELECT o.order_id, o.customer_name, o.order_date, o.order_status, o.payment_method, "
//         "GROUP_CONCAT(si.name, ', ') as medicines, "
//         "SUM(od.quantity) as total_quantity, "
//         "SUM(od.price * od.quantity) as total_amount "
//         "FROM Orders o "
//         "JOIN OrderDetails od ON o.order_id = od.order_id "
//         "JOIN Stock_info si ON od.medicine_id = si.medicine_id "
//         "GROUP BY o.order_id "
//         "ORDER BY o.order_id DESC"
//         );

//     if (query.exec()) {
//         while (query.next()) {
//             QVariantMap orderData;
//             orderData["orderID"] = query.value("order_id").toString();
//             orderData["customerName"] = query.value("customer_name").toString();
//             orderData["medicines"] = query.value("medicines").toString();
//             orderData["totalQuantity"] = query.value("total_quantity").toString();
//             orderData["paymentMethod"] = query.value("payment_method").toString();
//             orderData["totalAmount"] = query.value("total_amount").toString();
//             orderData["orderStatus"] = query.value("order_status").toString();
//             orderData["date"] = query.value("order_date").toString();

//             ordersSummary.append(orderData);
//         }
//     } else {
//         qDebug() << "Error fetching order summary:" << query.lastError().text();
//     }

//     return ordersSummary;
// }

// QVariantList DatabaseManager::getOrdersList()
// {
//     QVariantList ordersDetailList;

//     // Join Orders, OrderDetails, and Stock_info tables to get detailed order information
//     QSqlQuery query;
//     query.prepare(
//         "SELECT od.ordered_item_id, od.order_id, o.customer_name, o.order_date, "
//         "od.medicine_id, si.name as medicine_name, od.quantity, od.price, "
//         "o.payment_method "
//         "FROM OrderDetails od "
//         "JOIN Orders o ON od.order_id = o.order_id "
//         "JOIN Stock_info si ON od.medicine_id = si.medicine_id "
//         "ORDER BY od.order_id DESC, od.ordered_item_id"
//         );

//     if (query.exec()) {
//         while (query.next()) {
//             QVariantMap orderData;
//             orderData["itemID"] = query.value("ordered_item_id").toString();
//             orderData["orderID"] = query.value("order_id").toString();
//             orderData["medicineID"] = query.value("medicine_id").toString();
//             orderData["medicineName"] = query.value("medicine_name").toString();
//             orderData["customerName"] = query.value("customer_name").toString();
//             orderData["quantity"] = query.value("quantity").toString();
//             orderData["price"] = query.value("price").toString();
//             orderData["paymentMethod"] = query.value("payment_method").toString();
//             orderData["date"] = query.value("order_date").toString();

//             ordersDetailList.append(orderData);
//         }
//     } else {
//         qDebug() << "Error fetching orders details:" << query.lastError().text();
//     }

//     return ordersDetailList;
// }

// void DatabaseManager::fetchOrdersData()
// {
//     // This function will emit the signal with the detailed orders data
//     QVariantList detailedOrders = getOrdersList();
//     emit ordersDataChanged(detailedOrders);
// }

// Fixed version of the getInventory function
QVariantList DatabaseManager::getInventory()
{
    QVariantList stockList;

    // Make sure we have a valid connection
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isValid()) {
        qDebug() << "Invalid database connection";
        return stockList;
    }

    // Try to open the connection if it's not already open
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to open.";
        if (!db.open()) {
            qDebug() << "Failed to open database:" << db.lastError().text();
            return stockList;
        }
    }

    // Create and execute the query
    QSqlQuery query(db);

    // Check if the table exists
    query.exec("SELECT name FROM sqlite_master WHERE type='table' AND name='Stock_info'");
    if (!query.next()) {
        qDebug() << "Table 'Stock_info' does not exist!";
        return stockList;
    }

    // Execute the main query with proper error checking
    bool success = query.exec("SELECT medicine_id, name, supplier, price, expiry_date, quantity, contact_no FROM Stock_info");

    if (!success) {
        qDebug() << "Query failed:" << query.lastError().text();
        qDebug() << "SQL statement:" << query.lastQuery();
        return stockList;
    }

    // Process the results
    while (query.next()) {
        QVariantMap stockItem;
        stockItem["medicine_id"] = query.value(0).toInt();
        stockItem["name"] = query.value(1).toString();
        stockItem["supplier"] = query.value(2).toString();
        stockItem["price"] = query.value(3).toDouble();
        stockItem["expiry_date"] = query.value(4).toString();
        stockItem["quantity"] = query.value(5).toInt();
        stockItem["contact_no"] = query.value(6).toString(); // Changed to toString to prevent issues with large numbers
        stockItem["isEditable"] = false;  // default not editable
        stockList.append(stockItem);
    }

    qDebug() << "getInventory: Retrieved" << stockList.size() << "records.";

    return stockList;
}

QVariantList DatabaseManager::getOrders()
{
    QVariantList ordersList;
    // Make sure we have a valid connection
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isValid()) {
        qDebug() << "Invalid database connection";
        return ordersList;
    }

    // Try to open the connection if it's not already open
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to open.";
        if (!db.open()) {
            qDebug() << "Failed to open database:" << db.lastError().text();
            return ordersList;
        }
    }

    // Create and execute the query
    QSqlQuery query(db);
    // Check if the table exists
    query.exec("SELECT name FROM sqlite_master WHERE type='table' AND name='Orders'");
    if (!query.next()) {
        qDebug() << "Table 'Orders' does not exist!";
        return ordersList;
    }

    // Execute the main query with proper error checking
    // Assuming Orders table schema is something like:
    // orderID, customerID, customerName, customerContact, orderStatus, quantity, paymentMethod, totalAmount, date
    bool success = query.exec("SELECT order_id, customer_id, customer_name, contact_no, order_status, quantity, payment_method, total, order_date FROM Orders");
    if (!success) {
        qDebug() << "Query failed:" << query.lastError().text();
        qDebug() << "SQL statement:" << query.lastQuery();
        return ordersList;
    }

    // Process the results
    while (query.next()) {
        QVariantMap orderItem;
        orderItem["order_id"] = query.value(0).toString();
        orderItem["customer_id"] = query.value(1).toString();
        orderItem["customer_name"] = query.value(2).toString();
        orderItem["contact_no"] = query.value(3).toString();
        orderItem["order_status"] = query.value(4).toString();
        orderItem["quantity"] = query.value(5).toInt();
        orderItem["payment_method"] = query.value(6).toString();
        orderItem["total"] = query.value(7).toDouble();
        orderItem["order_date"] = query.value(8).toString();

        ordersList.append(orderItem);
    }

    qDebug() << "getOrders: Retrieved" << ordersList.size() << "records.";
    return ordersList;
}

QVariantList DatabaseManager::searchOrderById(const QString &orderId)
{
    QVariantList ordersList;
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");

    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return ordersList;
        }
    }

    QSqlQuery query(db);
    query.prepare("SELECT order_id, customer_id, customer_name, contact_no, order_status, quantity, payment_method, total, order_date FROM Orders WHERE order_id LIKE ?");
    query.addBindValue("%" + orderId + "%");

    if (!query.exec()) {
        qDebug() << "Error searching order by ID:" << query.lastError().text();
        return ordersList;
    }

    while (query.next()) {
        QVariantMap orderItem;
        orderItem["order_id"] = query.value(0).toString();
        orderItem["customer_id"] = query.value(1).toString();
        orderItem["customer_name"] = query.value(2).toString();
        orderItem["contact_no"] = query.value(3).toString();
        orderItem["order_status"] = query.value(4).toString();
        orderItem["quantity"] = query.value(5).toInt();
        orderItem["payment_method"] = query.value(6).toString();
        orderItem["total"] = query.value(7).toDouble();
        orderItem["order_date"] = query.value(8).toString();

        ordersList.append(orderItem);
    }

    return ordersList;
}

QVariantList DatabaseManager::searchOrderByCustomerId(const QString &customerId)
{
    QVariantList ordersList;
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");

    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return ordersList;
        }
    }

    QSqlQuery query(db);
    query.prepare("SELECT order_id, customer_id, customer_name, contact_no, order_status, quantity, payment_method, total, order_date FROM Orders WHERE customer_id LIKE ?");
    query.addBindValue("%" + customerId + "%");

    if (!query.exec()) {
        qDebug() << "Error searching order by customer ID:" << query.lastError().text();
        return ordersList;
    }

    while (query.next()) {
        QVariantMap orderItem;
        orderItem["order_id"] = query.value(0).toString();
        orderItem["customer_id"] = query.value(1).toString();
        orderItem["customer_name"] = query.value(2).toString();
        orderItem["contact_no"] = query.value(3).toString();
        orderItem["order_status"] = query.value(4).toString();
        orderItem["quantity"] = query.value(5).toInt();
        orderItem["payment_method"] = query.value(6).toString();
        orderItem["total"] = query.value(7).toDouble();
        orderItem["order_date"] = query.value(8).toString();

        ordersList.append(orderItem);
    }

    return ordersList;
}

QVariantList DatabaseManager::filterOrdersByPaymentMethod(const QString &paymentMethod)
{
    QVariantList ordersList;
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");

    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return ordersList;
        }
    }

    QSqlQuery query(db);
    query.prepare("SELECT order_id, customer_id, customer_name, contact_no, order_status, quantity, payment_method, total, order_date FROM Orders WHERE payment_method = ?");
    query.addBindValue(paymentMethod);

    if (!query.exec()) {
        qDebug() << "Error filtering orders by payment method:" << query.lastError().text();
        return ordersList;
    }

    while (query.next()) {
        QVariantMap orderItem;
        orderItem["order_id"] = query.value(0).toString();
        orderItem["customer_id"] = query.value(1).toString();
        orderItem["customer_name"] = query.value(2).toString();
        orderItem["contact_no"] = query.value(3).toString();
        orderItem["order_status"] = query.value(4).toString();
        orderItem["quantity"] = query.value(5).toInt();
        orderItem["payment_method"] = query.value(6).toString();
        orderItem["total"] = query.value(7).toDouble();
        orderItem["order_date"] = query.value(8).toString();

        ordersList.append(orderItem);
    }

    return ordersList;
}



