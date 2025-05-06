import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    anchors.fill: parent

    Image {
        id: bgimage
        anchors.fill: parent
        source: "file:///C:/Users/Admin/Downloads/medicine-capsules-global-health-with-geometric-pattern-digital-remix.jpg"
    }

    Rectangle {
        id: bgrectangle
        color: "#daeae6"
        anchors.fill: parent
        anchors.leftMargin: 110
        anchors.rightMargin: 110
        anchors.topMargin: 90
        anchors.bottomMargin: 110

        ColumnLayout {
            anchors.fill: parent

            // Welcome Text
            Text {
                id: welcometext
                color: "#5b99d6"
                text: qsTr("Welcome Admin!")
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 50
                horizontalAlignment: Text.AlignHCenter
                font.family: "Tahoma"
            }

            // Image and Button Row
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 4
                rowSpacing: 70
                columnSpacing: 50
                Layout.leftMargin: 120
                Layout.rightMargin: 120

                // View Employee
                Column {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 20
                    Layout.fillWidth: true

                    Image {
                        id: viewemployee
                        width: 160
                        height: 160
                        source: "file:///C:/Users/Admin/Downloads/employee.png"
                        fillMode: Image.PreserveAspectCrop
                        anchors.horizontalCenter: parent.horizontalCenter
                        MouseArea {
                            anchors.fill: parent
                            onClicked: stackView.push("Employee_details.qml")
                        }
                    }
                    Text {
                        color: "#0f3861"
                        text: "Employee Details"
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Tahoma"
                        width: 160
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // Track Inventory
                Column {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 20
                    Layout.fillWidth: true

                    Image {
                        id: inventory
                        width: 160
                        height: 160
                        source: "file:///C:/Users/Admin/Downloads/inventory.png"
                        fillMode: Image.PreserveAspectFit
                        anchors.horizontalCenter: parent.horizontalCenter
                        MouseArea {
                            anchors.fill: parent
                            onClicked: stackView.push("Track_inventory.qml")
                        }
                    }
                    Text {
                        color: "#0f3861"
                        text: "Track Inventory"
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Tahoma"
                        width: 160
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // Manage Stock
                Column {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 20
                    Layout.fillWidth: true

                    Image {
                        id: stock
                        width: 160
                        height: 160
                        source: "file:///C:/Users/Admin/Downloads/stock.png"
                        fillMode: Image.PreserveAspectFit
                        anchors.horizontalCenter: parent.horizontalCenter
                        MouseArea {
                            anchors.fill: parent
                            onClicked: stackView.push("Manage_stock.qml")
                        }
                    }
                    Text {
                        color: "#0f3861"
                        text: "Manage Stock"
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Tahoma"
                        width: 160
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // Sales Report
                Column {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 20
                    Layout.fillWidth: true

                    Image {
                        id: salesreport
                        width: 160
                        height: 160
                        source: "file:///C:/Users/Admin/Downloads/salesreport.png"
                        fillMode: Image.PreserveAspectFit
                        anchors.horizontalCenter: parent.horizontalCenter
                        MouseArea {
                            anchors.fill: parent
                            onClicked: stackView.push("Sales_report.qml")
                        }
                    }
                    Text {
                        color: "#0f3861"
                        text: "Generate Sales Report"
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Tahoma"
                        width: 160
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            Button {
                id: backbutton
                Layout.preferredWidth: 50
                Layout.preferredHeight: 30
                text: "Back"
                Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                Layout.rightMargin: 10
                Layout.bottomMargin: 10
                background: Rectangle {
                    color: parent.down ? "#d6d6d6" : "#f6f6f6"
                    border.color: "#707070"
                    border.width: 1
                }
                onClicked: stackView.pop()
            }
        }
    }
}
