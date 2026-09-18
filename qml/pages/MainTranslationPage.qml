import QtQuick 2.6
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import ".."
import "../components"

Page {
    id: page
    allowedOrientations: Orientation.All

    // ---- Fiat colours: every page paints itself ----
    function paint() { FiatGlossaTheme.applyPalette(page) }
    Component.onCompleted: {
        paint()
        restoreLanguages()
    }
    Connections {
        target: FiatGlossaTheme
        onAmbientChanged: page.paint()
    }

    // ---- languages ----
    // A language is identified by its DeepL TARGET code, because that is the
    // code that tells the variants apart -- and the variants are the point of
    // this app. DeepL's source_lang knows no variants, so the backend derives
    // it: EN-GB and EN-US both go out as EN.
    readonly property var languages: [
        { name: "Detect language",       code: "" },
        { name: "English (Traditional)", code: "EN-GB" },
        { name: "English (Simplified)",  code: "EN-US" },
        { name: "Chinese (Traditional)", code: "ZH-HANT" },
        { name: "Chinese (Simplified)",  code: "ZH-HANS" },
        { name: "Swedish",               code: "SV" },
        { name: "Finnish",               code: "FI" },
        { name: "Norwegian",             code: "NB" },
        { name: "Danish",                code: "DA" },
        { name: "German",                code: "DE" },
        { name: "Dutch",                 code: "NL" },
        { name: "French",                code: "FR" },
        { name: "Italian",               code: "IT" },
        { name: "Spanish",               code: "ES" },
        { name: "Portuguese (Portugal)", code: "PT-PT" },
        { name: "Portuguese (Brazil)",   code: "PT-BR" },
        { name: "Russian",               code: "RU" },
        { name: "Ukrainian",             code: "UK" },
        { name: "Polish",                code: "PL" },
        { name: "Czech",                 code: "CS" },
        { name: "Slovak",                code: "SK" },
        { name: "Slovenian",             code: "SL" },
        { name: "Estonian",              code: "ET" },
        { name: "Latvian",               code: "LV" },
        { name: "Lithuanian",            code: "LT" },
        { name: "Greek",                 code: "EL" },
        { name: "Hungarian",             code: "HU" },
        { name: "Romanian",              code: "RO" },
        { name: "Bulgarian",             code: "BG" },
        { name: "Turkish",               code: "TR" },
        { name: "Arabic",                code: "AR" },
        { name: "Hebrew",                code: "HE" },
        { name: "Japanese",              code: "JA" },
        { name: "Korean",                code: "KO" },
        { name: "Indonesian",            code: "ID" },
        { name: "Vietnamese",            code: "VI" },
        { name: "Thai",                  code: "TH" }
    ]
    readonly property var targetLanguages: languages.slice(1)

    property bool ready: false
    property int sourceIndex: 0
    property int targetIndex: 0

    readonly property string sourceCode: languages[sourceIndex].code
    readonly property string targetCode: targetLanguages[targetIndex].code

    // The button shows the code, the menu shows the name: a code is short
    // enough to sit on one line beside its twin, and this is an instrument.
    readonly property string sourceLabel: sourceIndex === 0 ? "detect" : sourceCode
    readonly property string targetLabel: targetCode

    // Swapping needs somewhere to swap to. Under "Detect language" that means
    // DeepL must have told us what it detected.
    readonly property bool canSwap: sourceIndex > 0
        || (glossa.detectedSource !== "" && indexOf(targetLanguages, glossa.detectedSource) >= 0)

    function indexOf(list, code) {
        for (var i = 0; i < list.length; ++i)
            if (list[i].code === code) return i
        return -1
    }

    function systemTarget() {
        var name = Qt.locale().name             // "sv_SE", "en_GB", "zh_TW" ...
        var lang = name.split("_")[0].toUpperCase()
        if (lang === "EN")
            return (name === "en_GB" || name === "en_IE" || name === "en_AU" || name === "en_NZ")
                   ? "EN-GB" : "EN-US"
        if (lang === "ZH")
            return (name === "zh_TW" || name === "zh_HK") ? "ZH-HANT" : "ZH-HANS"
        if (lang === "PT")
            return name === "pt_BR" ? "PT-BR" : "PT-PT"
        if (lang === "NO" || lang === "NN") return "NB"
        return indexOf(targetLanguages, lang) >= 0 ? lang : "EN-US"
    }

    function restoreLanguages() {
        var s = indexOf(languages, sourceConfig.value)
        sourceIndex = s >= 0 ? s : 0
        var t = indexOf(targetLanguages, targetConfig.value)
        if (t < 0) t = indexOf(targetLanguages, systemTarget())
        targetIndex = Math.max(0, t)
        ready = true
    }

    function selectionChanged() {
        if (!ready) return
        sourceConfig.value = sourceCode
        targetConfig.value = targetCode
        glossa.cancel()
    }

    function translateNow() {
        input.focus = false
        glossa.translate(input.text, sourceCode, targetCode)
    }

    function swapLanguages() {
        var from = sourceIndex > 0 ? sourceCode : glossa.detectedSource
        var to = targetCode
        var carried = glossa.translation

        ready = false
        sourceIndex = Math.max(0, indexOf(languages, to))
        targetIndex = Math.max(0, indexOf(targetLanguages, from))
        ready = true
        selectionChanged()

        if (carried !== "")
            input.text = carried
    }

    ConfigurationValue {
        id: sourceConfig
        key: "/apps/harbour-fiatglossa/source"
        defaultValue: ""
    }
    ConfigurationValue {
        id: targetConfig
        key: "/apps/harbour-fiatglossa/target"
        defaultValue: ""
    }

    Background { }

    SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: height              // the split fills the page; nothing scrolls

        PullDownMenu {
            MenuItem {
                text: FiatGlossaTheme.ambient ? "Fiat colours" : "Follow ambience"
                color: FiatGlossaTheme.primaryText
                onClicked: FiatGlossaTheme.setAmbient(!FiatGlossaTheme.ambient)
            }
            MenuItem {
                text: "About"
                color: FiatGlossaTheme.primaryText
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: "Settings"
                color: FiatGlossaTheme.primaryText
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }
            MenuItem {
                text: "Clear"
                color: FiatGlossaTheme.primaryText
                enabled: input.text !== ""
                onClicked: {
                    input.text = ""
                    glossa.cancel()
                    glossa.translate("", page.sourceCode, page.targetCode)
                }
            }
        }

        PushUpMenu {
            MenuItem {
                text: "Copy translation"
                color: FiatGlossaTheme.primaryText
                enabled: glossa.translation !== ""
                onClicked: Clipboard.text = glossa.translation
            }
        }

        // ---- head: wordmark, then the two languages on one line ----
        Column {
            id: head
            width: parent.width
            anchors.top: parent.top

            Wordmark { }

            Item {
                width: parent.width
                height: pickers.height + Theme.paddingLarge

                Row {
                    id: pickers
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Theme.paddingMedium

                    Button {
                        id: fromButton
                        text: page.sourceLabel
                        preferredWidth: Theme.buttonWidthSmall
                        onClicked: fromMenu.show(fromButton)
                    }

                    IconButton {
                        anchors.verticalCenter: fromButton.verticalCenter
                        icon.source: "image://theme/icon-m-swap"
                        enabled: page.canSwap
                        onClicked: page.swapLanguages()
                    }

                    Button {
                        id: toButton
                        text: page.targetLabel
                        preferredWidth: Theme.buttonWidthSmall
                        onClicked: toMenu.show(toButton)
                    }
                }
            }
        }

        // ---- the split: what you type above, what comes back below ----
        Item {
            id: split
            anchors.top: head.bottom
            anchors.bottom: status.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottomMargin: Theme.paddingSmall

            readonly property real halfHeight: (height - Theme.paddingMedium) / 2

            Rectangle {
                id: inputCard
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                height: split.halfHeight
                radius: FiatGlossaTheme.cardRadius
                color: FiatGlossaTheme.card
                border.color: FiatGlossaTheme.cardBorder
                border.width: FiatGlossaTheme.cardBorderWidth

                Flickable {
                    anchors.fill: parent
                    anchors.margins: Theme.paddingMedium
                    contentHeight: input.height
                    clip: true

                    TextArea {
                        id: input
                        width: parent.width
                        backgroundStyle: TextEditor.NoBackground
                        placeholderText: "Write or paste text"
                        color: FiatGlossaTheme.primaryText
                    }
                }
            }

            Rectangle {
                anchors.top: inputCard.bottom
                anchors.topMargin: Theme.paddingMedium
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                height: split.halfHeight
                radius: FiatGlossaTheme.cardRadius
                color: FiatGlossaTheme.card
                border.color: FiatGlossaTheme.cardBorder
                border.width: FiatGlossaTheme.cardBorderWidth

                Flickable {
                    anchors.fill: parent
                    anchors.margins: Theme.paddingMedium
                    contentHeight: output.height
                    clip: true

                    TextArea {
                        id: output
                        width: parent.width
                        readOnly: true              // still selectable and copyable
                        backgroundStyle: TextEditor.NoBackground
                        text: glossa.translation
                        placeholderText: glossa.busy ? "" : "The translation appears here"
                        color: FiatGlossaTheme.primaryText
                        font.family: FiatGlossaTheme.serif
                    }
                }

                BusyIndicator {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: Theme.paddingLarge
                    size: BusyIndicatorSize.Small
                    running: glossa.busy
                }
            }
        }

        // ---- status, then the primary action, low, where the thumb is ----
        Label {
            id: status
            anchors.bottom: go.top
            anchors.bottomMargin: Theme.paddingSmall
            x: Theme.horizontalPageMargin
            width: parent.width - 2 * Theme.horizontalPageMargin
            horizontalAlignment: Text.AlignHCenter
            truncationMode: TruncationMode.Fade
            font.pixelSize: Theme.fontSizeExtraSmall
            color: glossa.error !== "" ? FiatGlossaTheme.wrong : FiatGlossaTheme.secondaryText
            text: glossa.error !== "" ? glossa.error
                : glossa.local ? "Respelt on the phone. Nothing sent, nothing spent."
                : glossa.translation !== "" ? "via DeepL, " + glossa.billedCharacters + " characters"
                : !glossa.hasKey ? "No DeepL key yet. Settings, then How to get a key."
                : ""
        }

        // Deliberately a button and not translate-as-you-type: DeepL bills per
        // character, and retyping one sentence would spend it several times.
        Button {
            id: go
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Translate"
            enabled: input.text !== "" && !glossa.busy
            onClicked: page.translateNow()
        }
    }

    // The menus live outside the layout and are shown against their button.
    ContextMenu {
        id: fromMenu
        Repeater {
            model: page.languages
            MenuItem {
                text: modelData.name
                color: FiatGlossaTheme.primaryText
                onClicked: {
                    page.sourceIndex = index
                    page.selectionChanged()
                }
            }
        }
    }

    ContextMenu {
        id: toMenu
        Repeater {
            model: page.targetLanguages
            MenuItem {
                text: modelData.name
                color: FiatGlossaTheme.primaryText
                onClicked: {
                    page.targetIndex = index
                    page.selectionChanged()
                }
            }
        }
    }
}
