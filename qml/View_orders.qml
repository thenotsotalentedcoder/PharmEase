import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Item {
    id: root
    anchors.fill: parent

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
                placeholderText: "Search medicine name..."
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
                onClicked: console.log("Searching: " + searchField.text)
            }
            Item {
                width: 40
                height: 1
            }
            TextField {
                id: searchField1
                placeholderText: "Search medicine name..."
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
                onClicked: console.log("Searching: " + searchField1.text)
            }
            ComboBox {
                id: paymentFilter
                Layout.preferredHeight: 30
                width: 170
                model: ["All", "Cash", "Card", "Online"]
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
                    Text { text: "Medicine ID"; horizontalAlignment: Text.AlignHCenter; width: 130; font.bold: true }
                    Text { text: "Medicine"; horizontalAlignment: Text.AlignHCenter; width: 140; font.bold: true }
                    Text { text: "Customer ID"; horizontalAlignment: Text.AlignHCenter; width: 140; font.bold: true }
                    Text { text: "Customer Name"; horizontalAlignment: Text.AlignHCenter; width: 150; font.bold: true }
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
                        Text { text: model.orderID; anchors.fill: parent; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }

                    Rectangle { width: 140; height: 40; border.color: "black"; color: "white"
                        Text { text: model.medicineID; anchors.fill: parent; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }

                    Rectangle { width: 160; height: 40; border.color: "black"; color: "white"
                        Text { text: model.medicineName; anchors.fill: parent; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }

                    Rectangle { width: 140; height: 40; border.color: "black"; color: "white"
                        Text { text: model.customerID; anchors.fill: parent; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }

                    Rectangle { width: 160; height: 40; border.color: "black"; color: "white"
                        Text { text: model.customerName; anchors.fill: parent; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }

                    Rectangle { width: 80; height: 40; border.color: "black"; color: "white"
                        Text { text: model.quantity; anchors.fill: parent; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }

                    Rectangle { width: 100; height: 40; border.color: "black"; color: "white"
                        Text { text: model.paymentMethod; anchors.fill: parent; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }

                    Rectangle { width: 100; height: 40; border.color: "black"; color: "white"
                        Text { text: "Rs." + model.totalAmount; anchors.fill: parent; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }

                    Rectangle { width: 130; height: 40; border.color: "black"; color: "white"
                        Text { text: model.date; anchors.fill: parent; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter } }
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
            ListElement { orderID: "001"; medicineID: "M1001"; medicineName: "Paracetamol"; customerID: "C001"; customerName: "John Doe"; quantity: "2"; paymentMethod: "Cash"; totalAmount: "500"; date: "13-01-2025" }
            ListElement { orderID: "002"; medicineID: "M1002"; medicineName: "Ibuprofen"; customerID: "C002"; customerName: "Jane Smith"; quantity: "1"; paymentMethod: "Card"; totalAmount: "300"; date: "15-01-2025" }
            ListElement { orderID: "003"; medicineID: "M1003"; medicineName: "Aspirin"; customerID: "C003"; customerName: "Alice Johnson"; quantity: "3"; paymentMethod: "Online"; totalAmount: "750"; date: "21-01-2025" }
            ListElement { orderID: "004"; medicineID: "M1004"; medicineName: "Amoxicillin"; customerID: "C004"; customerName: "Robert Brown"; quantity: "1"; paymentMethod: "Cash"; totalAmount: "450"; date: "23-01-2025" }
            ListElement { orderID: "005"; medicineID: "M1005"; medicineName: "Ciprofloxacin"; customerID: "C005"; customerName: "Emily Davis"; quantity: "2"; paymentMethod: "Card"; totalAmount: "700"; date: "25-01-2025" }
            ListElement { orderID: "006"; medicineID: "M1006"; medicineName: "Metformin"; customerID: "C006"; customerName: "Daniel Wilson"; quantity: "1"; paymentMethod: "Online"; totalAmount: "200"; date: "27-01-2025" }
            ListElement { orderID: "007"; medicineID: "M1007"; medicineName: "Atorvastatin"; customerID: "C007"; customerName: "Sarah Miller"; quantity: "3"; paymentMethod: "Cash"; totalAmount: "900"; date: "29-01-2025" }
            ListElement { orderID: "008"; medicineID: "M1008"; medicineName: "Amlodipine"; customerID: "C008"; customerName: "William Johnson"; quantity: "2"; paymentMethod: "Card"; totalAmount: "600"; date: "31-01-2025" }
            ListElement { orderID: "009"; medicineID: "M1009"; medicineName: "Losartan"; customerID: "C009"; customerName: "Olivia Martinez"; quantity: "1"; paymentMethod: "Online"; totalAmount: "350"; date: "02-02-2025" }
            ListElement { orderID: "010"; medicineID: "M1010"; medicineName: "Omeprazole"; customerID: "C010"; customerName: "Michael Clark"; quantity: "3"; paymentMethod: "Cash"; totalAmount: "850"; date: "04-02-2025" }
            ListElement { orderID: "011"; medicineID: "M1011"; medicineName: "Gabapentin"; customerID: "C011"; customerName: "Sophia Hernandez"; quantity: "2"; paymentMethod: "Card"; totalAmount: "750"; date: "06-02-2025" }
            ListElement { orderID: "012"; medicineID: "M1012"; medicineName: "Sertraline"; customerID: "C012"; customerName: "Ethan Anderson"; quantity: "1"; paymentMethod: "Online"; totalAmount: "500"; date: "08-02-2025" }
            ListElement { orderID: "013"; medicineID: "M1013"; medicineName: "Lisinopril"; customerID: "C013"; customerName: "Ava Thompson"; quantity: "2"; paymentMethod: "Cash"; totalAmount: "600"; date: "10-02-2025" }
            ListElement { orderID: "014"; medicineID: "M1014"; medicineName: "Levothyroxine"; customerID: "C014"; customerName: "Mason White"; quantity: "3"; paymentMethod: "Card"; totalAmount: "900"; date: "12-02-2025" }
            ListElement { orderID: "015"; medicineID: "M1015"; medicineName: "Montelukast"; customerID: "C015"; customerName: "Isabella Garcia"; quantity: "1"; paymentMethod: "Online"; totalAmount: "400"; date: "14-02-2025" }
            ListElement { orderID: "016"; medicineID: "M1016"; medicineName: "Duloxetine"; customerID: "C016"; customerName: "James Robinson"; quantity: "2"; paymentMethod: "Cash"; totalAmount: "700"; date: "16-02-2025" }
            ListElement { orderID: "017"; medicineID: "M1017"; medicineName: "Fluoxetine"; customerID: "C017"; customerName: "Charlotte Scott"; quantity: "3"; paymentMethod: "Card"; totalAmount: "950"; date: "18-02-2025" }
            ListElement { orderID: "018"; medicineID: "M1018"; medicineName: "Escitalopram"; customerID: "C018"; customerName: "Benjamin Adams"; quantity: "1"; paymentMethod: "Online"; totalAmount: "550"; date: "20-02-2025" }
            ListElement { orderID: "019"; medicineID: "M1019"; medicineName: "Clopidogrel"; customerID: "C019"; customerName: "Mia Lewis"; quantity: "2"; paymentMethod: "Cash"; totalAmount: "750"; date: "22-02-2025" }
            ListElement { orderID: "020"; medicineID: "M1020"; medicineName: "Metoprolol"; customerID: "C020"; customerName: "Alexander Young"; quantity: "3"; paymentMethod: "Card"; totalAmount: "900"; date: "24-02-2025" }
        }
    }
}
