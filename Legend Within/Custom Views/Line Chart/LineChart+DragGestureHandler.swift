//
//  LineChart+DragGestureHandler.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 27..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

extension LineChart {
    class DragGestureHandler: ObservableObject {
        var requestedCoordinate = PassthroughSubject<CGPoint?, Never>()
        @Published var valueAtRequest: Double? = nil
    }
}
