import QtQuick 2.15
import QtQuick.Controls 2.15
import QtCharts 2.15

Item {
    visible: true
    width: 1920
    height: 1080

    Rectangle {
        width: parent.width
        height: parent.height
        color: "#daeae6"

        Text {
            y: 40
            text: "Sales Report"
            font.pixelSize: 55
            font.family: "Tahoma"
            font.styleName: "Tahoma"
            font.bold: true
            color: "#333"
            anchors.horizontalCenter: parent.horizontalCenter
            padding: 10
        }

        Row {
            y: 153
            spacing: 10
            width: 850
            anchors.horizontalCenterOffset: -485
            anchors.horizontalCenter: parent.horizontalCenter

            TextField {
                id: searchBar
                placeholderText: "Search Order ID or Customer"
                width: 300
            }
            ComboBox {
                id: dateFilter
                model: ["Today", "This Week", "This Month", "Custom"]
            }
            ComboBox {
                id: paymentFilter
                model: ["All", "Cash", "Card", "Online"]
            }
            Button {
                width: 120
                height: 40
                text: "Apply Filters"
                icon.color: "#26282a"
                background: Rectangle {
                    color: "#4f9c9c"
                }
            }
        }

        Rectangle {
            x: 1232
            y: 217
            width: 202;
            height: 100;
            color: "#7cc660";
            radius: 10
            Text {
                text: "Total Sales\n$5000"
                color: "white"
                font.bold: true
                anchors.centerIn: parent
            }
        }

        Rectangle {
            x: 939
            y: 480
            width: 178;
            height: 100;
            color: "#FF9800";
            radius: 10
            Text {
                text: "Transactions\n200"
                color: "white"
                font.bold: true
                anchors.centerIn: parent
            }
        }

        Rectangle {
            x: 939
            y: 356
            width: 211;
            height: 100;
            color: "#3c61b1";
            radius: 10
            Text {
                text: "Best Seller\nParacetamol"
                color: "white"
                font.bold: true
                anchors.centerIn: parent
            }
        }

        Rectangle {
            x: 1147
            y: 480
            width: 287; height: 100; color: "#673AB7"; radius: 10
            Text {
                text: "Avg Sale per Transaction\n Rs. 250"
                color: "white"
                font.bold: true
                anchors.centerIn: parent
            }
        }

        Rectangle {
            x: 939
            y: 217
            width: 261;
            height: 100;
            color: "#E91E63";
            radius: 10
            Text {
                text: "Most Used Payment\nCard"
                color: "white"
                font.bold: true
                anchors.centerIn: parent
            }
        }

        Rectangle {
            x: 1180
            y: 356
            width: 254
            height: 100
            color: "#d464e8"
            radius: 10
            Text {
                text: "Highest Single Sale\nRs. 1000"
                color: "white"
                font.bold: true
                anchors.centerIn: parent
            }
        }

        ChartView {
            x: 1472
            y: 204
            width: 373
            height: 396
            antialiasing: true

            PieSeries {
                PieSlice { label: "Cash"; value: 60 }
                PieSlice { label: "Card"; value: 100 }
                PieSlice { label: "Online"; value: 40 }
            }
        }

        ChartView {
            x: 939
            y: 617
            width: 450
            height: 358
            antialiasing: true

            BarSeries {
                axisX: BarCategoryAxis { categories: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"] }
                BarSet { label: "Sales"; values: [100, 200, 150, 250, 300, 400, 350] }
            }
        }

        ChartView {
            x: 1395
            y: 617
            width: 450
            height: 358
            antialiasing: true

            LineSeries {
                name: "Sales Trend"
                XYPoint { x: 1; y: 100 }
                XYPoint { x: 2; y: 180 }
                XYPoint { x: 3; y: 160 }
                XYPoint { x: 4; y: 220 }
                XYPoint { x: 5; y: 250 }
                XYPoint { x: 6; y: 300 }
                XYPoint { x: 7; y: 400 }
            }
        }

        ListModel {
            id: salesModel
            ListElement { orderID: "001"; medicineName: "Paracetamol"; paymentMethod: "Cash"; totalAmount: "500"; date: "13-01-2025" }
            ListElement { orderID: "002"; medicineName: "Ibuprofen"; paymentMethod: "Card"; totalAmount: "300"; date: "15-01-2025" }
            ListElement { orderID: "003"; medicineName: "Aspirin"; paymentMethod: "Online"; totalAmount: "750"; date: "21-01-2025" }
            ListElement { orderID: "004"; medicineName: "Dolo 650"; paymentMethod: "Cash"; totalAmount: "600"; date: "10-02-2025" }
            ListElement { orderID: "005"; medicineName: "Dollar DS"; paymentMethod: "Card"; totalAmount: "1000"; date: "15-02-2025" }
            ListElement { orderID: "006"; medicineName: "Paracetamol"; paymentMethod: "Cash"; totalAmount: "500"; date: "13-03-2025" }
            ListElement { orderID: "007"; medicineName: "Paracetamol"; paymentMethod: "Card"; totalAmount: "300"; date: "15-03-2025" }
            ListElement { orderID: "008"; medicineName: "Amoxcilin"; paymentMethod: "Online"; totalAmount: "650"; date: "21-03-2025" }
            ListElement { orderID: "009"; medicineName: "Polyfex"; paymentMethod: "Cash"; totalAmount: "600"; date: "10-04-2025" }
            ListElement { orderID: "010"; medicineName: "Cough Syrup"; paymentMethod: "Card"; totalAmount: "1000"; date: "15-04-2025" }
            ListElement { orderID: "011"; medicineName: "Antibiotic"; paymentMethod: "Cash"; totalAmount: "500"; date: "13-01-2025" }
            ListElement { orderID: "012"; medicineName: "Softin"; paymentMethod: "Card"; totalAmount: "300"; date: "15-01-2025" }
            ListElement { orderID: "013"; medicineName: "Paracetamol"; paymentMethod: "Online"; totalAmount: "750"; date: "21-01-2025" }
            ListElement { orderID: "014"; medicineName: "Piriton"; paymentMethod: "Cash"; totalAmount: "600"; date: "10-02-2025" }
            ListElement { orderID: "015"; medicineName: "Antibiotic"; paymentMethod: "Card"; totalAmount: "1000"; date: "15-02-2025" }
            ListElement { orderID: "016"; medicineName: "Entox"; paymentMethod: "Cash"; totalAmount: "500"; date: "13-03-2025" }
            ListElement { orderID: "017"; medicineName: "Aspirin"; paymentMethod: "Card"; totalAmount: "300"; date: "15-03-2025" }
            ListElement { orderID: "018"; medicineName: "Iboprufen"; paymentMethod: "Online"; totalAmount: "650"; date: "21-03-2025" }
            ListElement { orderID: "019"; medicineName: "Cough Syrup"; paymentMethod: "Cash"; totalAmount: "600"; date: "10-04-2025" }
            ListElement { orderID: "020"; medicineName: "Dollar DS"; paymentMethod: "Card"; totalAmount: "1000"; date: "15-04-2025" }
        }

        Column {
            x: 50
            y: 210
            width: 850
            height: 750

            Rectangle {
                width: parent.width
                height: 50
                color: "#89ced4"
                border.color: "black"
                border.width: 1
                Grid {
                    columns: 6
                    columnSpacing: 10
                    rowSpacing: 5
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter

                    Text { text: "Order ID"; horizontalAlignment: Text.AlignHCenter; font.bold: true; width: 130 }
                    Text { text: "Medicine Name"; horizontalAlignment: Text.AlignHCenter; font.bold: true; width: 190 }
                    Text { text: "Payment Method"; horizontalAlignment: Text.AlignHCenter; font.bold: true;  width: 150 }
                    Text { text: "Total Amount"; horizontalAlignment: Text.AlignHCenter; font.bold: true;  width: 160 }
                    Text { text: "Date"; horizontalAlignment: Text.AlignHCenter; font.bold: true; width: 165 }
                }
            }

            TableView {
                id: tableView
                width: parent.width
                height: 700
                clip: true
                model: salesModel

                delegate: Rectangle {
                    width: tableView.width
                    height: 40
                    border.color: "black"
                    border.width: 1
                    Row {
                        anchors.fill: parent
                        spacing: 5
                        Rectangle { width: 130; height: 50; border.color: "#BDBDBD"; Text { text: model.orderID; anchors.centerIn: parent } }
                        Rectangle { width: 190; height: 50; border.color: "#BDBDBD"; Text { text: model.medicineName; anchors.centerIn: parent } }
                        Rectangle { width: 160; height: 50; border.color: "#BDBDBD"; Text { text: model.paymentMethod; anchors.centerIn: parent } }
                        Rectangle { width: 160; height: 50; border.color: "#BDBDBD"; Text { text: "Rs." + model.totalAmount; anchors.centerIn: parent } }
                        Rectangle { width: 190; height: 50; border.color: "#BDBDBD"; Text { text: model.date; anchors.centerIn: parent } }
                    }
                }
            }
        }

        Row {
            y: 990
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                width: 170
                height: 40
                text: "Download PDF"
                font.pixelSize: 20
                onClicked: downloadPDFReport()
                background: Rectangle {
                    color: "#148273"
                }
            }
        }

        Button {
            id: backbutton
            x: 1795
            y: 985
            width: 95
            height: 40
            text: "Back"
            anchors.margins: 20
            anchors.rightMargin: 8
            anchors.bottomMargin: 50
            onClicked: stackView.pop()

            background: Rectangle {
               color: "lightgray"
            }
        }
    }

    function downloadPDFReport() {
        console.log("Downloading PDF sales report...");
    }
}
