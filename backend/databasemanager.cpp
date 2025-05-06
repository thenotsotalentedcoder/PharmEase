#include "DatabaseManager.h"
#include "qdebug.h"
#include "qlogging.h"
#include "supplier.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QVariant>
#include <QDate>
#include <QFile>
#include <QTextStream>
#include <QIODevice>
#include <QDebug>
#include <QVariant>
#include <QCoreApplication>
#include <QRandomGenerator>
#include <QDir>

DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent) {
    QString connectionName = "pharmacy_connection";

    if (QSqlDatabase::contains(connectionName)) {
        db = QSqlDatabase::database(connectionName);
    } else {
        db = QSqlDatabase::addDatabase("QSQLITE", connectionName);
        db.setDatabaseName(getDatabasePath());
    }

    if (!db.open()) {
        qDebug() << "Database Connection Failed:" << db.lastError().text();
        emit databaseError("Failed to connect to database: " + db.lastError().text());
    } else {
        qDebug() << "Database Connected Successfully!";
        // Initialize database if needed
        initializeDatabase();
    }
}

DatabaseManager::~DatabaseManager() {
    if (db.isOpen()) {
        db.close();
    }
}

QString DatabaseManager::getDatabasePath() {
    // Try to find the database file in various locations
    QString appDir = QCoreApplication::applicationDirPath();
    QStringList possiblePaths = {
        appDir + "/PHARMACY.db",
        appDir + "/../data/PHARMACY.db",
        appDir + "/../../data/PHARMACY.db",
        QDir::currentPath() + "/data/PHARMACY.db",
        "C:/Users/Admin/OneDrive/Documents/Pharmease_app/data/PHARMACY.db" // Fallback to original hardcoded path
    };
    
    for (const QString &path : possiblePaths) {
        QFile file(path);
        if (file.exists()) {
            qDebug() << "Found database at:" << path;
            return path;
        }
    }
    
    // If not found, use a default location
    QString defaultPath = appDir + "/PHARMACY.db";
    qDebug() << "Database not found in common locations, using default path:" << defaultPath;
    return defaultPath;
}

bool DatabaseManager::initializeDatabase() {
    // Check if tables exist, if not create them
    QStringList tables = db.tables();
    if (tables.isEmpty()) {
        qDebug() << "Database is empty, initializing tables...";
        
        // Execute SQL statements to create necessary tables
        QStringList createTableStatements = {
            // Customer table
            "CREATE TABLE IF NOT EXISTS Customers ("
            "customer_id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "name TEXT NOT NULL, "
            "contact_no TEXT)",
            
            // Medicine table
            "CREATE TABLE IF NOT EXISTS Medicine ("
            "medicine_id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "name TEXT NOT NULL, "
            "supplier TEXT, "
            "price REAL, "
            "expiry_date TEXT)",
            
            // Stock table
            "CREATE TABLE IF NOT EXISTS Stock ("
            "stock_id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "medicine_id INTEGER, "
            "quantity INTEGER, "
            "last_updation_date TEXT, "
            "FOREIGN KEY (medicine_id) REFERENCES Medicine(medicine_id))",
            
            // Order table
            "CREATE TABLE IF NOT EXISTS Orders ("
            "order_id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "customer_name TEXT, "
            "order_date TEXT, "
            "order_status TEXT)",
            
            // OrderDetails table
            "CREATE TABLE IF NOT EXISTS OrderDetails ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "order_id INTEGER, "
            "medicine_id INTEGER, "
            "quantity INTEGER, "
            "price REAL, "
            "FOREIGN KEY (order_id) REFERENCES Orders(order_id), "
            "FOREIGN KEY (medicine_id) REFERENCES Medicine(medicine_id))",
            
            // Sales table
            "CREATE TABLE IF NOT EXISTS Sales ("
            "sale_id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "order_id INTEGER, "
            "med_name TEXT, "
            "payment_method TEXT, "
            "total_amount REAL, "
            "date TEXT, "
            "FOREIGN KEY (order_id) REFERENCES Orders(order_id))",
            
            // Staff/Employee table
            "CREATE TABLE IF NOT EXISTS Staff ("
            "employee_id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "name TEXT NOT NULL, "
            "role TEXT, "
            "salary REAL, "
            "contact_no TEXT)",
            
            // Create employee login table
            "CREATE TABLE IF NOT EXISTS employee ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "username TEXT UNIQUE NOT NULL, "
            "password TEXT NOT NULL, "
            "employee_id INTEGER, "
            "FOREIGN KEY (employee_id) REFERENCES Staff(employee_id))",
            
            // Create admin login table
            "CREATE TABLE IF NOT EXISTS Admin ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "username TEXT DEFAULT 'admin', "
            "password TEXT NOT NULL)",
            
            // Create view for stock info
            "CREATE VIEW IF NOT EXISTS Stock_info AS "
            "SELECT m.medicine_id, m.name, m.supplier, m.price, m.expiry_date, s.quantity "
            "FROM Medicine m "
            "LEFT JOIN Stock s ON m.medicine_id = s.medicine_id",
            
            // Create supplier table
            "CREATE TABLE IF NOT EXISTS supplier ("
            "supplier_id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "name TEXT NOT NULL, "
            "contact_no TEXT, "
            "medicine_supplied TEXT)"
        };
        
        bool success = true;
        QSqlQuery query(db);
        
        for (const QString &statement : createTableStatements) {
            if (!query.exec(statement)) {
                qDebug() << "Error creating table:" << query.lastError().text();
                qDebug() << "Statement:" << statement;
                success = false;
            }
        }
        
        // Insert default admin account
        if (success) {
            query.prepare("INSERT OR IGNORE INTO Admin (username, password) VALUES ('admin', 'admin123')");
            if (!query.exec()) {
                qDebug() << "Error creating default admin account:" << query.lastError().text();
                success = false;
            }
            
            // Insert default employee account
            query.prepare("INSERT OR IGNORE INTO employee (username, password) VALUES ('employee', 'employee123')");
            if (!query.exec()) {
                qDebug() << "Error creating default employee account:" << query.lastError().text();
                success = false;
            }
            
            // Insert sample data if needed
            insertSampleData();
        }
        
        return success;
    }
    
    return true;
}

