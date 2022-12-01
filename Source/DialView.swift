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
    var maxValue: Double = 1.0
    var backgroundColor: Color?
}

struct DialView: View {
    @Binding var dials: [Dial]
    @Binding var relativeLineWidth: CGFloat
    @Binding var relativeSpacing: CGFloat
    @Binding var label: String
    @Binding var font: Font
    @Binding var color: Color
    @Binding var animation: Animation
    @Binding var animateOnAppear: Bool
    @Binding var animatedValue: CGFloat

    private static let minAnimatedValue = 0.0001
    private static let maxAnimatedValue = 1.0
    
//    @State private var animatedValue: CGFloat = DialView.minAnimatedValue
        
    init(dials: Binding<[Dial]> = .constant([]),
         relativeLineWidth: Binding<CGFloat> = .constant(0.06),
         relativeSpacing: Binding<CGFloat> = .constant(0.01),
         label: Binding<String> = .constant(""),
         font: Binding<Font> = .constant(Font.system(size: 14)),
         color: Binding<Color> = .constant(Color.primary),
         animation: Binding<Animation> = .constant(Animation.easeInOut(duration: 2.0)),
         animateOnAppear: Binding<Bool> = .constant(true),
         animatedValue: Binding<CGFloat> = .constant(DialView.minAnimatedValue)) {
        _dials = dials
        _relativeLineWidth = relativeLineWidth
        _relativeSpacing = relativeSpacing
        _label = label
        _font = font
        _color = color
        _animation = animation
        _animateOnAppear = animateOnAppear
        _animatedValue = animatedValue
    }
    
    var body: some View {
        GeometryReader { geometry in
            let containerSize = min(geometry.size.width, geometry.size.height)
            let lineWidth = containerSize * relativeLineWidth
            ZStack {
                ForEach(Array(dials.enumerated()), id: \.offset) { offset, item in
                    let lineOffset = (CGFloat(offset) * lineWidth*2)
                    let spacing = CGFloat(offset) * containerSize * relativeSpacing
                    let radius = containerSize - lineOffset - spacing - lineWidth
                    if let backgroundColor = item.backgroundColor {
                        Circle()
                            .trim(from: item.minValue, to: item.maxValue)
                            .stroke(backgroundColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .frame(width: radius, height: radius)
                            .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
                    }
                    Circle()
                        .trim(from: item.minValue, to: item.value * animatedValue)
                        .stroke(item.color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: radius, height: radius)
                        .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
//                        .zIndex(Double(-offset))
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

extension DialView {
    func animateDials(_ animationValue: CGFloat) -> some View {
        self.animatedValue = animationValue
        return self
    }
}

struct DialView_Previews: PreviewProvider {
    static var previews: some View {
        DialView(dials: .constant([.init(color: .red, value: 0.75, maxValue: 0.90, backgroundColor: .red.opacity(0.30)),
                                   .init(color: .green, value: 0.45, maxValue: 0.60, backgroundColor: .green.opacity(0.30)),
                                   .init(color: .blue, value: 0.15, maxValue: 0.50,  backgroundColor: .blue.opacity(0.30))]),
                 label: .constant("Usage\n75%"),
                 font: .constant(Font.largeTitle))
        .shadow(color: .gray.opacity(0.30), radius: 8, x: 8, y: 8)
        .padding(20)
    }
}
