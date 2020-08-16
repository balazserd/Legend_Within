//
//  IconSprites+PlayerStatType.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 13..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import UIKit

extension IconSprites {
    enum PlayerStatType : SpriteCuttable {
        case minion
        case gold

        var assetArea: CGRect {
            switch self {
                case .minion: return CGRect(x: 0, y: 56, width: 52, height: 56)
                case .gold: return CGRect(x: 0, y: 48, width: 56, height: 48)
            }
        }

        var description: String {
            switch self {
                case .gold: return "Gold earned"
                case .minion: return "Minions killed"
            }
        }
    }
}