void DatabaseManager::insertSampleData() {
    if (getTotalTransactions() > 0) {
        // Data already exists, no need to insert samples
        return;
    }
    
    QSqlQuery query(db);
    
    // Sample medicines
    QList<QStringList> medicines = {
        {"Paracetamol", "MediCorp", "200", "2025-12-31"},
        {"Ibuprofen", "PharmaPlus", "250", "2026-06-30"},
        {"Aspirin", "MediCare", "150", "2026-03-15"},
        {"Amoxicillin", "HealthFirst", "300", "2025-09-20"},
        {"Cough Syrup", "PharmaHub", "150", "2025-10-25"}
    };
    
    for (const QStringList &med : medicines) {
        query.prepare("INSERT INTO Medicine (name, supplier, price, expiry_date) VALUES (?, ?, ?, ?)");
        query.addBindValue(med[0]);
        query.addBindValue(med[1]);
        query.addBindValue(med[2].toDouble());
        query.addBindValue(med[3]);
        query.exec();
        
        int medId = query.lastInsertId().toInt();
        
        // Add stock for each medicine
        query.prepare("INSERT INTO Stock (medicine_id, quantity, last_updation_date) VALUES (?, ?, ?)");
        query.addBindValue(medId);
        query.addBindValue(QRandomGenerator::global()->bounded(20, 120)); // Random quantity between 20 and 119
        query.addBindValue(QDate::currentDate().toString("yyyy-MM-dd"));
        query.exec();
        
        // Add suppliers
        query.prepare("INSERT INTO supplier (name, contact_no, medicine_supplied) VALUES (?, ?, ?)");
        query.addBindValue(med[1]);
        query.addBindValue(QString::number(QRandomGenerator::global()->bounded(1000000000, 9999999999)));
        query.addBindValue(med[0]);
        query.exec();
    }
    
    // Sample customers
    QList<QStringList> customers = {
        {"John Doe", "1234567890"},
        {"Jane Smith", "0987654321"},
        {"Alice Johnson", "1122334455"}
    };
    
    for (const QStringList &cust : customers) {
        query.prepare("INSERT INTO Customers (name, contact_no) VALUES (?, ?)");
        query.addBindValue(cust[0]);
        query.addBindValue(cust[1]);
        query.exec();
    }
    
    // Sample employees
    QList<QStringList> employees = {
        {"Mark Wilson", "Pharmacist", "50000", "1231231231"},
        {"Sarah Brown", "Cashier", "30000", "4564564564"},
        {"David Lee", "Manager", "60000", "7897897890"}
    };
    
    for (const QStringList &emp : employees) {
        query.prepare("INSERT INTO Staff (name, role, salary, contact_no) VALUES (?, ?, ?, ?)");
        query.addBindValue(emp[0]);
        query.addBindValue(emp[1]);
        query.addBindValue(emp[2].toDouble());
        query.addBindValue(emp[3]);
        query.exec();
    }
    
    // Sample orders and sales
    QStringList paymentMethods = {"Cash", "Card", "Online"};
    QStringList dates = {"2025-01-15", "2025-02-10", "2025-03-05", "2025-04-20"};
    
    for (int i = 0; i < 10; i++) {
        // Create order
        query.prepare("INSERT INTO Orders (customer_name, order_date, order_status) VALUES (?, ?, ?)");
        query.addBindValue(customers[i % customers.size()][0]);
        query.addBindValue(dates[i % dates.size()]);
        query.addBindValue("Completed");
        query.exec();
        
        int orderId = query.lastInsertId().toInt();
        
        // Add order details
        int medicineId = (i % medicines.size()) + 1;
        int quantity = (i % 3) + 1;
        double price = medicines[i % medicines.size()][2].toDouble();
        
        query.prepare("INSERT INTO OrderDetails (order_id, medicine_id, quantity, price) VALUES (?, ?, ?, ?)");
        query.addBindValue(orderId);
        query.addBindValue(medicineId);
        query.addBindValue(quantity);
        query.addBindValue(price);
        query.exec();
        
        // Add to sales
        double totalAmount = price * quantity;
        query.prepare("INSERT INTO Sales (order_id, med_name, payment_method, total_amount, date) VALUES (?, ?, ?, ?, ?)");
        query.addBindValue(orderId);
        query.addBindValue(medicines[i % medicines.size()][0]);
        query.addBindValue(paymentMethods[i % paymentMethods.size()]);
        query.addBindValue(totalAmount);
        query.addBindValue(dates[i % dates.size()]);
        query.exec();
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
        return "Cash"; // Default if no data
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
    bestSelling.prepare("SELECT med_name, COUNT(med_name) as count FROM Sales "
                        "GROUP BY med_name ORDER BY count DESC LIMIT 1");
    if(bestSelling.exec() && bestSelling.next()){
        return QPair<QString,double>(bestSelling.value(0).toString(), bestSelling.value(1).toDouble());
    }
    else
        return QPair<QString,double>("None",0.0);
}

QVariantMap DatabaseManager::getBestSellingItemAsMap() {
    QPair<QString, double> bestItem = getBestSellingItem();
    QVariantMap result;
    result["name"] = bestItem.first;
    result["count"] = bestItem.second;
    return result;
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
    double total_sales = getTotalSales();
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

QVariantList DatabaseManager::getDailySalesData() {
    QVector<QPair<QString, double>> salesData = getDailySales();
    QVariantList result;
    
    for (const auto& sale : salesData) {
        QVariantMap item;
        item["date"] = sale.first;
        item["amount"] = sale.second;
        result.append(item);
    }
    
    return result;
}

// Customer Operations
int DatabaseManager::addCustomer(QString name, QString contact) {
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
    query.prepare("INSERT INTO OrderDetails (order_id, medicine_id, quantity, price) VALUES (?, ?, ?, ?)");
    query.addBindValue(order_id);
    query.addBindValue(medicine_id);
    query.addBindValue(quantity);
    query.addBindValue(price);
    
    bool success = query.exec();
    if (success) {
        // Update stock
        removeOrderedMeds(medicine_id, quantity);
    }
    
    return success;
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
    query.prepare("UPDATE Customers SET name = ?, contact_no = ? WHERE customer_id = ?");
    query.addBindValue(customer->getName());
    query.addBindValue(customer->getContactNo());
    query.addBindValue(customer->getId());
    return query.exec();
}

bool DatabaseManager::removeCustomer(int customer_id) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    QSqlQuery query(db);
    query.prepare("DELETE FROM Customers WHERE customer_id = ?");
    query.addBindValue(customer_id);
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
    query.prepare("INSERT INTO Medicine (name, supplier, price, expiry_date) VALUES (?, ?, ?, ?)");
    query.addBindValue(name);
    query.addBindValue(supplier);
    query.addBindValue(price);
    query.addBindValue(expiry_date);

    if (query.exec()) {
        int medicineId = query.lastInsertId().toInt();
        
        // Add stock for the new medicine
        QSqlQuery stockQuery(db);
        stockQuery.prepare("INSERT INTO Stock (medicine_id, quantity, last_updation_date) VALUES (?, ?, ?)");
        stockQuery.addBindValue(medicineId);
        stockQuery.addBindValue(stock);
        stockQuery.addBindValue(QDate::currentDate().toString("yyyy-MM-dd"));
        
        if (stockQuery.exec()) {
            qDebug() << "Medicine and stock added successfully!";
            return true;
        } else {
            qDebug() << "Error adding stock:" << stockQuery.lastError().text();
            return false;
        }
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
    
    // First remove the stock entries
    QSqlQuery stockQuery(db);
    stockQuery.prepare("DELETE FROM Stock WHERE medicine_id = ?");
    stockQuery.addBindValue(medicineID);
    if (!stockQuery.exec()) {
        qDebug() << "Error removing stock for medicine:" << stockQuery.lastError().text();
        return false;
    }
    
    // Then remove the medicine
    QSqlQuery query(db);
    query.prepare("DELETE FROM Medicine WHERE medicine_id = ?");
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
    query.prepare("SELECT * FROM Stock WHERE stock_id = ?");
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
    query.prepare("SELECT * FROM Medicine WHERE medicine_id = ?");
    query.addBindValue(medicineID);
    query.exec();

    return query.next(); // Returns true if medicine exists
}

// ==================== STOCK FUNCTIONS ====================

// Add stock to an existing medicine
bool DatabaseManager::addStock(int medicine_id, int quantity) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    
    // Check if stock entry already exists
    QSqlQuery checkQuery(db);
    checkQuery.prepare("SELECT quantity FROM Stock WHERE medicine_id = ?");
    checkQuery.addBindValue(medicine_id);
    
    if (checkQuery.exec() && checkQuery.next()) {
        // Stock entry exists, update it
        int currentQuantity = checkQuery.value(0).toInt();
        QSqlQuery updateQuery(db);
        updateQuery.prepare("UPDATE Stock SET quantity = ?, last_updation_date = ? WHERE medicine_id = ?");
        updateQuery.addBindValue(currentQuantity + quantity);
        updateQuery.addBindValue(QDate::currentDate().toString("yyyy-MM-dd"));
        updateQuery.addBindValue(medicine_id);
        
        if (!updateQuery.exec()) {
            qDebug() << "Failed to update stock:" << updateQuery.lastError().text();
            return false;
        }
        return true;
    } else {
        // No stock entry yet, create a new one
        QSqlQuery insertQuery(db);
        insertQuery.prepare("INSERT INTO Stock (medicine_id, quantity, last_updation_date) VALUES (?, ?, ?)");
        insertQuery.addBindValue(medicine_id);
        insertQuery.addBindValue(quantity);
        insertQuery.addBindValue(QDate::currentDate().toString("yyyy-MM-dd"));
        
        if (!insertQuery.exec()) {
            qDebug() << "Failed to add stock:" << insertQuery.lastError().text();
            return false;
        }
        return true;
    }
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
    
    // First get the IDs of expired medicines
    QSqlQuery selectQuery(db);
    selectQuery.prepare("SELECT medicine_id FROM Medicine WHERE expiry_date < DATE('now')");
    
    if (!selectQuery.exec()) {
        qDebug() << "Error finding expired medicines:" << selectQuery.lastError().text();
        return false;
    }
    
    // Delete associated stock entries first
    while (selectQuery.next()) {
        int medicineId = selectQuery.value(0).toInt();
        QSqlQuery stockQuery(db);
        stockQuery.prepare("DELETE FROM Stock WHERE medicine_id = ?");
        stockQuery.addBindValue(medicineId);
        
        if (!stockQuery.exec()) {
            qDebug() << "Error removing stock for expired medicine:" << stockQuery.lastError().text();
        }
    }
    
    // Then delete the expired medicines
    QSqlQuery deleteQuery(db);
    deleteQuery.prepare("DELETE FROM Medicine WHERE expiry_date < DATE('now')");
    
    if (deleteQuery.exec()) {
        qDebug() << "Expired medicines removed!";
        return true;
    } else {
        qDebug() << "Error removing expired medicines:" << deleteQuery.lastError().text();
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
            emit stockDataLoaded(QVariantList());
            return;
        }
    }

    QSqlQuery query(db);
    query.prepare("SELECT medicine_id, name, supplier, price, expiry_date, quantity FROM Stock_info");

    if (!query.exec()) {
        qDebug() << "Error fetching stock info:" << query.lastError().text();
        emit stockDataLoaded(QVariantList());
        return;
    }

    QVariantList stockList;
    while (query.next()) {
        QVariantMap stockItem;
        stockItem["medicine_id"] = query.value(0).toInt();
        stockItem["name"] = query.value(1).toString();
        stockItem["supplier"] = query.value(2).toString();
        stockItem["price"] = query.value(3).toDouble();
        stockItem["expiry_date"] = query.value(4).toString();
        stockItem["quantity"] = query.value(5).isNull() ? 0 : query.value(5).toInt();
        stockItem["isEditable"] = false;  // default not editable
        stockList.append(stockItem);
    }

    emit stockDataLoaded(stockList);
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
    query.prepare("SELECT quantity FROM Stock WHERE medicine_id = ?");
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
    query.prepare("SELECT quantity FROM Stock WHERE medicine_id = ?");
    query.addBindValue(medicineID);
    
    if (query.exec() && query.next()) {
        return query.value(0).toInt() > 0;
    }
    
    return false; // Returns false if no stock or database error
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
    query.prepare("SELECT quantity FROM Stock WHERE stock_id = ?");
    query.addBindValue(stockID);
    
    if (query.exec() && query.next()) {
        return query.value(0).toInt() > 0;
    }
    
    return false; // Returns false if no stock or database error
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
    query.prepare("SELECT medicine_id FROM Stock WHERE quantity < ?");
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
    query.prepare("INSERT INTO OrderDetails (order_id, medicine_id, quantity, price) VALUES (:orderID, :medID, :quantity, :price)");
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
    query.prepare("SELECT name FROM Medicine WHERE medicine_id = ?");
    query.addBindValue(medicineID);
    query.exec();

    if (query.next()) {
        return query.value(0).toString();  // Return the medicine name
    }

    return "";  // If no medicine is found, return an empty string
}

