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

                // Left Image
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

                // Right Panel - Login Form
                Column {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    spacing: 40
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        id: employeelogin1
                        color: "#5b99d6"
                        text: qsTr("Employee Login")
                        font.pixelSize: 30
                        horizontalAlignment: Text.AlignHCenter
                        font.family: "Tahoma"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        id: employeelogin2
                        color: "#6a6868"
                        text: qsTr("Enter your login details here.")
                        font.pixelSize: 15
                        font.family: "Tahoma"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    TextField {
                        id: userNameInput
                        height: 35
                        width: 330
                        placeholderText: "Enter User ID"
                        font.pixelSize: 15
                        anchors.horizontalCenter: parent.horizontalCenter
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
                        anchors.horizontalCenter: parent.horizontalCenter
                        background: Rectangle {
                            color: "white"
                            radius: 5
                            border.color: "gray"
                        }
                    }

                    Text {
                        id: loginError
                        color: "#e74c3c"
                        text: qsTr("Invalid credentials. Please try again.")
                        font.pixelSize: 14
                        visible: false
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Button {
                        id: loginButton
                        height: 45
                        width: 330
                        text: "Login"
                        font.bold: true
                        font.pointSize: 13
                        anchors.horizontalCenter: parent.horizontalCenter
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
                                loginError.visible = false
                                stackView.push("qrc:/qml/Main_employee.qml")
                            } else {
                                console.log("Invalid credentials")
                                loginError.visible = true
                                passwordInput.text = ""
                            }
                        }
                    }

                    Button {
                        id: backbutton
                        width: 100
                        height: 30
                        text: "Back"
                        anchors.horizontalCenter: parent.horizontalCenter
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
}