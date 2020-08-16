//
//  IconSprites.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 13..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

//Specifies that an enumeration type contains information about how to retrieve an icon for each case from an image sprite.
protocol SpriteCuttable {
    var assetArea: CGRect { get }
    var description: String { get }
}

enum IconSprites {
    case teamStat(type: TeamStatType)
    case playerStat(type: PlayerStatType)
    case dragon(type: DragonType)

    private var spriteFileName: String {
        switch self {
            case .teamStat: return "team_stat_icons"
            case .dragon: return "elemental_dragons"
            case .playerStat(let type):
                switch type {
                    case .gold: return "icon_gold"
                    case .minion: return "icon_minions"
                }
        }
    }

    func image() -> Image {
        switch self {
            case .teamStat(let type as SpriteCuttable),
                 .dragon(let type as SpriteCuttable),
                 .playerStat(let type as SpriteCuttable):
                if
                    let cgImage = UIImage(named: self.spriteFileName)?.cgImage,
                    let spriteCutCGImage = cgImage.cropping(to: type.assetArea) {
                    return Image(spriteCutCGImage, scale: 1.0, label: Text("type.description"))
                }

                return Image("")
        }
    }
}