bool DatabaseManager::updateOrderStatus(int orderID, const QString& status) {
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
bool DatabaseManager::removeOrderedMeds(int medID, int quantity) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return false;
        }
    }
    
    // Check current stock level
    QSqlQuery checkQuery(db);
    checkQuery.prepare("SELECT quantity FROM Stock WHERE medicine_id = ?");
    checkQuery.addBindValue(medID);
    
    if (!checkQuery.exec() || !checkQuery.next()) {
        qDebug() << "Error checking stock:" << checkQuery.lastError().text();
        return false;
    }
    
    int currentStock = checkQuery.value(0).toInt();
    
    if (currentStock < quantity) {
        qDebug() << "Insufficient stock. Available:" << currentStock << ", Required:" << quantity;
        return false;
    }
    
    // Update stock
    QSqlQuery updateQuery(db);
    updateQuery.prepare("UPDATE Stock SET quantity = quantity - ? WHERE medicine_id = ?");
    updateQuery.addBindValue(quantity);
    updateQuery.addBindValue(medID);

    if (updateQuery.exec()) {
        return true;
    } else {
        qDebug() << "Error updating stock:" << updateQuery.lastError().text();
        return false;
    }
}

int DatabaseManager::insertMedicine(const QString& name, const QString& supplier, double price, const QString& expiry_date) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return -1;
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
            return -1;
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
    query.prepare("SELECT price FROM Medicine WHERE medicine_id = ?");
    query.addBindValue(medicineID);
    if (query.exec() && query.next()) {
        return query.value(0).toDouble();
    }
    return 0.0;
}

