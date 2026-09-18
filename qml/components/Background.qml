import QtQuick 2.6
import ".."

// Painted only under Fiat colours. Under an ambience there is no background
// rectangle at all -- the wallpaper is the background.
Rectangle {
    anchors.fill: parent
    visible: !FiatGlossaTheme.ambient
    gradient: Gradient {
        GradientStop { position: 0.0; color: FiatGlossaTheme.backgroundHigh }
        GradientStop { position: 1.0; color: FiatGlossaTheme.backgroundLow }
    }
}
