import QtQuick 2.6
import Sailfish.Silica 1.0
import ".."

// Replaces Silica's PageHeader, which draws its title in Theme.highlightColor
// and cannot be recoloured. The title hangs from the TOP of the band, never
// bottom-aligned, so every page's title sits on the same line whether or not
// anything follows it. Only the title takes the cutout clearance.
Item {
    property alias title: label.text

    width: parent ? parent.width : 0
    height: FiatGlossaTheme.headerTopInset + label.height + Theme.paddingLarge

    Text {
        id: label
        anchors.left: parent.left
        anchors.leftMargin: Theme.horizontalPageMargin * 2
        anchors.right: parent.right
        anchors.rightMargin: Theme.horizontalPageMargin
        anchors.top: parent.top
        anchors.topMargin: FiatGlossaTheme.headerTopInset
        horizontalAlignment: Text.AlignRight
        elide: Text.ElideLeft
        color: FiatGlossaTheme.primaryText
        font.pixelSize: Theme.fontSizeLarge
        font.family: FiatGlossaTheme.serif
        font.italic: true
    }
}
