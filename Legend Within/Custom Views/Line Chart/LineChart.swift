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
import Combine

struct LineChart: View {
    fileprivate typealias AnyGeometryReader = GeometryReader<ZStack<TupleView<(DragSignal?, AnyForEach)>>>
    fileprivate typealias AnyForEach = ForEach<[LineChartData], UUID, SingleLineChart>
    typealias SumType = MatchDetailsModel.SumType

    var data: [LineChartData]
    @Binding var visibilityMatrix: [Bool]
    var dragGestureHandlers: [DragGestureHandler]
    var lineType: LineType = .curved
    var sumType: SumType

    @State private var gestureXValue: CGFloat = 0
    @State private var isDragging = false

    init(data: [LineChartData],
         visibilityMatrix: Binding<[Bool]>,
         dragGestureHandlers: [DragGestureHandler],
         sumType: SumType,
         lineType: LineType = .curved) {
        self.data = data
        self._visibilityMatrix = visibilityMatrix
        self.dragGestureHandlers = dragGestureHandlers
        self.sumType = sumType
        self.lineType = lineType
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.1))
                .shadow(color: Color.gray.opacity(0.2), radius: 3, x: 0, y: 1.5)

            AnyGeometryReader { geoProxy in
                let vt = self.getValueTransformer(for: geoProxy)
                let visibleLineDataSets = self.data
                    .filter { self.visibilityMatrix[$0.associatedParticipantId!] || self.sumType == .teamBased }
                    .sorted(by: self.sumType == .teamBased
                        ? { _, _ in true }
                        : { $0.associatedParticipantId! < $1.associatedParticipantId! })

                return ZStack(alignment: .leading) {
                    if self.isDragging {
                        DragSignal(gestureXValue: self.$gestureXValue)
                    }

                    AnyForEach(visibleLineDataSets, id: \.id) { dataSet in
                        SingleLineChart(data: dataSet,
                                        transformer: vt,
                                        lineType: self.lineType,
                                        dragGestureHandler: self.dragGestureHandlers[dataSet.associatedParticipantId!],
                                        isDragging: self.$isDragging,
                                        gestureXValue: self.$gestureXValue)
                    }
                }
            }
            .padding(8)
        }
        .gesture(DragGesture()
            .onChanged { value in
                self.isDragging = true
                self.gestureXValue = value.location.x
                self.dragGestureHandlers.forEach { $0.requestedCoordinate.send(value.location) }
            }
            .onEnded { _ in
                self.isDragging = false
                self.dragGestureHandlers.forEach { $0.requestedCoordinate.send(nil) }
            })
    }

    struct DragSignal: View {
        @Binding var gestureXValue: CGFloat

        var body: some View {
            Rectangle().fill(Color.gray)
                .frame(width: 0.5)
                .offset(x: gestureXValue - 8) //The padding offset must be balanced out.
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
        let transformXInverse: (Double) -> (Double) = { convertedXValue in
            (convertedXValue / Double(proxy.size.width - 8)) * (xValueMax - xValueMin)
        }
        let transformY: (Double) -> Double = { yValue in
            (yValue - yValueMin) / (yValueMax - yValueMin) * Double(proxy.size.height - 8)
        }
        let transformYInverse: (Double) -> (Double) = { convertedYValue in
            (convertedYValue / Double(proxy.size.height - 8)) * (yValueMax - yValueMin)
        }

        return ValueTransformer(xValueTransformer: transformX,
                                xValueTransformerInverse: transformXInverse,
                                yValueTransformer: transformY,
                                yValueTransformerInverse: transformYInverse)
    }

    struct ValueTransformer {
        var xValueTransformer: (Double) -> Double
        var xValueTransformerInverse: (Double) -> Double
        var yValueTransformer: (Double) -> Double
        var yValueTransformerInverse: (Double) -> Double
    }
}

fileprivate struct SingleLineChart: View {
    var data: LineChartData
    var transformer: LineChart.ValueTransformer
    var lineType: LineChart.LineType

    private var sequence: SKKeyframeSequence
    private var splinedValues = [(CGFloat, CGFloat)]()
    private var transformedData: LineChartData
    private var dragGestureHandler: LineChart.DragGestureHandler

    @Binding var gestureXValue: CGFloat
    @Binding var isDragging: Bool

    init(data: LineChartData,
         transformer: LineChart.ValueTransformer,
         lineType: LineChart.LineType,
         dragGestureHandler: LineChart.DragGestureHandler,
         isDragging: Binding<Bool>,
         gestureXValue: Binding<CGFloat>) {
        self.data = data
        self.transformer = transformer
        self.lineType = lineType
        self.dragGestureHandler = dragGestureHandler
        self._isDragging = isDragging
        self._gestureXValue = gestureXValue

        self.transformedData = self.data.copyForTransform(with: self.transformer)
        self.sequence = SKKeyframeSequence(keyframeValues: transformedData.values.map { $0.y },
                                           times: transformedData.values.map { NSNumber(value: $0.x) })
        sequence.interpolationMode = .spline

        let xMin = transformedData.values.map { $0.x }.min()!
        let xMax = transformedData.values.map { $0.x }.max()!
        stride(from: xMin, to: xMax, by: (xMax - xMin) / 200).forEach {
            self.splinedValues.append((CGFloat($0), sequence.sample(atTime: CGFloat($0)) as! CGFloat))
        }
    }

    var body: some View {
        let closestXValue = transformedData.values.map { $0.x }.closestValue(to: Double(gestureXValue - 8))
        let closestXIndex = transformedData.values.firstIndex { $0.x == closestXValue }!
        let yValueForClosestX = transformedData.values[closestXIndex].y
        print ("\(closestXValue) - \(closestXValue) - \(yValueForClosestX)")

        return ZStack(alignment: .topLeading) {
            if self.data.shownAspects.contains(.line) {
                LineChartPath(self.splinedValues)
                    .stroke(self.data.lineColor, lineWidth: 3)
                    .offset(x: 4, y: 0)
            }

            if self.data.shownAspects.contains(.points) {
                LineChartPoints(data: transformedData)
                    .offset(x: 0, y: -4)
            }

            if isDragging {
                Circle().fill(Color.white)
                    .frame(width: 7, height: 7)
                    .overlay(Circle().stroke(self.data.lineColor, lineWidth: 2)
                        .frame(width: 7, height: 7))
                    .offset(x: CGFloat(closestXValue),
                            y: CGFloat(yValueForClosestX) - 4)
                    .zIndex(.infinity)
            }
        }
        .rotation3DEffect(Angle(degrees: 180), axis: (1, 0, 0))
        .onReceive(self.dragGestureHandler.requestedCoordinate) { coordinateOfLocation in
            if let coord = coordinateOfLocation {
                let originalX = self.transformer.xValueTransformerInverse(Double(coord.x))
                let closestX = self.data.values.map { $0.x }.closestValue(to: originalX)
                let closestXIndex = self.data.values.firstIndex { $0.x == closestX }!

                self.dragGestureHandler.valueAtRequest = self.data.values[closestXIndex].y
            } else {
                self.dragGestureHandler.valueAtRequest = nil
                return
            }
        }
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
    private var splinedValues = [(CGFloat, CGFloat)]()

    init(_ splinedValues: [(CGFloat, CGFloat)]) {
        self.splinedValues = splinedValues
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: self.splinedValues[0].0, y: self.splinedValues[0].1))

            for splineValue in self.splinedValues.dropFirst() {
                path.addLine(to: CGPoint(x: splineValue.0, y: splineValue.1))
            }
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
