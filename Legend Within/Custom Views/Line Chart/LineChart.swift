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
    typealias SumType = MatchDetailsModel.SumType

    private let chartAreaPadding = EdgeInsets(top: 10, leading: 30, bottom: 20, trailing: 10)

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
            RoundedRectangle(cornerRadius: 6)
                .fill(MatchDetailsPage.ColorPalette.chartAreaBackground)

            GeometryReader { geoProxy in
                self.chartArea(in: geoProxy)
            }
            .padding(5)

            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.01))
                .gesture(DragGesture(coordinateSpace: .local)
                    .onChanged { value in
                        self.isDragging = true
                        self.gestureXValue = value.location.x //Gestures don't want to coordinate...
                        print(self.gestureXValue)
                        self.dragGestureHandlers.forEach { $0.requestedCoordinate.send(value.location) }
                    }
                    .onEnded { _ in
                        self.isDragging = false
                        self.dragGestureHandlers.forEach { $0.requestedCoordinate.send(nil) }
                    })
                .padding(self.chartAreaPadding)
        }
    }

    private func chartArea(in geoProxy: GeometryProxy) -> some View {
        let vt = self.getValueTransformer(for: geoProxy)
        let visibleLineDataSets = self.data
            .filter { self.visibilityMatrix[$0.associatedParticipantId!] || self.sumType == .teamBased }
            .sorted(by: self.sumType == .teamBased
                ? { _, _ in true }
                : { $0.associatedParticipantId! < $1.associatedParticipantId! })

        return ZStack(alignment: .leading) {
            if self.isDragging {
                DragSignal(gestureXValue: self.$gestureXValue)
                    .padding(self.chartAreaPadding)
            }

            ForEach(visibleLineDataSets, id: \.id) { dataSet in
                SingleLineChart(data: dataSet,
                                transformer: vt,
                                lineType: self.lineType,
                                dragGestureHandler: self.dragGestureHandlers[dataSet.associatedParticipantId!],
                                chartAreaPadding: self.chartAreaPadding,
                                isDragging: self.$isDragging,
                                gestureXValue: self.$gestureXValue)
            }

            if visibleLineDataSets.count != 0 {
                XAxis(data: visibleLineDataSets)
                YAxis(data: visibleLineDataSets)
            }
        }
    }

    private func getValueTransformer(for proxy: GeometryProxy) -> ValueTransformer {
        let xValueMax = self.data.map { $0.values.map { $0.x }.max()! }.max()!
        let xValueMin = self.data.map { $0.values.map { $0.x }.min()! }.min()!
        let yValueMax = self.data.map { $0.values.map { $0.y }.max()! }.max()!
        let yValueMin = self.data.map { $0.values.map { $0.y }.min()! }.min()!

        let transformX: (Double) -> Double = { [chartAreaPadding] xValue in
            (xValue - xValueMin) / (xValueMax - xValueMin) * Double(proxy.size.width - (chartAreaPadding.trailing + chartAreaPadding.leading))
        }
        let transformXInverse: (Double) -> (Double) = { [chartAreaPadding] convertedXValue in
            (convertedXValue / Double(proxy.size.width - (chartAreaPadding.trailing + chartAreaPadding.leading))) * (xValueMax - xValueMin)
        }
        let transformY: (Double) -> Double = { [chartAreaPadding] yValue in
            (yValue - yValueMin) / (yValueMax - yValueMin) * Double(proxy.size.height - (chartAreaPadding.bottom + chartAreaPadding.top))
        }
        let transformYInverse: (Double) -> (Double) = { [chartAreaPadding] convertedYValue in
            (convertedYValue / Double(proxy.size.height - (chartAreaPadding.bottom + chartAreaPadding.top))) * (yValueMax - yValueMin)
        }

        return ValueTransformer(xValueTransformer: transformX,
                                xValueTransformerInverse: transformXInverse,
                                yValueTransformer: transformY,
                                yValueTransformerInverse: transformYInverse)
    }
}

//MARK:- LineChart.DragSignal
extension LineChart {
    struct DragSignal: View {
        @Binding var gestureXValue: CGFloat

        var body: some View {
            Rectangle().fill(Color.gray)
                .frame(width: 0.5)
                .offset(x: gestureXValue)
        }
    }
}

//MARK:- LineChart.LineType
extension LineChart {
    enum LineType {
        case linear
        case curved
    }
}
