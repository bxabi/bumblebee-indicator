import QtQuick 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick.Controls
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.kirigami as Kirigami
import QtQuick.Layouts

Item {
    id: fullRepr
    property bool onlyIfOn: plasmoid.configuration.onlyIfOn

    property int defaultWidth: 200

    Layout.preferredWidth: cardData.paintedWidth <= defaultWidth ? defaultWidth : (cardData.paintedWidth + scrollView.ScrollBar.vertical.width + 1);

    Plasma5Support.DataSource {
        id: dataSource
        engine: 'executable'
        connectedSources:[]

        onNewData: (sourceName, data) => {
            cardData.text=data.stdout;
            //fullRepr.width=cardData.paintedWidth;

        }
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent

        Text {
            id: cardData
            font.family: 'monospace'
            color: Kirigami.Theme.textColor;
        }
    }

    ListView {
        id: data

        model: Plasma5Support.DataModel {
            dataSource: dataSource
        }
    }

    Connections {
        target: root
        ignoreUnknownSignals: true
        function onExpandedChanged () {
            if (root.expanded) {
                if (root.cardIsOn || !onlyIfOn) {
                    var withOptirun="";
                    if (!root.cardIsOn)
                        withOptirun="optirun ";

                    cardData.text='Loading ...';
                    var url=Qt.resolvedUrl(".");
                    var exec=String(url).substring(7,url.length);
                    dataSource.connectedSources=['bash -c "'+withOptirun+exec+'locate-nvidia-smi.sh -q"']
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
}
