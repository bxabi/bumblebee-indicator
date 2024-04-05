import QtQuick 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support
import QtQuick.Controls

Item {
    property int checkInterval: plasmoid.configuration.checkInterval
    property bool hideTemp: plasmoid.configuration.hideTemp
    property bool cardIsOn: false

    Image {
        id: logo
        source: "grayscale-logo.svg"
        sourceSize.width: parent.width
        sourceSize.height: parent.height
    }

    PlasmaCore.ToolTipArea {
        id: tooltip
        width: parent.width
        height: parent.height
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onClicked: (mouse) => {
            if (mouse.button == Qt.LeftButton) {
                root.expanded = !root.expanded;
            }
        }
    }

    //status checking
    Plasma5Support.DataSource {
        id: statusSource
        engine: 'executable'

        connectedSources: ['optirun --status']

        onNewData: (sourceName, data) => {
            var status='';
            if (data['exit code'] > 0) {
                status = data.stderr;
                logo.source='error-logo.svg';
                cardIsOn=false;
                plasmoid.status = PlasmaCore.Types.ActiveStatus
            } else {
                status = data.stdout;
                while (endsWith(status,'\n'))
                    status=status.substr(0,status.length-1);

                if (status.toLowerCase().indexOf('error')>0) {
                    logo.source='error-logo.svg';
                    cardIsOn=false;
                    plasmoid.status = PlasmaCore.Types.ActiveStatus
                }
                else if (endsWith(status,"Discrete video card is likely on.") || endsWith(status,"card is on.") || endsWith(status, 'applications using bumblebeed.')) {
                    logo.source='logo.svg';
                    cardIsOn=true;
                    plasmoid.status = PlasmaCore.Types.ActiveStatus
                }
                else {
                    logo.source='grayscale-logo.svg';
                    cardIsOn=false;
                    plasmoid.status = PlasmaCore.Types.PassiveStatus
                }
            }
            tooltip.subText=status;
        }
        interval: checkInterval * 1000
    }

    function endsWith(string, substr) {
        return string.length >= substr.length && string.substr(string.length - substr.length) == substr;
    }

    onCheckIntervalChanged: {
        statusSource.interval=checkInterval * 1000;
        resultSource.interval=checkInterval * 1000;
    }

    //temperature checking

    Text {
        id: tempText
        text: ''
        color: 'white'
        //font.bold: true
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    Plasma5Support.DataSource {
        id: resultSource
        engine: 'executable'

        connectedSources: []

        onNewData: (sourceName, data) => {
            var tmp='';
            if (data['exit code'] > 0) {
                tmp = data.stderr;
                //logo.source='error-logo.svg';
            } else {
                var result = data.stdout;
                while (endsWith(result,'\n'))
                    result=result.substr(0,result.length-1);

                var i=result.indexOf(':');
                if (i<0) tmp=result;
                else {
                    var j=result.lastIndexOf(' ');
                    tmp=result.substr(i+1,j-i-1);
                }
            }
            tempText.text=tmp+'°C';
        }
        interval: checkInterval * 1000
    }

    onHideTempChanged:  {
        root.hideTemp=hideTemp;
        updateResultSource();
    }

    onCardIsOnChanged:  {
        root.cardIsOn=cardIsOn;
        updateResultSource();
    }

    function updateResultSource() {
        if (cardIsOn && !hideTemp) {
            var url=Qt.resolvedUrl(".");
            var exec=String(url).substring(7,url.length);
            resultSource.connectedSources=['bash -c "'+exec+'locate-nvidia-smi.sh --query --display=TEMPERATURE | grep \\"GPU Current Temp\\""'];
        }
        else {
            resultSource.connectedSources=[];
            tempText.text='';
        }
    }
}
