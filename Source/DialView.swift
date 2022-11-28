//
//  DialView.swift
//  DialView
//
//  Created by Joseph Granieri on 27/11/2022.
//  Copyright © 2022 Arcade Wizz Kid (Microbee23). All rights reserved.
//

import SwiftUI

struct Dial: Identifiable {
    let id = UUID()
    var color: Color
    var value: Double = 0.0
    var minValue: Double = 0.0
}

struct DialView: View {
    @Binding var dials: [Dial]
    @Binding var relativeLineWidth: CGFloat
    @Binding var label: String
    @Binding var font: Font
    @Binding var color: Color
    @Binding var animation: Animation
    @Binding var animateOnAppear: Bool

    private static let minAnimatedValue = 0.0001
    private static let maxAnimatedValue = 1.0
    
    @State private var animatedValue: CGFloat = DialView.minAnimatedValue
        
    init(dials: Binding<[Dial]> = .constant([]),
         relativeLineWidth: Binding<CGFloat> = .constant(0.06),
         label: Binding<String> = .constant(""),
         font: Binding<Font> = .constant(Font.system(size: 14)),
         color: Binding<Color> = .constant(Color.black),
         animation: Binding<Animation> = .constant(Animation.easeInOut(duration: 2.0)),
         animateOnAppear: Binding<Bool> = .constant(true)
    ) {
        _dials = dials
        _relativeLineWidth = relativeLineWidth
        _label = label
        _font = font
        _color = color
        _animation = animation
        _animateOnAppear = animateOnAppear
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            let containerSize = min(geometry.size.width, geometry.size.height)
            let lineWidth = containerSize * relativeLineWidth
            ZStack {
                ForEach(Array(dials.enumerated()), id: \.offset) { offset, item in
                    let radius = containerSize-(CGFloat(offset) * lineWidth*2) - lineWidth
                    Circle()
                        .trim(from: item.minValue, to: item.value * animatedValue)
                        .stroke(item.color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: radius, height: radius)
                        .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
                }
                Text(label)
                    .font(font)
                    .foregroundColor(color)
                    .multilineTextAlignment(.center)
            }
            .onAppear {
                withAnimation(animateOnAppear ? animation : nil) {
                    animatedValue = DialView.maxAnimatedValue
                }
            }
            .onTapGesture {
                withAnimation(animation) {
                    animatedValue = animatedValue == DialView.maxAnimatedValue ? DialView.minAnimatedValue : DialView.maxAnimatedValue
                }
            }
        }
    }
}

struct DialView_Previews: PreviewProvider {
    static var previews: some View {
        DialViewDemo()
    }
}
