import QtQuick 2.6
import Sailfish.Silica 1.0
import ".."
import "../components"

// The manual, in the app, because a new user has no idea what a DeepL key is
// and will not go looking for a README.
Page {
    id: page
    allowedOrientations: Orientation.All

    function paint() { FiatGlossaTheme.applyPalette(page) }
    Component.onCompleted: paint()
    Connections {
        target: FiatGlossaTheme
        onAmbientChanged: page.paint()
    }

    readonly property string signupUrl:
        "https://www.deepl.com/en/signup?cta=checkout&is_api=true&productId=api-developer"

    readonly property var steps: [
        { n: "1", text: "Make a DeepL account on the developer plan. The button below opens the right "
                      + "page: it is the plan for programs, not the DeepL Pro subscription for the website." },
        { n: "2", text: "DeepL may ask for a card to prove you are a person. The free plan is not charged. "
                      + "When the characters run out, translating stops until the quota resets." },
        { n: "3", text: "In the account pages, open the API keys section and copy the key. A free-tier key "
                      + "ends in :fx, and fiat glossa reads that ending to reach the right DeepL server." },
        { n: "4", text: "Come back here, open Settings, paste the key in and close the keyboard. Check the "
                      + "key in the pull-down asks DeepL how many characters are left; a number means it works." }
    ]

    Background { }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingLarge

            PageHead { title: "how to get a key" }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.Wrap
                color: FiatGlossaTheme.primaryText
                font.pixelSize: Theme.fontSizeSmall
                text: "fiat glossa translates with DeepL, using a key that belongs to you. There is no "
                    + "server of mine in between, and no account to make with me."
            }

            Repeater {
                model: page.steps

                Column {
                    width: column.width
                    spacing: Theme.paddingLarge

                    // a hairline, not a box: the steps are separated, not framed
                    Rectangle {
                        x: Theme.horizontalPageMargin
                        width: column.width - 2 * Theme.horizontalPageMargin
                        height: 1
                        color: FiatGlossaTheme.innerBorder
                    }

                    Row {
                        x: Theme.horizontalPageMargin
                        width: column.width - 2 * Theme.horizontalPageMargin
                        spacing: Theme.paddingMedium

                        Text {
                            width: Theme.itemSizeExtraSmall / 2
                            text: modelData.n
                            color: FiatGlossaTheme.accent
                            font.pixelSize: Theme.fontSizeLarge
                            font.family: FiatGlossaTheme.serif
                        }

                        Label {
                            width: parent.width - Theme.itemSizeExtraSmall / 2 - Theme.paddingMedium
                            wrapMode: Text.Wrap
                            color: FiatGlossaTheme.primaryText
                            font.pixelSize: Theme.fontSizeSmall
                            text: modelData.text
                        }
                    }
                }
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Open the DeepL sign-up"
                onClicked: Qt.openUrlExternally(page.signupUrl)
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAnywhere
                font.pixelSize: Theme.fontSizeTiny
                color: FiatGlossaTheme.secondaryText
                text: page.signupUrl
            }
        }

        VerticalScrollDecorator { }
    }
}