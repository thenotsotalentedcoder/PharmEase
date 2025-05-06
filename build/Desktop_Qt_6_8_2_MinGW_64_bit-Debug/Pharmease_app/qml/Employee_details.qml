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
            id: employeedetails
            x: 699
            y: 65
            width: 494
            height: 70
            text: qsTr("Employee Details")
            font.pixelSize: 50
            font.bold: true
            font.family: "Tahoma"
        }

        Row {
            id: employeeidsearchbar
            x: 140
            y: 200
            spacing: 7
            TextField {
                id: searchField
                placeholderText: "Search employee ID..."
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
            id: employeepositionsearchbar
            x: 1030
            y: 200
            spacing: 7
            TextField {
                id: searchField1
                placeholderText: "Search employee position..."
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

                    Text { text: "Employee ID"; horizontalAlignment: Text.AlignHCenter; width: 300; font.bold: true }
                    Text { text: "Employee Name"; horizontalAlignment: Text.AlignHCenter; width: 350; font.bold: true }
                    Text { text: "Position"; horizontalAlignment: Text.AlignHCenter; width: 290; font.bold: true }
                    Text { text: "Salary"; horizontalAlignment: Text.AlignHCenter; width: 250; font.bold: true }
                    Text { text: "Contact"; horizontalAlignment: Text.AlignHCenter; width: 290; font.bold: true }

                  }
            }

            ListModel {
                id: employeeModel
                ListElement { employeeID: "E10034894581"; name: "John Doe"; position: "Manager"; salary: "50000"; contact: "123-456-7890"; isEditable: false }
                ListElement { employeeID: "E10008498322"; name: "Jane Smith"; position: "Pharmacist"; salary: "45000"; contact: "987-654-3210"; isEditable: false }
                ListElement { employeeID: "E10030745793"; name: "Mark Johnson"; position: "Technician"; salary: "40000"; contact: "555-987-6543"; isEditable: false }
                ListElement { employeeID: "E10039497044"; name: "Emily White"; position: "Cashier"; salary: "35000"; contact: "222-333-4444"; isEditable: false }
                ListElement { employeeID: "E10003429405"; name: "Michael Brown"; position: "Inventory Manager"; salary: "4700"; contact: "111-222-3333"; isEditable: false }
                ListElement { employeeID: "E10034858906"; name: "Sarah Johnson"; position: "Pharmacy Assistant"; salary: "32000"; contact: "777-888-9999"; isEditable: false }
                ListElement { employeeID: "E10030974407"; name: "David Miller"; position: "Security Guard"; salary: "28000"; contact: "666-555-4444"; isEditable: false }
                ListElement { employeeID: "E10039048848"; name: "Laura Wilson"; position: "HR Executive"; salary: "46000"; contact: "123-987-6543"; isEditable: false }
                ListElement { employeeID: "E10040969599"; name: "James Anderson"; position: "Technician"; salary: "41000"; contact: "321-654-9870"; isEditable: false }
                ListElement { employeeID: "E10498090410"; name: "Olivia Martin"; position: "Accountant"; salary: "48000"; contact: "987-321-6543"; isEditable: false }
                ListElement { employeeID: "E10948095411"; name: "William Garcia"; position: "Sales Executive"; salary: "39000"; contact: "654-789-1234"; isEditable: false }
                ListElement { employeeID: "E10300488512"; name: "Sophia Martinez"; position: "Storekeeper"; salary: "34000"; contact: "789-654-3210"; isEditable: false }
                ListElement { employeeID: "E10048490513"; name: "Daniel Rodriguez"; position: "Marketing Manager"; salary: "52000"; contact: "159-357-4862"; isEditable: false }
                ListElement { employeeID: "E10408540914"; name: "Isabella Gonzalez"; position: "Receptionist"; salary: "30000"; contact: "753-951-3570"; isEditable: false }
                ListElement { employeeID: "E10004858915"; name: "Ethan Lee"; position: "IT Support"; salary: "45000"; contact: "852-963-7410"; isEditable: false }
                ListElement { employeeID: "E10409895016"; name: "Ava Walker"; position: "Nurse"; salary: "43000"; contact: "159-753-4862"; isEditable: false }
                ListElement { employeeID: "E10408594517"; name: "Mason Hall"; position: "Janitor"; salary: "27000"; contact: "951-357-1590"; isEditable: false }
                ListElement { employeeID: "E10048545918"; name: "Mia Allen"; position: "Legal Advisor"; salary: "55000"; contact: "753-456-9510"; isEditable: false }
                ListElement { employeeID: "E10940894519"; name: "Liam Scott"; position: "Customer Support"; salary: "36000"; contact: "852-456-7890"; isEditable: false }
                ListElement { employeeID: "E10409590320"; name: "Charlotte Young"; position: "Admin Assistant"; salary: "32000"; contact: "741-258-3690"; isEditable: false }
            }

            TableView {
                id: tableView
                width: parent.width
                height: parent.height - 40
                clip: true
                model: employeeModel

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
                            if (model.isEditable) {
                                employeeModel.set(index, {
                                    "employeeID": idInput.text,
                                    "name": nameInput.text,
                                    "position": positionInput.text,
                                    "salary": salaryInput.text,
                                    "contact": contactInput.text,
                                    "isEditable": false
                                });
                            } else {
                                employeeModel.set(index, {
                                    "employeeID": model.employeeID,
                                    "name": model.name,
                                    "position": model.position,
                                    "salary": model.salary,
                                    "contact": model.contact,
                                    "isEditable": true
                                });
                            }
                        }

                        Rectangle {
                            width: 300
                            height: parent.height
                            border.color: "black"
                            TextInput {
                                id: idInput
                                anchors.centerIn: parent
                                text: model.employeeID
                                horizontalAlignment: Text.AlignHCenter
                                readOnly: !model.isEditable
                            }
                        }

                        Rectangle {
                            width: 350
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
                            width: 300
                            height: parent.height
                            border.color: "black"
                            TextInput {
                                id: positionInput
                                anchors.centerIn: parent
                                text: model.position
                                horizontalAlignment: Text.AlignHCenter
                                readOnly: !model.isEditable
                            }
                        }

                        Rectangle {
                            width: 250
                            height: parent.height
                            border.color: "black"
                            TextInput {
                                id: salaryInput
                                anchors.centerIn: parent
                                text: model.salary
                                horizontalAlignment: Text.AlignHCenter
                                readOnly: !model.isEditable
                            }
                        }

                        Rectangle {
                            width: 300
                            height: parent.height
                            border.color: "black"
                            TextInput {
                                id: contactInput
                                anchors.centerIn: parent
                                text: model.contact
                                horizontalAlignment: Text.AlignHCenter
                                readOnly: !model.isEditable
                            }
                        }

                        Button {
                            width: 85
                            height: parent.height
                            text: model.isEditable ? "Save" : "Edit"
                            onClicked: {
                                employeeModel.setProperty(index, "isEditable", !model.isEditable);
                                if (!model.isEditable) {
                                    employeeModel.set(index, {
                                        "ID": idInput.text,
                                        "name": nameInput.text,
                                        "position": positionInput.text,
                                        "salary": salaryInput.text,
                                        "contact": contactInput.text,
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
                                employeeModel.remove(index);
                            }
                        }

                    }
                }
            }

        }
    }

    Button {
        id: addEmployeeButton
        y: 978
        width: 140
        height: 52
        text: "Add Employee"
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

        onClicked: addemployeeDialog.open()
    }

    Dialog {
        id: addemployeeDialog
        title: "Add New Employee"
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel

        Column {
            spacing: 10
            width: 300

            TextField { id: newEmployeeID; placeholderText: "ID" }
            TextField { id: newEmployeeName; placeholderText: "Name" }
            TextField { id: newEmployeePosition; placeholderText: "Position" }
            TextField { id: newEmployeeSalary; placeholderText: "Salary" }
            TextField { id: newEmployeeContact; placeholderText: "Contact" }
        }

        onAccepted: {
            employeeModel.append({
               "employeeID": newEmployeeID.text,
                "name": newEmployeeName.text,
                "position": newEmployeePosition.text,
                "salary": newEmployeeSalary.text,
                "contact": newEmployeeContact.text,
                "isEditable": false
            });

            newEmployeeID.text = "";
            newEmployeeName.text = "";
            newEmployeePosition.text = "";
            newEmployeeSalary.text = "";
            newEmployeeContact.text = "";
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
