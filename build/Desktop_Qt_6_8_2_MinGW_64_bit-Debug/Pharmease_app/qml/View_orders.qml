import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    width: 1920
    height: 1080
    visible: true

    Rectangle {
        width: parent.width
        height: parent.height
        color: "#daeae6"

        Text {
            id: orders
            x: 762
            y: 65
            width: 396
            height: 70
            text: qsTr("Orders & Sales")
            font.pixelSize: 50
            font.bold: true
            font.family: "Tahoma"
        }

        ComboBox {
            id: paymentFilter
            x: 1570
            y: 190
            width: 170
            model: ["All", "Cash", "Card", "Online"]
        }

        Row {
            id: medicinesearchbar
            x: 810
            y: 190
            spacing: 7
            TextField {
                id: searchField
                placeholderText: "Search medicine name..."
                width: 550
            }
            Button {
                y: 0
                width: 100
                height: 40
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
        }

        Row {
            id: customersearchbar
            x: 110
            y: 190
            spacing: 7
            TextField {
                id: searchField1
                placeholderText: "Search medicine name..."
                width: 550
            }
            Button {
                y: 0
                width: 100
                height: 40
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
        }


        Column {
            id: tableContainer
            x: 110
            y: 300
            width: 1700
            height: 700

            Rectangle {
                width: parent.width
                height: 40
                color: "#89ced4"
                border.color: "black"
                border.width: 1

                Grid {
                    columns: 9
                    columnSpacing: 10
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    Text { text: "Order ID"; horizontalAlignment: Text.AlignHCenter; width: 240; color: "white" }
                    Text { text: "Medicine ID"; horizontalAlignment: Text.AlignHCenter; width: 230; color: "white" }
                    Text { text: "Medicine"; horizontalAlignment: Text.AlignHCenter; width: 210; color: "white" }
                    Text { text: "Customer ID"; horizontalAlignment: Text.AlignHCenter; width: 240; color: "white" }
                    Text { text: "Customer Name"; horizontalAlignment: Text.AlignHCenter; width: 220; color: "white" }
                    Text { text: "Qty"; horizontalAlignment: Text.AlignHCenter; width: 85; color: "white" }
                    Text { text: "Payment"; horizontalAlignment: Text.AlignHCenter; width: 100; color: "white" }
                    Text { text: "Total (Rs.)"; horizontalAlignment: Text.AlignHCenter; width: 100; color: "white" }
                    Text { text: "Date"; horizontalAlignment: Text.AlignHCenter; width: 190; color: "white" }
                }
            }

            TableView {
                id: salesTable
                width: parent.width
                height: 650
                columnSpacing: 5
                rowSpacing: 5
                clip: true

                model: ListModel {
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

                delegate: Row {
                    spacing: 2

                    Rectangle { width: 240; height: 40; border.color: "black"; color: "white"
                        Text { text: model.orderID; anchors.centerIn: parent } }

                    Rectangle { width: 240; height: 40; border.color: "black"; color: "white"
                        Text { text: model.medicineID; anchors.centerIn: parent } }

                    Rectangle { width: 230; height: 40; border.color: "black"; color: "white"
                        Text { text: model.medicineName; anchors.centerIn: parent } }

                    Rectangle { width: 240; height: 40; border.color: "black"; color: "white"
                        Text { text: model.customerID; anchors.centerIn: parent } }

                    Rectangle { width: 230; height: 40; border.color: "black"; color: "white"
                        Text { text: model.customerName; anchors.centerIn: parent } }

                    Rectangle { width: 80; height: 40; border.color: "black"; color: "white"
                        Text { text: model.quantity; anchors.centerIn: parent } }

                    Rectangle { width: 120; height: 40; border.color: "black"; color: "white"
                        Text { text: model.paymentMethod; anchors.centerIn: parent } }

                    Rectangle { width: 104; height: 40; border.color: "black"; color: "white"
                        Text { text: "Rs." + model.totalAmount; anchors.centerIn: parent } }

                    Rectangle { width: 200; height: 40; border.color: "black"; color: "white"
                        Text { text: model.date; anchors.centerIn: parent } }
                }
            }
        }

        Button {
            id: backbutton
            text: "Back"
            width: 70
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 20
            anchors.rightMargin: 20
            anchors.bottomMargin: 50
            onClicked: stackView.pop()

            background: Rectangle {
                color: "lightgray"
            }
        }
    }
}
