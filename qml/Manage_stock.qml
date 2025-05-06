import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQml 2.15

Item {
    id: root
    anchors.fill: parent
    property StackView stackView: null

    // Property to hold the database model
    property var stockModel: []

    // Connect to C++ signals
    Connections {
        target: dbManager

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
                messageText.text = "Stock added successfully"
                messageText.color = "#4CAF50"
                messagePopup.open()
            } else {
                // Show error message
                messageText.text = "Failed to add stock"
                messageText.color = "#F44336"
                messagePopup.open()
            }
        }

        // When a stock item is updated
        function onStockUpdated(success) {
            if (success) {
                // Refresh the data
                dbManager.getStockInfo()
                messageText.text = "Stock updated successfully"
                messageText.color = "#4CAF50"
                messagePopup.open()
            } else {
                // Show error message
                messageText.text = "Failed to update stock"
                messageText.color = "#F44336"
                messagePopup.open()
            }
        }

        // When a stock item is deleted
        function onStockDeleted(success) {
            if (success) {
                // Refresh the data
                dbManager.getStockInfo()
                messageText.text = "Stock deleted successfully"
                messageText.color = "#4CAF50"
                messagePopup.open()
            } else {
                // Show error message
                messageText.text = "Failed to delete stock"
                messageText.color = "#F44336"
                messagePopup.open()
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
            spacing: 20

            Text {
                id: managestock
                color: "#5b99d6"
                text: qsTr("Stock Management")
                font.pixelSize: 30
                anchors.horizontalCenter: parent.horizontalCenter
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
                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 40
                    onTextChanged: {
                        if (text.length > 2) {
                            dbManager.searchMedicine(text)
                        }
                    }
                }
                
                Button {
                    text: "Search"
                    width: 100
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
                        font.pointSize: 10
                    }
                    onClicked: dbManager.searchMedicine(searchField.text)
                }
                
                Rectangle {
                    width: 20
                    height: 1
                    color: "transparent"
                }
                
                TextField {
                    id: searchField1
                    placeholderText: "Search supplier..."
                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 40
                    onTextChanged: {
                        if (text.length > 2) {
                            dbManager.searchSupplier(text)
                        }
                    }
                }
                
                Button {
                    text: "Search"
                    width: 100
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
                        font.pointSize: 10
                    }
                    onClicked: dbManager.searchSupplier(searchField1.text)
                }
                
                Button {
                    id: resetButton
                    text: "Reset"
                    width: 100
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
                        font.pointSize: 10
                    }
                    onClicked: {
                        searchField.text = ""
                        searchField1.text = ""
                        dbManager.getStockInfo()
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
                            text: "Medicine ID"
                            horizontalAlignment: Text.AlignHCenter 
                            font.bold: true
                            Layout.preferredWidth: 130
                        }
                        Text { 
                            text: "Medicine Name"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 170
                        }
                        Text { 
                            text: "Quantity"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 90
                        }
                        Text { 
                            text: "Price per Unit"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 120
                            }
                        Text { 
                            text: "Supplier"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 190
                        }
                        Text { 
                            text: "Expiry Date"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 130
                        }
                        Text { 
                            text: "Actions"
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
                        model: medicineModel
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

                                property bool editable: model.isEditable

                                Rectangle {
                                    Layout.preferredWidth: 130
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    TextInput {
                                        id: idInput
                                        anchors.centerIn: parent
                                        text: model.medicine_id
                                        horizontalAlignment: Text.AlignHCenter
                                        readOnly: !model.isEditable
                                        width: parent.width - 10
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 170
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    TextInput {
                                        id: nameInput
                                        anchors.centerIn: parent
                                        text: model.name
                                        horizontalAlignment: Text.AlignHCenter
                                        readOnly: !model.isEditable
                                        width: parent.width - 10
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 90
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    TextInput {
                                        id: quantityInput
                                        anchors.centerIn: parent
                                        text: model.quantity
                                        horizontalAlignment: Text.AlignHCenter
                                        readOnly: !model.isEditable
                                        width: parent.width - 10
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 120
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    TextInput {
                                        id: priceInput
                                        anchors.centerIn: parent
                                        text: model.price
                                        horizontalAlignment: Text.AlignHCenter
                                        readOnly: !model.isEditable
                                        width: parent.width - 10
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 190
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    TextInput {
                                        id: supplierInput
                                        anchors.centerIn: parent
                                        text: model.supplier
                                        horizontalAlignment: Text.AlignHCenter
                                        readOnly: !model.isEditable
                                        width: parent.width - 10
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 130
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    TextInput {
                                        id: expiryInput
                                        anchors.centerIn: parent
                                        text: model.expiry_date
                                        horizontalAlignment: Text.AlignHCenter
                                        readOnly: !model.isEditable
                                        width: parent.width - 10
                                    }
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"

                                    RowLayout {
                                        anchors.centerIn: parent
                                        spacing: 10

                                        Button {
                                            width: 60
                                            height: 30
                                            text: model.isEditable ? "Save" : "Edit"
                                            background: Rectangle {
                                                color: model.isEditable ? "#4CAF50" : "#2196F3"
                                                radius: 5
                                            }
                                            contentItem: Text {
                                                text: parent.text
                                                color: "white"
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                                font.pixelSize: 12
                                            }
                                            onClicked: {
                                                if (model.isEditable) {
                                                    // Save changes to the database
                                                    dbManager.updateStock(
                                                        parseInt(idInput.text),
                                                        nameInput.text,
                                                        supplierInput.text,
                                                        parseFloat(priceInput.text),
                                                        expiryInput.text,
                                                        parseInt(quantityInput.text)
                                                    )
                                                }
                                                medicineModel.setProperty(index, "isEditable", !model.isEditable)
                                            }
                                        }

                                        Button {
                                            width: 60
                                            height: 30
                                            text: "Delete"
                                            background: Rectangle {
                                                color: "#F44336"
                                                radius: 5
                                            }
                                            contentItem: Text {
                                                text: parent.text
                                                color: "white"
                                                horizontalAlignment: Text.AlignHCenter
                                                verticalAlignment: Text.AlignVCenter
                                                font.pixelSize: 12
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
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                Layout.bottomMargin: 20
                
                Button {
                    id: addStockButton
                    text: "Add Stock"
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 40
                    background: Rectangle {
                        color: "#4CAF50"
                        radius: 5
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 14
                    }
                    onClicked: stockDialog.open()
                }
                
                Item { Layout.fillWidth: true }
                
                Button {
                    id: backbutton
                    text: "Back"
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 40
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

        Dialog {
            id: stockDialog
            title: "Add New Stock"
            modal: true
            x: parent.width / 2 - width / 2
            y: parent.height / 2 - height / 2
            width: 400
            standardButtons: Dialog.Ok | Dialog.Cancel

            ColumnLayout {
                spacing: 15
                width: parent.width

                Label {
                    text: "Medicine ID:"
                    font.bold: true
                }
                TextField { 
                    id: newId
                    placeholderText: "Medicine ID"
                    Layout.fillWidth: true
                    validator: IntValidator { bottom: 1 }
                }
                
                Label {
                    text: "Name:"
                    font.bold: true
                }
                TextField { 
                    id: newName
                    placeholderText: "Medicine Name"
                    Layout.fillWidth: true
                }
                
                Label {
                    text: "Quantity:"
                    font.bold: true
                }
                TextField { 
                    id: newQuantity
                    placeholderText: "Quantity"
                    Layout.fillWidth: true
                    validator: IntValidator { bottom: 0 }
                }
                
                Label {
                    text: "Price:"
                    font.bold: true
                }
                TextField { 
                    id: newPrice
                    placeholderText: "Price"
                    Layout.fillWidth: true
                    validator: DoubleValidator { bottom: 0.0 }
                }
                
                Label {
                    text: "Supplier:"
                    font.bold: true
                }
                TextField { 
                    id: newSupplier
                    placeholderText: "Supplier Name"
                    Layout.fillWidth: true
                }
                
                Label {
                    text: "Expiry Date (YYYY-MM-DD):"
                    font.bold: true
                }
                TextField { 
                    id: newExpiry
                    placeholderText: "YYYY-MM-DD"
                    Layout.fillWidth: true
                }
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

        Dialog {
            id: deleteConfirmDialog
            title: "Confirm Delete"
            modal: true
            x: parent.width / 2 - width / 2
            y: parent.height / 2 - height / 2
            width: 400
            property int medicineId: -1
            standardButtons: Dialog.Yes | Dialog.No

            Label {
                text: "Are you sure you want to delete this item?"
                wrapMode: Text.WordWrap
                width: parent.width
            }

            onAccepted: {
                // Call database function to delete the stock item
                dbManager.deleteStock(medicineId)
            }
        }

        Dialog {
            id: messagePopup
            title: "Status"
            modal: true
            x: parent.width / 2 - width / 2
            y: parent.height / 2 - height / 2
            width: 300
            standardButtons: Dialog.Ok

            Label {
                id: messageText
                text: "Operation completed"
                color: "#4CAF50"
                font.pixelSize: 14
                wrapMode: Text.WordWrap
                width: parent.width
            }
        }
    }

    ListModel {
        id: medicineModel
        // This will be populated from the database
    }
}