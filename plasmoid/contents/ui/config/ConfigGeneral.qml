import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {
    property alias cfg_checkInterval: checkInterval.value
    property alias cfg_onlyIfOn: onlyIfOn.checked

    GridLayout {
        columns: 2
        anchors.left: parent.left
        anchors.right: parent.right

        Label {
            text: i18n('Check interval in seconds:')
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight
        }
        SpinBox {
            id: checkInterval
            minimumValue: 1
            maximumValue: 30
        }

        Label {
            text: i18n('Show the info page only if the card is already on (use this if you have a bumblebee driver bug when the card is not turned back off once started):')
            Layout.alignment: Qt.AlignRight
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
        CheckBox {
            id: onlyIfOn
            checked: false
        }
    }    
}
