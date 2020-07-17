//
//  GlowingView.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 17..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

struct GlowingView<Content : View>: View {
    private let glowRatios: [CGFloat] = [0.63, 0.61, 0.64, 0.63, 0.58, 0.61, 0.55, 0.60, 0.57, 0.63, 0.58, 0.63, 0.62, 0.62, 0.56, 0.65, 0.56, 0.56, 0.60, 0.59, 0.58, 0.62, 0.56, 0.56, 0.60, 0.58, 0.60, 0.61, 0.56, 0.60, 0.62, 0.63, 0.55, 0.64, 0.55, 0.55, 0.63, 0.61, 0.64, 0.63, 0.58, 0.61, 0.55, 0.60, 0.57, 0.63, 0.58, 0.63, 0.62, 0.62, 0.56, 0.65, 0.56, 0.56, 0.60, 0.59, 0.58, 0.62, 0.56, 0.56, 0.60, 0.58, 0.60, 0.61, 0.56, 0.60, 0.62, 0.63, 0.55, 0.64, 0.55, 0.55]

    var content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    @State private var visible: Bool = false

    var body: some View {
        VStack {
            GeometryReader { proxy in
                ZStack {
                    ForEach(0..<self.glowRatios.count) { i in
                        RandomizedTriangle(i: i, proxy: proxy, glowRatio: self.glowRatios[i],
                                           animationTrigger: self.$visible)
                            .shadow(color: Color.orange.opacity(0.2), radius: 3, x: 0, y: -3)
                    }

                    self.content
                }
                .drawingGroup()
            }
            .onAppear { self.visible = true }
        }
    }

    private struct RandomizedTriangle: View {
        let i: Int
        let proxy: GeometryProxy
        let glowRatio: CGFloat
        @Binding var animationTrigger: Bool

        var body: some View {
            let height = proxy.size.height / 2 * glowRatio

            return Triangle()
                .frame(width: CGFloat(15 + (Double(i).remainder(dividingBy: 6.0))),
                       height: height)
                .alignmentGuide(VerticalAlignment.center, computeValue: { d in
                    d[VerticalAlignment.bottom] * (self.animationTrigger ? 1 : 0.8)
                })
                .scaleEffect(animationTrigger ? 1 : 0.8)
                .animation(Animation.linear(duration: 1).repeatForever())
                .rotationEffect(Angle(degrees: animationTrigger ? 360 + 5 * Double(i) : 5 * Double(i)),
                                anchor: .bottom)
                .animation(Animation.linear(duration: 20).repeatForever(autoreverses: false))
        }
    }

    private struct Triangle: View {
        var body: some View {
            GeometryReader { proxy in
                Path { path in
                    path.addLines([
                        CGPoint(x: 0, y: proxy.size.height),
                        CGPoint(x: proxy.size.width / 2, y: 0),
                        CGPoint(x: proxy.size.width, y: proxy.size.height)
                    ])
                }
                .fill(Color.yellow.opacity(0.2))
            }
        }
    }
}

struct GlowingView_Previews: PreviewProvider {
    static var previews: some View {
        GlowingView {
            Circle().fill(Color.blue).frame(width: 80, height: 80)
        }
    }
}
