//
//  DialViewDemo.swift
//  DialViewDemo
//
//  Created by Joseph Granieri on 28/11/2022.
//

import SwiftUI

struct DialViewDemo: View {
    let dials: Binding<[Dial]> = .constant([
        .init(color: .red, value: 0.75),
        .init(color: .orange, value: 0.65),
        .init(color: .yellow, value: 0.55),
        .init(color: .green, value: 0.45),
        .init(color: .blue, value: 0.35),
        .init(color: .indigo, value: 0.25),
    ])
    
    var body: some View {
        Grid {
            ForEach(0..<3) {row in
                GridRow {
                    ForEach(0..<3) {col in
                        let relativeLineWidth = 0.03 + CGFloat(row)/100.0
                        let fontSize = 10.0 + (100.0 * CGFloat(col)/100.0) * 4.0
                        let font = Font.system(size: fontSize, weight: .regular)
                        let labelString = String(format: "Line %.0f%%\n%.0fpt", relativeLineWidth*100.0, fontSize)
                        let color = row+col < dials.wrappedValue.count ? dials.wrappedValue[(row+col)].color : .black
                        DialView(dials: dials,
                                 relativeLineWidth: .constant(relativeLineWidth),
                                 label: .constant(labelString),
                                 font: .constant(font),
                                 color: .constant(color),
                                 animation: .constant(Animation.easeInOut(duration: Double(row))))
                            .gridCellColumns(col+1)
                    }
                }
            }
        }
    }
}

struct DialViewDemo_Previews: PreviewProvider {
    static var previews: some View {
        DialViewDemo()
    }
}