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

            Text {
                id: employeeid
                color: "#5b99d6"
                text: qsTr("/*Employee ID*/")
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Tahoma"
            }

            Text {
                id: employeedesignation
                color: "#5b99d6"
                text: qsTr("/*Employee Designation*/")
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Tahoma"
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

                // Place Order
                Column {
                    spacing: 18
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true


                    Image {
                        id: placeorder
                        width: 160
                        height: 160
                        source: "file:///C:/Users/Admin/Downloads/new order.jpg"
                        fillMode: Image.PreserveAspectFit
                        anchors.horizontalCenter: parent.horizontalCenter
                        MouseArea {
                            anchors.fill: parent
                            onClicked: stackView.push("Place_order.qml")
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

                    Image {
                        id: vieworder
                        width: 160
                        height: 160
                        source: "file:///C:/Users/Admin/Downloads/view order.jpg"
                        fillMode: Image.PreserveAspectFit
                        anchors.horizontalCenter: parent.horizontalCenter
                        MouseArea {
                            anchors.fill: parent
                            onClicked: stackView.push("View_orders.qml")
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
                    spacing: 18
                    Layout.alignment: Qt.AlignVCenter
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
            }

            // Back Button
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
