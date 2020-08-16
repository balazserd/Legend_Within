//
//  HorizontalAlignedView.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import SwiftUI

struct HorizontalAlignedView<Content: View>: View {
    var content: Content
    var alignment: HorizontalAlignment

    init(_ alignment: HorizontalAlignment = .center, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.alignment = alignment
    }
    
    var body: some View {
        HStack {
            if [.center, .trailing].contains(alignment) {
                Spacer()
            }

            self.content

            if [.center, .leading].contains(alignment) {
                Spacer()
            }
        }
    }
}
