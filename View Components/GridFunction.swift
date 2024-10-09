//
//  GridFunction.swift
//  WeatherApp
//
//  Created by chandana on 26/08/24.
//

import Foundation
import SwiftUI

func gridView(width: CGFloat, height: CGFloat, rows: Int, columns: Int) -> some View {
    let rowHeight = height / CGFloat(rows)
    let columnWidth = width / CGFloat(columns)
    
    return ZStack(alignment: .center) {
        // Vertical dotted lines
        ForEach(0...columns, id: \.self) { column in
            Path { path in
                let x = CGFloat(column) * columnWidth
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: height))
            }
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
            .foregroundColor(.gridLines)
        }
        
        // Horizontal dotted lines
        ForEach(0...rows, id: \.self) { row in
            Path { path in
                let y = CGFloat(row) * rowHeight
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: width, y: y))
            }
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
            .foregroundColor(.gridLines)
        }
    }
    .frame(width: width, height: height)
        .clipped()
        .mask(
            LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.gridLines.opacity(0.15), location: 0),
                            .init(color: Color.gridLines.opacity(0.2), location: 0.5),
                            .init(color: Color.gridLines.opacity(0.25), location: 1)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                .padding(.horizontal, columnWidth / 10)
        )
}
