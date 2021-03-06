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
    static let green3 = Color(90, 196, 146)

    static let darkRed5 = Color(194, 16, 10)

    static let red5 = Color(244, 49, 42)
    static let red3 = Color(247, 105, 100)

    static let lightRed5 = Color(253, 236, 236)
    static let lightRed1 = Color(239, 107, 107)

    static let reallyLightBlue3 = Color(246, 250, 255)
    static let reallyLightBlue1 = Color(227, 239, 254)
    static let lightBlue5 = Color(236, 249, 253)
    static let lightBlue3 = Color(220, 231, 247)

    static let darkBlue2 = Color("darkBlue2")

    static let blue5 = Color("blue5")
    static let blue2 = Color("blue2")

    static let greenishBlue3 = Color(61, 175, 206)
    static let greenishBlue1 = Color(183, 213, 216)

    static let gold = Color("gold")
}
