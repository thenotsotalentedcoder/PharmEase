import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Item {
    id: root
    anchors.fill: parent

    // Property to store the employees data from C++
    property var employeesData: []

    // Function to load data from C++
    function loadEmployees() {
        // Call the C++ function to get employee data
        employeesData = dbManager.getAllEmployeesList();
        // Update the model with the retrieved data
        updateEmployeeModel();
    }

    // Function to update the model with data from C++
    function updateEmployeeModel() {
        employeeModel.clear();
        for (var i = 0; i < employeesData.length; i++) {
            employeeModel.append({
                employeeID: employeesData[i].employee_id,
                name: employeesData[i].name,
                position: employeesData[i].role,
                salary: employeesData[i].salary,
                contact: employeesData[i].contact_no,
                isEditable: false
            });
        }
    }

    // Load data when component is completed
    Component.onCompleted: {
        loadEmployees();
    }

    Rectangle {
        id: bgrectangle
        color: "#daeae6"
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent
            spacing: 50

            Text {
                id: welcometext
                color: "#5b99d6"
                text: qsTr("Employee Details")
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter
                font.family: "Tahoma"
                font.bold: true
            }

            RowLayout {
                Layout.fillWidth: true
                anchors.left: parent.left
                anchors.margins: 70
                spacing: 20

                TextField {
                    id: searchField
                    Layout.preferredWidth: 400
                    Layout.preferredHeight: 40
                    placeholderText: "Search employee ID..."
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
                        // Filter by ID
                        if (searchField.text.trim() !== "") {
                            var filteredEmployees = [];
                            for (var i = 0; i < employeesData.length; i++) {
                                if (String(employeesData[i].employee_id).includes(searchField.text)) {
                                    filteredEmployees.push(employeesData[i]);
                                }
                            }

                            employeeModel.clear();
                            for (var j = 0; j < filteredEmployees.length; j++) {
                                employeeModel.append({
                                    employeeID: filteredEmployees[j].employee_id,
                                    name: filteredEmployees[j].name,
                                    position: filteredEmployees[j].role,
                                    salary: filteredEmployees[j].salary,
                                    contact: filteredEmployees[j].contact_no,
                                    isEditable: false
                                });
                            }
                        } else {
                            // If search field is empty, show all data
                            updateEmployeeModel();
                        }
                    }
                }
                Item {
                    width: 50
                    height: 1
                }
                TextField {
                    id: searchField1
                    placeholderText: "Search employee position..."
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
                        color: "#000000"
                        text: parent.text
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: 10
                    }
                    onClicked: {
                        // Filter by position/role
                        if (searchField1.text.trim() !== "") {
                            var filteredEmployees = [];
                            for (var i = 0; i < employeesData.length; i++) {
                                if (String(employeesData[i].role).toLowerCase().includes(searchField1.text.toLowerCase())) {
                                    filteredEmployees.push(employeesData[i]);
                                }
                            }

                            employeeModel.clear();
                            for (var j = 0; j < filteredEmployees.length; j++) {
                                employeeModel.append({
                                    employeeID: filteredEmployees[j].employee_id,
                                    name: filteredEmployees[j].name,
                                    position: filteredEmployees[j].role,
                                    salary: filteredEmployees[j].salary,
                                    contact: filteredEmployees[j].contact_no,
                                    isEditable: false
                                });
                            }
                        } else {
                            // If search field is empty, show all data
                            updateEmployeeModel();
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
                        columns: 6
                        columnSpacing: 10
                        rowSpacing: 5
                        width: parent.width
                        anchors.verticalCenter: parent.verticalCenter

                        Text { text: "Employee ID"; horizontalAlignment: Text.AlignHCenter; width: 200; font.bold: true }
                        Text { text: "Employee Name"; horizontalAlignment: Text.AlignHCenter; width: 230; font.bold: true }
                        Text { text: "Position"; horizontalAlignment: Text.AlignHCenter; width: 180; font.bold: true }
                        Text { text: "Salary"; horizontalAlignment: Text.AlignHCenter; width: 160; font.bold: true }
                        Text { text: "Contact"; horizontalAlignment: Text.AlignHCenter; width: 160; font.bold: true }
                    }
                }

                ScrollView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 400
                    clip: true

                    ListView {
                        id: tableView
                        width: parent.width
                        model: employeeModel
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
                                    width: 200
                                    height: parent.height
                                    border.color: "black"

                                    TextInput {
                                        id: idInput
                                        anchors.fill: parent
                                        text: model.employeeID
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        readOnly: !model.isEditable
                                    }
                                }

                                Rectangle {
                                    width: 240
                                    height: parent.height
                                    border.color: "black"

                                    TextInput {
                                        id: nameInput
                                        anchors.fill: parent
                                        text: model.name
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        readOnly: !model.isEditable
                                    }
                                }

                                Rectangle {
                                    width: 200
                                    height: parent.height
                                    border.color: "black"

                                    TextInput {
                                        id: positionInput
                                        anchors.fill: parent
                                        text: model.position
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        readOnly: !model.isEditable
                                    }
                                }

                                Rectangle {
                                    width: 150
                                    height: parent.height
                                    border.color: "black"

                                    TextInput {
                                        id: salaryInput
                                        anchors.fill: parent
                                        text: model.salary
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        readOnly: !model.isEditable
                                    }
                                }

                                Rectangle {
                                    width: 190
                                    height: parent.height
                                    border.color: "black"

                                    TextInput {
                                        id: contactInput
                                        anchors.fill: parent
                                        text: model.contact
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        readOnly: !model.isEditable
                                    }
                                }

                                Button {
                                    width: 85
                                    height: parent.height
                                    text: model.isEditable ? "Save" : "Edit"
                                    onClicked: {
                                        if (model.isEditable) {
                                            // Save changes to database
                                            var employeeId = model.employeeID;
                                            var updatedName = nameInput.text;
                                            var updatedRole = positionInput.text;
                                            var updatedSalary = salaryInput.text;
                                            var updatedContact = contactInput.text;

                                            // Call C++ function to update database
                                            var success = dbManager.updateEmployee(
                                                employeeId,
                                                updatedName,
                                                updatedRole,
                                                updatedSalary,
                                                updatedContact
                                            );

                                            if (success) {
                                                // Update model
                                                employeeModel.set(index, {
                                                    "employeeID": employeeId,
                                                    "name": updatedName,
                                                    "position": updatedRole,
                                                    "salary": updatedSalary,
                                                    "contact": updatedContact,
                                                    "isEditable": false
                                                });

                                                // Refresh data from database
                                                loadEmployees();
                                            } else {
                                                console.log("Failed to update employee in database");
                                            }
                                        } else {
                                            // Enable editing
                                            employeeModel.setProperty(index, "isEditable", true);
                                        }
                                    }
                                }

                                Button {
                                    width: 85
                                    height: parent.height
                                    text: "Delete"
                                    Material.background: Material.Red
                                    onClicked: {
                                        // Call C++ function to delete from database
                                        var employeeId = model.employeeID;
                                        var success = dbManager.deleteEmployee(employeeId);

                                        if (success) {
                                            // Remove from model
                                            employeeModel.remove(index);
                                            // Refresh data from database
                                            loadEmployees();
                                        } else {
                                            console.log("Failed to delete employee from database");
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Button {
                id: addEmployeeButton
                Layout.preferredWidth: 140
                Layout.preferredHeight: 40
                text: "Add Employee"
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 20
                anchors.rightMargin: 150
                z: 10
                background: Rectangle {
                    color: "#fa086960"
                    radius: 5
                }
                onClicked: addemployeeDialog.open()
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
            id: addemployeeDialog
            title: "Add New Employee"
            modal: true
            standardButtons: Dialog.Ok | Dialog.Cancel

            Column {
                spacing: 10
                width: 300

                TextField { id: newEmployeeName; placeholderText: "Name" }
                TextField { id: newEmployeePosition; placeholderText: "Position" }
                TextField { id: newEmployeeSalary; placeholderText: "Salary" }
                TextField { id: newEmployeeContact; placeholderText: "Contact" }
            }

            onAccepted: {
                var success = dbManager.addEmployee(
                    newEmployeeName.text,
                    newEmployeePosition.text,
                    newEmployeeSalary.text,
                    newEmployeeContact.text
                );

                if (success) {
                    // Refresh data from database to show the new entry
                    loadEmployees();

                    // Clear fields
                    newEmployeeName.text = "";
                    newEmployeePosition.text = "";
                    newEmployeeSalary.text = "";
                    newEmployeeContact.text = "";
                } else {
                    console.log("Failed to add employee to database");
                }
            }
        }
    }

    ListModel {
        id: employeeModel
        // Empty model - will be populated from database
    }
}
