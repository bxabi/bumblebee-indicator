import QtQuick 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick.Controls 1.4

Item {
    id: fullRepr
    
    width: 600

    PlasmaCore.DataSource {
        id: dataSource
        engine: 'executable'
        connectedSources:[]

        onNewData: {
            cardData.text=data.stdout;
            fullRepr.width=cardData.paintedWidth;
        }
    }

    ScrollView {
        anchors.fill: parent

        Text {
            id: cardData
            font.family: 'monospace'
            color: PlasmaCore.ColorScope.textColor;
        }
    }

    ListView {
        id: data

        model: PlasmaCore.DataModel {
                dataSource: dataSource
        }
    }

    onVisibleChanged: {
        cardData.text='Loading ...';
        if (visible) {
            dataSource.connectedSources=['optirun nvidia-smi -q']
        }
        else {
            dataSource.connectedSources=[];
        }
    }
}
