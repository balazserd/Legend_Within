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

    var url: URL? {
        switch self {
            case .profileIcons(let iconId):
                return URL(string: "https://ddragon.leagueoflegends.com/cdn/10.13.1/img/profileicon/\(iconId).png")
        }
    }
}
