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
                onClicked: console.log("Searching: " + searchField.text)
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
                y: -4
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
                onClicked: console.log("Searching: " + searchField1.text)
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

                    Text { text: "Supplier ID"; horizontalAlignment: Text.AlignHCenter; width: 200; font.bold: true }
                    Text { text: "Supplier Name"; horizontalAlignment: Text.AlignHCenter; width: 230; font.bold: true }
                    Text { text: "Supplier Contact"; horizontalAlignment: Text.AlignHCenter; width: 175; font.bold: true }
                    Text { text: "Medicine Name"; horizontalAlignment: Text.AlignHCenter; width: 200; font.bold: true }
                    Text { text: "Quantity"; horizontalAlignment: Text.AlignHCenter; width: 110; font.bold: true }
                    Text { text: "Expiry Date"; horizontalAlignment: Text.AlignHCenter; width: 170; font.bold: true }
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
                            width: 200
                            height: parent.height
                            border.color: "black"

                            Text {
                                id: idInput
                                anchors.fill: parent
                                text: model.ID
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        Rectangle {
                            width: 240
                            height: parent.height
                            border.color: "black"

                            Text {
                                id: suppnameInput
                                anchors.fill: parent
                                text: model.supplierName
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        Rectangle {
                            width: 200
                            height: parent.height
                            border.color: "black"

                            Text {
                                id: contactInput
                                anchors.fill: parent
                                text: model.contact
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        Rectangle {
                            width: 200
                            height: parent.height
                            border.color: "black"

                            Text {
                                id: mednameInput
                                anchors.fill: parent
                                text: model.medicineName
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        Rectangle {
                            width: 110
                            height: parent.height
                            border.color: "black"

                            Text {
                                id: quantityInput
                                anchors.fill: parent
                                text: model.quantity
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        Rectangle {
                            width: 200
                            height: parent.height
                            border.color: "black"

                            Text {
                                id: expiryInput
                                anchors.fill: parent
                                text: model.expiry
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
            ListElement { ID: "S032984801"; supplierName: "MediCorp"; contact: "123-456-7890"; medicineName: "Paracetamol"; quantity: "50"; expiry: "2025-06-12" }
            ListElement { ID: "S084877402"; supplierName: "PharmaPlus"; contact: "987-654-3210"; medicineName: "Ibuprofen"; quantity: "30"; expiry: "2024-09-25" }
            ListElement { ID: "S038774703"; supplierName: "MediCare"; contact: "555-123-4567"; medicineName: "Amoxicillin"; quantity: "20"; expiry: "2026-02-10" }
            ListElement { ID: "S073739404"; supplierName: "HealthFirst"; contact: "111-222-3333"; medicineName: "Aspirin"; quantity: "40"; expiry: "2025-11-30" }
            ListElement { ID: "S007734565"; supplierName: "PharmaHub"; contact: "999-888-7777"; medicineName: "Cetirizine"; quantity: "60"; expiry: "2027-01-15" }
            ListElement { ID: "S043789206"; supplierName: "MediLine"; contact: "444-555-6666"; medicineName: "Dolo 650"; quantity: "80"; expiry: "2025-08-20" }
            ListElement { ID: "S032048507"; supplierName: "BioHealth"; contact: "777-666-5555"; medicineName: "Cough Syrup"; quantity: "35"; expiry: "2024-12-10" }
            ListElement { ID: "S032874708"; supplierName: "Wellness Pharma"; contact: "222-333-4444"; medicineName: "Vitamin C"; quantity: "100"; expiry: "2026-07-05" }
            ListElement { ID: "S093484709"; supplierName: "MedTrust"; contact: "888-999-0000"; medicineName: "Omeprazole"; quantity: "45"; expiry: "2025-09-18" }
            ListElement { ID: "S034874410"; supplierName: "Global Health"; contact: "666-777-8888"; medicineName: "Antibiotic"; quantity: "25"; expiry: "2026-03-14" }
            ListElement { ID: "S084858611"; supplierName: "MediLife"; contact: "112-233-4455"; medicineName: "Loratadine"; quantity: "70"; expiry: "2025-10-30" }
            ListElement { ID: "S059886612"; supplierName: "WellMed"; contact: "223-344-5566"; medicineName: "Ciprofloxacin"; quantity: "55"; expiry: "2026-06-22" }
            ListElement { ID: "S004590613"; supplierName: "GoodHealth"; contact: "334-455-6677"; medicineName: "Metformin"; quantity: "90"; expiry: "2027-04-01" }
            ListElement { ID: "S005496914"; supplierName: "LifeLine Pharma"; contact: "445-566-7788"; medicineName: "Insulin"; quantity: "15"; expiry: "2025-12-31" }
            ListElement { ID: "S056989615"; supplierName: "TrustMeds"; contact: "556-677-8899"; medicineName: "Losartan"; quantity: "50"; expiry: "2026-09-09" }
            ListElement { ID: "S002943816"; supplierName: "MediTrust"; contact: "667-788-9900"; medicineName: "Amlodipine"; quantity: "60"; expiry: "2026-11-05" }
            ListElement { ID: "S048589017"; supplierName: "Healthy Life"; contact: "778-899-0011"; medicineName: "Ranitidine"; quantity: "40"; expiry: "2025-08-14" }
            ListElement { ID: "S023050918"; supplierName: "CureMed"; contact: "889-900-1122"; medicineName: "Omeprazole"; quantity: "30"; expiry: "2026-05-20" }
            ListElement { ID: "S040096119"; supplierName: "VitalMeds"; contact: "990-112-2233"; medicineName: "Prednisone"; quantity: "25"; expiry: "2027-02-28" }
            ListElement { ID: "S009590920"; supplierName: "PrimePharma"; contact: "101-213-3244"; medicineName: "Hydrochlorothiazide"; quantity: "35"; expiry: "2026-07-18" }
        }
    }
}
