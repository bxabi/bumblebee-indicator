plasmapkg2 --remove com.bxabi.bumblebee-indicator
rm -r ~/.local/share/plasma/plasmoids/com.bxabi.bumblebee-indicator
plasmapkg2 --install plasmoid
plasmawindowed com.bxabi.bumblebee-indicator
