#include <QCommandLineParser>
#include <QDebug>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    // Qt 平台参数（-platform eglfs 等）由 QGuiApplication 在构造时解析；
    // eglfs 下建议配合 QT_QPA_PLATFORM=eglfs 与相关 QT_QPA_EGLFS_* 环境变量，
    // 详见 docs/build.md。
    QGuiApplication app(argc, argv);
    QGuiApplication::setApplicationName(QStringLiteral("batana-gui"));
    QGuiApplication::setApplicationVersion(QStringLiteral("0.1.0"));

    QCommandLineParser parser;
    parser.setApplicationDescription(QStringLiteral("batana-pi 嵌入式显示屏 HelloWorld"));
    parser.addHelpOption();
    parser.addVersionOption();
    const QCommandLineOption widthOption(
        QStringLiteral("width"),
        QStringLiteral("窗口宽度（像素，默认 800，对应 batana-pi 竖屏）"),
        QStringLiteral("px"),
        QStringLiteral("800"));
    const QCommandLineOption heightOption(
        QStringLiteral("height"),
        QStringLiteral("窗口高度（像素，默认 1280）"),
        QStringLiteral("px"),
        QStringLiteral("1280"));
    parser.addOption(widthOption);
    parser.addOption(heightOption);
    parser.process(app);

    bool ok = false;
    const int width = parser.value(widthOption).toInt(&ok);
    if (!ok || width <= 0) {
        qWarning() << "无效的 --width，回退到 800";
    }
    const int height = parser.value(heightOption).toInt(&ok);
    if (!ok || height <= 0) {
        qWarning() << "无效的 --height，回退到 1280";
    }

    qInfo() << "QPA 平台:" << QGuiApplication::platformName()
            << "窗口:" << width << "x" << height;

    QQmlApplicationEngine engine;
    engine.setInitialProperties({
        {QStringLiteral("windowWidth"), width > 0 ? width : 800},
        {QStringLiteral("windowHeight"), height > 0 ? height : 1280},
    });
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Batana", "Main");

    return QGuiApplication::exec();
}
