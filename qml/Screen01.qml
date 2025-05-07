import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    anchors.fill: parent
    property StackView stackView

    Rectangle {
        id: bgrectangle
        anchors.fill: parent
        color: "#99c4bf"

        Rectangle {
            id: layer2rectangle
            anchors.fill: parent
            anchors.margins: 100
            color: "#daeae6"

            RowLayout {
                anchors.fill: parent
                spacing: 40

                // Left Image with overlayed text
                Item {
                    Layout.preferredWidth: parent.width * 0.4
                    Layout.fillHeight: true

                    Image {
                        id: layer3image
                        anchors.fill: parent
                        source: "file:///C:/Users/Admin/Downloads/medicine-capsules-global-health-with-geometric-pattern-digital-remix.jpg"
                        fillMode: Image.PreserveAspectCrop

                        Column {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 120
                            anchors.leftMargin: 50
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 20

                            Text {
                                text: qsTr("PharmEase")
                                color: "#1c241e"
                                font.pixelSize: 45
                                font.bold: true
                                font.family: "Courier"
                            }

                            Text {
                                text: qsTr("Simplifying Pharmacy Management with efficiency and care.")
                                color: "#1c241e"
                                font.pixelSize: 20
                                wrapMode: Text.WordWrap
                                font.family: "Tahoma"
                                width: 350
                            }
                        }
                    }
                }

                // Right Side Login Options
                Column {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    spacing: 40
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: qsTr("Login in as:")
                        color: "#5b99d6"
                        font.pixelSize: 48
                        font.family: "Tahoma"
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Row {
                        spacing: 30
                        anchors.horizontalCenter: parent.horizontalCenter

                        Button {
                            text: qsTr("Administrator")
                            width: 200
                            height: 60
                            font.pointSize: 14
                            font.bold: true
                            font.family: "Tahoma"
                            background: Rectangle {
                                color: "#5b99d6"
                                radius: 20
                            }
                            onClicked: stackView.push("Login_administrator.qml")
                        }

                        Button {
                            text: qsTr("Employee")
                            width: 200
                            height: 60
                            font.pointSize: 14
                            font.bold: true
                            font.family: "Tahoma"
                            background: Rectangle {
                                color: "#5b99d6"
                                radius: 20
                            }
                            onClicked: stackView.push("Login_employee.qml")
                        }
                    }
                }
            }
        }
    }
}

