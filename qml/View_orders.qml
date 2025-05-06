import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    anchors.fill: parent
    property StackView stackView: null

    // Connect to database signals
    Connections {
        target: dbManager
        function onOrderDataLoaded(orderData) {
            ordermodel.clear();
            for (var i = 0; i < orderData.length; i++) {
                ordermodel.append(orderData[i]);
            }
        }
    }
    
    // Load data on component initialization
    Component.onCompleted: {
        dbManager.getOrdersList();
    }

    Rectangle {
        id: bgrectangle
        color: "#daeae6"
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent
            spacing: 30

            Text {
                id: orders
                color: "#5b99d6"
                text: qsTr("Orders & Sales")
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                font.family: "Tahoma"
                Layout.topMargin: 20
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 40
                Layout.rightMargin: 40
                spacing: 20
                
                TextField {
                    id: searchField
                    placeholderText: "Search medicine..."
                    Layout.preferredWidth: 250
                    Layout.preferredHeight: 40
                    onTextChanged: {
                        if (text.length > 2) {
                            filterOrders();
                        }
                    }
                }
                
                Button {
                    text: "Search"
                    width: 80
                    height: 40
                    background: Rectangle {
                        color: "#89ced4"
                        radius: 5
                    }
                    contentItem: Text {
                        text: parent.text
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 14
                    }
                    onClicked: filterOrders()
                }
                
                Rectangle {
                    width: 20
                    height: 1
                    color: "transparent"
                }
                
                TextField {
                    id: searchField1
                    placeholderText: "Search customer..."
                    Layout.preferredWidth: 250
                    Layout.preferredHeight: 40
                    onTextChanged: {
                        if (text.length > 2) {
                            filterOrders();
                        }
                    }
                }
                
                Button {
                    text: "Search"
                    width: 80
                    height: 40
                    background: Rectangle {
                        color: "#89ced4"
                        radius: 5
                    }
                    contentItem: Text {
                        color: "#000000"
                        text: parent.text
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 14
                    }
                    onClicked: filterOrders()
                }
                
                ComboBox {
                    id: paymentFilter
                    Layout.preferredHeight: 40
                    Layout.preferredWidth: 150
                    model: ["All", "Cash", "Card", "Online"]
                    onCurrentTextChanged: filterOrders()
                }
                
                Button {
                    text: "Reset"
                    width: 80
                    height: 40
                    background: Rectangle {
                        color: "#f0f0f0"
                        radius: 5
                    }
                    contentItem: Text {
                        text: parent.text
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 14
                    }
                    onClicked: {
                        searchField.text = "";
                        searchField1.text = "";
                        paymentFilter.currentIndex = 0;
                        dbManager.getOrdersList();
                    }
                }
            }

            ColumnLayout {
                id: tableContainer
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                Layout.fillWidth: true
                Layout.fillHeight: true

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    color: "#89ced4"
                    border.color: "black"
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0

                        Text { 
                            text: "Order ID"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 100
                        }
                        Text { 
                            text: "Medicine ID"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 110
                        }
                        Text { 
                            text: "Medicine"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 140
                        }
                        Text { 
                            text: "Customer ID"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 110
                        }
                        Text { 
                            text: "Customer Name"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 160
                        }
                        Text { 
                            text: "Qty"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 60
                        }
                        Text { 
                            text: "Payment"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 120
                        }
                        Text { 
                            text: "Total (Rs.)"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 110
                        }
                        Text { 
                            text: "Date"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.fillWidth: true
                        }
                    }
                }

                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    ListView {
                        id: tableView
                        width: parent.width
                        model: ordermodel
                        boundsBehavior: Flickable.StopAtBounds

                        delegate: Rectangle {
                            width: tableView.width
                            height: 40
                            color: index % 2 === 0 ? "#f5f5f5" : "white"
                            border.color: "#e0e0e0"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                spacing: 0

                                Rectangle {
                                    Layout.preferredWidth: 100
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: model.orderID
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 110
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    Text
                                    text: model.medicineID
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 140
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: model.medicineName
                                        horizontalAlignment: Text.AlignHCenter
                                        elide: Text.ElideRight
                                        width: parent.width - 10
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 110
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: model.customerID
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 160
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: model.customerName
                                        horizontalAlignment: Text.AlignHCenter
                                        elide: Text.ElideRight
                                        width: parent.width - 10
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 60
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: model.quantity
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 120
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: model.paymentMethod || "Cash"
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 110
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: "Rs. " + model.totalAmount
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: model.date
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            // Back button at the bottom 
            Button {
                id: backbutton
                text: "Back"
                Layout.preferredWidth: 100
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: 20
                Layout.bottomMargin: 20
                background: Rectangle {
                    color: parent.down ? "#d6d6d6" : "#f6f6f6"
                    border.color: "#707070"
                    border.width: 1
                    radius: 5
                }
                contentItem: Text {
                    text: parent.text
                    color: "#202020"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 14
                }
                onClicked: stackView.pop()
            }
        }
    }

    ListModel {
        id: ordermodel
        // Will be populated from database
    }
    
    // Function to filter orders based on search criteria
    function filterOrders() {
        // If all filters are empty, reload full data
        if (searchField.text === "" && searchField1.text === "" && paymentFilter.currentText === "All") {
            dbManager.getOrdersList();
            return;
        }
        
        // Filter local model
        let filteredData = [];
        for (let i = 0; i < ordermodel.count; i++) {
            let item = ordermodel.get(i);
            let medNameMatch = item.medicineName.toLowerCase().includes(searchField.text.toLowerCase());
            let customerMatch = item.customerName.toLowerCase().includes(searchField1.text.toLowerCase());
            let paymentMatch = paymentFilter.currentText === "All" || 
                              (paymentFilter.currentText === item.paymentMethod);
            
            if ((searchField.text === "" || medNameMatch) && 
                (searchField1.text === "" || customerMatch) &&
                (paymentFilter.currentText === "All" || paymentMatch)) {
                filteredData.push(item);
            }
        }
        
        // Update model with filtered data
        ordermodel.clear();
        for (let i = 0; i < filteredData.length; i++) {
            ordermodel.append(filteredData[i]);
        }
    }
}