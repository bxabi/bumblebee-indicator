import QtQuick 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick.Controls 1.4

Item {
    id: fullRepr
    property bool onlyIfOn: plasmoid.configuration.onlyIfOn

    width: 600

    PlasmaCore.DataSource {
        id: dataSource
        engine: 'executable'
        connectedSources:[]

        onNewData: {
            cardData.text=data.stdout;
            //fullRepr.width=cardData.paintedWidth;
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
        if (visible) {
            if (root.cardIsOn || !onlyIfOn) {
                cardData.text='Loading ...';
                var url=Qt.resolvedUrl(".");
                var exec=url.substring(7,url.length);
                dataSource.connectedSources=['bash -c "'+exec+'locate-nvidia-smi.sh -q"']
            }
            else {
                cardData.text='Your settings allow showing the info\nonly if the card is on.';
            }
        }
        else {
            dataSource.connectedSources=[];
        }
    }
}
