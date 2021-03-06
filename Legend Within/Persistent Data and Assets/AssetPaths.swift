//
//  AssetPaths.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 03..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

enum AssetPaths {
    case rankedEmblem(tier: LeagueEntry.Tier)
    case positionIcon(tier: LeagueEntry.Tier, position: LeagueEntry.Position)
    case tabIcon(tab: MainWindow.Tab, selected: Bool)

    var path: String {
        switch self {
            case .positionIcon(let tier, let position):
                return "Position_\(tier.normalizedString.capitalized)-\(position.normalizedString.capitalized)"
            case .rankedEmblem(let tier):
                return "Emblem_\(tier.normalizedString.capitalized)"
            case .tabIcon(let tabName, let selected):
                return selected ? "TabIcon_\(tabName.iconName)_Selected" : "TabIcon_\(tabName.iconName)"
        }
    }
}
