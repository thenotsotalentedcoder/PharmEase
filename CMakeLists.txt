cmake_minimum_required(VERSION 3.16)

project(Pharmease_app VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick Sql Widgets)

qt_standard_project_setup()

qt_add_executable(appPharmease_app
    main.cpp
    backend/databasemanager.cpp
    backend/customer.cpp
    backend/mainwindow.cpp
    backend/medicine.cpp
    backend/order.cpp
    backend/stock.cpp
    backend/supplier.cpp
)

target_include_directories(appPharmease_app PRIVATE backend)

target_link_libraries(appPharmease_app
    PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::Sql
    Qt6::Widgets
)


qt_add_resources(appPharmease_app "qml_resources"
    PREFIX "/"
    FILES
        qml/App.qml
        qml/Screen01.qml
        qml/Employee_details.qml
        qml/Login_administrator.qml
        qml/Login_employee.qml
        qml/Main_administrator.qml
        qml/Main_employee.qml
        qml/Manage_stock.qml
        qml/Place_order.qml
        qml/Sales_report.qml
        qml/Track_inventory.qml
        qml/View_orders.qml
)

install(TARGETS appPharmease_app
    BUNDLE DESTINATION .
    LIBRARY DESTINATION lib
)
