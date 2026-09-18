#include <QtQuick>
#include <sailfishapp.h>

#include "translator.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));

    // Declared before the view so it outlives the QML that binds to it.
    Translator translator;

    QScopedPointer<QQuickView> view(SailfishApp::createView());
    // A context property, not qmlRegisterType: the cover is loaded by URL and
    // cannot see ids from the root QML, so this is how page and cover share
    // one instance.
    view->rootContext()->setContextProperty(QStringLiteral("glossa"), &translator);
    view->setSource(SailfishApp::pathTo(QStringLiteral("qml/harbour-fiatglossa.qml")));
    view->show();

    return app->exec();
}
