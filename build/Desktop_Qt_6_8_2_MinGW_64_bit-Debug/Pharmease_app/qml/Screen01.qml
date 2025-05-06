/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/

import QtQuick
import QtQuick.Controls
import UntitledProject

Rectangle {
    property StackView stackView
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

        }

    }
    Button {
        id: employeebutton
        x: 1332
        y: 531
        width: 238
        height: 75
        text: qsTr("Employee")
        highlighted: false
        display: AbstractButton.TextUnderIcon
        font.bold: true
        font.pointSize: 14
        font.family: "Tahoma"
        autoExclusive: true
        checkable: true
        icon.width: 26
        background: Rectangle {
            color: "#5b99d6"
            radius: 20
        }
        onClicked: stackView.push("Login_employee.qml")
    }

    Text {
        id: logintext
        x: 975
        y: 360
        width: 595
        height: 72
        color: "#5b99d6"
        text: qsTr("Login in as:")
        font.pixelSize: 58
        horizontalAlignment: Text.AlignHCenter
        font.styleName: "Regular"
        font.family: "Tahoma"
    }

    Button {
        id: adminbutton
        x: 975
        y: 531
        width: 238
        height: 75
        text: qsTr("Administrator")
        highlighted: false
        display: AbstractButton.TextUnderIcon
        font.pointSize: 14
        font.styleName: "Bold"
        icon.width: 26
        autoExclusive: true
        checkable: true
        font.family: "Tahoma"
        background: Rectangle {
            color: "#5b99d6"
            radius: 20
        }
        onClicked:  stackView.push("Login_administrator.qml")
    }
}

