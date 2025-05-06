import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Item {
    id: root
    anchors.fill: parent
    property StackView stackView: null

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
            spacing: 30

            Text {
                id: welcometext
                color: "#5b99d6"
                text: qsTr("Employee Details")
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter
                font.family: "Tahoma"
                font.bold: true
                Layout.topMargin: 20
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 40
                Layout.rightMargin: 40
                spacing: 20

                TextField {
                    id: searchField
                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 40
                    placeholderText: "Search employee name..."
                    onTextChanged: {
                        if (text.length > 2) {
                            filterEmployees();
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
                    onClicked: filterEmployees();
                }
                
                Rectangle {
                    width: 20
                    height: 1
                    color: "transparent"
                }
                
                TextField {
                    id: searchField1
                    placeholderText: "Search position..."
                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 40
                    onTextChanged: {
                        if (text.length > 2) {
                            filterEmployees();
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
                    onClicked: filterEmployees();
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
                        loadEmployees();
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
                            text: "Employee ID"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 150
                        }
                        Text { 
                            text: "Employee Name"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 200
                        }
                        Text { 
                            text: "Position"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 180
                        }
                        Text { 
                            text: "Salary"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 160
                        }
                        Text { 
                            text: "Contact"
                            horizontalAlignment: Text.AlignHCenter
                            font.bold: true
                            Layout.preferredWidth: 160
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
                        model: employeeModel
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
                                    Layout.preferredWidth: 150
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    TextInput {
                                        id: idInput
                                        anchors.centerIn: parent
                                        text: model.employeeID
                                        horizontalAlignment: Text.AlignHCenter
                                        readOnly: true // ID should never be editable
                                        width: parent.width - 10
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 200
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
                                    Layout.preferredWidth: 180
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    TextInput {
                                        id: positionInput
                                        anchors.centerIn: parent
                                        text: model.position
                                        horizontalAlignment: Text.AlignHCenter
                                        readOnly: !model.isEditable
                                        width: parent.width - 10
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 160
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    TextInput {
                                        id: salaryInput
                                        anchors.centerIn: parent
                                        text: model.salary
                                        horizontalAlignment: Text.AlignHCenter
                                        readOnly: !model.isEditable
                                        width: parent.width - 10
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 160
                                    Layout.fillHeight: true
                                    color: "transparent"
                                    border.color: "#e0e0e0"
                                    
                                    TextInput {
                                        id: contactInput
                                        anchors.centerIn: parent
                                        text: model.contact
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
                                                    // Save changes to database
                                                    var employeeId = parseInt(idInput.text);
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

                                                        // Show success message
                                                        messageDialog.text = "Employee updated successfully!"
                                                        messageDialog.color = "#4CAF50"
                                                        messageDialog.open()
                                                        
                                                        // Refresh data from database
                                                        loadEmployees();
                                                    } else {
                                                        messageDialog.text = "Failed to update employee in database"
                                                        messageDialog.color = "#F44336"
                                                        messageDialog.open()
                                                    }
                                                } else {
                                                    // Enable editing
                                                    employeeModel.setProperty(index, "isEditable", true);
                                                }
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
                                                deleteConfirmDialog.employeeId = model.employeeID
                                                deleteConfirmDialog.employeeName = model.name
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
                    id: addEmployeeButton
                    text: "Add Employee"
                    Layout.preferredWidth: 140
                    Layout.preferredHeight: 40
                    background: Rectangle {
                        color: "#4CAF50"
                        radius: 5
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.bold: true
                        font.pixelSize: 14
                    }
                    onClicked: addemployeeDialog.open()
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
            id: addemployeeDialog
            title: "Add New Employee"
            modal: true
            x: parent.width / 2 - width / 2
            y: parent.height / 2 - height / 2
            width: 400
            standardButtons: Dialog.Ok | Dialog.Cancel

            ColumnLayout {
                spacing: 15
                width: parent.width
                
                Label {
                    text: "Employee Name:"
                    font.bold: true
                }
                TextField { 
                    id: newEmployeeName
                    placeholderText: "Name" 
                    Layout.fillWidth: true
                }
                
                Label {
                    text: "Position:"
                    font.bold: true
                }
                TextField { 
                    id: newEmployeePosition
                    placeholderText: "Position" 
                    Layout.fillWidth: true
                }
                
                Label {
                    text: "Salary:"
                    font.bold: true
                }
                TextField { 
                    id: newEmployeeSalary
                    placeholderText: "Salary" 
                    Layout.fillWidth: true
                    validator: DoubleValidator { bottom: 0.0 }
                }
                
                Label {
                    text: "Contact:"
                    font.bold: true
                }
                TextField { 
                    id: newEmployeeContact
                    placeholderText: "Contact" 
                    Layout.fillWidth: true
                }
            }

            onAccepted: {
                // Call C++ function to add to database
                var success = dbManager.addEmployee(
                    newEmployeeName.text,
                    newEmployeePosition.text,
                    newEmployeeSalary.text,
                    newEmployeeContact.text
                );

                if (success) {
                    // Show success message
                    messageDialog.text = "Employee added successfully!"
                    messageDialog.color = "#4CAF50"
                    messageDialog.open()
                    
                    // Refresh data from database to show the new entry
                    loadEmployees();

                    // Clear fields
                    newEmployeeName.text = "";
                    newEmployeePosition.text = "";
                    newEmployeeSalary.text = "";
                    newEmployeeContact.text = "";
                } else {
                    messageDialog.text = "Failed to add employee to database"
                    messageDialog.color = "#F44336"
                    messageDialog.open()
                }
            }
        }
        
        Dialog {
            id: deleteConfirmDialog
            title: "Confirm Delete"
            modal: true
            x: parent.width / 2 - width / 2
            y: parent.height / 2 - height / 2
            width: 400
            property int employeeId: -1
            property string employeeName: ""
            standardButtons: Dialog.Yes | Dialog.No

            Label {
                text: "Are you sure you want to delete employee: " + deleteConfirmDialog.employeeName + "?"
                wrapMode: Text.WordWrap
                width: parent.width
            }

            onAccepted: {
                // Call C++ function to delete from database
                var success = dbManager.deleteEmployee(deleteConfirmDialog.employeeId);

                if (success) {
                    // Show success message
                    messageDialog.text = "Employee deleted successfully!"
                    messageDialog.color = "#4CAF50"
                    messageDialog.open()
                    
                    // Refresh data from database
                    loadEmployees();
                } else {
                    messageDialog.text = "Failed to delete employee from database"
                    messageDialog.color = "#F44336"
                    messageDialog.open()
                }
            }
        }
        
        Dialog {
            id: messageDialog
            title: "Status"
            modal: true
            x: parent.width / 2 - width / 2
            y: parent.height / 2 - height / 2
            width: 300
            standardButtons: Dialog.Ok
            property string color: "#4CAF50"

            Label {
                id: messageText
                text: "Operation completed"
                color: messageDialog.color
                font.pixelSize: 14
                wrapMode: Text.WordWrap
                width: parent.width
            }
        }
    }

    ListModel {
        id: employeeModel
        // Will be populated from database
    }
    
    // Function to filter employees based on search criteria
    function filterEmployees() {
        if (searchField.text === "" && searchField1.text === "") {
            // If both fields are empty, load all employees
            loadEmployees();
            return;
        }
        
        // Filter based on the original data
        var filteredData = [];
        for (var i = 0; i < employeesData.length; i++) {
            var nameMatch = searchField.text === "" || 
                           employeesData[i].name.toLowerCase().includes(searchField.text.toLowerCase());
            var positionMatch = searchField1.text === "" || 
                              employeesData[i].role.toLowerCase().includes(searchField1.text.toLowerCase());
            
            if (nameMatch && positionMatch) {
                filteredData.push(employeesData[i]);
            }
        }
        
        // Update model with filtered data
        employeeModel.clear();
        for (var j = 0; j < filteredData.length; j++) {
            employeeModel.append({
                employeeID: filteredData[j].employee_id,
                name: filteredData[j].name,
                position: filteredData[j].role,
                salary: filteredData[j].salary,
                contact: filteredData[j].contact_no,
                isEditable: false
            });
        }
    }
}