QString DatabaseManager::getCustomerName(int customer_id) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            return "DATABASE ERROR";
        }
    }
    QSqlQuery name(db);
    name.prepare("SELECT name FROM Customers WHERE customer_id = ?");
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
            return -1;
        }
    }
    QSqlQuery query(db);

    query.prepare("INSERT INTO Orders (customer_name, order_date, order_status) VALUES (?, ?, ?)");
    query.addBindValue(customerName);
    query.addBindValue(QDate::currentDate().toString("yyyy-MM-dd"));
    query.addBindValue("Pending");

    if (!query.exec()) {
        qDebug() << "Failed to start order because:" << query.lastError().text();
        return -1;
    }
    
    int newOrderId = query.lastInsertId().toInt();
    emit orderPlaced(true, newOrderId);
    return newOrderId;
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

    // Update the stock
    removeOrderedMeds(medicineID, requiredQuantity);

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

    // Update order status to "Confirmed"
    QSqlQuery updateStatusQuery(db);
    updateStatusQuery.prepare("UPDATE Orders SET order_status = 'Confirmed' WHERE order_id = ?");
    updateStatusQuery.addBindValue(orderID);
    
    if (!updateStatusQuery.exec()) {
        qDebug() << "Failed to update order status:" << updateStatusQuery.lastError().text();
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
            return -1;
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
        return -1;
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
        return -1;
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
    
    // Collect medicine names for the sale record
    QStringList medNames;
    QSqlQuery medQuery(db);
    medQuery.prepare("SELECT medicine_id FROM OrderDetails WHERE order_id = ?");
    medQuery.addBindValue(orderID);

    if (medQuery.exec()) {
        while (medQuery.next()) {
            int medicineID = medQuery.value(0).toInt();
            QString medName = getMedicineName(medicineID);
            if (!medName.isEmpty()) {
                medNames << medName;
            }
        }
    }
    
    // Combine the medicine names for the sales record
    QString combinedMedNames = medNames.join(", ");
    
    // Insert into Sales table
    QSqlQuery insert(db);
    insert.prepare("INSERT INTO Sales (order_id, med_name, payment_method, total_amount, date) "
                   "VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)");

    insert.addBindValue(orderID);
    insert.addBindValue(combinedMedNames);
    insert.addBindValue(paymentMethod);
    insert.addBindValue(totalAmount);

    if (!insert.exec()) {
        qDebug() << "Failed to insert into Sales:" << insert.lastError();
        return false;
    }

    // Update the Orders table to mark the order as Completed
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
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");

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

void DatabaseManager::getStockInfo() {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            emit stockDataLoaded(QVariantList());
            return;
        }
    }

    QSqlQuery query(db);
    query.prepare("SELECT m.medicine_id, m.name, m.supplier, m.price, m.expiry_date, "
                  "COALESCE(s.quantity, 0) as quantity "
                  "FROM Medicine m "
                  "LEFT JOIN Stock s ON m.medicine_id = s.medicine_id");

    if (!query.exec()) {
        qDebug() << "Error fetching stock info:" << query.lastError().text();
        emit stockDataLoaded(QVariantList());
        return;
    }

    QVariantList stockList;
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

    emit stockDataLoaded(stockList);
}

