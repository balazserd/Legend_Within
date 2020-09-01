//
//  LineChart+XAxis.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 09. 01..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

extension LineChart {
    struct XAxis: View {
        let xData: [Double]
        private(set) var xMax: Double = 0.0

        //XAxis will always be about minutes of the game.
        init(data: [LineChartData]) {
            let xData = data.map { $0.values.map { $0.x }.max()! } //This is just to make sure, but each dataSet should have the same max.
            self.xMax = xData.max()!
            self.xData = Self.xDataCreate(numberOfValuesShown: 4, xMax: xMax)
        }

        var body: some View {
            GeometryReader { proxy in
                VStack(spacing: 2) {
                    Spacer()

                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 0.5)
                        .padding(.horizontal, 5)

                    HStack {
                        ForEach(0..<self.xData.count) { i in
                            self.getMinuteText(forIndex: i)

                            if i != self.xData.count - 1 {
                                Spacer()
                            }
                        }
                    }
                    .padding(.trailing, proxy.size.width / CGFloat(self.xMax) * CGFloat(self.xMax - self.xData.max()!))
                }
            }
        }

        private func getMinuteText(forIndex i: Int) -> some View {
            Text("\(Int(self.xData[i]))m")
                .font(.system(size: 12))
                .offset(x: i == 0 ? 15 : 0, y: 0)
                .frame(width: 30)
        }

        private static func selectMultiplier(basedOnMaxValue xMax: Double) -> Double {
            if xMax.isLess(than: 40) {
                return 10.0
            }

            if xMax.isLess(than: 75) {
                return 15.0
            }

            return 20.0
        }

        private static func xDataCreate(numberOfValuesShown: Int, xMax: Double) -> [Double] {
            var xData = [Double]()
            let unit = Self.selectMultiplier(basedOnMaxValue: xMax)

            var i = 0.0
            while i * unit <= xMax {
                xData.append(i * unit)
                i += 1
            }

            return xData
        }
    }
}
