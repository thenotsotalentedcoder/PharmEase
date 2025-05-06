import QtQuick
import QtQuick.Controls
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Item {
    id: root
    width: 1920
    height: 1080

    Rectangle {
        id: bgrectangle
        color: "#daeae6"
        anchors.fill: parent
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.topMargin: 0
        anchors.bottomMargin: 0

        Column {
            anchors.fill: parent
            spacing: 10
        }

        Text {
            id: managestock
            x: 699
            y: 65
            width: 494
            height: 70
            text: qsTr("Stock Management")
            font.pixelSize: 50
            font.bold: true
            font.family: "Tahoma"
        }

        Row {
            id: medicinesearchbar
            x: 140
            y: 200
            spacing: 7
            TextField {
                id: searchField
                placeholderText: "Search medicine..."
                width: 650
            }
            Button {
                y: -4
                width: 100
                height: 65
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
            id: suppliersearchbar
            x: 1030
            y: 200
            spacing: 7
            TextField {
                id: searchField1
                placeholderText: "Search supplier..."
                width: 650
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
                    color: "#000000"
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
            x: 120
            y: 300
            width: parent.width - 215
            height: 650

            Rectangle {
                width: parent.width
                height: 40
                color: "#89ced4"
                border.color: "black"
                border.width: 1

                Grid {
                    columns: 6
                    columnSpacing: 10
                    rowSpacing: 5
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter

                    Text { text: "               Medicine ID"; width: 247; font.bold: true }
                    Text { text: "               Medicine Name"; width: 280; font.bold: true }
                    Text { text: "          Quantity"; width: 180; font.bold: true }
                    Text { text: "          Price per Unit"; width: 230; font.bold: true }
                    Text { text: "                   Supplier"; width: 280; font.bold: true }
                    Text { text: "              Expiry Date"; width: 280; font.bold: true }
                }
            }

            ListModel {
                id: medicineModel
                ListElement { ID: "M032984801"; supplierName: "MediCorp"; medicineName: "Paracetamol"; quantity: "50"; price: "900"; expiry: "2025-06-12"; isEditable: false }
                ListElement { ID: "M084877402"; supplierName: "PharmaPlus"; medicineName: "Ibuprofen"; quantity: "30"; price: "1000"; expiry: "2024-09-25"; isEditable: false }
                ListElement { ID: "M038774703"; supplierName: "MediCare"; medicineName: "Amoxicillin"; quantity: "20"; price: "1500"; expiry: "2026-02-10"; isEditable: false }
                ListElement { ID: "M073739404"; supplierName: "HealthFirst"; medicineName: "Aspirin"; quantity: "40"; price: "600"; expiry: "2025-11-30"; isEditable: false }
                ListElement { ID: "M007734565"; supplierName: "PharmaHub"; medicineName: "Cetirizine"; quantity: "60"; price: "800"; expiry: "2027-01-15"; isEditable: false }
                ListElement { ID: "M043789206"; supplierName: "MediLine"; medicineName: "Dolo 650"; quantity: "80"; price: "1000"; expiry: "2025-08-20"; isEditable: false }
                ListElement { ID: "M032048507"; supplierName: "BioHealth"; medicineName: "Cough Syrup"; quantity: "35"; price: "500"; expiry: "2024-12-10"; isEditable: false }
                ListElement { ID: "M032874708"; supplierName: "Wellness Pharma"; medicineName: "Vitamin C"; quantity: "100"; price: "700"; expiry: "2026-07-05"; isEditable: false }
                ListElement { ID: "M093484709"; supplierName: "MedTrust"; medicineName: "Omeprazole"; quantity: "45"; price: "1100"; expiry: "2025-09-18"; isEditable: false }
                ListElement { ID: "M034874410"; supplierName: "Global Health"; medicineName: "Antibiotic"; quantity: "25"; price: "900"; expiry: "2026-03-14"; isEditable: false }
                ListElement { ID: "M084858611"; supplierName: "MediLife"; medicineName: "Loratadine"; quantity: "70"; price: "1500"; expiry: "2025-10-30"; isEditable: false }
                ListElement { ID: "M059886612"; supplierName: "WellMed"; medicineName: "Ciprofloxacin"; quantity: "55"; price: "1000"; expiry: "2026-06-22"; isEditable: false }
                ListElement { ID: "M004590613"; supplierName: "GoodHealth"; medicineName: "Metformin"; quantity: "90"; price: "900"; expiry: "2027-04-01"; isEditable: false }
                ListElement { ID: "M005496914"; supplierName: "LifeLine Pharma"; medicineName: "Insulin"; quantity: "15"; price: "1200"; expiry: "2025-12-31"; isEditable: false }
                ListElement { ID: "M056989615"; supplierName: "TrustMeds"; medicineName: "Losartan"; quantity: "50"; price: "950"; expiry: "2026-09-09"; isEditable: false }
                ListElement { ID: "M002943816"; supplierName: "MediTrust"; medicineName: "Amlodipine"; quantity: "60"; price: "1300"; expiry: "2026-11-05"; isEditable: false }
                ListElement { ID: "M048589017"; supplierName: "Healthy Life"; medicineName: "Ranitidine"; quantity: "40"; price: "900"; expiry: "2025-08-14"; isEditable: false }
                ListElement { ID: "M023050918"; supplierName: "CureMed"; medicineName: "Omeprazole"; quantity: "30"; price: "800"; expiry: "2026-05-20"; isEditable: false }
                ListElement { ID: "M040096119"; supplierName: "VitalMeds";  medicineName: "Prednisone"; quantity: "25"; price: "780"; expiry: "2027-02-28"; isEditable: false }
                ListElement { ID: "M009590920"; supplierName: "PrimePharma"; medicineName: "Hydrochlorothiazide"; quantity: "35"; price: "910"; expiry: "2026-07-18"; isEditable: false }
            }

            TableView {
                id: tableView
                width: parent.width
                height: parent.height - 40
                clip: true
                model: medicineModel

                delegate: Rectangle {
                    width: tableView.width
                    height: 40
                    border.color: "black"
                    border.width: 1

                    Row {
                        anchors.fill: parent
                        spacing: 5

                        property bool editable: model.isEditable

                        function toggleEdit() {
                            if (editable) {
                                medicineModel.set(index, {
                                    "ID": idInput.text,
                                    "medicineName": nameInput.text,
                                    "quantity": quantityInput.text,
                                    "price": priceInput.text,
                                    "supplierName": supplierInput.text,
                                    "expiry": expiryInput.text,
                                    "isEditable": false
                                });
                            } else {
                                medicineModel.set(index, {
                                    "ID": model.ID,
                                    "medicineName": model.medicineName,
                                    "quantity": model.quantity,
                                    "price": model.price,
                                    "supplierName": model.supplierName,
                                    "expiry": model.expiry,
                                    "isEditable": true
                                });
                            }
                        }

                        Rectangle {
                            width: 247
                            height: parent.height
                            border.color: "black"
                            TextInput {
                                id: idInput
                                anchors.centerIn: parent
                                text: model.ID
                                horizontalAlignment: Text.AlignHCenter
                                readOnly: !model.isEditable
                            }
                        }

                        Rectangle {
                            width: 280
                            height: parent.height
                            border.color: "black"
                            TextInput {
                                id: nameInput
                                anchors.centerIn: parent
                                text: model.medicineName
                                horizontalAlignment: Text.AlignHCenter
                                readOnly: !model.isEditable
                            }
                        }

                        Rectangle {
                            width: 180
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
                            width: 230
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
                            width: 280
                            height: parent.height
                            border.color: "black"
                            TextInput {
                                id: supplierInput
                                anchors.centerIn: parent
                                text: model.supplierName
                                horizontalAlignment: Text.AlignHCenter
                                readOnly: !model.isEditable
                            }
                        }

                        Rectangle {
                            width: 280
                            height: parent.height
                            border.color: "black"
                            TextInput {
                                id: expiryInput
                                anchors.centerIn: parent
                                text: model.expiry
                                horizontalAlignment: Text.AlignHCenter
                                readOnly: !model.isEditable
                            }
                        }

                        Button {
                            width: 85
                            height: parent.height
                            text: model.isEditable ? "Save" : "Edit"
                            onClicked: {
                                medicineModel.setProperty(index, "isEditable", !model.isEditable);
                                if (!model.isEditable) {
                                    medicineModel.set(index, {
                                        "ID": idInput.text,
                                        "medicineName": nameInput.text,
                                        "quantity": quantityInput.text,
                                        "price": priceInput.text,
                                        "supplierName": supplierInput.text,
                                        "expiry": expiryInput.text,
                                        "isEditable": false
                                    });
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
                                medicineModel.remove(index);
                            }
                        }
                    }

                }
            }
        }

        Button {
            id: addStockButton
            y: 978
            width: 120
            height: 52
            text: "Add Stock"
            anchors.right: backbutton.left
            anchors.bottom: parent.bottom
            anchors.margins: 20
            anchors.rightMargin: 8
            anchors.bottomMargin: 50

            background: Rectangle {
                color: "#fa086960"
                radius: 10
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

        Dialog {
            id: stockDialog
            title: "Add New Stock"
            modal: true
            standardButtons: Dialog.Ok | Dialog.Cancel

            Column {
                spacing: 10
                width: 300

                TextField { id: newId; placeholderText: "ID" }
                TextField { id: newName; placeholderText: "Name" }
                TextField { id: newQuantity; placeholderText: "Quantity" }
                TextField { id: newPrice; placeholderText: "Price" }
                TextField { id: newSupplier; placeholderText: "Supplier Name" }
                TextField { id: newExpiry; placeholderText: "Expiry Date (YYYY-MM-DD)" }
            }

            onAccepted: {
                medicineModel.append({
                    "ID": newId.text,
                    "medicineName": newName.text,
                    "quantity": newQuantity.text,
                    "price": newPrice.text,
                    "supplierName": newSupplier.text,
                    "expiry": newExpiry.text,
                    "isEditable": false
                });
                newId.text = "";
                newName.text = "";
                newQuantity.text = "";
                newPrice.text = "";
                newSupplier.text = "";
                newExpiry.text = "";
            }
        }

        Button {
            id: backbutton
            x: 1823
            y: 978
            width: 89
            height: 52
            text: "Back"
            anchors.right: parent.right
            anchors.bottom: parent.bottom
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
}