void DatabaseManager::searchMedicine(const QString &searchText) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            emit stockDataLoaded(QVariantList());
            return;
        }
    }

    QSqlQuery query(db);
    // Using LIKE for partial matching
    query.prepare("SELECT m.medicine_id, m.name, m.supplier, m.price, m.expiry_date, "
                  "COALESCE(s.quantity, 0) as quantity "
                  "FROM Medicine m "
                  "LEFT JOIN Stock s ON m.medicine_id = s.medicine_id "
                  "WHERE m.name LIKE ?");
    query.addBindValue("%" + searchText + "%");

    if (!query.exec()) {
        qDebug() << "Error searching medicines:" << query.lastError().text();
        emit stockDataLoaded(QVariantList());
        return;
    }

    QVariantList stockList;
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

    emit stockDataLoaded(stockList);
}

void DatabaseManager::searchSupplier(const QString &searchText) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            emit stockDataLoaded(QVariantList());
            return;
        }
    }

    QSqlQuery query(db);
    query.prepare("SELECT m.medicine_id, m.name, m.supplier, m.price, m.expiry_date, "
                  "COALESCE(s.quantity, 0) as quantity "
                  "FROM Medicine m "
                  "LEFT JOIN Stock s ON m.medicine_id = s.medicine_id "
                  "WHERE m.supplier LIKE ?");
    query.addBindValue("%" + searchText + "%");

    if (!query.exec()) {
        qDebug() << "Error searching suppliers:" << query.lastError().text();
        emit stockDataLoaded(QVariantList());
        return;
    }

    QVariantList stockList;
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

    emit stockDataLoaded(stockList);
}

