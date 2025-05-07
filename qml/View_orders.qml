import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Item {
    id: root
    anchors.fill: parent

    // Connect to C++ DatabaseManager
    Component.onCompleted: {
        // Call function to fetch data from database
        loadOrders();

        // Set initial filter to "All" without triggering a reload
        paymentFilter.currentIndex = 0;
    }

    // Function to load orders to avoid code duplication
    function loadOrders() {
        var ordersData = dbManager.getOrders();
        ordermodel.clear();
        for (var i = 0; i < ordersData.length; i++) {
            ordermodel.append(ordersData[i]);
        }
    }

    Rectangle {
        id: bgrectangle
        color: "#daeae6"
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent
            spacing: 50

        Text {
            id: orders
            color: "#5b99d6"
            text: qsTr("Orders & Sales")
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 30
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
            font.family: "Tahoma"
        }

        RowLayout {
            Layout.fillWidth: true
            anchors.left: parent.left
            anchors.margins: 70
            spacing: 20
            TextField {
                id: searchField
                placeholderText: "Search Order ID..."
                Layout.preferredWidth: 350
                Layout.preferredHeight: 40
            }
            Button {
                width: 50
                height: 25
                text: "Search"
                background: Rectangle {
                    color: "#89ced4"
                    radius: 40
                }
                contentItem: Text {
                    text: parent.text
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 10
                }
                onClicked: {
                    ordermodel.clear();
                    // Filter model by medicine name
                    if (searchField.text.trim() !== "") {
                        var filteredOrders = dbManager.searchOrderById(searchField.text);

                        ordermodel.clear();
                        for (var j = 0; j < filteredOrders.length; j++) {
                            ordermodel.append({
                                order_id: filteredOrders[j].order_id,
                                customer_id: filteredOrders[j].customer_id,
                                customer_name: filteredOrders[j].customer_name,
                                contact_no: filteredOrders[j].contact_no,
                                order_status: filteredOrders[j].order_status,
                                quantity: filteredOrders[j].quantity,
                                payment_method: filteredOrders[j].payment_method,
                                total: filteredOrders[j].total,
                                order_date: filteredOrders[j].order_date,
                                isEditable: false
                            });
                        }
                    } else {
                        loadOrders();
                    }
                }
            }
            Item {
                width: 40
                height: 1
            }
            TextField {
                id: searchField1
                placeholderText: "Search Customer ID..."
                Layout.preferredWidth: 350
                Layout.preferredHeight: 40
            }
            Button {
                width: 50
                height: 25
                text: "Search"
                background: Rectangle {
                    color: "#89ced4"
                    radius: 40
                }
                contentItem: Text {
                    text: parent.text
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 10
                }
                onClicked: {
                    ordermodel.clear();
                    // Filter model by medicine name
                    if (searchField1.text.trim() !== "") {
                        var filteredOrders = dbManager.searchOrderByCustomerId(searchField1.text);

                        ordermodel.clear();
                        for (var j = 0; j < filteredOrders.length; j++) {
                            ordermodel.append({
                                order_id: filteredOrders[j].order_id,
                                customer_id: filteredOrders[j].customer_id,
                                customer_name: filteredOrders[j].customer_name,
                                contact_no: filteredOrders[j].contact_no,
                                order_status: filteredOrders[j].order_status,
                                quantity: filteredOrders[j].quantity,
                                payment_method: filteredOrders[j].payment_method,
                                total: filteredOrders[j].total,
                                order_date: filteredOrders[j].order_date,
                                isEditable: false
                            });
                        }
                    } else {
                        loadOrders();
                    }
                }
            }
            ComboBox {
                id: paymentFilter
                Layout.preferredHeight: 30
                width: 170
                model: ["All", "Cash", "Card", "Online"]
                onCurrentTextChanged: {
                    if (currentText === "All") {
                        loadOrders();
                    } else {
                        var filteredOrders = dbManager.filterOrdersByPaymentMethod(currentText);
                        ordermodel.clear();
                        for (var j = 0; j < filteredOrders.length; j++) {
                            ordermodel.append({
                                order_id: filteredOrders[j].order_id,
                                customer_id: filteredOrders[j].customer_id,
                                customer_name: filteredOrders[j].customer_name,
                                contact_no: filteredOrders[j].contact_no,
                                order_status: filteredOrders[j].order_status,
                                quantity: filteredOrders[j].quantity,
                                payment_method: filteredOrders[j].payment_method,
                                total: filteredOrders[j].total,
                                order_date: filteredOrders[j].order_date,
                                isEditable: false
                            });
                        }
                    }
                }
            }
        }

        ColumnLayout {
            id: tableContainer
            Layout.leftMargin: 60
            Layout.preferredWidth: parent.width - 165
            Layout.rightMargin: 70
            Layout.preferredHeight: 700

            Rectangle {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight:  40
                color: "#89ced4"
                border.color: "black"
                border.width: 1

                Grid {
                    columns: 9
                    columnSpacing: 10
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    rowSpacing: 5

                    Text { text: "Order ID"; horizontalAlignment: Text.AlignHCenter; width: 140; font.bold: true }
                    Text { text: "Customer ID"; horizontalAlignment: Text.AlignHCenter; width: 130; font.bold: true }
                    Text { text: "Customer Name"; horizontalAlignment: Text.AlignHCenter; width: 140; font.bold: true }
                    Text { text: "Customer Contact No."; horizontalAlignment: Text.AlignHCenter; width: 140; font.bold: true }
                    Text { text: "Order Status"; horizontalAlignment: Text.AlignHCenter; width: 150; font.bold: true }
                    Text { text: "Qty"; horizontalAlignment: Text.AlignHCenter; width: 50; font.bold: true }
                    Text { text: "Payment"; horizontalAlignment: Text.AlignHCenter; width: 110; font.bold: true }
                    Text { text: "Total (Rs.)"; horizontalAlignment: Text.AlignHCenter; width: 80; font.bold: true }
                    Text { text: "Date"; horizontalAlignment: Text.AlignHCenter; width: 110; font.bold: true }
                }
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.preferredHeight: 400
                clip: true

                ListView {
                    id: tableView
                    width: parent.width
                    model: ordermodel

                    delegate: Rectangle {
                        width: tableView.width
                        height: 40
                        border.color: "black"
                        border.width: 1

                        Row {
                            anchors.fill: parent

                            Rectangle { width: 140; height: 40; border.color: "black"; color: "white"
                                Text { text: model.order_id; anchors.fill: parent; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }

                            Rectangle { width: 140; height: 40; border.color: "black"; color: "white"
                                Text { text: model.customer_id; anchors.fill: parent; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }

                            Rectangle { width: 160; height: 40; border.color: "black"; color: "white"
                                Text { text: model.customer_name; anchors.fill: parent; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }

                            Rectangle { width: 140; height: 40; border.color: "black"; color: "white"
                                Text { text: model.contact_no; anchors.fill: parent; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }

                            Rectangle { width: 160; height: 40; border.color: "black"; color: "white"
                                Text { text: model.order_status; anchors.fill: parent; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }

                            Rectangle { width: 80; height: 40; border.color: "black"; color: "white"
                                Text { text: model.quantity; anchors.fill: parent; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }

                            Rectangle { width: 100; height: 40; border.color: "black"; color: "white"
                                Text { text: model.payment_method; anchors.fill: parent; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }

                            Rectangle { width: 100; height: 40; border.color: "black"; color: "white"
                                Text { text: "Rs." + model.total; anchors.fill: parent; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }

                            Rectangle { width: 130; height: 40; border.color: "black"; color: "white"
                                Text { text: model.order_date; anchors.fill: parent; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }
                        }
                    }
                }
            }
        }
    }

        Button {
            id: backbutton
            Layout.preferredWidth: 50
            Layout.preferredHeight: 40
            text: "Back"
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 20
            z: 10
            background: Rectangle {
                color: parent.down ? "#d6d6d6" : "#f6f6f6"
                border.color: "#707070"
                border.width: 1
                radius: 0
            }
            contentItem: Text {
                text: parent.text
                color: "#202020"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: stackView.pop()
        }
    }
        ListModel {
            id: ordermodel
            // Will be populated from database in Component.onCompleted
        }
    }

