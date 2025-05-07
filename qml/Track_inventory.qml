import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Item {
    id: root
    anchors.fill: parent

    // Connect to C++ DatabaseManager
    Component.onCompleted: {
        stockmodel.clear();
        // Call function to fetch data from database
        var inventoryData = dbManager.getInventory();
        // Populate model with data
        for (var i = 0; i < inventoryData.length; i++) {
            stockmodel.append(inventoryData[i]);
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
                id: trackinventory
                color: "#5b99d6"
                text: qsTr("Inventory Details")
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
                    placeholderText: "Search medicine..."
                    Layout.preferredWidth: 400
                    Layout.preferredHeight: 40
                }
                Button {
                    text: "Search"
                    width: 60
                    height: 30
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
                        stockmodel.clear();
                        // Filter model by medicine name
                        if (searchField.text.trim() !== "") {
                            var filteredStocks = dbManager.searchMedicine(searchField.text);

                            stockmodel.clear();
                            for (var j = 0; j < filteredStocks.length; j++) {
                                stockmodel.append({
                                    medicine_id: filteredStocks[j].medicine_id,
                                    name: filteredStocks[j].name,
                                    quantity: filteredStocks[j].quantity,
                                    price: filteredStocks[j].price,
                                    supplier: filteredStocks[j].supplier,
                                    expiry_date: filteredStocks[j].expiry_date,
                                    contact_no: filteredStocks[j].contact_no,
                                    isEditable: false
                                });
                            }
                        } else {
                            // If search field is empty, show all data
                            var inventoryData = dbManager.getInventory();
                            // Populate model with data
                            for (var i = 0; i < inventoryData.length; i++) {
                                stockmodel.append(inventoryData[i]);
                            }
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
                    width: 100
                    text: "Search"
                    height: 65
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
                        stockmodel.clear();
                        // Filter model by supplier name
                        if (searchField1.text.trim() !== "") {
                            var filteredStocks = dbManager.searchSupplier(searchField1.text);

                            stockmodel.clear();
                            for (var j = 0; j < filteredStocks.length; j++) {
                                stockmodel.append({
                                    medicine_id: filteredStocks[j].medicine_id,
                                    name: filteredStocks[j].name,
                                    quantity: filteredStocks[j].quantity,
                                    price: filteredStocks[j].price,
                                    supplier: filteredStocks[j].supplier,
                                    expiry_date: filteredStocks[j].expiry_date,
                                    contact_no: filteredStocks[j].contact_no,
                                    isEditable: false
                                });
                            }
                        } else {
                            // If search field is empty, show all data
                            var inventoryData = dbManager.getInventory();
                            // Populate model with data
                            for (var i = 0; i < inventoryData.length; i++) {
                                stockmodel.append(inventoryData[i]);
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
                    Layout.preferredHeight: 40
                    color: "#89ced4"
                    border.color: "black"
                    border.width: 1

                    Grid {
                        columns: 7
                        columnSpacing: 10
                        rowSpacing: 5
                        width: parent.width
                        anchors.verticalCenter: parent.verticalCenter

                        Text { text: "Medicine ID"; horizontalAlignment: Text.AlignHCenter; width: 150; font.bold: true }
                        Text { text: "Medicine Name"; horizontalAlignment: Text.AlignHCenter; width: 200; font.bold: true }
                        Text { text: "Supplier"; horizontalAlignment: Text.AlignHCenter; width: 185; font.bold: true }
                        Text { text: "Price"; horizontalAlignment: Text.AlignHCenter; width: 120; font.bold: true }
                        Text { text: "Expiry Date"; horizontalAlignment: Text.AlignHCenter; width: 160; font.bold: true }
                        Text { text: "Quantity"; horizontalAlignment: Text.AlignHCenter; width: 120; font.bold: true }
                        Text { text: "Contact No"; horizontalAlignment: Text.AlignHCenter; width: 150; font.bold: true }
                    }
                }

                ScrollView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 400
                    clip: true

                    ListView {
                        id: tableView
                        width: parent.width
                        model: stockmodel

                        delegate: Rectangle {
                            width: tableView.width
                            height: 40
                            border.color: "black"
                            border.width: 1

                            Row {
                                anchors.fill: parent

                                Rectangle {
                                    width: 150
                                    height: parent.height
                                    border.color: "black"

                                    Text {
                                        anchors.fill: parent
                                        text: model.medicine_id
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }

                                Rectangle {
                                    width: 210
                                    height: parent.height
                                    border.color: "black"

                                    Text {
                                        anchors.fill: parent
                                        text: model.name
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }

                                Rectangle {
                                    width: 210
                                    height: parent.height
                                    border.color: "black"

                                    Text {
                                        anchors.fill: parent
                                        text: model.supplier
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }

                                Rectangle {
                                    width: 120
                                    height: parent.height
                                    border.color: "black"

                                    Text {
                                        anchors.fill: parent
                                        text: model.price
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }

                                Rectangle {
                                    width: 180
                                    height: parent.height
                                    border.color: "black"

                                    Text {
                                        anchors.fill: parent
                                        text: model.expiry_date
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }

                                Rectangle {
                                    width: 110
                                    height: parent.height
                                    border.color: "black"

                                    Text {
                                        anchors.fill: parent
                                        text: model.quantity
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }

                                Rectangle {
                                    width: 170
                                    height: parent.height
                                    border.color: "black"

                                    Text {
                                        anchors.fill: parent
                                        text: model.contact_no
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
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
            id: stockmodel
            // Will be populated from database in Component.onCompleted
        }
    }
}
