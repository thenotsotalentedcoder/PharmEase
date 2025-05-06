import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    anchors.fill: parent
    property string errorMessage: "Database connection error"
    
    Rectangle {
        anchors.fill: parent
        color: "#daeae6"
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 20
            width: parent.width * 0.7
            
            Text {
                text: "Database Connection Error"
                font.pixelSize: 36
                font.bold: true
                color: "#e74c3c"
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: errorMessage
                font.pixelSize: 18
                color: "#2c3e50"
                wrapMode: Text.WordWrap
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
            }
            
            Text {
                text: "Please make sure the database file exists and is accessible."
                font.pixelSize: 16
                color: "#34495e"
                wrapMode: Text.WordWrap
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
            }
            
            Button {
                text: "Retry Connection"
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 200
                Layout.preferredHeight: 50
                font.pixelSize: 16
                onClicked: {
                    if (dbManager.isDatabaseConnected()) {
                        // Reload the main screen
                        stackView.replace(Qt.createComponent("qrc:/qml/Screen01.qml").createObject(stackView, {"stackView": stackView}));
                    } else {
                        // Show error message
                        errorMessage = "Still unable to connect: " + dbManager.getLastError();
                    }
                }
            }
        }
    }
}