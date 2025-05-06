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

                // Left Image Section
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

                // Right Login Form Section
                Column {
                    Layout.fillWidth: true
                    spacing: 40
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter


                    Text {
                        id: adminlogin
                        color: "#5b99d6"
                        text: qsTr("Admin Login")
                        font.pixelSize: 30
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: "Tahoma"
                    }

                    Text {
                        id: administratorlogintext
                        color: "#6a6868"
                        text: qsTr("Enter your password here.")
                        font.pixelSize: 15
                        font.family: "Tahoma"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Item {
                        Layout.preferredHeight: 20
                        width: 1
                    }

                    TextField {
                        id: passwordInput
                        width: 330
                        height: 35
                        placeholderText: "Password"
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
                        text: qsTr("Invalid password. Please try again.")
                        font.pixelSize: 14
                        visible: false
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Button {
                        id: loginButton
                        width: 330
                        height: 45
                        Layout.alignment: Qt.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Login"
                        font.bold: true
                        font.pointSize: 13
                        background: Rectangle {
                            color: "#5b99d6"
                            radius: 10
                        }
                        onClicked: {
                            const password = passwordInput.text;
                            if (dbManager.verifyAdminLogin(password)) {
                                console.log("Admin login successful");
                                loginError.visible = false;
                                stackView.push("qrc:/qml/Main_administrator.qml");
                            } else {
                                console.log("Invalid admin password");
                                loginError.visible = true;
                                passwordInput.text = "";
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