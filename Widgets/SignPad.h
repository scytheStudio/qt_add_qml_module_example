#ifndef SIGNPAD_H
#define SIGNPAD_H

#include <QColor>
#include <QImage>
#include <QQuickPaintedItem>

typedef QList<QPoint> QPointList;

class SignPad : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QColor penColor READ penColor WRITE setPenColor NOTIFY penColorChanged)
    Q_PROPERTY(int penWidth READ penWidth WRITE setPenWidth NOTIFY penWidthChanged)
    Q_PROPERTY(bool showBaseLine READ showBaseLine WRITE setShowBaseLine NOTIFY showBaseLineChanged)
    Q_PROPERTY(bool redrawOnPenChange READ redrawOnPenChange WRITE setRedrawOnPenChange NOTIFY redrawOnPenChangeChanged)
    QML_ELEMENT

public:
    explicit SignPad(QQuickItem *parent = nullptr);

    QColor penColor() const;
    int penWidth() const;
    bool showBaseLine() const;
    bool redrawOnPenChange() const;

public slots:
    void clear(bool clearCached = true);
    void redraw();
    bool saveImage(const QString &fileName, bool addBackground = false, bool saveCutted = true);

    void setPenColor(const QColor &penColor);
    void setPenWidth(int penWidth);
    void setShowBaseLine(bool showBaseLine);
    void setRedrawOnPenChange(bool redrawOnPenChange);

signals:
    void penColorChanged(const QColor &penColor);
    void penWidthChanged(int penWidth);
    void showBaseLineChanged(bool showBaseLine);
    void redrawOnPenChangeChanged(bool redrawOnPenChange);

protected:
    void mousePressEvent(QMouseEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;
    void paint(QPainter *painter) override;

private:
    void drawLineTo(const QPoint &endPoint, bool appendPoint = true);
    void resizeImage(QImage *image, const QSizeF &newSize);
    void addPoint(const QPoint &point);

    /*!
     * \brief cuttedImage can be used to generate actual signature with no background or margins
     */
    QImage cuttedImage() const;

    bool m_isScribbling = false;
    QImage m_image;
    QPoint m_lastPoint;
    QPointList m_points;
    QList<QPointList> m_series;

    QColor m_penColor        = Qt::blue;
    int m_penWidth           = 2;
    bool m_showBaseLine      = false;
    bool m_redrawOnPenChange = true;
};

#endif // SIGNPAD_H
