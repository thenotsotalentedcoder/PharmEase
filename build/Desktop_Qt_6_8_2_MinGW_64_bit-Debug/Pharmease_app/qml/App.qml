import QtQuick
import QtQuick.Controls

ApplicationWindow {
    visible: true
    width: 1920
    height: 1080

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: Screen01 {
            stackView: stackView
        }
    }
}