bool DatabaseManager::addStockInfo(int medicineId, const QString &name, const QString &supplier,
                                  double price, const QString &expiryDate, int quantity) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            emit stockAdded(false);
            return false;
        }
    }

    // Begin transaction
    db.transaction();
    
    bool success = true;
    
    // Check if medicine exists
    QSqlQuery checkQuery(db);
    checkQuery.prepare("SELECT COUNT(*) FROM Medicine WHERE medicine_id = ?");
    checkQuery.addBindValue(medicineId);
    
    if (checkQuery.exec() && checkQuery.next()) {
        if (checkQuery.value(0).toInt() > 0) {
            // Medicine exists, update it
            QSqlQuery medicineQuery(db);
            medicineQuery.prepare("UPDATE Medicine SET name = ?, supplier = ?, price = ?, expiry_date = ? "
                            "WHERE medicine_id = ?");
            medicineQuery.addBindValue(name);
            medicineQuery.addBindValue(supplier);
            medicineQuery.addBindValue(price);
            medicineQuery.addBindValue(expiryDate);
            medicineQuery.addBindValue(medicineId);
            
            if (!medicineQuery.exec()) {
                qDebug() << "Error updating medicine:" << medicineQuery.lastError().text();
                success = false;
            }
        } else {
            // Medicine doesn't exist, insert it
            QSqlQuery medicineQuery(db);
            medicineQuery.prepare("INSERT INTO Medicine (medicine_id, name, supplier, price, expiry_date) "
                            "VALUES (?, ?, ?, ?, ?)");
            medicineQuery.addBindValue(medicineId);
            medicineQuery.addBindValue(name);
            medicineQuery.addBindValue(supplier);
            medicineQuery.addBindValue(price);
            medicineQuery.addBindValue(expiryDate);
            
            if (!medicineQuery.exec()) {
                qDebug() << "Error inserting medicine:" << medicineQuery.lastError().text();
                success = false;
            }
        }
    } else {
        qDebug() << "Error checking medicine existence:" << checkQuery.lastError().text();
        success = false;
    }

    // If medicine was handled successfully, update or insert stock
    if (success) {
        QSqlQuery checkStockQuery(db);
        checkStockQuery.prepare("SELECT COUNT(*) FROM Stock WHERE medicine_id = ?");
        checkStockQuery.addBindValue(medicineId);
        
        if (checkStockQuery.exec() && checkStockQuery.next()) {
            if (checkStockQuery.value(0).toInt() > 0) {
                // Stock exists, update it
                QSqlQuery stockQuery(db);
                stockQuery.prepare("UPDATE Stock SET quantity = ?, last_updation_date = ? "
                                "WHERE medicine_id = ?");
                stockQuery.addBindValue(quantity);
                stockQuery.addBindValue(QDate::currentDate().toString("yyyy-MM-dd"));
                stockQuery.addBindValue(medicineId);
                
                if (!stockQuery.exec()) {
                    qDebug() << "Error updating stock:" << stockQuery.lastError().text();
                    success = false;
                }
            } else {
                // Stock doesn't exist, insert it
                QSqlQuery stockQuery(db);
                stockQuery.prepare("INSERT INTO Stock (medicine_id, quantity, last_updation_date) "
                                "VALUES (?, ?, ?)");
                stockQuery.addBindValue(medicineId);
                stockQuery.addBindValue(quantity);
                stockQuery.addBindValue(QDate::currentDate().toString("yyyy-MM-dd"));
                
                if (!stockQuery.exec()) {
                    qDebug() << "Error inserting stock:" << stockQuery.lastError().text();
                    success = false;
                }
            }
        } else {
            qDebug() << "Error checking stock existence:" << checkStockQuery.lastError().text();
            success = false;
        }
    }

    // Commit or rollback transaction based on success
    if (success) {
        db.commit();
    } else {
        db.rollback();
    }

    emit stockAdded(success);
    return success;
}

