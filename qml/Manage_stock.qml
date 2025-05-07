import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQml 2.15

Item {
    id: root
    anchors.fill: parent

    // Property to hold the database model
    property var stockdata: []

    function loadStock() {
        // Call the C++ function to get stock data
        stockdata = dbManager.getStockInfo();
        // Update the model with the retrieved data
        updateStockModel();
    }

    function updateStockModel() {
        medicineModel.clear();
        for (var i = 0; i < stockdata.length; i++) {
            medicineModel.append({
                medicine_id: stockdata[i].medicine_id,
                name: stockdata[i].name,
                quantity: stockdata[i].quantity,
                price: stockdata[i].price,
                supplier: stockdata[i].supplier,
                expiry_date: stockdata[i].expiry_date,
                isEditable: false
            });
        }
    }

    // Load data when component is completed
    Component.onCompleted: {
        loadStock();
    }

    Rectangle {
        id: bgrectangle
        color: "#daeae6"
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent
            spacing: 50

            Text {
                id: managestock
                color: "#5b99d6"
                text: qsTr("Stock Management")
                font.pixelSize: 30
                anchors.horizontalCenter: parent.horizontalCenter
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
                    placeholderText: "Search medicine..."
                    Layout.preferredWidth: 400
                    Layout.preferredHeight: 40
                }

                Button {
                    width: 60
                    height: 30
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
                        // Filter by medicine name
                        if (searchField.text.trim() !== "") {
                            var filteredStocks = dbManager.searchMedicine(searchField.text);

                            medicineModel.clear();
                            for (var j = 0; j < filteredStocks.length; j++) {
                                medicineModel.append({
                                    medicine_id: filteredStocks[j].medicine_id,
                                    name: filteredStocks[j].name,
                                    quantity: filteredStocks[j].quantity,
                                    price: filteredStocks[j].price,
                                    supplier: filteredStocks[j].supplier,
                                    expiry_date: filteredStocks[j].expiry_date,
                                    isEditable: false
                                });
                            }
                        } else {
                            // If search field is empty, show all data
                            loadStock();
                        }
                    }
                }

                Item {
                    width: 50
                    height: 1
                }

                TextField {
                    id: searchField1
                    placeholderText: "Search supplier..."
                    Layout.preferredWidth: 400
                    Layout.preferredHeight: 40
                }

                Button {
                    width: 60
                    text: "Search"
                    height: 30
                    background: Rectangle {
                        color: "#89ced4"
                        radius: 40
                    }
                    contentItem: Text {
                        color: "#000000"
                        text: parent.text
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: 10
                    }
                    onClicked: {
                        // Filter by supplier
                        if (searchField1.text.trim() !== "") {
                            var filteredStocks = dbManager.searchSupplier(searchField1.text);

                            medicineModel.clear();
                            for (var j = 0; j < filteredStocks.length; j++) {
                                medicineModel.append({
                                    medicine_id: filteredStocks[j].medicine_id,
                                    name: filteredStocks[j].name,
                                    quantity: filteredStocks[j].quantity,
                                    price: filteredStocks[j].price,
                                    supplier: filteredStocks[j].supplier,
                                    expiry_date: filteredStocks[j].expiry_date,
                                    isEditable: false
                                });
                            }
                        } else {
                            // If search field is empty, show all data
                            loadStock();
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
                    Layout.preferredHeight: 40
                    color: "#89ced4"
                    border.color: "black"
                    border.width: 1

                    Grid {
                        columns: 6
                        columnSpacing: 10
                        rowSpacing: 5
                        width: parent.width
                        anchors.verticalCenter: parent.verticalCenter

                        Text { text: "Stock ID"; width: 180; horizontalAlignment: Text.AlignHCenter; font.bold: true }
                        Text { text: "Medicine Name"; width: 170; horizontalAlignment: Text.AlignHCenter; font.bold: true }
                        Text { text: "Quantity"; width: 90; horizontalAlignment: Text.AlignHCenter; font.bold: true }
                        Text { text: "Price per Unit"; width: 120; horizontalAlignment: Text.AlignHCenter; font.bold: true }
                        Text { text: "Supplier"; width: 190; horizontalAlignment: Text.AlignHCenter; font.bold: true }
                        Text { text: "Expiry Date"; width: 170; horizontalAlignment: Text.AlignHCenter; font.bold: true }
                    }
                }

                ScrollView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 400
                    clip: true

                    ListView {
                        id: tableView
                        width: parent.width
                        model: medicineModel
                        boundsBehavior: Flickable.StopAtBounds

                        delegate: Rectangle {
                            width: tableView.width
                            height: 40
                            border.color: "black"
                            border.width: 1

                            Row {
                                anchors.fill: parent
                                spacing: 0

                                property bool editable: model.isEditable

                                Rectangle {
                                    width: 180
                                    height: parent.height
                                    border.color: "black"
                                    TextInput {
                                        id: idInput
                                        anchors.centerIn: parent
                                        text: model.medicine_id
                                        horizontalAlignment: Text.AlignHCenter
                                        readOnly: !model.isEditable
                                    }
                                }

                                Rectangle {
                                    width: 180
                                    height: parent.height
                                    border.color: "black"
                                    TextInput {
                                        id: nameInput
                                        anchors.centerIn: parent
                                        text: model.name
                                        horizontalAlignment: Text.AlignHCenter
                                        readOnly: !model.isEditable
                                    }
                                }

                                Rectangle {
                                    width: 105
                                    height: parent.height
                                    border.color: "black"
                                    TextInput {
                                        id: quantityInput
                                        anchors.centerIn: parent
                                        text: model.quantity
                                        horizontalAlignment: Text.AlignHCenter
                                        readOnly: !model.isEditable
                                    }
                                }

                                Rectangle {
                                    width: 140
                                    height: parent.height
                                    border.color: "black"
                                    TextInput {
                                        id: priceInput
                                        anchors.centerIn: parent
                                        text: model.price
                                        horizontalAlignment: Text.AlignHCenter
                                        readOnly: !model.isEditable
                                    }
                                }

                                Rectangle {
                                    width: 190
                                    height: parent.height
                                    border.color: "black"
                                    TextInput {
                                        id: supplierInput
                                        anchors.centerIn: parent
                                        text: model.supplier
                                        horizontalAlignment: Text.AlignHCenter
                                        readOnly: !model.isEditable
                                    }
                                }

                                Rectangle {
                                    width: 180
                                    height: parent.height
                                    border.color: "black"
                                    TextInput {
                                        id: expiryInput
                                        anchors.centerIn: parent
                                        text: model.expiry_date
                                        horizontalAlignment: Text.AlignHCenter
                                        readOnly: !model.isEditable
                                    }
                                }

                                Button {
                                    width: 85
                                    height: parent.height
                                    text: model.isEditable ? "Save" : "Edit"
                                    onClicked: {
                                        if (model.isEditable) {
                                            // Save changes to the database
                                            var medId = idInput.text;
                                            var updatedName = nameInput.text;
                                            var updatedQuantity = quantityInput.text;
                                            var updatedPrice = priceInput.text;
                                            var updatedSupplier = supplierInput.text;
                                            var updatedExpiry = expiryInput.text;

                                            var success = dbManager.updateStock(
                                                parseInt(medId),
                                                updatedName,
                                                updatedSupplier,
                                                parseFloat(updatedPrice),
                                                updatedExpiry,
                                                parseInt(updatedQuantity)
                                            );

                                            if (success) {
                                                // Update model
                                                medicineModel.set(index, {
                                                    "medicine_id": medId,
                                                    "name": updatedName,
                                                    "quantity": updatedQuantity,
                                                    "price": updatedPrice,
                                                    "supplier": updatedSupplier,
                                                    "expiry_date": updatedExpiry,
                                                    "isEditable": false
                                                });

                                                // Refresh data from database
                                                loadStock();
                                            } else {
                                                console.log("Failed to update stock in database");
                                            }
                                        } else {
                                            // Enable editing
                                            medicineModel.setProperty(index, "isEditable", true);
                                        }
                                    }
                                }

                                Button {
                                    width: 85
                                    height: parent.height
                                    text: "Delete"
                                    Material.background: "#d84c4c"
                                    contentItem: Text {
                                        text: parent.text
                                        color: "white"
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    onClicked: {
                                        // Call C++ function to delete from database
                                        var medicineId = model.medicine_id;
                                        var success = dbManager.deleteStock(parseInt(medicineId));

                                        if (success) {
                                            // Remove from model
                                            medicineModel.remove(index);
                                            // Refresh data from database
                                            loadStock();
                                        } else {
                                            console.log("Failed to delete medicine from database");
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Button {
                id: addStockButton
                Layout.preferredWidth: 140
                Layout.preferredHeight: 40
                text: "Add Stock"
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 20
                anchors.rightMargin: 150
                z: 10
                background: Rectangle {
                    color: "#fa086960"
                    radius: 5
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: addstockDialog.open()
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

        Dialog {
            id: addstockDialog
            title: "Add New Stock"
            modal: true
            standardButtons: Dialog.Ok | Dialog.Cancel

            Column {
                spacing: 10
                width: 300

                TextField { id: newName; placeholderText: "Name" }
                TextField { id: newQuantity; placeholderText: "Quantity" }
                TextField { id: newPrice; placeholderText: "Price" }
                TextField { id: newSupplier; placeholderText: "Supplier Name" }
                TextField { id: newExpiry; placeholderText: "Expiry Date (YYYY-MM-DD)" }
            }

            onAccepted: {
                var success = dbManager.addStockInfo(
                    newName.text,
                    newSupplier.text,
                    newPrice.text,
                    newExpiry.text,
                    newQuantity.text
                );

                if(success) {
                    loadStock();
                    // Clear fields
                    newName.text = "";
                    newQuantity.text = "";
                    newPrice.text = "";
                    newSupplier.text = "";
                    newExpiry.text = "";
                } else {
                    console.log("Failed to add stock to database");
                }
            }
        }

        ListModel {
            id: medicineModel
            // This will be populated from the database
        }
    }
}
