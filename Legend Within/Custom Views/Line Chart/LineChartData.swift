//
//  LineChartData.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 09. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import SwiftUI

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
