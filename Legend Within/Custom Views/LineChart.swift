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
import SpriteKit

struct LineChart: View {
    var lineType: LineType = .curved
    var data: [LineChartData]
    @Binding var visibilityMatrix: [Bool]

    var body: some View {
        ZStack {
            GeometryReader<ForEach<[LineChartData], UUID, SingleLineChart>> { geoProxy in
                let vt = self.getValueTransformer(for: geoProxy)

                return ForEach(self.data.filter { self.visibilityMatrix[$0.associatedParticipantId!] }, id: \.id) { dataSet in
                    SingleLineChart(data: dataSet, proxy: geoProxy, transformer: vt)
                }
            }
        }
    }

    enum LineType {
        case linear
        case curved
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

    struct ValueTransformer {
        var xValueTransformer: (Double) -> Double
        var yValueTransformer: (Double) -> Double
    }
}

fileprivate struct SingleLineChart: View {
    var lineType: LineChart.LineType = .curved
    var data: LineChartData
    var proxy: GeometryProxy
    var transformer: LineChart.ValueTransformer

    var body: some View {
        let transformedData = self.data.copyForTransform(with: self.transformer)

        return ZStack {
            if self.data.shownAspects.contains(.line) {
                LineChartPath(data: transformedData)
                    .stroke(transformedData.lineColor, lineWidth: 3)
                    .offset(x: 4, y: 0)
            }

            if self.data.shownAspects.contains(.points) {
                LineChartPoints(data: transformedData)
                    .offset(x: 0, y: -4)
            }
        }
        .rotation3DEffect(Angle(degrees: 180), axis: (1, 0, 0))
    }
}

fileprivate struct LineChartPoints: View {
    var data: LineChartData

    var body: some View {
        ForEach(0..<data.values.count) { [data] i in
            Circle().fill(data.pointColor)
                .frame(width: 8, height: 8)
                .offset(x: CGFloat(data.values[i].x),
                        y: CGFloat(data.values[i].y))
        }
    }
}


fileprivate struct LineChartPath: Shape {
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
            self.splinedValues.append((CGFloat($0), sequence.sample(atTime: CGFloat($0)) as! CGFloat))
        }
    }
}

class LineChartData : ObservableObject {
    private(set) var id = UUID()
    var values: [Value]
    var lineColor: Color
    var pointColor: Color
    var shownAspects: [ShownAspect]
    var associatedParticipantId: Int?

    init(values: [(Double, Double)],
         lineColor: Color = .black,
         pointColor: Color = .black,
         shownAspects: [ShownAspect] = [.line, .points],
         associatedParticipantId: Int? = nil) {
        self.values = values.map { Value(x: $0.0, y: $0.1)}
        self.lineColor = lineColor
        self.pointColor = pointColor
        self.shownAspects = shownAspects
        self.associatedParticipantId = associatedParticipantId
    }

    func copyForTransform(with transformer: LineChart.ValueTransformer) -> LineChartData {
        let new = LineChartData(values: self.values.map {
                                    (x: transformer.xValueTransformer($0.x),
                                     y: transformer.yValueTransformer($0.y))
                                },
                                lineColor: self.lineColor,
                                pointColor: self.pointColor,
                                shownAspects: self.shownAspects)
        new.id = self.id
        return new
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
