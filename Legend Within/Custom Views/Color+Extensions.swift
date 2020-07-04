//
//  Color+Extensions.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 04..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import SwiftUI

extension Color {
    init(_ red: Int, _ green: Int, _ blue: Int) {
        self = Color(red: Double(red) / 255, green: Double(green) / 255, blue: Double(blue) / 255)
    }

    static let darkGreen5 = Color(29, 123, 87)

    static let green5 = Color(31, 193, 136)

    static let darkRed5 = Color(194, 16, 10)

    static let red5 = Color(244, 49, 42)

    static let lightBlue5 = Color(236, 249, 253)
}
