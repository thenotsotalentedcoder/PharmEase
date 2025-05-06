import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    anchors.fill: parent

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

                // Left Image
                Item {
                    Layout.preferredWidth: parent.width * 0.4
                    Layout.fillHeight: true

                    Image {
                        id: layer3image
                        anchors.fill: parent
                        source: "file:///C:/Users/Admin/Downloads/medicine-capsules-global-health-with-geometric-pattern-digital-remix.jpg"
                        fillMode: Image.PreserveAspectCrop
                    }

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

                // Right Panel - Login Form
                Column {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    spacing: 40
                    anchors.verticalCenter: parent.verticalCenter

                        Text {
                            id: employeelogin1
                            color: "#5b99d6"
                            text: qsTr("Login Employee")
                            font.pixelSize: 30
                            horizontalAlignment: Text.AlignHCenter
                            font.family: "Tahoma"
                        }

                        Text {
                            id: employeelogin2
                            color: "#6a6868"
                            text: qsTr("Enter your login details here.")
                            font.pixelSize: 15
                            font.family: "Tahoma"
                        }

                        TextField {
                            id: userNameInput
                            height: 35
                            width: 330
                            placeholderText: "Enter User ID"
                            font.pixelSize: 15
                            background: Rectangle {
                                color: "white"
                                radius: 5
                                border.color: "gray"
                            }
                        }

                        TextField {
                            id: passwordInput
                            height: 35
                            width: 330
                            placeholderText: "Enter Password"
                            echoMode: TextInput.Password
                            font.pixelSize: 15
                            background: Rectangle {
                                color: "white"
                                radius: 5
                                border.color: "gray"
                            }
                        }

                        Button {
                            id: loginButton
                            height: 45
                            width: 380
                            text: "Login"
                            font.bold: true
                            font.pointSize: 13
                            background: Rectangle {
                                color: "#5b99d6"
                                radius: 10
                            }
                            onClicked: {
                                let userName = userNameInput.text
                                let password = passwordInput.text
                                let success = dbManager.verifyEmployeeLogin(userName, password)

                                if (success) {
                                    console.log("Login successful!")
                                    stackView.push("Main_employee.qml")
                                } else {
                                    console.log("Invalid credentials")
                                    passwordInput.text = ""
                                    userNameInput.text = ""
                                }
                            }

                        }
                    }
                    Item {
                        Layout.fillHeight: true
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
    }
