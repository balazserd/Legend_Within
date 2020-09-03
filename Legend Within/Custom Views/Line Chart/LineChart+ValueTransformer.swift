//
//  LineChart+ValueTransformer.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 09. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension LineChart {
    struct ValueTransformer {
        var xValueTransformer: (Double) -> Double
        var xValueTransformerInverse: (Double) -> Double
        var yValueTransformer: (Double) -> Double
        var yValueTransformerInverse: (Double) -> Double
    }
}
