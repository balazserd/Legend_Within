//
//  IconSprites+DragonType.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 13..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import UIKit

extension IconSprites {
    enum DragonType : SpriteCuttable {
        case cloud
        case mountain
        case infernal
        case ocean
        case elder

        var assetArea: CGRect {
            switch self {
                case .cloud: return CGRect(x: 0, y: 0, width: 80, height: 80)
                case .mountain: return CGRect(x: 0, y: 80, width: 80, height: 80)
                case .infernal: return CGRect(x: 0, y: 160, width: 80, height: 80)
                case .ocean: return CGRect(x: 0, y: 240, width: 80, height: 80)
                case .elder: return CGRect(x: 0, y: 320, width: 80, height: 80)
            }
        }

        var description: String {
            switch self {
                case .cloud: return "Cloud drake"
                case .mountain: return "Mountain drake"
                case .infernal: return "Infernal drake"
                case .ocean: return "Ocean drake"
                case .elder: return "Elder drake"
            }
        }
    }
}
