import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Item {
    id: root
    anchors.fill: parent
    property StackView stackView: null

    // Connect to database signals
    Connections {
        target: dbManager
        function onInventoryDataLoaded(inventoryData) {
            stockmodel.clear();
            for (var i = 0; i < inventoryData.length; i++) {
                stockmodel.append(inventoryData[i]);
            }
        }
    }
    
    // Load data on component initialization
    Component.onCompleted: {
        dbManager.getInventoryData();
    }

    Rectangle {
        id: bgrectangle
        color: "#daeae6"
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent
            spacing: 30

            Text {
                id: trackinventory
                color: "#5b99d6"
                text: qsTr("Inventory Details")
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
                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 40
                    onTextChanged: {
                        if (text.length > 2) {
                            filterInventory();
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
                        font.pixelSize: 14
                    }
                    onClicked: filterInventory()
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
                            filterInventory();
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
                        font.pixelSize: 14
                    }
                    onClicked: filterInventory()
                }
                
                Button {
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
                        font.pixelSize: 14
                    }
                    onClicked: {
                        searchField.text = "";
                        searchField1.text = "";
                        dbManager.getInventoryData();
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
                            text: "Supplier ID"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 150
                        }
                        Text { 
                            text: "Supplier Name"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 180
                        }
                        Text { 
                            text: "Supplier Contact"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 180
                        }
                        Text { 
                            text: "Medicine Name"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 180
                        }
                        Text { 
                            text: "Quantity"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 100
                        }
                        Text { 
                            text: "Expiry Date"
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
                        model: stockmodel
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
                                    Layout.preferredWidth: 150
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: model.ID
                                        horizontalAlignment: Text.AlignHCenter
                                        width: parent.width - 10
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 180
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: model.supplierName
                                        horizontalAlignment: Text.AlignHCenter
                                        width: parent.width - 10
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 180
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: model.contact
                                        horizontalAlignment: Text.AlignHCenter
                                        width: parent.width - 10
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 180
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: model.medicineName
                                        horizontalAlignment: Text.AlignHCenter
                                        width: parent.width - 10
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 100
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: model.quantity
                                        horizontalAlignment: Text.AlignHCenter
                                        width: parent.width - 10
                                    }
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: model.expiry
                                        horizontalAlignment: Text.AlignHCenter
                                        width: parent.width - 10
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
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
        id: stockmodel
        // Will be populated from database
    }
    
    // Function to filter inventory based on search terms
    function filterInventory() {
        // Reload full data if both fields are empty
        if (searchField.text === "" && searchField1.text === "") {
            dbManager.getInventoryData();
            return;
        }
        
        // Filter local model
        let filteredData = [];
        for (let i = 0; i < stockmodel.count; i++) {
            let item = stockmodel.get(i);
            let medNameMatch = item.medicineName.toLowerCase().includes(searchField.text.toLowerCase());
            let supplierMatch = item.supplierName.toLowerCase().includes(searchField1.text.toLowerCase());
            
            if ((searchField.text === "" || medNameMatch) && 
                (searchField1.text === "" || supplierMatch)) {
                filteredData.push(item);
            }
        }
        
        // Update model with filtered data
        stockmodel.clear();
        for (let i = 0; i < filteredData.length; i++) {
            stockmodel.append(filteredData[i]);
        }
    }
}