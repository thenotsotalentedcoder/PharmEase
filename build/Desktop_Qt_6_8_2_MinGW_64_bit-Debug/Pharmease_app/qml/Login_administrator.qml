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
        anchors.topMargin: 180
        anchors.bottomMargin: 180
        
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
            id: nametext
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
            id: introtext
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
            id: administratorlogintext
            x: 753
            y: 108
            width: 307
            height: 64
            color: "#5b99d6"
            text: qsTr("Login Admin")
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
            text: qsTr("Enter your password here.")
            font.pixelSize: 20
            font.family: "Tahoma"
        }


        TextField {
            id: passwordInput
            x: 775
            y: 295
            width: 338
            height: 42
            placeholderText: "Password"
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
            onClicked: stackView.push("Main_administrator.qml")
        }

        Button {
            id: backbutton
            x: 1430
            y: 656
            text: "Back"
            anchors.right: parent.right
               anchors.bottom: parent.bottom
               anchors.margins: 20
               anchors.rightMargin: 20
               anchors.bottomMargin: 20
               onClicked: stackView.pop()
           }
}
}
