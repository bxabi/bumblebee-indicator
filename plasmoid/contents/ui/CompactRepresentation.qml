import QtQuick 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    property int checkInterval: plasmoid.configuration.checkInterval
  
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
    
    PlasmaCore.DataSource {
        id: statusSource
        engine: 'executable'
        
        connectedSources: ['optirun --status']
        
        onNewData: {
	    var status='';
            if (data['exit code'] > 0) {
                status = data.stderr; 
                logo.source='';
            } else {
                status = data.stdout;
                while (endsWith(status,'\n'))
                    status=status.substr(0,status.length-1);
                if (endsWith(status,"Discrete video card is likely on.") || endsWith(status, 'applications using bumblebeed.')) {
                    logo.source='logo.svg';
                }
                else
                    logo.source='grayscale-logo.svg';
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
    }
}
