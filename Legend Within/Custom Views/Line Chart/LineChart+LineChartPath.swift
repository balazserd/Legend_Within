//
//  LineChart+LineChartPath.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 09. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

extension LineChart {
    struct LineChartPath: Shape {
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
}
