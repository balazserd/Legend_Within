//
//  Chart.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 18..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import Charts
import SpriteKit

struct LineChart: View {
    var lineType: LineType = .curved
    var data: [LineChartData]

    var body: some View {
        ZStack {
            GeometryReader { proxy in
                self.getPath(in: proxy)

            }
            .offset(x: 4, y: 0)

            GeometryReader { proxy in
                self.getPoints(in: proxy)
            }
            .offset(x: 0, y: -4)
        }
        .rotation3DEffect(Angle(degrees: 180), axis: (1, 0, 0))
    }

    enum LineType {
        case linear
        case curved
    }

    struct ValueTransformer {
        var xValueTransformer: (Double) -> Double
        var yValueTransformer: (Double) -> Double
    }

    private func getPoints(in proxy: GeometryProxy) -> some View {
        let valueTransformer = self.getValueTransformer(for: proxy)
        let transformedValues = self.data
        .map {
            LineChartData(values: $0.values.map {
                              (x: valueTransformer.xValueTransformer($0.x),
                               y: valueTransformer.yValueTransformer($0.y))
                          },
                          lineColor: $0.lineColor, shownAspects: $0.shownAspects)
        }
        .filter { $0.shownAspects.contains(.points) }

        return ZStack {
            ForEach(transformedValues, id: \.id) { transformedData in
                ForEach(0..<transformedData.values.count) { i in
                    Circle().fill(Color.black)
                        .frame(width: 8, height: 8)
                        .offset(x: CGFloat(transformedData.values[i].x),
                                y: CGFloat(transformedData.values[i].y))
                }
            }
        }
    }

    private func getPath(in proxy: GeometryProxy) -> some View {
        let valueTransformer = self.getValueTransformer(for: proxy)
        let transformedValues = self.data
            .map {
                LineChartData(values: $0.values.map {
                                  (x: valueTransformer.xValueTransformer($0.x),
                                   y: valueTransformer.yValueTransformer($0.y))
                              },
                              lineColor: $0.lineColor, shownAspects: $0.shownAspects)
            }
            .filter { $0.shownAspects.contains(.line) }

        return ZStack {
            ForEach(transformedValues, id: \.id) { transformedData in
                LineChartPath(data: transformedData)
                    .stroke(Color.black, lineWidth: 3)
            }
        }
    }

    private func getValueTransformer(for proxy: GeometryProxy) -> ValueTransformer {
        let xValueMax = self.data.map { $0.values.map { $0.x }.max()! }.max()!
        let xValueMin = self.data.map { $0.values.map { $0.x }.min()! }.min()!
        let yValueMax = self.data.map { $0.values.map { $0.y }.max()! }.max()!
        let yValueMin = self.data.map { $0.values.map { $0.y }.min()! }.min()!

        let transformX: (Double) -> Double = { xValue in
            (xValue - xValueMin) / (xValueMax - xValueMin) * Double(proxy.size.width - 8)
        }
        let transformY: (Double) -> Double = { yValue in
            (yValue - yValueMin) / (yValueMax - yValueMin) * Double(proxy.size.height - 8)
        }

        return ValueTransformer(xValueTransformer: transformX, yValueTransformer: transformY)
    }
}

struct LineChartPath: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: self.splinedValues[0].0, y: self.splinedValues[0].1))

            if data.shownAspects.contains(.line) {
                for splineValue in self.splinedValues.dropFirst() {
                    path.addLine(to: CGPoint(x: splineValue.0, y: splineValue.1))
                }
            }
        }
    }

    var sequence: SKKeyframeSequence
    var splinedValues = [(CGFloat, CGFloat)]()
    var data: LineChartData

    init(data: LineChartData) {
        self.data = data
        self.sequence = SKKeyframeSequence(keyframeValues: data.values.map { $0.y },
                                           times: data.values.map { NSNumber(value: $0.x) })
        sequence.interpolationMode = .spline

        let xMin = data.values.map { $0.x }.min()!
        let xMax = data.values.map { $0.x }.max()!
        stride(from: xMin, to: xMax, by: (xMax - xMin) / 200).forEach {
            self.splinedValues.append((CGFloat($0), CGFloat(sequence.sample(atTime: CGFloat($0)) as! Double)))
        }
    }
}

struct LineChartData {
    let id = UUID()
    var values: [Value]
    var lineColor: Color
    var shownAspects: [ShownAspect]

    init(values: [(Double, Double)],
         lineColor: Color = .black,
         shownAspects: [ShownAspect] = [.line, .points]) {
        self.values = values.map { Value(x: $0.0, y: $0.1)}
        self.lineColor = lineColor
        self.shownAspects = shownAspects
    }

    struct Value {
        var x: Double
        var y: Double
    }

    enum ShownAspect {
        case line
        case points
    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        LineChart(data: [LineChartData(values: [(1, 4), (2, 6), (3, 7), (4, 5), (5, 3), (6, -1), (7, -2),
                                                (8, -2.5), (9, -2), (10, 0), (11, 4)],
                                       lineColor: .black,
                                       shownAspects: [.line, .points])])
            .frame(height: 200)
    }
}
