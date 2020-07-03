//
//  FloatIn.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import SwiftUI

extension CustomViewModifiers {
    struct FloatIn : ViewModifier {
        @Binding var whenTrue: Bool

        func body(content: Content) -> some View {
            content
                .offset(x: 0, y: whenTrue ? 0 : -30)
                .opacity(whenTrue ? 1 : 0)
                .animation(.linear(duration: 0.3))
        }
    }
}
