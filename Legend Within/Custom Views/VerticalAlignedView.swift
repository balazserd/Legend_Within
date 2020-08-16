//
//  VerticalAlignedView.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 15..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import SwiftUI

struct VerticalAlignedView<Content: View>: View {
    var content: Content
    var alignment: VerticalAlignment

    init(_ alignment: VerticalAlignment, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.alignment = alignment
    }

    var body: some View {
        VStack {
            if [.center, .bottom].contains(alignment) {
                Spacer()
            }

            self.content

            if [.center, .top].contains(alignment) {
                Spacer()
            }
        }
    }
}

