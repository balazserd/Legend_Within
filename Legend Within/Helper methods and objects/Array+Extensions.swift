//
//  Array+Extensions.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 27..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import CoreGraphics

extension Array where Element : BinaryFloatingPoint {
    func closestValue(to i: Element) -> Element {
        return self.min(by: { abs($0 - i).isLess(than: abs($1 - i)) })!
    }
}
