import QtQuick 2.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: root
    
    property Component compactRepr: CompactRepresentation {}
    property Component fullRepr: FullRepresentation {}
    
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.compactRepresentation: compactRepr
    Plasmoid.fullRepresentation: fullRepr

    property bool cardIsOn: false
}
