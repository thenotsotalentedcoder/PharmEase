import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: 1920
    height: 1080

    Image {
        id: bgimage
        anchors.fill: parent
        source:  "../../../../Downloads/medicine-capsules-global-health-with-geometric-pattern-digital-remix.jpg"
    }

    Rectangle {
        id: bgrectangle
        color: "#daeae6"
        anchors.fill: parent
        anchors.leftMargin: 110
        anchors.rightMargin: 110
        anchors.topMargin: 90
        anchors.bottomMargin: 110

        Text {
            id: employeeid
            x: 616
            y: 68
            width: 469
            height: 75
            color: "#5b99d6"
            text: qsTr("/*Employee ID*/")
            font.pixelSize: 57
            horizontalAlignment: Text.AlignHCenter
            font.family: "Tahoma"
        }

        Text {
            id: employeedesignation
            x: 474
            y: 151
            width: 752
            height: 75
            color: "#5b99d6"
            text: qsTr("/*Employee Designation*/")
            font.pixelSize: 57
            horizontalAlignment: Text.AlignHCenter
            font.family: "Tahoma"
        }

        Button {
            x: 846
            y: 588
            width: 332
            height: 99
            font.pointSize: 21
            font.family: "Tahoma"
            contentItem: Text {
                color: "#0f3861"
                text: "Track Inventory"
                font.pixelSize: 27
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                color: "#daeae6"
            }
            autoExclusive: true
        }

        Button {
            x: 1172
            y: 588
            width: 332
            height: 99
            font.pointSize: 21
            font.family: "Tahoma"
            contentItem: Text {
                color: "#0f3861"
                text: "Manage Stock"
                font.pixelSize: 27
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                color: "#daeae6"
            }
            autoExclusive: true
        }

        Button {
            x: 189
            y: 588
            width: 332
            height: 99
            font.pointSize: 21
            font.family: "Tahoma"
            contentItem: Text {
                color: "#0f3861"
                text: "Place New Order"
                font.pixelSize: 27
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                color: "#daeae6"
            }
            autoExclusive: true
        }

        Button {
            x: 520
            y: 588
            width: 332
            height: 99
            font.pointSize: 21
            font.family: "Tahoma"
            contentItem: Text {
                color: "#0f3861"
                text: "View Orders and Sales"
                font.pixelSize: 27
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                color: "#daeae6"
            }
            autoExclusive: true
        }

        Image {
            id: inventory
            x: 902
            y: 350
            width: 220
            height: 220
            source: "../../../../Downloads/inventory.png"
            fillMode: Image.PreserveAspectFit
            MouseArea {
                anchors.fill: parent
                onClicked: stackView.push("Track_inventory.qml")
            }
        }

        Image {
           id: stock
           x: 1228
           y: 350
           width: 220
           height: 220
           source: "../../../../Downloads/stock.png"
           fillMode: Image.PreserveAspectFit
           MouseArea {
               anchors.fill: parent
               onClicked: stackView.push("Manage_stock.qml")
           }
        }

        Image {
            id: placeorder
            x: 250
            y: 350
            width: 220
            height: 220
            source: "../../../../Downloads/new order.jpg"
            fillMode: Image.PreserveAspectFit
            MouseArea {
                anchors.fill: parent
                onClicked: stackView.push("Place_order.qml")
            }
        }

        Image {
           id: vieworder
           x: 576
           y: 350
           width: 220
           height: 220
           source: "../../../..//Downloads/view order.jpg"
           fillMode: Image.PreserveAspectFit
           MouseArea {
               anchors.fill: parent
               onClicked: stackView.push("View_orders.qml")
            }
        }

        Button {
            id: backbutton
            text: "Back"
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 20
            anchors.rightMargin: 20
            onClicked: stackView.pop()
        }
    }
}

