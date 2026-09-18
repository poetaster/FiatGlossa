import QtQuick 2.6
import Sailfish.Silica 1.0
import ".."
import "../components"

Page {
    id: page
    allowedOrientations: Orientation.All

    function paint() { FiatGlossaTheme.applyPalette(page) }
    Component.onCompleted: paint()
    Connections {
        target: FiatGlossaTheme
        onAmbientChanged: page.paint()
    }

    Background { }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingLarge

            PageHead { title: "about" }

            Column {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    x: Theme.horizontalPageMargin
                    width: column.width - 2 * Theme.horizontalPageMargin
                    text: "fiat glossa"
                    color: FiatGlossaTheme.accent
                    font.pixelSize: Theme.fontSizeExtraLarge
                    font.family: FiatGlossaTheme.serif
                    font.italic: true
                }

                Label {
                    x: Theme.horizontalPageMargin
                    width: column.width - 2 * Theme.horizontalPageMargin
                    text: "version 1.0"
                    color: FiatGlossaTheme.secondaryText
                    font.pixelSize: Theme.fontSizeExtraSmall
                }
            }

            Rectangle {
                x: Theme.horizontalPageMargin
                width: column.width - 2 * Theme.horizontalPageMargin
                height: 1
                color: FiatGlossaTheme.innerBorder
            }

            Label {
                x: Theme.horizontalPageMargin
                width: column.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.Wrap
                color: FiatGlossaTheme.primaryText
                font.pixelSize: Theme.fontSizeSmall
                text: "Glossa is the tongue, and a gloss is what someone wrote in the margin when the "
                    + "word was hard. This is a small translator for Sailfish OS, one of the Fiat family."
            }

            Label {
                x: Theme.horizontalPageMargin
                width: column.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.Wrap
                color: FiatGlossaTheme.primaryText
                font.pixelSize: Theme.fontSizeSmall
                text: "Translations come from DeepL, with a key that belongs to you. fiat glossa has no "
                    + "server and no account: your text goes from the phone to DeepL and nowhere else."
            }

            Label {
                x: Theme.horizontalPageMargin
                width: column.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.Wrap
                color: FiatGlossaTheme.primaryText
                font.pixelSize: Theme.fontSizeSmall
                text: "English (Traditional) against English (Simplified) is settled on the phone, from a "
                    + "word table, with no request and no characters spent. It is a joke that happens to "
                    + "be the fastest path in the app."
            }

            Rectangle {
                x: Theme.horizontalPageMargin
                width: column.width - 2 * Theme.horizontalPageMargin
                height: 1
                color: FiatGlossaTheme.innerBorder
            }

            Label {
                x: Theme.horizontalPageMargin
                width: column.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.Wrap
                color: FiatGlossaTheme.secondaryText
                font.pixelSize: Theme.fontSizeExtraSmall
                text: "By Caesar Ivarsson, Munkstolen. Released under the GPL, version 3.\n"
                    + "DeepL is a trademark of DeepL SE, which has nothing to do with this app."
            }
        }

        VerticalScrollDecorator { }
    }
}