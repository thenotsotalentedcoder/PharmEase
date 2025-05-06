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

                // Left Image Section
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

                // Right Login Form Section
                Column {
                    Layout.fillWidth: true
                    spacing: 40
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter


                    Text {
                        id: adminlogin
                        color: "#5b99d6"
                        text: qsTr("Login Admin")
                        font.pixelSize: 30
                        horizontalAlignment: Text.AlignHCenter
                        anchors.top: parent
                        anchors.topMargin: 200
                        font.family: "Tahoma"
                    }

                    Text {
                        id: administratorlogintext
                        color: "#6a6868"
                        text: qsTr("Enter your password here.")
                        font.pixelSize: 15
                        font.family: "Tahoma"
                    }

                    Item {
                        Layout.preferredHeight: 20
                    }

                    TextField {
                        id: passwordInput
                        width: 330
                        height: 35
                        placeholderText: "Password"
                        echoMode: TextInput.Password
                        font.pixelSize: 15
                        background: Rectangle {
                            color: "white"
                            radius: 5
                            border.color: "gray"
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }

                    Button {
                        id: loginButton
                        width: 380
                        height: 45
                        Layout.alignment: Qt.AlignHCenter
                        anchors.bottom: parent
                        anchors.bottomMargin: 100
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
                                    stackView.push("Main_administrator.qml");  // or your admin main screen
                                } else {
                                    console.log("Invalid admin password");
                                    // Optionally show an error popup or visual feedback
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