bool DatabaseManager::updateStock(int medicineId, const QString &name, const QString &supplier,
                                 double price, const QString &expiryDate, int quantity) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            emit stockUpdated(false);
            return false;
        }
    }

    // Begin transaction
    db.transaction();
    
    bool success = true;
    
    // Update medicine information
    QSqlQuery medicineQuery(db);
    medicineQuery.prepare("UPDATE Medicine SET name = ?, supplier = ?, price = ?, expiry_date = ? "
                         "WHERE medicine_id = ?");
    medicineQuery.addBindValue(name);
    medicineQuery.addBindValue(supplier);
    medicineQuery.addBindValue(price);
    medicineQuery.addBindValue(expiryDate);
    medicineQuery.addBindValue(medicineId);
    
    if (!medicineQuery.exec()) {
        qDebug() << "Error updating medicine:" << medicineQuery.lastError().text();
        success = false;
    }

    // Update stock information
    QSqlQuery checkStockQuery(db);
    checkStockQuery.prepare("SELECT COUNT(*) FROM Stock WHERE medicine_id = ?");
    checkStockQuery.addBindValue(medicineId);
    
    if (checkStockQuery.exec() && checkStockQuery.next()) {
        if (checkStockQuery.value(0).toInt() > 0) {
            // Stock exists, update it
            QSqlQuery stockQuery(db);
            stockQuery.prepare("UPDATE Stock SET quantity = ?, last_updation_date = ? "
                              "WHERE medicine_id = ?");
            stockQuery.addBindValue(quantity);
            stockQuery.addBindValue(QDate::currentDate().toString("yyyy-MM-dd"));
            stockQuery.addBindValue(medicineId);
            
            if (!stockQuery.exec()) {
                qDebug() << "Error updating stock:" << stockQuery.lastError().text();
                success = false;
            }
        } else {
            // Stock doesn't exist, insert it
            QSqlQuery stockQuery(db);
            stockQuery.prepare("INSERT INTO Stock (medicine_id, quantity, last_updation_date) "
                              "VALUES (?, ?, ?)");
            stockQuery.addBindValue(medicineId);
            stockQuery.addBindValue(quantity);
            stockQuery.addBindValue(QDate::currentDate().toString("yyyy-MM-dd"));
            
            if (!stockQuery.exec()) {
                qDebug() << "Error inserting stock:" << stockQuery.lastError().text();
                success = false;
            }
        }
    } else {
        qDebug() << "Error checking stock existence:" << checkStockQuery.lastError().text();
        success = false;
    }

    // Commit or rollback transaction based on success
    if (success) {
        db.commit();
    } else {
        db.rollback();
    }

    emit stockUpdated(success);
    
    // Reload stock data if successful
    if (success) {
        getStockInfo();
    }
    
    return success;
}

bool DatabaseManager::deleteStock(int medicineId) {
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            emit stockDeleted(false);
            return false;
        }
    }

    // Begin transaction
    db.transaction();
    
    bool success = true;
    
    // First delete from Stock table
    QSqlQuery stockQuery(db);
    stockQuery.prepare("DELETE FROM Stock WHERE medicine_id = ?");
    stockQuery.addBindValue(medicineId);
    
    if (!stockQuery.exec()) {
        qDebug() << "Error deleting stock:" << stockQuery.lastError().text();
        success = false;
    }

    // Then delete from Medicine table
    QSqlQuery medicineQuery(db);
    medicineQuery.prepare("DELETE FROM Medicine WHERE medicine_id = ?");
    medicineQuery.addBindValue(medicineId);
    
    if (!medicineQuery.exec()) {
        qDebug() << "Error deleting medicine:" << medicineQuery.lastError().text();
        success = false;
    }

    // Commit or rollback transaction based on success
    if (success) {
        db.commit();
    } else {
        db.rollback();
    }

    emit stockDeleted(success);
    
    // Reload stock data if successful
    if (success) {
        getStockInfo();
    }
    
    return success;
}

