import QtQuick
import QtQuick.Controls

ApplicationWindow {
    width: Screen.width
    height: Screen.height
    visibility: "Maximized"

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: Screen01 {
            stackView: stackView
        }
    }
}
