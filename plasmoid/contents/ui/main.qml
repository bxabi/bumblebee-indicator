import QtQuick 2.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

PlasmoidItem {
    id: root
    
    property Component compactRepr: CompactRepresentation {}
    property Component fullRepr: FullRepresentation {}
    
    //preferredRepresentation: compactRepresentation
    compactRepresentation: compactRepr
    fullRepresentation: fullRepr

    property bool cardIsOn: false
    property bool hideTemp: false
}
