//
//  UrlConstants.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 06. 30..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation

enum UrlConstants {
    case profileIcons(iconId: Int)
    case championIcons(iconName: String)
    case itemIcons(itemId: Int)
    case runeIcons(runePath: Int)

    var url: URL? {
        let currentVersion = UserDefaults.standard.string(forKey: Settings.currentDownloadedVersion) ?? "10.16.1"

        switch self {
            case .profileIcons(let iconId):
                return URL(string: "https://ddragon.leagueoflegends.com/cdn/\(currentVersion)/img/profileicon/\(iconId).png")
            case .championIcons(let iconName):
                return URL(string: "https://ddragon.leagueoflegends.com/cdn/\(currentVersion)/img/champion/\(iconName)")
            case .itemIcons(let itemId):
                return URL(string: "https://ddragon.leagueoflegends.com/cdn/\(currentVersion)/img/item/\(itemId).png")
            case .runeIcons(let runePath):
                return URL(string: "https://ddragon.leagueoflegends.com/cdn/\(currentVersion)/img/\(runePath)")
        }
    }
}
