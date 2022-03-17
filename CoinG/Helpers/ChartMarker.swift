//
//  ChartMarker.swift
//  CoinG
//
//  Created by Gleb Lanin on 14/03/2022.
//

import Foundation
import Charts

class ChartMarker: MarkerView {
    private var text = String()

    private let drawAttributes: [NSAttributedString.Key: Any] = [
        .font: Fonts.num,
        .foregroundColor: UIColor.lightGray,
        .backgroundColor: Colors.main
    ]

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        text = String(format: "%.3f", entry.y)
    }

    override func draw(context: CGContext, point: CGPoint) {
        super.draw(context: context, point: point)

        let sizeForDrawing = text.size(withAttributes: drawAttributes)
        bounds.size = sizeForDrawing
        offset = CGPoint(x: -sizeForDrawing.width / 2, y: -sizeForDrawing.height - 4)

        let offset = offsetForDrawing(atPoint: point)
        let originPoint = CGPoint(x: point.x + offset.x, y: point.y + offset.y)
        let rectForText = CGRect(origin: originPoint, size: sizeForDrawing)
        drawText(text: text, rect: rectForText, withAttributes: drawAttributes)
    }

    private func drawText(text: String, rect: CGRect, withAttributes attributes: [NSAttributedString.Key: Any]? = nil) {
        let size = bounds.size
        let centeredRect = CGRect(
            x: rect.origin.x + (rect.size.width - size.width) / 2,
            y: rect.origin.y + (rect.size.height - size.height) / 2,
            width: size.width,
            height: size.height
        )
        text.draw(in: centeredRect, withAttributes: attributes)
    }
}
