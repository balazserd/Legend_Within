//
//  Array+Extensions.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 27..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

extension Array where Element == Double {
    func closestValue(to i: Double) -> Element {
        return self.min(by: { abs($0 - i) < abs($1 - i) })!
    }
}
