import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    width: 1920
    height: 1080
    visible: true

    function calculateTotal() {
        var total = 0;
        for (var i = 0; i < orderListModel.count; i++) {
            var item = orderListModel.get(i);
            total += item.price * item.quantity;
        }
        return total;
    }

    property int currentTotal: calculateTotal()
    property int discountAmount: 0
    property int discountedTotal: currentTotal - (currentTotal * discountAmount / 100)

    Connections {
        target: orderListModel
        onDataChanged: currentTotal = calculateTotal()
        onRowsInserted: currentTotal = calculateTotal()
        onRowsRemoved: currentTotal = calculateTotal()
    }

    Rectangle {
        id: rectangle
        anchors.fill: parent
        color: "#daeae6"

        Text {
            text: "Place Order"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 814
            anchors.rightMargin: 814
            y: 50
            font.pixelSize: 50
            font.bold: true
            font.family: "Tahoma"
        }

        Rectangle {
            id: medicineSelection
            x: 100
            y: 130
            width: 750
            height: 550
            color: "white"
            border.color: "black"
            radius: 10

            Text {
                text: "Search Medicine:"
                x: 20
                y: 42
                font.pixelSize: 25
            }

            TextField {
                id: medicineSearch
                x: 222
                y: 34
                width: 392
                height: 50
                placeholderText: "Enter medicine name..."
            }

            Button {
                text: "Search"
                x: 628
                y: 34
                width: 100
                height: 50
                onClicked: {
                    console.log("Searching for: " + medicineSearch.text)
                }
            }

            ListView {
                id: medicineList
                x: 20
                y: 100
                width: 700
                height: 410
                model: ListModel {
                    ListElement { medID: "M001"; name: "Paracetamol"; price: "200" }
                    ListElement { medID: "M002"; name: "Ibuprofen"; price: "250" }
                    ListElement { medID: "M003"; name: "Aspirin"; price: "150" }
                    ListElement { medID: "M004"; name: "Polyfex"; price: "300" }
                    ListElement { medID: "M005"; name: "Entamizol"; price: "350" }
                    ListElement { medID: "M006"; name: "Cough Syrup"; price: "150" }
                }
                delegate: Row {
                    spacing: 15
                    padding: 5
                    Rectangle {
                        width: 590
                        height: 40
                        color: "lightgray"
                        Text { text: model.name + " (Rs." + model.price + ")"; anchors.centerIn: parent; font.pixelSize: 20  }
                    }
                    Button {
                        height: 40
                        text: "Add"
                        onClicked: {
                            var found = false
                            for (var i = 0; i < orderListModel.count; i++) {
                                if (orderListModel.get(i).name === model.name) {
                                    orderListModel.set(i, { name: model.name, price: model.price, quantity: orderListModel.get(i).quantity + 1 })
                                    found = true
                                    break
                                }
                            }
                            if (!found) {
                                orderListModel.append({ name: model.name, price: model.price, quantity: 1 })
                            }
                            updateTotalPrice()
                        }
                    }
                }
            }
        }

        Rectangle {
            id: orderList
            x: 900
            y: 130
            width: 700
            height: 550
            color: "white"
            border.color: "black"
            radius: 10

            Text {
                text: "Order List:"
                x: 20
                y: 20
                height: 25
                font.pixelSize: 25
            }

            ListModel { id: orderListModel }

            ListView {
                id: orderListView
                x: 20
                y: 75
                width: 650
                height: 400
                model: orderListModel

                delegate: Row {
                    spacing: 15
                    padding: 5
                    Rectangle {
                        width: 300
                        height: 40
                        color: "lightgray"
                        Text { text: model.name + " (Rs." + model.price + " x " + model.quantity + ")"; anchors.centerIn: parent }
                    }
                    Button {
                        text: "+"
                        height: 40
                        onClicked: {
                            orderListModel.setProperty(index, "quantity", orderListModel.get(index).quantity + 1);
                        }
                    }
                    Button {
                        text: "-"
                        height: 40
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
                        height: 40
                        onClicked: {
                            orderListModel.remove(index)
                            updateTotalPrice()
                        }
                    }
                }
            }

            Text {
                id: totalPrice
                x: 28
                y: 500
                font.pixelSize: 25
                text: "Total: Rs. " + currentTotal
            }
        }

        Rectangle {
            id: customerDetails
            x: 100
            y: 700
            width: 750
            height: 300
            color: "white"
            border.color: "black"
            radius: 10

            Text {
                text: "Customer Details:"
                x: 20
                y: 20
                font.pixelSize: 25
            }

            TextField {
                id: customerSearch
                x: 20
                y: 70
                width: 565
                height: 50
                placeholderText: "Search Customer by Name/ID..."
            }

            Text {
                id: notFoundMessage
                text: "Customer Not Found"
                x: 20
                y: 126
                color: "red"
                font.pixelSize: 18
                visible: false
            }

            Text {
                  id: actionMessage
                  x: 20
                  y: 126
                  font.pixelSize: 18
                  visible: false
                  color: "green"
            }

            ListModel {
               id: customerListModel
               ListElement { name: "John Doe"; phone: "1234567890" }
               ListElement { name: "Jane Smith"; phone: "0987654321" }
            }

            property bool customerFound: false

            Button {
                text: "Search"
                x: 600
                y: 70
                width: 80
                height: 50
                onClicked: {
                    var found = false;
                    for (var i = 0; i < customerListModel.count; i++) {
                        if (customerListModel.get(i).name.toLowerCase().includes(customerSearch.text.toLowerCase()) ||
                            customerListModel.get(i).phone.includes(customerSearch.text)) {
                            found = true;
                            break;
                        }
                    }
                    notFoundMessage.visible = !found;

                    if (found) {
                        for (i = 0; i < customerListModel.count; i++) {
                            if (customerListModel.get(i).name.toLowerCase().includes(customerSearch.text.toLowerCase()) ||
                                customerListModel.get(i).phone.includes(customerSearch.text)) {
                                customerName.text = customerListModel.get(i).name;
                                customerPhone.text = customerListModel.get(i).phone;
                                break;
                            }
                        }
                    }
                }
            }

            TextField {
                id: customerName
                x: 20
                y: 166
                width: 300
                placeholderText: "Customer Name"
                visible: notFoundMessage.visible
            }

            TextField {
                id: customerPhone
                x: 356
                y: 166
                width: 300
                placeholderText: "Phone Number"
                visible: notFoundMessage.visible
            }

            Button {
                text: "Save Customer"
                x: 20
                y: 220
                width: 200
                height: 50
                enabled: customerName.text !== "" && customerPhone.text !== ""
                onClicked: {
                    customerListModel.append({ name: customerName.text, phone: customerPhone.text });
                    notFoundMessage.visible = false;
                }
                visible: notFoundMessage.visible
            }

        }

        Rectangle {
            id: paymentProcessing
            x: 900
            y: 700
            width: 700
            height: 300
            color: "white"
            border.color: "black"
            radius: 10

            Text {
                text: "Apply Discount:"
                x: 20
                y: 20
                font.pixelSize: 25
            }

            TextField {
                id: discountField
                x: 225
                y: 12
                width: 250
                height: 50
                placeholderText: "Enter discount amount..."
                validator: IntValidator { bottom: 0; top: 100 }
                inputMethodHints: Qt.ImhDigitsOnly
            }

            Button {
                text: "Apply"
                x: 509
                y: 12
                height: 50
                onClicked: {
                    if (discountField.text !== "") {
                        root.discountAmount = parseInt(discountField.text);
                        console.log("Discount applied:", root.discountAmount + "%");
                    }
                }
            }

            Text {
                id: originalTotal
                x: 20
                y: 200
                font.pixelSize: 20
                text: "Total Payable: Rs. " + currentTotal
                visible: discountAmount > 0
            }

            Text {
                id: discountDisplay
                x: 20
                y: 80
                font.pixelSize: 20
                text: "Discount: " + discountAmount + "% (-Rs. " + (currentTotal * discountAmount / 100) + ")"
                visible: discountAmount > 0
            }

            Text {
                id: totalAmount
                x: 20
                y: 140
                font.pixelSize: 25
                text: "Total Payable: Rs. " + (discountAmount > 0 ? discountedTotal : currentTotal)
            }
        }

        Button {
            text: "Place Order"
            font.pixelSize: 25
            x: 1650
            y: 550
            width: 200
            height: 70
            background: Rectangle {
                color: "#4f9c9c"
                radius: 15
            }
            onClicked: {
                if (orderListModel.count > 0) {
                    billPopup.open();
                } else {
                    messagePopup.text = "Please add items to order";
                    messagePopup.open();
                }
            }
        }

        Popup {
            id: billPopup
            x: 560
            y: 240
            width: 800
            height: 600
            modal: true
            focus: true

            Rectangle {
                anchors.fill: parent
                color: "white"
                border.color: "black"
                radius: 10

                Flickable {
                    anchors.fill: parent
                    contentHeight: billContent.height + 40
                    clip: true

                    Column {
                        id: billContent
                        width: parent.width
                        spacing: 10
                        padding: 20

                        Text {
                            text: "INVOICE"
                            font.pixelSize: 30
                            font.bold: true
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Text {
                            text: "Customer: " + (customerName.text || "Walk-in Customer")
                            font.pixelSize: 20
                        }

                        Text {
                            text: "Date: " + Qt.formatDateTime(new Date(), "dd-MM-yyyy hh:mm")
                            font.pixelSize: 20
                        }

                        Rectangle {
                            width: parent.width - 40
                            height: 2
                            color: "black"
                        }

                        Repeater {
                            model: orderListModel
                            delegate: Row {
                                width: parent.width - 40
                                spacing: 20

                                Text {
                                    width: 400
                                    text: model.name
                                    font.pixelSize: 18
                                }

                                Text {
                                    width: 100
                                    text: "Rs. " + model.price
                                    font.pixelSize: 18
                                }

                                Text {
                                    width: 50
                                    text: "x" + model.quantity
                                    font.pixelSize: 18
                                }

                                Text {
                                    width: 100
                                    text: "Rs. " + (model.price * model.quantity)
                                    font.pixelSize: 18
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width - 40
                            height: 2
                            color: "black"
                        }

                        Text {
                            text: "Subtotal: Rs. " + currentTotal
                            font.pixelSize: 20
                        }

                        Text {
                            text: "Discount: " + discountAmount + "% (-Rs. " + (currentTotal * discountAmount / 100) + ")"
                            font.pixelSize: 20
                            visible: discountAmount > 0
                        }

                        Text {
                            text: "Total Payable: Rs. " + (discountAmount > 0 ? discountedTotal : currentTotal)
                            font.pixelSize: 22
                            font.bold: true
                        }
                    }
                }

                Button {
                    text: "Proceed to Payment"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 20
                    width: 200
                    height: 50
                    onClicked: {
                        billPopup.close();
                        paymentMethodPopup.open();
                    }
                }
            }
        }

        Popup {
            id: paymentMethodPopup
            x: 760
            y: 440
            width: 400
            height: 200
            modal: true
            focus: true

            Rectangle {
                anchors.fill: parent
                color: "white"
                border.color: "black"
                radius: 10

                Column {
                    anchors.centerIn: parent
                    spacing: 20

                    Text {
                        text: "Select Payment Method"
                        font.pixelSize: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    ComboBox {
                        id: paymentMethod
                        width: 200
                        model: ["Cash", "Card", "Online"]
                    }

                    Button {
                        text: "Confirm Payment"
                        width: 200
                        height: 40
                        onClicked: {
                            paymentMethodPopup.close();
                            messagePopup.text = "Order Placed Successfully!";
                            messagePopup.open();

                            orderListModel.clear();
                            currentTotal = 0;
                            discountAmount = 0;
                            discountField.text = "";
                            customerName.text = "";
                            customerPhone.text = "";
                        }
                    }
                }
            }
        }

        Popup {
            id: messagePopup
            x: 760
            y: 440
            width: 400
            height: 200
            modal: true
            focus: true
            property alias text: messageText.text
            Rectangle {
                anchors.fill: parent
                color: "white"
                border.color: "black"
                radius: 10

                Text {
                    id: messageText
                    text: "Order Placed Successfully!"
                    anchors.centerIn: parent
                    font.pixelSize: 20
                    font.bold: true
                }
            }
        }

        function updateTotalPrice() {
            currentTotal = calculateTotal();
        }
    }

    Button {
        id: backbutton
        x: 1800
        y: 960
        width: 95
        height: 45
        text: "Back"
        anchors.margins: 20
        anchors.rightMargin: 8
        anchors.bottomMargin: 50
        onClicked: stackView.pop()

        background: Rectangle {
               color: "lightgray"
               radius: 0
        }
    }

}



