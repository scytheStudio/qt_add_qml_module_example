#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    engine.addImportPath(":/scythestudio.com/imports");

    engine.load(QUrl(u"qrc:/scythestudio.com/imports/Superapp/main.qml"_qs));

    return app.exec();
}
