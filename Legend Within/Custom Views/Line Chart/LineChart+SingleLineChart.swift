//
//  LineChart+SingleLineChart.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 09. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI
import SpriteKit

extension LineChart {
    struct SingleLineChart: View {
        var data: LineChartData
        var transformer: LineChart.ValueTransformer
        var lineType: LineChart.LineType

        private var sequence: SKKeyframeSequence
        private var splinedValues = [(CGFloat, CGFloat)]()
        private var transformedData: LineChartData
        private var dragGestureHandler: LineChart.DragGestureHandler
        private var chartAreaPadding: EdgeInsets

        @Binding var gestureXValue: CGFloat
        @Binding var isDragging: Bool

        private let pointSize: CGFloat = 7

        init(data: LineChartData,
             transformer: LineChart.ValueTransformer,
             lineType: LineChart.LineType,
             dragGestureHandler: LineChart.DragGestureHandler,
             chartAreaPadding: EdgeInsets,
             isDragging: Binding<Bool>,
             gestureXValue: Binding<CGFloat>) {
            self.data = data
            self.transformer = transformer
            self.lineType = lineType
            self.dragGestureHandler = dragGestureHandler
            self.chartAreaPadding = chartAreaPadding
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
            let closestXValue = transformedData.values.map { $0.x }.closestValue(to: Double(gestureXValue))
            let closestXIndex = transformedData.values.firstIndex { $0.x == closestXValue }!
            let yValueForClosestX = transformedData.values[closestXIndex].y

            return ZStack(alignment: .topLeading) {
                if self.data.shownAspects.contains(.line) {
                    LineChartPath(self.splinedValues)
                        .stroke(self.data.lineColor, style: StrokeStyle(lineWidth: 2,
                                                                        lineCap: .round))
                }

                if self.data.shownAspects.contains(.points) {
                    LineChartPoints(data: transformedData)
                }

                if isDragging {
                    Circle().fill(Color.white)
                        .frame(width: pointSize, height: pointSize)
                        .overlay(Circle().stroke(self.data.lineColor, lineWidth: 2)
                            .frame(width: pointSize, height: pointSize))
                        .offset(x: CGFloat(closestXValue) - pointSize / 2,
                                y: CGFloat(yValueForClosestX) - pointSize / 2)
                        .zIndex(.infinity)
                }
            }
            .rotation3DEffect(Angle(degrees: 180), axis: (1, 0, 0))
            .padding(chartAreaPadding) //Space for labels
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
}