QVariantList DatabaseManager::getMedicineList() {
    QVariantList medicineList;
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            emit databaseError("Database connection failed");
            return medicineList;
        }
    }
    
    QSqlQuery query(db);
    query.prepare("SELECT m.medicine_id, m.name, m.price, COALESCE(s.quantity, 0) as quantity "
                 "FROM Medicine m "
                 "LEFT JOIN Stock s ON m.medicine_id = s.medicine_id "
                 "WHERE COALESCE(s.quantity, 0) > 0");
    
    if (query.exec()) {
        while (query.next()) {
            QVariantMap medicine;
            medicine["medID"] = query.value(0).toString();
            medicine["name"] = query.value(1).toString();
            medicine["price"] = query.value(2).toString();
            medicine["available"] = query.value(3).toInt();
            medicineList.append(medicine);
        }
    } else {
        qDebug() << "Error fetching medicine list:" << query.lastError().text();
    }
    
    emit medicineListLoaded(medicineList);
    return medicineList;
}

QVariantList DatabaseManager::getOrdersList() {
    QVariantList ordersList;
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            emit databaseError("Database connection failed");
            return ordersList;
        }
    }
    
    QSqlQuery query(db);
    query.prepare("SELECT o.order_id, od.medicine_id, m.name, o.customer_name, od.quantity, "
                  "s.payment_method, s.total_amount, o.order_date "
                  "FROM Orders o "
                  "JOIN OrderDetails od ON o.order_id = od.order_id "
                  "JOIN Medicine m ON od.medicine_id = m.medicine_id "
                  "LEFT JOIN Sales s ON o.order_id = s.order_id "
                  "ORDER BY o.order_date DESC");
    
    if (query.exec()) {
        while (query.next()) {
            QVariantMap order;
            order["orderID"] = query.value(0).toString();
            order["medicineID"] = query.value(1).toString();
            order["medicineName"] = query.value(2).toString();
            order["customerName"] = query.value(3).toString();
            order["customerID"] = "C" + QString::number(query.value(0).toInt() % 100); // Generate placeholder ID
            order["quantity"] = query.value(4).toString();
            order["paymentMethod"] = query.value(5).isNull() ? "Pending" : query.value(5).toString();
            order["totalAmount"] = query.value(6).isNull() ? "0" : query.value(6).toString();
            order["date"] = query.value(7).toString();
            ordersList.append(order);
        }
    } else {
        qDebug() << "Error fetching orders list:" << query.lastError().text();
    }
    
    emit orderDataLoaded(ordersList);
    return ordersList;
}

QVariantList DatabaseManager::getInventoryData() {
    QVariantList inventoryList;
    QSqlDatabase db = QSqlDatabase::database("pharmacy_connection");
    
    if (!db.isOpen()) {
        qDebug() << "Connection not open. Trying to reopen.";
        if (!db.open()) {
            qDebug() << "Reopen failed:" << db.lastError().text();
            emit databaseError("Database connection failed");
            return inventoryList;
        }
    }
    
    QSqlQuery query(db);
    query.prepare("SELECT m.supplier, s.supplier_id, s.contact_no, m.name, st.quantity, m.expiry_date "
                  "FROM Medicine m "
                  "LEFT JOIN supplier s ON m.supplier = s.name "
                  "LEFT JOIN Stock st ON m.medicine_id = st.medicine_id");
    
    if (query.exec()) {
        while (query.next()) {
            QVariantMap item;
            item["supplierName"] = query.value(0).toString();
            
            // Generate a supplier ID if NULL
            if (query.value(1).isNull()) {
                QString suppName = query.value(0).toString();
                QString genId = "S" + QString::number(QRandomGenerator::global()->bounded(100000));
                item["ID"] = genId;
                
                // Insert into supplier table if not exists
                QSqlQuery suppQuery(db);
                suppQuery.prepare("INSERT OR IGNORE INTO supplier (supplier_id, name, contact_no, medicine_supplied) "
                                 "VALUES (?, ?, ?, ?)");
                suppQuery.addBindValue(genId);
                suppQuery.addBindValue(suppName);
                suppQuery.addBindValue("Unknown");
                suppQuery.addBindValue(query.value(3).toString());
                suppQuery.exec();
            } else {
                item["ID"] = query.value(1).toString();
            }
            
            item["contact"] = query.value(2).isNull() ? "Unknown" : query.value(2).toString();
            item["medicineName"] = query.value(3).toString();
            item["quantity"] = query.value(4).isNull() ? "0" : query.value(4).toString();
            item["expiry"] = query.value(5).toString();
            inventoryList.append(item);
        }
    } else {
        qDebug() << "Error fetching inventory data:" << query.lastError().text();
    }
    
    emit inventoryDataLoaded(inventoryList);
    return inventoryList;
}

// Utility method to check database connection status
bool DatabaseManager::isDatabaseConnected() {
    return db.isOpen();
}

// Utility method to get the last error message
QString DatabaseManager::getLastError() {
    return db.lastError().text();
}