//
//  IconSprites+TeamStatType.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 13..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import UIKit

extension IconSprites {
    enum TeamStatType : SpriteCuttable {
        case turret
        case inhibitor
        case baron
        case dragon
        case herald
        case vilemaw

        var assetArea: CGRect {
            switch self {
                case .turret: return CGRect(x: 0, y: 0, width: 80, height: 80)
                case .inhibitor: return CGRect(x: 0, y: 80, width: 80, height: 80)
                case .baron: return CGRect(x: 0, y: 160, width: 80, height: 80)
                case .dragon: return CGRect(x: 0, y: 240, width: 80, height: 80)
                case .herald: return CGRect(x: 0, y: 320, width: 80, height: 80)
                case .vilemaw: return CGRect(x: 0, y: 400, width: 80, height: 80)
            }
        }

        var description: String {
            switch self {
                case .turret: return "Turrets destroyed"
                case .inhibitor: return "Inhibitors destroyed"
                case .baron: return "Barons killed"
                case .dragon: return "Dragons slain"
                case .herald: return "Rift heralds slain"
                case .vilemaw: return "Vilemaws killed"
            }
        }
    }
}
