import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    anchors.fill: parent
    property StackView stackView: null
    
    // Track order data
    property int currentOrderId: -1
    property var currentCustomer: null
    property double currentTotal: calculateTotal()
    property double discountAmount: 0
    property double discountedTotal: currentTotal - (currentTotal * discountAmount / 100)
    
    // Connect to database signals
    Connections {
        target: dbManager
        
        function onMedicineListLoaded(medicineList) {
            medicineModel.clear();
            for (var i = 0; i < medicineList.length; i++) {
                medicineModel.append(medicineList[i]);
            }
        }
        
        function onOrderPlaced(success, orderId) {
            if (success) {
                currentOrderId = orderId;
                messagePopup.text = "Order started successfully!";
                messagePopup.open();
            } else {
                messagePopup.text = "Failed to start order.";
                messagePopup.open();
            }
        }
    }
    
    // Load medicine data when component loads
    Component.onCompleted: {
        dbManager.getMedicineList();
    }
    
    // Calculate total price of items in order
    function calculateTotal() {
        var total = 0;
        for (var i = 0; i < orderListModel.count; i++) {
            var item = orderListModel.get(i);
            total += parseFloat(item.price) * item.quantity;
        }
        return total;
    }
    
    // Update when order changes
    Connections {
        target: orderListModel
        function onDataChanged() { currentTotal = calculateTotal(); }
        function onRowsInserted() { currentTotal = calculateTotal(); }
        function onRowsRemoved() { currentTotal = calculateTotal(); }
    }

    Rectangle {
        id: rectangle
        anchors.fill: parent
        color: "#daeae6"

        Text {
            text: "Place Order"
            anchors.horizontalCenter: parent.horizontalCenter
            y: 50
            font.pixelSize: 40
            font.bold: true
            font.family: "Tahoma"
            color: "#333333"
        }

        // Medicine selection panel
        Rectangle {
            id: medicineSelection
            x: 100
            y: 130
            width: 750
            height: 550
            color: "white"
            border.color: "#cccccc"
            radius: 10
            
            // Title
            Rectangle {
                id: medicineSelectionHeader
                width: parent.width
                height: 50
                color: "#4f9c9c"
                radius: 10
                
                Text {
                    text: "Medicine Selection"
                    anchors.centerIn: parent
                    font.pixelSize: 20
                    font.bold: true
                    color: "white"
                }
                
                // To ensure only top corners are rounded
                Rectangle {
                    width: parent.width
                    height: parent.height / 2
                    anchors.bottom: parent.bottom
                    color: parent.color
                }
            }

            // Search field
            Text {
                text: "Search Medicine:"
                x: 20
                y: 70
                font.pixelSize: 16
            }

            TextField {
                id: medicineSearch
                x: 160
                y: 65
                width: 450
                height: 40
                placeholderText: "Enter medicine name..."
                onTextChanged: {
                    if (text.length > 2) {
                        filterMedicines();
                    } else if (text.length === 0) {
                        dbManager.getMedicineList();
                    }
                }
            }

            Button {
                text: "Search"
                x: 620
                y: 65
                width: 100
                height: 40
                background: Rectangle {
                    color: "#4f9c9c"
                    radius: 5
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                }
                onClicked: filterMedicines()
            }

            ListView {
                id: medicineList
                x: 20
                y: 120
                width: 710
                height: 410
                clip: true
                model: medicineModel
                
                delegate: Rectangle {
                    width: medicineList.width
                    height: 50
                    color: index % 2 === 0 ? "#f5f5f5" : "white"
                    border.color: "#e0e0e0"
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 5
                        spacing: 10
                        
                        Text {
                            text: model.name + " (Rs." + model.price + ")"
                            font.pixelSize: 16
                            Layout.fillWidth: true
                            Layout.leftMargin: 10
                        }
                        
                        Text {
                            text: "Available: " + model.available
                            font.pixelSize: 14
                            color: parseInt(model.available) > 10 ? "#4CAF50" : "#FF9800"
                            Layout.preferredWidth: 100
                            horizontalAlignment: Text.AlignRight
                        }
                        
                        Button {
                            text: "Add"
                            Layout.preferredWidth: 80
                            Layout.preferredHeight: 35
                            Layout.rightMargin: 10
                            background: Rectangle {
                                color: "#4CAF50"
                                radius: 5
                            }
                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                            }
                            onClicked: {
                                var found = false
                                for (var i = 0; i < orderListModel.count; i++) {
                                    if (orderListModel.get(i).name === model.name) {
                                        orderListModel.set(i, { 
                                            name: model.name, 
                                            price: model.price, 
                                            quantity: orderListModel.get(i).quantity + 1,
                                            medID: model.medID 
                                        })
                                        found = true
                                        break
                                    }
                                }
                                if (!found) {
                                    orderListModel.append({ 
                                        name: model.name, 
                                        price: model.price, 
                                        quantity: 1,
                                        medID: model.medID 
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }

        // Order list panel
        Rectangle {
            id: orderList
            x: 900
            y: 130
            width: 700
            height: 550
            color: "white"
            border.color: "#cccccc"
            radius: 10
            
            // Title
            Rectangle {
                id: orderListHeader
                width: parent.width
                height: 50
                color: "#4f9c9c"
                radius: 10
                
                Text {
                    text: "Order List"
                    anchors.centerIn: parent
                    font.pixelSize: 20
                    font.bold: true
                    color: "white"
                }
                
                // To ensure only top corners are rounded
                Rectangle {
                    width: parent.width
                    height: parent.height / 2
                    anchors.bottom: parent.bottom
                    color: parent.color
                }
            }

            // Order items list
            ListView {
                id: orderListView
                x: 20
                y: 75
                width: 660
                height: 400
                clip: true
                model: orderListModel

                delegate: Rectangle {
                    width: orderListView.width
                    height: 50
                    color: index % 2 === 0 ? "#f5f5f5" : "white"
                    border.color: "#e0e0e0"
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 5
                        spacing: 5
                        
                        Text {
                            text: model.name + " (Rs." + model.price + " x " + model.quantity + " = Rs." + (model.price * model.quantity) + ")"
                            font.pixelSize: 14
                            Layout.fillWidth: true
                            Layout.leftMargin: 10
                        }
                        
                        Button {
                            text: "+"
                            Layout.preferredWidth: 40
                            Layout.preferredHeight: 35
                            background: Rectangle {
                                color: "#4CAF50"
                                radius: 3
                            }
                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                            }
                            onClicked: {
                                orderListModel.setProperty(index, "quantity", orderListModel.get(index).quantity + 1);
                            }
                        }
                        
                        Button {
                            text: "-"
                            Layout.preferredWidth: 40
                            Layout.preferredHeight: 35
                            background: Rectangle {
                                color: "#FF5722"
                                radius: 3
                            }
                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                            }
                            onClicked: {
                                if (orderListModel.get(index).quantity > 1) {
                                    orderListModel.setProperty(index, "quantity", orderListModel.get(index).quantity - 1);
                                } else {
                                    orderListModel.remove(index);
                                }
                            }
                        }
                        
                        Button {
                            text: "Remove"
                            Layout.preferredWidth: 80
                            Layout.preferredHeight: 35
                            Layout.rightMargin: 5
                            background: Rectangle {
                                color: "#F44336"
                                radius: 3
                            }
                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                            }
                            onClicked: {
                                orderListModel.remove(index)
                            }
                        }
                    }
                }
            }

            // Total price display
            Rectangle {
                x: 20
                y: 485
                width: 660
                height: 50
                color: "#f0f0f0"
                border.color: "#d0d0d0"
                
                Text {
                    id: totalPrice
                    anchors.centerIn: parent
                    font.pixelSize: 20
                    font.bold: true
                    text: "Total: Rs. " + currentTotal.toFixed(2) + (discountAmount > 0 ? " (After " + discountAmount + "% Discount: Rs. " + discountedTotal.toFixed(2) + ")" : "")
                }
            }
        }

        // Customer details panel
        Rectangle {
            id: customerDetails
            x: 100
            y: 700
            width: 750
            height: 300
            color: "white"
            border.color: "#cccccc"
            radius: 10
            
            // Title
            Rectangle {
                id: customerDetailsHeader
                width: parent.width
                height: 50
                color: "#4f9c9c"
                radius: 10
                
                Text {
                    text: "Customer Details"
                    anchors.centerIn: parent
                    font.pixelSize: 20
                    font.bold: true
                    color: "white"
                }
                
                // To ensure only top corners are rounded
                Rectangle {
                    width: parent.width
                    height: parent.height / 2
                    anchors.bottom: parent.bottom
                    color: parent.color
                }
            }

            TextField {
                id: customerSearch
                x: 20
                y: 70
                width: 565
                height: 50
                placeholderText: "Search Customer by Name/ID..."
            }
            
            Button {
                text: "Search"
                x: 600
                y: 70
                width: 120
                height: 50
                background: Rectangle {
                    color: "#4f9c9c"
                    radius: 5
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                }
                onClicked: searchCustomer()
            }

            Text {
                id: notFoundMessage
                text: "Customer Not Found"
                x: 20
                y: 130
                color: "#F44336"
                font.pixelSize: 18
                visible: false
            }

            Text {
                id: actionMessage
                x: 20
                y: 130
                font.pixelSize: 18
                visible: false
                color: "#4CAF50"
            }
            
            // New customer form (shown when customer not found)
            Rectangle {
                id: newCustomerForm
                x: 20
                y: 160
                width: 710
                height: 120
                color: "#f5f5f5"
                border.color: "#e0e0e0"
                visible: notFoundMessage.visible
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10
                    
                    RowLayout {
                        spacing: 20
                        
                        TextField {
                            id: customerName
                            Layout.preferredWidth: 330
                            placeholderText: "Customer Name"
                        }
                        
                        TextField {
                            id: customerPhone
                            Layout.preferredWidth: 330
                            placeholderText: "Phone Number"
                        }
                    }
                    
                    Button {
                        text: "Save Customer"
                        Layout.preferredWidth: 150
                        Layout.preferredHeight: 40
                        enabled: customerName.text !== "" && customerPhone.text !== ""
                        background: Rectangle {
                            color: parent.enabled ? "#4CAF50" : "#cccccc"
                            radius: 5
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                        }
                        onClicked: saveNewCustomer()
                    }
                }
            }
            
            // Customer info display (shown when customer is found or created)
            Rectangle {
                id: customerInfoDisplay
                x: 20
                y: 160
                width: 710
                height: 120
                color: "#f5f5f5"
                border.color: "#e0e0e0"
                visible: false
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        id: customerDisplayName
                        font.pixelSize: 18
                        font.bold: true
                        text: "Customer Name: --"
                    }
                    
                    Text {
                        id: customerDisplayPhone
                        font.pixelSize: 18
                        text: "Phone: --"
                    }
                    
                    Text {
                        id: customerDisplayId
                        font.pixelSize: 18
                        text: "ID: --"
                    }
                }
            }
        }

        // Payment processing panel
        Rectangle {
            id: paymentProcessing
            x: 900
            y: 700
            width: 700
            height: 300
            color: "white"
            border.color: "#cccccc"
            radius: 10
            
            // Title
            Rectangle {
                id: paymentProcessingHeader
                width: parent.width
                height: 50
                color: "#4f9c9c"
                radius: 10
                
                Text {
                    text: "Payment Details"
                    anchors.centerIn: parent
                    font.pixelSize: 20
                    font.bold: true
                    color: "white"
                }
                
                // To ensure only top corners are rounded
                Rectangle {
                    width: parent.width
                    height: parent.height / 2
                    anchors.bottom: parent.bottom
                    color: parent.color
                }
            }

            ColumnLayout {
                x: 20
                y: 70
                width: 660
                spacing: 15
                
                RowLayout {
                    spacing: 20
                    
                    Text {
                        text: "Apply Discount:"
                        font.pixelSize: 18
                    }
                    
                    TextField {
                        id: discountField
                        Layout.preferredWidth: 150
                        Layout.preferredHeight: 40
                        placeholderText: "Discount %"
                        validator: IntValidator { bottom: 0; top: 100 }
                        inputMethodHints: Qt.ImhDigitsOnly
                    }
                    
                    Button {
                        text: "Apply"
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 40
                        background: Rectangle {
                            color: "#4f9c9c"
                            radius: 5
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                        }
                        onClicked: {
                            if (discountField.text !== "") {
                                root.discountAmount = parseInt(discountField.text);
                            }
                        }
                    }
                }
                
                Rectangle {
                    Layout.preferredWidth: 660
                    Layout.preferredHeight: 2
                    color: "#e0e0e0"
                    visible: discountAmount > 0
                }
                
                Text {
                    id: originalTotal
                    font.pixelSize: 18
                    text: "Subtotal: Rs. " + currentTotal.toFixed(2)
                }
                
                Text {
                    id: discountDisplay
                    font.pixelSize: 18
                    text: "Discount: " + discountAmount + "% (-Rs. " + (currentTotal * discountAmount / 100).toFixed(2) + ")"
                    visible: discountAmount > 0
                }
                
                Text {
                    id: totalAmount
                    font.pixelSize: 22
                    font.bold: true
                    text: "Total Payable: Rs. " + (discountAmount > 0 ? discountedTotal.toFixed(2) : currentTotal.toFixed(2))
                }
                
                // Payment method selection
                RowLayout {
                    Layout.topMargin: 20
                    spacing: 20
                    
                    Text {
                        text: "Payment Method:"
                        font.pixelSize: 18
                    }
                    
                    ComboBox {
                        id: paymentMethod
                        Layout.preferredWidth: 200
                        Layout.preferredHeight: 40
                        model: ["Cash", "Card", "Online"]
                    }
                }
            }
        }

        // Place order button
        Button {
            id: placeOrderButton
            text: "Place Order"
            font.pixelSize: 20
            font.bold: true
            x: 1650
            y: 550
            width: 200
            height: 70
            background: Rectangle {
                color: orderListModel.count > 0 ? "#4CAF50" : "#cccccc"
                radius: 10
            }
            contentItem: Text {
                text: parent.text
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
            }
            enabled: orderListModel.count > 0
            onClicked: {
                if (orderListModel.count > 0) {
                    if (customerInfoDisplay.visible) {
                        billPopup.open();
                    } else {
                        messagePopup.text = "Please add customer details first";
                        messagePopup.open();
                    }
                } else {
                    messagePopup.text = "Please add items to order";
                    messagePopup.open();
                }
            }
        }

        // Back button
        Button {
            id: backbutton
            x: 1800
            y: 960
            width: 100
            height: 45
            text: "Back"
            background: Rectangle {
                color: "lightgray"
                radius: 5
            }
            contentItem: Text {
                text: parent.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 14
            }
            onClicked: stackView.pop()
        }

        // Invoice popup
        Dialog {
            id: billPopup
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            width: 800
            height: 600
            modal: true
            focus: true
            title: "Invoice"

            contentItem: Rectangle {
                color: "white"
                
                Flickable {
                    anchors.fill: parent
                    contentHeight: billContent.height + 40
                    clip: true

                    ColumnLayout {
                        id: billContent
                        width: parent.width
                        anchors.top: parent.top
                        anchors.topMargin: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 15

                        Text {
                            text: "INVOICE"
                            font.pixelSize: 26
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }
                        
                        Rectangle {
                            Layout.preferredWidth: parent.width - 40
                            Layout.preferredHeight: 2
                            Layout.alignment: Qt.AlignHCenter
                            color: "#e0e0e0"
                        }

                        Text {
                            text: "Customer: " + customerDisplayName.text.replace("Customer Name: ", "")
                            font.pixelSize: 18
                            Layout.leftMargin: 20
                        }

                        Text {
                            text: "Date: " + Qt.formatDateTime(new Date(), "dd-MM-yyyy hh:mm")
                            font.pixelSize: 18
                            Layout.leftMargin: 20
                        }
                        
                        Text {
                            text: "Order ID: " + (currentOrderId > 0 ? currentOrderId : "To be generated")
                            font.pixelSize: 18
                            Layout.leftMargin: 20
                        }

                        Rectangle {
                            Layout.preferredWidth: parent.width - 40
                            Layout.preferredHeight: 2
                            Layout.alignment: Qt.AlignHCenter
                            color: "#e0e0e0"
                        }
                        
                        // Header row for invoice items
                        Rectangle {
                            Layout.preferredWidth: parent.width - 40
                            Layout.preferredHeight: 40
                            Layout.alignment: Qt.AlignHCenter
                            color: "#f5f5f5"
                            border.color: "#e0e0e0"
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 5
                                spacing: 5
                                
                                Text {
                                    text: "Item"
                                    font.pixelSize: 16
                                    font.bold: true
                                    Layout.preferredWidth: 350
                                    Layout.leftMargin: 10
                                }
                                
                                Text {
                                    text: "Price"
                                    font.pixelSize: 16
                                    font.bold: true
                                    Layout.preferredWidth: 100
                                    horizontalAlignment: Text.AlignRight
                                }
                                
                                Text {
                                    text: "Qty"
                                    font.pixelSize: 16
                                    font.bold: true
                                    Layout.preferredWidth: 80
                                    horizontalAlignment: Text.AlignRight
                                }
                                
                                Text {
                                    text: "Total"
                                    font.pixelSize: 16
                                    font.bold: true
                                    Layout.fillWidth: true
                                    horizontalAlignment: Text.AlignRight
                                    Layout.rightMargin: 10
                                }
                            }
                        }

                        // Items in order
                        Repeater {
                            model: orderListModel
                            delegate: Rectangle {
                                Layout.preferredWidth: billContent.width - 40
                                Layout.preferredHeight: 40
                                Layout.alignment: Qt.AlignHCenter
                                color: index % 2 === 0 ? "white" : "#f9f9f9"
                                border.color: "#e0e0e0"
                                
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 5
                                    spacing: 5
                                    
                                    Text {
                                        text: model.name
                                        font.pixelSize: 16
                                        Layout.preferredWidth: 350
                                        Layout.leftMargin: 10
                                        elide: Text.ElideRight
                                    }
                                    
                                    Text {
                                        text: "Rs. " + parseFloat(model.price).toFixed(2)
                                        font.pixelSize: 16
                                        Layout.preferredWidth: 100
                                        horizontalAlignment: Text.AlignRight
                                    }
                                    
                                    Text {
                                        text: model.quantity
                                        font.pixelSize: 16
                                        Layout.preferredWidth: 80
                                        horizontalAlignment: Text.AlignRight
                                    }
                                    
                                    Text {
                                        text: "Rs. " + (parseFloat(model.price) * model.quantity).toFixed(2)
                                        font.pixelSize: 16
                                        Layout.fillWidth: true
                                        horizontalAlignment: Text.AlignRight
                                        Layout.rightMargin: 10
                                    }
                                }
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: parent.width - 40
                            Layout.preferredHeight: 2
                            Layout.alignment: Qt.AlignHCenter
                            color: "#e0e0e0"
                        }
                        
                        // Summary section
                        Rectangle {
                            Layout.preferredWidth: parent.width - 40
                            Layout.preferredHeight: 40
                            Layout.alignment: Qt.AlignHCenter
                            color: "white"
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 5
                                
                                Item { Layout.fillWidth: true }
                                
                                Text {
                                    text: "Subtotal:"
                                    font.pixelSize: 16
                                    font.bold: true
                                    Layout.preferredWidth: 120
                                    horizontalAlignment: Text.AlignRight
                                }
                                
                                Text {
                                    text: "Rs. " + currentTotal.toFixed(2)
                                    font.pixelSize: 16
                                    Layout.preferredWidth: 120
                                    horizontalAlignment: Text.AlignRight
                                    Layout.rightMargin: 10
                                }
                            }
                        }
                        
                        // Discount row (if applicable)
                        Rectangle {
                            Layout.preferredWidth: parent.width - 40
                            Layout.preferredHeight: 40
                            Layout.alignment: Qt.AlignHCenter
                            color: "white"
                            visible: discountAmount > 0
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 5
                                
                                Item { Layout.fillWidth: true }
                                
                                Text {
                                    text: "Discount (" + discountAmount + "%):"
                                    font.pixelSize: 16
                                    font.bold: true
                                    Layout.preferredWidth: 120
                                    horizontalAlignment: Text.AlignRight
                                }
                                
                                Text {
                                    text: "-Rs. " + (currentTotal * discountAmount / 100).toFixed(2)
                                    font.pixelSize: 16
                                    color: "#4CAF50"
                                    Layout.preferredWidth: 120
                                    horizontalAlignment: Text.AlignRight
                                    Layout.rightMargin: 10
                                }
                            }
                        }
                        
                        // Total row
                        Rectangle {
                            Layout.preferredWidth: parent.width - 40
                            Layout.preferredHeight: 40
                            Layout.alignment: Qt.AlignHCenter
                            color: "#f5f5f5"
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 5
                                
                                Item { Layout.fillWidth: true }
                                
                                Text {
                                    text: "Total Payable:"
                                    font.pixelSize: 18
                                    font.bold: true
                                    Layout.preferredWidth: 120
                                    horizontalAlignment: Text.AlignRight
                                }
                                
                                Text {
                                    text: "Rs. " + (discountAmount > 0 ? discountedTotal.toFixed(2) : currentTotal.toFixed(2))
                                    font.pixelSize: 18
                                    font.bold: true
                                    Layout.preferredWidth: 120
                                    horizontalAlignment: Text.AlignRight
                                    Layout.rightMargin: 10
                                }
                            }
                        }
                    }
                }

                // Buttons at bottom of dialog
                RowLayout {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 20
                    
                    Button {
                        text: "Proceed to Payment"
                        Layout.preferredWidth: 200
                        Layout.preferredHeight: 50
                        background: Rectangle {
                            color: "#4CAF50"
                            radius: 5
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                        }
                        onClicked: {
                            billPopup.close();
                            finalizeOrder();
                        }
                    }
                    
                    Button {
                        text: "Cancel"
                        Layout.preferredWidth: 120
                        Layout.preferredHeight: 50
                        background: Rectangle {
                            color: "#F44336"
                            radius: 5
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                        }
                        onClicked: {
                            billPopup.close();
                        }
                    }
                }
            }
        }

        // Message popup for notifications
        Dialog {
            id: messagePopup
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            width: 400
            height: 200
            modal: true
            focus: true
            title: "Information"
            property alias text: messageText.text
            
            contentItem: Rectangle {
                color: "white"
                
                Text {
                    id: messageText
                    text: "Order Placed Successfully!"
                    anchors.centerIn: parent
                    font.pixelSize: 18
                    font.bold: true
                    wrapMode: Text.WordWrap
                    width: parent.width - 40
                    horizontalAlignment: Text.AlignHCenter
                }
                
                Button {
                    text: "OK"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 100
                    height: 40
                    background: Rectangle {
                        color: "#4f9c9c"
                        radius: 5
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.bold: true
                    }
                    onClicked: messagePopup.close()
                }
            }
        }
    }

    // Models
    ListModel {
        id: medicineModel
        // Will be populated from database
    }

    ListModel {
        id: orderListModel
        // Will be populated with selected medicines
    }

    ListModel {
        id: customerListModel
        // Sample customer data
        ListElement { name: "John Doe"; phone: "1234567890"; id: "C001" }
        ListElement { name: "Jane Smith"; phone: "0987654321"; id: "C002" }
    }
    
    // Function to filter medicine list based on search term
    function filterMedicines() {
        if (medicineSearch.text.trim() === "") {
            dbManager.getMedicineList();
            return;
        }
        
        // Filter based on the original data - this should be enhanced
        // to use a dedicated backend search
        var filteredMedicines = [];
        for (var i = 0; i < medicineModel.count; i++) {
            if (medicineModel.get(i).name.toLowerCase().includes(medicineSearch.text.toLowerCase())) {
                filteredMedicines.push(medicineModel.get(i));
            }
        }
        
        // Update displayed list with filtered medicines
        medicineModel.clear();
        for (var j = 0; j < filteredMedicines.length; j++) {
            medicineModel.append(filteredMedicines[j]);
        }
        
        // If no medicines found, display a message
        if (filteredMedicines.length === 0) {
            medicineModel.append({
                name: "No medicines found matching '" + medicineSearch.text + "'",
                price: "0",
                available: "0",
                medID: "-1"
            });
        }
    }
    
    // Function to search for a customer
    function searchCustomer() {
        if (customerSearch.text.trim() === "") {
            notFoundMessage.visible = false;
            customerInfoDisplay.visible = false;
            return;
        }
        
        let found = false;
        for (let i = 0; i < customerListModel.count; i++) {
            if (customerListModel.get(i).name.toLowerCase().includes(customerSearch.text.toLowerCase()) ||
                customerListModel.get(i).phone.includes(customerSearch.text) ||
                customerListModel.get(i).id.toLowerCase() === customerSearch.text.toLowerCase()) {
                found = true;
                
                // Display customer info
                customerDisplayName.text = "Customer Name: " + customerListModel.get(i).name;
                customerDisplayPhone.text = "Phone: " + customerListModel.get(i).phone;
                customerDisplayId.text = "ID: " + customerListModel.get(i).id;
                
                // Store current customer
                currentCustomer = {
                    name: customerListModel.get(i).name,
                    phone: customerListModel.get(i).phone,
                    id: customerListModel.get(i).id
                };
                
                break;
            }
        }
        
        notFoundMessage.visible = !found;
        customerInfoDisplay.visible = found;
    }
    
    // Function to save a new customer
    function saveNewCustomer() {
        if (customerName.text.trim() === "" || customerPhone.text.trim() === "") {
            return;
        }
        
        // Generate a customer ID
        let customerId = "C" + (customerListModel.count + 1).toString().padStart(3, "0");
        
        // Add to model
        customerListModel.append({
            name: customerName.text,
            phone: customerPhone.text,
            id: customerId
        });
        
        // Update display
        customerDisplayName.text = "Customer Name: " + customerName.text;
        customerDisplayPhone.text = "Phone: " + customerPhone.text;
        customerDisplayId.text = "ID: " + customerId;
        
        // Store current customer
        currentCustomer = {
            name: customerName.text,
            phone: customerPhone.text,
            id: customerId
        };
        
        // Show info display and hide not found message
        notFoundMessage.visible = false;
        customerInfoDisplay.visible = true;
        
        // Show success message
        actionMessage.text = "Customer added successfully!";
        actionMessage.visible = true;
        
        // Clear form
        customerName.text = "";
        customerPhone.text = "";
        
        // Hide action message after a delay
        actionMessageTimer.restart();
    }
    
    // Timer to hide action message
    Timer {
        id: actionMessageTimer
        interval: 3000
        onTriggered: actionMessage.visible = false
    }
    
    // Function to finalize order and process payment
    function finalizeOrder() {
        if (currentCustomer === null || orderListModel.count === 0) {
            messagePopup.text = "Cannot finalize order. Please check customer details and order items.";
            messagePopup.open();
            return;
        }
        
        // Start an order in the database if needed
        if (currentOrderId <= 0) {
            currentOrderId = dbManager.startOrder(currentCustomer.name);
            if (currentOrderId <= 0) {
                messagePopup.text = "Failed to create order in database.";
                messagePopup.open();
                return;
            }
        }
        
        // Add all items to the order
        let allItemsAdded = true;
        for (let i = 0; i < orderListModel.count; i++) {
            let item = orderListModel.get(i);
            let success = dbManager.addOrderDetails(
                currentOrderId,
                item.medID,
                item.quantity,
                parseFloat(item.price)
            );
            
            if (!success) {
                allItemsAdded = false;
                break;
            }
        }
        
        if (!allItemsAdded) {
            messagePopup.text = "Failed to add all items to order.";
            messagePopup.open();
            return;
        }
        
        // Finalize order
        let finalPrice = discountAmount > 0 ? discountedTotal : currentTotal;
        let success = dbManager.finalizeSale(
            currentOrderId, 
            paymentMethod.currentText,
            finalPrice
        );
        
        if (success) {
            messagePopup.text = "Order #" + currentOrderId + " completed successfully!";
            messagePopup.open();
            
            // Reset the form
            orderListModel.clear();
            currentOrderId = -1;
            currentCustomer = null;
            discountAmount = 0;
            discountField.text = "";
            customerSearch.text = "";
            notFoundMessage.visible = false;
            customerInfoDisplay.visible = false;
            
            // Refresh medicine list
            dbManager.getMedicineList();
        } else {
            messagePopup.text = "Failed to finalize order.";
            messagePopup.open();
        }
    }
}