//
//  MiddleAlignedText.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import SwiftUI

struct MiddleAlignedView<Content: View>: View {
    var content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack {
            Spacer()
            self.content
            Spacer()
        }
    }
}
