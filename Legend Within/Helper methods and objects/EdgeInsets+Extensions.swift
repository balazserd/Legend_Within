//
//  EdgeInsets+Extensions.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 09. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import SwiftUI

extension EdgeInsets {
    func opposite() -> EdgeInsets {
        return EdgeInsets(top: -self.top, leading: -self.leading, bottom: -self.bottom, trailing: -self.trailing)
    }
}
