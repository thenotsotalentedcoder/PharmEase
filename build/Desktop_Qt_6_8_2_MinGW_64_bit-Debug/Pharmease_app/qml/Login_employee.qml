import QtQuick
import QtQuick.Controls

Rectangle {
    id: bgrectangle
    width: 1920
    height: 1080
    color: "#99c4bf"
    Rectangle {
        id: layer2rectangle
        color: "#daeae6"
        anchors.fill: parent
        anchors.leftMargin: 180
        anchors.rightMargin: 180
        anchors.topMargin: 162
        anchors.bottomMargin: 198
        
        Image {
            id: layer3image
            width: 600
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.bottomMargin: 0
            source: "../../../../Downloads/medicine-capsules-global-health-with-geometric-pattern-digital-remix.jpg"
            fillMode: Image.PreserveAspectCrop 
        }

        Text {
            id: name
            x: 101
            y: 133
            width: 399
            height: 100
            color: "#1c241e"
            text: qsTr("PharmEase")
            font.pixelSize: 70
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
            font.family: "Courier"
        }

        Text {
            id: intro
            x: 117
            y: 232
            width: 423
            height: 98
            color: "#1c241e"
            text: qsTr("Simplifying Pharmacy Management with efficiency and care.")
            font.pixelSize: 25
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WordWrap
            style: Text.Sunken
            textFormat: Text.PlainText
            font.family: "Tahoma"
        }

        Text {
            id: employeelogin1
            x: 753
            y: 108
            width: 383
            height: 66
            color: "#5b99d6"
            text: qsTr("Login Employee")
            font.pixelSize: 50
            horizontalAlignment: Text.AlignHCenter
            font.family: "Tahoma"
        }

        Text {
            id: employeelogin2
            x: 775
            y: 232
            width: 376
            height: 42
            color: "#6a6868"
            text: qsTr("Enter your login details here.")
            font.pixelSize: 20
            font.family: "Tahoma"
        }

        TextField {
            id: userIdInput
            x: 775
            y: 301
            width: 338
            height: 50
            placeholderText: "Enter User ID"
            font.pixelSize: 18
            background: Rectangle {
                color: "white"
                radius: 5
                border.color: "gray"
            }
        }

        TextField {
            id: passwordInput
            x: 775
            y: 390
            width: 338
            height: 42
            placeholderText: "Enter Password"
            echoMode: TextInput.Password
            font.pixelSize: 18
            background: Rectangle {
                color: "white"
                radius: 5
                border.color: "gray"
            }
        }

        Button {
            id: loginButton
            x: 775
            y: 510
            width: 505
            height: 42
            text: "Login"
            font.bold: true
            font.pointSize: 13
            background: Rectangle {
                color: "#5b99d6"
                radius: 10
            }
            onClicked: stackView.push("Main_employee.qml")
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
