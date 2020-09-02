//
//  LineChart+YAxis.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 09. 02..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

extension LineChart {
    struct YAxis: View {
        private typealias AnyForEach = ForEach<[Double], Double, TupleView<(RotatedText, Spacer?)>>
        private typealias RotatedText = ModifiedContent<Text, _RotationEffect>

        let yData: [Double]
        private(set) var yMax: Double
        private(set) var yMin: Double

        init(data: [LineChartData]) {
            let yMaxData = data.map { $0.values.map { $0.y }.max()! } //This is just to make sure, but each dataSet should have the same max.
            let yMinData = data.map { $0.values.map { $0.y }.min()! } //This is just to make sure, but each dataSet should have the same min.
            self.yMax = yMaxData.max()!
            self.yMin = yMinData.min()!
            self.yData = Self.yDataCreate(numberOfValuesShown: 4, yMin: yMin, yMax: yMax)
        }

        let noDecimalsNumberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 0
            return formatter
        }()

        let oneDecimalNumberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            return formatter
        }()

        var body: some View {
            GeometryReader { proxy in
                HStack(spacing: 2) {
                    VStack {
                        AnyForEach(self.yData, id: \.self) { value in
                            let v1 = self.getValueText(for: value)
                            let v2 = ViewBuilder.buildIf(self.yData.last!.isEqual(to: value) ? nil : Spacer())

                            return ViewBuilder.buildBlock(v1, v2)
                        }
                    }
                    .frame(width: 25)
                    .padding(.top, proxy.size.height / CGFloat(self.yMax - self.yMin) * CGFloat(self.yMax - self.yData.max()!))
                    .padding(.bottom, proxy.size.height / CGFloat(self.yMax - self.yMin) * CGFloat(self.yData.min()! - self.yMin))

                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 0.5)
                        .padding(.vertical, 5)

                    Spacer()
                }
            }
        }

        private func getValueText(for value: Double) -> RotatedText {
            let numberFormatter: NumberFormatter
            let numberString: String

            if value.isLessThanOrEqualTo(1000.0) || !value.isLessThanOrEqualTo(15000.0) {
                numberFormatter = self.noDecimalsNumberFormatter
            } else {
                numberFormatter = self.oneDecimalNumberFormatter
            }

            if value.isLessThanOrEqualTo(1000.0) {
                numberString = value.asSmallValueText(formatBy: numberFormatter)
            } else {
                numberString = value.asBigValueText(formatBy: numberFormatter)
            }

            return Text(value.isEqual(to: 0.0) ? "" : numberString)
                .font(.system(size: 11))
                .rotationEffect(.degrees(45)) as! RotatedText

        }

        private static func selectMultiplier(basedOnAmplitude amplitude: Double) -> Double {
            //----This should be minion Kills
            if amplitude.isLessThanOrEqualTo(300.0) {
                return 50
            }

            if amplitude.isLessThanOrEqualTo(1000.0) {
                return 100.0
            }

            //----This should be XP and gold
            if amplitude.isLessThanOrEqualTo(10000.0) {
                return 2000.0
            }

            if amplitude.isLessThanOrEqualTo(25000.0) {
                return 5000.0
            }

            //----This should be damage dealt
            return 10000.0
        }

        private static func yDataCreate(numberOfValuesShown: Int, yMin: Double, yMax: Double) -> [Double] {
            var yData = [Double]()
            let unit = Self.selectMultiplier(basedOnAmplitude: yMax - yMin)

            var i = 0.0
            while i * unit <= yMax {
                yData.insert(i * unit, at: yData.count)
                i += 1
            }

            var j = -1.0
            while j * unit >= yMin {
                yData.insert(j * unit, at: 0)
                j -= 1
            }

            return yData.reversed() //need the highest number first for VStack.
        }
    }
}

private extension Double {
    //Adds no 'k' to signal thousands
    func asSmallValueText(formatBy formatter: NumberFormatter) -> String {
        return "\(formatter.string(from: NSNumber(value: self))!)"
    }

    //Adds 'k' to signal thousands and divides by 1000.
    func asBigValueText(formatBy formatter: NumberFormatter) -> String {
        return "\(formatter.string(from: NSNumber(value: self / 1000.0))!)k"
    }
}
