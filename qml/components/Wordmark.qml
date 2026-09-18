import QtQuick 2.6
import Sailfish.Silica 1.0
import ".."

// Top-left, as high as the screen allows. Lowercase, serif, italic. Centred
// on the system indicator row rather than given a top margin: a centred
// cutout never reaches the corner.
Item {
    width: parent ? parent.width : 0
    height: FiatGlossaTheme.statusRowCenter + mark.height / 2 + Theme.paddingMedium

    Text {
        id: mark
        anchors.left: parent.left
        anchors.leftMargin: Theme.horizontalPageMargin
        anchors.top: parent.top
        anchors.topMargin: Math.max(0, FiatGlossaTheme.statusRowCenter - height / 2)
        text: "fiat glossa"
        color: FiatGlossaTheme.primaryText
        font.pixelSize: Theme.fontSizeLarge
        font.family: FiatGlossaTheme.serif
        font.italic: true
    }
}
