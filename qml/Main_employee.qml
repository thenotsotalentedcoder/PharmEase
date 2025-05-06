import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    anchors.fill: parent
    property StackView stackView: null

    Rectangle {
        id: bgrectangle
        color: "#daeae6"
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent

            Text {
                id: employeeid
                color: "#5b99d6"
                text: qsTr("Employee Portal")
                font.pixelSize: 40
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Tahoma"
                font.bold: true
                Layout.topMargin: 40
            }

            Text {
                id: employeedesignation
                color: "#5b99d6"
                text: qsTr("Welcome to PharmEase")
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Tahoma"
                Layout.topMargin: 10
            }

            // Images Row
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 4
                rowSpacing: 70
                columnSpacing: 50
                Layout.leftMargin: 120
                Layout.rightMargin: 120
                Layout.topMargin: 40

                // Place Order
                Column {
                    spacing: 18
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true

                    Rectangle {
                        width: 160
                        height: 160
                        color: "#7cc660"
                        radius: 80
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text {
                            text: "🛒"
                            font.pixelSize: 80
                            anchors.centerIn: parent
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: stackView.push("qrc:/qml/Place_order.qml")
                        }
                    }
                    
                    Text {
                        color: "#0f3861"
                        text: "Place New Order"
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Tahoma"
                        width: 160
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // View Orders
                Column {
                    spacing: 18
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true

                    Rectangle {
                        width: 160
                        height: 160
                        color: "#3c61b1"
                        radius: 80
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text {
                            text: "📋"
                            font.pixelSize: 80
                            anchors.centerIn: parent
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: stackView.push("qrc:/qml/View_orders.qml")
                        }
                    }
                    
                    Text {
                        color: "#0f3861"
                        text: "View Orders and Sales"
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
                    spacing: 18
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true

                    Rectangle {
                        width: 160
                        height: 160
                        color: "#FF9800"
                        radius: 80
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text {
                            text: "📊"
                            font.pixelSize: 80
                            anchors.centerIn: parent
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: stackView.push("qrc:/qml/Track_inventory.qml")
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
                    spacing: 18
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true

                    Rectangle {
                        width: 160
                        height: 160
                        color: "#E91E63"
                        radius: 80
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text {
                            text: "📦"
                            font.pixelSize: 80
                            anchors.centerIn: parent
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: stackView.push("qrc:/qml/Manage_stock.qml")
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
            }

            // Back Button
            Button {
                id: backbutton
                Layout.preferredWidth: 100
                Layout.preferredHeight: 40
                text: "Logout"
                Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                Layout.rightMargin: 20
                Layout.bottomMargin: 20
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