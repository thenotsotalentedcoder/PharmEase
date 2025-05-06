import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQml 2.15

Item {
    id: root
    anchors.fill: parent

    // Property to hold the database model
    property var stockModel: []

    // Connect to C++ signals
    Connections {
        target: dbManager // This should be your database manager object exposed to QML

        // When data is loaded from database
        function onStockDataLoaded(stockData) {
            medicineModel.clear()
            for (var i = 0; i < stockData.length; i++) {
                medicineModel.append(stockData[i])
            }
        }

        // When a stock item is added successfully
        function onStockAdded(success) {
            if (success) {
                // Refresh the data
                dbManager.getStockInfo()
            } else {
                // Show error message
                errorDialog.open()
            }
        }

        // When a stock item is updated
        function onStockUpdated(success) {
            if (success) {
                // Refresh the data
                dbManager.getStockInfo()
            } else {
                // Show error message
                errorDialog.open()
            }
        }

        // When a stock item is deleted
        function onStockDeleted(success) {
            if (success) {
                // Refresh the data
                dbManager.getStockInfo()
            } else {
                // Show error message
                errorDialog.open()
            }
        }
    }

    // Load data when component completes
    Component.onCompleted: {
        // Load stock data from database
        dbManager.getStockInfo()
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
                    onTextChanged: {
                        dbManager.searchMedicine(searchField.text)
                    }
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
                    onClicked: dbManager.searchMedicine(searchField.text)
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
                    onTextChanged: {
                        dbManager.searchSupplier(searchField1.text)
                    }
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
                    onClicked: dbManager.searchSupplier(searchField1.text)
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

                        Text { text: "Medicine ID"; width: 180; horizontalAlignment: Text.AlignHCenter; font.bold: true }
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
                                            dbManager.updateStock(
                                                idInput.text,
                                                nameInput.text,
                                                quantityInput.text,
                                                priceInput.text,
                                                supplierInput.text,
                                                expiryInput.text
                                            )
                                        }
                                        medicineModel.setProperty(index, "isEditable", !model.isEditable)
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
                                        deleteConfirmDialog.medicineId = model.medicine_id
                                        deleteConfirmDialog.open()
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
                onClicked: stockDialog.open()
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
            id: stockDialog
            title: "Add New Stock"
            modal: true
            standardButtons: Dialog.Ok | Dialog.Cancel

            Column {
                spacing: 10
                width: 300

                TextField { id: newId; placeholderText: "Medicine ID" }
                TextField { id: newName; placeholderText: "Name" }
                TextField { id: newQuantity; placeholderText: "Quantity" }
                TextField { id: newPrice; placeholderText: "Price" }
                TextField { id: newSupplier; placeholderText: "Supplier Name" }
                TextField { id: newExpiry; placeholderText: "Expiry Date (YYYY-MM-DD)" }
            }

            onAccepted: {
                // Call the database function to add stock
                dbManager.addStockInfo(
                    parseInt(newId.text),
                    newName.text,
                    newSupplier.text,
                    parseFloat(newPrice.text),
                    newExpiry.text,
                    parseInt(newQuantity.text)
                )

                // Clear fields
                newId.text = ""
                newName.text = ""
                newQuantity.text = ""
                newPrice.text = ""
                newSupplier.text = ""
                newExpiry.text = ""
            }
        }

        // Dialog {
        //     id: deleteConfirmDialog
        //     title: "Confirm Delete"
        //     text: "Are you sure you want to delete this item?"
        //     modal: true
        //     property int medicineId: -1
        //     standardButtons: Dialog.Yes | Dialog.No

        //     onAccepted: {
        //         // Call database function to delete the stock item
        //         dbManager.deleteStock(medicineId)
        //     }
        // }

        // Dialog {
        //     id: errorDialog
        //     title: "Error"
        //     text: "An error occurred during the database operation."
        //     modal: true
        //     standardButtons: Dialog.Ok
        // }

        ListModel {
            id: medicineModel
            // This will be populated from the database
        }
    }
}
