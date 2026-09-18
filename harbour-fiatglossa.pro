TARGET = harbour-fiatglossa

CONFIG += sailfishapp c++11
QT += network

SOURCES += \
    src/main.cpp \
    src/translator.cpp \
    src/spelling.cpp

HEADERS += \
    src/translator.h \
    src/spelling.h

DISTFILES += \
    qml/harbour-fiatglossa.qml \
    qml/qmldir \
    qml/FiatGlossaTheme.qml \
    qml/components/Background.qml \
    qml/components/PageHead.qml \
    qml/components/Wordmark.qml \
    qml/cover/CoverPage.qml \
    qml/pages/MainTranslationPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/HelpPage.qml \
    qml/pages/AboutPage.qml \
    rpm/harbour-fiatglossa.spec \
    harbour-fiatglossa.desktop \
    README.md

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# Internet access is NOT declared here. It is Permissions=Internet in the
# [X-Sailjail] block of the .desktop file.

# Every one of these fails silently and each looks like a different bug:
# a missing root qml is a white screen, a missing qmldir is "FiatGlossaTheme
# is not a type", a missing .desktop kills the build 200 lines later.
REQUIRED_FILES = \
    $${TARGET}.desktop \
    qml/$${TARGET}.qml \
    qml/qmldir \
    qml/FiatGlossaTheme.qml \
    qml/components/Background.qml \
    qml/components/PageHead.qml \
    qml/components/Wordmark.qml \
    qml/pages/MainTranslationPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/HelpPage.qml \
    qml/pages/AboutPage.qml \
    qml/cover/CoverPage.qml \
    icons/86x86/$${TARGET}.png \
    icons/172x172/$${TARGET}.png

for(f, REQUIRED_FILES) {
    !exists($$PWD/$$f): error("Missing $$f -- expected it at $$PWD/$$f")
}