import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    anchors.fill: parent
    property StackView stackView: null

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

                    Rectangle {
                        anchors.fill: parent
                        color: "#5b99d6"

                        Column {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 120
                            anchors.leftMargin: 50
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 20

                            Text {
                                text: qsTr("PharmEase")
                                color: "#ffffff"
                                font.pixelSize: 45
                                font.bold: true
                                font.family: "Courier"
                            }

                            Text {
                                text: qsTr("Simplifying Pharmacy Management with efficiency and care.")
                                color: "#ffffff"
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
                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: parent.font.bold
                                font.family: parent.font.family
                                font.pointSize: parent.font.pointSize
                            }
                            onClicked: stackView.push("qrc:/qml/Login_administrator.qml", {"stackView": stackView})
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
                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: parent.font.bold
                                font.family: parent.font.family
                                font.pointSize: parent.font.pointSize
                            }
                            onClicked: stackView.push("qrc:/qml/Login_employee.qml", {"stackView": stackView})
                        }
                    }

                    // Connect to database status
                    Text {
                        text: dbManager.isDatabaseConnected() ? 
                              "Connected to database" : 
                              "Not connected to database"
                        color: dbManager.isDatabaseConnected() ? "#4CAF50" : "#F44336"
                        font.pixelSize: 14
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible: true
                    }
                }
            }
        }
    }
}