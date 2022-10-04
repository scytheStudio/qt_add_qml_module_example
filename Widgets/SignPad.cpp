#include "SignPad.h"
#include <QImage>
#include <QPainter>

SignPad::SignPad(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    setAcceptedMouseButtons(Qt::LeftButton);
    setAcceptTouchEvents(true);
}

QColor SignPad::penColor() const
{
    return m_penColor;
}

int SignPad::penWidth() const
{
    return m_penWidth;
}

bool SignPad::redrawOnPenChange() const
{
    return m_redrawOnPenChange;
}

bool SignPad::showBaseLine() const
{
    return m_showBaseLine;
}

void SignPad::clear(bool clearCached)
{
    m_image.fill(Qt::transparent);
    update();

    if (clearCached) {
        m_points.clear();
        m_series.clear();
    }
}

void SignPad::redraw()
{
    clear(false);

    if (m_series.count() > 0) {
        for (const auto &serie : m_series) {
            m_lastPoint = serie.first();
            for (int i = 0; i < serie.count(); ++i) {
                drawLineTo(serie[i], false);
            }
        }
    } else {
        qDebug() << "Nothing to draw";
    }
}

bool SignPad::saveImage(const QString &fileName, bool addBackground, bool saveCutted)
{
    QImage baseImage = saveCutted ? cuttedImage() : m_image;

    QImage visibleImage = QImage(baseImage.size(), QImage::Format_ARGB32);

    visibleImage.fill(addBackground ? fillColor() : Qt::transparent);

    QPainter painter(&visibleImage);
    painter.drawImage(QPoint(0, 0), baseImage);
    return visibleImage.save(fileName, "PNG");
}

void SignPad::setPenColor(const QColor &penColor)
{
    if (m_penColor == penColor) {
        return;
    }

    m_penColor = penColor;
    emit penColorChanged(m_penColor);

    if (m_redrawOnPenChange) {
        redraw();
    }
}

void SignPad::setPenWidth(int penWidth)
{
    if (m_penWidth == penWidth) {
        return;
    }

    m_penWidth = penWidth;
    emit penWidthChanged(m_penWidth);

    if (m_redrawOnPenChange) {
        redraw();
    }
}

void SignPad::setShowBaseLine(bool showBaseLine)
{
    if (m_showBaseLine == showBaseLine) {
        return;
    }

    m_showBaseLine = showBaseLine;
    emit showBaseLineChanged(m_showBaseLine);

    update();
}

void SignPad::setRedrawOnPenChange(bool redrawOnPenChange)
{
    if (m_redrawOnPenChange == redrawOnPenChange) {
        return;
    }

    m_redrawOnPenChange = redrawOnPenChange;
    emit redrawOnPenChangeChanged(m_redrawOnPenChange);
}

void SignPad::mousePressEvent(QMouseEvent *event)
{
    m_lastPoint = event->pos();
    addPoint(m_lastPoint);

    m_isScribbling = true;
}

void SignPad::mouseMoveEvent(QMouseEvent *event)
{
    if (m_isScribbling) {
        drawLineTo(event->pos());
    }
}

void SignPad::mouseReleaseEvent(QMouseEvent *event)
{
    if (m_isScribbling) {
        drawLineTo(event->pos());
        m_isScribbling = false;
        m_series << m_points;
        m_points.clear();
    }
}

void SignPad::paint(QPainter *painter)
{
    if (m_image.isNull()) {
        m_image = QImage(width(), height(), QImage::Format_ARGB32);
        m_image.fill(Qt::white);
    } else {
        if (m_image.size() != size()) {
            qDebug() << "need to resize " << m_image.size() << ", item size " << size();
            resizeImage(&m_image, size());
        }
    }

    painter->setRenderHint(QPainter::Antialiasing, true);

    painter->save();
    painter->setPen(Qt::NoPen);
    painter->setBrush(fillColor());
    painter->drawRect(0, 0, width(), height());
    painter->restore();

    if (m_showBaseLine) {
        painter->setPen(QPen(Qt::lightGray, 2, Qt::SolidLine, Qt::SquareCap));
        const auto y = height() * 2 / 3;

        painter->drawLine(QPoint(0, y), QPoint(width(), y));
    }

    painter->drawImage(boundingRect().topLeft(), m_image, boundingRect());
}

void SignPad::drawLineTo(const QPoint &endPoint, bool appendPoint)
{
    QPainter painter(&m_image);

    painter.setPen(QPen(m_penColor, m_penWidth, Qt::SolidLine, Qt::RoundCap,
      Qt::RoundJoin));
    painter.drawLine(m_lastPoint, endPoint);

    if (appendPoint) {
        addPoint(endPoint);
    }

    int rad = (m_penWidth / 2) + 2;
    update(QRect(m_lastPoint, endPoint).normalized()
      .adjusted(-rad, -rad, +rad, +rad));
    m_lastPoint = endPoint;
}

void SignPad::resizeImage(QImage *image, const QSizeF &newSize)
{
    if (image->size() == newSize) {
        return;
    }

    QImage newImage(newSize.toSize(), QImage::Format_ARGB32);
    newImage.fill(Qt::transparent);
    QPainter painter(&newImage);
    painter.drawImage(QPoint(0, 0), *image);
    *image = newImage;
}

void SignPad::addPoint(const QPoint &point)
{
    if (m_points.count() == 0) {
        m_points << point;
    } else if (m_points.last() != point) {
        m_points << point;
    }
}

QImage SignPad::cuttedImage() const
{
    int xMin = std::numeric_limits<int>::max();
    int xMax = std::numeric_limits<int>::min();
    int yMin = std::numeric_limits<int>::max();
    int yMax = std::numeric_limits<int>::min();

    for (const auto &serie : m_series) {
        for (const auto &p : serie) {
            xMin = qMin(xMin, p.x());
            xMax = qMax(xMax, p.x());
            yMin = qMin(yMin, p.y());
            yMax = qMax(yMax, p.y());
        }
    }

    const int width  = xMax - xMin;
    const int height = yMax - yMin;

    return m_image.copy(xMin, yMin, width, height);
}
