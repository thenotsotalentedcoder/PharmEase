import QtQuick
import QtQuick.Controls
import QtQuick.Window

ApplicationWindow {
    id: appWindow
    width: Screen.width
    height: Screen.height
    visible: true
    visibility: "Maximized"
    title: "PharmEase - Pharmacy Management System"
    
    // Property to track database connection status
    property bool databaseConnected: dbManager ? dbManager.isDatabaseConnected() : false
    
    // Connections to handle database errors
    Connections {
        target: dbManager
        function onDatabaseError(errorMessage) {
            errorDialog.errorMessage = errorMessage
            errorDialog.open()
        }
    }
    
    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: databaseConnected ? 
            Qt.createComponent("qrc:/qml/Screen01.qml").createObject(stackView, {"stackView": stackView}) :
            Qt.createComponent("qrc:/qml/DatabaseError.qml").createObject(stackView, {"errorMessage": "Database connection failed"})
    }
    
    // Error dialog for database issues
    Dialog {
        id: errorDialog
        title: "Database Error"
        property string errorMessage: ""
        
        Label {
            text: errorDialog.errorMessage
            wrapMode: Text.WordWrap
        }
        
        standardButtons: Dialog.Ok
        modal: true
        closePolicy: Popup.CloseOnEscape
    }
    
    // Function to go back to home screen
    function goHome() {
        stackView.pop(null);
    }
    
    Component.onCompleted: {
        console.log("App started, database connected: " + databaseConnected);
    }
}