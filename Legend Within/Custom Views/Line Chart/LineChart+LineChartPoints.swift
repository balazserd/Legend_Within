//
//  LineChart+LineChartPoints.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 09. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

extension LineChart {
    struct LineChartPoints: View {
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
}
