pragma Singleton
import QtQuick 2.6
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

// Fiat colours, the family standard. Two palettes behind one set of names,
// switched by one boolean. The only thing that is Glossa's own is the accent.
QtObject {
    // ---- the switch, remembered between runs ----
    property ConfigurationValue ambientConfig: ConfigurationValue {
        key: "/apps/harbour-fiatglossa/ambient"
        defaultValue: true
    }
    readonly property bool ambient: ambientConfig.value
    function setAmbient(on) { ambientConfig.value = on }

    // Fiat colours are a light scheme, so dark is false there.
    readonly property bool dark: ambient ? (Theme.colorScheme === Theme.LightOnDark) : false

    readonly property string serif: "Georgia"

    readonly property color primaryText:   ambient ? Theme.primaryColor   : "#1A1A1A"
    readonly property color secondaryText: ambient ? Theme.secondaryColor : Qt.rgba(0.10, 0.10, 0.10, 0.55)
    // Verdigris: the green of old ink and manuscript bindings, where glosses
    // were written in the margin.
    readonly property color accent:        ambient ? Theme.highlightColor : "#006E8C"

    readonly property color backgroundHigh: "#F2EFE8"
    readonly property color backgroundLow:  "#D8D2C6"

    readonly property color card: ambient
        ? (dark ? Qt.rgba(0.08, 0.08, 0.08, 1.0) : Qt.rgba(0.96, 0.96, 0.96, 1.0))
        : "#F5F5F5"
    readonly property color surface: card
    readonly property color cardBorder:   Theme.rgba(primaryText, 0.45)
    readonly property color innerBorder:  Theme.rgba(primaryText, 0.22)
    readonly property color recessFill:   Theme.rgba(primaryText, 0.05)
    readonly property color recessBorder: Theme.rgba(primaryText, 0.16)
    readonly property real cardRadius: Theme.paddingLarge * 2
    readonly property int cardBorderWidth: 2

    readonly property color pillFill:         Theme.rgba(primaryText, 0.15)
    readonly property color pillBorder:       Theme.rgba(primaryText, 0.55)
    readonly property color pillFillActive:   Theme.rgba(accent, 0.15)
    readonly property color pillBorderActive: Theme.rgba(accent, 0.45)

    // Meaning, never decoration. Glossa judges one thing: the translation
    // did not happen. Everything else -- busy, translated, local -- is a
    // state and stays in the accent.
    readonly property color wrong: dark ? "#A0403A" : "#8A2B25"

    // ---- the notch ----
    // Asking a QObject for a property it does not have returns undefined
    // rather than throwing, so the probe is safe; the fallback is a real
    // number, not a hope.
    function cutoutHeight() {
        if (typeof Screen === "undefined" || Screen === null) return -1
        var c = Screen.topCutout
        if (c === undefined || c === null) return -1
        if (typeof c === "number") return c
        if (c.height !== undefined) return c.height
        return -1
    }

    readonly property real headerTopInsetFallback: Theme.paddingLarge * 1.5
    readonly property real headerTopInset: {
        var c = cutoutHeight()
        return c >= 0 ? c + Theme.paddingMedium : headerTopInsetFallback
    }

    // Written down, not derived. Tune by eye on the device, once.
    readonly property real statusRowCenter: Theme.itemSizeLarge / 2

    // Silica's own chrome reads Theme.* directly and ignores this singleton.
    // The palette is inherited by children, so setting it on a window or page
    // reaches every control inside it. Assign from JavaScript, never from a
    // binding: a missing property in a binding kills the whole page silently.
    function applyPalette(item) {
        if (item === null || item === undefined) return
        var p = item.palette
        if (p === undefined || p === null) return
        try { p.colorScheme = ambient ? Theme.colorScheme : Theme.DarkOnLight } catch (e) { }
        try { p.primaryColor = primaryText } catch (e) { }
        try { p.secondaryColor = secondaryText } catch (e) { }
        try { p.highlightColor = accent } catch (e) { }
        try { p.secondaryHighlightColor = Theme.rgba(accent, 0.6) } catch (e) { }
        // NOT the accent: this role paints the virtual keyboard's keys.
        try { p.highlightBackgroundColor = Theme.rgba(primaryText, 0.12) } catch (e) { }
        try { p.errorColor = wrong } catch (e) { }
        try { p.highlightDimmerColor = ambient ? Theme.highlightDimmerColor : backgroundLow } catch (e) { }
        try { p.overlayBackgroundColor = ambient ? Theme.overlayBackgroundColor : backgroundHigh } catch (e) { }
    }
}
