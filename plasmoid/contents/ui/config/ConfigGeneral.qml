import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {
    property alias cfg_checkInterval: checkInterval.value
    
    GridLayout {
        columns: 2
        anchors.left: parent.left
        anchors.right: parent.right
        
        Label {
            text: i18n('Check interval in seconds:')
            Layout.alignment: Qt.AlignRight
        }
        SpinBox {
            id: checkInterval
	    minimumValue: 1
	    maximumValue: 30
	}
    }    
}
